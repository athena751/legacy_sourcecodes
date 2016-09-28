/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: nsgui_fsync.c,v 1.2 2005/06/23 05:09:07 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: nsgui_fsync.c,v 1.2 2005/06/23 05:09:07 liuyq Exp $";
#endif
#endif

/*************************************************************************************
 * Function: use fsync() to synchronize the specified file
 * Parameter : file name
 * Return:
 * 		0 -- success
 * 		1 -- parameter error
 * 		2 -- system call error
 *
 * INSTALL:
 *     1. gcc -o nsgui_fsync nsgui_fsync.c
 *     2. use "./nsgui_fysnc <file_name> to synchronize file 
 *     3. makefile's writing  not  sure
 *
 * HISTORY:
 *     Date        Modifier        Contents
 *     2005/04/04  Liuyq           First time finished.
 *     2005/04/05  Liuyq           Output all the message to standard error.
 *     2005/04/12  Liuyq           Use perror to output error message of system call
 *     2005/04/12  Liuyq           Modify copyright and include direction
 ***************************************************************************************/
 
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

void usage(char *cmdName); 

int main(int argc, char *argv[]){
    int fd_sync , ret;
    char *file;
    ret = 0;

    if(argc != 2){
        usage(argv[0]);
        exit(1);
    }
    
    file = argv[1];
    
    fd_sync = open(file, O_RDWR);
    if(fd_sync < 0 ){
        perror("Open");
        close(fd_sync);
        exit(2);
    }
    ret = fsync(fd_sync);
    if(0 != ret ){
        perror("Fsync");
        close(fd_sync);			
        exit(2);
    }
	
    ret = close(fd_sync);
    if(0 != ret ){
        perror("Close");		
        exit(2);
    }
    exit(0);
}

/*
 * *Function : print usage
 * *Parameter: 
 * *    cmdName: command's name
 * *Return : void
 */
void usage(char *cmdName){
    fprintf(stderr , "Usage:\n");
    fprintf(stderr , "\t%s <file>\n", cmdName);
}
