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
#include <time.h>
#include "wfs.h"

// array of pointers to disk memory maps in the mkfs order
void *ordered_disk_mmap_ptr[10] = {NULL};

// global variable to store number of disks in wfs
 int cnt_disks = 0;

int raid_mode = -1;

// function to get mmap array pointer
void create_disk_mmap(char **disk_name, int disk_cnt, void **disk_mmap_ptr, int disk_size, int disk_fd[])
{
    // printf("test 1 \n");
    // open files & create mmap pointers
    for (int i = 0; i < disk_cnt; i++)
    {
        // printf("does he know\n");
        int fd = open(disk_name[i], O_RDWR, 0777);
        disk_fd[i] = fd;
        disk_mmap_ptr[i] = mmap(NULL, disk_size , PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
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

// function that provides array of correctly ordered disk mmaps
void reorder_disk_mmap(int disk_cnt, void **disk_mmap_ptr, void** ordered_disk_mmap_ptr)
{
    for (int i = 0; i < disk_cnt; i++)
    {
        struct wfs_sb * sb = (struct wfs_sb *)disk_mmap_ptr[i];
        ordered_disk_mmap_ptr[sb->disk_order] = disk_mmap_ptr[i];
    }
    
}


// ########################################### Helper functions ##########################################

// int get_raid_mode(void *disk_mmap_ptr)
// {

// }


int path_parse(char *str, char **arg_arr, char *delims)
{
    int arg_cnt = 0;                        // cnt of the number of tokens
    // using strtok()
    // Returns pointer to first token
    char *token = strtok(str, delims);

    // Keep counting tokens while one of the
    // delimiters present in str[].
    while (token != NULL)
    {
        // printf(" % s\n", token);
        arg_cnt++;
        arg_arr[arg_cnt - 1] = strdup(token);
        token = strtok(NULL, delims);
    }

    // printf("tokenization done %d\n", arg_cnt);
    return arg_cnt;
}


// function to return the next inode number if available 
int get_inode_index(void *disk_mmap_ptr)
{
    struct wfs_sb * sb = (struct wfs_sb *)disk_mmap_ptr;

    // check sb->i_bitmap for empty spot
    // Change type of pointer to char to make it byte addressable
    char* base = (void*)disk_mmap_ptr;
    
    int inode_number = -1;
    __u_int * i_bitmap = (__u_int *) (base + sb->i_bitmap_ptr);

    for (int i = 0; i < sb->num_inodes/32; i++)
    {
        uint32_t mask = 1;
        for (int j = 0; j < 32; j++)
        {
            if(i_bitmap[i] & mask == 0)
            {
                // set the inode bitmap
                i_bitmap[i] |= mask;

                // return the inode number
                inode_number = i*32 + j;
                return inode_number;
            }
            mask<<1;
        } 
    }
    return inode_number;
}

// standby if needed later
// change the get_inode_index method
void set_inode_index(int inode_number, void *disk_mmap_ptr)
{
    struct wfs_sb * sb = (struct wfs_sb *)disk_mmap_ptr;
    char* base = (void*)disk_mmap_ptr;
    __u_int * i_bitmap = (__u_int *) (base + sb->i_bitmap_ptr);

    int row = inode_number/32;
    int col = inode_number%32;

    __u_int mask =1;

    for (int i = 0; i < col; i++)
    { 
        mask<<1;
    }
    // set the inode bitmap
    i_bitmap[row] |= mask;
}


// ###################################### call-back functions ######################################

static int wfs_getattr(const char *path, struct stat *stbuf)
{
    // Implementation of getattr function to retrieve file attributes
    // Fill stbuf structure with the attributes of the file/directory indicated by path
    printf("In getattr\n");

    // For RAID1
    struct wfs_sb * sb =  (struct wfs_sb * )ordered_disk_mmap_ptr[0];

    // Change type of pointer to char to make it byte addressable
    char* base = (void*)ordered_disk_mmap_ptr[0];
    struct wfs_inode * root_inode = (struct wfs_inode *) (base + sb->i_blocks_ptr);
 
    
    stbuf->st_uid = root_inode->uid;
    stbuf->st_gid = root_inode->gid;
    stbuf->st_atime = root_inode->atim;
    stbuf->st_mtime = root_inode->mtim;
    stbuf->st_mode = root_inode->mode;
    stbuf->st_size = root_inode->size;

    printf("end of getattr\n");

    return 0; // Return 0 on success
}


static int wfs_mkdir(const char* path, mode_t mode)
{
    // tokenize the path
    char * copy_path = strdup(path);
    char *token_arr[10];                    // Assuming that path won't have more than 10 tokens
    int token_cnt = 0;
    token_cnt = path_parse(copy_path, token_arr, '/');

    // struct wfs_sb * sb = (struct wfs_sb *)ordered_disk_mmap_ptr[0];

    int parent_inode_num = 0;

    // check whether path is valid
    for(int i=1; i<token_cnt-1; i++)
    {
        // later
    }

    // ------------------- get the next empty inode bitmap index -------------------
    int inode_bmp_idx = get_inode_index(ordered_disk_mmap_ptr[0]);

    if(inode_bmp_idx == -1)
    {
        // all inodes allcated, inode bitmap full
        return -1;
    }
    
    // -------------------------- create an inode on each disk --------------------------

    // for loop to iterate over each disk
    for (int i = 0; i < cnt_disks; i++)
    {
        // set the inode bit map
        set_inode_index(inode_bmp_idx, ordered_disk_mmap_ptr[i]);

        // sb pointer to access inode block offset
        struct wfs_sb * sb = (struct wfs_sb *)ordered_disk_mmap_ptr[0];
        int offset = sb->i_blocks_ptr;


        char* base = (void*)ordered_disk_mmap_ptr[i];
        struct wfs_inode* curr_inode = (struct wfs_inode *) (base + sb->i_blocks_ptr + inode_bmp_idx*BLOCK_SIZE);
        curr_inode->num = inode_bmp_idx;
        curr_inode->mode = S_IFDIR | 0755;
        curr_inode->uid = getuid();
        curr_inode->gid = getgid();
        curr_inode->size = 0;
        curr_inode->nlinks = 1;
        curr_inode->atim = time(NULL);
        curr_inode->mtim = time(NULL);
        curr_inode->ctim = time(NULL);
        memset(curr_inode->blocks,0,N_BLOCKS*(sizeof(off_t)));

        // update parent inode 

        struct wfs_inode* parent_inode = (struct wfs_inode *) (base + sb->i_blocks_ptr + parent_inode_num*BLOCK_SIZE);
        parent_inode->size += sizeof(struct wfs_dentry);
        parent_inode->mtim = time(NULL);
        parent_inode->ctim = time(NULL);
    }

    
    // update parent dirent
    

    // make a directory entry
}

static struct fuse_operations ops = {
    .getattr = wfs_getattr,
    // .mknod = wfs_mknod,
    .mkdir = wfs_mkdir,
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
    // int cnt_disks = 0;
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

    raid_mode = sb->raid_mode;


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
