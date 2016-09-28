/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSArefreshlist.c,v 1.2300 2003/11/24 00:54:30 nsadmin Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSArefreshlist.c,v 1.2300 2003/11/24 00:54:30 nsadmin Exp $";
#endif
#endif

#include <stdio.h>

#include <stdlib.h>

#include "iSAdisklist.h"

#include "general.h"





int main(int argc, char* argv[])

{

    unsigned char array_id;

    int result;



    if (argc==1){

        fprintf(stderr,"Usage: iSArefreshlist -aid array_id\n");

        fprintf(stderr,"Usage: iSArefreshlist -?\n");

        exit(FCSAN_ERROR_CODE);        

    }

    

    if (!strcmp(argv[1],OPTION_HELP)){
        if (argc==2){
                printf("Usage: iSArefreshlist -aid array_id\n");
                printf("Usage: iSArefreshlist -?\n");
                exit(FCSAN_SUCCESS_CODE);        
        }else{
                fprintf(stderr,"Usage: iSArefreshlist -aid array_id\n");
                fprintf(stderr,"Usage: iSArefreshlist -?\n");
                exit(FCSAN_ERROR_CODE);        
        }
    }



    if (argc != 3){ /*usage error*/

        fprintf(stderr,"Usage: iSArefreshlist -aid array_id\n");

        fprintf(stderr,"Usage: iSArefreshlist -?\n");

        exit(FCSAN_ERROR_CODE);

    }

    if (!strcmp(argv[1],PARAM_AID)){

        if (convert_arrayid(argv[2],&array_id)){/*array_id is invalid*/

        fprintf(stderr,"%s::%02u%03u:%s(aid:%s)\n",CMDNAME_ISAREFRESHLIST,MSGNO_FCSAN_PREFIX,

            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[2]);

            exit(FCSAN_ERROR_CODE);

        }else{

            result= iSMSMRMCtrl(array_id);

        if (result==iSMSM_NORMAL){/*API successful*/

            printf("Refresh request accept.\n%s : %s\n%s\n",ARRAY_ID_LABEL,argv[2],COMMAND_SUCCESS_INFO);

            exit(FCSAN_SUCCESS_CODE);/* success */

        }else{    /* API failed */

                fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISAREFRESHLIST,

                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,

            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISAREFRESHLIST,CMDCODE_TYPE_API,1);    

                exit(FCSAN_ERROR_CODE); /* failed */

        }

        }        

    }else{

            fprintf(stderr,"Usage: iSArefreshlist -aid array_id\n");

            fprintf(stderr,"Usage: iSArefreshlist -?\n");

            exit(FCSAN_ERROR_CODE);

    }

    return FCSAN_SUCCESS_CODE;

}    

