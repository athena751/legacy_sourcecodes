/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistC.c,v 1.2301 2007/05/09 07:37:37 liuyq Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistC.c,v 1.2301 2007/05/09 07:37:37 liuyq Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAdisklist.h"

int diskList_c(unsigned char array_id,unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMDac *data=NULL;
    char ctl_name[13];
    char num_of_port[4];
    
    /*modified by hujing;according to the mail (nas 2791) No.24*/
    /*char * state[]={DAC_STATE_READY,DAC_STATE_OFFLINE,DAC_STATE_FAULT};*/
    char *dac_matter="";
    /*end modify*/
    
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    unsigned char dac_num;
    int i,j,result ;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_C,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf.data =NULL ;
    result=iSMSMGetDacListInfo(array_id,&i_inf,&o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_C,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */
    
    /* output table header */
    printf("%-9s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%8s  %8s%s%-12s%s%6s%s%-10s%s%s\n",
        //TYPE_LABEL,TABLE_COL_SEPARATOR,
        CTL_RES_TYPE,                         // modify by jiangfx,2007.4.26
        CTL_DIR_TYPE,TABLE_COL_SEPARATOR,
        CTL_NAME_LABEL,TABLE_COL_SEPARATOR,
        CTL_NO_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL,TABLE_COL_SEPARATOR,
        COMPLEMENT_LABEL);
    //for (i=0;i<50;i++) // modify by jiangfx,2007.4.26
    for (i=0;i<74;i++)
    {
        printf("%c",TABLE_LINE_SYMBOL);
    }
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY || remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }

    /* get DAC info */
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
        i_inf.data_size=get_num*sizeof(iSMSMDac);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMDac));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_C,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        /* call API */
        result=iSMSMGetDacListInfo(array_id,&i_inf,&o_inf);
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_C,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /* Output Table Body */
        data=(iSMSMDac *)i_inf.data ;
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            /*remarked by hj;according to the mail (nas 2791) No.26*/
            /*unsigned char dac_matter=data[i].dac_matter/16;
            if (dac_matter>2)
            {
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_C,CMDCODE_TYPE_INTERNAL,9001);
                return FCSAN_ERROR_CODE;
            }*/
            
            /*modified by hujing;according to the mail (nas 2791) No.26*/
            /*switch (data[i].dac_type)
            {
              case DAC_TYPE_HD_RD_DD_ETC_VALUE_ONE:
              case DAC_TYPE_HD_RD_DD_ETC_VALUE_TWO:
                if (data[i].dir_type==DIR_TYPE_HD_VALUE)
                {
                    ctl_name=CTL_NAME_HD;
                }
                else if (data[i].dir_type==DIR_TYPE_RD_VALUE)
                {
                    ctl_name=CTL_NAME_RD;
                }
                else if (data[i].dir_type==DIR_TYPE_DD_VALUE)
                {
                    ctl_name=CTL_NAME_DD;
                }
                else
                {
                    ctl_name=CTL_NAME_ETC;
                }                                
                break;
              case DAC_TYPE_CHE_VALUE:
                ctl_name=CTL_NAME_CHE;
                break;
              case DAC_TYPE_SVP_VALUE:
                ctl_name=CTL_NAME_SVP;
                break;
              case DAC_TYPE_DAC_PS_VALUE:
                ctl_name=CTL_NAME_DAC_PS;
                break;
              case DAC_TYPE_DAC_BBU_VALUE:
                ctl_name=CTL_NAME_DAC_BBU;
                break;
              case DAC_TYPE_DAC_FANU_VALUE:
                ctl_name=CTL_NAME_DAC_FANU;
                break;
              case DAC_TYPE_DAC_FANL_VALUE:
                ctl_name=CTL_NAME_DAC_FANL;
                break;
              case DAC_TYPE_DAC_TEMP_ALM_VALUE:
                ctl_name=CTL_NAME_DAC_TEMP_ALM;
                break;
              case DAC_TYPE_DAC_BB_VALUE:
                ctl_name=CTL_NAME_DAC_BB;
                break;
              case DAC_TYPE_BC_JB_VALUE:
                ctl_name=CTL_NAME_BC_JB;
                break;
              case DAC_TYPE_PANEL_VALUE:
                ctl_name=CTL_NAME_PANEL;
                break;
              default: 
                ctl_name=CTL_NAME_ETC;
                break;
            } */
            chars2str(data[i].dac_name,12,ctl_name);
            /*end modify*/
            
            if (data[i].dac_type==0x01 || data[i].dac_type==0x02)
                dac_num=data[i].dir_num;
            else
                dac_num=data[i].dac_num;
                
            /*modified by hj;according to the mail (nas 2791) No.25*/
            /*printf(" %02xh%s%-12s%s   %02xh%s%-7s%s",
                data[i].dac_type,TABLE_COL_SEPARATOR,
                ctl_name,TABLE_COL_SEPARATOR,
                dac_num,TABLE_COL_SEPARATOR,
                state[data[i].dac_matter/16],TABLE_COL_SEPARATOR);*/
                
            switch (data[i].dac_matter){
            case 0x00:
                dac_matter = DAC_STATE_READY;
                break;
            case 0x10:
                dac_matter = DAC_STATE_OFFLINE;
                break;
            case 0x11:
                dac_matter = DAC_STATE_NOLICENCE;
                break;
            case 0x12:
                dac_matter = DAC_STATE_REBUILDING;
                break;                
            case 0x13:
                dac_matter = DAC_STATE_CHARGE;
                break;
            case 0x14:
                dac_matter = DAC_STATE_WARNING1;
                break;                
            case 0x20:
                dac_matter = DAC_STATE_FAULT;
                break;
            default:
                dac_matter="unknown";
            }
            printf("     %02xh       %02xh%s%-12s%s   %02xh%s%-10s%s",
                //data[i].dac_type,TABLE_COL_SEPARATOR,  // modify by jiangfx,2007.4.26
                data[i].res_type,
                data[i].dir_type,TABLE_COL_SEPARATOR,
                ctl_name,TABLE_COL_SEPARATOR,
                dac_num,TABLE_COL_SEPARATOR,
                dac_matter,TABLE_COL_SEPARATOR);
            /*end modify*/    
            
            /* print complement*/
            if (data[i].dac_type==DAC_TYPE_PORT_NO_VALUE_ONE ||
                data[i].dac_type==DAC_TYPE_PORT_NO_VALUE_TWO)
            {
                if (data[i].num_of_port==0)
                    printf("--");
                else
                {
                    printf("%s",PORT_NO_EQUAL_LABEL);
                    for (j=0;j<data[i].num_of_port;j++)
                    {
                        printf("%02xh",j);
                        if (j!=data[i].num_of_port-1)
                            printf(",");    
                    } /* end of "for" */
                    if (data[i].dac_type==0x01 && data[i].dir_type==0x10 &&
                        data[i].res_type>=0x80 && data[i].res_type<=0x8f)
                        switch (data[i].protocol)
                        {
                          case 1:
                            printf(",FC");
                            break;
                          case 2:
                            printf(",PI");
                            break;
                          case 3:
                            printf(",IP");
                            break;
                          default:
                            printf(",unknown");
                        }
                }
            }
            else if (data[i].dac_type==DAC_TYPE_CACHE_VALUE)
            {
                printf("%s:%u%s",CAPACITY_LABEL,data[i].cache_capacity_conf,MBYTE_LABEL);
            }
            else
                printf("--");            
            printf("\n");            
            
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
    
} /* end of "diskList_c" */

/*********************************************************************************************/
