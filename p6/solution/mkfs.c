#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>
#include "wfs.h"

// function to get mmap array pointer
void create_mmap_pointers(char **disk_name, int disk_num, char **disk_ptr, int disk_size)
{
    // printf("test 1 \n");
    // open files & create mmap pointers
    for (int i = 0; i < disk_num; i++)
    {
        // printf("does he know\n");
        int fd = open(disk_name[i], O_RDWR, 0777);
        disk_ptr[i] = mmap(NULL, disk_size , PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    }
}

int main(int argc, char *argv[])
{

    // ################## parse the command line arguments ##################

    // command line arguments should be odd
    // each command line argument is accompanied by a flag
    if (argc % 2 == 0)
    { // confirm once
        return -1;
    }

    int raid_mode = -1;
    int cnt_data_blocks = 0;
    int cnt_inodes = 0;
    int cnt_disks = 0;
    char *disk_name[10] = {NULL};
    char *mmap_pointers[10] = {NULL};

    uid_t process_uid = getuid();
    gid_t process_gid = getgid();

    // loop to iterate over all the command line args
    for (int i = 0; i < argc; i++)
    {
        // ----------- RAID MODE -------------
        if (strcmp(argv[i], "-r") == 0)
        {
            // printf("-r found\n");
            if (strcmp(argv[i + 1], "0") == 0)
            {
                raid_mode = 0;
                // printf("%d\n", raid_mode);
            }
            else if (strcmp(argv[i + 1], "1") == 0)
            {
                raid_mode = 1;
            }
            else if (strcmp(argv[i + 1], "1v") == 0)
            {
                raid_mode = 2;
            }
            else
            {
                printf("Error : Unknown raid mode specified\n");
                return 1;
            }
        }

        // ---------------- count & store disk names ----------------
        if (strcmp(argv[i], "-d") == 0)
        {
            disk_name[cnt_disks] = argv[i + 1];
            cnt_disks++;
        }

        // ---------------- count & store inodes ----------------
        if (strcmp(argv[i], "-i") == 0)
        {
            cnt_inodes = atoi(argv[i + 1]);
        }

        // ---------------- count & store data blocks ----------------
        if (strcmp(argv[i], "-b") == 0)
        {
            cnt_data_blocks = atoi(argv[i + 1]);
        }
    }

    // ############### validate command line arguments ###############

    if(cnt_disks <2)
        return 1;

    if (raid_mode == -1)
    {
        printf("Error: No raid mode specified.");
        return -1;
    }
    else
    {
        // printf("The raid mode is %d\n", raid_mode);
    }

    if (cnt_data_blocks == 0)
    {
        printf("Error: No data blocks specified.");
        return -1;
    }
    else
    {
        // convert num_data_blocks to closest multiple of 32
        if (cnt_data_blocks % 32 != 0)
        {
            cnt_data_blocks = 32 * (cnt_data_blocks / 32) + 32;
        }
        // printf("Number of data blocks = %d\n", cnt_data_blocks);
    }

    if (cnt_inodes == 0)
    {
        printf("Error: No inodes specified.");
        return -1;
    }
    else
    {
        if (cnt_inodes % 32 != 0)
        {
            cnt_inodes = 32 * (cnt_inodes / 32) + 32;
        }
        // printf("Number of inodes = %d\n", cnt_inodes);
    }

    for (int i = 0; i < 10; i++)
    {
        if (disk_name[i] == NULL)
            break;
        // printf("%s\n", disk_name[i]);
    }

    // ####################### Disk Size >= Data Blocks #######################
    struct stat file_stat;
    long disk_size = 0;
    if (stat(disk_name[0], &file_stat) == 0)
    {
        disk_size = file_stat.st_size;
        // printf("File Size = %d KB\n", (int)disk_size/1000);
        
    }
    else
    {
        perror("stat");
    }

    if(disk_size  <= (cnt_data_blocks+cnt_inodes)*512)
    {
        // printf("Not enough disk size\n");
        
        return -1;
    }
    else
    {
        // printf("Enough Disk Size\n");
        // printf("\nsohi\n");
    }
    // printf("disk size = %d\n", (int)disk_size);
    // printf("blocks = %d\n", (cnt_data_blocks+cnt_inodes)*512);

    // ####################### Open Disk Files & Mmap #######################
    create_mmap_pointers(disk_name, cnt_disks, mmap_pointers, disk_size);



    // // ####################### static structs #######################

    // struct wfs_sb superblock;
    // struct wfs_inode inode_block;

    // char i_BMP[cnt_inodes / 8];
    // memset(i_BMP, 0, sizeof(i_BMP)); 
    // i_BMP[0] = 1;
    
    
    // char d_BMP[cnt_data_blocks/8];
    // memset(i_BMP, 0, sizeof(d_BMP));



    // superblock.num_inodes = cnt_inodes;
    // superblock.num_data_blocks = cnt_data_blocks;
    // superblock.i_bitmap_ptr = &superblock + sizeof(struct wfs_sb);
    // superblock.d_bitmap_ptr = superblock.i_bitmap_ptr + (cnt_inodes*sizeof(char))/8; 


    // // PADDING 512
    // superblock.i_blocks_ptr = superblock.d_bitmap_ptr + (cnt_data_blocks*sizeof(char))/8;
    // superblock.d_blocks_ptr = superblock.i_blocks_ptr + cnt_inodes*BLOCK_SIZE;

    // //strcpy(superblock.raid_mode, raid_mode);
    // superblock.disk_order = 0;
    
    // ###################### Write Data to Mmaps ######################
    //int disk_order = 0;
    for (int i = 0; i < cnt_disks; i++)
    {
        // memcpy(mmap_pointers[i], &superblock, sizeof(struct wfs_sb));
        // superblock.disk_order++;
        // // BITMAPS:
        // memcpy(mmap_pointers[i], &i_BMP, sizeof(cnt_inodes / 8));
        // memcpy(mmap_pointers[i], &d_BMP, sizeof(cnt_inodes / 8));


        // memcpy(mmap_pointers[i], &inode_block, sizeof(struct wfs_inode));
        
        
        
        // printf("1\n");
        // create the supernode 
        struct wfs_sb * sb = (struct wfs_sb *)mmap_pointers[i];
        // printf("2\n");

        sb->num_inodes = cnt_inodes;   
        sb->num_data_blocks = cnt_data_blocks;
        sb->raid_mode = raid_mode;
        sb->disk_order = i;


        sb->i_bitmap_ptr = sizeof(struct wfs_sb);
        sb->d_bitmap_ptr = sb->i_bitmap_ptr + (cnt_inodes)/8;
        // printf("3\n");
        // 
        int size = sizeof(struct wfs_sb) + (cnt_inodes)/8 +(cnt_data_blocks)/8;
        // printf("size of offset %d\n",size);
        int offset=0;

        // ----------- allocate the inodes -----------
        if (size % 512 != 0)
        {
            offset = 512 - (size % 512);
        }
        // printf("size of round offset %d\n",offset);
        // mmap_pointers[i] += offset;

        sb->i_blocks_ptr = size + offset;
        sb->d_blocks_ptr = sb->i_blocks_ptr + cnt_inodes*BLOCK_SIZE;


        // Change type of pointer to char to make it byte addressable
        char* base = (void*) sb;
        //Allocate bitmaps:
        __u_int * i_BMP_temp = (__u_int *) (base + sb->i_bitmap_ptr);
        //One Inode for the root
        i_BMP_temp[0] = 1;

        //allocate Inode:
        struct wfs_inode * i_Node_temp = (struct wfs_inode *) (base + sb->i_blocks_ptr);
        i_Node_temp->num = 0;
        i_Node_temp->mode = 1;
        i_Node_temp->uid = process_uid;
        i_Node_temp->gid = process_gid;
        i_Node_temp->size = 0;

        i_Node_temp->nlinks = 1;
        i_Node_temp->atim = 123;
        i_Node_temp->mtim = 123;
        i_Node_temp->ctim = 123;
        memset(i_Node_temp->blocks,0,N_BLOCKS*(sizeof(off_t)));

        


    // memset(i_BMP, 0, sizeof(i_BMP)); 
    // i_BMP[0] = 1;



        // sb->num_inodes = cnt_inodes;
        // sb->num_data_blocks = cnt_data_blocks;
         
        // //all maps-------------------------------
        // char *i_bitmap = sb + sizeof(struct wfs_sb);
        // char *d_bitmap = i_bitmap + ();
        // //----------------------------------------




        
        // // ----------- allocate the inode bitmap -----------
        // mmap_pointers[i] += sizeof(struct wfs_sb);

        // char *i_bitmap = (char *)mmap_pointers[i];
        // // reset the bitmap elements
        // for(int i=0; i<cnt_inodes; i++)
        // {
        //     i_bitmap[i] = 0;
        // }
        
        // // ----------- allocate the data bitmap -----------
        // char **d_bitmap = (char *)mmap_pointers[i];
        // // reset the bitmap elements
        // for(int i=0; i<cnt_data_blocks; i++)
        // {
        //     d_bitmap[i] = 0;
        // }

        // int size = sizeof(struct wfs_sb) + sizeof(i_bitmap)+sizeof(d_bitmap);
        // int offset=0;

        // // ----------- allocate the inodes -----------
        // if (size % 512 != 0)
        // {
        //     offset = 512 - (size % 512);
        // }

        // mmap_pointers[i] += offset;

        // for(int i=0; i<cnt_inodes; i++)
        // {
        //     struct wfs_inode *inode = mmap_pointers[i];
        //     mmap_pointers[i] += 512;
        // }


        // // initialize the pointers
        // sb->i_bitmap_ptr = sizeof(struct wfs_sb);
        // sb->d_bitmap_ptr = sizeof(struct wfs_sb) + sizeof(i_bitmap);
        // sb->i_blocks_ptr = size + offset;
        // sb->d_blocks_ptr = size + offset + cnt_inodes*sizeof(struct wfs_inode);

        // strcpy(sb->raid_mode, raid_mode);
        // sb->disk_order = i; 
    }
    

    return 0;
}
