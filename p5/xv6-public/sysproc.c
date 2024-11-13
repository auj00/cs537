#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "wmap.h"         // p5

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


// -------------------- p5 --------------------

// to request physical memory pages 
int sys_wmap(void)
{
  // code here
  int start_va;         // starting virtual address requested by the user
  int mem_length;       // size of memory requested by user 
  int flags_val;        // MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS
  int k_fd;             // file descriptor 

  // Check if these arguments are present & within allocated address
  // space
  if(argint(0, &start_va)<0 || argint(1, &mem_length)<0 || argint(2, &flags_val)<0 || argint(3, &k_fd)<0)
  {
    return -1;
  }

  // check if provided virtual address is a multiple of page size
  if(start_va%PGSIZE != 0)
  {
    return FAILED;
  }
  

  // check if the address is within 0x60000000 and 0x80000000 
  if(!(start_va >= 0x60000000 && start_va < 0x80000000))
  {
    return -1;
  }


  // check whether this page is already allocated
  // for (size_t i = 0; i < count; i++)
  // {
  //   /* code */
  // }
  

  // check if the full space asked by the user is unallocated & within the 
  

  // copy of the starting address that the user asked
  int copy_va = start_va; 


  // check for flags val
  // the value will be a 4-bit number e.g. 1110

  // check for MAP_SHARED 0x0002
  if(!(flags_val & MAP_SHARED))
  {
    // MAP_SHARED not set
    return -1;
  }

  // check for MAP_FIXED 0x0004
  if(!(flags_val & MAP_FIXED))
  {
    // MAP_FIXED not set
    return -1;
  }

  // // check for MAP_ANONYMOUS 0x0004
  // if((flags_val & MAP_ANONYMOUS))
  // {
  //   // MAP_ANONYMOUS set -> Not a file-backed mapping
    
  // }
  // else
  // {
  //   // file-backed mapping
  // }


  


  // single page size = 4096 bytes
  // assign multiple pages if requested memory size > 4096
  // loop to allocate multiple physical pages, if needed
  int page_size = 4096;
  int num_pages = mem_length/page_size;

  // if requested memory is not a multiple of page size
  if(mem_length%page_size != 0)
  {
    num_pages += 1;
  }
  
  for(int i=0; i<num_pages; i++)
  {
    // remove the static from mappages()
    // // allocate pages
    char *mem = kalloc();
    cprintf("physical address of wmap%x\n", V2P(mem));

    // // create PTE mapping VPN -> PPN
    if (mappages(myproc()->pgdir, (char*)copy_va, 4096, V2P(mem), PTE_W | PTE_U) == -1)
    {
      return -1;
    }

    // if (alloc_page(myproc(), &start_va) == -1) 
    // {
    //   return -5;
    // }

    // starting address of the next virtual page
    copy_va += 0x1000;
    
    
  }

  // update memory mapping meta-data
  myproc()->num_maps += 1;
  //int index = -1;
  for(int i=0; i<16; i++)
  {
    // find the 1st empty slot
    if(myproc()->start_addr[i] == -1)
    {
      myproc()->start_addr[i] = start_va;
      myproc()->map_length[i] = mem_length;
      myproc()->pages_in_map[i] = num_pages;
      myproc()->file_desc[i] = k_fd;
      break;
    }
  }

  cprintf("debug\n");

  // return the starting va of the newly created mapping
  return start_va;
}



int sys_wunmap(void)
{
  int start_va;
  if(argint(0, &start_va)<0)
  {
    return -1;
  }

  int copy_va = start_va;

  // find if a memory map for start_va exists
  int map_index = -1;
  for(int i=0; i<16; i++)
  {
    if(myproc()->start_addr[i] == start_va)
    {
      map_index = i;
      break;
    }
  }

  // no such memory map exists
  if(map_index == -1)
  {
    return -1;
  }

  // Handle file-backed mapping


  // reset the metadata
  myproc()->start_addr[map_index] = -1;
  myproc()->map_length[map_index] = -1;
  // myproc()->pages_in_map[map_index] = -1;
  myproc()->file_desc[map_index] = -1;

  // free each page in the map
  for(int i=0; i<myproc()->pages_in_map[map_index]; i++)
  {
    pte_t *pte = walkpgdir(myproc()->pgdir, (char*)copy_va, 0);   // get the page-table entry
    int physical_address = PTE_ADDR(*pte);                        // Access the upper 20-bit of PTE
    kfree(P2V(physical_address));                                 // free the physical memory
    *pte = 0;                                                     // convert to kernel va, free the PTE
    copy_va += 0x1000;                                            // Increment va to next va

  }

  myproc()->pages_in_map[map_index] = -1;
  myproc()->num_maps -= 1;

  return 0;
}


/*
To translate a virtual address to physical address 
according to the page table for the calling process.
*/
int sys_va2pa(void)
{
  // 
  int va_input;
  if(argint(0, &va_input)<0)
  {
    return -1;
  }

  // page-table entry for the given virtual address
  pte_t *pte = walkpgdir(myproc()->pgdir, (char*)va_input, 0);

  cprintf("pte=%x\n", *pte);
  // check if PTE is present
  if((*pte & PTE_P) == 0)
  {
    return FAILED;
  }

  int ppn = PTE_ADDR(*pte);

  int offset = va_input & 0xFFF;
  
  int pa = ppn | offset;

  cprintf("ppn=%x\noffset=%x\npa=%x\n", ppn, offset, pa);
  return pa;
}

int sys_getwmapinfo(void)
{
  // pointer for the struct argument
  struct wmapinfo *ptr;

  // check if argument are present & within allocated 
  // address space
  if(argptr(0, (void*)&ptr, sizeof(*ptr)) < 0)
  {
    return -1;
  }

  // Null pointer handled
  if(ptr==0)
  {
    return -1;
  }

  int index = 0;
  for(int i=0; i<16; i++)
  {
    if(myproc()->start_addr[i] != -1)
    {
      ptr->addr[index] = myproc()->start_addr[i];
      ptr->length[index] = myproc()->map_length[i];
      ptr->n_loaded_pages[index] = myproc()->pages_in_map[i];
      index++;
    }
    else
    {
      ptr->addr[index] = 0;
      ptr->length[index] = 0;
      ptr->n_loaded_pages[index] = 0;
    }
  }
  ptr->total_mmaps = index;
  return 0;
}


int sys_test(void)
{
  return myproc()->pid;
}
