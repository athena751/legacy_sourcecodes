/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklistO.c,v 1.2301 2005/12/16 06:15:14 liyb Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklistO.c,v 1.2301 2005/12/16 06:15:14 liyb Exp $";
#endif
#endif

#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"
#include "general.h"
#include "iSAdisklist.h"

int diskList_o(unsigned char array_id,unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMOwner *data=NULL;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int result ;
    int i,j;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_O,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf .data =NULL ;
    result=iSMSMGetOwnerListInfo(array_id,&i_inf , &o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_O,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num = o_inf . remain_num ; /* total number */
    
    /* Output Table Header */
    printf("%-10s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%-8s%s%-8s%s%-19s%s%s\n",
        OWNER_ID_LABEL,TABLE_COL_SEPARATOR,PLATFORM_LABEL,TABLE_COL_SEPARATOR,
        WWN_LABEL,TABLE_COL_SEPARATOR,OWNER_NAME_LABEL);

    for (i=0;i<49;i++)
    {
        printf("%c",TABLE_LINE_SYMBOL);
    }
    printf("\n");

    if (result==iSMSM_TBL_NOENTRY ||remain_num==0)
    {
        printf("%s::%s=%s\n",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL,CONDITION_CODE_ZERO);
        return FCSAN_SUCCESS_CODE;
    }    

    /* get disk array info */
    while (remain_num>0)
    {
        get_num=(remain_num<=lcount)?remain_num:lcount;

        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        i_inf.data_size=get_num*sizeof(iSMSMOwner);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMOwner));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_O,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetOwnerListInfo(array_id,&i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_O,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMOwner *)i_inf.data ;
        /* Output Table Body */
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            char owner_name[33];
            printf("    %04u%s     %02xh%s",
                data[i].owner_id,TABLE_COL_SEPARATOR,
                data[i].host_type,TABLE_COL_SEPARATOR);
            if (data[i].wwn[0] != -1 || data[i].wwn[1] != -1 ||
               data[i].wwn[2] != -1 || data[i].wwn[3] != -1 ||
               data[i].wwn[4] != -1 || data[i].wwn[5] != -1 ||
               data[i].wwn[6] != -1 || data[i].wwn[7] != -1)
                printf("%02x%02x-%02x%02x-%02x%02x-%02x%02x%s",
                    (unsigned char)data[i].wwn[0],(unsigned char)data[i].wwn[1],
                    (unsigned char)data[i].wwn[2],(unsigned char)data[i].wwn[3],
                    (unsigned char)data[i].wwn[4],(unsigned char)data[i].wwn[5],
                    (unsigned char)data[i].wwn[6],(unsigned char)data[i].wwn[7],
                     TABLE_COL_SEPARATOR);
            else
                printf("%-19s%s","-",TABLE_COL_SEPARATOR);            
            chars2str(data[i].owner_name,32,owner_name);        
            printf("%s\n",owner_name);
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
    
} /* end of "diskList_o" */

/***************************************************************************************/

int diskList_ol(unsigned char array_id,unsigned short oid, unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMOwnerId ownerid;
    iSMSMLd *data=NULL;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int result ;
    int i,j;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OL,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
/* modified by chs & key, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ownerid);

    /* call API to get total number */
    ownerid.array_id=array_id;
    ownerid.owner_id=oid;
    i_inf .data =NULL ;

    result=iSMSMGetOwnerLdInfo(&ownerid , &i_inf , &o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_OL,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num = o_inf . remain_num ; /* total number */

    /* Output Table Header */
    printf("%-10s:%04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-10s:%04u\n\n",OWNER_ID_LABEL,oid);
    printf("%-5s%s%-8s%s%-25s%s%-15s%s%4s%s%15s%s%-5s%s%11s%s%5s%s%-7s%s%s\n",
          LD_NO_LABEL,TABLE_COL_SEPARATOR, TYPE_LABEL,TABLE_COL_SEPARATOR,
          LD_NAME_LABEL,TABLE_COL_SEPARATOR,STATE_LABEL,TABLE_COL_SEPARATOR,
          RAID_LABEL,TABLE_COL_SEPARATOR,CAPACITY_LABEL,TABLE_COL_SEPARATOR,
          CACHE_LABEL,TABLE_COL_SEPARATOR,PROGRESSION_LABEL,TABLE_COL_SEPARATOR,
          LUN_LABEL,TABLE_COL_SEPARATOR,RESERVE_LABEL,TABLE_COL_SEPARATOR,
          DVR_LABEL);

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
        get_num=(remain_num<=lcount)?remain_num:lcount;

        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        i_inf.data_size=get_num*sizeof(iSMSMLd);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OL,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetOwnerLdInfo(&ownerid,&i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_OL,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMLd *)i_inf.data ;
        /* Output Table Body */
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            int err_no=outLDPartInfo(data[i] , CMDCODE_FUNC_ISADISKLIST_OL,array_id );
            if (err_no)
            {
                fflush(stdout);
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OL,CMDCODE_TYPE_INTERNAL,9000+err_no);
                free(i_inf.data);
                return FCSAN_ERROR_CODE;
            }

            /* print LUN */
            printf("%04xh%s",data[i].lun,    TABLE_COL_SEPARATOR);

            /* print "Reserve" */
            if (data[i].reserve_flag==0)
                printf("no     %s",TABLE_COL_SEPARATOR);
            else if (data[i].reserve_flag==1)
                printf("yes    %s",TABLE_COL_SEPARATOR);
            else
            {
                fflush(stdout);
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OL,CMDCODE_TYPE_INTERNAL,9005);
                free(i_inf.data);
                return FCSAN_ERROR_CODE;
            }    

            /* print "DVR" */
            if (data[i].dvr_flag==0)
                printf("no%s\n",TABLE_COL_SEPARATOR);
            else if (data[i].dvr_flag==1)
                printf("yes%s\n",TABLE_COL_SEPARATOR);
            else
            {
                fflush(stdout);
                fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                        MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                        COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OL,CMDCODE_TYPE_INTERNAL,9006);
                free(i_inf.data);
                return FCSAN_ERROR_CODE;
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

} /* end of "diskList_ol" */

/***************************************************************************************/

int diskList_os(unsigned char array_id,char* owner_name, int detail, unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    LdPatternListHeadNode *patternlist=NULL;
    iSMSMOwner *data=NULL;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int result ;
    int i,j;

    if (lcount==0 || !owner_name || owner_name[0]==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OS,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }

    /* call API to get total number */
    i_inf .data =NULL ;

    result=iSMSMGetOwnerListInfo(array_id , &i_inf , &o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_OS,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num = o_inf . remain_num ; /* total number */
    
    /* Output Table Header */
    printf("%-11s:%04u\n",ARRAY_ID_LABEL,array_id);
    printf("%-11s:%s\n\n",OWNER_NAME_LABEL,owner_name);
    printf("%-8s%s%-8s%s%-19s%s",OWNER_ID_LABEL,TABLE_COL_SEPARATOR,
            PLATFORM_LABEL,TABLE_COL_SEPARATOR,
            WWN_LABEL,TABLE_COL_SEPARATOR);
    if (detail)
        printf("%s",PATTERN_LABEL);
    printf("\n");

    for (i=0;i<50;i++)
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
        get_num=(remain_num<=lcount)?remain_num:lcount;

        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        i_inf.data_size=get_num*sizeof(iSMSMOwner);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMOwner));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OS,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetOwnerListInfo(array_id , &i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_OS,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMOwner *)i_inf.data ;
        /* Output Table Body */
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            char  cur_owner_name[33];
            char  spec_owner_name[33];
            chars2str(data[i].owner_name,32,cur_owner_name);
            chars2str(owner_name,32,spec_owner_name);
            if ( strcmp(spec_owner_name,cur_owner_name ) )
                continue;  /* the current owner does not meet the requirement,so skip .*/
            printf("    %04u%s     %02xh%s",data[i].owner_id,TABLE_COL_SEPARATOR,
                    data[i].host_type,TABLE_COL_SEPARATOR);
            if (data[i].wwn[0] != -1 || data[i].wwn[1] != -1 ||
               data[i].wwn[2] != -1 || data[i].wwn[3] != -1 ||
               data[i].wwn[4] != -1 || data[i].wwn[5] != -1 ||
               data[i].wwn[6] != -1 || data[i].wwn[7] != -1)
                printf("%02x%02x-%02x%02x-%02x%02x-%02x%02x%s",
                    (unsigned char)data[i].wwn[0],(unsigned char)data[i].wwn[1],
                    (unsigned char)data[i].wwn[2],(unsigned char)data[i].wwn[3],
                    (unsigned char)data[i].wwn[4],(unsigned char)data[i].wwn[5],
                    (unsigned char)data[i].wwn[6],(unsigned char)data[i].wwn[7],
                     TABLE_COL_SEPARATOR);
            else
                printf("%-19s%s","-",TABLE_COL_SEPARATOR);            

            if (detail)
            {
                unsigned short pattern;
                fflush(stdout);   /*added by yangah, 2002/6/24 */
                if (load_pattern(array_id,data[i].owner_id,lcount,&patternlist,&pattern)) 
                { /* error occurred in function load_pattern() */
                    free(i_inf.data);
                    releasePatternList(patternlist);
                    printf("\n");
                    return FCSAN_ERROR_CODE;
                }
                else
                    printf("%7u",pattern);
            }
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
    releasePatternList(patternlist);
    return FCSAN_SUCCESS_CODE; /* success */    
    
} /* end of "diskList_os" */

/***************************************************************************************/

int diskList_pf(unsigned char array_id,unsigned int lcount)
{
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMPf *data=NULL;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int result ;
    int i,j;

    if (lcount==0)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PF,CMDCODE_TYPE_INTERNAL,1);
        return FCSAN_ERROR_CODE;
    }
    
    /* call API to get total number */
    i_inf .data =NULL ;
    result=iSMSMGetPfInfo(array_id,&i_inf , &o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_PF,CMDCODE_TYPE_API,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num = o_inf . remain_num ; /* total number */
    
    /* Output Table Header */
    printf("%-10s:%04u\n\n",ARRAY_ID_LABEL,array_id);
    printf("%-7s%s%-7s%s%-12s%s%s\n",
        PF_TYPE_LABEL,TABLE_COL_SEPARATOR,PF_INFO_LABEL,TABLE_COL_SEPARATOR,
        ABBREVIATION_LABEL,TABLE_COL_SEPARATOR,PF_NAME_LABEL);

    for (i=0;i<45;i++)
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
        get_num=(remain_num<=lcount)?remain_num:lcount;

        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        i_inf.data_size=get_num*sizeof(iSMSMPf);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMPf));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_PF,
                CMDCODE_TYPE_SYSTEMFUNC,1);
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetPfInfo(array_id,&i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_PF,CMDCODE_TYPE_API+1,loop_count+1);
            free(i_inf.data);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMPf *)i_inf.data ;
        /* Output Table Body */
        for (i=0;i<o_inf.return_num;i++)
        {/* print a record in one loop procedure */
            char name_abbr[9], name[33];
            chars2str(data[i].host_nm,8,name_abbr);        
            chars2str(data[i].host_name,32,name);
            printf("    %02xh%s    %02xh%s%-12s%s%-s\n",
                data[i].host_type,TABLE_COL_SEPARATOR,
                data[i].host_bit1,TABLE_COL_SEPARATOR,
                name_abbr,TABLE_COL_SEPARATOR,name);
            
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

} /* end of "diskList_pf" */

/***************************************************************************************/

int load_pattern(unsigned char array_id,unsigned short owner_id,unsigned int lcount , LdPatternListHeadNode **patternlist ,unsigned short *pattern)
{ 
    iSMSMinDataInfo i_inf;
    iSMSMoutDataInfo o_inf;
    iSMSMOwnerId ownerid;
    iSMSMLd *data=NULL;
    LdPatternListHeadNode * new_pattern=NULL;
    LdPatternListHeadNode * current_pattern=NULL;
    LdPatternListHeadNode * last_pattern=NULL;
    int pattern_already_exist=0;
    unsigned int remain_num;
    unsigned int get_num;
    unsigned int table_rev=iSMSM_TBL_FIRST;
    unsigned int current_num=1;
    unsigned int loop_count=0;
    int result ;
    int i,j;

    if (lcount==0 || !pattern)
    {
        fflush(stdout);
        fprintf(stderr,"\n%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OS,CMDCODE_TYPE_INTERNAL,2);
        return FCSAN_ERROR_CODE;
    }
    
/* modified by chs & key & hujun, 2002-12-26*/
    ISMSM_CLI_INIT_ZERO(ownerid);

    /* call API to get total number */
    ownerid.array_id=array_id;
    ownerid.owner_id=owner_id;
    i_inf .data =NULL ;
    result=iSMSMGetOwnerLdInfo(&ownerid,&i_inf , &o_inf ) ;
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fflush(stdout);
        fprintf(stderr,"\n%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            CMDCODE_FUNC_ISADISKLIST_OS,CMDCODE_TYPE_API+2,1);
        return FCSAN_ERROR_CODE;
    }
    remain_num = o_inf . remain_num ; /* total number */

    if (result==iSMSM_TBL_NOENTRY || remain_num==0 )
    {
        *pattern=0;
        return FCSAN_SUCCESS_CODE;
    }    

    new_pattern=(LdPatternListHeadNode *)malloc(sizeof (LdPatternListHeadNode));
    if  ( ! new_pattern)
    { /* mem alloc failure */
            fflush(stdout);
            fprintf(stderr,"\n%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OS,
                CMDCODE_TYPE_SYSTEMFUNC,2);
            return FCSAN_ERROR_CODE;
    }
    else
    {
        memset( new_pattern, 0 , sizeof(LdPatternListHeadNode) );
        new_pattern->numOfLd=remain_num;
    }

    /* get disk array info */
    while (remain_num>0)
    {
        get_num=(remain_num<=lcount)?remain_num:lcount;

        /* Initiate "i_inf" */
        i_inf.get_num=get_num ;
        i_inf.current_num=current_num ;
        i_inf.table_rev=table_rev ;
        i_inf.data_size=get_num*sizeof(iSMSMLd);
        
        /* Memory Allocation */
        i_inf.data=calloc(get_num,sizeof(iSMSMLd));
        if ( !i_inf.data )
        {/* Memory allocation failure */
            fflush(stdout);
            fprintf(stderr,"\n%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OS,
                CMDCODE_TYPE_SYSTEMFUNC,3);
            releasePatternList(new_pattern); 
            return FCSAN_ERROR_CODE;
        }
        
        result=iSMSMGetOwnerLdInfo(&ownerid , &i_inf , &o_inf ) ;
        if (result!=iSMSM_NORMAL)
        {/* API error */
            fflush(stdout);
            fprintf(stderr,"\n%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                CMDCODE_FUNC_ISADISKLIST_OS,CMDCODE_TYPE_API+3,loop_count+1);
            free(i_inf.data);
            releasePatternList(new_pattern);
            return FCSAN_ERROR_CODE;
        }
        
        data=(iSMSMLd *)i_inf.data ;

        for (i=0;i<o_inf.return_num;i++)
        {
            LdNoNode * ld_node=(LdNoNode *)malloc(sizeof(LdNoNode));
            if ( !ld_node)
            {
                fflush(stdout);
                fprintf(stderr,"\n%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                    MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                    COMMAND_CODE_LABEL,CMDCODE_FUNC_ISADISKLIST_OS,
                    CMDCODE_TYPE_SYSTEMFUNC,4);
                releasePatternList(new_pattern); 
                return FCSAN_ERROR_CODE;                
            }
            ld_node->ld_no=data[i].ld_num;
            ld_node->next=new_pattern->right;
            new_pattern->right=ld_node; /* insert in the front */
        }/* end of "for" */

        /* release allocated memory */
        free(i_inf.data);
        
        /* make provision for the next loop procedure */
        remain_num = o_inf.remain_num ;
        current_num += o_inf.return_num;
        table_rev=o_inf.table_rev ;
        loop_count++;
        
    }/* end of "while" */

        /* get pattern value */
    pattern_already_exist=0;
    *pattern=0;
    current_pattern=*patternlist;
    last_pattern=NULL;
    while (!pattern_already_exist && current_pattern!=NULL)
    {
            (*pattern)++;
            if (current_pattern->numOfLd!=new_pattern->numOfLd)
            {
                last_pattern=current_pattern;
                current_pattern=current_pattern->down;
            }
            else
            {
                LdNoNode * cur_ld_node=current_pattern->right;
                LdNoNode * new_ld_node=new_pattern->right;
                while ( cur_ld_node && new_ld_node)
                {
                    if (cur_ld_node->ld_no != new_ld_node->ld_no)
                        break;
                    cur_ld_node=cur_ld_node->next;
                    new_ld_node=new_ld_node->next;
                }
                if (cur_ld_node || new_ld_node)/* one list is not empty ; goto the next pattern */
                {
                    last_pattern=current_pattern;
                    current_pattern=current_pattern->down;
                }
                else
                    pattern_already_exist=1;                    
            }
    } /* end of "while" */
    if (!pattern_already_exist)
    { /* append the pattern */
            new_pattern->down=NULL;
            if ( !last_pattern)  /* pattern list is empty */
                *patternlist=new_pattern;
            else
                last_pattern->down=new_pattern;            
            (*pattern)++;
    }
    else
    { /* pattern already exists ; releast new_pattern */
            releasePatternList(new_pattern); 
    }        

    return FCSAN_SUCCESS_CODE; /* success */        
} /* end of "load_pattern" */

void releasePatternList(LdPatternListHeadNode *patternlist)
{
    while (patternlist!=NULL)
    {
        LdPatternListHeadNode * cur_pattern=patternlist;
        patternlist=patternlist->down;
        while (cur_pattern->right!=NULL)
        {
            LdNoNode * cur_ldno_node=cur_pattern->right;
            cur_pattern->right=cur_ldno_node->next;
            free(cur_ldno_node);
        }
        free(cur_pattern); /* release head node */
    }
} /* end of "releasePatternList" */
