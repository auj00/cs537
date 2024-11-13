// test.c
#include "types.h"
#include "stat.h"
#include "user.h"
#include "wmap.h"

int main(void) 
{

  struct wmapinfo wminfo;
  printf(1, "The process ID is: %d\n", test());

  // printf(1, "The process ID is: %d\n", wunmap(0x6000_0000));
  printf(1, "The physical address is: %x\n", va2pa(0x60000123));


  printf(1, "The process ID is: %d\n", getwmapinfo(&wminfo));

  uint address = wmap(0x60000000, 8192, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);
  printf(1, "The address returned by wmap: %x\n", address);

  printf(1, "The physical address is: %x\n", va2pa(0x60000123));


  printf(1, "Return value wunmap is: %d\n", wunmap(0x60000000));
  exit();
}
