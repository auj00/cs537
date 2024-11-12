// test.c
#include "types.h"
#include "stat.h"
#include "user.h"
#include "wmap.h"

int main(void) 
{
  printf(1, "The process ID is: %d\n", test());

  uint address = wmap(0x60000000, 8192, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);
  printf(1, "The address returned by wmap: %d\n", address);
  exit();
}
