#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "wfs.h"

int main(int argc, char *argv[])
{
    // ################## parse the command line arguments ##################

    // ----------- RAID MODE -------------
    int raid_mode= -1;
    for (int i = 0; i < argc; i++)
    {
        if(strcmp(argv[i], "-r") == 0)
        {   
            printf("-r found\n");
            if(strcmp(argv[i+1], "0")==0)
            {
                raid_mode = 0;
                break;
            }
            else if(strcmp(argv[i+1], "1")==0)
            {
                raid_mode = 1;
                break;
            }
            else if(strcmp(argv[i+1], "1v")==0)
            {
                raid_mode = 2;
                break;
            }
            else 
            {
                printf("Error : Unknown raid mode specified\n");
                return -1;
            }
            
        }  
    }

    if(raid_mode == -1)
    {
        printf("Error: No raid mode specified.");
        return -1;
    }
    else
    {
        printf("The raid mode is %d\n", raid_mode);
    }
    

    
    
    return 0;
}
