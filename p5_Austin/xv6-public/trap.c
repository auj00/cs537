#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
/*redefining the file struct for all access*/
struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  case T_PGFLT: // T_PGFLT = 14

    // cprintf("Page Fault\n");

    // address that caused the page fault
    int pgflt_va = rcr2();

    /*Invalid page accessed rcr2 returned error*/
    if(pgflt_va == -1) {
      cprintf("gotcha 2\n");
      exit();
    }

    // check if pgflt_va is present within any allocated map

    // location of wmap in proc struct
    // cprintf("faulty address: %x\n", pgflt_va);
    int map_index = -1;                   
    for(int i=0; i<16; i++)
    {
      
      if(pgflt_va >= myproc()->mapinfo[i].start_addr && pgflt_va <= myproc()->mapinfo[i].end_addr)
      {
        // cprintf("faulty address: %d\n", pgflt_va);
        // cprintf("start address: %x end address: %x\n", myproc()->mapinfo[i].start_addr,myproc()->mapinfo[i].end_addr);
        map_index = i;
        break;
      }
    }
    // cprintf("index : %d\n", map_index);

    if(map_index == -1)
    {
      cprintf("Segmentation Fault\n");
      // kill the process
      // should i call kill() or exit()
      // kill(myproc()->pid);
      // myproc()->killed = 1;
      exit();
    }


    // -------- handle lazy allocation --------


    // calculate : which page of the map to allocate
    // int offset = pgflt_va - myproc()->mapinfo[map_index].start_addr;

    // starting address of the page to be allocated
    int alloc_va = PGROUNDDOWN(pgflt_va);
    
    // allocate single page
    char *mem = kalloc();

    // set up all bytes as 0 on first allocation
    memset(mem, 0, PGSIZE);

    // cprintf("physical address of allocated page %d : %x\n", i, V2P(mem));
    // create PTE -> store PPN & flags
    if (mappages(myproc()->pgdir, (char*)alloc_va, 4096, V2P(mem), PTE_W | PTE_U) == -1)
    {
      cprintf("mappages() failed\n");
      // kill the process
    }

    int fd = myproc()->mapinfo[map_index].file_desc;

    if(fd != -1)
    {
      // MAP_ANONYMOUS not set -> file-backed mapping
      struct file *f;
      if((f = myproc()->ofile[fd]) == 0)
      {
        cprintf("NULL pointer to the file structure, has the file with ofile[fd] been opened (sys_open)yet \nOR\n has it been closed?\n");
        // kill the process
      }

      /*get the correct offset to access the correct page*/
      f->off = alloc_va -  myproc()->mapinfo[map_index].start_addr;
      fileread(f, (char*)alloc_va, 4096);
      
    }
    myproc()->mapinfo[map_index].pages_in_map += 1;
    
    // else:
    break;  
        


  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
