#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include "wfs.h"

int main(int argc, char *argv[])
{

    // ################## parse the command line arguments ##################

    // command line arguments should be odd
    // each command line argument is accompanied by a flag
    if (argc % 2 == 0)
    { // confirm once
        return -1;
    }

    char *raid_mode = "-1";
    int cnt_data_blocks = 0;
    int cnt_inodes = 0;
    int cnt_disks = 0;
    char *disk_name[10]={NULL};
    void *mmap_pointers[10] = {NULL};

    // loop to iterate over all the command line args
    for (int i = 0; i < argc; i++)
    {
        // ----------- RAID MODE -------------
        if (strcmp(argv[i], "-r") == 0)
        {
            printf("-r found\n");
            if (strcmp(argv[i + 1], "0") == 0)
            {
                raid_mode = "0";
                printf("%s\n", raid_mode);
            }
            else if (strcmp(argv[i + 1], "1") == 0)
            {
                raid_mode = "1";
            }
            else if (strcmp(argv[i + 1], "1v") == 0)
            {
                raid_mode = "1v";
            }
            else
            {
                printf("Error : Unknown raid mode specified\n");
                return -1;
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

    if (strcmp(raid_mode, "-1") == 0)
    {
        printf("Error: No raid mode specified.");
        return -1;
    }
    else
    {
        printf("The raid mode is %s\n", raid_mode);
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
        printf("Number of data blocks = %d\n", cnt_data_blocks);
    }

    if (cnt_inodes == 0)
    {
        printf("Error: No inodes specified.");
        return -1;
    }
    else
    {
        printf("Number of inodes = %d\n", cnt_inodes);
    }

    for (int i = 0; i < 10; i++)
    {
        if(disk_name[i] == NULL)
            break;
        printf("%s\n", disk_name[i]);
    }
    

    // ####################### Open Disk Files & Mmap #######################

    

    // ###################### Write Data to Mmaps ######################

    return 0;
}
