/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetarray.c,v 1.2301 2007/04/27 07:34:09 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAsetarray.c,v 1.2301 2007/04/27 07:34:09 liuyq Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAsetarray.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"
#include "iSMSMApi_cfg.h"

int main(int argc , char * argv[])
{
    char* array_name;
    char* ptype;
    char * result_time; //modified by hujun May. 6 2002
    unsigned char build_time=0;
    int restart = 0, nounlock = 0, force = 0, position = 0, result;
    unsigned char type;
    time_t the_time;
    struct tm * tm_time = NULL;


    if (argc==1)
    { /*print usage for all options */
        fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_CLD,USAGE_FOR_CA,USAGE_FOR_HELP);
        exit(FCSAN_ERROR_CODE); /* failed */
    }
    
    /* argc>=2 */
    if (strcmp(argv[1],OPTION_HELP)==0) 
    { /* Option is "-?" */
        if (argc==2)
        {
                fprintf(stdout,"%s\n%s\n%s\n",USAGE_FOR_CLD,USAGE_FOR_CA,USAGE_FOR_HELP);
                exit(FCSAN_SUCCESS_CODE); /* success */
        }
        else
        {
                fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_CLD,USAGE_FOR_CA,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* error */
        }
    }

    if (strcmp(argv[1],OPTION_CLD)==0)
    { /* Option is "-cld" */

        if (argc<8 || argc>11 || strcmp(argv[2],PARAM_ANAME)!=0 || strcmp(argv[4],PARAM_BLTIME)!=0
            || strcmp(argv[6],PARAM_PTYPE)!=0 
            || (strcmp(argv[7],PARAM_ALL)!=0 && strcmp(argv[7],PARAM_BASIC)!=0 && strcmp(argv[7],PARAM_DYNAMIC)!=0))
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_CLD,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        ptype = argv[7];
        if (isInvalidName(argv[3],ARRAY_NAME_MAX_LENGTH))
        {/* invalid array id */
            fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        array_name = argv[3];

        if(dec_char_unchar(argv[5],&build_time) || build_time>255){
            fprintf(stderr,"%s::%02u%03u:%s(-bltime:%s)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
            exit(FCSAN_ERROR_CODE); /* failed */                
        }

        position = 8;

        if(position<argc && strcmp(argv[position],PARAM_RESTART)==0){
            restart = 1;
            position++;
        }
        if(position<argc && strcmp(argv[position],PARAM_NOUNLOCK)==0){
            nounlock = 1;
            position++;
        }
        if(position<argc && strcmp(argv[position],PARAM_FORCE)==0){
            force = 1;
            position++;
        }
        if(position<argc){
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_CLD,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */        
        }

        /* call API */
        result = setarray_cld(array_name, build_time, restart, nounlock, force, ptype);
        exit(result);        

    } /* end of process of "-cld" */

    if (strcmp(argv[1],OPTION_CA)==0)
    { /* Option is "-ca" */

        if (argc<4 || argc>11 || strcmp(argv[2],PARAM_ANAME)!=0)
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_CA,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        if (isInvalidName(argv[3],ARRAY_NAME_MAX_LENGTH))
        {/* invalid array id */
            fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        array_name = argv[3];

        if(argc>=8 && strcmp(argv[4],PARAM_DATE)==0 && strcmp(argv[6],PARAM_TIME)==0){
            // get time from input
            tm_time = (struct tm*)malloc(sizeof(struct tm));
            if ( !tm_time ){/* Memory allocation failure */
                    fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETARRAY,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_SETARRAY_MAIN,
                        CMDCODE_TYPE_SYSTEMFUNC,1);
                    exit(FCSAN_ERROR_CODE);
            }
            result_time=(char *)strptime(argv[5],"%Y/%m/%e",tm_time);
            if(strlen(argv[5])!=10 || !result_time || strlen(result_time) || !check_date(tm_time->tm_year+1900, tm_time->tm_mon+1, tm_time->tm_mday)){
                fprintf(stderr,"%s::%02u%03u:%s(-date:%s)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                free(tm_time);
                exit(FCSAN_ERROR_CODE); /* failed */
            }
            result_time=(char *)strptime(argv[7], "%H:%M:%S",tm_time);
            if(strlen(argv[7])!=8 || !result_time || tm_time->tm_sec>59 || strlen(result_time)){
                fprintf(stderr,"%s::%02u%03u:%s(-time:%s)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
                free(tm_time);
                exit(FCSAN_ERROR_CODE); /* failed */
            }
            position = 8;
            type = iSMSMCFG_SET_SPECIFY_TIME;
        }else{
            // get time from local server
            time(&the_time);
            tm_time = localtime(&the_time);
            position = 4;
            type = iSMSMCFG_SET_SERVER_TIME;
        }

        if(position<argc && strcmp(argv[position],PARAM_RESTART)==0){
            restart = 1;
            position++;
        }
        if(position<argc && strcmp(argv[position],PARAM_NOUNLOCK)==0){
            nounlock = 1;
            position++;
        }
        if(position<argc && strcmp(argv[position],PARAM_FORCE)==0){
            force = 1;
            position++;
        }
        if(position<argc){
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_CA,USAGE_FOR_HELP);
            if (!tm_time)
                free(tm_time);
            exit(FCSAN_ERROR_CODE); /* failed */        
        }

        /* call API */
        result = setarray_ca(array_name, tm_time, restart, nounlock, force, type);
        if(type == iSMSMCFG_SET_SPECIFY_TIME)
            free(tm_time);
        exit(result);        

    } /* end of process "-ca" */
    
    /* wrong option;print all usages and exit abnormally */
    fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_CLD,USAGE_FOR_CA,USAGE_FOR_HELP);
    exit(FCSAN_ERROR_CODE);/* failed */

} /* end of "main" */

int setarray_cld(char *arr_name, unsigned char build_time, int restart, int nounlock, int force, char *ptype)
{
    int result;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMFormatTime format_time;

    if(!arr_name || strlen(arr_name)==0)
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETARRAY_CLD,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }

    result = start_iSMSMCfg(arr_name, CMDNAME_ISASETARRAY, CMDCODE_FUNC_SETARRAY_CLD, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if(result == FCSAN_ERROR_CODE)
        return result;

    iSMSM_INIT_FMTIMEINFO(format_time);
    format_time.formattime = build_time;
	if(strcmp(ptype, PARAM_ALL) == 0){
		format_time.pooltype = iSMSMCFG_BASIC_POOL;
		result = iSMSMSetFormatTime(&api_info, format_time);
	    if (result == iSMSM_NORMAL){
	    	format_time.pooltype = iSMSMCFG_DYNAMIC_POOL;
			result = iSMSMSetFormatTime(&api_info, format_time);    
	    }	
	}
	if(strcmp(ptype, PARAM_BASIC) == 0){
		format_time.pooltype = iSMSMCFG_BASIC_POOL;
		result = iSMSMSetFormatTime(&api_info, format_time);
	}
	if(strcmp(ptype, PARAM_DYNAMIC) == 0){
    	format_time.pooltype = iSMSMCFG_DYNAMIC_POOL;
		result = iSMSMSetFormatTime(&api_info, format_time);
	}

    if (result!=iSMSM_NORMAL)
    {
        stop_iSMSMCfg(CMDNAME_ISASETARRAY, CMDCODE_FUNC_SETARRAY_CLD, CMDCODE_TYPE_API+3, &api_info, nounlock, restart);
	fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETARRAY_CLD,CMDCODE_TYPE_API+2,1);        
        return FCSAN_ERROR_CODE; /* failed */
    }

    printf("%s\n",ISASETARRAY_CLD_LABEL);
    printf("%-20s:%s\n",ARRAY_NAME_LABEL,arr_name);
    printf("%-20s:%d\n",BUILD_TIME_LABEL,build_time);

    result=stop_iSMSMCfg(CMDNAME_ISASETARRAY, CMDCODE_FUNC_SETARRAY_CLD, CMDCODE_TYPE_API+3, &api_info, nounlock, restart);
    if(result == FCSAN_ERROR_CODE)
        return result;
    printf("\n%s\n",COMMAND_SUCCESS_INFO);
    fflush(stdout);
    return FCSAN_SUCCESS_CODE;
} /* end of "setarray_cld" */

int setarray_ca(char* arr_name, struct tm * tm_time, int restart, int nounlock, int force, unsigned char type)
{
    int result;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMAryDateTime date_time;
    
    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETARRAY_CA,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    if ( !tm_time)
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETARRAY_CA,CMDCODE_TYPE_INTERNAL,2);    
        return FCSAN_ERROR_CODE ; /* failed */
    }

    result = start_iSMSMCfg(arr_name, CMDNAME_ISASETARRAY, CMDCODE_FUNC_SETARRAY_CA, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if(result == FCSAN_ERROR_CODE)
        return result;

    iSMSM_INIT_ARYDATETIMEINFO(date_time);
    memcpy(&date_time.time_val,tm_time,sizeof(struct tm));
    date_time.type = type;

    result = iSMSMSetTimer(&api_info, date_time);
    if (result!=iSMSM_NORMAL)
    {
        stop_iSMSMCfg(CMDNAME_ISASETARRAY, CMDCODE_FUNC_SETARRAY_CA, CMDCODE_TYPE_API+3, &api_info, nounlock, restart);
	fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETARRAY,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETARRAY_CA,CMDCODE_TYPE_API+2,1);        
        return FCSAN_ERROR_CODE; /* failed */
    }

    printf("%s\n",ISASETARRAY_CA_LABEL);
    printf("%-20s:%s\n",ARRAY_NAME_LABEL,arr_name);
    if(type == iSMSMCFG_SET_SPECIFY_TIME){
        printf("%-20s:%d/%02d/%02d\n",DATE_LABEL,tm_time->tm_year+1900,tm_time->tm_mon+1,tm_time->tm_mday);
        printf("%-20s:%02d:%02d:%02d\n",TIME_LABEL,tm_time->tm_hour,tm_time->tm_min,tm_time->tm_sec);
    }else{
        printf("%-20s:%s\n",DATE_LABEL,"SERVER");
        printf("%-20s:%s\n",TIME_LABEL,"SERVER");
    }

    result=stop_iSMSMCfg(CMDNAME_ISASETARRAY, CMDCODE_FUNC_SETARRAY_CA, CMDCODE_TYPE_API+3, &api_info, nounlock, restart);
    if(result == FCSAN_ERROR_CODE)
        return result;
    printf("\n%s\n",COMMAND_SUCCESS_INFO);
    fflush(stdout);
    return FCSAN_SUCCESS_CODE;
} /* end of "setarray_ca" */

int check_date(int year, int month, int day){
    int leap; 

    if(year<2000 || year>2099)
        return 0;
    if(year<=0 || month<=0 || day<=0)
        return 0;
    if (year%4 == 0){
        if(year%100 == 0){
            if (year%400 == 0)  
                leap = 1;  
            else
                leap = 0;  
        }else
            leap = 1;  
    }else
        leap = 0;

    if(month == 2&& leap ==1){
        return (day<30);
    }
    if(month == 2&& leap ==0){
        return (day<29);
    }
    if(month ==4 || month ==6 || month ==9 || month ==11){
        return (day<31);
    }else if(month ==1 || month ==3 || month ==5 || month == 7 || month ==8 || month ==10  || month ==12)
        return (day<32);
    else
        return 0;
}
