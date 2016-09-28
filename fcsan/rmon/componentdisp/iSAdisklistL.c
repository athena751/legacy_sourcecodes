/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistL.c,v 1.2307 2007/04/16 07:24:33 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistL.c,v 1.2307 2007/04/16 07:24:33 liuyq Exp $";
#endif
#endif


#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "math.h"
#include "general.h"
#include "iSAdisklist.h"



int printDetailInfo(iSMSMLd LDdata)
{
    char * reserve , * dvr ;
    switch (LDdata.reserve_flag)
    {
      case 0:
        reserve="no";
        break;
      case 1:
          reserve="yes";
        break;
      default:
        return 11;
    }
    switch (LDdata.dvr_flag)
    {
      case 0:
        dvr="no";
        break;
      case 1:
          dvr="yes";
        break;
      default:
        return 12;
    }

    printf("%04xh%s%-7s%s%-3s\n",LDdata.lun,TABLE_COL_SEPARATOR,reserve,TABLE_COL_SEPARATOR,dvr);
    return 0;
} /* end of "printDetailInfo" ; added by yangah*/


int printLDInfo(unsigned char array_id,iSMSMLd LDdata,unsigned int* loop_count_ldset,int cmdCodeFunc,int cmdCodeType)
{
    int i, j;
    iSMSMinDataInfo i_inf_ldset;
    iSMSMoutDataInfo o_inf_ldset,o_info_pool;
    iSMSMLdsetId ldsetId;
    /* added by maojb    */
    char new_ldsetname[17];
    unsigned char partition_counter=0;    
    unsigned char svrVerId;
    iSMSMVersion version;

    int result;

//to get pool info by LDdata.pool_num ,  liyb 20050829
    unsigned short pool_no=LDdata.pool_num;
    iSMSMPool *poolData=NULL;
   
    // invoke sub_function to get pool info  liyb 20050905
   result=getPoolInfo(pool_no, array_id,  &poolData, &o_info_pool,  loop_count_ldset,  cmdCodeFunc, cmdCodeType);
   if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    	{
    	    return FCSAN_ERROR_CODE;    
    	}

  unsigned char base_pd=poolData->num_of_base_pd;
  char  pool_name[33];
  chars2str(poolData->poolname, 32, pool_name);//strncpy(pool_name,poolData->poolname,32);  //changed by liyb 20050905
  free(poolData);
//end ,get pool info
    int err_no=outLDPartInfo(LDdata,cmdCodeFunc,array_id);
    if (err_no)
    {
       printf("\n");
    	fflush(stdout);  /*added by changhs 2002/07/01*/
       fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,cmdCodeFunc,CMDCODE_TYPE_INTERNAL,9000+err_no);
        return FCSAN_ERROR_CODE;
    }
//output pool no and pool name  liyb 20050829
printf("%04xh%s",pool_no,TABLE_COL_SEPARATOR);
printf("%-32s%s",pool_name,TABLE_COL_SEPARATOR);

printBasePdValue(base_pd);
printf("\n");        

       /*added by hj for iSMSM v1.5*/
    /*call API to get version*/
    i_inf_ldset.data = &version;
    i_inf_ldset.data_size = sizeof(iSMSMVersion);
    result = iSMSMGetVersionInfo(&i_inf_ldset,&o_inf_ldset) ;
    if (result!=iSMSM_NORMAL)
    {
    	fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                cmdCodeFunc,cmdCodeType,1);
        return FCSAN_ERROR_CODE;
    }
    svrVerId = ((iSMSMVersion *)(i_inf_ldset.data))->ismsvr_verid;
    /*end add*/
    
        /*print LDset's name*/
        if (LDdata.rtn_ldset_id_num==0)
            printf("--"); 
        for (j = 0;j < LDdata.rtn_ldset_id_num;j++){
            /*modified by hj for iSM version 1.5*/
            if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
                i_inf_ldset.data_size = sizeof(iSMSMLdset2);
                i_inf_ldset.data = malloc(i_inf_ldset.data_size);
            }else{ /*version 1.4*/
                  i_inf_ldset.data_size = sizeof(iSMSMLdset);
                i_inf_ldset.data = malloc(i_inf_ldset.data_size);
            }
        /*end modify*/
        
            if ( !i_inf_ldset.data ){/* Memory allocation failure */
                fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,cmdCodeFunc,CMDCODE_TYPE_SYSTEMFUNC,1);
                return FCSAN_ERROR_CODE;
             }
/* modified by chs & key, 2002-12-26*/
            ISMSM_CLI_INIT_ZERO(ldsetId);

            ldsetId.array_id = array_id;
            ldsetId.ldset_num = LDdata.ldset_id[j];
            ldsetId.version_id = svrVerId;
            
            result = iSMSMGetLdsetInfo(&ldsetId,&i_inf_ldset,&o_inf_ldset);
            if (result!=iSMSM_NORMAL){/* API error */
                fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                    cmdCodeFunc,cmdCodeType+1,(*loop_count_ldset)++);
                free(i_inf_ldset.data);
                return FCSAN_ERROR_CODE;
            }
               if (j!=0)
                printf(",");
                
            /*modified by hj for iSM version 1.5*/
            if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
                chars2str(((iSMSMLdset2*)i_inf_ldset.data)->ldset_name ,16 , new_ldsetname);
            }else{ /*version 1.4*/
                chars2str(((iSMSMLdset*)i_inf_ldset.data)->ldset_name ,16 , new_ldsetname);
            }
            /*end modify*/
    
            /*printf("%s",((iSMSMLdset*)i_inf_ldset.data)->ldset_name);*/
            strtrim(new_ldsetname);
            printf("%s",new_ldsetname);
            free(i_inf_ldset.data);
        }
        printf("\n");
        return FCSAN_SUCCESS_CODE;
}

int diskList_l_nooption(unsigned char array_id, unsigned int lcount , int detail)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMLd *LDdata;
    unsigned int loop_count_ld=1,loop_count_ldset=1;
    int i,j;
    unsigned int get_num;
    int result ;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_NOOPTION,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
     /*call API to get LD number*/
     i_inf.data = NULL;
     result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
     if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_NOOPTION,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    
    /*print command title */
    printf("%s    : %04u\n\n",ARRAY_ID_LABEL,array_id);
	   
   printLDHeadInfo();  //changed by liyb 20050906
   printPoolHeadInfo();//changed by liyb 20050906
   printf("\n");  //changed by liyb 20050905
   printf("%s",LDSET_LABEL);  //changed by liyb 20050905
   printf("\n");
    if (detail)
        printf("%-5s%s%-7s%s%s\n",LUN_LABEL,TABLE_COL_SEPARATOR,RESERVE_LABEL,TABLE_COL_SEPARATOR,DVR_LABEL);
    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");
        
    if (result==iSMSM_TBL_NOENTRY || o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* call API to get LD info */
    i_inf.current_num = 1;
    i_inf.table_rev = iSMSM_TBL_FIRST;
    while(o_inf.remain_num > 0)
    {
        get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
        
        i_inf.get_num = get_num ;
        i_inf.data_size=get_num*sizeof(iSMSMLd);
           /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data ){/* Memory allocation failure */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_NOOPTION,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
            result = iSMSMGetLdListInfo(array_id,&i_inf,&o_inf);
        if (result!=iSMSM_NORMAL){/* API error */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_L_NOOPTION,CMDCODE_TYPE_API+1,loop_count_ld++);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /*output ld info*/
        LDdata = (iSMSMLd*)i_inf.data;
        for (i = 0;i<o_inf.return_num;i++){
        int err_no;
        if (printLDInfo(array_id,LDdata[i],&loop_count_ldset,CMDCODE_FUNC_ISADISKLIST_L_NOOPTION,
                CMDCODE_TYPE_API+2))
        {
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                       return FCSAN_ERROR_CODE;
        }
        if (detail)
            if (err_no=printDetailInfo(LDdata[i]))
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_NOOPTION,
                    CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;            
            }
        }/*ld for-loop end*/
      
        free(i_inf.data);  
        i_inf.current_num += o_inf.return_num;
        i_inf.table_rev = o_inf.table_rev;
    } /*ld while-loop end*/
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
}

int diskList_l_ldset(unsigned char array_id, unsigned int lcount,unsigned short ldset_id ,int detail)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMLd *LDdata;
    iSMSMLdsetId ldsetId;
    
    unsigned int loop_count_ld=1,loop_count_ldset=1;
    int i,j;
    unsigned int get_num;
    int result ;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_LDSET,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }

/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ldsetId);
    
     /*call API to get LD number*/
     ldsetId.array_id = array_id;
     ldsetId.ldset_num = ldset_id;
     i_inf.data = NULL;
     
     result = iSMSMGetLdsetLdInfo(&ldsetId,&i_inf,&o_inf);
     if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_LDSET,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    
    /*print command title */
    printf("%s    : %04u\n",ARRAY_ID_LABEL,array_id);
    printf("%s    : %05hu\n\n",LDSET_ID_LABEL,ldset_id);
	
   printLDHeadInfo();  //changed by liyb 20050906
   printPoolHeadInfo();//changed by liyb 20050906
   printf("\n");  //changed by liyb 20050905
   printf("%s\n",LDSET_LABEL);  //changed by liyb 20050905
   
    if (detail)
        printf("%-5s%s%-7s%s%s\n",LUN_LABEL,TABLE_COL_SEPARATOR,RESERVE_LABEL,TABLE_COL_SEPARATOR,DVR_LABEL);
    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");
        
    if (result==iSMSM_TBL_NOENTRY || o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* call API to get LD info */
    i_inf.current_num = 1;
    i_inf.table_rev = iSMSM_TBL_FIRST;
    while(o_inf.remain_num > 0)
    {
        get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
        
        i_inf.get_num = get_num ;
        i_inf.data_size=get_num*sizeof(iSMSMLd);
           /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data ){/* Memory allocation failure */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_LDSET,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
        }
        result = iSMSMGetLdsetLdInfo(&ldsetId,&i_inf,&o_inf);
        if (result!=iSMSM_NORMAL){/* API error */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_LDSET,CMDCODE_TYPE_API+1,loop_count_ld++);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
        }
        
        /*output ld info*/
        LDdata = (iSMSMLd*)i_inf.data;
        for (i = 0;i<o_inf.return_num;i++){
        int err_no;
        if (printLDInfo(array_id,LDdata[i],&loop_count_ldset,CMDCODE_FUNC_ISADISKLIST_L_LDSET,
                CMDCODE_TYPE_API+2))
        {
            free(i_inf.data);  /* added by yangah when detecting memory leak */
                   return FCSAN_ERROR_CODE;
        }
        if (detail)
            if (err_no=printDetailInfo(LDdata[i]))
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_LDSET,
                    CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;            
            } /* added by yangah */
        }/*ld for-loop end*/
      
        free(i_inf.data);  
        i_inf.current_num += o_inf.return_num;
        i_inf.table_rev = o_inf.table_rev;
    } /*ld while-loop end*/
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
}

int diskList_l_port(unsigned char array_id, unsigned int lcount, unsigned char dir_num,unsigned char port_num,int detail)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMLd *LDdata;
    iSMSMPortId portId;
    
    unsigned int loop_count_ld=1,loop_count_ldset=1;
    int i,j;
    unsigned int get_num;
    int result ;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_PORT,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(portId);

     /*call API to get LD number*/
     portId.array_id = array_id;
     portId.dir_num = dir_num;
     portId.port_num = port_num;
     i_inf.data = NULL;
     
     result = iSMSMGetPortLdInfo(&portId,&i_inf,&o_inf);
     if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY) {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_PORT,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    
    /*print command title */
    printf("%-10s: %04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-10s: %02xh-%02xh\n\n",PORT_NO_LABEL,dir_num,port_num);
	
   printLDHeadInfo( );  //changed by liyb 20050906
   printPoolHeadInfo( );//changed by liyb 20050906
   printf("\n");  //changed by liyb 20050905
   printf("%s\n",LDSET_LABEL);  //changed by liyb 20050905
   
    if (detail)
        printf("%-5s%s%-7s%s%s\n",LUN_LABEL,TABLE_COL_SEPARATOR,RESERVE_LABEL,TABLE_COL_SEPARATOR,DVR_LABEL);
    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");
        
    if (result==iSMSM_TBL_NOENTRY || o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* call API to get LD info */
    i_inf.current_num = 1;
    i_inf.table_rev = iSMSM_TBL_FIRST;
    while(o_inf.remain_num > 0)
    {
        get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
        
        i_inf.get_num = get_num ;
        i_inf.data_size=get_num*sizeof(iSMSMLd);
           /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data ){/* Memory allocation failure */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_PORT,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
        }
        result = iSMSMGetPortLdInfo(&portId,&i_inf,&o_inf);
        if (result!=iSMSM_NORMAL){/* API error */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_PORT,CMDCODE_TYPE_API+1,loop_count_ld++);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
        }
        
        /*output ld info*/
        LDdata = (iSMSMLd*)i_inf.data;
        for (i = 0;i<o_inf.return_num;i++){
        int err_no;
            if (printLDInfo(array_id,LDdata[i],&loop_count_ldset,CMDCODE_FUNC_ISADISKLIST_L_PORT,
                CMDCODE_TYPE_API+2))
        {
            free(i_inf.data);  /* added by yangah when detecting memory leak */
                   return FCSAN_ERROR_CODE;
        }
        if (detail)
            if (err_no=printDetailInfo(LDdata[i]))
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_PORT,
                    CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;            
            }
        }/*ld for-loop end*/
      
        free(i_inf.data);  
        i_inf.current_num += o_inf.return_num;
        i_inf.table_rev = o_inf.table_rev;
    } /*ld while-loop end*/
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
}

int diskList_l_pool(unsigned char array_id, unsigned int lcount ,int detail)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMLd *LDdata;
    
    unsigned int loop_count_ld=1,loop_count_ldset=1;
    int i,j;
    unsigned int get_num;
    int result ;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_POOL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
     /*call API to get LD number*/
     i_inf.data = NULL;
     
     result = iSMSMGetPoolLdInfo(array_id,&i_inf,&o_inf);
     if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_POOL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    
    /*print command title */
    printf("%s    : %04u\n",ARRAY_ID_LABEL,array_id);
    printf("%s\n\n",POOL_LABEL);
	
   printLDHeadInfo( );  //changed by liyb 20050906
   printPoolHeadInfo( );//changed by liyb 20050906
   printf("\n");  //changed by liyb 20050905
   printf("%s\n",LDSET_LABEL);  //changed by liyb 20050905
   
    if (detail)
        printf("%-5s%s%-7s%s%s\n",LUN_LABEL,TABLE_COL_SEPARATOR,RESERVE_LABEL,TABLE_COL_SEPARATOR,DVR_LABEL);
    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");
        
    if (result==iSMSM_TBL_NOENTRY || o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* call API to get LD info */
    i_inf.current_num = 1;
    i_inf.table_rev = iSMSM_TBL_FIRST;
    while(o_inf.remain_num > 0)
    {
        get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;

        i_inf.get_num = get_num ;
        i_inf.data_size=get_num*sizeof(iSMSMLd);
           /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data ){/* Memory allocation failure */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_POOL,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
        }
        result = iSMSMGetPoolLdInfo(array_id,&i_inf,&o_inf);
        if (result!=iSMSM_NORMAL){/* API error */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_L_POOL,CMDCODE_TYPE_API+1,loop_count_ld++);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
        }
        
        /*output ld info*/
        LDdata = (iSMSMLd*)i_inf.data;
        for (i = 0;i<o_inf.return_num;i++){
        int err_no;
            if (printLDInfo(array_id,LDdata[i],&loop_count_ldset,CMDCODE_FUNC_ISADISKLIST_L_POOL,
                CMDCODE_TYPE_API+2))
        {
            free(i_inf.data);  /* added by yangah when detecting memory leak */
             return FCSAN_ERROR_CODE;
        }
        if (detail)
            if (err_no=printDetailInfo(LDdata[i]))
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_L_POOL,
                    CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;            
            }
        }/*ld for-loop end*/
      
        free(i_inf.data);  
        i_inf.current_num += o_inf.return_num;
        i_inf.table_rev = o_inf.table_rev;
    } /*ld while-loop end*/

    /* print condition code */
    print_condition_code(o_inf);
    
    return FCSAN_SUCCESS_CODE; /* success */
}

//this function is wholly changed by liyb 20050830
int diskList_lp(unsigned char array_id,unsigned short ld_num,unsigned int lcount)
{

//add those local variale by liyb 20050830
    iSMSMLdId ldid;
    iSMSMPoolId poolID;
     unsigned short pool_no;
    char pool_name[33];  
    iSMSMinDataInfo pool_i_inf,ld_i_inf,pd_i_inf;
    iSMSMoutDataInfo pool_o_inf,ld_o_inf,pd_o_inf;
    iSMSMLd  *ld_data=NULL;
    iSMSMPool *pool_data=NULL;
    iSMSMPd *pd_data=NULL;
    int i,get_num;
    int result;
   
  //to get ld info by liyb 20050830


    ISMSM_CLI_INIT_ZERO(ldid);

    /* Init "i_inf" */
    ld_i_inf.data_size = sizeof(iSMSMLd) ;
    ld_i_inf.data = malloc(ld_i_inf.data_size);
    if (!ld_i_inf.data) 
    {/* memory allocation failure */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LP,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE; 
    }
    
    /* Initiate "ldid" */
    ldid.array_id=array_id ;
    ldid.ld_num=ld_num ;
    
    /* call API */
    result=iSMSMGetLdInfo(&ldid,&ld_i_inf,&ld_o_inf) ;

  if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_API,1);
        free(ld_i_inf.data);
        return FCSAN_ERROR_CODE;
    }


    if ( result==iSMSM_TBL_NOENTRY)  //noresult  added by liyb 20050909
    {
        //print command title  
        printf("%-14s: %04d\n",ARRAY_ID_LABEL,array_id);
        printf("%-14s: %04xh\n\n",LD_NO_LABEL,ld_num);  

        printf("%-7s%s%-11s%s%15s%s%-5s%s%-32s%s%-8s\n",PD_NO_LABEL,TABLE_COL_SEPARATOR,
            STATE_LABEL,TABLE_COL_SEPARATOR,CAPACITY_LABEL,TABLE_COL_SEPARATOR,
           POOL_NO_LABEL,TABLE_COL_SEPARATOR,POOL_NAME_LABEL,TABLE_COL_SEPARATOR,DIVISION_LABEL);
        for (i = 0;i < 80;i++)
            printf("%c",TABLE_LINE_SYMBOL); 
        printf("\n");

	 free(ld_i_inf.data);
	 
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);

        return FCSAN_SUCCESS_CODE; /* success */
    }
    
    ld_data=(iSMSMLd *)ld_i_inf.data;
//end get ld data by liyb

//to get pool_no  by liyb 20050830
	pool_no=ld_data->pool_num;
	free(ld_data);
	
//end( get pool_no  )

//to get pool_name 
 
 int loop_count=1;
   int     returnCode=getPoolInfo(pool_no,array_id,&pool_data,&pool_o_inf,&loop_count,CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_INTERNAL);
   if(returnCode){
     return returnCode;
   }

 
    chars2str(pool_data->poolname,32,pool_name);
    free(pool_data);
//end(get pool_name )


//print command title    liyb 20050830
   printf("%-14s: %04d\n",ARRAY_ID_LABEL,array_id);
   printf("%-14s: %04xh\n\n",LD_NO_LABEL,ld_num);  


//begin to get pd info by liyb 20050830
   if (lcount==0){
           fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }

    ISMSM_CLI_INIT_ZERO(poolID);

    /* call API to get total number */
    pd_i_inf.data = NULL ;
    poolID.array_id = array_id;
    poolID.pool_num = pool_no;

    result = iSMSMGetRankGroupPdInfo(&poolID,&pd_i_inf,&pd_o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_API+2,1);
        return FCSAN_ERROR_CODE;
    }
    
//print command title    liyb 20050830
    printf("%-7s%s%-11s%s%16s%s%-5s%s%-32s%s%-8s%s",PD_NO_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL,TABLE_COL_SEPARATOR,CAPACITY_LABEL,TABLE_COL_SEPARATOR,
       POOL_NO_LABEL,TABLE_COL_SEPARATOR,POOL_NAME_LABEL,TABLE_COL_SEPARATOR,
       DIVISION_LABEL,TABLE_COL_SEPARATOR);
       
    printf("%-11s%s",PROGRESSION_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20051210
    printf("%-5s%s",SPIN_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20051214
    printf("%-4s\n",PD_TYPE_LABEL);//added by liyb 20051214
    
    for (i = 0;i < 80;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");
    
    if (result==iSMSM_TBL_NOENTRY || pd_o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get PD list info */
    pd_i_inf.current_num = 1;
    pd_i_inf.table_rev = iSMSM_TBL_FIRST;
    while (pd_o_inf.remain_num > 0)
    {
        get_num = pd_o_inf.remain_num <= lcount ? pd_o_inf.remain_num : lcount;
          /* Initiate "pd_i_inf" */
        pd_i_inf.get_num = get_num ;
        pd_i_inf.data_size = get_num * sizeof(iSMSMPd);
          /* Memory Allocation */
        pd_i_inf.data = calloc(get_num,sizeof(iSMSMPd));
        if ( !pd_i_inf.data ){/* Memory allocation failure */
        fflush(stdout);// added by keyan 2002-7-1
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LP,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        fflush(stderr);// added by keyan 2002-7-1
        return FCSAN_ERROR_CODE;
        }
        
         result=iSMSMGetRankGroupPdInfo(&poolID,&pd_i_inf,&pd_o_inf ) ;
        if (result!=iSMSM_NORMAL){/* API error */
            fflush(stdout);// added by keyan 2002-7-1
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_API+3,loop_count++);
            free(pd_i_inf.data);
            fflush(stderr);// added by keyan 2002-7-1
            return FCSAN_ERROR_CODE;
        }
        pd_data = (iSMSMPd *)pd_i_inf.data;
        
        /* print PD List */
        for (i = 0;i < pd_o_inf.return_num; i++)
        {/* print a record in one loop procedure */
            int err_no; /* added by Yang AH */
            printf("%02xh-%02xh%s",pd_data[i].pd_grp_num,pd_data[i].pd_num,TABLE_COL_SEPARATOR); /*PD_No*/
            /*print state*/
            if (err_no=outPdState(pd_data[i].pd_matter))
            { /* err_no: 1(error occurred) 0(success) */
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_INTERNAL,9001);
                free(pd_i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1
                    return FCSAN_ERROR_CODE;
            }
            /*print capacity*/
            char floatStr[40];
	     double capa = pd_data[i].sector_num*512.0/pow(1024,3);
            getCutString(((float)capa), floatStr); 
            printf("%16s%s",floatStr,TABLE_COL_SEPARATOR);
	      /*print  pool_no and pool name*/
            printf("%04xh%s%33s%s",pool_no,TABLE_COL_SEPARATOR,pool_name,TABLE_COL_SEPARATOR);
            /*print Division*/
            if (err_no=outPdDivision(pd_data[i].pd_flag))
            { /* error_no: 1(error occurred) 0(success) */
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LP,CMDCODE_TYPE_INTERNAL,9002);
                free(pd_i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1
                return FCSAN_ERROR_CODE;
            }
            
        /*print rebuild rate  added by liyb 20051210*/
        if(pd_data[i].pd_matter==0x11) {
	       printf("%11d%s",pd_data[i].rebuild_rate,TABLE_COL_SEPARATOR);}
	 else{
	       printf("%11s%s","--",TABLE_COL_SEPARATOR);}


    /*print pd_revolution  added by liyb 20051214*/
         printf("%5d%s",pd_data[i].pd_revolution,TABLE_COL_SEPARATOR);
    /*print pd_type  added by liyb 20051214*/
        if(pd_data[i].pd_type==PD_TYPE_FC_VALUE) {
            printf("%s",PD_TYPE_FC_DESC);
        }else if(pd_data[i].pd_type==PD_TYPE_SATA_VALUE){
            printf("%s",PD_TYPE_SATA_DESC);
        }else if(pd_data[i].pd_type==PD_TYPE_SAS_VALUE){
            printf("%s",PD_TYPE_SAS_DESC);
	 }else{
             printf("%s",NULL_STATE);
        }

	 printf("\n");

        }/* end of "for" */
        
        /* release allocated memory */
        free(pd_i_inf.data);
        
        /* prepare for the next loop procedure */
        pd_i_inf.current_num += pd_o_inf.return_num;
        pd_i_inf.table_rev = pd_o_inf.table_rev ;
    }/* end of "while" */
    
    /* print condition code */
    print_condition_code(pd_o_inf);

    return FCSAN_SUCCESS_CODE; /* success */

//end(get pd info)
    
} /* end of "diskList_lp" */

/*********************************************************************************************/

int diskList_lap(unsigned char array_id,unsigned short ld_num,unsigned int lcount)
{
    iSMSMLdId ldid;
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPort *data=NULL;
    char * access_mode[]={"",ACCESS_MODE_PORT,ACCESS_MODE_WNN};
    /*    0x01-----Port
        0x02-----WWN    */
    /*modified by hujing;according to the mail (nas 2791) No.24*/
    /*char * port_matter[]={PORT_MATTER_READY,PORT_MATTER_OFFLINE,PORT_MATTER_FAULT};*/
    char *port_matter = "";

    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int i,result ;
    //add by maojb
    char new_portname[33];

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LAP,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }

/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ldid);   
    
    /* call API to get total number */
    ldid.array_id =array_id ;
    ldid.ld_num =ld_num ;
    i_inf.data =NULL ;
    result=iSMSMGetLdPortInfo(&ldid,&i_inf,&o_inf) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LAP,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */
    
    /* output table header */
    printf("%-9s:%04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-9s:%04xh\n\n",LD_NO_LABEL,ld_num);

    printf("%-7s%s%-32s%s%-4s%s%-10s%s%s\n",
        PORT_NO_LABEL,TABLE_COL_SEPARATOR,PORT_LABEL,
        TABLE_COL_SEPARATOR,MODE_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL,TABLE_COL_SEPARATOR,PROTOCOL_LABEL);
    for (i=0;i<72;i++)
    {
        printf("%c",TABLE_LINE_SYMBOL);
    }
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY || remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get LD port info */
    while (remain_num>0)
    {
        if (remain_num<=lcount)
        {
            get_num=remain_num ;
        }
        else
        {
            get_num=lcount ;
        }/* store the minimum number of {lcount , remain_num} to "get_num" */
        
        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        i_inf.data_size=get_num*sizeof(iSMSMPort);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMPort));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LAP,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetLdPortInfo(&ldid,&i_inf,&o_inf) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_LAP,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /* Output Table Body */
        data=(iSMSMPort *)i_inf.data;
        
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            //change chars to string
            
            chars2str(data[i].port_name,32,new_portname);

            /*printf("%02xh-%02xh%s%32s%s%4s%s%s\n",
                data[i].dir_num,data[i].port_num,TABLE_COL_SEPARATOR,
                data[i].port_name,TABLE_COL_SEPARATOR,
                access_mode[data[i].access_mode],TABLE_COL_SEPARATOR,
                port_matter[data[i].port_matter/16]);*/
            if (data[i].access_mode<1 || data[i].access_mode>2)
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LAP,CMDCODE_TYPE_INTERNAL,9001);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;
            }
            
            /*remarked by hujing;according to the mail (nas 2791) No.24*/
            /*if (data[i].port_matter!=0x00 && data[i].port_matter!=0x10 && data[i].port_matter!=0x20)
            {
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LAP,CMDCODE_TYPE_INTERNAL,9002);
                return FCSAN_ERROR_CODE;
            }*/            
            
            /*modified by hujing; according to the mail (nas 2791) No.24*/
            /*printf("%02xh-%02xh%s%32s%s%4s%s%-10s",
                data[i].dir_num,data[i].port_num,TABLE_COL_SEPARATOR,
                new_portname,TABLE_COL_SEPARATOR,
                access_mode[data[i].access_mode],TABLE_COL_SEPARATOR,
                port_matter[data[i].port_matter/16]);*/

            switch (data[i].port_matter){
            case 0x00:
                port_matter = PORT_MATTER_READY;
                break;
            case 0x10:
                port_matter = PORT_MATTER_OFFLINE;
                break;
            case 0x11:
                port_matter = PORT_MATTER_NOLICENCE;
                break;
            case 0x20:
                port_matter = PORT_MATTER_FAULT;
                break;
            default:
                port_matter="unknown";
            }
            printf("%02xh-%02xh%s%32s%s%4s%s%-10s%s",
                data[i].dir_num,data[i].port_num,TABLE_COL_SEPARATOR,
                new_portname,TABLE_COL_SEPARATOR,
                access_mode[data[i].access_mode],TABLE_COL_SEPARATOR,
                port_matter,TABLE_COL_SEPARATOR);
            /*end modify*/
            
            switch (data[i].protocol)
            {
              case 1:
                puts("FC");
                break;
              case 2:
                puts("PI");
                break;
              case 3:
                puts("IP");
                break;
              default:
                puts("unknown");
            }
            
        }/* end of "for" */
        
        /* release allocated memory */
        free(i_inf.data);
        
        /* make provision for the next loop procedure */
        remain_num = o_inf.remain_num ;
        current_num += o_inf.return_num;
        table_rev=o_inf.table_rev ;
        loop_count++;
        
    }/* end of "while" */
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
    
} /* end of "diskList_lap" */

/*********************************************************************************************/

int diskList_lal(unsigned char array_id,unsigned short ld_num,unsigned int lcount)
{
    iSMSMLdId ldid;
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMLdset *data;
    iSMSMLdset2 *data1;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int i,j,result ;
    //add by maojb
    char new_ldsettype[3];
    char new_ldsetname[17];
    iSMSMVersion version;
    unsigned char svrVerId;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LAL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
/* modified by chs & key & hujun, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ldid);   

    /*added by hj for iSMSM v1.5*/
    /*call API to get version*/
    i_inf.data = &version;
    i_inf.data_size = sizeof(iSMSMVersion);
    result = iSMSMGetVersionInfo(&i_inf,&o_inf) ;
    if (result!=iSMSM_NORMAL)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LAL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    svrVerId = ((iSMSMVersion *)(i_inf.data))->ismsvr_verid;
    /*end add*/
    
    /* call API to get total number */
    ldid.array_id=array_id ;
    ldid.ld_num=ld_num ;
    ldid.version_id = svrVerId;
    i_inf.data =NULL ;
    result=iSMSMGetLdLdsetInfo(&ldid,&i_inf,&o_inf) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LAL,CMDCODE_TYPE_API+1,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */
    
    /* output table header */
    printf("%-9s:%04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-9s:%04xh\n\n",LD_NO_LABEL,ld_num);
    printf("%-8s%s%-4s%s%-16s%s%8s%s%s\n",
        LDSET_ID_LABEL,TABLE_COL_SEPARATOR,
        TYPE_LABEL,TABLE_COL_SEPARATOR,
        LDSET_LABEL,TABLE_COL_SEPARATOR,
        PATH_CNT_LABEL,TABLE_COL_SEPARATOR,    
        PATH_LABEL);
    for (i=0;i<80;i++)
    {
        printf("%c",TABLE_LINE_SYMBOL);
    }
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY || remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get LDset info */
    while (remain_num>0)
    {
        if (remain_num<=lcount)
        {
            get_num=remain_num ;
        }
        else
        {
            get_num=lcount ;
        }/* store the minimum number of {lcount , remain_num} to "get_num" */
        
        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        
        /*modified by hj for iSM version 1.5*/
        if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
            i_inf.data_size = get_num*sizeof(iSMSMLdset2);
            i_inf.data=calloc(get_num,sizeof(iSMSMLdset2));
        }else{ /*version 1.4*/
            i_inf.data_size=get_num*sizeof(iSMSMLdset);
            i_inf.data=calloc(get_num,sizeof(iSMSMLdset));
        }
        /*end modify*/
        
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LAL,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        /* call API */
        result=iSMSMGetLdLdsetInfo(&ldid,&i_inf,&o_inf) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_LAL,CMDCODE_TYPE_API+2,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /*modified by hj for iSM version 1.5*/
        if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
            /* Output Table Body */
            data1=(iSMSMLdset2 *)i_inf.data ;
        
            for (i=0;i<o_inf.return_num;i++)
            {/* print a record in one loop procedure */
                unsigned int  num_of_wwpn;                       
                if (    (data1[i].num_of_wwpn==1) &&
                        (data1[i].wwpn[0][0]==-1) && (data1[i].wwpn[0][1]==-1) &&
                        (data1[i].wwpn[0][2]==-1) && (data1[i].wwpn[0][3]==-1) &&
                        (data1[i].wwpn[0][4]==-1) && (data1[i].wwpn[0][5]==-1) &&
                        (data1[i].wwpn[0][6]==-1) && (data1[i].wwpn[0][7]==-1)  )
                {
                        num_of_wwpn=0;
                }
                else
                {
                        num_of_wwpn=data1[i].num_of_wwpn;                        
                }    /* added by yangah according to defect 094*/
                chars2str(data1[i].ldset_type,2,new_ldsettype);
                chars2str(data1[i].ldset_name,16,new_ldsetname);
    
                printf("   %05hu%s%-4s%s%-16s%s%8u%s",
                    data1[i].ldset_id,TABLE_COL_SEPARATOR,
                    new_ldsettype,TABLE_COL_SEPARATOR,
                    new_ldsetname,TABLE_COL_SEPARATOR,
                    num_of_wwpn,TABLE_COL_SEPARATOR
                    );    
    
                /* output path    */
                if (data1[i].num_of_wwpn==0){
                    printf("-\n");
                    continue;
                }
                
                for (j=0;j<data1[i].num_of_wwpn;j++)
                {
                    if (data1[i].wwpn[j][0] != -1 || data1[i].wwpn[j][1] != -1 ||
                        data1[i].wwpn[j][2] != -1 || data1[i].wwpn[j][3] != -1 ||
                        data1[i].wwpn[j][4] != -1 || data1[i].wwpn[j][5] != -1 ||
                        data1[i].wwpn[j][6] != -1 || data1[i].wwpn[j][7] != -1)
                              printf("%02x%02x-%02x%02x-%02x%02x-%02x%02x",
                                (unsigned char)data1[i].wwpn[j][0],(unsigned char)data1[i].wwpn[j][1],
                                (unsigned char)data1[i].wwpn[j][2],(unsigned char)data1[i].wwpn[j][3],
                                (unsigned char)data1[i].wwpn[j][4],(unsigned char)data1[i].wwpn[j][5],
                                (unsigned char)data1[i].wwpn[j][6],(unsigned char)data1[i].wwpn[j][7]    );
                    else
                            printf("-");

                      if (j < data1[i].num_of_wwpn-1)
                            printf(",");
                }
                printf("\n");            
            }/* end of "for" */
        }else{/*version 1.4*/
            /* Output Table Body */
            data=(iSMSMLdset *)i_inf.data ;
            for (i=0;i<o_inf.return_num;i++)
            {/* print a record in one loop procedure */
                unsigned int  num_of_wwpn;                       
                if (    (data[i].num_of_wwpn==1) &&
                        (data[i].wwpn[0][0]==-1) && (data[i].wwpn[0][1]==-1) &&
                        (data[i].wwpn[0][2]==-1) && (data[i].wwpn[0][3]==-1) &&
                        (data[i].wwpn[0][4]==-1) && (data[i].wwpn[0][5]==-1) &&
                        (data[i].wwpn[0][6]==-1) && (data[i].wwpn[0][7]==-1)  )
                {
                        num_of_wwpn=0;
                }
                else
                {
                        num_of_wwpn=data[i].num_of_wwpn;                        
                }    /* added by yangah according to defect 094*/            
            
                chars2str(data[i].ldset_type,2,new_ldsettype);
                chars2str(data[i].ldset_name,16,new_ldsetname);
    
                printf("   %05hu%s%-4s%s%-16s%s%8u%s",
                    data[i].ldset_id,TABLE_COL_SEPARATOR,
                    new_ldsettype,TABLE_COL_SEPARATOR,
                    new_ldsetname,TABLE_COL_SEPARATOR,
                    num_of_wwpn,TABLE_COL_SEPARATOR
                    );    
    
                if (data[i].num_of_wwpn==0){
                    printf("-\n");
                    continue;
                }
                /* output path    */
                for (j=0;j<data[i].num_of_wwpn;j++)
                {
                    if (data[i].wwpn[j][0] != -1 || data[i].wwpn[j][1] != -1 ||
                        data[i].wwpn[j][2] != -1 || data[i].wwpn[j][3] != -1 ||
                        data[i].wwpn[j][4] != -1 || data[i].wwpn[j][5] != -1 ||
                        data[i].wwpn[j][6] != -1 || data[i].wwpn[j][7] != -1)
                              printf("%02x%02x-%02x%02x-%02x%02x-%02x%02x",
                                (unsigned char)data1[i].wwpn[j][0],(unsigned char)data1[i].wwpn[j][1],
                                (unsigned char)data1[i].wwpn[j][2],(unsigned char)data1[i].wwpn[j][3],
                                (unsigned char)data1[i].wwpn[j][4],(unsigned char)data1[i].wwpn[j][5],
                                (unsigned char)data1[i].wwpn[j][6],(unsigned char)data1[i].wwpn[j][7]    );
                    else
                            printf("-");

                      if (j < data[i].num_of_wwpn-1)
                            printf(",");
                }
                printf("\n");            
            }/* end of "for" */
        }/*end else: version 1.4*/
            
        /* release allocated memory */
        free(i_inf.data);
        
        /* make provision for the next loop procedure */
        remain_num = o_inf.remain_num ;
        current_num += o_inf.return_num;
        table_rev=o_inf.table_rev ;
        loop_count++;
        
    }/* end of "while" */
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
    
} /* end of "diskList_lal" */

/*********************************************************************************************/

int diskList_ls(unsigned char array_id,unsigned short ld_num)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf,pool_o_inf;
    iSMSMLdId ldid;
    iSMSMLd * data;
    int loop_count=1;


    iSMSMPool    * pool_data=NULL;

    unsigned short pool_no;
	
   // unsigned char partition_counter=0; /* added by Yang AH */  //delete by liyb 20080530 
    int result;
    int i,err_no;
    
    char * current_owner=NULL, * default_owner=NULL;

/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ldid);

    /* Init "i_inf" */
    i_inf.data_size = sizeof(iSMSMLd) ;
    i_inf.data = malloc(i_inf.data_size);
    if (!i_inf.data) 
    {/* memory allocation failure */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LS,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE; 
    }
    
    /* Initiate "ldid" */
    ldid.array_id=array_id ;
    ldid.ld_num=ld_num ;
    
    /* call API */
    result=iSMSMGetLdInfo(&ldid,&i_inf,&o_inf) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LS,CMDCODE_TYPE_API,1);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
    }

    if (result==iSMSM_TBL_NOENTRY)
    {
         printLDHeadInfo();
     
         printf(" %-13s%s%-13s%s",
     	     CURRENT_OWNER_LABEL,TABLE_COL_SEPARATOR,
                 DEFAULT_OWNER_LABEL,TABLE_COL_SEPARATOR);
         printPoolHeadInfo();
         printf("%-5s%s\n", LUN_LABEL,TABLE_COL_SEPARATOR );
         for (i=0;i<TABLE_FULL_WIDTH;i++)
         {
             printf("%c",TABLE_LINE_SYMBOL);
         }
         printf("\n");
     	
	 printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        free(i_inf.data); 
        return FCSAN_SUCCESS_CODE;
    }
	
    data=(iSMSMLd *)i_inf.data;
	
    //to get pool info , liyb 20050830
     pool_no=data->pool_num;
      result=getPoolInfo(pool_no,array_id,&pool_data,&pool_o_inf,&loop_count,CMDCODE_FUNC_ISADISKLIST_LS,CMDCODE_TYPE_INTERNAL);

      if(result){
	  	return result;
      	}

	
    /* Output command title */
    printf("%s    :%04u\n\n",ARRAY_ID_LABEL,array_id);    /* Array_ID */


    printLDHeadInfo();

    printf(" %-13s%s%-13s%s",
	     CURRENT_OWNER_LABEL,TABLE_COL_SEPARATOR,
            DEFAULT_OWNER_LABEL,TABLE_COL_SEPARATOR);
    printPoolHeadInfo();
    printf("%-5s%s\n", LUN_LABEL,TABLE_COL_SEPARATOR );

	

    for (i=0;i<TABLE_FULL_WIDTH;i++)
    {
        printf("%c",TABLE_LINE_SYMBOL);
    }
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
        return FCSAN_SUCCESS_CODE;
    }

    if (data->cross_call==0x01){
        switch (data->current_owner)
        {
            case 0x00:
                current_owner="-";
                break;
            case 0x10:
                current_owner="controller0";
                break;
            case 0x11:
                current_owner="controller1";
                break;
            default:
                fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LS,CMDCODE_TYPE_INTERNAL,9001);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;        
        }
    
        switch (data->default_owner)
        {
            case 0x00:
                default_owner="-";
                break;
            case 0x10:
                default_owner="controller0";
                break;
            case 0x11:
                default_owner="controller1";
                break;
            default:
                fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LS,CMDCODE_TYPE_INTERNAL,9002);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;        
        }
    }else if(data->cross_call==0x00 || data->cross_call == 0x02){
        current_owner="-";
        default_owner="-";
        
    }
    /*output ld_no, type, ld_name,lun, state, raid,base_pd , capacity, cache, progression info*/
    if (err_no=outLDPartInfo(*data,CMDCODE_FUNC_ISADISKLIST_LS,array_id))
    {  
        printf("\n");
    	 fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LS,CMDCODE_TYPE_INTERNAL,9002+err_no);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
    }
    /*print current_owner, default owner*/
    printf("%-13s%s%-13s%s",current_owner,TABLE_COL_SEPARATOR,default_owner,TABLE_COL_SEPARATOR);

 //to output  pool_no and pool_name  , liyb 20050830
    char pool_name[33];
    chars2str(pool_data->poolname, 32,pool_name );
    
    printf("%04xh%s%-32s %s",pool_no,TABLE_COL_SEPARATOR,pool_name,TABLE_COL_SEPARATOR);

     printBasePdValue(pool_data->num_of_base_pd);
     free(pool_data);
     printf("%04xh\n",data->lun);
    free(i_inf.data); /* release allocated memory */
    /* print condition code */
    print_condition_code(o_inf);
    return FCSAN_SUCCESS_CODE; /* success */

} /* end of "diskList_ls" */

/**********************************************************************************************/
/* start of "diskList_lpool" */
//delete  parameter "unsigned int lcount" by liyb 20050829
//this function is wholly changed by liyb   20050831
//all infos about pool  in this function is deleted  except  pool_no and Pool_name    liyb  20050901
//the infos to be shown is pool_no, pool_name and rank info    liyb  20050901
int diskList_lpool(unsigned char array_id,unsigned short ld_no)
{



    iSMSMLdId ldid;

     unsigned short pool_no;
    char pool_name[33];  
    iSMSMinDataInfo ld_i_inf;
    iSMSMoutDataInfo ld_o_inf,pool_o_inf;
    iSMSMLd  *ld_data=NULL;
    iSMSMPool *pool_data=NULL;
   int loop_count=1;
   int ld_raid=-1;
    int result;
    int i ;



  //1  to get ld info by liyb 20050830


    ISMSM_CLI_INIT_ZERO(ldid);

    /* Init "i_inf" */
    ld_i_inf.data_size = sizeof(iSMSMLd) ;
    ld_i_inf.data = malloc(ld_i_inf.data_size);
    if (!ld_i_inf.data) 
    {/* memory allocation failure */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LPOOL,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE; 
    }
    
    /* Initiate "ldid" */
    ldid.array_id=array_id ;
    ldid.ld_num=ld_no;
    
    /* call API */
    result=iSMSMGetLdInfo(&ldid,&ld_i_inf,&ld_o_inf) ;

  if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_API,1);
        free(ld_i_inf.data);
        return FCSAN_ERROR_CODE;
    }

     if (result==iSMSM_TBL_NOENTRY || ld_o_inf.remain_num==0)
    {
                /* output table header */
        printf("%-9s:%04u\n",ARRAY_ID_LABEL,array_id);
        printf("%-9s:%04xh\n\n",LD_NO_LABEL,ld_no);

        printf("%-5s%s%-32s%s%4s%s%15s%s%10s%s%15s\n",
            POOL_NO_LABEL,TABLE_COL_SEPARATOR,
            POOL_NAME_LABEL,TABLE_COL_SEPARATOR,        
            RAID_LABEL,TABLE_COL_SEPARATOR,     
            CAPACITY_LABEL,TABLE_COL_SEPARATOR, 
            START_ADDR_LABEL,TABLE_COL_SEPARATOR,
            PARTITION_LABEL);
      	
        for (i=0;i<TABLE_FULL_WIDTH;i++)
        {
            printf("%c",TABLE_LINE_SYMBOL);
        }
        printf("\n");
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }
    ld_data=(iSMSMLd *)ld_i_inf.data;

    ld_raid=getRaidtype(ld_data->raid_type) ;//changed by liyb 20050906
    if(ld_raid==-1){
	        fflush(stdout);
	        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
	                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
	                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_INTERNAL,9001);
	        free(ld_i_inf.data);  
	        fflush(stderr);
            return FCSAN_ERROR_CODE;

     }
	
//end get ld data by liyb

  //2  if  Ld_raid ==6 ,no need  to go on     liyb 20050901

  if(ld_raid==6)
  	{
	     fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
	                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
	                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_WRONGLD_RAID6,9001);
	      free(ld_i_inf.data); 
             return FCSAN_ERROR_CODE;
  	}
  
  //3 if Ld_raid !=6 , go on     liyb 20050901
//to get pool_no  by liyb 20050830
	pool_no=ld_data->pool_num;
     
	free(ld_data);
//end( get pool_no  )

//to get pool info
   
   int     returnCode=getPoolInfo(pool_no,array_id,&pool_data,&pool_o_inf,&loop_count,CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_INTERNAL);

   if(returnCode){
     return returnCode;
   }

   chars2str( pool_data->poolname,32,pool_name);

   //3  to get rank info     liyb 20050901  

//add the local varialbes   liyb  20050901
    iSMSMinDataInfo rank_i_inf;
    iSMSMoutDataInfo rank_o_inf;
	
   
    iSMSMRank    *rank_data;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    loop_count=0;
    char * state="";

    int lcount=128;    //actually there only one record ;   liyb   20050901


/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ldid);
    
    ldid.array_id=array_id;
    ldid.ld_num=ld_no;
    
    /* call API to get total number */
    rank_i_inf.data =NULL ;
    result=iSMSMGetLdRankInfo(&ldid,&rank_i_inf,&rank_o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=rank_o_inf.remain_num ; /* total number */

    /* output table header */
    printf("%-9s:%04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-9s:%04xh\n\n",LD_NO_LABEL,ld_no);


//added by liyb 20050901
      printf("%-5s%s%-32s%s%4s%s%15s%s%10s%s%15s\n",
        POOL_NO_LABEL,TABLE_COL_SEPARATOR,
        POOL_NAME_LABEL,TABLE_COL_SEPARATOR,        
        RAID_LABEL,TABLE_COL_SEPARATOR,     
        CAPACITY_LABEL,TABLE_COL_SEPARATOR, 
        START_ADDR_LABEL,TABLE_COL_SEPARATOR,
        PARTITION_LABEL);
  	
    for (i=0;i<TABLE_FULL_WIDTH;i++)
    {
        printf("%c",TABLE_LINE_SYMBOL);
    }
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY || remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }


    /* get info */
    while (remain_num>0)
    {
        if (remain_num<=lcount)
        {
            get_num=remain_num ;
        }
        else
        {
            get_num=lcount ;
        }/* store the minimum number of {lcount , remain_num} to "get_num" */
        
        /* Initiate "i_inf" */
        rank_i_inf.get_num=get_num ;
        rank_i_inf.current_num=current_num ;
        rank_i_inf.table_rev=table_rev ;
        rank_i_inf.data_size=get_num*sizeof(iSMSMRank);
        
        /* Memory Allocation */
        rank_i_inf.data=calloc(get_num,sizeof(iSMSMRank));
        if ( !rank_i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LPOOL,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        /* call API */
        result=iSMSMGetLdRankInfo(&ldid,&rank_i_inf,&rank_o_inf);
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_API+1,loop_count+1);
            free(rank_i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /* Output Table Body */
        rank_data=(iSMSMRank *)rank_i_inf.data ;
        for (i=0;i<rank_o_inf.return_num;i++)
        {/* print a record in one loop procedure */
     
           getStateDescribe(rank_data[i].expand_state, rank_data[i].rank_matter,&state);//changed by liyb 20050901
           if(!state ||strlen(state)==0)//changed by liyb 20050901
           	{
           	      fflush(stdout); 
                    fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_LPOOL,CMDCODE_TYPE_INTERNAL,9003);
                    free(rank_i_inf.data);
                    return FCSAN_ERROR_CODE;
           	}
      

	        printf("%04xh%s%-32s%s%",
	        pool_no,TABLE_COL_SEPARATOR,
	        pool_name,TABLE_COL_SEPARATOR);               // liyb 20050901
	  
               printf("%4u%s", ld_raid,TABLE_COL_SEPARATOR);                    
               printf("%15.0f%s", rank_data[i].sector_num*512.0,TABLE_COL_SEPARATOR);			   

               printf(" %08xh%s%15u\n",    
		      rank_data[i].start_block_addr,TABLE_COL_SEPARATOR,
                    rank_data[i].partition_capacity);
				
		
     }/* end of "for" */
        
        /* release allocated memory */
        free(rank_i_inf.data);
        
        /* make provision for the next loop procedure */
        remain_num = rank_o_inf.remain_num ;
        current_num += rank_o_inf.return_num;
        table_rev=rank_o_inf.table_rev ;
        loop_count++;
        
    }/* end of "while" */
    
    /* print condition code */
    print_condition_code(rank_o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
    
} 
/* end of "diskList_lpool" */
/*********************************************************************************************/






