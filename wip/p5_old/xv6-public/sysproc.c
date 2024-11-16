#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "wmap.h"

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
// p5 - austin
//uint wmap(uint addr, int length, int flags, int fd);
int
sys_wmap(void){
  
  /*virtual address*/
  int addr;
  /*length of mapping in bytes*/
  int length;
  /*as defined in wmap.h*/
  int flags;
  /*kind of memory mapping you are requesting for*/
  int fd;

  /*fetch from userspace and check for redundancy*/
  if(argint(0, &addr)<0 || argint(1, &length)<0 || argint(2, &flags)<0 || argint(3, &fd)<0) return FAILED;
  cprintf("addrees %x\n",addr);
  // MAP_SHARED should always be set. If it's not, return error.
  if(MAP_SHARED != (flags & MAP_SHARED)) return FAILED;
  // //In this project, you only implement the case with MAP_FIXED . Return error if this flag is not set. 
  if(MAP_FIXED != (flags & MAP_FIXED)) return FAILED;
  // Also, a valid addr (+ no of pages ) will be a multiple of page size and within 0x60000000 and 0x80000000 
  if(addr > 0x80000000 || addr < 0x60000000) return FAILED;
  if(addr % PAGESIZE != 0) return FAILED;
  // check if the page is already allocated then return 

  /*get the number of pages*/
  int n = NPAGE(length);
  if(length%PAGESIZE != 0) n++;

  uint v_addr_tmp = addr;
  uint v_addr_tmp_last = addr + (n*PAGESIZE);
  /*check if the total address' requirement is within the addr range*/
  if(v_addr_tmp_last >= 0x80000000) return FAILED;

  /*get the current process*/
  struct proc *curproc = myproc();

  /*check if the page has already been allocated for the same process*/
  for (int i = 0; i < 16; i++)
  if(curproc->map_md.num_pages[i] != 0)
    if(v_addr_tmp  > curproc->map_md.va_addr_begin[i] && v_addr_tmp_last < curproc->map_md.va_addr_end[i]) 
      return FAILED;


  /*loop around to allocate physical pages and store the mapping in the process' page table*/
  char* phy_addr_tmp;
  for (int i = 0; i < n; i++)
  {
    /*
    allocate free physical page
    kalloc only works with/returns kernel virtual address
    */
    phy_addr_tmp = kalloc();
    cprintf("Physical address: %d\n",V2P(phy_addr_tmp));
    /*map the physical page address(kernel virtual address, actually) to the page table*/
    if(mappages(curproc->pgdir, (char *)v_addr_tmp, PAGESIZE, V2P(phy_addr_tmp), PTE_W | PTE_U) != 0) return FAILED;
    // mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

    v_addr_tmp += PAGESIZE;
  }
  /*
  TODO:
  if(MAP_ANONYMOUS == (flags & MAP_ANONYMOUS)){
    //ignore fd
  }
  */

  /*****************************************
   populate the current mapping in the process'
   mapped table:
   *****************************************/
  /*get an empty index*/
  int idx = 0;
  for (int i = 0; i < 16; i++)
    if(curproc->map_md.num_pages[i] == 0){
      idx = i;
      break;
    }
  curproc->map_md.num_pages[idx] = length;
  curproc->map_md.va_addr_begin[idx] = addr;
  curproc->map_md.va_addr_end[idx] = v_addr_tmp_last;
  /*increment number of mmaps*/
  curproc->map_md.num_mmap[idx]++;
  cprintf("%d\n",idx);
  cprintf("%d %d %d %d\n",curproc->map_md.va_addr_begin[idx],v_addr_tmp_last,n,1);
  /*****************************************/

  return addr;
}

int 
sys_wunmap(void){
  /*int wunmap(uint addr);*/
  /*get the address from user space*/
  uint va_addr;
  if(argint(0, (int *)&va_addr)<0) return FAILED;
  // if(va_addr > 0x80000000 || va_addr < 0x60000000) return FAILED;
  // if((uint) va_addr % PGSIZE != 0) return FAILED;
  /*****************************************
   Every process can call wunmap 16 times,
   search through the proc's struct to get the
   details of the va passed.
   ASSUME:
   The va passed will be the begin index.
   *****************************************/
  struct proc * currproc = myproc();
  /*get the length of the allocated physical size*/
  int n = 0;
  for (int i = 0; i < 16; i++)
  {
    if(currproc->map_md.va_addr_begin[i] == va_addr){
      n = currproc->map_md.num_pages[i];
      /*clear the num of pages for this mem_index*/
      currproc->map_md.num_pages[i] = 0;
      /*decrement number of mmaps*/
      currproc->map_md.num_mmap[i]--;
      break;
    }
  }
  
  /*free the index's contents*/
  for (int i = 0; i < n; i++)
  {
    /*get the pte for the given virtual address*/
    pte_t *pte = walkpgdir(currproc->pgdir, (void *)va_addr, 0);
    /*don't need the last 12 bits for the PPN*/
    int physical_address = PTE_ADDR(*pte);

    if(pte == 0 || physical_address == 0) return -1;

    /*kfree can only work with kernel virtual address'
    so convert using P2V
    */
    kfree(P2V(physical_address));

    /* future reference to that virtual address to fail*/
    *pte = 0;

    va_addr+=PAGESIZE;
  }

	return SUCCESS;
}

int 
sys_va2pa(void){
  // uint va2pa(uint va);
  int va_addr;
  if(argint(0,&va_addr) < 0) return FAILED;
  // if(va_addr > 0x80000000 || va_addr < 0x60000000) return FAILED; 
  // if(va_addr % PGSIZE != 0) return FAILED;
  struct proc * currproc = myproc();
  pte_t *pte = walkpgdir(currproc->pgdir, (char *)va_addr, 0);

  if((*pte & PTE_P) == 0) return FAILED;

  int ppn = PTE_ADDR(*pte);

  int offset = va_addr & 0xFFF;
  
  int pa = ppn | offset;

  return pa;
}

int
sys_getwmapinfo(void){
 
  struct wmapinfo *ptr;
  if(argptr(0, (void*)&ptr, sizeof(*ptr)) < 0)
  {
    return FAILED;
  }

  if(ptr == 0) return FAILED;

  int index = 0;
  for(int i=0; i<16; i++)
  {
    if(myproc()->map_md.num_pages[i] != 0)
    {
      // ptr->addr[index] = myproc()->start_addr[i];
      // ptr->length[index] = myproc()->map_length[i];
      // ptr->n_loaded_pages[index] = myproc()->pages_in_map[i];

      ptr->addr[index] = myproc()->map_md.va_addr_begin[i];
      ptr->length[index] = myproc()->map_md.num_pages[i];
      ptr->n_loaded_pages[index] = myproc()->map_md.num_mmap[i];
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
  index--;
  cprintf("%x %d %d %d\n",ptr->addr[index],ptr->length[index],ptr->n_loaded_pages[index],ptr->total_mmaps);
  return 0;
}