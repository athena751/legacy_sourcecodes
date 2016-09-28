/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetname.c,v 1.2301 2005/09/28 01:13:30 liyb Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAsetname.c,v 1.2301 2005/09/28 01:13:30 liyb Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAsetname.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"

int main(int argc , char * argv[])
{
    
    unsigned char array_id ;
    unsigned char dir_num;
    unsigned char port_num;
    unsigned short ld_num;
    int result;

    if (argc==1)
    { /*print usage for all options */
        fprintf(stderr,"%s\n%s\n%s\n%s\n%s\n",USAGE_FOR_SA,USAGE_FOR_SP,USAGE_FOR_SL,USAGE_FOR_SPOOL,USAGE_FOR_HELP);
        exit(FCSAN_ERROR_CODE); /* failed */
    }
    
    /* argc>=2 */
    if (strcmp(argv[1],OPTION_HELP)==0) 
    { /* Option is "-?" */
        if (argc==2)
        {
                printf("%s\n%s\n%s\n%s\n%s\n",USAGE_FOR_SA,USAGE_FOR_SP,USAGE_FOR_SL,USAGE_FOR_SPOOL, USAGE_FOR_HELP);
                exit(FCSAN_SUCCESS_CODE); /* success */
        }
        else
        {
                fprintf(stderr,"%s\n%s\n%s\n%s\n%s\n",USAGE_FOR_SA,USAGE_FOR_SP,USAGE_FOR_SL,USAGE_FOR_SPOOL,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* error */
        }
    }

    if (strcmp(argv[1],OPTION_SA)==0)
    { /* Option is "-sa" */

        if (argc!=6 || strcmp(argv[2],PARAM_AID)!=0 || strcmp(argv[4],PARAM_NAME)!=0)
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_SA,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        if (convert_arrayid(argv[3],&array_id))
        {/* invalid array id */
            fprintf(stderr,"%s::%02u%03u:%s(aid:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        if (isInvalidName(argv[5],ARRAY_NAME_MAX_LENGTH))
        {/* invalid array name */
            fprintf(stderr,"%s::%02u%03u:%s(arrayname:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        /* call API */
        result=setName_sa(array_id , argv[5] ) ;
        exit(result) ;
        
    } /* end of process of "-sa" */

    if (strcmp(argv[1],OPTION_SP)==0)
    { /* Option is "-sp" */

        if (argc!=8 || strcmp(argv[2],PARAM_AID)!=0 || 
            strcmp(argv[4],PARAM_PORT)!=0 || strcmp(argv[6],PARAM_NAME)!=0)
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_SP,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if ( convert_arrayid(argv[3],&array_id))
        {/* invalid array id */
            fprintf(stderr,"%s::%02u%03u:%s(aid:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        if ( convert_port_rank_no(argv[5],&dir_num,&port_num))
        {/* invalid "port_no" */
            fprintf(stderr,"%s::%02u%03u:%s(portno:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if (isInvalidName(argv[7],PORT_NAME_MAX_LENGTH))
        {/* invalid array name */
            fprintf(stderr,"%s::%02u%03u:%s(portname:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        /* call API */
        result=setName_sp(array_id , dir_num,port_num , argv[7]);
        exit(result);        

    } /* end of process "-sp" */

    if (strcmp(argv[1],OPTION_SL)==0)
    { /* Option is "-sl" */
        
        if (argc!=10 || strcmp(argv[2],PARAM_AID)!=0 ||
            strcmp(argv[4],PARAM_LD)!=0 || strcmp(argv[6],PARAM_LDTYPE)!=0 ||
            strcmp(argv[8],PARAM_NAME)!=0)
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_SL,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if (convert_arrayid(argv[3],&array_id))
        {/* invalid array id */
            fprintf(stderr,"%s::%02u%03u:%s(aid:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if (convert_ldno(argv[5],&ld_num))
        {/* invalid "ld_no" */
            fprintf(stderr,"%s::%02u%03u:%s(ldno:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if (isInvalidName(argv[9],LD_NAME_MAX_LENGTH))
        {/* invalid array name */
            fprintf(stderr,"%s::%02u%03u:%s(ldname:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[9]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if (isInvalidLdType(argv[7]))
        {/* invalid ld type */
            fprintf(stderr,"%s::%02u%03u:%s(ldtype:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        /* call API */
        result=setName_sl(array_id , ld_num , argv[7] , argv[9]);
        exit(result);
    
    } /* end of process of "-sl" */

// iSAsetname -spool -aname array_name -oldname pool_oldname 
//                              -newname pool_newname [-restart] [-nounlock] [-force]
    if (strcmp(argv[1],OPTION_SPOOL)==0)
    { /* Option is "-spool" */
        int restart=0;
	 int nounlock=0;
	 int force=0;

	 int position=0;
		
	 
        if (argc<8|| argc>11
	     || strcmp(argv[2],PARAM_ANAME)!=0 
	     ||strcmp(argv[4],PARAM_POOLNAME_OLD)!=0 
	     ||strcmp(argv[6],PARAM_POOLNAME_NEW)!=0 
            ) {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_SPOOL,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

//to invalidate array name
	if (isInvalidName(argv[3],ARRAY_NAME_MAX_LENGTH))
        {
            fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
//to invalidate pool old name
	if (isInvalidName(argv[5],POOL_NAME_MAX_LENGTH))
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,PARAM_POOLNAME_OLD,argv[5]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
//to invalidate pool new name
	if (isInvalidName(argv[7],POOL_NAME_MAX_LENGTH))
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s:%s)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,PARAM_POOLNAME_NEW,argv[7]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        position = 8;

        if(position+1<=argc && strcmp(argv[position],PARAM_RESTART)==0){
            restart = 1;
            position++;
        }
        if(position+1<=argc && strcmp(argv[position],PARAM_NOUNLOCK)==0){
            nounlock = 1;
            position++;
        }
        if(position+1<=argc && strcmp(argv[position],PARAM_FORCE)==0){
            force = 1;
            position++;
        }
        if(position+1<=argc){
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_SPOOL,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */        
        }
	 /* call API */
        result=setName_spool(argv[3], argv[5], argv[7], restart, nounlock, force);
	 exit(result);  
    }
    /* wrong option;print all usages and exit abnormally */
    fprintf(stderr,"%s\n%s\n%s\n%s\n",USAGE_FOR_SA,USAGE_FOR_SP,USAGE_FOR_SL,USAGE_FOR_SPOOL,USAGE_FOR_HELP);
    exit(FCSAN_ERROR_CODE);/* failed */

} /* end of "main" */

int setName_sa(unsigned char array_id , char* new_name )
{

    int result ;
    if ( !new_name || strlen(new_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SA,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }    
    result=iSMSMSetAryName(array_id , new_name) ;    
    if (result==iSMSM_NORMAL)
    {
        printf("%s:%04u\n%s:%s\n%s\n",ARRAY_ID_LABEL,array_id,ARRAY_NAME_LABEL,new_name,COMMAND_SUCCESS_INFO);
        return FCSAN_SUCCESS_CODE; /* success */
    }
    else
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SA,CMDCODE_TYPE_API,1);        
        return FCSAN_ERROR_CODE; /* failed */
    }

} /* end of "setName_sa" */

int setName_sp(unsigned char array_id , unsigned char dir_num, unsigned char port_num, char * port_name )
{

    iSMSMPortId portID ;
    int result ;
    
    if ( !port_name || strlen(port_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SP,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
/* modified by chs & key & hujun, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(portID);
    
    portID.dir_num=dir_num ;
    portID.port_num=port_num ;
    portID.array_id=array_id ;
    result= iSMSMSetPortName(&portID, port_name) ;
    if (result == iSMSM_NORMAL)
    {
        printf("%s:%04u\t%s:%02uh-%02uh\n%s:%s\n%s\n",ARRAY_ID_LABEL,
            array_id,PORT_NO_LABEL,dir_num,port_num,PORT_NAME_LABEL,
            port_name,COMMAND_SUCCESS_INFO);
        return FCSAN_SUCCESS_CODE; /* success */
    }
    else /* API error */
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SP,CMDCODE_TYPE_API,1);        
        return FCSAN_ERROR_CODE ; /* failed */
    }

} /* end of "setName_sp" */

int setName_sl(unsigned char array_id , unsigned short ld_num, char * ld_type, char * ld_name )
{

    iSMSMLdId ldID ;
    int result ;
    
    /* check parameters */
    if ( !ld_type || strlen(ld_type)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SL,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    if ( !ld_name || strlen(ld_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SL,CMDCODE_TYPE_INTERNAL,2);    
        return FCSAN_ERROR_CODE ; /* failed */
    }

/* modified by chs & key & hujun, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ldID);

    /* call API */
    ldID.array_id= array_id ;
    ldID.ld_num=ld_num ;
    result= iSMSMSetLdName(&ldID, ld_type, ld_name);
    if (result==iSMSM_NORMAL)
    {
        printf("%s:%04u\t%s:%04xh\n%s:%s\t%s:%s\n%s\n",ARRAY_ID_LABEL
            ,array_id,LD_NO_LABEL,ld_num,LD_TYPE_LABEL,ld_type
            ,LD_NAME_LABEL,ld_name,COMMAND_SUCCESS_INFO);
        return FCSAN_SUCCESS_CODE; /* success */
    }
    else /*API error*/
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETNAME_SL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE; /* failed */
    }

} /* end of "setName_sl" */

//to change pool's name , liyb 20050920
int setName_spool(char * arr_name ,  char* oldname , char* newname, int restart,int nounlock,int force )
{  
    int result=1;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMNickname nickName;
	
//start server	
    result = start_iSMSMCfg(arr_name, CMDNAME_ISASETNAME, CMDCODE_FUNC_SETNAME_SPOOL, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if(result == FCSAN_ERROR_CODE){
       return result;
    }
	
//init nickname
    iSMSM_INIT_NICKNAMEINFO(nickName);
    nickName.type = iSMSMCFG_SETPOOLNAME;
    nickName.smode = iSMSMCFG_SPECIFY_NAME;
    strncpy(nickName.oldname,oldname,strlen(oldname));
    strncpy(nickName.newname,newname,strlen(newname));
	
//change name
    result = iSMSMSetNickname(&api_info, nickName);
    if (result!=iSMSM_NORMAL)
     {
       stop_iSMSMCfg(CMDNAME_ISASETNAME, CMDCODE_FUNC_SETNAME_SPOOL, CMDCODE_TYPE_API+1, &api_info, nounlock, restart);

	fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETNAME,MSGNO_FCSAN_PREFIX,
       MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
       CMDCODE_FUNC_SETNAME_SL,CMDCODE_TYPE_API+1,1);
   
       return FCSAN_ERROR_CODE; /* failed */
     }
	
//stop server
    result=stop_iSMSMCfg(CMDNAME_ISASETNAME, CMDCODE_FUNC_SETNAME_SPOOL, CMDCODE_TYPE_API+1, &api_info, nounlock, restart);
    if(result == FCSAN_ERROR_CODE)
        return result;
    printf("\n%s\n",COMMAND_SUCCESS_INFO);
    fflush(stdout);
    return FCSAN_SUCCESS_CODE;
}






















































































