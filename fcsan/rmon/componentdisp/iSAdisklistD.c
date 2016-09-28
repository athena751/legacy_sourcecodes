/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistD.c,v 1.2302 2005/09/20 02:25:38 liyb Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistD.c,v 1.2302 2005/09/20 02:25:38 liyb Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAdisklist.h"


int diskList_d(unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMAry *data=NULL;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int result ;
    int i,j;
    char array_name[33]; 

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_D,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf .data =NULL ;
    result=iSMSMGetAryListInfo2(&i_inf , &o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_D,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num = o_inf . remain_num ; /* total number */
    
    /* Output Table Header */

    printf("%-8s%s",ARRAY_ID_LABEL,TABLE_COL_SEPARATOR);
    printf("%-32s%s",DISK_ARRAY_LABEL,TABLE_COL_SEPARATOR);
    printf("%-10s%s",ARRAY_TYPE_LABEL,TABLE_COL_SEPARATOR);
    printf("%-5s%s",STATE_LABEL,TABLE_COL_SEPARATOR);
    printf("%-13s%s",OBSERVATION_LABEL,TABLE_COL_SEPARATOR);
    printf("%-56s%s",SAA_LABEL,TABLE_COL_SEPARATOR);
    printf("%-16s",WWNN_LABEL);
    printf("\n");
	 
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

    /* get disk array info */
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
        i_inf.data_size=get_num*sizeof(iSMSMAry);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMAry));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_D,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetAryListInfo2(&i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_D,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMAry *)i_inf.data ;
        /* Output Table Body */
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            char * array_state="";
            char * watch_state="";
            
            chars2str(data[i].array_name,32,array_name); 
            if(data[i].invalid_flag==0x00) {
                switch (data[i].array_total_state)
                {
                case ARRAY_STATE_READY_VALUE:
                    array_state=ARRAY_STATE_READY_DESC;
                    break;
                case ARRAY_STATE_ATTENTION_VALUE:
                    array_state=ARRAY_STATE_ATTENTION_DESC;
                    break;
                case ARRAY_STATE_FAULT_VALUE:
                    array_state=ARRAY_STATE_FAULT_DESC;
                    break;
                default:
                    fflush(stdout);
                    fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_D,CMDCODE_TYPE_INTERNAL,9001);
                    free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;
                }

                switch (data[i].watch_state)
                {
                case OBSERVATION_RUNNING_VALUE:
                    watch_state=OBSERVATION_RUNNING_DESC;
                    break;
                case OBSERVATION_INIT_VALUE:
                    watch_state=OBSERVATION_INIT_DESC;
                    break;
                case OBSERVATION_CONFIG_VALUE:
                    watch_state=OBSERVATION_CONFIG_DESC;
                    break;
                case OBSERVATION_TERM_VALUE:
                    watch_state=OBSERVATION_TERM_DESC;
                    break;
                case OBSERVATION_STOP_VALUE:
                    watch_state=OBSERVATION_STOP_DESC;
                    break;
                case OBSERVATION_STOP_M_VALUE:
                    watch_state=OBSERVATION_STOP_M_DESC;
                    break;
                case OBSERVATION_STOP_F_VALUE:
                    watch_state=OBSERVATION_STOP_F_DESC;
                    break;
                case OBSERVATION_WAIT_VALUE:
                    watch_state=OBSERVATION_WAIT_DESC;
                    break;
                default:
                    fflush(stdout);
                    fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_D,CMDCODE_TYPE_INTERNAL,9002);
                    free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;
                }
                
              printf("    %04u%s%-32s%s       %02xh%s%-5s%s%-13s%s",
                    data[i].array_id,TABLE_COL_SEPARATOR,
                    array_name,TABLE_COL_SEPARATOR,
                    data[i].product_code,TABLE_COL_SEPARATOR,
                    array_state,TABLE_COL_SEPARATOR,
                    watch_state,TABLE_COL_SEPARATOR    );
                for (j=0;j<28;j++)
                    printf("%02x",data[i].saa[j]);

//add WWNN by liyb 20050829
                   printf("%s",TABLE_COL_SEPARATOR);
               for (j=0;j<8;j++)
                    printf("%02x",(unsigned char)data[i].wwnn[j]);
//end add
   
                printf("\n");
            }else {
               printf("    %04u%s%-32s%s         %s%s%-5s%s%-13s%s%s",                 
                      data[i].array_id,TABLE_COL_SEPARATOR,
                      array_name,TABLE_COL_SEPARATOR,
                      BLANK_LABEL,TABLE_COL_SEPARATOR,
                      BLANK_LABEL,TABLE_COL_SEPARATOR,
                      NO_MONITORING,TABLE_COL_SEPARATOR, 
                      BLANK_LABEL );
	         printf("%s%s",TABLE_COL_SEPARATOR,BLANK_LABEL);
                printf("\n");
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
    printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);

    return FCSAN_SUCCESS_CODE; /* success */
    
} /* end of "diskList_d" */

/**************************************************************************************/

int diskList_ds(unsigned char array_id)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMAry *data;
    char *array_state="", *watch_state="";
    char *cross_call[]={CROSS_CALL_NOT_SUPPORT,CROSS_CALL_OFF,CROSS_CALL_ON};
    char *access[]={ACCESS_CONTROL_OFF,ACCESS_CONTROL_ON};
    char *auto_assign_mode[]={"-","OFF","ON"};
    char array_name[33],product_id[17],product_revision[5];
    char serial_num[17],pass0[129],pass1[129],path_state0[3],path_state1[3];
    int j,result;

    /* Init "i_inf" */
    i_inf.data_size =sizeof(iSMSMAry) ;
    i_inf.data=malloc(i_inf.data_size);
    if (!i_inf.data)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DS,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* Call API */
    result=iSMSMGetAryInfo2(array_id,&i_inf,&o_inf) ;
    if (result==iSMSM_TBL_NOENTRY)
    {
        printf("%-14s:  \n",ARRAY_ID_LABEL);                /* Array_ID */
        printf("%-14s:  \n",DISK_ARRAY_LABEL);        /* Disk_Array */
        printf("%-14s:  \n",ARRAY_TYPE_LABEL);    /* Array_Type */
        printf("%-14s:  \n",STATE_LABEL);                /* State */
        printf("%-14s:  \n",OBSERVATION_LABEL);            /* Observation */
        printf("%-14s:  \n",SAA_LABEL);
        printf("%-14s:  \n",PRODUCT_ID_LABEL);    /* Product_ID */
        printf("%-14s:  \n",REV_LABEL);            /* Rev */
        printf("%-14s:  \n",SERIAL_NO_LABEL);        /* Serial_No */
        printf("%-14s:  \n",CAPACITY_LABEL);    /* Capacity */
        printf("%-14s:  \n",CONTROL_PASS1_LABEL);        /* Control_pass1 */
        printf("%-14s:  \n",CONTROL_PASS2_LABEL);        /* Control_pass2 */
        printf("%-14s:  \n",CROSS_CALL_LABEL);/* Cross_call */
        printf("%-14s:  \n",AUTO_ASSIGN_LABEL);  /* Auto Assign */
        printf("%-14s:  \n",ACCESS_LABEL);    /* Access */
        printf("%-14s:  \n",USER_SYS_CODE_LABEL);    /* User_sys_code */
//add wwnn by liyb 20050829
        printf("%-14s:  \n",WWNN_LABEL);    /* wwnn */

        /* print condition code */
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
        return FCSAN_SUCCESS_CODE;
    }
    if (result!=iSMSM_NORMAL )
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_DS,CMDCODE_TYPE_API,1);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
    }
    
    data=(iSMSMAry *)i_inf.data;
    /*add iSM2.0 begin */
    if(data->invalid_flag==0x00) {
    /*add iSM2.0 end */
    /* Initiate "array_state" and "observation" for output */
        switch (data->array_total_state) /* switch 1 */
        {
        case ARRAY_STATE_READY_VALUE:
            array_state=ARRAY_STATE_READY_DESC;
            break;
        case ARRAY_STATE_ATTENTION_VALUE:
            array_state=ARRAY_STATE_ATTENTION_DESC;
            break;
        case ARRAY_STATE_FAULT_VALUE:
            array_state=ARRAY_STATE_FAULT_DESC;
            break;
        default:
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DS,CMDCODE_TYPE_INTERNAL,9001);
            free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
        }/* end of "switch 1" */
    
        switch (data->watch_state) /* switch 2 */
        {
        case OBSERVATION_RUNNING_VALUE:
            watch_state=OBSERVATION_RUNNING_DESC;
            break;
        case OBSERVATION_INIT_VALUE:
            watch_state=OBSERVATION_INIT_DESC;
            break;
        case OBSERVATION_CONFIG_VALUE:
            watch_state=OBSERVATION_CONFIG_DESC;
            break;
        case OBSERVATION_TERM_VALUE:
            watch_state=OBSERVATION_TERM_DESC;
            break;
        case OBSERVATION_STOP_VALUE:
            watch_state=OBSERVATION_STOP_DESC;
            break;
        case OBSERVATION_STOP_M_VALUE:
            watch_state=OBSERVATION_STOP_M_DESC;
            break;
        case OBSERVATION_STOP_F_VALUE:
            watch_state=OBSERVATION_STOP_F_DESC;
            break;
        case OBSERVATION_WAIT_VALUE:
            watch_state=OBSERVATION_WAIT_DESC;
            break;
        default:
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DS,CMDCODE_TYPE_INTERNAL,9002);
            free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
        } /* end of "switch 2" */

        if (data->auto_assign>2)
        {
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DS,CMDCODE_TYPE_INTERNAL,9003);
            free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
        }
    
    /* Output info */
        chars2str(data->array_name,32,array_name);
        chars2str(data->product_id,16,product_id);
        chars2str(data->product_revision,4,product_revision);
        chars2str(data->serial_num,16,serial_num);
    } else {
        chars2str(data->array_name,32,array_name);
    }
    if (data->num_of_pass==0)
    {
        strcpy(pass0,"-");
        strcpy(pass1,"-");
        strcpy(path_state0,"-");
        strcpy(path_state1,"-");
    }
    else if (data->num_of_pass == 1)/* data->num_of_pass is 1*/
    {
        chars2str(data->pass0,128,pass0);
        strcpy(pass1,"-");
        if (data->pass0_state == 0x00)
            strcpy(path_state0,PATH_STATE_OK);
        else if (data->pass0_state == 0x01)
            strcpy(path_state0,PATH_STATE_NG);
        else
            strcpy(path_state0,"-");
        strcpy(path_state1,"-");
    }
    else if (data->num_of_pass == 2)/* data->num_of_pass is 3*/
    {
        chars2str(data->pass0,128,pass0);
        chars2str(data->pass1,128,pass1);
        if (data->pass0_state == 0x00)
            strcpy(path_state0,PATH_STATE_OK);
        else if (data->pass0_state == 0x01)
            strcpy(path_state0,PATH_STATE_NG);
        else
            strcpy(path_state0,"-");
        if (data->pass1_state == 0x00)
            strcpy(path_state1,PATH_STATE_OK);
        else if (data->pass1_state == 0x01)
            strcpy(path_state1,PATH_STATE_NG);
        else
            strcpy(path_state1,"-");
    }
    else
    {
        int i;
        for (i=0;i<128;i++)
        {
            pass0[i]=0x20;
            pass1[i]=0x20;
        }
        pass0[128]=pass1[128]=0;
    }
    if(data->invalid_flag==0x00) {
        printf("%-14s:%04u\n",ARRAY_ID_LABEL,array_id);                /* Array_ID */
        printf("%-14s:%s\n",DISK_ARRAY_LABEL,array_name);        /* Disk_Array */
        printf("%-14s:%02xh\n",ARRAY_TYPE_LABEL,data->product_code);    /* Array_Type */
        printf("%-14s:%s\n",STATE_LABEL,array_state);                /* State */
        printf("%-14s:%s\n",OBSERVATION_LABEL,watch_state);            /* Observation */
        printf("%-14s:",SAA_LABEL);
        for (j=0;j<28;j++)                                        /* SAA */
            printf("%02x",data->saa[j]);
        printf("\n%-14s:%s\n",PRODUCT_ID_LABEL,product_id);    /* Product_ID */
        printf("%-14s:%s\n",REV_LABEL,product_revision);            /* Rev */
        printf("%-14s:%s\n",SERIAL_NO_LABEL,serial_num);        /* Serial_No */
        printf("%-14s:%d\n",CAPACITY_LABEL,data->array_total_capacity);    /* Capacity */
        strtrim(pass0);
        strtrim(pass1);
        printf("%-14s:%s\n",CONTROL_PASS1_LABEL,pass0);        /* Control_pass1 */
        printf("%-14s:%s\n",PATH1_STATE_LABEL,path_state0);  /*path1 state*/
        printf("%-14s:%s\n",CONTROL_PASS2_LABEL,pass1);        /* Control_pass2 */
        printf("%-14s:%s\n",PATH2_STATE_LABEL,path_state1);  /*path2 state*/
        printf("%-14s:%s\n",CROSS_CALL_LABEL,cross_call[data->cross_call]);/* Cross_call */
        printf("%-14s:%s\n",AUTO_ASSIGN_LABEL, auto_assign_mode[data->auto_assign]);    /* Auto Assing Mode */
        printf("%-14s:%s\n",ACCESS_LABEL,access[data->accctl_flag]);    /* Access */
        printf("%-14s:",USER_SYS_CODE_LABEL);
        for (j=0;j<10;j++){
            printf("%c",data->usercode[j]);
        }
	 printf("\n"); //added by liyb 20050907
//add WWNN by liyb 20050829
       printf("%-14s:",WWNN_LABEL);
        for (j=0;j<8;j++)
                    printf("%02x",(unsigned char)data->wwnn[j]);
//end add
   
        printf("\n");
    }else {
        printf("%-14s:%04u\n",ARRAY_ID_LABEL,array_id);                /* Array_ID */
        printf("%-14s:%s\n",DISK_ARRAY_LABEL,array_name);        /* Disk_Array */
        printf("%-14s:%s\n",ARRAY_TYPE_LABEL,BLANK_LABEL);    /* Array_Type */
        printf("%-14s:%s\n",STATE_LABEL,BLANK_LABEL);                /* State */
        printf("%-14s:%s\n",OBSERVATION_LABEL,NO_MONITORING);            /* Observation */
        printf("%-14s:%s\n",SAA_LABEL,BLANK_LABEL);                                /* SAA */
        printf("%-14s:%s\n",PRODUCT_ID_LABEL,BLANK_LABEL);    /* Product_ID */
        printf("%-14s:%s\n",REV_LABEL,BLANK_LABEL);            /* Rev */
        printf("%-14s:%s\n",SERIAL_NO_LABEL,BLANK_LABEL);        /* Serial_No */
        printf("%-14s:%s\n",CAPACITY_LABEL,BLANK_LABEL);    /* Capacity */
        strtrim(pass0);
        strtrim(pass1);
        printf("%-14s:%s\n",CONTROL_PASS1_LABEL,pass0);        /* Control_pass1 */
        printf("%-14s:%s\n",PATH1_STATE_LABEL,path_state0);  /*path1 state*/
        printf("%-14s:%s\n",CONTROL_PASS2_LABEL,pass1);        /* Control_pass2 */
        printf("%-14s:%s\n",PATH2_STATE_LABEL,path_state1);  /*path2 state*/
        printf("%-14s:%s\n",CROSS_CALL_LABEL,BLANK_LABEL);/* Cross_call */
        printf("%-14s:%s\n",AUTO_ASSIGN_LABEL, BLANK_LABEL);    /* Auto Assing Mode */
        printf("%-14s:%s\n",ACCESS_LABEL,BLANK_LABEL);    /* Access */
        printf("%-14s:%s\n",USER_SYS_CODE_LABEL,BLANK_LABEL);
	 printf("%-14s:%s\n",WWNN_LABEL,BLANK_LABEL);
    }
    
    /* print condition code */
    print_condition_code(o_inf);

    free(i_inf.data); /* release allocated memory */
    return FCSAN_SUCCESS_CODE; /* success */

} /* end of "diskList_ds" */

/**************************************************************************************/

int diskList_dap(unsigned char array_id , unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPort *data=NULL ;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int i,result ;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DAP,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf .data =NULL ;
    result=iSMSMGetPortListInfo(array_id,&i_inf,&o_inf) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_DAP,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */

    /* Output Table Header */
    printf("%s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%-7s%s%-32s%s%-7s%s%-10s%s%s\n",
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

    /* get port info */
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
        i_inf.data=(iSMSMPort *)calloc(get_num,sizeof(iSMSMPort));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DAP,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetPortListInfo(array_id,&i_inf,&o_inf) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_DAP,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMPort *)i_inf.data;
        /* Output Table Body */
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            char * access_mode;
            
            /*modified by hujing;according to the mail (nas 2791) No.24*/
            /*char * port_matter[]={PORT_MATTER_READY,PORT_MATTER_OFFLINE,PORT_MATTER_FAULT};*/
            char *port_matter = "";
            
            char port_name[33];
            
            if (data[i].access_mode == 0x01){
                access_mode = ACCESS_MODE_PORT;
            }else if (data[i].access_mode == 0x02){
                access_mode = ACCESS_MODE_WNN;
            }else{
                access_mode = ACCESS_MODE_UNKNOWN;
            }
            
            /*remarked by hujing;according to the mail (nas 2791) No.24*/
            /*if (data[i].port_matter!=0x00 && data[i].port_matter!=0x10 && data[i].port_matter!=0x20)
            {
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DAP,CMDCODE_TYPE_INTERNAL,9002);
                return FCSAN_ERROR_CODE;
            }*/
                        
            chars2str(data[i].port_name,32,port_name);
            
            /*modified by hujing; according to the mail (nas 2791) No.24*/
            /*printf("%02xh-%02xh%s%-32s%s%-7s%s%-10s%s",
                data[i].dir_num,data[i].port_num,TABLE_COL_SEPARATOR,
                port_name,TABLE_COL_SEPARATOR,
                access_mode,TABLE_COL_SEPARATOR,
                port_matter[data[i].port_matter/16],TABLE_COL_SEPARATOR);*/
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
            printf("%02xh-%02xh%s%-32s%s%-7s%s%-10s%s",
                data[i].dir_num,data[i].port_num,TABLE_COL_SEPARATOR,
                port_name,TABLE_COL_SEPARATOR,
                access_mode,TABLE_COL_SEPARATOR,
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
    
} /* end of "diskList_dap" */

/**************************************************************************************/

int diskList_dal(unsigned char array_id , unsigned int lcount)
{
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
    unsigned char svrVerId;
    iSMSMVersion version;


    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DAL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
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
                CMDCODE_FUNC_ISADISKLIST_DAL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    svrVerId = ((iSMSMVersion *)(i_inf.data))->ismsvr_verid;
    /*end add*/

    /* call API to get total number */
    i_inf .data =NULL ;
    
    /*modified by hj for iSM version 1.5*/
    if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
        result= iSMSMGetLdsetListInfo2(array_id,&i_inf,&o_inf );
    }else{ /*version 1.4*/
        result= iSMSMGetLdsetListInfo(array_id,&i_inf,&o_inf );
    }
    /*end modify*/
    
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_DAL,CMDCODE_TYPE_API+1,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */
    
    /* Output Table Header */
    printf("%s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%-8s%s%-4s%s%-16s%s%-8s%s%s\n",
        LDSET_ID_LABEL,TABLE_COL_SEPARATOR,
        TYPE_LABEL,TABLE_COL_SEPARATOR,
        LDSET_LABEL,TABLE_COL_SEPARATOR,
        PATH_CNT_LABEL,TABLE_COL_SEPARATOR,
        PATH_LABEL);
    for (i=0;i<63;i++)
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
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DAL,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }

        /*modified by hj for iSM version 1.5*/
        if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
            result= iSMSMGetLdsetListInfo2(array_id,&i_inf,&o_inf );
        }else{ /*version 1.4*/
            result= iSMSMGetLdsetListInfo(array_id,&i_inf,&o_inf );
        }
        /*end modify*/
        
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_DAL,CMDCODE_TYPE_API+2,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /*modified by hj for iSM version 1.5*/
        if (svrVerId >= SERVER_VERSION_15){ /*version 1.5*/
            data1=(iSMSMLdset2 *)i_inf.data;
            for (i=0;i<o_inf.return_num;i++)
            {/* print a record in one loop procedure */
                char ldset_type[3];
                char ldset_name[17];
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
                }
                chars2str(data1[i].ldset_type,2,ldset_type);
                chars2str(data1[i].ldset_name,16,ldset_name);
                printf("   %05u%s%-4s%s%-16s%s%8u%s",
                    data1[i].ldset_id,TABLE_COL_SEPARATOR,
                    ldset_type,TABLE_COL_SEPARATOR,
                    ldset_name,TABLE_COL_SEPARATOR,
                    num_of_wwpn,TABLE_COL_SEPARATOR
                    );
                /* output path    */
                if (data1[i].num_of_wwpn==0)
                    printf("-\n");
                else
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
                        if (j==data1[i].num_of_wwpn-1)
                            printf("\n");
                        else
                            printf(",");
                    }
            }/* end of "for" */
        }else{ /*version 1.4*/
            data=(iSMSMLdset *)i_inf.data;
            for (i=0;i<o_inf.return_num;i++)
            {/* print a record in one loop procedure */
                char ldset_type[3];
                char ldset_name[17];
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
                chars2str(data[i].ldset_type,2,ldset_type);
                chars2str(data[i].ldset_name,16,ldset_name);
                printf("   %05u%s%-4s%s%-16s%s%8u%s",
                    data[i].ldset_id,TABLE_COL_SEPARATOR,
                    ldset_type,TABLE_COL_SEPARATOR,
                    ldset_name,TABLE_COL_SEPARATOR,
                    num_of_wwpn,TABLE_COL_SEPARATOR
                    );
                /* output path    */
                if (data[i].num_of_wwpn==0)
                    printf("-\n");
                else
                    for (j=0;j<data[i].num_of_wwpn;j++)
                    {
                        if (data[i].wwpn[j][0] != -1 || data[i].wwpn[j][1] != -1 ||
                            data[i].wwpn[j][2] != -1 || data[i].wwpn[j][3] != -1 ||
                            data[i].wwpn[j][4] != -1 || data[i].wwpn[j][5] != -1 ||
                            data[i].wwpn[j][6] != -1 || data[i].wwpn[j][7] != -1)
                        {
                              printf("%02x%02x-%02x%02x-%02x%02x-%02x%02x",
                                (unsigned char)data[i].wwpn[j][0],(unsigned char)data[i].wwpn[j][1],
                                (unsigned char)data[i].wwpn[j][2],(unsigned char)data[i].wwpn[j][3],
                                (unsigned char)data[i].wwpn[j][4],(unsigned char)data[i].wwpn[j][5],
                                (unsigned char)data[i].wwpn[j][6],(unsigned char)data[i].wwpn[j][7]);
                        }else
                            printf("-");
                        if (j==data[i].num_of_wwpn-1)
                            printf("\n");
                        else
                            printf(",");
                    }
            }/* end of "for" */
        }/*end else: version 1.3*/
        
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
    
} /* end of "diskList_dal" */

/**************************************************************************************/

int diskList_dp(unsigned char array_id)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    char product[40],array_name[33];
    iSMSMAry * data;
    int i,result;

    /* Init "i_inf" */
    i_inf.data_size =sizeof(iSMSMAry) ;
    i_inf.data=malloc(i_inf.data_size);
    if (!i_inf.data) 
    {/* memory allocation failure */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DP,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE; 
    }
    
    /* Call API */
    result=iSMSMGetAryInfo(array_id,&i_inf,&o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_DP,CMDCODE_TYPE_API,1);
        free(i_inf.data);
        return FCSAN_ERROR_CODE;
    }
    
    data=(iSMSMAry *)i_inf.data;
    /* Output table header */
    chars2str(data->array_name,32,array_name);
    printf("%-11s:%04u\n",ARRAY_ID_LABEL,array_id);                /* Array_ID */
    printf("%-11s:%s\n\n",DISK_ARRAY_LABEL,array_name);        /* Disk_Array */
    printf("%-40s%s%s\n",PRODUCT_LABEL,TABLE_COL_SEPARATOR,STATE_LABEL);
    for (i=0;i<55;i++)
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

    /* Output table body */
    if (data->ddr_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 1 */
        
        /* concat field "product" */
        if (data->ddr_license_limit==PRODUCT_POSTSCRIPT_NOLIM_VALUE)
        {
            sprintf(product,"%s(%s)",PRODUCT_DDR,PRODUCT_POSTSCRIPT_NOLIM_DESC);
        }
        else if (data->ddr_license_limit==PRODUCT_POSTSCRIPT_NONE_VALUE)
        {
            sprintf(product,"%s",PRODUCT_DDR);
        }
        else
        {
            sprintf(product,"%s(%.1f)",PRODUCT_DDR,data->ddr_license_limit/10.0);
        } 
        
        /* output */
        if (data->ddr_license==STATE_IMPOSSIBLE_VALUE)
        {
            if (data->ddr_license_limit==STATE_POSTSCRIPT_CP_VALUE)
            { /* append "(pp)" */
              printf("%-40s%s%s(%s)\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC,STATE_POSTSCRIPT_PP_DESC);
            }
            else 
            { /* append "(cp)" */
              printf("%-40s%s%s(%s)\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC,STATE_POSTSCRIPT_CP_DESC);
            }
        }
        else if (data->ddr_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 1 */

    if (data->rdr_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 2 */
        
        /* concat field "product" */
        if (data->rdr_license_limit==PRODUCT_POSTSCRIPT_NOLIM_VALUE)
        {
            sprintf(product,"%s(%s)",PRODUCT_RDR,PRODUCT_POSTSCRIPT_NOLIM_DESC);
        }
        else if (data->rdr_license_limit==PRODUCT_POSTSCRIPT_NONE_VALUE)
        {
            sprintf(product,"%s",PRODUCT_RDR);
        }
        else
        {
            sprintf(product,"%s(%.1f)",PRODUCT_RDR,data->rdr_license_limit/10.0);
        } 
        
        /* output field */
        if (data->rdr_license==STATE_IMPOSSIBLE_VALUE)
        {
            if (data->rdr_license_limit==STATE_POSTSCRIPT_CP_VALUE)
            { /* append "(pp)" */
              printf("%-40s%s%s(%s)\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC,STATE_POSTSCRIPT_PP_DESC);
            }
            else 
            { /* append "(cp)" */
              printf("%-40s%s%s(%s)\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC,STATE_POSTSCRIPT_CP_DESC);
            }
        }
        else if (data->rdr_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 2 */

    if (data->perf_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 3 */
        if (data->perf_license==STATE_IMPOSSIBLE_VALUE)
        {
              printf("%-40s%s%s\n",PRODUCT_PERF,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC);
        }
        else if (data->perf_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",PRODUCT_PERF,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",PRODUCT_PERF,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 3 */

    if (data->rc_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 4 */
        if (data->rc_license==STATE_IMPOSSIBLE_VALUE)
        {
              printf("%-40s%s%s\n",PRODUCT_REP_CONTROL,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC);
        }
        else if (data->rc_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",PRODUCT_REP_CONTROL,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",PRODUCT_REP_CONTROL,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 4 */

    if (data->acc_wwn_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 5 */
        
        /* concat field "product" */
        if (data->wwn_license==PRODUCT_POSTSCRIPT_NOLIM_VALUE)
        {
            sprintf(product,"%s(%s)",PRODUCT_ACCESS_CONTROL,PRODUCT_POSTSCRIPT_NOLIM_DESC);
        }
        else
        {    
            sprintf(product,"%s(%d)",PRODUCT_ACCESS_CONTROL,data->wwn_license);
        }     
        
        /* output */
        if (data->acc_wwn_license==STATE_IMPOSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC);
        }
        else if (data->acc_wwn_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 5 */    

    if (data->perf_opt_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 6 */
        
        /* concat field "product" */
        if (data->perf_opt_license_limit==PRODUCT_POSTSCRIPT_NOLIM_VALUE)
        {
            sprintf(product,"%s(%s)",PRODUCT_PERF_OPT,PRODUCT_POSTSCRIPT_NOLIM_DESC);
        }
        else if (data->perf_opt_license_limit==PRODUCT_POSTSCRIPT_NONE_VALUE)
        {
            sprintf(product,"%s",PRODUCT_PERF_OPT);
        }
        else
        {
            sprintf(product,"%s(%.1f)",PRODUCT_PERF_OPT,data->perf_opt_license_limit/10.0);
        } 
        
        /* output */
        if (data->perf_opt_license==STATE_IMPOSSIBLE_VALUE)
        {
            if (data->perf_opt_license_limit==STATE_POSTSCRIPT_CP_VALUE)
            { /* append "(cp)" */
              printf("%-40s%s%s(%s)\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC,STATE_POSTSCRIPT_PP_DESC);
            }
            else 
            { /* append "(pp)" */
              printf("%-40s%s%s(%s)\n",product,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC,STATE_POSTSCRIPT_CP_DESC);
            }
        }
        else if (data->perf_opt_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",product,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 6 */

    if (data->sp_license!=PRODUCT_ROW_INVISIBLE_VALUE)
    {/* print row 7 */
        if (data->sp_license==STATE_IMPOSSIBLE_VALUE)
        {
              printf("%-40s%s%s\n",PRODUCT_REALLOCATION_CONTROL,TABLE_COL_SEPARATOR,STATE_IMPOSSIBLE_DESC);
        }
        else if (data->sp_license==STATE_POSSIBLE_VALUE)
        {
            printf("%-40s%s%s\n",PRODUCT_REALLOCATION_CONTROL,TABLE_COL_SEPARATOR,STATE_POSSIBLE_DESC);
        }
        else 
        {
            printf("%-40s%s%s\n",PRODUCT_REALLOCATION_CONTROL,TABLE_COL_SEPARATOR,"--");    
        }
    } /* end of printing row 7 */

    /* print condition code */
    print_condition_code(o_inf);

    free(i_inf.data); /* release allocated memory */
    return FCSAN_SUCCESS_CODE; /* success */

} /* end of "diskList_dp" */

/**************************************************************************************/

int diskList_dd(unsigned char array_id)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMAry * data=NULL;
    char *state[]={ARRAY_STATE_READY_DESC,ARRAY_STATE_ATTENTION_DESC,
            ARRAY_STATE_FAULT_DESC};
    char array_name[33];
    int i,result;

    /* Init "i_inf" */
    i_inf.data_size =sizeof(iSMSMAry) ;
    i_inf.data=malloc(i_inf.data_size);
    if (!i_inf.data) 
    {/* memory allocation failure */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DD,
            CMDCODE_TYPE_SYSTEMFUNC,1);
        return FCSAN_ERROR_CODE; 
    }
    
    /* Call API */
    result= iSMSMGetAryInfo(array_id,&i_inf,&o_inf) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {/* API error */
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_DD,CMDCODE_TYPE_API,1);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
        return FCSAN_ERROR_CODE;
    }
    
    data=(iSMSMAry *)i_inf.data;
    /* Output table header */
    chars2str(data->array_name,32,array_name);
    printf("%-11s:%04u\n",ARRAY_ID_LABEL,array_id);                /* Array_ID */
    printf("%-11s:%s\n\n",DISK_ARRAY_LABEL,array_name);        /* Disk_Array */
    printf("%-4s%s%-5s%s%s\n",TYPE_LABEL,TABLE_COL_SEPARATOR,
                STATE_LABEL,TABLE_COL_SEPARATOR,CNT_LABEL);
    for (i=0;i<18;i++)
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

    if (data->ld_total_state!=0x00 && data->ld_total_state!=0x10 && data->ld_total_state!=0x20)
    {
        fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_DD,CMDCODE_TYPE_INTERNAL,9001);
        free(i_inf.data);  /* added by yangah when detecting memory leak */
            return FCSAN_ERROR_CODE;
    }
    /* Output table body */
    printf("%-4s%s%-5s%s%d\n",LD_LABEL,TABLE_COL_SEPARATOR,
        state[data->ld_total_state/16],TABLE_COL_SEPARATOR,
        data->pre_num_of_ld); /* print line "LD" */
    printf("%-4s%s%-5s%s%d\n",PD_LABEL,TABLE_COL_SEPARATOR,
        state[data->pd_total_state/16],TABLE_COL_SEPARATOR,
        data->pre_num_of_pd); /* print line "PD" */
    printf("%-4s%s%-5s%s%d\n",DAC_LABEL,TABLE_COL_SEPARATOR,
        state[data->dac_total_state/16],TABLE_COL_SEPARATOR,
        data->pre_num_of_dac); /* print line "DAC" */
    printf("%-4s%s%-5s%s%d\n",DE_LABEL,TABLE_COL_SEPARATOR,
        state[data->de_total_state/16],TABLE_COL_SEPARATOR,
        data->pre_num_of_de); /* print line "DE" */

    /* print condition code */
    print_condition_code(o_inf);
    
    free(i_inf.data); /* release allocated memory */
    return FCSAN_SUCCESS_CODE; /* success */

} /* end of "diskList_dd" */

/**************************************************************************************/

