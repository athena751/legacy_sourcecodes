/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistP.c,v 1.2309 2007/04/16 07:24:33 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistP.c,v 1.2309 2007/04/16 07:24:33 liuyq Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAdisklist.h"


int diskList_p(unsigned char array_id,unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPd* pdInfo;
    unsigned int loop_count=1;
    int i,get_num;
    int result;
    char pool_name[33];

    unsigned short pool_no;
    iSMSMPool   *pool_data=NULL;
	
    if (lcount==0){
           fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_P,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    /* call API to get total number */
    i_inf.data = NULL ;
    result = iSMSMGetPdListInfo(array_id,&i_inf,&o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_P,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    
    /*print command title*/
    printf("%s    : %04d\n\n",ARRAY_ID_LABEL,array_id);

	
    printf("%-7s%s",PD_NO_LABEL,TABLE_COL_SEPARATOR);   //changed by liyb 20050906
    printf("%-11s%s",STATE_LABEL,TABLE_COL_SEPARATOR);//changed by liyb 20050906
    printf("%-15s%s",CAPACITY_LABEL,TABLE_COL_SEPARATOR);//changed by liyb 20050906
    printf("%s%s", POOL_NO_LABEL,TABLE_COL_SEPARATOR);//changed by liyb 20050906
    printf("%-32s%s", POOL_NAME_LABEL,TABLE_COL_SEPARATOR);    //changed by liyb 20050906
    printf("%-8s%s", DIVISION_LABEL,TABLE_COL_SEPARATOR);//changed by liyb 20050906
    printf("%-11s%s",PROGRESSION_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20051210
    printf("%-5s%s",SPIN_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20051214
    printf("%-4s\n",PD_TYPE_LABEL);//added by liyb 20051214
	
    for (i = 0;i < 58;i++)
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
        get_num = o_inf.remain_num<=lcount?o_inf.remain_num:lcount;
          /* Initiate "i_inf" */
        i_inf.get_num = get_num ;
        i_inf.data_size = get_num * sizeof(iSMSMPd);
          /* Memory Allocation */
        i_inf.data = calloc(get_num,sizeof(iSMSMPd));
        if ( !i_inf.data ){/* Memory allocation failure */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_P,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
        }
	        
         result=iSMSMGetPdListInfo(array_id,&i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL){/* API error */
        fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_P,CMDCODE_TYPE_API+1,loop_count++);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
        }
        pdInfo = (iSMSMPd *)i_inf.data;
        
        /* print PD List */
        for (i = 0;i < o_inf.return_num; i++)
        {/* print a record in one loop procedure */
        printf("%02xh-%02xh%s",pdInfo[i].pd_grp_num,pdInfo[i].pd_num,TABLE_COL_SEPARATOR); /*PD_No*/
        /*print state*/
        if (outPdState(pdInfo[i].pd_matter))
        {/* err_no: 1(error occurred) 0(success) */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_P,CMDCODE_TYPE_INTERNAL,9001);
            free(i_inf.data);  /* added by yangah when detecting memory leak */
                return FCSAN_ERROR_CODE;
        }
        /*print capacity*/
        printf("%15.0f%s",pdInfo[i].sector_num*512.0,TABLE_COL_SEPARATOR);

  //to get pool info   liyb 20050830
    if((pdInfo[i].flag_info&0x80)==0x80)     //have  pool          added by liyb 20050902  , wait for modifycation.....
    	{
         iSMSMoutDataInfo pool_o_inf	;
         int loop_count=1;
         pool_no=pdInfo[i].pool_num;
         result=getPoolInfo( pool_no,  array_id,  &pool_data,&pool_o_inf,&loop_count,CMDCODE_FUNC_ISADISKLIST_P,CMDCODE_TYPE_INTERNAL);
 
 	 if(result){
 	 	return result;
 	  }
 	 chars2str(pool_data->poolname,  32,pool_name);//changed by liyb 20050906

	 printf("%04xh%s%-32s%s",pool_no,TABLE_COL_SEPARATOR,pool_name,TABLE_COL_SEPARATOR);
	    
    	}else{
         printf("%-5s%s%-32s%s",POOL_NUM_MASK_DESC,TABLE_COL_SEPARATOR,POOL_NAME_MASK_DESC,TABLE_COL_SEPARATOR);
       }


        /*print Division*/
        if (outPdDivision(pdInfo[i].pd_flag))
        {
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_P,CMDCODE_TYPE_INTERNAL,9002);
            free(i_inf.data);  /* added by yangah when detecting memory leak */
                return FCSAN_ERROR_CODE;
        }


        
    /*print rebuild rate  added by liyb 20051210*/
        if(pdInfo[i].pd_matter==0x11) {
            printf("%11d%s",pdInfo[i].rebuild_rate,TABLE_COL_SEPARATOR);}
        else{
            printf("%11s%s","--",TABLE_COL_SEPARATOR);}

    /*print pd_revolution  added by liyb 20051214*/
       printf("%5d%s",pdInfo[i].pd_revolution,TABLE_COL_SEPARATOR);
    /*print pd_type  added by liyb 20051214*/
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

//this function is wholly changed by liyb 20050830
int diskList_pl(unsigned char array_id,unsigned char pd_grp_num,unsigned char pd_num,unsigned int lcount)
{

     if (lcount==0){
           fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }

  //new method to get ld info from pd info
  // 1 get pool no according pdinfo
  //  2get ld info according pool no imitating diskList_pooll()

  //1  get pool no
      //1-1 get pd 

     iSMSMinDataInfo pd_i_inf;
     iSMSMoutDataInfo pd_o_inf;
     
     iSMSMPdId pdId;
     int result;
     unsigned short pool_no;
     iSMSMPd * pdInfo;
     iSMSMPool  *pool_data=NULL;
     int i = 0;
		
    ISMSM_CLI_INIT_ZERO(pdId);   

    /* call API to get rank_no */
    pd_i_inf.data_size = sizeof(iSMSMPd);
    pd_i_inf.data = malloc(pd_i_inf.data_size);
    if (!pd_i_inf.data){/* Memory allocation failure */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PL,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
    }
    
     pdId.array_id=array_id;   //added by liyb 20050906
     pdId.pd_num=pd_num;//added by liyb 20050906
     pdId.pd_grp_num=pd_grp_num;//added by liyb 20050906

     result=iSMSMGetPdInfo(&pdId,&pd_i_inf,&pd_o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_API,1);
        free(pd_i_inf.data);
        return FCSAN_ERROR_CODE;
    }

    pdInfo=(iSMSMPd *)pd_i_inf.data;
	
     //to get pool info   liyb 20050830
    if((pdInfo->flag_info&0x80)==0x80)     //have  pool          added by liyb 20050902  , wait for modifycation.....
    	{
	    pool_no=pdInfo->pool_num;
	    iSMSMoutDataInfo  pool_o_info;
	    int pool_loop=1;
	    if(result=getPoolInfo( pool_no,  array_id,  &pool_data,&pool_o_info,&pool_loop,CMDCODE_FUNC_ISADISKLIST_PD,CMDCODE_TYPE_INTERNAL))
	    	{
	    	       return result;
	    	}
	    //1-2 get pool no
           pool_no=pdInfo->pool_num;	   
    	}else{
    	       /*print command title*/
            printf("%-14s: %04u\n",ARRAY_ID_LABEL,array_id);
            printf("%-14s: %04xh\n\n",PD_NO_LABEL,pd_num);
        
           printLDHeadInfo(); //added by liyb 20050906
           printf("%s%s",BASE_PD_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20050906
           printf("%s\n",LDSET_LABEL);//added by liyb 20050906
         
           for (i = 0;i<TABLE_FULL_WIDTH;i++)
                printf("%c",TABLE_LINE_SYMBOL); 
           printf("\n");

	    print_condition_code(pd_o_inf);
           return FCSAN_SUCCESS_CODE; /* success */
    	}
    	
   
    free(pd_i_inf.data);
	  
  //2 to get ld info imitating diskList_pooll()

    iSMSMinDataInfo  ld_i_inf,ldset_i_inf;
    iSMSMoutDataInfo ld_o_inf,ldset_o_inf;
    iSMSMPoolId     poolID;  
    iSMSMLd* LDdata;
    unsigned int loop_count_ld=1,loop_count_ldset=1;
    int get_num;
    
//to get base_pd from pool info    liyb 20050830
   
   iSMSMoutDataInfo pool_o_inf;
   int loop_pool=1;
   result=getPoolInfo( pool_no,  array_id, &pool_data,&pool_o_inf,&loop_pool,CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_INTERNAL);
   if(result){ 
   	return result;
   	}

    unsigned char base_pd=pool_data->num_of_base_pd;
    free(pool_data);



    ISMSM_CLI_INIT_ZERO(poolID);   

    /* call API to get total number */
    ld_i_inf.data = NULL ;
    
    poolID.array_id=array_id;
    poolID.pool_num=pool_no;
	
   result = iSMSMGetRankGroupLdInfo(&poolID,&ld_i_inf,&ld_o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_API+1,1);
        return FCSAN_ERROR_CODE;
    }


	
    /*print command title*/
    printf("%-14s: %04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-14s: %04xh\n\n",PD_NO_LABEL,pd_num);

   printLDHeadInfo(); //added by liyb 20050906
   printf("%s%s",BASE_PD_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20050906
   printf("%s\n",LDSET_LABEL);//added by liyb 20050906
 
    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY || ld_o_inf.remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get LD list info */
    ld_i_inf.current_num = 1;
    ld_i_inf.table_rev = iSMSM_TBL_FIRST;
    while (ld_o_inf.remain_num > 0)
    {
        get_num = ld_o_inf.remain_num <= lcount ? ld_o_inf.remain_num : lcount;
          /* Initiate "i_inf" */
        ld_i_inf.get_num = get_num ;
        ld_i_inf.data_size = get_num * sizeof(iSMSMLd);
          /* Memory Allocation */
        ld_i_inf.data = calloc(get_num,sizeof(iSMSMLd));
        if ( !ld_i_inf.data ){/* Memory allocation failure */
        fflush(stdout);// added by keyan 2002-7-1 
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PL,
            CMDCODE_TYPE_SYSTEMFUNC,1);// added by keyan 2002-7-1
        fflush(stderr);// added by keyan 2002-7-1
        return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetRankGroupLdInfo(&poolID, &ld_i_inf, &ld_o_inf ) ;
        if (result!=iSMSM_NORMAL){/* API error */
        fflush(stdout);// added by keyan 2002-7-1
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_API+2,loop_count_ld++);
        free(ld_i_inf.data);
        fflush(stderr);// added by keyan 2002-7-1
        return FCSAN_ERROR_CODE;
        }
        
        /*output ld info*/
        LDdata = (iSMSMLd*)ld_i_inf.data;
        for (i = 0;i < ld_o_inf.return_num;i++){
            int err_no;
            if (err_no=outLDInfo(array_id,LDdata[i],&loop_count_ldset,CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_API+3,base_pd))
			
            {/* err_no: 1~5 (error occurred) 0 (success) */
                fflush(stdout);// added by keyan 2002-7-1
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PL,CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(ld_i_inf.data);  /* added by yangah when detecting memory leak */
                fflush(stderr);// added by keyan 2002-7-1    
                return FCSAN_ERROR_CODE;
            } /* added by Yang AH */
          
        }/*ld for-loop end*/
      
        free(ld_i_inf.data);  
        ld_i_inf.current_num += ld_o_inf.return_num;
        ld_i_inf.table_rev = ld_o_inf.table_rev;
    } /*ld while-loop end*/
    
    /* print condition code */
    print_condition_code(ld_o_inf);

    return FCSAN_SUCCESS_CODE; /* success */
  //3 end 
  

} /* end of "diskList_pl" */

/**************************************************************************************/

int diskList_pd(unsigned char array_id,unsigned char pd_grp_num,unsigned char pd_num)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPdId pdId;
    iSMSMPd* pdInfo;
    char product_id[17],product_rev[5],serial_num[21];
    int result;
    int i;

    unsigned short pool_no;
    iSMSMPoolId  poolID;

     iSMSMPool * pool_data=NULL;
     char pool_name[33];
    
    
    /* Init "i_inf" */
    i_inf.data_size = sizeof(iSMSMPd) ;
    i_inf.data = malloc(i_inf.data_size);
    if (!i_inf.data)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PD,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
    }
/* modified by chs & key & hujun, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(pdId);   
    
    /*Init iSMSMPdId*/
    pdId.array_id = array_id;
    pdId.pd_grp_num = pd_grp_num;
    pdId.pd_num = pd_num;
    
    /* Call API */
    result=iSMSMGetPdInfo(&pdId,&i_inf,&o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_PD,CMDCODE_TYPE_API,1);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
    }
    
    pdInfo = (iSMSMPd *)i_inf.data;
    

  //to get pool info   liyb 20050830
    if((pdInfo->flag_info&0x80)==0x80)     //have  pool          added by liyb 20050902  , wait for modifycation.....
    	{
	    pool_no=pdInfo->pool_num;
	    iSMSMoutDataInfo  pool_o_info;
	    int pool_loop=1;
	    if(result=getPoolInfo( pool_no,  array_id,  &pool_data,&pool_o_info,&pool_loop,CMDCODE_FUNC_ISADISKLIST_PD,CMDCODE_TYPE_INTERNAL))
	    	{
	    	       return result;
	    	}
	    chars2str(pool_data->poolname,  32,pool_name);//changed by liyb 20050906
	    
    	}
    
    /*print command title */
    printf("%s    : %04d\n\n",ARRAY_ID_LABEL,array_id);
    printf("%-7s%s%-11s%s%15s%s%5s%s%-32s%s%-8s%s%-16s%s%-4s%s%-20s%s%5s%s",
	 PD_NO_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL,TABLE_COL_SEPARATOR,
        CAPACITY_LABEL,TABLE_COL_SEPARATOR,
	 POOL_NO_LABEL,TABLE_COL_SEPARATOR,
	 POOL_NAME_LABEL,TABLE_COL_SEPARATOR,        
        DIVISION_LABEL,TABLE_COL_SEPARATOR,
        PRODUCT_ID_LABEL,TABLE_COL_SEPARATOR,
        REV_LABEL,TABLE_COL_SEPARATOR,
        SERIAL_NO_LABEL,TABLE_COL_SEPARATOR,
        SPIN_LABEL,TABLE_COL_SEPARATOR);
    
    printf("%-11s%s",PROGRESSION_LABEL,TABLE_COL_SEPARATOR);//added by liyb 20051210
    printf("%-4s\n",PD_TYPE_LABEL);//added by liyb 20051214
    
    for (i = 0;i<TABLE_FULL_WIDTH;i++)
        printf("%c",TABLE_LINE_SYMBOL); 
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
        return FCSAN_SUCCESS_CODE;
    }

    /*print pd info*/
    printf("%02xh-%02xh%s",pdInfo->pd_grp_num,pdInfo->pd_num,TABLE_COL_SEPARATOR); /*PD_No*/
    /*print state*/
    if (outPdState(pdInfo->pd_matter))
    {
    	fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PD,CMDCODE_TYPE_INTERNAL,9001);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
    }
    /*print capacity*/
    printf("%15.0f%s",pdInfo->sector_num*512.0,TABLE_COL_SEPARATOR);

    
        
//output  pool info  liyb 20050830
if((pdInfo->flag_info&0x80)==0x80){
 printf("%04xh%s%-32s%s",pool_no,TABLE_COL_SEPARATOR,pool_name,TABLE_COL_SEPARATOR);
}else{
  printf("%-4s%s%-32s%s",POOL_NUM_MASK_DESC,TABLE_COL_SEPARATOR,POOL_NAME_MASK_DESC,TABLE_COL_SEPARATOR);
}




    /*print Division*/
    if (outPdDivision(pdInfo->pd_flag))
    {
    	fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PD,CMDCODE_TYPE_INTERNAL,9002);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
    }
    
    /*print ProductId,rev,serialNo,spin*/
    chars2str(pdInfo->product_id,16,product_id);
    chars2str(pdInfo->product_rev,4,product_rev);
    chars2str(pdInfo->serial_num,20,serial_num);
    printf("%-16s%s%-4s%s%-20s%s%5d%s",product_id,TABLE_COL_SEPARATOR,
        product_rev,TABLE_COL_SEPARATOR,serial_num,
        TABLE_COL_SEPARATOR,pdInfo->pd_revolution,TABLE_COL_SEPARATOR);
        
    /*print rebuild rate  added by liyb 20051210*/
    if(pdInfo->pd_matter==0x11) {
        printf("%11d%s",pdInfo->rebuild_rate,TABLE_COL_SEPARATOR);}
    else{
        printf("%11s%s","--",TABLE_COL_SEPARATOR);}

    /*print pd_type  added by liyb 20051214*/
        if(pdInfo->pd_type==PD_TYPE_FC_VALUE) {
            printf("%s",PD_TYPE_FC_DESC);
        }else if(pdInfo->pd_type==PD_TYPE_SATA_VALUE){
            printf("%s",PD_TYPE_SATA_DESC);
        }else if(pdInfo->pd_type==PD_TYPE_SAS_VALUE){
            printf("%s",PD_TYPE_SAS_DESC);
	 }else{
             printf("%s",NULL_STATE);
        }

	 printf("\n");
        
    free(i_inf.data);    

    /* print condition code */
    print_condition_code(o_inf);

    return FCSAN_SUCCESS_CODE; /* success */

} /* end of "diskList_pd" */

int outPdDivision(unsigned char pdflag)
{
    switch (pdflag){
    case 0x00:
        printf("%-8s%s",PD_DIVISION_NONE,TABLE_COL_SEPARATOR);
        break;
    case 0x01:
        printf("%-8s%s",PD_DIVISION_DATA,TABLE_COL_SEPARATOR);
        break;
    case 0x02:
        printf("%-8s%s",PD_DIVISION_SPARE,TABLE_COL_SEPARATOR);
        break;
    default:
        return 1;
    }
    return 0;
}

int outPdState(unsigned char pdmatter)
{
    switch (pdmatter){
    case PD_STATE_READY_VALUE:
        printf("%-11s%s",PD_STATE_READY_DESC,TABLE_COL_SEPARATOR);
        break;
    case PD_STATE_OFFLINE_VALUE:
        printf("%-11s%s",PD_STATE_OFFLINE_DESC,TABLE_COL_SEPARATOR);
        break;
    case PD_STATE_REBUILDING_VALUE:
        printf("%-11s%s",PD_STATE_REBUILDING_DESC,TABLE_COL_SEPARATOR);
        break;
    case PD_STATE_POWERING_VALUE:
        printf("%-11s%s",PD_STATE_POWERING_DESC,TABLE_COL_SEPARATOR);
        break;
    case PD_STATE_FORMATTING_VALUE:
        printf("%-11s%s",PD_STATE_FORMATTING_DESC,TABLE_COL_SEPARATOR);
        break;
    case PD_STATE_FAULT_VALUE:
        printf("%-11s%s",PD_STATE_FAULT_DESC,TABLE_COL_SEPARATOR);
        break;
    case PD_STATE_INVALID_VALUE:
        printf("%-11s%s",PD_STATE_INVALID_DESC,TABLE_COL_SEPARATOR);
        break;
    default:
        return 1;
    }
    return 0;
}

//used for diskList_p()
int outLDInfo(unsigned char array_id,iSMSMLd LDdata,unsigned int* loop_count_ldset,int cmdCodeFunc,int cmdCodeType,unsigned char base_pd)
{
    int j;
    iSMSMinDataInfo i_inf_ldset;
    iSMSMoutDataInfo o_inf_ldset;
    iSMSMLdsetId ldsetId;
    char ldset_name[17];

    int result;
    unsigned char svrVerId;
    iSMSMVersion version;
    
    int err_no=outLDPartInfo(LDdata,cmdCodeFunc,array_id);
    if (err_no)
    {
    	fflush(stdout);  /*added by changhs 2002/07/01*/
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,cmdCodeFunc,CMDCODE_TYPE_INTERNAL,9000+err_no);
        return FCSAN_ERROR_CODE;
    }

   //print basepd  liyb 20050905
    if(base_pd==iSMSMCFG_RAID_6_4PQ|| iSMSMCFG_RAID_6_8PQ)
   {
 	printf("%-2d%s",base_pd,TABLE_COL_SEPARATOR);	
   }else
   {
      printf("%-2s%s",NO_BASE_PD,TABLE_COL_SEPARATOR);	
   }
  
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
/* modified by chs & key & hujun, 2002-12-26*/
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
            chars2str(((iSMSMLdset2*)i_inf_ldset.data)->ldset_name,16,ldset_name);    
        }else{ /*version 1.4*/
            chars2str(((iSMSMLdset*)i_inf_ldset.data)->ldset_name,16,ldset_name);    
        }
        /*end modify*/
    
        strtrim(ldset_name);
        printf("%s",ldset_name);
        free(i_inf_ldset.data);
        }
        printf("\n");
        return FCSAN_SUCCESS_CODE;
}

//changed by liyb , add new parameter :array_id   20051215
int outLDPartInfo(iSMSMLd LDdata,unsigned int cmdCodeFunc,unsigned char array_id)
{
        char vol_type[9],vol_name[25];
        chars2str(LDdata.vol_type,8,vol_type);
        chars2str(LDdata.vol_name,24,vol_name);
        printf("%04xh%s%-8s%s%-25s%s",LDdata.ld_num,TABLE_COL_SEPARATOR,vol_type,
            TABLE_COL_SEPARATOR,vol_name,TABLE_COL_SEPARATOR);

         iSMSMoutDataInfo pool_o_inf	;
	  iSMSMPool * pool_data=NULL;
         int loop_count=1;
	  unsigned short pool_no;
         int result=0;

         int isPoolExpanding=0;
			
        /*print state*/
        switch (LDdata.ld_state){
        case ARRAY_STATE_READY_VALUE:
        case ARRAY_STATE_ATTENTION_VALUE:
            switch (LDdata.ld_matter){
            case ARRAY_STATE_READY_VALUE:
		  if( (LDdata.flag_info&0x80)==0x80  
                    &&  LDdata.raid_type==RAID_TYPE6
                    && LDdata.expand_state==POOL_EXPANDING){

                    printf("%-15s%s",LDSTATE_EXPANDING,TABLE_COL_SEPARATOR);
                    isPoolExpanding=1;
                }else{
                    printf("%-15s%s",ARRAY_STATE_READY_DESC,TABLE_COL_SEPARATOR);
                }
                break;
            case LDSTATE_REDUCE_VALUE:
                printf("%-15s%s",LDSTATE_REDUCE,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_REBUILDING_VALUE:
                printf("%-15s%s",LDSTATE_REBUILDING,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_PREVENT_VALUE:
                printf("%-15s%s",LDSTATE_PREVENT,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_COPY_BACK_VALUE:
                printf("%-15s%s",LDSTATE_COPY_BACK,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_UNFORMATTED_VALUE:
                   printf("%-15s%s",LDSTATE_UNFORMATTED,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_FORMATTING_VALUE:
                   printf("%-15s%s",LDSTATE_FORMATTING,TABLE_COL_SEPARATOR);
                break;
               case LDSTATE_FORMAT_FAIL_VALUE:
                   printf("%-15s%s",LDSTATE_FORMAT_FAIL,TABLE_COL_SEPARATOR);
                break;
               case LDSTATE_EXPANDING_VALUE:
                   printf("%-15s%s",LDSTATE_EXPANDING,TABLE_COL_SEPARATOR);
                break;
               case LDSTATE_EXPANDING_FAIL_VALUE:
                   printf("%-15s%s",LDSTATE_EXPANDING_FAIL,TABLE_COL_SEPARATOR);
                break;
            case ARRAY_STATE_FAULT_VALUE:
            case LDSTATE_MEDIA_ERROR_VALUE:
                printf("%15s%s","--",TABLE_COL_SEPARATOR);
                break;
            default:
                return 1;
            } /* end of inner "switch" */
            break;
        case ARRAY_STATE_FAULT_VALUE:
            switch (LDdata.ld_matter){ 
               case ARRAY_STATE_FAULT_VALUE:
                   printf("%-15s%s",ARRAY_STATE_FAULT_DESC,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_MEDIA_ERROR_VALUE:
                printf("%-15s%s",LDSTATE_MEDIA_ERROR,TABLE_COL_SEPARATOR);
                break;
            case LDSTATE_REDUCE_VALUE:
            case LDSTATE_REBUILDING_VALUE:
            case LDSTATE_PREVENT_VALUE:
            case LDSTATE_COPY_BACK_VALUE:
            case LDSTATE_UNFORMATTED_VALUE:
            case LDSTATE_FORMATTING_VALUE:
            case LDSTATE_FORMAT_FAIL_VALUE:
            case LDSTATE_EXPANDING_VALUE:
            case LDSTATE_EXPANDING_FAIL_VALUE:
                printf("%15s%s","--",TABLE_COL_SEPARATOR);
                break;
            default:
                return 1;
            } /* end of inner "switch" */
            break;
        default:
            printf("%15s%s","-",TABLE_COL_SEPARATOR);
            break;
        } /* end of outer "switch" */
            
        /*print RAID*/
	  int raid=getRaidtype(LDdata.raid_type);
	  if(raid!=-1){
             printf("%4d%s",raid,TABLE_COL_SEPARATOR);
	  }
	  else{
              return 3;
	  }
	  	
        
        /*print capacity*/
        switch (cmdCodeFunc){
        case CMDCODE_FUNC_ISADISKLIST_PL:
        /*remarked by hj 2002/5/31, now the capacity outputed by "-rl" is bytes*/
//        case CMDCODE_FUNC_ISADISKLIST_RL:
        {
            char floatStr[40];
            double capa = LDdata.sector_num*512.0/1024/1024/1024 ;
            getCutString(((float)capa), floatStr);    
            printf("%15s%s",floatStr,TABLE_COL_SEPARATOR);
            break;
        }
        default:
            printf("%15.0f%s",LDdata.sector_num*512.0,TABLE_COL_SEPARATOR);
     }
        /*print cache*/
        if (LDdata.cache_flag == 0x00)
            printf("%-5s%s","no",TABLE_COL_SEPARATOR);
        else if (LDdata.cache_flag == 0x10)
            printf("%-5s%s","yes",TABLE_COL_SEPARATOR);
        else
            return 4;
    /*print progression*/

         switch (LDdata.ld_matter){
	    case 0x15:
	        printf("%11d%s",LDdata.format_rate,TABLE_COL_SEPARATOR);
	        break;
	    case 0x11:
	    case 0x13:
	    case 0x18:
	    case 0x00:
	    case 0x10:
	    case 0x12:
	    case 0x14:
	    case 0x16:
	    case 0x19:
	    case 0x20:
	    case 0x21:
		 if(isPoolExpanding==1){
	            pool_no=LDdata.pool_num;
	            result=getPoolInfo( pool_no,  array_id,  &pool_data,&pool_o_inf,&loop_count,cmdCodeFunc,CMDCODE_TYPE_INTERNAL);

	            if(result){
	 	         return result;
	            }
	            printf("%11d%s",pool_data->expansion_rate,TABLE_COL_SEPARATOR);     
		 }else{
	            printf("%11s%s","--",TABLE_COL_SEPARATOR);
		 }
	        break;
	    default:
	        return 4;
           }
    
    return 0;
}
