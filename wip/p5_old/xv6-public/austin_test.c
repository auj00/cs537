#include "types.h"
#include "stat.h"
#include "user.h"
#include "wmap.h"
int main(void)
{
	wmap(0x60002000, 4008, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);
	//int getparentname(char* parentbuf,char* childbuf, int parentbufsize, int childbufsize);
	printf(1,"Physical address in page table: %d\n",va2pa(0x60002000));
	struct wmapinfo *ptr = malloc(sizeof(struct wmapinfo));
if (ptr == 0) {
    // Handle memory allocation failure
    printf(1,"malloc failed");
    return -1; // or an appropriate error code
}

int rc2 = getwmapinfo(ptr);
	if(rc2!=0) printf(1,"error\n");
		for(int i=0; i<16; i++)
  {
    if(ptr->n_loaded_pages[i] != 0)
    {
      // ptr->addr[index] = myproc()->start_addr[i];
      // ptr->length[index] = myproc()->map_length[i];
      // ptr->n_loaded_pages[index] = myproc()->pages_in_map[i];

		printf(1,"%d %d %d %d\n",ptr->addr[i],ptr->length[i],ptr->n_loaded_pages[i],ptr->total_mmaps);
    }
  }
	int rc = wunmap(0x60000000);
	if (rc == 0) {printf(1,"FREED! checking if physical page removed from pgtable....\n");
	printf(1,"%d",va2pa(0x60000000));
	// if(va2pa(0x60000000) == -1) printf(1,"success!\n");
	// else printf(1,"FAIL\n");
	}

	int ret = va2pa(0x0);
    if (ret == FAILED) {
        printf(1,"va2pa(0x%x)` failed\n", 0);
    }
	exit();
}