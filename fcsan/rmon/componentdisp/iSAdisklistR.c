/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistR.c,v 1.2306 2007/04/16 07:24:33 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistR.c,v 1.2306 2007/04/16 07:24:33 liuyq Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "string.h"
#include "general.h"
#include "iSAdisklist.h"



//change name by liyb 20050829
int diskList_pool(unsigned char array_id,unsigned short lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPool *data=NULL;  //iSMSMRank *data=NULL;   liyb  20050830
    char *state=""; 
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int raid=-1;
    int i,result ;

//add local variable by liyb 20050830
     iSMSMPoolId  poolid;


    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf.data =NULL ;
    poolid.array_id=array_id;
     
    result=iSMSMGetRankGroupListInfo(&poolid, & i_inf, & o_inf);   //delete iSMSMGetRankListInfo(array_id,&i_inf,&o_inf); ,liyb 20050830
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */
    
    /* output table header */
    printf("%-9s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%5s%s%-32s%s%-16s%s%4s%s%2s%s%20s%s%11s%s%15s%s%20s\n",
        POOL_NO_LABEL,TABLE_COL_SEPARATOR,
        POOL_NAME_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL,TABLE_COL_SEPARATOR,
        RAID_LABEL,TABLE_COL_SEPARATOR,
        BASE_PD_LABEL,TABLE_COL_SEPARATOR,
        CAPACITY_LABEL,TABLE_COL_SEPARATOR,
        PROGRESSION_LABEL,TABLE_COL_SEPARATOR,
        REBUILDING_TIME_LABEL,TABLE_COL_SEPARATOR,
        REMAIN_CAPACITY_LABEL);
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
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
         i_inf.data_size=get_num*sizeof(iSMSMPool);  //change iSMSMRank to  iSMSMPool   liyb 20050830        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMPool));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);// added by keyan 2002-7-1
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOL,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            fflush(stderr);// added by keyan 2002-7-1
            return FCSAN_ERROR_CODE;
        }
        
        /* call API */
        result=iSMSMGetRankGroupListInfo(&poolid, & i_inf, & o_inf);    //  change iSMSMGetRankListInfo(array_id,&i_inf,&o_inf);  liyb 20050830
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);// added by keyan 2002-7-1
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            fflush(stderr);// added by keyan 2002-7-1
            return FCSAN_ERROR_CODE;
        }
        
        /* Output Table Body */
        data=(iSMSMPool *)i_inf.data ;
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */

          raid=getRaidtype(data[i].raid_type);
          if(raid==-1)
          {
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_INTERNAL,9001);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1  
                return FCSAN_ERROR_CODE;
            }
           getStateDescribe(data[i].expansion_state, data[i].pool_matter,&state);
           if(!state ||strlen(state)==0)
            {
                      fflush(stdout);// added by keyan 2002-7-1
                      fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_INTERNAL,9002);
                      free(i_inf.data);  /* added by yangah when detecting memory leak */
                      fflush(stderr);// added by keyan 2002-7-1  

                        return FCSAN_ERROR_CODE;
              } 
            

//remove rank no,    remove pdg no ,  add poolno,poolname   liyb 20050830
 //remove "if" to next some line   // if (data[i].expansion_state== 0x00 && data[i].pool_state== 0x11){
                printf("%04xh%s%-32s%s%-16s%s%4u%s",
                    data[i].pool_num,TABLE_COL_SEPARATOR,
                    data[i].poolname,TABLE_COL_SEPARATOR,
                    state,TABLE_COL_SEPARATOR,
                    raid,TABLE_COL_SEPARATOR);
//print base_pd  liyb 20050831
	          if(raid==6){
			printf("%2d%s", data[i].num_of_base_pd,TABLE_COL_SEPARATOR);
	          	}else{
	          	printf("%2s%s", NO_BASE_PD,TABLE_COL_SEPARATOR);
		    }

//to get pool capacity (block)	  
                 unsigned long long ullPoolCapacity=0;
                 result=Char8ToInt64(data[i].ttl_realcpty ,&ullPoolCapacity);

	       
		  if(result)
		  {
		    fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_INTERNAL,9003);
                  free(i_inf.data);  
                  fflush(stderr);
		    return FCSAN_ERROR_CODE;
		  }

//print capacity of pool liyb 20050831
                printf("%20llu%s",ullPoolCapacity,TABLE_COL_SEPARATOR);
//print progression   liyb 20050831
		  if (data[i].expansion_state== 0x00 && data[i].pool_matter== 0x11){    //change expand_state,  rank_state
		  	 printf("%11u%s",data[i].rebuild_rate,TABLE_COL_SEPARATOR);
		  	}else{
		  	  printf("%11s%s","--",TABLE_COL_SEPARATOR);
		  	}
		 printf("%15u%s", data[i].rebuild_time,TABLE_COL_SEPARATOR);//,TABLE_COL_SEPARATOR, data[i]. expand_time);

//to get used capacity (block)	  
                 unsigned long long ullUsedCapacity=0;
                if(raid==6){
		        result=Char8ToInt64(data[i].alc_virtualcpty,&ullUsedCapacity);
		  }else{
		   	 result=Char8ToInt64(data[i].alc_cpty_real,&ullUsedCapacity);
		  }
	       
		  if(result)
		  {
		    fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOL,CMDCODE_TYPE_INTERNAL,9003);
                  free(i_inf.data);  
                  fflush(stderr);
		    return FCSAN_ERROR_CODE;
		  }
               printf("%20llu\n",ullPoolCapacity-ullUsedCapacity);

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
    
} /* end of "diskList_pool" */



//change parameters by liyb   deleted  pdg , replace rankno with pool no  20050829
//delete rank info from outputing and add pool info(base_pd)   liyb 20050830      ---fininshed
int diskList_pooll(unsigned char array_id, unsigned short pool_no,unsigned int lcount)
{
       if (lcount==0){
           fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }

   
    iSMSMinDataInfo i_inf; //delete ,i_inf_ldset
    iSMSMoutDataInfo o_inf; //delete  ,o_inf_ldset
    //iSMSMRankId rankId; deleted by liyb 20050830
    iSMSMPoolId     poolID;   //added by liyb 20050830
    iSMSMLd* LDdata;
    unsigned int loop_count=1;
    int i,get_num;
    int result;


//to get base_pd from pool info    liyb 20050830
   iSMSMPool * pool_data=NULL;
   iSMSMoutDataInfo pool_o_inf;
   result=getPoolInfo( pool_no,  array_id, &pool_data,&pool_o_inf,&loop_count,CMDCODE_FUNC_ISADISKLIST_POOLL,CMDCODE_TYPE_INTERNAL);

   if(result){
   	return result;
   	}

    unsigned char base_pd=pool_data->num_of_base_pd;
    free(pool_data)	;


/* modified by chs & key & hujun, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(poolID);   

    /* call API to get total number */
    i_inf.data = NULL ;

//add pool info by liyb 20050830
    poolID.array_id=array_id;
    poolID.pool_num=pool_no;
	
//replace iSMSMGetRankLdInfo() with iSMSMGetRankGroupLdInfo() 20050830
// result = iSMSMGetRankLdInfo(&rankId,&i_inf,&o_inf ) ;
   result = iSMSMGetRankGroupLdInfo(&poolID,&i_inf,&o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_POOLL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    
    /*print command title*/
    printf("%-14s: %04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-14s: %04xh\n\n",POOL_NO_LABEL,pool_no);

   printLDHeadInfo();
   printf("%-2s%s\n",BASE_PD_LABEL,TABLE_COL_SEPARATOR);   

    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY || o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get LD list info */
    i_inf.current_num = 1;
    i_inf.table_rev = iSMSM_TBL_FIRST;
    while (o_inf.remain_num > 0)
    {
        get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
          /* Initiate "i_inf" */
        i_inf.get_num = get_num ;
        i_inf.data_size = get_num * sizeof(iSMSMLd);
          /* Memory Allocation */
        i_inf.data = calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data ){/* Memory allocation failure */
        fflush(stdout);// added by keyan 2002-7-1 
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLL,
            CMDCODE_TYPE_SYSTEMFUNC,1);// added by keyan 2002-7-1
        fflush(stderr);// added by keyan 2002-7-1
        return FCSAN_ERROR_CODE;
        }


		
       // change " result=iSMSMGetRankLdInfo(&rankId, &i_inf, &o_inf ) ;"  by liyb  20050831
	result=iSMSMGetRankGroupLdInfo(&poolID, &i_inf, &o_inf ) ;
        if (result!=iSMSM_NORMAL){/* API error */
        fflush(stdout);// added by keyan 2002-7-1
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_POOLL,CMDCODE_TYPE_API+1,loop_count++);
        free(i_inf.data);
        fflush(stderr);// added by keyan 2002-7-1
        return FCSAN_ERROR_CODE;
        }
        
        /*output ld info*/
        LDdata = (iSMSMLd*)i_inf.data;
        for (i = 0;i < o_inf.return_num;i++){
            int err_no;
            if (err_no=outLDPartInfo(LDdata[i],CMDCODE_FUNC_ISADISKLIST_POOLL,array_id))
            {/* err_no: 1~5 (error occurred) 0 (success) */
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLL,CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1    
                return FCSAN_ERROR_CODE;
            } /* added by Yang AH */

 	   //print base_pd
 	    printBasePdValue(base_pd); //added by liyb
 	    printf("\n");

       	}
        free(i_inf.data);  
        i_inf.current_num += o_inf.return_num;
        i_inf.table_rev = o_inf.table_rev;
    } /*ld while-loop end*/
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
}

//delete pd_grp_num ,replace rank_no with pool_no by liyb 20050829
int diskList_poolp(unsigned char array_id, unsigned short pool_no,unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPd* pdInfo;
    iSMSMPoolId  poolID; //add by liyb 20050830
	//iSMSMRankId rankId;
    unsigned int loop_count=1;
    int i,get_num;
    int result;

    if (lcount==0){
           fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLP,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(poolID);
   // ISMSM_CLI_INIT_ZERO(rankId);

    /* call API to get total number */
    i_inf.data = NULL ;
//init poolID by liyb 20050830
    poolID.array_id = array_id;
    poolID.pool_num = pool_no;

    result = iSMSMGetRankGroupPdInfo(&poolID,&i_inf,&o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_POOLP,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }

	
    /*print command title*/
    printf("%-14s: %04d\n",ARRAY_ID_LABEL,array_id);
   printf("%-14s: %04xh\n\n",POOL_NO_LABEL,pool_no);  //add poolno label by liyb 20050830
  //  printf("%-14s: %02xh-%02xh\n\n",RANK_NO_LABEL,pd_grp_num,rank_no);   //delete some infos about rank  liyb 2050831
    printf("%-7s%s%-11s%s%15s%s%-8s%s",PD_NO_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL,TABLE_COL_SEPARATOR,CAPACITY_LABEL,TABLE_COL_SEPARATOR,DIVISION_LABEL,TABLE_COL_SEPARATOR);


    printf("%-5s%s",SPIN_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20051216
    printf("%-4s\n",PD_TYPE_LABEL);//added by liyb 20051216

    for (i = 0;i < 80;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");
    
    if (result==iSMSM_TBL_NOENTRY || o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get PD list info */
    i_inf.current_num = 1;
    i_inf.table_rev = iSMSM_TBL_FIRST;
    while (o_inf.remain_num > 0)
    {
        get_num = o_inf.remain_num <= lcount ? o_inf.remain_num : lcount;
          /* Initiate "i_inf" */
        i_inf.get_num = get_num ;
        i_inf.data_size = get_num * sizeof(iSMSMPd);
          /* Memory Allocation */
        i_inf.data = calloc(get_num,sizeof(iSMSMPd));
        if ( !i_inf.data ){/* Memory allocation failure */
        fflush(stdout);// added by keyan 2002-7-1
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLP,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        fflush(stderr);// added by keyan 2002-7-1
        return FCSAN_ERROR_CODE;
        }
        
         result=iSMSMGetRankGroupPdInfo(&poolID,&i_inf,&o_inf ) ;
        if (result!=iSMSM_NORMAL){/* API error */
            fflush(stdout);// added by keyan 2002-7-1
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_POOLP,CMDCODE_TYPE_API+1,loop_count++);
            free(i_inf.data);
            fflush(stderr);// added by keyan 2002-7-1
            return FCSAN_ERROR_CODE;
        }
        pdInfo = (iSMSMPd *)i_inf.data;
        
        /* print PD List */
        for (i = 0;i < o_inf.return_num; i++)
        {/* print a record in one loop procedure */
            int err_no; /* added by Yang AH */
            printf("%02xh-%02xh%s",pdInfo[i].pd_grp_num,pdInfo[i].pd_num,TABLE_COL_SEPARATOR); /*PD_No*/
            /*print state*/
            if (err_no=outPdState(pdInfo[i].pd_matter))
            { /* err_no: 1(error occurred) 0(success) */
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLP,CMDCODE_TYPE_INTERNAL,9001);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1
                    return FCSAN_ERROR_CODE;
            }
            /*print capacity*/
            printf("%15.0f%s",pdInfo[i].sector_num*512.0,TABLE_COL_SEPARATOR);
            /*print Division*/
            if (err_no=outPdDivision(pdInfo[i].pd_flag))
            { /* error_no: 1(error occurred) 0(success) */
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_POOLP,CMDCODE_TYPE_INTERNAL,9002);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1
                return FCSAN_ERROR_CODE;
            }

          /*print pd_revolution  added by liyb 20051216*/
            printf("%5d%s",pdInfo[i].pd_revolution,TABLE_COL_SEPARATOR);
         /*print pd_type  added by liyb 20051216*/
         if(pdInfo[i].pd_type==PD_TYPE_FC_VALUE) {
              printf("%s",PD_TYPE_FC_DESC);
          }else if(pdInfo[i].pd_type==PD_TYPE_SATA_VALUE){
              printf("%s",PD_TYPE_SATA_DESC);
          }else if(pdInfo[i].pd_type==PD_TYPE_SAS_VALUE){
              printf("%s",PD_TYPE_SAS_DESC);
          }else{
               printf("%s",NULL_STATE);
          }
			
           printf("\n");
        }/* end of "for" */
        
        /* release allocated memory */
        free(i_inf.data);
        
        /* prepare for the next loop procedure */
        i_inf.current_num += o_inf.return_num;
        i_inf.table_rev = o_inf.table_rev ;
    }/* end of "while" */
    
    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
}
