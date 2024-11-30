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

// ############################################ Global Variables #####################################

// array of pointers to disk memory maps in the mkfs order
void *ordered_disk_mmap_ptr[10] = {NULL};

// global variable to store number of disks in wfs
int cnt_disks = 0;

int raid_mode = -1;

// ######################################### memory map functions #########################################

// function to populate array mmap pointers
void create_disk_mmap(char **disk_name, int disk_cnt, void **disk_mmap_ptr, int disk_size, int disk_fd[])
{
    // printf("test 1 \n");
    // open files & create mmap pointers
    for (int i = 0; i < disk_cnt; i++)
    {
        // printf("does he know\n");
        int fd = open(disk_name[i], O_RDWR, 0777);
        disk_fd[i] = fd;
        disk_mmap_ptr[i] = mmap(NULL, disk_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    }
}

/************************************************
Function to free memory maps & close file pointers
*************************************************/
void remove_disk_mmap(int disk_cnt, int disk_size, int disk_fd[], void **mmap_pointers)
{
    for (int i = 0; i < disk_cnt; i++)
    {
        // munmap
        munmap(mmap_pointers[i], disk_size);
        // free the file-descriptors
        close(disk_fd[i]);
    }
}

// function that provides array of correctly ordered disk mmaps
void reorder_disk_mmap(int disk_cnt, void **disk_mmap_ptr, void **ordered_disk_mmap_ptr)
{
    for (int i = 0; i < disk_cnt; i++)
    {
        struct wfs_sb *sb = (struct wfs_sb *)disk_mmap_ptr[i];
        ordered_disk_mmap_ptr[sb->disk_order] = disk_mmap_ptr[i];
    }
    printf("reorder disk map done\n");
}

// ########################################### Helper functions ##########################################

// returns RAID mode
int get_raid_mode(void *disk_mmap_ptr)
{
    struct wfs_sb *sb = (struct wfs_sb *)disk_mmap_ptr;
    printf("RAID%d\n", sb->raid_mode);
    return sb->raid_mode;
}

// returns count of tokens within "path"
// populates array of tokens using strdup()
int path_parse(char *str, char **arg_arr, char *delims)
{
    printf("path parse called\n");
    int arg_cnt = 0; // cnt of the number of tokens
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

    printf("tokens found = %d\n", arg_cnt);
    return arg_cnt;
}

// checks the inode bitmap
// returns the next empty inode index
// else returns -1
int get_next_inode_index(void *disk_mmap_ptr)
{
    struct wfs_sb *sb = (struct wfs_sb *)disk_mmap_ptr;

    // check sb->i_bitmap for empty spot
    // Change type of pointer to char to make it byte addressable
    char *base = (void *)disk_mmap_ptr;

    int inode_number = -1;
    __u_int *i_bitmap = (__u_int *)(base + sb->i_bitmap_ptr);

    for (int i = 0; i < sb->num_inodes / 32; i++)
    {
        uint32_t mask = 1;
        for (int j = 0; j < 32; j++)
        {
            if ((i_bitmap[i] & mask) == 0)
            {
                // set the inode bitmap
                i_bitmap[i] |= mask;

                // return the inode number
                inode_number = i * 32 + j;
                return inode_number;
            }
            mask = mask << 1;
        }
    }
    return inode_number;
}

//
//
void set_inode_index(int inode_number, int mask)
{
    for (int i = 0; i < cnt_disks; i++)
    {
        struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[i];
        char *base = (void *)ordered_disk_mmap_ptr[i];
        __u_int *i_bitmap = (__u_int *)(base + sb->i_bitmap_ptr);

        int row = inode_number / 32;
        int col = inode_number % 32;

        __u_int mask = 1;

        for (int i = 0; i < col; i++)
        {
            mask = mask << 1;
        }
        // set the inode bitmap
        i_bitmap[row] |= mask;
    }
}

// function to return the next inode number if available
int get_data_index(void *disk_mmap_ptr)
{
    struct wfs_sb *sb = (struct wfs_sb *)disk_mmap_ptr;

    // check sb->i_bitmap for empty spot
    // Change type of pointer to char to make it byte addressable
    char *base = (void *)disk_mmap_ptr;

    int data_block_number = -1;
    __u_int *d_bitmap = (__u_int *)(base + sb->d_bitmap_ptr);

    for (int i = 0; i < sb->num_data_blocks / 32; i++)
    {
        uint32_t mask = 1;
        for (int j = 0; j < 32; j++)
        {
            if ((d_bitmap[i] & mask) == 0)
            {
                // set the inode bitmap
                d_bitmap[i] |= mask;

                // return the inode number
                data_block_number = i * 32 + j;
                return data_block_number;
            }
            mask = mask << 1;
        }
    }
    return data_block_number;
}

/*****************
sets the given data bitmap index to the given mask for all disks
****************/
void set_data_bmp_index(int data_block_number, int mask)
{
    for (int i = 0; i < cnt_disks; i++)
    {
        struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[i];
        char *base = (void *)sb;
        __u_int *d_bitmap = (__u_int *)(base + sb->d_bitmap_ptr);

        int row = data_block_number / 32;
        int col = data_block_number % 32;

        __u_int mask = 1;

        for (int i = 0; i < col; i++)
        {
            mask = mask << 1;
        }
        // set the inode bitmap
        d_bitmap[row] |= mask;
    }
}

// ################################

// Returns pointer to inode based on
// 1. given inode_num
// 2. given disk
struct wfs_inode *get_inode_ptr(int inode_num, int disk_num)
{
    struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[disk_num];
    char *base = (void *)ordered_disk_mmap_ptr[disk_num];

    struct wfs_inode *curr_inode = (struct wfs_inode *)(base + sb->i_blocks_ptr + inode_num * BLOCK_SIZE);
    return curr_inode;
}

/*****************************************
 Function to set the d_block ptr:
 index of d_block based on data bitmap;
 RAID;
 pointer to set;
 *****************************************/
void *get_d_block_ptr(int d_block_index, int disk_num)
{
    void *d_block_ptr = NULL;

    if (raid_mode == 0)
    {
        disk_num = d_block_index % cnt_disks;
    }

    // point to the sb of the correct disk (matters for RAID 0)
    struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[disk_num];
    char *base = (void *)sb;
    if (raid_mode == 0)
    {
        // point to the d_block of the first block of current inode passed
        d_block_ptr = (void *)(base + sb->d_blocks_ptr + (d_block_index / cnt_disks) * BLOCK_SIZE);

    } // divided across disks
    else
    {
        // all blocks present in the each disks
        d_block_ptr = (void *)(base + sb->d_blocks_ptr + d_block_index * BLOCK_SIZE);
    }
    return d_block_ptr;
}

/********************************************************
Function to find the inode number of the next element in path
Takes in inode number of the parent directory & name of the
directory to find
return inode number of the directory if found, else -1
**********************************************************/
int get_child_inode_num(int inode_num, char *child_name)
{
    printf("get_child_inode_num() called on inode_num %d & child_name %s\n", inode_num, child_name);
    // ---- step-1 : get the inode pointer ----
    struct wfs_inode *curr_inode = get_inode_ptr(inode_num, 0);

    if (curr_inode->size == 0)
        return -1;

    // ---- step-2 : Search dirents on each data block ----
    for (int i = 0; i < 7; i++)
    {
        int d_block_index = curr_inode->blocks[i];
        void *d_block_ptr = get_d_block_ptr(d_block_index, 0);

        // check the 16 directory entries in d-block
        // since each dentry is 32B and each d-block is 512B
        struct wfs_dentry *dentry_ptr = (struct wfs_dentry *)d_block_ptr;
        for (int j = 0; j < 16; j++)
        {
            printf("i = %d & j = %d\n", i, j);
            if (strcmp(child_name, dentry_ptr->name) == 0)
            {
                // if match, then return the next inode block index;
                return dentry_ptr->num;
            }
            dentry_ptr = dentry_ptr + 1;
        }
    }

    // search the indirect blocks
    return -1;
}

/*
Returns the inode_num of the last element in path

*/
int path_traversal(const char *path, int token_cnt_dcr)
{
    char *copy_path = strdup(path);
    char *token_arr[10]; // Assuming that path won't have more than 10 tokens
    int token_cnt = 0;
    token_cnt = path_parse(copy_path, token_arr, "/");

    // Algorithm to determine inode
    int inode_num = 0;
    int next_inode_num = 0;
    int i = 0;
    for (i = 0; i < (token_cnt - token_cnt_dcr); i++)
    {
        // find the inode number of the child
        next_inode_num = get_child_inode_num(inode_num, token_arr[i]);
        if (next_inode_num == -1)
        {
            return -1;
        }
        else
        {
            inode_num = next_inode_num;
        }
    }
    return inode_num;
}

/**************************
returns 1 if new data block should be allocated to an inode
only for the direct blocks
*****************************/
int allocate_data_block(int inode_num)
{
    struct wfs_inode *inode_ptr = get_inode_ptr(inode_num, 0);

    if (inode_ptr->size == 0 || ((inode_ptr->size % BLOCK_SIZE == 0) && (inode_ptr->size / BLOCK_SIZE != 7)))
    {
        return 1;
    }
    // else if(inode_ptr->size/BLOCK_SIZE == 7){
    //     return -1;
    // }
    else
    {
        return 0;
    }
}

struct wfs_dentry *get_next_dentry_ptr(int inode_num, int disk_num)
{
    struct wfs_inode *inode_ptr = get_inode_ptr(inode_num, disk_num);

    int index_in_blocks = inode_ptr->size / BLOCK_SIZE;
    int offset = inode_ptr->size % BLOCK_SIZE;

    int d_block_index = inode_ptr->blocks[index_in_blocks];
    char *dentry_ptr = (char *)get_d_block_ptr(d_block_index, disk_num);
    return (struct wfs_dentry *)(dentry_ptr + offset);
}

char *get_name_from_path(const char *path)
{
    char *copy_path = strdup(path);
    char *token_arr[10]; // Assuming that path won't have more than 10 tokens
    int token_cnt = 0;
    token_cnt = path_parse(copy_path, token_arr, "/");
    return token_arr[token_cnt - 1];
}

// ###################################### call-back functions ######################################

static int wfs_getattr(const char *path, struct stat *stbuf)
{
    printf("wfs_getattr() called on %s\n", path);

    // return code
    int res = 0;

    // corner case : path = "/"
    if (strcmp(path, "/") == 0)
    {
        struct wfs_inode *root_inode = get_inode_ptr(0, 0);
        memset(stbuf, 0, sizeof(struct stat));
        stbuf->st_uid = root_inode->uid;
        stbuf->st_gid = root_inode->gid;
        stbuf->st_atime = root_inode->atim;
        stbuf->st_mtime = root_inode->mtim;
        stbuf->st_mode = root_inode->mode;
        stbuf->st_size = root_inode->size;
        printf("root inode size = %d\n", (int)root_inode->size);
        return res;
    }

    // ---------------------- Path Parse -------------------------------
    int inode_num = path_traversal(path, 0);
    
    if(inode_num == -1)
    {
        res = -ENOENT;
        return res;
    }
    // char *copy_path = strdup(path);
    // char *token_arr[10]; // Assuming that path won't have more than 10 tokens
    // int token_cnt = 0;
    // token_cnt = path_parse(copy_path, token_arr, "/");

    // // char *new_path = "/";

    // int inode_num = 0;
    // int next_inode_num = 0;
    // int i = 0;
    // for (i = 0; i < token_cnt; i++)
    // {
    //     // find the inode number of the child
    //     next_inode_num = get_child_inode_num(inode_num, token_arr[i]);
    //     if (next_inode_num == -1)
    //     {
    //         res = -ENOENT;
    //         break;
    //     }
    //     else
    //     {
    //         inode_num = next_inode_num;
    //     }
    // }

    // // next_inode_num NOT FOUND
    // if (i != token_cnt)
    // {
    //     return res;
    // }

    // get the inode pointer
    struct wfs_inode *curr_inode = get_inode_ptr(inode_num, 0);

    memset(stbuf, 0, sizeof(struct stat));
    stbuf->st_uid = curr_inode->uid;
    stbuf->st_gid = curr_inode->gid;
    stbuf->st_atime = time(NULL);
    stbuf->st_mtime = curr_inode->mtim;
    stbuf->st_mode = curr_inode->mode;
    stbuf->st_size = 1000;

    // For RAID1
    // struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[0];
    // char *base = (void *)ordered_disk_mmap_ptr[0];

    // struct wfs_dentry *curr_dblock = (struct wfs_dentry *)(base + sb->d_blocks_ptr);

    // struct wfs_inode *root_inode = (struct wfs_inode *)(base + sb->i_blocks_ptr);

    // printf("debug 4\n");
    // if (root_inode->size != 0)
    // {
    //     for (int i = 0; i < token_cnt; i++)
    //     {
    //         printf("inside for loop\n");
    //         printf("%s & %p\n", curr_dblock->name, (void *)curr_dblock);
    //         printf("%s\n", token_arr[0]);
    //         if (strcmp(curr_dblock->name, token_arr[0]) == 0)
    //         {
    //             new_path = "/hello";
    //             printf("%s\n", new_path);
    //         }
    //     }
    // }
    // else
    // {
    //     printf("root inode size = 0\n");
    // }

    // printf("debug 5\n");

    // if (strcmp(path, "/") == 0)
    // {
    //     memset(stbuf, 0, sizeof(struct stat));
    //     stbuf->st_uid = root_inode->uid;
    //     stbuf->st_gid = root_inode->gid;
    //     stbuf->st_atime = root_inode->atim;
    //     stbuf->st_mtime = root_inode->mtim;
    //     stbuf->st_mode = root_inode->mode;
    //     stbuf->st_size = root_inode->size;
    //     printf("%d\n", (int)root_inode->size);
    //     // stbuf->st_ino = 35;
    // }
    // else if (strcmp(path, new_path) == 0)
    // {
    //     memset(stbuf, 0, sizeof(struct stat));
    //     stbuf->st_uid = root_inode->uid;
    //     stbuf->st_gid = root_inode->gid;
    //     stbuf->st_atime = time(NULL);
    //     stbuf->st_mtime = root_inode->mtim;
    //     stbuf->st_mode = root_inode->mode;
    //     stbuf->st_size = 1000;
    //     // stbuf->st_ino = 35;
    // }
    // else
    // {
    //     res = -ENOENT;
    // }

    return res; // Return 0 on success
}

/********************
1. allocate a new inode using the inode bitmap
2. add a new directory entry to the parent inode
******************** */
static int wfs_mkdir(const char *path, mode_t mode)
{
    printf("wfs_mkdir called on %s\n", path);
    int res = 0;

    // check : file exists
    if (path_traversal(path, 0) != -1)
    {
        res = -EEXIST;
        return res;
    }

    // get : parent inode number
    int parent_inode_num = path_traversal(path, 1);
    printf("parent inode = %d\n", parent_inode_num);

    // get : next empty inode bitmap index
    int inode_bmp_idx = get_next_inode_index(ordered_disk_mmap_ptr[0]);
    printf("inode_bitmap_index = %d\n", inode_bmp_idx);

    // check : inode bitmap full
    if (inode_bmp_idx == -1)
    {
        res = -ENOSPC;
        return res;
    }

    // set the inode bit map
    set_inode_index(inode_bmp_idx, 1);

    // create : new inode on each disk
    for (int i = 0; i < cnt_disks; i++)
    {
        // // set the inode bit map
        // set_inode_index(inode_bmp_idx, 1);

        // // sb pointer to access inode block offset
        // struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[0];
        // // int offset = sb->i_blocks_ptr;

        // char *base = (void *)ordered_disk_mmap_ptr[i];
        // struct wfs_inode *curr_inode = (struct wfs_inode *)(base + sb->i_blocks_ptr + inode_bmp_idx * BLOCK_SIZE);

        struct wfs_inode *curr_inode = get_inode_ptr(inode_bmp_idx, i);
        curr_inode->num = inode_bmp_idx;
        curr_inode->mode = S_IFDIR | 0755;
        curr_inode->uid = getuid();
        curr_inode->gid = getgid();
        curr_inode->size = 0;
        curr_inode->nlinks = 1;
        curr_inode->atim = time(NULL);
        curr_inode->mtim = time(NULL);
        curr_inode->ctim = time(NULL);
        memset(curr_inode->blocks, 0, N_BLOCKS * (sizeof(off_t)));
    }
    printf("Inode created for the new directory\n");

    // check : parent inode needs new data-block to hold new dentry
    int d_block_index = -1;
    if (allocate_data_block(parent_inode_num))
    {
        d_block_index = get_data_index(ordered_disk_mmap_ptr[0]);

        // check : data bitmap full
        if (d_block_index == -1)
        {
            res = -ENOSPC;
            return res;
        }
        set_data_bmp_index(d_block_index, 1);

        // update : parent inode
        for (int i = 0; i < cnt_disks; i++)
        {
            struct wfs_inode *parent_inode = get_inode_ptr(parent_inode_num, i);
            // parent_inode->size += sizeof(struct wfs_dentry);
            // parent_inode->mtim = time(NULL);
            // parent_inode->ctim = time(NULL);
            int index_in_blocks = parent_inode->size / BLOCK_SIZE;
            parent_inode->blocks[index_in_blocks] = d_block_index;
            // for (int j = 0; j < 7; i++)
            // {
            //     if(parent_inode->blocks[i] == 0)
            //     {
            //         parent_inode->blocks[i] = d_block_index;
            //         break;
            //     }
            // }
            printf("parent inode updated, size = %d\n", (int)parent_inode->size);
        }
    }
    else
    {
        // check : Parent data blocks full
        if (get_inode_ptr(parent_inode_num, 0)->size / BLOCK_SIZE == 7)
        {
            res = -ENOSPC;
            return res;
        }
    }

    // create : dentry in the parent
    if (raid_mode == 0)
    {
        struct wfs_dentry *dentry = get_next_dentry_ptr(parent_inode_num, 0);
        strcpy(dentry->name, get_name_from_path(path));
        dentry->num = inode_bmp_idx;
    }
    else
    {
        for (int i = 0; i < cnt_disks; i++)
        {
            struct wfs_dentry *dentry = get_next_dentry_ptr(parent_inode_num, i);
            strcpy(dentry->name, get_name_from_path(path));
            dentry->num = inode_bmp_idx;
        }
    }

    // update : parent inode
    for (int i = 0; i < cnt_disks; i++)
    {
        struct wfs_inode *parent_inode = get_inode_ptr(parent_inode_num, i);
        parent_inode->size += sizeof(struct wfs_dentry);
        parent_inode->mtim = time(NULL);
        parent_inode->ctim = time(NULL);
    }

    // tokenize the path
    // char *copy_path = strdup(path);
    // char *token_arr[10]; // Assuming that path won't have more than 10 tokens
    // int token_cnt = 0;
    // token_cnt = path_parse(copy_path, token_arr, "/");

    // // check the parents data bitmap
    // int dblock_bmp_idx = get_data_index(ordered_disk_mmap_ptr[0]);
    // printf("dblock_bmp_idx = %d\n", dblock_bmp_idx);

    // if (dblock_bmp_idx == -1)
    // {
    //     // all inodes allcated, inode bitmap full
    //     return -1;
    // }

    // allocate block & setup the new dirent
    // for (int i = 0; i < cnt_disks; i++)
    // {
    //     // set_data_index(dblock_bmp_idx, ordered_disk_mmap_ptr[i]);

    //     struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[0];
    //     // int offset = sb->d_blocks_ptr;

    //     char *base = (void *)ordered_disk_mmap_ptr[i];
    //     struct wfs_dentry *curr_dblock = (struct wfs_dentry *)(base + sb->d_blocks_ptr + dblock_bmp_idx * BLOCK_SIZE);

    //     strcpy(curr_dblock->name, token_arr[token_cnt - 1]);
    //     printf("%s & %p\n", curr_dblock->name, (void *)curr_dblock);
    //     curr_dblock->num = inode_bmp_idx;
    // }
    // printf("debug 4\n");
    // make a directory entry

    // update parent inode

    return res;
}


static int wfs_mknod(const char* path, mode_t mode, dev_t rdev)
{
    printf("wfs_mknod called on %s\n", path);
    int res = 0;

    // check : file exists
    if (path_traversal(path, 0) != -1)
    {
        res = -EEXIST;
        return res;
    }

    // get : parent inode number
    int parent_inode_num = path_traversal(path, 1);
    printf("parent inode = %d\n", parent_inode_num);

    // get : next empty inode bitmap index
    int inode_bmp_idx = get_next_inode_index(ordered_disk_mmap_ptr[0]);
    printf("inode_bitmap_index = %d\n", inode_bmp_idx);

    // check : inode bitmap full
    if (inode_bmp_idx == -1)
    {
        res = -ENOSPC;
        return res;
    }

    // set the inode bit map
    set_inode_index(inode_bmp_idx, 1);

    // create : new inode on each disk
    for (int i = 0; i < cnt_disks; i++)
    {
        // // set the inode bit map
        // set_inode_index(inode_bmp_idx, 1);

        // // sb pointer to access inode block offset
        // struct wfs_sb *sb = (struct wfs_sb *)ordered_disk_mmap_ptr[0];
        // // int offset = sb->i_blocks_ptr;

        // char *base = (void *)ordered_disk_mmap_ptr[i];
        // struct wfs_inode *curr_inode = (struct wfs_inode *)(base + sb->i_blocks_ptr + inode_bmp_idx * BLOCK_SIZE);

        struct wfs_inode *curr_inode = get_inode_ptr(inode_bmp_idx, i);
        curr_inode->num = inode_bmp_idx;
        curr_inode->mode = S_IFREG | 0755;
        curr_inode->uid = getuid();
        curr_inode->gid = getgid();
        curr_inode->size = 0;
        curr_inode->nlinks = 1;
        curr_inode->atim = time(NULL);
        curr_inode->mtim = time(NULL);
        curr_inode->ctim = time(NULL);
        memset(curr_inode->blocks, 0, N_BLOCKS * (sizeof(off_t)));
    }
    printf("Inode created for the new directory\n");

    // check : parent inode needs new data-block to hold new dentry
    int d_block_index = -1;
    if (allocate_data_block(parent_inode_num))
    {
        d_block_index = get_data_index(ordered_disk_mmap_ptr[0]);

        // check : data bitmap full
        if (d_block_index == -1)
        {
            res = -ENOSPC;
            return res;
        }
        set_data_bmp_index(d_block_index, 1);

        // update : parent inode
        for (int i = 0; i < cnt_disks; i++)
        {
            struct wfs_inode *parent_inode = get_inode_ptr(parent_inode_num, i);
            // parent_inode->size += sizeof(struct wfs_dentry);
            // parent_inode->mtim = time(NULL);
            // parent_inode->ctim = time(NULL);
            int index_in_blocks = parent_inode->size / BLOCK_SIZE;
            parent_inode->blocks[index_in_blocks] = d_block_index;
            // for (int j = 0; j < 7; i++)
            // {
            //     if(parent_inode->blocks[i] == 0)
            //     {
            //         parent_inode->blocks[i] = d_block_index;
            //         break;
            //     }
            // }
            printf("parent inode updated, size = %d\n", (int)parent_inode->size);
        }
    }
    else
    {
        // check : Parent data blocks full
        if (get_inode_ptr(parent_inode_num, 0)->size / BLOCK_SIZE == 7)
        {
            res = -ENOSPC;
            return res;
        }
    }

    // create : dentry in the parent
    if (raid_mode == 0)
    {
        struct wfs_dentry *dentry = get_next_dentry_ptr(parent_inode_num, 0);
        strcpy(dentry->name, get_name_from_path(path));
        dentry->num = inode_bmp_idx;
    }
    else
    {
        for (int i = 0; i < cnt_disks; i++)
        {
            struct wfs_dentry *dentry = get_next_dentry_ptr(parent_inode_num, i);
            strcpy(dentry->name, get_name_from_path(path));
            dentry->num = inode_bmp_idx;
        }
    }

    // update : parent inode
    for (int i = 0; i < cnt_disks; i++)
    {
        struct wfs_inode *parent_inode = get_inode_ptr(parent_inode_num, i);
        parent_inode->size += sizeof(struct wfs_dentry);
        parent_inode->mtim = time(NULL);
        parent_inode->ctim = time(NULL);
    }
    return res;
}

static struct fuse_operations ops = {
    .getattr = wfs_getattr,
    .mknod   = wfs_mknod,
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
    int disk_fd[10] = {0};

    // assuming the order is maintained in the cmd-line args
    // ./wfs disk1 disk2 [FUSE options] mount_point
    int fuse_options_flag = 0; // flag indicates FUSE options have been parsed

    for (int i = 0; i < argc; i++)
    {
        if (strcmp(argv[i], "-f") == 0 || strcmp(argv[i], "-s") == 0)
        {
            fuse_options_flag = 1;
        }

        if (fuse_options_flag == 0 && i != 0)
        {
            disk_name[cnt_disks] = argv[i];
            printf("%s\n", disk_name[cnt_disks]);
            cnt_disks++;
        }
    }

    // #################################### Validate the cmd line args ####################################

    if (cnt_disks == 0)
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

    // --------------------------------- mmap disks & reorder them ---------------------------------

    create_disk_mmap(disk_name, cnt_disks, disk_mmap_ptr, disk_size, disk_fd);

    struct wfs_sb *sb = (struct wfs_sb *)disk_mmap_ptr[0];
    if (sb->total_disks != cnt_disks)
    {
        printf("Error: not enough disks.\n");
        remove_disk_mmap(cnt_disks, disk_size, disk_fd, disk_mmap_ptr);
        return -1;
    }
    raid_mode = sb->raid_mode;
    reorder_disk_mmap(cnt_disks, disk_mmap_ptr, ordered_disk_mmap_ptr);

    raid_mode = get_raid_mode(ordered_disk_mmap_ptr[0]);

    // #################################### modify argc & argv ########################################

    // decrement argc
    argc = argc - cnt_disks - 1;
    // printf("%d\n", argc);

    // increment argv
    for (int i = 0; i < (cnt_disks + 1); i++)
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
