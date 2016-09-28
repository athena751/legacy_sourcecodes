/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetspare.c,v 1.2300 2003/11/24 00:54:28 nsadmin Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAsetspare.c,v 1.2300 2003/11/24 00:54:28 nsadmin Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAsetspare.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"
#include "iSMSMApi_cfg.h"

int main(int argc, char *argv[])
{
     unsigned char pd_g;
     unsigned char pd_n;
     int restart=0;
     int nounlock=0;
     int force=0;
     int mark;
     int param=0;
     int result;

    if (argc==1)
    { /*print usage for all options */
        fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_B,USAGE_FOR_R,USAGE_FOR_HELP);
        exit(FCSAN_ERROR_CODE); /* failed */
    }
    
    /* argc>=2 */
    if (strcmp(argv[1],OPTION_HELP)==0) 
    { /* Option is "-?" */
        if (argc==2)
        {
                printf("%s\n%s\n%s\n",USAGE_FOR_B,USAGE_FOR_R,USAGE_FOR_HELP);
                exit(FCSAN_SUCCESS_CODE); /* success */
        }
        else
        {
                fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_B,USAGE_FOR_R,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* error */
        }
    }

    if (strcmp(argv[1],OPTION_B)==0)
    {
        param=1;// first command as"-rp"
    }
    else{
        if (strcmp(argv[1],OPTION_R)==0)
            {
                param=2;// first command as"-rs"
            }else
                {
                    fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_B,USAGE_FOR_R,USAGE_FOR_HELP);
                    exit(FCSAN_ERROR_CODE); /* failed */
                }
    }

    if (argc<8 || argc>11 || strcmp(argv[2],PARAM_ANAME)!=0 || strcmp(argv[4],PARAM_PDG)!=0||strcmp(argv[6],PARAM_PDN)!=0)/*keyPARAM_ANAME=-aname;PARAM_PDG=-pdg;PARAM_PDN=-pdn;*/
    {/* wrong command */
        if (strcmp(argv[1],OPTION_B)==0)
        {
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        else{
                fprintf(stderr,"%s\n%s\n",USAGE_FOR_R,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* failed */
            }
    }
        
    if (isInvalidName(argv[3],ARRAY_NAME_MAX_LENGTH))
    {/* invalid array name */
        fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);/*key CMDNAME_ISASETSPARE="ISAsetspare"*/
        exit(FCSAN_ERROR_CODE); /* failed */
    }
    if (hex_char_unchar(argv[5],&pd_g))
    {/* invalid pd_g */
        fprintf(stderr,"%s::%02u%03u:%s(-pdg:%s)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
        exit(FCSAN_ERROR_CODE); /* failed */
    }
        
    if (hex_char_unchar(argv[7],&pd_n))
    {/* invalid pd_n */
        fprintf(stderr,"%s::%02u%03u:%s(-pdn:%s)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
        exit(FCSAN_ERROR_CODE); /* failed */
    }
    mark=8;
    if (mark<argc&&strcmp(argv[mark],PARAM_RESTART)==0)/* PARAM_RESTART=-restart */
    { 
        restart = 1;
        mark++;
    }
    if (mark<argc&&strcmp(argv[mark],PARAM_NOUNLOCK)==0)/* PARAM_NOUNLOCK=-nounlock */
    { 
        nounlock = 1;
        mark++;
    }
    if (mark<argc&&strcmp(argv[mark],PARAM_FORCE)==0)/* PARAM_FORCE=-force */
    { 
        force=1;
        mark++;
    }
    if (mark<argc)
    {
        if (param==1)
        {
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        else{
                fprintf(stderr,"%s\n%s\n",USAGE_FOR_R,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* failed */
        }
    }
        /* call API */
    if (param==1)
    {
        result=setspare_b(argv[3],pd_g,pd_n,restart,nounlock,force) ;
        exit(result) ;
    }
    else 
    {    
        result=setspare_r(argv[3],pd_g,pd_n,restart,nounlock,force) ;
        exit(result) ;
    }

}//end of main()

int setspare_b(char *arr_name,unsigned char pd_g,unsigned char pd_n,int restart,int nounlock,int force)
{
    int result ;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMSpareBind spare_info;

    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETSPARE_B,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETSPARE,CMDCODE_FUNC_SETSPARE_B, CMDCODE_TYPE_API, &api_info,restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }

    iSMSM_INIT_SPAREBINDINFO(spare_info);
    spare_info.pdg=pd_g;
    spare_info.pdn =pd_n;
    result=iSMSMSetSpareBind(&api_info , spare_info);
    if (result == iSMSM_NORMAL)
        {
            printf("%s\n%-20s:%s\n%-20s:%02xh\n%-20s:%02xh\n\n",SPARE_BUILD_LABEL,ARRAY_NAME_LABEL,
                arr_name,PD_GROUP_LABEL,pd_g,PD_NO_LABEL,pd_n);
        }
        else /* API error */
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_SETSPARE_B,CMDCODE_TYPE_API+2,1);    
            stop_iSMSMCfg(CMDNAME_ISASETSPARE, CMDCODE_FUNC_SETSPARE_B,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
            return FCSAN_ERROR_CODE ; /* failed */
        }
    
    /* stop connect*/
    
    result=stop_iSMSMCfg(CMDNAME_ISASETSPARE, CMDCODE_FUNC_SETSPARE_B,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    return(result);
    printf("%s\n",COMMAND_SUCCESS_INFO);
    return FCSAN_SUCCESS_CODE;
    
} /* end of "setspare_b" */
int setspare_r(char *arr_name,unsigned char pd_g,unsigned char pd_n,int restart,int nounlock,int force)
{
    int result ;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMSpareBind spare_info;

    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETSPARE_R,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETSPARE,CMDCODE_FUNC_SETSPARE_R, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }
    iSMSM_INIT_SPAREBINDINFO(spare_info);
    spare_info.pdg=pd_g;
    spare_info.pdn =pd_n;
    result=iSMSMSetSpareUnbind (&api_info , spare_info);
    if (result == iSMSM_NORMAL)
        {
            printf("%s\n%-20s:%s\n%-20s:%02xh\n%-20s:%02xh\n\n",SPARE_RELEASE_LABEL,ARRAY_NAME_LABEL,
                arr_name,PD_GROUP_LABEL,pd_g,PD_NO_LABEL,pd_n);
        }
        else /* API error */
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETSPARE,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_SETSPARE_R,CMDCODE_TYPE_API+2,1);        
                stop_iSMSMCfg(CMDNAME_ISASETSPARE, CMDCODE_FUNC_SETSPARE_R,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
            return FCSAN_ERROR_CODE ; /* failed */
        }
    
    /* stop connect*/
    
    result=stop_iSMSMCfg(CMDNAME_ISASETSPARE, CMDCODE_FUNC_SETSPARE_R,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }
    printf("%s\n",COMMAND_SUCCESS_INFO);
    return FCSAN_SUCCESS_CODE;
    
} /* end of "setspare_r" */
