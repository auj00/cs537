// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "proc.h"
#include "x86.h"

unsigned char pg_ref_cnt[1024*1024]={0};

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if(kmem.use_lock)
  {
    int index = V2P(v)/PGSIZE;
    pg_ref_cnt [index]--;
    if(pg_ref_cnt [index] > 0)
    {
      // cprintf("ref count greater than 0\n");
      return;
    }
  }

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;

  // increment the reference count of the pages
  char * mem = (char*)r;
  int index = V2P(mem)/PGSIZE;
  pg_ref_cnt [index] += 1;

  if(r)
    kmem.freelist = r->next;
  if(kmem.use_lock)
    release(&kmem.lock);

  // p5
  // // increment the reference count of the pages
  // char * mem = (char*)r;
  // int index = V2P(mem)/PGSIZE;
  // pg_ref_cnt [index] += 1;
  // cprintf("ref count for %x is %d in kalloc\n", index, pg_ref_cnt [index]);

  return (char*)r;
}

void duplicate_page(pte_t *pte, struct proc *child, int alloc_va)
{
  // determine the flags & pa
      // pde_t *d;
      if(kmem.use_lock)
        acquire(&kmem.lock);

      uint pa, flags; 
      flags = PTE_FLAGS(*pte);
      pa = PTE_ADDR(*pte);

      // cprintf("%d process are accessing this page\n", pg_ref_cnt[pa/PGSIZE]);

      // decrement the page reference count 
      pg_ref_cnt[pa/PGSIZE]--;

      // single reference remaining to the page
      if(pg_ref_cnt[pa/PGSIZE] == 1)
      {
        // make the page READ/WRITE
        //cprintf("Less than 2 references\n");
        pte_t *pte_parent;
        pte_parent = walkpgdir(child->parent->pgdir, (void *)alloc_va, 0);
        *pte_parent |=  PTE_W;
        lcr3(V2P(child->parent->pgdir));
        // break; 
      }

      // make the new page writable
      flags = flags | PTE_W;

      // clear out the pte of the child
      *pte = 0;

      // allocate new page
      kmem.use_lock = 0;
      char *mem = kalloc();
      
      memmove(mem, (char*)P2V(pa), PGSIZE);
      mappages(child->pgdir, (void*)alloc_va, PGSIZE, V2P(mem), flags);
      // kmem.use_lock = 1;
      // pg_ref_cnt[pa/PGSIZE]--;
      // cprintf("reference count of page %x to %d in trap\n", pa/PGSIZE, pg_ref_cnt[pa/PGSIZE]);
    
      lcr3(V2P(child->pgdir));
      kmem.use_lock = 1;
      if(kmem.use_lock)
        release(&kmem.lock);
}

// incrementer function for ref_cnt of each physical page
int ref_cnt_incrementer(uint pa)
{
  // if(pa > KERNBASE)
  // {
  //   return -1;
  // }
  if(kmem.use_lock)
        acquire(&kmem.lock);

  pg_ref_cnt[pa/PGSIZE]++;

  if(kmem.use_lock)
        release(&kmem.lock);
  // cprintf("incremented page ref cnt %d to %d\n", pa, pg_ref_cnt[pa]);
  return 0;
}
