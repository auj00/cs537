#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "wfs.h"

int main(int argc, char *argv[])
{
    // ################## parse the command line arguments ##################

    // check if the number of command line arguments is odd since each argument is in pair
    if(argc%2 == 0)
    {
        // confirm once
        return -1;
    }

    char *raid_mode = "-1";
    int num_data_blocks = 0;
    int num_inodes = 0;
    for (int i = 0; i < argc; i++)
    {
        // ----------- RAID MODE -------------
        if(strcmp(argv[i], "-r") == 0)
        {   
            printf("-r found\n");
            // printf("%s\n", argv[i+1]);
            if(strcmp(argv[i+1], "0")==0)
            {
                raid_mode = "0";
                printf("%s\n", raid_mode);
                break;
            }
            else if(strcmp(argv[i+1], "1")==0)
            {
                raid_mode = "1";
                break;
            }
            else if(strcmp(argv[i+1], "1v")==0)
            {
                raid_mode = "1v";
                break;
            }
            else 
            {
                printf("Error : Unknown raid mode specified\n");
                return -1;
            }
            
        }  
        // ---------------- count & store disk files ----------------
        if(strcmp(argv[i], "-d") == 0)
        {

        }

        // ---------------- count & store inodes ----------------
        if(strcmp(argv[i], "-i") == 0)
        {
            num_inodes = atoi(argv[i+1]);
        }

        // ---------------- count & store data blocks ----------------
        if(strcmp(argv[i], "-b") == 0)
        {
            num_data_blocks = atoi(argv[i+1]);
        }

    }

    // ############### check for valid command line arguments ###############

    if(strcmp(raid_mode, "-1") == 0)
    {
        printf("Error: No raid mode specified.");
        return -1;
    }
    else
    {
        printf("The raid mode is %s\n", raid_mode);
    }


    if(num_data_blocks == 0)
    {
        printf("Error: No data blocks specified.");
        return -1;
    }
    else
    {
        printf("The raid mode is %s\n", raid_mode);
    }

    if(num_inodes == 0)
    {
        printf("Error: No inodes specified.");
        return -1;
    }
    else
    {
        printf("The raid mode is %s\n", raid_mode);
    }


    // convert num_data_blocks to closest multiple of 32
    if(num_data_blocks%32 != 0)
    {
        num_data_blocks = 32*(num_data_blocks/32) + 32;
    }
    

    

    
    // #### open the disk files ### 
    
    // get disk file fds


    // mmap the disk files
    
    return 0;
}
