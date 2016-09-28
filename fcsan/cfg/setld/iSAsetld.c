/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetld.c,v 1.2304 2007/05/10 04:50:46 xingyh Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAsetld.c,v 1.2304 2007/05/10 04:50:46 xingyh Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAsetld.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"
#include "iSMSMApi_cfg.h"

int main(int argc , char * argv[])
{
    char* arrayname;
    unsigned char pd_group;
    unsigned char rank_no;
    unsigned int count=1;  // from 0 to MAXLDN, total MAXLDN+1
    double ld_size;
    unsigned short ld_no;
    unsigned char array_id;
    unsigned short start_ld_no;
    unsigned long long start_addr = 0xffffffffffffffff;
    unsigned long start_addr_low = 0xffffffff, start_addr_high = 0xffffffff;  /* set 0xffffffff*/
    unsigned char syscapa = iSMSMCFG_EXCLUDE_SYSCAPA;
    unsigned char owner = iSMSMCFG_OWNERSHIP_CNT0;
    char* ld_type="";
    char* ld_name="";
    unsigned char build_time=0xff;
    int restart=0, nounlock=0, force=0;
    int position = 0, result;
    int array_id_set = 0, start_ld_no_set = 0, syscapa_set = 0, start_addr_set = 0, owner_set = 0, build_time_set = 0, count_set = 0;
    unsigned short* ldnArray=NULL;

    //add  poolname by liyb  20050831
    char* pool_name=NULL;
    /* v5.1 quick bind  add by xingyh */
    int quick_format = 0, dynmc_fmt_time = 0;
    
    if (argc==1)
    { /*print usage for all options */
        fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_B,USAGE_FOR_R,USAGE_FOR_HELP);//delete USAGE_FOR_C,  liyb 20050831
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
                exit(FCSAN_ERROR_CODE); /* failed */         
        }
    }

    if (strcmp(argv[1],OPTION_B)==0)
    { /* Option is "-b" */

        //after changement      liyb 20050831
	    if (argc<MIN_PARAM_NUM||argc>MAX_PARAM_NUM||strcmp(argv[2],PARAM_ANAME)!=0||strcmp(argv[4],PARAM_POOLNAME)!=0)
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        if (isInvalidName(argv[3],ARRAY_NAME_MAX_LENGTH))
        {
            fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        arrayname = argv[3];
        //add to valide poolname  liyb 20050831
        if (isInvalidName(argv[5],POOL_NAME_MAX_LENGTH))
        {
            fprintf(stderr,"%s::%02u%03u:%s(-pname:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
	 
	    pool_name= argv[5];

        position = 6;  //   position = 8;  changed by liyb ,20050831
        if(strcmp(argv[position],PARAM_LDCOUNT)==0){
            if(convert_lcount(argv[position+1],&count) || count==0 || count>MAXLDN+1)
            {
                fprintf(stderr,"%s::%02u%03u:%s(-ldcount:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                exit(FCSAN_ERROR_CODE); /* failed */
            }
            count_set = 1;
            position+=2;
        }

        if(strcmp(argv[position],PARAM_LDSZ)==0){
	    
            ld_size=atof(argv[position+1]);
         
            //validate ldsize    liyb  20050831
	        if(ld_size<MIN_LD_SIZE ||ld_size>MAX_LD_SIZE)//||floor(ld_size*10)/10.0!=ld_size
	     	{
	            fprintf(stderr,"%s::%02u%03u:%s(-ldze:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                exit(FCSAN_ERROR_CODE); /* failed */
	     	}
	        position+=2;
        }else{
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }

        if(position+2<=argc){
            if(strcmp(argv[position],PARAM_LDN)==0){
                array_id_set=0;
                if(convert_ldno(argv[position+1],&ld_no) || count!=1){
                    fprintf(stderr,"%s::%02u%03u:%s(-ldn:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                    MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                    exit(FCSAN_ERROR_CODE); /* failed */                
                }
                position+=2;
            }else if(strcmp(argv[position],PARAM_AID)==0){
                array_id_set=1;
                if(convert_arrayid(argv[position+1],&array_id)){
                    fprintf(stderr,"%s::%02u%03u:%s(-aid:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                    MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                    exit(FCSAN_ERROR_CODE); /* failed */                
                }
                position+=2;
                if(position+2<=argc && strcmp(argv[position],PARAM_SLDNO)==0){
                    if(convert_ldno(argv[position+1],&start_ld_no)){
                        fprintf(stderr,"%s::%02u%03u:%s(-sldno:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                        MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                        exit(FCSAN_ERROR_CODE); /* failed */                
                    }
                    position+=2;
                    start_ld_no_set = 1;
                }
            }else{
                fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* failed */        
            }
        }else{
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */        
        }

        if(position+2<=argc && strcmp(argv[position],PARAM_START)==0){
            if(address_char_unlonglong(argv[position+1],&start_addr,&start_addr_high,&start_addr_low)){
                fprintf(stderr,"%s::%02u%03u:%s(-start:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                exit(FCSAN_ERROR_CODE); /* failed */                
            }
            position+=2;
            start_addr_set = 1;
        }

        if(position+1<=argc && strcmp(argv[position],PARAM_SYSCAPA)==0){
            syscapa = iSMSMCFG_INCLUDE_SYSCAPA;
            position++;
            syscapa_set = 1;
        }

        if (position+1<argc)
        {
            if (!strcmp(argv[position],PARAM_LDTYPE))
            { /* specified "-ldtype" */
                if (position+3>=argc || strcmp(argv[position+2],PARAM_NAME))
                { /* missing "-name" or its value */
                    fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
                    exit(FCSAN_ERROR_CODE); /* failed */    
                }
                if(isInvalidLdType(argv[position+1]))
                {
                    fprintf(stderr,"%s::%02u%03u:%s(-ldtype:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                        MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                    exit(FCSAN_ERROR_CODE); /* failed */                
                }
                ld_type = argv[position+1];
                position+=2;
            }
            /* no "-ldtype" or "-ldtype type" matched */
            if (!strcmp(argv[position],PARAM_NAME))
            { /* Specified "-name" */
                if ((count_set&&isInvalidName(argv[position+1],LD_NAME_MAX_LENGTH-(count_set?strlen(argv[9]):0)))||
                   (!count_set&&isInvalidName(argv[position+1],LD_NAME_MAX_LENGTH))){ /// name length
                        fprintf(stderr,"%s::%02u%03u:%s(-ldname:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                        exit(FCSAN_ERROR_CODE); /* failed */                
                }
                ld_name = argv[position+1];
                position+=2;
            }
        }        

        if(position+2<=argc && strcmp(argv[position],PARAM_BLTIME)==0){
            if(dec_char_unchar(argv[position+1],&build_time) || build_time > MAX_BUILD_TIME){ /* V5.1 max build time is 255 */
                fprintf(stderr,"%s::%02u%03u:%s(-bltime:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[position+1]);
                exit(FCSAN_ERROR_CODE); /* failed */                
            }
            position += 2;
            build_time_set = 1;
        }

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
        /* v5.1 quick bind add  by xingyh 2007/04/27 */
        if(position+1<=argc && strcmp(argv[position],PARAM_QUICK_FORMAT)==0){
            quick_format = 1;
            /* v5.1 when the qck_format is setted ,ld_type must be set*/
            if(strlen(ld_type)==0){/* ld_type is missing*/
                fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
                exit(FCSAN_ERROR_CODE); /* failed */      
            }
            position++;
        }
        if(position+1<=argc && strcmp(argv[position],PARAM_DYNMC_FORMAT_TIME)==0){
            dynmc_fmt_time = 1;
            position++;
        }
        /* add by xingyh over */
       
        if(position+1<=argc){
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_B,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */        
        }
        /* call API */

        ldnArray = (unsigned short *)malloc(count*sizeof(unsigned short));
        if ( !ldnArray ){/* Memory allocation failure */
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_SETLD_MAIN,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        if(array_id_set == 0){
            ldnArray[0] = ld_no;
        }else{
            if(getldnarray(array_id,count,ldnArray,start_ld_no_set,start_ld_no)){
                free(ldnArray);
                exit(FCSAN_ERROR_CODE);
            }
        }
	    result=setld_b(arrayname, pool_name,  ld_size, array_id, 
		               start_ld_no, start_addr,start_addr_high,start_addr_low, syscapa, ld_type,
		               ld_name, build_time, restart, nounlock, force, count, ldnArray, syscapa_set,
                       start_ld_no_set, array_id_set, start_addr_set, 
                       build_time_set, count_set, quick_format, dynmc_fmt_time);

        free(ldnArray);
        exit(result) ;
    } /* end of process of "-sa" */


    // option_r with anyting changed  liyb 20050831
    if (strcmp(argv[1],OPTION_R)==0)
    { /* Option is "-r" */

        if (argc<6 || argc>9 || strcmp(argv[2],PARAM_ANAME)!=0)
        {/* wrong command */
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_R,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        
        if (isInvalidName(argv[3],ARRAY_NAME_MAX_LENGTH))
        {/* invalid array id */
            fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        arrayname = argv[3];
        if (strcmp(argv[4],PARAM_LDN)==0){
            if(convert_ldno(argv[5],&ld_no)){
                fprintf(stderr,"%s::%02u%03u:%s(-ldn:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE); /* failed */                
            }
        }else if(strcmp(argv[4],PARAM_LDNAME)==0){
            if(isInvalidTypeName(argv[5],LD_TYPE_MAX_LENGTH,LD_NAME_MAX_LENGTH)){
                fprintf(stderr,"%s::%02u%03u:%s(-ldname:%s)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE); /* failed */                
            }
            ld_name = argv[5];
        }else{
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_R,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */
        }
        position = 6;

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
            fprintf(stderr,"%s\n%s\n",USAGE_FOR_R,USAGE_FOR_HELP);
            exit(FCSAN_ERROR_CODE); /* failed */        
        }

        /* call API */
        result=setld_r(arrayname, ld_no, ld_name, restart, nounlock, force);
        exit(result);        

    } /* end of process "-r" */


    /* wrong option;print all usages and exit abnormally */
    fprintf(stderr,"%s\n%s\n%s\n",USAGE_FOR_B,USAGE_FOR_R,USAGE_FOR_HELP);
    exit(FCSAN_ERROR_CODE);/* failed */

} /* end of "main" */

  /* change function parameter   liyb 20050831
   * int setld_b(char * arr_name , unsigned char pd_group, unsigned char rank_no, double ld_size, unsigned char array_id, unsigned short start_ld_no, unsigned long start_addr, unsigned char syscapa, unsigned char owner, char * ld_type, char * ld_name, unsigned char build_time, int restart, int nounlock, int force, unsigned int length, unsigned short* ldn_array, int syscapa_set, int start_ld_no_set, int array_id_set, int start_addr_set, int owner_set, int build_time_set, int count_set)
   * v5.1 quick bind adding two parameters quick_format dynmc_fmt_time  
   */
  int setld_b(char * arr_name ,  char* pool_name,
        double ld_size, unsigned char array_id, unsigned short start_ld_no, unsigned long long start_addr, unsigned long start_addr_high,unsigned long start_addr_low,
        unsigned char syscapa, char * ld_type, char * ld_name, unsigned char build_time,
        int restart, int nounlock, int force, unsigned int length, unsigned short* ldn_array,
        int syscapa_set, int start_ld_no_set, int array_id_set, 
        int start_addr_set,  int build_time_set, int count_set, int quick_format, int dynmc_fmt_time)
{
    int result,i;
    char temp[NICKNAME_LENGTH];
    iSMSMCfg_APIinfo_t api_info;
    iSMSMLdBind ldBind;
    iSMSMNickname nickName;
    char buf[10];
    char print_ld_name[LD_NAME_MAX_LENGTH+1];
    char print_ld_type[5];
    unsigned long long capacity = 0;
    
    /* V5.1 add by xingyh for store high and low bytes*/
    unsigned long capacity_high = 0, capacity_low = 0; 
    //added by liyb 20050831
    iSMSMPoolInfo  iPoolInfo;

    if ( !arr_name || strlen(arr_name)==0 || !ld_type || !ld_name )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETLD_B,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    if ( !ldn_array )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETLD_B,CMDCODE_TYPE_INTERNAL,2);    
        return FCSAN_ERROR_CODE ; /* failed */
    }

    result = start_iSMSMCfg(arr_name, CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_B, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if(result == FCSAN_ERROR_CODE){
        return result;
    }
    iSMSM_INIT_NICKNAMEINFO(nickName);
    nickName.type = iSMSMCFG_SETLDNAME;
    nickName.smode = iSMSMCFG_SPECIFY_NUMBER;
    /* Setting public infomation of LDs */
    
    /* compute the capacity blocks */
    compute_size_block(ld_size,syscapa_set,&capacity, &capacity_high, &capacity_low);
    
    /* Set iPoolInfo struct modify by xingyh 2007/04/027*/
    iSMSM_INIT_POOLLDBINDINFO2(ldBind, iPoolInfo);
    
    iPoolInfo.para_mode=iSMSMCFG_SPECIFY_NAME;
    iPoolInfo.start_addr_high = start_addr_high;
    iPoolInfo.capacity_high = capacity_high;
    if(quick_format == 1){ /* set quick bind v5.1 add*/
        iPoolInfo.quick_format = ISMSM_QUICK_FORMAT_ON;
        strcpy(iPoolInfo.ld_type,ld_type);
        
    }else{
        iPoolInfo.quick_format = ISMSM_QUICK_FORMAT_OFF;
    }    
    strncpy(iPoolInfo.pool_name,pool_name,strlen(pool_name));
        
    /* Set ldBind struct */
    if( dynmc_fmt_time == 1){/* set format time v5.1 add */
        ldBind.fmt_time_ex = iSMSMCFG_DYNAMIC_FMT_TIME_ON;
    }else{
        ldBind.fmt_time_ex = iSMSMCFG_DYNAMIC_FMT_TIME_OFF;
        build_time = 0xff; /* when the fmt_time_ex is OFF the build_time must be oxff*/
    } 
    ldBind.capacity=capacity_low;
    ldBind.boundary=iSMSMCFG_BONND_MB;
    ldBind.capa_type=syscapa;	 
    ldBind.start_addr=start_addr_low;
    ldBind.fmt_time=build_time;
    /* End Setting struct   */
    
    /* Print the public informations */
    printf("%s\n",ISASETLD_B_LABEL);
    printf("%-20s:%s\n",ARRAY_NAME_LABEL,arr_name);
    printf("%-20s:%s\n",POOL_NAME_LABEL,pool_name);  
    printf("%-20s:%u\n",LD_COUNT_LABEL,length);
    printf("%-20s:%-6.1f\n",LD_SIZE_LABEL,ld_size);  
    if(syscapa_set)
        printf("%-20s:%s\n",SYSCAPA_LABEL,(syscapa==iSMSMCFG_INCLUDE_SYSCAPA?"yes":"no"));
    if(array_id_set)
        printf("%-20s:%04u\n",ARRAY_ID_LABEL,array_id);
    if(start_ld_no_set)
        printf("%-20s:%04xh\n",START_LD_NO_LABEL,start_ld_no);
    if(start_addr_set)
        printf("%-20s:0x%08llx\n",START_ADDR_LABEL,start_addr);/*xingyh */
    if(build_time_set)
        printf("%-20s:%u\n",BUILD_TIME_LABEL,build_time);
    printf("\n%-10s%-10s%-30s%-20s\n",LD_NO_LABEL,LD_TYPE_LABEL,LD_NAME_LABEL,LD_BUILD_SIZE);
    printf("-------------------------------------------------------------------\n");
    /* End of printing the public informations */
    
    /* Setting and printing private infomation for each LDs */
    for(i=0;i<length;i++){
        ldBind.ldn=ldn_array[i];
        
        result = iSMSMSetLdBind(&api_info, ldBind);
        if (result!=iSMSM_NORMAL)
        {
	        fflush(stdout);  /*added by changhs 2002/07/01*/
            stop_iSMSMCfg(CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_B, CMDCODE_TYPE_API+4, &api_info, nounlock, restart);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_SETLD_B,CMDCODE_TYPE_API+2,i+1);
                    
            return FCSAN_ERROR_CODE; /* failed */
        }
        if( strlen(ld_name)!=0){ /* changed by Yang Aihua */
            if( quick_format == 0 ){ /* when did not set quick bind  set nick name v5.1 add*/
                temp[0] = '\0';
                strcpy(print_ld_name,ld_name);
                strcpy(print_ld_type,ld_type);
                if( count_set == 1){
                    sprintf(buf,"%d",i+1);
                    strcat(print_ld_name,buf);
                }
                strcat(strcat(strcat(temp,ld_type),":"),print_ld_name);
                strcpy(nickName.newname,temp);
                nickName.number = ldn_array[i];
                result=iSMSMSetNickname(&api_info, nickName);
                if (result!=iSMSM_NORMAL)
                {
                    stop_iSMSMCfg(CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_B, CMDCODE_TYPE_API+4, &api_info, nounlock, restart);
                    fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                        MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                        CMDCODE_FUNC_SETLD_B,CMDCODE_TYPE_API+3,i+1);         
                    return FCSAN_ERROR_CODE; /* failed */
                } 
            }else{/* when set quick bind print default ld_name but ld_type is real v5.1  add */
                strcpy(print_ld_name,"<default>");
                strcpy(print_ld_type,ld_type);
            }  
        }else{/* when did not give a name set default ld_name and ld_type*/
            strcpy(print_ld_name,"<default>");
            strcpy(print_ld_type,"--");
        }
        printf("%04xh     %-10s%-30s%10llu\n",ldn_array[i],print_ld_type,print_ld_name,capacity);//ld_size/512); changed by liyb 20050831
    }

    result=stop_iSMSMCfg(CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_B, CMDCODE_TYPE_API+4, &api_info, nounlock, restart);
    if(result == FCSAN_ERROR_CODE){
        return result;
    }
    printf("\n%s\n",COMMAND_SUCCESS_INFO);
    fflush(stdout);
    return FCSAN_SUCCESS_CODE;
} /* end of "setld_b" */

//this function is kept unchanged. 
int setld_r(char* arr_name, unsigned short ld_no, char * ld_name, int restart, int nounlock, int force)
{
    int result;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMLdUnbind ldUnbind;
    
    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETLD_R,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }

    result = start_iSMSMCfg(arr_name, CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_R, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if(result == FCSAN_ERROR_CODE)
        return result;

    iSMSM_INIT_LDUNBINDINFO(ldUnbind);
    if(ld_name == NULL || strlen(ld_name)==0){
        ldUnbind.ldmode = iSMSMCFG_SPECIFY_NUMBER;
        ldUnbind.ldn = ld_no;
    }else{
        ldUnbind.ldmode =iSMSMCFG_SPECIFY_NAME;
        strcpy(ldUnbind.ldname,ld_name);
        }
    result = iSMSMSetLdUnbind(&api_info, ldUnbind);

    if (result!=iSMSM_NORMAL)
    {
        stop_iSMSMCfg(CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_R, CMDCODE_TYPE_API+3, &api_info, nounlock, restart);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_SETLD_R,CMDCODE_TYPE_API+2,1);        
        return FCSAN_ERROR_CODE; /* failed */
    }

// output
    printf("%s\n",ISASETLD_R_LABEL);
    printf("%-20s:%s\n",ARRAY_NAME_LABEL,arr_name);
    if(ld_name == NULL || strlen(ld_name)==0){
        printf("%-20s:%04xh\n",LD_NO_LABEL,ld_no);    
    }else{
        printf("%-20s:%s\n",LD_NAME_LABEL,ld_name);
    }
    result=stop_iSMSMCfg(CMDNAME_ISASETLD, CMDCODE_FUNC_SETLD_R, CMDCODE_TYPE_API+3, &api_info, nounlock, restart);
    if(result == FCSAN_ERROR_CODE)
        return result;
    printf("\n%s\n",COMMAND_SUCCESS_INFO);
    fflush(stdout);
    return FCSAN_SUCCESS_CODE;
} /* end of "setld_r" */


//deleted setld_c(),just because this function only changes owner
//int setld_c(char *arr_name, unsigned short ld_no, unsigned char owner, int restart, int nounlock, int force)


int getldnarray(unsigned char array_id, unsigned int length, unsigned short * ldnArray, int start_ld_no_set, unsigned short start_ld_no)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMLd *LDdata;
    unsigned int loop_count_ld=3;
    int i,j,k;
    unsigned int get_num, next_ldn=MAXLDN+1;
    int result, lcount = 128;

     i_inf.data = NULL;

    if(start_ld_no_set==0){  // default start_ld_no
         result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
         if (result!=iSMSM_NORMAL)
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_SETLD_GETLDNARRAY,CMDCODE_TYPE_API,1);
            return FCSAN_ERROR_CODE;
        }
        if(o_inf.remain_num != 0){
            i_inf.current_num = o_inf.remain_num;
            i_inf.table_rev = iSMSM_TBL_FIRST;
            i_inf.get_num = 1;  
            i_inf.data_size=sizeof(iSMSMLd);
            i_inf.data=calloc(1,sizeof(iSMSMLd));
            if ( !i_inf.data ){
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_SETLD_GETLDNARRAY,
                    CMDCODE_TYPE_SYSTEMFUNC,1);
                return FCSAN_ERROR_CODE;
            }
               result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
            if (result!=iSMSM_NORMAL){
                fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                    CMDCODE_FUNC_SETLD_GETLDNARRAY,CMDCODE_TYPE_API,2);
                free(i_inf.data);
                return FCSAN_ERROR_CODE;
            }
            LDdata = (iSMSMLd*)i_inf.data;
            i_inf.current_num+=o_inf.return_num;
            i_inf.table_rev=o_inf.table_rev;
            next_ldn = LDdata[0].ld_num;
            free(LDdata);
            if(MAXLDN-next_ldn<length){//  which type error?
                    fprintf(stderr,"%s::%02u%03u:%s(-ldcount:%d)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                        MSGNO_PARAM_ERROR,PARAM_ERR_INFO,length);
                    return FCSAN_ERROR_CODE;
            }
            for (i=0;i<length;i++){
                ldnArray[i] = (unsigned short)next_ldn+1+i;
            }
        }else
            for (i=0;i<length;i++)
                ldnArray[i] = (unsigned short)i;
    }else{ // specified start_ld_no
         result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
         if (result!=iSMSM_NORMAL)
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_SETLD_GETLDNARRAY,CMDCODE_TYPE_API,loop_count_ld++);
            return FCSAN_ERROR_CODE;
        }
        if(o_inf.remain_num == 0){
            next_ldn = MAXLDN+1;
            o_inf.return_num = 1;
        }else{
            i_inf.current_num = 1;
            i_inf.table_rev = iSMSM_TBL_FIRST;
            get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
            i_inf.get_num = get_num ;
            i_inf.data_size = get_num*sizeof(iSMSMLd);
               /* Memory Allocation */
            i_inf.data=calloc(get_num,sizeof(iSMSMLd));
            if ( !i_inf.data ){/* Memory allocation failure */
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_SETLD_GETLDNARRAY,
                    CMDCODE_TYPE_SYSTEMFUNC,2);
                return FCSAN_ERROR_CODE;
            }
            result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
            if (result!=iSMSM_NORMAL){/* API error */
                fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                    CMDCODE_FUNC_SETLD_GETLDNARRAY,CMDCODE_TYPE_API,loop_count_ld++);
                free(i_inf.data);
                return FCSAN_ERROR_CODE;
            }
            LDdata = (iSMSMLd*)i_inf.data;
            next_ldn=LDdata[0].ld_num;
            i_inf.current_num+=o_inf.return_num;
            i_inf.table_rev=o_inf.table_rev;
        }
        for(i=start_ld_no,j=0,k=0;i<MAXLDN+1&&j<length;){
            if(k==o_inf.return_num){
                k=0;
                if(o_inf.remain_num == 0){
                    next_ldn = MAXLDN+1;
                    o_inf.return_num = 1;
                }else{
                    free(i_inf.data);
                    get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
                    i_inf.get_num = get_num ;
                    i_inf.data_size = get_num*sizeof(iSMSMLd);
                       /* Memory Allocation */
                    i_inf.data=calloc(get_num,sizeof(iSMSMLd));
                    if ( !i_inf.data ){/* Memory allocation failure */
                        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                            COMMAND_CODE_LABEL,CMDCODE_FUNC_SETLD_GETLDNARRAY,
                            CMDCODE_TYPE_SYSTEMFUNC,2);
                        return FCSAN_ERROR_CODE;
                    }
                    result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
                    if (result!=iSMSM_NORMAL){/* API error */
                        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETLD,
                            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                            CMDCODE_FUNC_SETLD_GETLDNARRAY,CMDCODE_TYPE_API+1,loop_count_ld++);
                        free(i_inf.data);
                        return FCSAN_ERROR_CODE;
                    }
                    LDdata = (iSMSMLd*)i_inf.data;
                    i_inf.current_num+=o_inf.return_num;
                    i_inf.table_rev=o_inf.table_rev;
                    if(length-j>MAXLDN-i-o_inf.remain_num+1){
                        i=MAXLDN+1;
                    }
                }
            }
            if(next_ldn!=MAXLDN+1)
                next_ldn = LDdata[k].ld_num;
            if(next_ldn==i){
                i++;
                k++;
            }else if(next_ldn>i){
                ldnArray[j] = (unsigned short)i;
                i++;
                j++;
            }else
                k++;
        }
        free(i_inf.data);
        if(j<length){
            fprintf(stderr,"%s::%02u%03u:%s(-ldcount:%d)\n",CMDNAME_ISASETLD,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,length);
            return FCSAN_ERROR_CODE;
        }
    }
    return FCSAN_SUCCESS_CODE;
}
