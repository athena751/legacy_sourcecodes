/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistE.c,v 1.2301 2005/12/23 12:51:16 liyb Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistE.c,v 1.2301 2005/12/23 12:51:16 liyb Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAdisklist.h"

int diskList_e(unsigned char array_id,unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMDe *data;
    
    /*modified by hj; according to the mail (nas 2791) No.27*/
    /*char * ctl_name[]={"",CTL_NAME_DE_ADP,CTL_NAME_DE_PS,CTL_NAME_DE_FAN,
               CTL_NAME_DE_TEMP_FAN,CTL_NAME_DE_BB,CTL_NAME_EC_JB} ;*/
    
    char de_name[13];        
    /*end modify*/
    
    char * state[]={DAC_STATE_READY,DAC_STATE_OFFLINE,DAC_STATE_FAULT};
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
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_E,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf.data =NULL ;
    result=iSMSMGetDeListInfo(array_id,&i_inf,&o_inf);
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_E,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num=o_inf.remain_num ; /* total number */

    /* output table header */
    printf("%-9s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%4s%s%-12s%s%6s%s%-7s\n",
        TYPE_LABEL,TABLE_COL_SEPARATOR,
        CTL_NAME_LABEL,TABLE_COL_SEPARATOR,
        CTL_NO_LABEL,TABLE_COL_SEPARATOR,
        STATE_LABEL);
    for (i=0;i<35;i++)
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
        i_inf.data_size=get_num*sizeof(iSMSMDe);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMDe));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_E,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        /* call API */
        result=iSMSMGetDeListInfo(array_id,&i_inf,&o_inf);
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);  /*added by changhs 2002/07/01*/
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_E,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        /* Output Table Body */
        data=(iSMSMDe *)i_inf.data ;
        for (i=0;i<get_num;i++)
        {/* print a record in one loop procedure */
            unsigned char de_type=data[i].de_type;
            unsigned char de_matter=data[i].de_matter/16;
            if ((de_type>0x86 && de_type != 0xff) || de_type<0x81)
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_E,CMDCODE_TYPE_INTERNAL,9001);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;
            }
            if (de_matter>2)
            {
            	fflush(stdout);  /*added by changhs 2002/07/01*/
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_E,CMDCODE_TYPE_INTERNAL,9002);
                free(i_inf.data);  /* added by yangah when detecting memory leak */
                    return FCSAN_ERROR_CODE;
            }
            
            /*modified by hj;according to the mail (nas 2791) No.27*/
            /*printf(" %02xh%s%-12s%s   %02xh%s%-7s\n",
                data[i].de_type,TABLE_COL_SEPARATOR,
                ctl_name[de_type],TABLE_COL_SEPARATOR,
                data[i].de_num,TABLE_COL_SEPARATOR,
                state[de_matter]);*/
            if (de_type == 0xff && data[i].res_type == 0xc1){
                strcpy(de_name,"DE_ADP(SATA)");   		
	     }else{
                chars2str(data[i].de_name,12,de_name);        
	     }
		  printf(" %02xh%s%-12s%s   %02xh%s%-7s\n",
                data[i].de_type,TABLE_COL_SEPARATOR,
                de_name,TABLE_COL_SEPARATOR,
                data[i].de_num,TABLE_COL_SEPARATOR,
                state[de_matter]);    
            /*end modify*/
            
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

