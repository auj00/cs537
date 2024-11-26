#define FUSE_USE_VERSION 30

#include <fuse.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include "wfs.h"


// function to get mmap array pointer
void create_disk_mmap(char **disk_name, int disk_cnt, void **disk_ptr, int disk_size, int disk_fd[])
{
    // printf("test 1 \n");
    // open files & create mmap pointers
    for (int i = 0; i < disk_cnt; i++)
    {
        // printf("does he know\n");
        int fd = open(disk_name[i], O_RDWR, 0777);
        disk_fd[i] = fd;
        disk_ptr[i] = mmap(NULL, disk_size , PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    }
}

/*
Function to free memory maps & close file pointers
*/
void remove_disk_mmap(int disk_cnt, int disk_size, int disk_fd[], void **mmap_pointers)
{
    for(int i=0; i<disk_cnt; i++)
    {
        // munmap
        munmap(mmap_pointers[i], disk_size);
        // free the file-descriptors
        close(disk_fd[i]);
    }
}

// ###################################### call-back functions ######################################

static int wfs_getattr(const char *path, struct stat *stbuf)
{
    // Implementation of getattr function to retrieve file attributes
    // Fill stbuf structure with the attributes of the file/directory indicated by path
    printf("In getattr\n");
    

    return 0; // Return 0 on success
}

static struct fuse_operations ops = {
    .getattr = wfs_getattr,
    // .mknod = wfs_mknod,
    // .mkdir = wfs_mkdir,
    // .unlink = wfs_unlink,
    // .rmdir = wfs_rmdir,
    // .read = wfs_read,
    // .write = wfs_write,
    // .readdir = wfs_readdir,
};

int main(int argc, char *argv[])
{
    // ###################################### parse command line arguments ######################################
    // int raid_mode = -1;
    // int cnt_data_blocks = 0;
    // int cnt_inodes = 0;
    int cnt_disks = 0;
    int disk_size = 0;
    char *disk_name[10] = {NULL};
    void *disk_mmap_ptr[10] = {NULL};
    int disk_fd[10]={0};

    // assuming the order is maintained in the cmd-line args
    // ./wfs disk1 disk2 [FUSE options] mount_point
    int fuse_options_flag = 0;                     // flag indicates FUSE options have been parsed

    for(int i=0; i<argc; i++)
    {
        if(strcmp(argv[i], "-f")==0 || strcmp(argv[i], "-s")==0)
        {
            fuse_options_flag = 1;
        }

        if(fuse_options_flag == 0 && i != 0)
        {
            disk_name[cnt_disks] = argv[i];
            printf("%s\n", disk_name[cnt_disks]);
            cnt_disks++;
        }
    }

    // #################################### Validate the cmd line args ####################################

    if(cnt_disks == 0)
    {
        return -1;
    }


    struct stat file_stat;
    // long disk_size = 0;
    if (stat(disk_name[0], &file_stat) == 0)
    {
        disk_size = file_stat.st_size;
    }
    else
    {
        perror("stat");
    }

    create_disk_mmap(disk_name, cnt_disks, disk_mmap_ptr, disk_size, disk_fd);

    struct wfs_sb *sb = (struct wfs_sb *)disk_mmap_ptr[0];

    if(sb->total_disks != cnt_disks)
    {
        printf("Error: not enough disks.\n");
        return -1;
        remove_disk_mmap(cnt_disks, disk_size, disk_fd, disk_mmap_ptr);
    }


    // #################################### modify argc & argv ########################################

    // decrement argc
    argc = argc-cnt_disks-1;
    // printf("%d\n", argc);

    // increment argv
    for(int i=0; i<(cnt_disks+1); i++)
    {
        argv++;
    }

    for (int i = 0; i < argc; i++)
    {
        printf("%s\n", argv[i]);
    }
    
    // return 0;

    // ######################################## call fuse_main ########################################

    printf("started\n");
    // Initialize FUSE with specified operations
    // Filter argc and argv here and then pass it to fuse_main
    return fuse_main(argc, argv, &ops, NULL);
}
