#include "types.h"
#include "stat.h"
#include "user.h"
#include "wmap.h"
int main(void)
{
	wmap(0x60000000, 8192, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);
	//int getparentname(char* parentbuf,char* childbuf, int parentbufsize, int childbufsize);
	printf(1,"Physical address in page table: %x\n",va2pa(0x60000000));
	int rc = wunmap(0x60000000);
	if (rc == 0) {printf(1,"FREED! checking if physical page removed from pgtable....\n");
	printf(1,"%d",va2pa(0x60000000));
	if(va2pa(0x60000000) == -1) printf(1,"success!\n");
	else printf(1,"FAIL\n");
	}
	exit();
}