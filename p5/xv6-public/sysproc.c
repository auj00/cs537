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
  

  // check if the address is within 0x60000000 and 0x80000000 
  if(!(start_va >= 0x60000000 && start_va < 0x80000000))
  {
    return -2;
  }

  

  // copy of the starting address that the user asked
  int copy_va = start_va; 


  // check for flags val
  // the value will be a 4-bit number e.g. 1110

  // check for MAP_SHARED 0x0002
  if(!(flags_val & MAP_SHARED))
  {
    // MAP_SHARED not set
    return -3;
  }

  // check for MAP_FIXED 0x0004
  if(!(flags_val & MAP_FIXED))
  {
    // MAP_FIXED not set
    return -4;
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
    cprintf("%d\n", start_va);

    // // create PTE mapping VPN -> PPN
    if (mappages(myproc()->pgdir, (char*)start_va, 4096, V2P(mem), PTE_W | PTE_U) == -1)
    {
      return -1;
    }

    // if (alloc_page(myproc(), &start_va) == -1) 
    // {
    //   return -5;
    // }

    // starting address of the next virtual page
    start_va += 0x1000;
    
    
  }

  cprintf("debug\n");

  // return the starting va of the newly created mapping
  return copy_va;
}

int sys_test(void)
{
  return myproc()->pid;
}
