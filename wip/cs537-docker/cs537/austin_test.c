#include "types.h"
#include "stat.h"
#include "user.h"
#include "wmap.h"
int main(void)
{
	int address = wmap(0x60000000, 8192, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);
	//int getparentname(char* parentbuf,char* childbuf, int parentbufsize, int childbufsize);
	printf(1,"something....%d\n", address);
	int rc = wunmap(0x60000000);
	printf(1,"%d",rc);
	// if (rc == 0) printf(1,"FREED!");
	exit();
}