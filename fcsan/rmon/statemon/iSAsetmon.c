/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetmon.c,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAsetmon.c,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "general.h"
#include "iSAsetmon.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"

int main(int argc , char * argv[])
{
    int ctrl_flg ;
    int result ; /* value returned from API */
    unsigned char array_id ;
    
    if (argc==1)
    {
        fprintf(stderr,"%s" , USAGE_FOR_ALL_OPTIONS);
        exit(FCSAN_ERROR_CODE) ; /* failed */
    }
    
    
    if (strcmp(argv[1],OPTION_HELP)==0)
    {
        if (argc==2)
        {
                printf("%s" , USAGE_FOR_ALL_OPTIONS);
                exit(FCSAN_SUCCESS_CODE) ;/* success */
        }
        else
        {
                fprintf(stderr,"%s" , USAGE_FOR_ALL_OPTIONS);
                exit(FCSAN_ERROR_CODE) ;/* error */
        }
    }
    
    if (argc!=4 || strcmp(argv[2],PARAM_AID))
    {/* missing parameter */
        fprintf(stderr,"%s" , USAGE_FOR_ALL_OPTIONS);
        exit(FCSAN_ERROR_CODE) ; /* failed */
    }
    
    /* argc==4 */
    if (strcmp(argv[1],OPTION_START)==0)
    {
        ctrl_flg=iSMSM_MONITOR_START ;
    }
    else if (strcmp(argv[1],OPTION_STOP)==0)
    {
        ctrl_flg=iSMSM_MONITOR_STOP ;
    }
    else if (strcmp(argv[1],OPTION_FSTOP)==0)
    {
        ctrl_flg=iSMSM_MONITOR_FSTOP ;
    }
    else /* wrong option */
    {
        fprintf(stderr,"%s" , USAGE_FOR_ALL_OPTIONS);
        exit(FCSAN_ERROR_CODE) ; /* failed */
    }
    
    if (convert_arrayid(argv[3],&array_id))
    {/* invalid array id */
        fprintf(stderr,"%s::%02u%03u:%s(aid:%s)\n",CMDNAME_ISASETMON,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
        exit(FCSAN_ERROR_CODE); /* failed */
    }
    
    /* call API*/
    result= iSMSMMonCtrl(array_id , ctrl_flg) ;
    if (result==iSMSM_NORMAL)
    {
        char * acceptInfo ;
        switch(ctrl_flg)
        {
          case iSMSM_MONITOR_START:
            acceptInfo=START_ACCEPT_INFO;
            break ;
          case iSMSM_MONITOR_STOP:
            acceptInfo=STOP_ACCEPT_INFO;
            break ;
          case iSMSM_MONITOR_FSTOP:
            acceptInfo=FSTOP_ACCEPT_INFO;
            break ;
        }
        printf("%s\n%s:%s\n%s\n",acceptInfo,ARRAY_ID_LABEL,argv[3],COMMAND_SUCCESS_INFO);
        exit(FCSAN_SUCCESS_CODE);/* success */
    }
    else    /* API failed */
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETMON,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_SETMON,CMDCODE_TYPE_API,1);    
        exit(FCSAN_ERROR_CODE); /* failed */
    }


    
}//end of "main"


