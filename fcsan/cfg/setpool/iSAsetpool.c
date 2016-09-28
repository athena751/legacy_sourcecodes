/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAsetpool.c,v 1.3 2007/04/27 07:32:06 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAsetpool.c,v 1.3 2007/04/27 07:32:06 liuyq Exp $";
#endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "general.h"
#include "iSAsetpool.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"
#include "iSMSMApi_cfg.h"
//simulate pool binding     liyb  20051222 
int setPool_sb(char *arr_name,unsigned char pdg_no,unsigned char pd_cnt,
                           unsigned char *pd_list,unsigned short pool_no, char * pool_name,
                           unsigned char raid_type, unsigned char base_pd,unsigned char rebuild_time, 
                           int restart, int nounlock, int force )
{

    iSMSMCfg_APIinfo_t     api_info;
    iSMSMPoolBind         pool_info;
    int                     i, result;

    /* check parameters */
    if (!arr_name)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    else
    {
        int ary_name_len=strlen(arr_name);
        if (ary_name_len==0 || ary_name_len>ARRAY_NAME_MAX_LENGTH)
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_INTERNAL,2);
            return FCSAN_ERROR_CODE;
        }
    }

    if (pd_cnt==0 || pd_cnt>MAX_PD_CNT)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_INTERNAL,3);
        return FCSAN_ERROR_CODE;
    }
    
    if (!pd_list)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_INTERNAL,4);
        return FCSAN_ERROR_CODE;
    }

    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETPOOL,CMDCODE_FUNC_ISASETPOOL_SB, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
 
	
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }

    /* build */
      iSMSM_INIT_SIM_POOLBINDINFO(pool_info);          // delete  iSMSM_INIT_RANKBINDINFO(rank_info);    liyb 20050831

//pool_info init  liyb   20050831
    pool_info.pdg_number=pdg_no;
    pool_info.pool_number=pool_no;
    pool_info.raid_type=raid_type;
    pool_info.rebuild_time=rebuild_time;
    pool_info.rebuild_time_flag=iSMSMCFG_POOL_FLAG_ON;
    pool_info.pd_list_count=pd_cnt;
    memcpy(pool_info.pdn_list,pd_list,pd_cnt);
    memset(pool_info.pool_name,'\0',NICKNAME_LENGTH);
    strncpy(pool_info.pool_name,pool_name,strlen(pool_name));

    if(raid_type==6)
    {
      pool_info.pool_type=iSMSMCFG_DYNAMIC_POOL;
      pool_info.base_pd_count=base_pd;
    }else{
     pool_info.pool_type=iSMSMCFG_BASIC_POOL;
	}


   
    result=iSMSMSimPoolBind(&api_info , &pool_info); /* call API */
    if (result!= iSMSM_NORMAL)
    {

        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_API+2,1);
        stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
  
        return FCSAN_ERROR_CODE;
    }
    
    /* output info */
    puts(INFO_ACCEPT_BUILD_REQUEST);    /* accept info */
    printf("%-13s:%s\n", LABEL_ARRAY_NAME,arr_name);  /* array name */
    printf("%-13s:%02xh\n", LABEL_PD_GROUP, pdg_no);  /* pd group */
    printf("%-13s:", LABEL_PD_NO);       /* pd no */
    for (i=0;i<pd_cnt-1;i++)
        printf("%02xh," , pd_list[i]);
    printf("%02xh\n",pd_list[pd_cnt-1]);
    printf("%-13s:%02xh\n", LABEL_POOL_NO, pool_no);    //added liyb   20050831
    printf("%-13s:%-32s\n", LABEL_POOL_NAME, pool_name);    //added liyb   20050831
    printf("%-13s:%u\n", LABEL_RAID, raid_type);   /* raid type */
    if(raid_type==6)
    {    printf("%-13s:%u\n", LABEL_BASE_PD, base_pd);   }
   else{printf("%-13s:%s\n", LABEL_BASE_PD, NO_BASE_PD);  }

    printf("%-13s:%u\n", LABEL_REBUILD_TIME, rebuild_time);    /* rebuild_time */
  
    unsigned long long capacity=(unsigned long long)(pool_info.sim_capacity_high)*0x10000*0x10000+pool_info.sim_capacity_low;
    printf("%-13s:%llu\n", LABEL_CAPACITY, capacity);    /* capacity */
      
    result=stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_SB,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }
    
    puts(COMMAND_SUCCESS_INFO); /* success info */
    return 0;    /* success */

}  /* end of "setRank_b" */

// delete parameter 'unsigned char s_no'  ,add "pool_no","pool_name", "base_pd" liyb 20050831
int setPool_b(char *arr_name,unsigned char pdg_no,unsigned char pd_cnt,unsigned char *pd_list,unsigned short pool_no, char * pool_name,unsigned char raid_type, unsigned char base_pd,unsigned char rebuild_time, int restart, int nounlock, int force )
{

    iSMSMCfg_APIinfo_t     api_info;
    iSMSMPoolBind         pool_info;//iSMSMRankBind         rank_info;
    int                     i, result;

    /* check parameters */
    if (!arr_name)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    else
    {
        int ary_name_len=strlen(arr_name);
        if (ary_name_len==0 || ary_name_len>ARRAY_NAME_MAX_LENGTH)
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_INTERNAL,2);
            return FCSAN_ERROR_CODE;
        }
    }

    if (pd_cnt==0 || pd_cnt>MAX_PD_CNT)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_INTERNAL,3);
        return FCSAN_ERROR_CODE;
    }
    
    if (!pd_list)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_INTERNAL,4);
        return FCSAN_ERROR_CODE;
    }

    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETPOOL,CMDCODE_FUNC_ISASETPOOL_B, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
 
	
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }

    /* build */
      iSMSM_INIT_POOLBINDINFO(pool_info);          // delete  iSMSM_INIT_RANKBINDINFO(rank_info);    liyb 20050831

//pool_info init  liyb   20050831
    pool_info.pdg_number=pdg_no;
    pool_info.pool_number=pool_no;
    pool_info.raid_type=raid_type;
    pool_info.rebuild_time=rebuild_time;
    pool_info.rebuild_time_flag=iSMSMCFG_POOL_FLAG_ON;
    pool_info.pd_list_count=pd_cnt;
    memcpy(pool_info.pdn_list,pd_list,pd_cnt);
    memset(pool_info.pool_name,'\0',NICKNAME_LENGTH);
    strncpy(pool_info.pool_name,pool_name,strlen(pool_name));

    if(raid_type==6)
    {
      pool_info.pool_type=iSMSMCFG_DYNAMIC_POOL;
      pool_info.base_pd_count=base_pd;
    }else{
     pool_info.pool_type=iSMSMCFG_BASIC_POOL;
	}


   
    result=iSMSMSetPoolBind(&api_info , pool_info); /* call API */
    if (result!= iSMSM_NORMAL)
    {

        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_API+2,1);
        stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
  
        return FCSAN_ERROR_CODE;
    }
    
    /* output info */
    puts(INFO_ACCEPT_BUILD_REQUEST);    /* accept info */
    printf("%-13s:%s\n", LABEL_ARRAY_NAME,arr_name);  /* array name */
    printf("%-13s:%02xh\n", LABEL_PD_GROUP, pdg_no);  /* pd group */
    printf("%-13s:", LABEL_PD_NO);       /* pd no */
    for (i=0;i<pd_cnt-1;i++)
        printf("%02xh," , pd_list[i]);
    printf("%02xh\n",pd_list[pd_cnt-1]);
    printf("%-13s:%02xh\n", LABEL_POOL_NO, pool_no);    //added liyb   20050831
    printf("%-13s:%-32s\n", LABEL_POOL_NAME, pool_name);    //added liyb   20050831
    printf("%-13s:%u\n", LABEL_RAID, raid_type);   /* raid type */
    if(raid_type==6)
    {    printf("%-13s:%u\n", LABEL_BASE_PD, base_pd);   }
   else{printf("%-13s:%s\n", LABEL_BASE_PD, NO_BASE_PD);  }

  
    printf("%-13s:%u\n\n", LABEL_REBUILD_TIME, rebuild_time);    /* rebuild_time */
    
    result=stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_B,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }
    
    puts(COMMAND_SUCCESS_INFO); /* success info */
    return 0;    /* success */

}  /* end of "setRank_b" */

/***************************************************************************************************************************/
//delete parameter "rank_no"  and pdg_no ,  add ""pool_name"     liyb 20050831
int setPool_r(char *arr_name, char* pool_name, int restart, int nounlock, int force )
{  
    iSMSMCfg_APIinfo_t     api_info;
   iSMSMPoolUnbind        pool_info;// iSMSMRankUnbind        rank_info;   changed by liyb 20050831
    int                    result;
   
    /* check parameters */
    if (!arr_name)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_R,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    else
    {
        int ary_name_len=strlen(arr_name);
        if (ary_name_len==0 || ary_name_len>ARRAY_NAME_MAX_LENGTH)
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISASETPOOL_R,CMDCODE_TYPE_INTERNAL,2);
            return FCSAN_ERROR_CODE;
        }
    }

    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETPOOL,CMDCODE_FUNC_ISASETPOOL_R, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by changhs 2002/6/5*/
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }

    /* release */
    iSMSM_INIT_POOLUNBINDINFO(pool_info);     /* initiate "pool_info" */

 //init pool_info by liyb   20050831	
    pool_info.para_mode=iSMSMCFG_SPECIFY_NAME;
    memset(pool_info.pool_name,'\0',32);
    strncpy(pool_info.pool_name,pool_name,strlen(pool_name));
    result=iSMSMSetPoolUnbind(&api_info , pool_info); /* call API */
    if (result!= iSMSM_NORMAL)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISASETPOOL_R,CMDCODE_TYPE_API+2,1);
        stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_R,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);

        return FCSAN_ERROR_CODE;
    }
    
    /* output info */
    puts(INFO_ACCEPT_RELEASE_REQUEST);    /* accept info */
    printf("%-13s:%s\n", LABEL_ARRAY_NAME,arr_name);  /* array name */
   // printf("%-13s:%02xh\n", LABEL_PD_GROUP, pdg_no);  /* pd group */   deleted by liyb  20050831
    printf("%-13s:%-32s\n\n", LABEL_POOL_NAME, pool_name);    /* pool */
    
    result=stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_R,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }

    puts(COMMAND_SUCCESS_INFO); /* success info */
    return 0;    /* success */

} /* end of "setPool_r" */

int get_pd_list (char * list, unsigned char * pd_cnt, unsigned char pd_list[])
{
        char temp_list[240];  //60 changed by liyb 20050912
        char * token , *source;

        if (!list || !pd_cnt || list[strlen(list)-1]==',' || strlen(list)>239)//59 changed by lyb  20050912
            return 1;
        *pd_cnt=0;
        strcpy(temp_list,list);
        source=temp_list;
        do
        {
            token=strsep(&source,",");
            if (hex_char_unchar(token, &pd_list[ *pd_cnt ]) )
                return 1;
            if (*pd_cnt==0 || pd_list[*pd_cnt]>pd_list[*pd_cnt - 1])
                (*pd_cnt)++;
            else
                return 1; /* non-ascent order */
        }
        while (*pd_cnt<MAX_PD_CNT && source);

        if (source)
            return 1 ; /* too many pd no */
        else
            return 0 ; /* sort(pd_list , *pd_cnt) ;    */
        
} /* end of  "get_pd_list" */


  
////simulate pool expanding      liyb  20051223
int setPool_se(char *arr_name, unsigned char pdg_no, unsigned char pd_cnt,
                           unsigned char *pd_list, char* pool_name,unsigned char emode,
                           int expand_time,   int restart,   int nounlock,   int force){
    int result ;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMPoolExpand expand_info;    
    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISASETPOOL_SE,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETPOOL,CMDCODE_FUNC_ISASETPOOL_SE, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by liyb  20050831*/
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }
    iSMSM_INIT_SIM_POOLEXPANDINFO(expand_info);
   

    expand_info.expand_mode=emode;
    expand_info.pdg_number=pdg_no;
    memcpy(expand_info.pdn_list,pd_list,MAX_PD_IN_SCSI);
    //expand_info.pdn_list=pd_list;
    expand_info.pd_list_count=pd_cnt;
    expand_info.para_mode=iSMSMCFG_SPECIFY_NAME;
	
    strncpy(expand_info.pool_name,pool_name,POOL_NAME_MAX_LENGTH);
    

    if(expand_time!=-1){
    	expand_info.expand_time_flag=iSMSMCFG_POOL_FLAG_ON;
	expand_info.expand_time=expand_time;
     }else{
       expand_info.expand_time_flag=iSMSMCFG_POOL_FLAG_OFF;
     	}
    
    
    result=iSMSMSimPoolExpand(&api_info , &expand_info);
    if (result == iSMSM_NORMAL)
        {

	    printf("%-13s:%s\n", LABEL_ARRAY_NAME,arr_name);  /* array name */
	    printf("%-13s:%02xh\n", LABEL_PD_GROUP, pdg_no);  /* pd group */
	    printf("%-13s:%-32s\n", LABEL_POOL_NAME, pool_name);    
	    printf("%-13s:", LABEL_PD_NO);       /* pd no */
	    int i=0;
	    for (i=0;i<pd_cnt-1;i++){
	        printf("%02xh," , pd_list[i]);
	    }
	    printf("%02xh\n",pd_list[pd_cnt-1]);

	    if(emode==iSMSMCFG_EXPAND_ON)    	{
	    	printf("%-13s:%s\n",LABEL_EXPAND_MODE_FLAG,"ON");
		if(expand_time>=0){
			   printf("%-13s:%u\n", LABEL_EXPAND_TIME,expand_time);      
			}
	    }
		else{
	       printf("%-13s:%s\n",LABEL_EXPAND_MODE_FLAG,"OFF");
	    }

	   unsigned long long capacity=(unsigned long long)(expand_info.sim_capacity_high)*0x10000*0x10000+expand_info.sim_capacity_low;
	   printf("%-13s:%llu\n", LABEL_CAPACITY,capacity);    
        
        }
        else /* API error */
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISASETPOOL_SE,CMDCODE_TYPE_API+2,1);        
            stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_E,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);

            return FCSAN_ERROR_CODE ; /* failed */
        }
    
    /* stop connect*/
    
    result=stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_SE,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }
    printf("%s\n",COMMAND_SUCCESS_INFO);
    return FCSAN_SUCCESS_CODE;

}//end of "-e"

/*****************************************************By Key**************************************************************/
//delete rank_no,  add pool_name   ,
//change pd no into pd_list ,add pd_cnt   
//add  emode                                                        liyb 20050831
int setPool_e(char *arr_name, unsigned char pdg_no, unsigned char pd_cnt, unsigned char *pd_list, char* pool_name,unsigned char emode, int expand_time, int restart, int nounlock, int force )
{
    int result ;
    iSMSMCfg_APIinfo_t api_info;
    iSMSMPoolExpand expand_info;    // iSMSMRankExpand expand_info;   by liyb  20050831
    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISASETPOOL_E,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETPOOL,CMDCODE_FUNC_ISASETPOOL_E, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by liyb  20050831*/
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }
    iSMSM_INIT_POOLEXPANDINFO(expand_info);//iSMSM_INIT_RANKEXPANDINFO(expand_info);   liyb  20050831
   

    expand_info.expand_mode=emode;
    expand_info.pdg_number=pdg_no;
    memcpy(expand_info.pdn_list,pd_list,MAX_PD_IN_SCSI);
    //expand_info.pdn_list=pd_list;
    expand_info.pd_list_count=pd_cnt;
    expand_info.para_mode=iSMSMCFG_SPECIFY_NAME;
	
    strncpy(expand_info.pool_name,pool_name,POOL_NAME_MAX_LENGTH);
    

    if(expand_time!=-1){
    	expand_info.expand_time_flag=iSMSMCFG_POOL_FLAG_ON;
	expand_info.expand_time=expand_time;
     }else{
       expand_info.expand_time_flag=iSMSMCFG_POOL_FLAG_OFF;
     	}
    
    
    result=iSMSMSetPoolExpand(&api_info , expand_info);//result=iSMSMSetRankExpand(&api_info , expand_info);
    if (result == iSMSM_NORMAL)
        {

	       /* output info                      changed all   by liyb  20050831
	    puts(INFO_ACCEPT_EXPAND_REQUEST);    /* accept info */
	    printf("%-13s:%s\n", LABEL_ARRAY_NAME,arr_name);  /* array name */
	    printf("%-13s:%02xh\n", LABEL_PD_GROUP, pdg_no);  /* pd group */
	    printf("%-13s:%-32s\n", LABEL_POOL_NAME, pool_name);    //added liyb   20050831
	    printf("%-13s:", LABEL_PD_NO);       /* pd no */
	    int i=0;
	    for (i=0;i<pd_cnt-1;i++)
	        printf("%02xh," , pd_list[i]);
	    printf("%02xh\n",pd_list[pd_cnt-1]);

	    if(emode==iSMSMCFG_EXPAND_ON)    	{
	    	printf("%-13s:%s\n",LABEL_EXPAND_MODE_FLAG,"ON");
		if(expand_time>=0){
			   printf("%-13s:%u\n", LABEL_EXPAND_TIME,expand_time);      
			}
	    	}
		else{
	       printf("%-13s:%s\n",LABEL_EXPAND_MODE_FLAG,"OFF");
		}



        }
        else /* API error */
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISASETPOOL_E,CMDCODE_TYPE_API+2,1);        
            stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_E,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);

            return FCSAN_ERROR_CODE ; /* failed */
        }
    
    /* stop connect*/
    
    result=stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_E,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }
    printf("%s\n",COMMAND_SUCCESS_INFO);
    return FCSAN_SUCCESS_CODE;

}//end of "-e"

/*****************************************************By Key**************************************************************/
//delete  mark, rank_no, time
//add   pool_name,  rbtime                    liyb   20050831
int setPool_c(char *arr_name, unsigned char pdg_no, char* pool_name,  unsigned char rbtime, int restart, int nounlock, int force ){
    int result ;
    iSMSMCfg_APIinfo_t api_info;

    if ( !arr_name || strlen(arr_name)==0 )
    {/* internal error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISASETPOOL_C,CMDCODE_TYPE_INTERNAL,1);    
        return FCSAN_ERROR_CODE ; /* failed */
    }
    result=start_iSMSMCfg(arr_name, CMDNAME_ISASETPOOL,CMDCODE_FUNC_ISASETPOOL_C, CMDCODE_TYPE_API, &api_info, restart,nounlock,force);  /*modified by liyb  20050831*/
    if (result==FCSAN_ERROR_CODE)
    {
        return result;
    }

 
        iSMSMRebuildTime rebuild_info;
        iSMSM_INIT_REBUILDTIMEINFO (rebuild_info);

	 iSMSMPoolInfo iPoolInfo;  //added by liyb  20050831

//init build info    liyb 20050831
	 iSMSM_INIT_POOLREBUILDTIMEINFO(rebuild_info, iPoolInfo);
	 iPoolInfo.para_mode=iSMSMCFG_SPECIFY_NAME;
	 memset(iPoolInfo.pool_name,'\0',NICKNAME_LENGTH);
	 strncpy(iPoolInfo.pool_name,pool_name,strlen(pool_name));
  
	 rebuild_info.rebuild_time=rbtime;


       
        result=iSMSMSetRebuildTime(&api_info ,rebuild_info);
        if (result == iSMSM_NORMAL)
        {
          printf("%s\n%-20s:%s\n%-20s:%02xh\n%-20s:%s\n%-20s:%u\n\n",INFO_ACCEPT_CHANGE_R_REQUEST,
		  	LABEL_ARRAY_NAME,arr_name,
		  	LABEL_PD_GROUP,pdg_no,
		  	LABEL_POOL_NAME,pool_name,
		  	LABEL_REBUILD_TIME,rbtime);          //changed by liyb 20050831
        }
        else /* API error */
        {
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISASETPOOL_C,CMDCODE_TYPE_API+2,1);        
                stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_C,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
            return FCSAN_ERROR_CODE ; /* failed */
        }

    result=stop_iSMSMCfg(CMDNAME_ISASETPOOL, CMDCODE_FUNC_ISASETPOOL_C,CMDCODE_TYPE_API+3, &api_info,nounlock,restart);
    if(result == FCSAN_ERROR_CODE)
    {
        return(result);
    }
    printf("%s\n",COMMAND_SUCCESS_INFO);
    return FCSAN_SUCCESS_CODE;

}//end of "-c"

/***************************************************************************************************************************/

void printUsage(int option_id)
{
    switch (option_id)
    {
        case OPTION_ID_B:
            fprintf(stderr,"%s\n%s\n",USAGE_B , USAGE_HELP);
            break;
        case OPTION_ID_SB:
            fprintf(stderr,"%s\n%s\n",USAGE_SB , USAGE_HELP);
            break;
        case OPTION_ID_R:
            fprintf(stderr,"%s\n%s\n",USAGE_R , USAGE_HELP);
            break;
        case OPTION_ID_E:
            fprintf(stderr,"%s\n%s\n",USAGE_E , USAGE_HELP);
            break;
        case OPTION_ID_SE:
            fprintf(stderr,"%s\n%s\n",USAGE_SE , USAGE_HELP);
            break;
        case OPTION_ID_C:
            fprintf(stderr,"%s\n%s\n",USAGE_C , USAGE_HELP);
    } /* end of "switch" */

} /* end of "printUsage" */

/***************************************************************************************************************************/
int main(int argc, char * argv[])
{
    int restart=0, nounlock=0, force=0;
    int cursor, option_id;
    unsigned char pdg_no ;// rank_no;  deleted by liyb 20050831

    
    char pool_name[33]; //added by liyb  20050831
    unsigned char base_pd; //added by liyb  20050831
    unsigned short pool_no;


    if (argc==1)
    { /* no option */
        fprintf(stderr,"%s\n%s\n%s\n%s\n%s\n%s\n%s\n",USAGE_B,USAGE_SB,USAGE_R,USAGE_E,USAGE_SE,USAGE_C,USAGE_HELP);
        return FCSAN_ERROR_CODE; 
    }

    if (!strcmp(argv[1],OPTION_B))    /* -b */
        option_id=OPTION_ID_B;
    else if (!strcmp(argv[1],OPTION_R))    /* -r */
        option_id=OPTION_ID_R;
    else if (!strcmp(argv[1],OPTION_E))    /* -e */
        option_id=OPTION_ID_E;
    else if (!strcmp(argv[1],OPTION_C))    /* -c */
        option_id=OPTION_ID_C;
    else if (!strcmp(argv[1],OPTION_SB))    /* -sb */
        option_id=OPTION_ID_SB;
    else if (!strcmp(argv[1],OPTION_SE))    /* -se */
        option_id=OPTION_ID_SE;
    else
    { /* "-?" or undefined option */
        if (!strcmp(argv[1],OPTION_HELP) && argc==2 )
        {/* -? */
            printf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n",USAGE_B,USAGE_SB,USAGE_R,USAGE_E,USAGE_SE,USAGE_C,USAGE_HELP);
            return FCSAN_SUCCESS_CODE; 
        } /* end of "-?"　*/
        else
        {
            fprintf(stderr, "%s\n%s\n%s\n%s\n%s\n%s\n%s\n",USAGE_B,USAGE_SB,USAGE_R,USAGE_E,USAGE_SE,USAGE_C,USAGE_HELP);
            return FCSAN_ERROR_CODE;
        }
    }
//add "!strcmp(argv[1],OPTION_R) "  in "if()" liyb 20050831  , because   there is no parameter "-pdg"  in CLI  "-r" 
    if (argc<6  
         || strcmp(argv[2],PARAM_ANAME)  /* "-aname" error */
         ||(strcmp(argv[1],OPTION_R)&&strcmp(argv[4],PARAM_PDG))        /* "-pdg" error */ 
       )
    {
        printUsage(option_id);
        return FCSAN_ERROR_CODE;
    }    

    if (isInvalidName(argv[3], 32))
    {
        fprintf(stderr,"%s::%02u%03u:%s(-aname:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
            return FCSAN_ERROR_CODE;
    }

//add "!strcmp(argv[1],OPTION_R) "  in "if()" liyb 20050831  , because   there is no parameter "-pdg"  in CLI  "-r" 
    if (strcmp(argv[1],OPTION_R) &&hex_char_unchar(argv[5], &pdg_no) )  
     {
        fprintf(stderr,"%s::%02u%03u:%s(-pdg:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
            return FCSAN_ERROR_CODE;
     }  


      memset(pool_name,'\0',33);

    if (option_id==OPTION_ID_B || option_id==OPTION_ID_SB )
    {/* -b  or -sb*/
        unsigned char pd_cnt, pd_list[MAX_PD_CNT] ;
        unsigned char raid_type , rebuild_time=0;

//added by liyb  20050831
	if ( argc>21 || argc<16             
            ||strcmp(argv[6],PARAM_PDN)        /* "-pdn" error */
            ||strcmp(argv[8],PARAM_POOLNO)    /* "-pno" error */    ////changed by liyb 20050905
            ||strcmp(argv[10],PARAM_POOLNAME)    /* "-pname" error */////changed by liyb 20050905
            ||strcmp(argv[12],PARAM_RAID)    /* "-raid" error */
            ||strcmp(argv[14],PARAM_BASE_PD)   /* "-base_pd" error */
          ) {
            printUsage(option_id);
            return FCSAN_ERROR_CODE; 
        } 

        if (get_pd_list(argv[7],&pd_cnt, pd_list))
        {
            fprintf(stderr,"%s::%02u%03u:%s(-pdn:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
                return FCSAN_ERROR_CODE;
        }
//delete  if (hex_char_unchar(argv[9], &rank_no))  by liyb 20050831
        if (hex4toushort(argv[9], &pool_no)||pool_no>255)
        {
            fprintf(stderr,"%s::%02u%03u:%s(-pno:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[9]);
                return FCSAN_ERROR_CODE;
        }

//added by liyb  20050831,  to validate  if the pool_name is right
        if (isInvalidName(argv[11], 32) ){        
                 fprintf(stderr,"%s::%02u%03u:%s(-pname:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[11]);
                return FCSAN_ERROR_CODE;
        }

        memcpy(pool_name,argv[11],strlen(argv[11]));
		   
//raid should be 1,5,10,50,6   liyb ,20050831
        if (dec_char_unchar(argv[13], &raid_type) || 
              (raid_type!=1 && raid_type!=5 && raid_type!=10 && raid_type!=50&& raid_type!=6 )
           )
        {
            fprintf(stderr,"%s::%02u%03u:%s(-raid:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[13]);
                return FCSAN_ERROR_CODE;
        }
//base_pd should be -,6,10,  liyb ,20050831
        if (!strcmp(argv[15],"6")){
			base_pd=6;
	}else if(!strcmp(argv[15],"10")){
	             base_pd=10;
		}else if(!strcmp(argv[15],"-")){
                    base_pd=0;
		}else{
            fprintf(stderr,"%s::%02u%03u:%s(-basepd:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[15]);
                return FCSAN_ERROR_CODE;			
		}
		

//change "cursor=12"  to "cursor=16"   liyb  20050831
   for (cursor=16;cursor<argc;cursor++)
        {
            if (!strcmp(argv[cursor],PARAM_RBTIME))
            { /* -rbtime */
                if (cursor==argc-1 || restart || nounlock || force)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                cursor++;
                if (dec_char_unchar(argv[cursor],&rebuild_time) || rebuild_time>255)
                {
                    fprintf(stderr,"%s::%02u%03u:%s(-rbtime:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                        MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[cursor]);
                        return FCSAN_ERROR_CODE;
                }
            }
            else if (!strcmp(argv[cursor],PARAM_RESTART))
            { /* -restart */
                if (nounlock || force || restart)
                {
                    printUsage(option_id);
                    return  FCSAN_ERROR_CODE; 
                }
                restart=1;
            }
            else if (!strcmp(argv[cursor],PARAM_NOUNLOCK))
            { /* -nounlock */
                if (force || nounlock)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                nounlock=1;
            }
            else if (!strcmp(argv[cursor],PARAM_FORCE))
            { /* -force */
                if (force)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                force=1;
            }
            else /* error token */
            {
                printUsage(option_id);
                return FCSAN_ERROR_CODE; 
            }
        }    /* end of "for" */

	 if(option_id ==OPTION_ID_B){  
            return setPool_b(argv[3] , pdg_no , pd_cnt , pd_list , pool_no , pool_name,raid_type ,base_pd, rebuild_time, restart, nounlock, force );
	 }else if (option_id == OPTION_ID_SB){
	     return setPool_sb(argv[3] , pdg_no , pd_cnt , pd_list , pool_no , pool_name,raid_type ,base_pd, rebuild_time, restart, nounlock, force );
	 }
	 
    } /* end of "-b"　*/
    
    if (option_id==OPTION_ID_R)
    {/* -r */
    
  //added by liyb 20050831
        if (argc>9 || argc<6               
            ||strcmp(argv[4],PARAM_POOLNAME)    /* "-pname" error */   //changed by liyb 20050905
                   )
        {
            printUsage(option_id);
            return FCSAN_ERROR_CODE; 
        } 

	//added by liyb  20050908
        if (isInvalidName(argv[5], 32) ){        
                 fprintf(stderr,"%s::%02u%03u:%s(-pname:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                return FCSAN_ERROR_CODE;
        }  
       memcpy(pool_name,argv[5],strlen(argv[5]));
	   
        for (cursor=6;cursor<argc;cursor++)   // for (cursor=8;cursor<argc;cursor++)  liyb   20050831
        {
            if (!strcmp(argv[cursor],PARAM_RESTART))
            { /* -restart */
                if (nounlock || force || restart)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                restart=1;
            }
            else if (!strcmp(argv[cursor],PARAM_NOUNLOCK))
            { /* -nounlock */
                if (force || nounlock)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                nounlock=1;
            }
            else if (!strcmp(argv[cursor],PARAM_FORCE))
            { /* -force */
                if (force)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                force=1;
            }
            else /* error token */
            {
                printUsage(option_id);
                return FCSAN_ERROR_CODE; 
            }
        }    /* end of "for" */
        return setPool_r(argv[3] ,  pool_name, restart, nounlock, force );

    } /* end of "-r"　*/    

    if (option_id==OPTION_ID_E || option_id==OPTION_ID_SE)
    {/* -e  or -se*/

	 unsigned char pd_cnt, pd_list[MAX_PD_CNT] ;
        unsigned char  pd_no;
	  long expand_time =0;  //default value
	 unsigned char  expandmode;

        if (argc>17 || argc<12
            ||strcmp(argv[6],PARAM_POOLNAME)    /* "-pool" error */   //changed by liyb 20050905
            ||strcmp(argv[8],PARAM_PDN )  /* "-pdn" error */  
            ||strcmp(argv[10],PARAM_EXPANDMODE)    /* "-emode" error */  //added by liyb 20050906
          ) {
            printUsage(option_id);
            return FCSAN_ERROR_CODE; 
        } 

//added by liyb  20050908
        if (isInvalidName(argv[7], 32) ){        
                 fprintf(stderr,"%s::%02u%03u:%s(-pname:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
                return FCSAN_ERROR_CODE;
        }

        memcpy(pool_name,argv[7],strlen(argv[7]));
//add    liyb   20050831
        if (get_pd_list(argv[9],&pd_cnt, pd_list))
        {
            fprintf(stderr,"%s::%02u%03u:%s(-pdn:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[9]);
                return FCSAN_ERROR_CODE;
        }
	
//added by liyb  to check "-emode "   20050831
        if (!strcmp(argv[11],"off")){
			expandmode=iSMSMCFG_EXPAND_OFF;
		}else if (!strcmp(argv[11],"on")){
			expandmode=iSMSMCFG_EXPAND_ON;}
		else {
            fprintf(stderr,"%s::%02u%03u:%s(-emode:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[11]);
                return FCSAN_ERROR_CODE;
        }


   for (cursor=12;cursor<argc;cursor++)
        {
            if (!strcmp(argv[cursor],PARAM_EXPTIME))
            { /* -expandtime */
                if (cursor==argc-1 || restart || nounlock || force)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                cursor++;
                if (dec_char_unlong(argv[cursor],&expand_time)    || expand_time>255)
                {
                    fprintf(stderr,"%s::%02u%03u:%s(-exptime:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                        MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[cursor]);
                        return FCSAN_ERROR_CODE;
                }
            }
            else if (!strcmp(argv[cursor],PARAM_RESTART))
            { /* -restart */
                if (nounlock || force || restart)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                restart=1;
            }
            else if (!strcmp(argv[cursor],PARAM_NOUNLOCK))
            { /* -nounlock */
                if (force || nounlock)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                nounlock=1;
            }
            else if (!strcmp(argv[cursor],PARAM_FORCE))
            { /* -force */
                if (force)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                force=1;
            }
            else /* error token */
            {
                printUsage(option_id);
                return FCSAN_ERROR_CODE; 
            }
        }    /* end of "for" */

       if(option_id == OPTION_ID_E){
           return setPool_e(argv[3] ,  pdg_no, pd_cnt,  pd_list, pool_name, expandmode,expand_time,  restart,  nounlock,  force );
       }else if(option_id == OPTION_ID_SE){
           return setPool_se(argv[3] ,  pdg_no, pd_cnt,  pd_list, pool_name, expandmode,expand_time,  restart,  nounlock,  force );
    	}
          
    } /* end of "-e"　*/

    if (option_id==OPTION_ID_C)
    {/* -c */

        
	 unsigned char rbtime =0;
//delete  ||strcmp(argv[6],PARAM_RANK)        /* "-rank" error */    liyb  20050831
        if (argc>13 || argc<10  
	     ||(strcmp(argv[6],PARAM_PNAME))
            ||(strcmp(argv[8],PARAM_RBTIME) )    /* "-rbtime" */
          ) {
            printUsage(option_id);
            return FCSAN_ERROR_CODE; 
        } 
//added by liyb  20050908
        if (isInvalidName(argv[7], 32) ){        
                 fprintf(stderr,"%s::%02u%03u:%s(-pname:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[7]);
                return FCSAN_ERROR_CODE;
        }

        memcpy(pool_name,argv[7],strlen(argv[7]));

//add to validate -rbtime   liyb 20050831

	    if (dec_char_unchar(argv[9],&rbtime) || rbtime>255)
                    {
                        fprintf(stderr,"%s::%02u%03u:%s(%s:%s)\n",CMDNAME_ISASETPOOL,MSGNO_FCSAN_PREFIX,
                            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[8], argv[9]);
                            return FCSAN_ERROR_CODE;
                    }	 

// add the "for" recycle   liyb   20050831
  for (cursor=10;cursor<argc;cursor++)   
        {
            if (!strcmp(argv[cursor],PARAM_RESTART))
            { /* -restart */
                if (nounlock || force || restart)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                restart=1;
            }
            else if (!strcmp(argv[cursor],PARAM_NOUNLOCK))
            { /* -nounlock */
                if (force || nounlock)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                nounlock=1;
            }
            else if (!strcmp(argv[cursor],PARAM_FORCE))
            { /* -force */
                if (force)
                {
                    printUsage(option_id);
                    return FCSAN_ERROR_CODE; 
                }
                force=1;
            }
            else /* error token */
            {
                printUsage(option_id);
                return FCSAN_ERROR_CODE; 
            }
        }    /* end of "for" */
        return setPool_c(argv[3] , pdg_no,  pool_name,rbtime, restart, nounlock,  force );

        
    } /* end of "-c"　*/



} /* end of "main" */
