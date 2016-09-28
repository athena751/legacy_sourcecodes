/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: iSAdisklist.c,v 1.2302 2005/09/20 02:25:38 liyb Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: iSAdisklist.c,v 1.2302 2005/09/20 02:25:38 liyb Exp $";
#endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "general.h"
#include "iSAdisklist.h"
//added by liyb 20050905
int getRaidtype(unsigned char raid_type)
{
  int raid=-1;
  switch (raid_type)
    {

             case 0x01:
                raid=5;
                break;
	      case 0x02:
                raid=3;
                break;
              case 0x04:
                raid=1;
                break;
              case 0x21:
                raid=6;
                break;
              case 0x41:
                raid=50;
                break;
              case 0x44:
                raid=10;
                break;		
      default:
        raid=-1;
  	}
  return raid;
}

//added by liyb 20050905
int getStateDescribe(unsigned char expansion_state_id, unsigned char matter_id, char** state)
{ 
    if (!(*state)){
		return 1;
    	}		
    if (expansion_state_id==POOL_STATE_ID_EXPANDING_NORMAL)  //data->expand_state==0x01   changed by liyb 20050831
    {
        *state=POOL_STATE_EXPANDING_NORMAL;     //RANK_STATE_EXPANDING;     changed by liyb 20050831
    } else if (expansion_state_id==POOL_STATE_ID_EXPANDING_SUSPEND) //added by liyb 20050905
    {
        *state=POOL_STATE_EXPANDING_SUSPEND;  //added by liyb 20050905
    } else if (expansion_state_id==POOL_STATE_ID_RAID_CONVERSIONING_NORMAL) //added by liyb 20050905
    {
        *state=POOL_STATE_RAID_CONVERSIONING_NORMAL;  //added by liyb 20050905
    } else if (expansion_state_id==POOL_STATE_ID_RAID_CONVERSIONING_SUSPEND) //added by liyb 20050905
    {
        *state=POOL_STATE_RAID_CONVERSIONING_SUSPEND;  //added by liyb 20050905
    } else if (expansion_state_id==POOL_STATE_ID_FAIL) //added by liyb 20050905
    {
        *state=POOL_STATE_FAIL;  //added by liyb 20050905
    }   else if (expansion_state_id==POOL_STATE_ID_END) //data->expand_state==0x00   changed by liyb 20050831
    { 
  
        switch (matter_id)  //data->rank _state  changed by liyb 20050831  
        {
          case 0x00:
           *state=POOL_STATE_READY; //RANK_STATE_READY; changed by liyb 20050831
            break;
          case 0x10:
            *state=POOL_STATE_REDUCE;//RANK_STATE_REDUCE;changed by liyb 20050831
            break;
          case 0x11:
            *state=POOL_STATE_REBUILDING;//RANK_STATE_REBUILDING;changed by liyb 20050831
            break;
          case 0x12:
            *state=POOL_STATE_PREVENTIVE_COPY; //RANK_STATE_PREVENTIVE_COPY;changed by liyb 20050831
            break;
          case 0x13:
            *state=POOL_STATE_COPY_BACK;//RANK_STATE_COPY_BACK;changed by liyb 20050831
            break;
          case 0x20:
            *state=POOL_STATE_FAULT;//RANK_STATE_FAULT;changed by liyb 20050831
            break;
          case 0x01:
           *state=POOL_MEDIA_ERROR;//RANK_MEDIA_ERROR;changed by liyb 20050831
            break;
        }
    	}

   return 0;
}

//to get pool_in_info  added by liyb 20050905
int getPoolInfo(unsigned short pool_no,  unsigned char array_id, iSMSMPool** poolData,iSMSMoutDataInfo *ptr_pool_o_inf,
                            unsigned int* loop_count,int cmdCodeFunc,int cmdCodeType)
{  
   iSMSMPoolId poolID; 
   //iSMSMPool   *pool;
   iSMSMinDataInfo  pool_i_inf;
   ISMSM_CLI_INIT_ZERO(poolID);
   int  result ;

    pool_i_inf.data_size = sizeof(iSMSMPool) ;
    pool_i_inf.data = malloc(pool_i_inf.data_size);
    if (!pool_i_inf.data) 
    {/* memory allocation failure */
         fprintf(stderr,"%s::%02u%03u:%s(%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            COMMAND_CODE_LABEL,cmdCodeFunc,
            CMDCODE_TYPE_SYSTEMFUNC,1);
		        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
                MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
                ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                cmdCodeFunc,cmdCodeType,1);
        return FCSAN_ERROR_CODE; 
    }
    poolID.array_id = array_id;
    poolID.pool_num = pool_no;

    result = iSMSMGetRankGroupInfo(&poolID,&pool_i_inf,ptr_pool_o_inf);  //&pool_o_inf
    if (result!=iSMSM_NORMAL && result!=iSMSM_TBL_NOENTRY)
    {
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",CMDNAME_ISADISKLIST,
            MSGNO_FCSAN_PREFIX,MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,
            ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
             cmdCodeFunc,cmdCodeType+1,(*loop_count)++);
	 free(pool_i_inf.data);
	
        return FCSAN_ERROR_CODE;
    }
    
     *poolData =(iSMSMPool *)pool_i_inf.data;
      
   return 0;
}
//added by liyb 20050906
//print ld head info 
// LD_No  Type  LD_Name   State  RAID  Capacity   Cache  Progression  
void printLDHeadInfo(void)
{
   printf("%-5s%s",LD_NO_LABEL,TABLE_COL_SEPARATOR);   //changed by liyb 20050905
   printf("%-8s%s",TYPE_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%-25s%s",LD_NAME_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%-15s%s",STATE_LABEL,  TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%4s%s",RAID_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%15s%s",CAPACITY_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%-3s%s",CACHE_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%11s%s",PROGRESSION_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
  
}
//added by liyb 20050906
//print ld head info 
//  POOL_No  POOL_Name  Base_pd

void printPoolHeadInfo(void)
{
   printf("%s%s",POOL_NO_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%-32s%s",POOL_NAME_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   printf("%s%s",BASE_PD_LABEL,TABLE_COL_SEPARATOR);  //changed by liyb 20050905
   
}

void printBasePdValue( unsigned char base_pd)
{       
   	   //print base_pd
 	    if(base_pd==iSMSMCFG_RAID_6_4PQ|| base_pd==iSMSMCFG_RAID_6_8PQ)
            {
          	printf("%-2d%s",base_pd,TABLE_COL_SEPARATOR);	
            }else
            {
               printf("%-2s%s",NO_BASE_PD,TABLE_COL_SEPARATOR);	
            }
}

int checkOption(char* option)
{
    int optionCase;
    if (!strcmp(option,OPTION_D)){/*"-d" option*/
        optionCase = 1;
    }else if (!strcmp(option,OPTION_DS)){/*"-ds" option*/
        optionCase = 2;
    }else if (!strcmp(option,OPTION_DAP)){/* "-dap" option*/
        optionCase = 3;
    }else if (!strcmp(option,OPTION_DAL)){/*"-dal" option*/
        optionCase = 4;
    }else if (!strcmp(option,OPTION_DP)){/*"-dp" option*/
        optionCase = 5;
    }else if (!strcmp(option,OPTION_DD)){/*"-dd" option*/
        optionCase = 6;
    }else if (!strcmp(option,OPTION_L)){/*"-l"*/
        optionCase = 7;
    }else if (!strcmp(option,OPTION_LP)){/*print usage for "-lp"*/
        optionCase = 8;
    }else if (!strcmp(option,OPTION_LS)){/*print usage for "-ls"*/
        optionCase = 9;
    }else if (!strcmp(option,OPTION_LAL)){/*print usage for "-lal"*/
        optionCase = 10;
    }else if (!strcmp(option,OPTION_LAP)){/*print usage for "-lap"*/
        optionCase = 11;
    }else if (!strcmp(option,OPTION_P)){/*print usage for "-p"*/
        optionCase = 12;
    }else if (!strcmp(option,OPTION_PL)){/*print usage for "-pl"*/
        optionCase = 13;
    }else if (!strcmp(option,OPTION_PD)){/*print usage for "-pd"*/
        optionCase = 14;
    }else if (!strcmp(option,OPTION_C)){/*print usage for "-c"*/
        optionCase = 15;
    }else if (!strcmp(option,OPTION_E)){/*print usage for "-e"*/
        optionCase = 16;
    }else if (!strcmp(option,OPTION_POOL)){/*print usage for "-pool"*/      // changed by liyb 20050829  r=>pool
        optionCase = 17;
   // }else if (!strcmp(option,OPTION_POOLD)){/*print usage for "-poold"*/
   //     optionCase = 18;
    }else if (!strcmp(option,OPTION_POOLP)){/*print usage for "-poolp"*/
        optionCase = 19;
    }else if (!strcmp(option,OPTION_POOLL)){/*print usage for "-pooll"*/
        optionCase = 20;
    }else if (!strcmp(option,OPTION_HELP)){/*"-?" option*/
        optionCase = 21;
    }else if (!strcmp(option,OPTION_LPOOL)){ /* -lpool*/ // changed by liyb 20050829  r=>pool
        optionCase=22;
    }else if (!strcmp(option,OPTION_O)){ 
        optionCase = 23;
    }else if (!strcmp(option,OPTION_OL)){ 
        optionCase = 24;
    }else if (!strcmp(option,OPTION_OS)){ 
        optionCase = 25;
    }else if (!strcmp(option,OPTION_PF)){ /* -pf */
        optionCase = 26;
    }else /*invalid option*/
        optionCase = -1;
        
    return optionCase;
}

void outUsages(int option)
{
    switch (option){
    case 1:
        fprintf(stderr,"%s\n",USAGE_FOR_D);
        break;
    case 2:
        fprintf(stderr,"%s\n",USAGE_FOR_DS);
        break;
    case 3:
        fprintf(stderr,"%s\n",USAGE_FOR_DAP);
        break;
    case 4:
        fprintf(stderr,"%s\n",USAGE_FOR_DAL);
        break;
    case 5:
        fprintf(stderr,"%s\n",USAGE_FOR_DP);
        break;
    case 6:
        fprintf(stderr,"%s\n",USAGE_FOR_DD);
        break;
    case 7:
        fprintf(stderr,"%s\n",USAGE_FOR_L);
        break;
    case 8:
        fprintf(stderr,"%s\n",USAGE_FOR_LP);
        break;
    case 9:
        fprintf(stderr,"%s\n",USAGE_FOR_LS);
        break;
    case 10:
        fprintf(stderr,"%s\n",USAGE_FOR_LAL);
        break;
    case 11:
        fprintf(stderr,"%s\n",USAGE_FOR_LAP);
        break;
    case 12:
        fprintf(stderr,"%s\n",USAGE_FOR_P);
        break;
    case 13:
        fprintf(stderr,"%s\n",USAGE_FOR_PL);
        break;
    case 14:
        fprintf(stderr,"%s\n",USAGE_FOR_PD);
        break;
    case 15:
        fprintf(stderr,"%s\n",USAGE_FOR_C);
        break;
    case 16:
        fprintf(stderr,"%s\n",USAGE_FOR_E);
        break;
    case 17:
        fprintf(stderr,"%s\n",USAGE_FOR_POOL);  //changed the followed 5 parameters by liyb 20050829
        break;
 //   case 18:
 //       fprintf(stderr,"%s\n",USAGE_FOR_POOLD);
 //       break;
    case 19:
        fprintf(stderr,"%s\n",USAGE_FOR_POOLP);
        break;
    case 20:
        fprintf(stderr,"%s\n",USAGE_FOR_POOLL);
        break;
    case 22:
        fprintf(stderr,"%s\n",USAGE_FOR_LPOOL);
        break;
    case 23:
        fprintf(stderr,"%s\n",USAGE_FOR_O);
        break;
    case 24:
        fprintf(stderr,"%s\n",USAGE_FOR_OL);
        break;
    case 25:
        fprintf(stderr,"%s\n",USAGE_FOR_OS);
        break;
    case 26:
        fprintf(stderr,"%s\n",USAGE_FOR_PF);
        break;
    case 21:
    case -1:
        fprintf(stderr,"%s\n",USAGE_FOR_D);
        fprintf(stderr,"%s\n",USAGE_FOR_DS);
        fprintf(stderr,"%s\n",USAGE_FOR_DAP);
        fprintf(stderr,"%s\n",USAGE_FOR_DAL);
        fprintf(stderr,"%s\n",USAGE_FOR_DP);
        fprintf(stderr,"%s\n",USAGE_FOR_DD);
        fprintf(stderr,"%s\n",USAGE_FOR_L);
        fprintf(stderr,"%s\n",USAGE_FOR_LP);
        fprintf(stderr,"%s\n",USAGE_FOR_LS);
        fprintf(stderr,"%s\n",USAGE_FOR_LAL);
        fprintf(stderr,"%s\n",USAGE_FOR_LAP);
        fprintf(stderr,"%s\n",USAGE_FOR_LPOOL);
        fprintf(stderr,"%s\n",USAGE_FOR_P);
        fprintf(stderr,"%s\n",USAGE_FOR_PL);
        fprintf(stderr,"%s\n",USAGE_FOR_PD);
        fprintf(stderr,"%s\n",USAGE_FOR_C);
        fprintf(stderr,"%s\n",USAGE_FOR_E);
        fprintf(stderr,"%s\n",USAGE_FOR_POOL);
        fprintf(stderr,"%s\n",USAGE_FOR_POOLP);
        fprintf(stderr,"%s\n",USAGE_FOR_POOLL);
        fprintf(stderr,"%s\n",USAGE_FOR_O);
        fprintf(stderr,"%s\n",USAGE_FOR_OL);
        fprintf(stderr,"%s\n",USAGE_FOR_OS);
		
        fprintf(stderr,"%s\n",USAGE_FOR_PF);
    }
        fprintf(stderr,"%s\n",USAGE_FOR_HELP); 
    return;
}

int check_lcount(char* parameter,char* lcountStr,int optionCase,unsigned int* lcountPtr)
{
    if (!parameter || !lcountStr)
        return FCSAN_ERROR_CODE;
        
    if (strcmp(parameter, PARAM_LCOUNT)){ /*no "-lcount"*/
        outUsages(optionCase);
        return FCSAN_ERROR_CODE;
    }
    if (convert_lcount(lcountStr,lcountPtr)){/* the value of lcount is invalid*/
        fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(-lcount:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,lcountStr); //changed by Yang AH
        return FCSAN_ERROR_CODE;
    }
    return FCSAN_SUCCESS_CODE;
} 

int main(int argc, char* argv[])
{
    unsigned int lcount = 128;
    unsigned char array_id,dir_num, port_rank_num;   
    int optionCase ,detail=0 ;
    unsigned short ldset_id,ld_no,oid;

    unsigned short pool_no; //added by liyb 20050829

    if (argc == 1){ /*usage error*/
        outUsages(-1);
        exit(FCSAN_ERROR_CODE);
    }
    optionCase = checkOption(argv[1]); /*check the invalidity of option*/
    
    if (optionCase == -1){/*invalid option*/
        outUsages(optionCase);
        exit(FCSAN_ERROR_CODE);
    }
    
    if (optionCase == 21){/*"-?" option*/
        if (argc==2){
                fprintf(stdout,"%s\n",USAGE_FOR_D);
                fprintf(stdout,"%s\n",USAGE_FOR_DS);
                fprintf(stdout,"%s\n",USAGE_FOR_DAP);
                fprintf(stdout,"%s\n",USAGE_FOR_DAL);
                fprintf(stdout,"%s\n",USAGE_FOR_DP);
                fprintf(stdout,"%s\n",USAGE_FOR_DD);
                fprintf(stdout,"%s\n",USAGE_FOR_L);
                fprintf(stdout,"%s\n",USAGE_FOR_LP);
                fprintf(stdout,"%s\n",USAGE_FOR_LS);
                fprintf(stdout,"%s\n",USAGE_FOR_LAL);
                fprintf(stdout,"%s\n",USAGE_FOR_LAP);
                fprintf(stdout,"%s\n",USAGE_FOR_LPOOL);
                fprintf(stdout,"%s\n",USAGE_FOR_P);
                fprintf(stdout,"%s\n",USAGE_FOR_PL);
                fprintf(stdout,"%s\n",USAGE_FOR_PD);
                fprintf(stdout,"%s\n",USAGE_FOR_C);
                fprintf(stdout,"%s\n",USAGE_FOR_E);
                fprintf(stdout,"%s\n",USAGE_FOR_POOL);
                fprintf(stdout,"%s\n",USAGE_FOR_POOLP);
                fprintf(stdout,"%s\n",USAGE_FOR_POOLL);
                fprintf(stdout,"%s\n",USAGE_FOR_O);
                fprintf(stdout,"%s\n",USAGE_FOR_OL);
                fprintf(stdout,"%s\n",USAGE_FOR_OS);
                fprintf(stdout,"%s\n",USAGE_FOR_PF);                
                fprintf(stdout,"%s\n",USAGE_FOR_HELP);                
                exit(FCSAN_SUCCESS_CODE);
        }else{
                outUsages(optionCase);
                exit(FCSAN_ERROR_CODE);
        }
    }
    
    if (optionCase == 1){/* "-d" option*/ 
            if (argc != 4 && argc != 2){/*the number of parameters is wrong*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }

        if (argc == 2)
            exit(diskList_d(128));
        else{
            if (!check_lcount(argv[2],argv[3],optionCase,&lcount)){/*lcount is invalid*/
                exit(diskList_d(lcount));
            }else
                exit(FCSAN_ERROR_CODE);
        }
    }
    
    /*process for other options*/
    if (argc < 4){ /*the number of parameters is not correct*/
        outUsages(optionCase);
        exit(FCSAN_ERROR_CODE);
    }
    if (strcmp(argv[2],PARAM_AID)){ /*no "-aid" parameter*/
        outUsages(optionCase);
        exit(FCSAN_ERROR_CODE);
    }
    if (convert_arrayid(argv[3],&array_id)){/*array_id is invalid*/
        fprintf(stderr,"%s::%02u%03u:%s(-aid:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
            MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[3]);
        exit(FCSAN_ERROR_CODE);
    }
    
    switch (optionCase){
    case 2: /*"-ds" option*/
        if (argc!=4)
        {
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        } /* added by Yang AH */
        exit(diskList_ds(array_id));
    case 3: /* "-dap" option*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_dap(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is valid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_dap(array_id,lcount));
    case 4: /* "-dal" option*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_dal(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is invalid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_dal(array_id,lcount));
    case 5: /*"-dp" option*/
        if (argc!=4)
        {
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        } /* added by Yang AH */
        exit(diskList_dp(array_id));
    case 6: /*"-dd" option*/
        if (argc!=4)
        {
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        } /* added by Yang AH */
        exit(diskList_dd(array_id));
    case 7: /*"-l" option */
        switch (argc){
        case 4:/*for "-aid" ,no "-detail" */
              exit(diskList_l_nooption(array_id,128,0)); 
        case 5:/*for "-aid -pool" or "-aid -detail" */
              if (!strcmp(argv[4],PARAM_POOL))
                  exit(diskList_l_pool(array_id,128,0));
        else if (!strcmp(argv[4],PARAM_DETAIL))
            exit(diskList_l_nooption(array_id,128,1));
              else{
                  outUsages(optionCase);
                  exit(FCSAN_ERROR_CODE);
              }
          case 6:/*for "-aid -ldset","-aid -port", "-aid -lcount" , "-aid -pool -detail */
              if (!strcmp(argv[4],PARAM_LDSET)){
            if (convert_ldset_no(argv[5],&ldset_id)){
            fprintf(stderr,"%s::%02u%03u:%s(-ldset:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else
                    exit(diskList_l_ldset(array_id,128,ldset_id,0));
            }else if(!strcmp(argv[4],PARAM_PORT)){
                  if (convert_port_rank_no(argv[5],&dir_num,&port_rank_num)){
            fprintf(stderr,"%s::%02u%03u:%s(-port:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else
                    exit(diskList_l_port(array_id,128,dir_num,port_rank_num,0));
         }else if (!strcmp(argv[4],PARAM_POOL)){ 
            if (!strcmp(argv[5],PARAM_DETAIL))
                exit(diskList_l_pool(array_id,128,1));
            else
            {
                outUsages(optionCase);
                          exit(FCSAN_ERROR_CODE);
            }
            }else{
                  if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is valid*/
                     exit(FCSAN_ERROR_CODE);
                 }else{
                     exit(diskList_l_nooption(array_id,lcount,0));
                 }
              }
          case 7: /*for "-pool -lcount" or "-ldset -detail" or "-port -detail" */
              if (!strcmp(argv[4],PARAM_POOL)){
                  if (check_lcount(argv[5],argv[6],optionCase,&lcount)){/*lcount is invalid*/
                     exit(FCSAN_ERROR_CODE);
                 }else{
                     exit(diskList_l_pool(array_id,lcount,0));
                 }
         }else if (!strcmp(argv[4],PARAM_LDSET)){
            if (convert_ldset_no(argv[5],&ldset_id)){
            fprintf(stderr,"%s::%02u%03u:%s(-ldset:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }else{
            if (!strcmp(argv[6],PARAM_DETAIL))
                exit(diskList_l_ldset(array_id,128,ldset_id,1));
            else
            {
                outUsages(optionCase);
                          exit(FCSAN_ERROR_CODE);
            }
            }            
         
         }else if (!strcmp(argv[4],PARAM_PORT)){
                  if (convert_port_rank_no(argv[5],&dir_num,&port_rank_num)){
            fprintf(stderr,"%s::%02u%03u:%s(-port:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else{
                    if (!strcmp(argv[6],PARAM_DETAIL))
                exit(diskList_l_port(array_id,128,dir_num,port_rank_num,1));
                     else
            {
                outUsages(optionCase);
                        exit(FCSAN_ERROR_CODE);
            }
            }               
         }else{
                  outUsages(optionCase);
                  exit(FCSAN_ERROR_CODE);
              }
          case 8:/*for "-ldset -lcount","-port -lcount" or "-pool -lcount -detail" */
              if (!strcmp(argv[4],PARAM_LDSET)){
            if (convert_ldset_no(argv[5],&ldset_id)){
            fprintf(stderr,"%s::%02u%03u:%s(-ldset:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else{
                    if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                         exit(FCSAN_ERROR_CODE);
                     else
                        exit(diskList_l_ldset(array_id,lcount,ldset_id,0));
                }
            }else if(!strcmp(argv[4],PARAM_PORT)){
                  if (convert_port_rank_no(argv[5],&dir_num,&port_rank_num)){
            fprintf(stderr,"%s::%02u%03u:%s(-port:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else{
                    if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                         exit(FCSAN_ERROR_CODE);
                     else
                        exit(diskList_l_port(array_id,lcount,dir_num,port_rank_num,0));
            }               
         }else if(!strcmp(argv[4],PARAM_POOL)){
            if (check_lcount(argv[5],argv[6],optionCase,&lcount))/*lcount is invalid*/
                         exit(FCSAN_ERROR_CODE);
                     else
            {
                if (!strcmp(argv[7],PARAM_DETAIL))
                    exit(diskList_l_pool(array_id,lcount,1));
                else
                {
                    outUsages(optionCase);
                              exit(FCSAN_ERROR_CODE);
                }
            }
            }else{
                outUsages(optionCase);
                  exit(FCSAN_ERROR_CODE);
              }
       case 9: /* "-ldset -lcount -detail" or "-port -lcount -detail" */
              if (!strcmp(argv[4],PARAM_LDSET)){
            if (convert_ldset_no(argv[5],&ldset_id)){
            fprintf(stderr,"%s::%02u%03u:%s(-ldset:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else{
                    if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                             exit(FCSAN_ERROR_CODE);
               else if (!strcmp(argv[8],PARAM_DETAIL))
                               exit(diskList_l_ldset(array_id,lcount,ldset_id,1));
               else
               {
                outUsages(optionCase);
                          exit(FCSAN_ERROR_CODE);
               }
                }
            }else if(!strcmp(argv[4],PARAM_PORT)){
                  if (convert_port_rank_no(argv[5],&dir_num,&port_rank_num)){
            fprintf(stderr,"%s::%02u%03u:%s(-port:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
                MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
                }else{
                    if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                         exit(FCSAN_ERROR_CODE);
                     else if (!strcmp(argv[8],PARAM_DETAIL))
                        exit(diskList_l_port(array_id,lcount,dir_num,port_rank_num,1));
            else{
                outUsages(optionCase);
                          exit(FCSAN_ERROR_CODE);
            }
            }               
            }else{
                outUsages(optionCase);
                  exit(FCSAN_ERROR_CODE);
              }

         default:
             outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
         }
    case 8: /*"-lp" option*/
        if (argc != 6 && argc != 8){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_NLD)){
            if (convert_ldno(argv[5],&ld_no)){ /*ld_no is invalid*/
            fprintf(stderr,"%s::%02u%03u:%s(-nld:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }
        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (argc == 6){ /*for "-aid -nld"*/
                exit(diskList_lp(array_id,ld_no,128));
        }else{ /*for "-aid -nld -lcount"*/
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                    exit(FCSAN_ERROR_CODE);
                else
                    exit(diskList_lp(array_id,ld_no,lcount));
        }
    case 9: /*"-ls" option*/
        if (argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_NLD)){
            if (convert_ldno(argv[5],&ld_no)){ /*ld_no is invalid*/
            fprintf(stderr,"%s::%02u%03u:%s(-nld:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }else
                exit(diskList_ls(array_id,ld_no));
        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
    case 10: /*"-lal" option*/
        if (argc != 6 && argc != 8){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_NLD)){
            if (convert_ldno(argv[5],&ld_no)){ /*ld_no is invalid*/
            fprintf(stderr,"%s::%02u%03u:%s(-nld:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }
        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (argc == 6){ /*for "-aid -nld"*/
                exit(diskList_lal(array_id,ld_no,128));
        }else{ /*for "-aid -nld -lcount"*/
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                    exit(FCSAN_ERROR_CODE);
                else
                    exit(diskList_lal(array_id,ld_no,lcount));
        }
    case 11: /*"-lap" option*/
        if (argc != 6 && argc != 8){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_NLD)){
            if (convert_ldno(argv[5],&ld_no)){ /*ld_no is invalid*/
            fprintf(stderr,"%s::%02u%03u:%s(-nld:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }
        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (argc == 6){ /*for "-aid -nld"*/
                exit(diskList_lap(array_id,ld_no,128));
        }else{ /*for "-aid -nld -lcount"*/
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                    exit(FCSAN_ERROR_CODE);
                else
                    exit(diskList_lap(array_id,ld_no,lcount));
       }
    case 12: /*"-p" option*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_p(array_id,128));
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is valid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_p(array_id,lcount));
    case 13: /*"-pl" option*/
        if (argc != 6 && argc != 8){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_NPD)){
            if (convert_port_rank_no(argv[5],&dir_num,&port_rank_num)){ /*port_no is invalid*/
            fprintf(stderr,"%s::%02u%03u:%s(-npd:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }
        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (argc == 6){ /*for "-aid -npd"*/
                exit(diskList_pl(array_id,dir_num,port_rank_num,128));
        }else{ /*for "-aid -npd -lcount"*/
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                    exit(FCSAN_ERROR_CODE);
                else
                    exit(diskList_pl(array_id,dir_num, port_rank_num,lcount));
        }
    case 14: /*"-pd" option */
        if (argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_NPD)){
            if (convert_port_rank_no(argv[5],&dir_num,&port_rank_num)){ /*port_no is invalid*/
            fprintf(stderr,"%s::%02u%03u:%s(-npd:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
            }else
                exit(diskList_pd(array_id,dir_num,port_rank_num));
        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
    case 15: /* "-c" option*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_c(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is valid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_c(array_id,lcount));
    case 16: /* "-e" option*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_e(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is invalid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_e(array_id,lcount));
    case 17: /* "-pool" option*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_pool(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is invalid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_pool(array_id,lcount));
//    case 18: /*"-poold" option */                                       //adited by liyb 20050829
//......
    case 19: /*"-poolp" option*/
        if (argc != 6 && argc != 8){/*the number of parameters is not correct*/
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_POOLNO)){                  //changed by liyb 20050829
			
//changed by liyb 20050829			
	      if(hex4toushort(argv[5], &pool_no) ||pool_no>255)/*pool_no is invalid*/   
	     	{
	     	  fprintf(stderr,"%s::%02u%03u:%s(-pno:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
	     	}

        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (argc == 6){ /*for "iSAdisklist  -poolp -aid  nnnn  -pno mmmmh"*/
                exit(diskList_poolp(array_id,pool_no,128));
        }else{ /*for "iSAdisklist  -poolp -aid  nnnn  -pno mmmmh -lcount xx"*/
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))/*lcount is invalid*/
                    exit(FCSAN_ERROR_CODE);
                else
                    exit(diskList_poolp(array_id,pool_no,lcount));
        }
    case 20: /*"-pooll" option*/
        if (argc != 6 && argc != 8){/*the number of parameters is not correct*/  
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (!strcmp(argv[4],PARAM_POOLNO)){   //changed by liyb 20050905

//changed by liyb 20050829			
	      if(hex4toushort(argv[5], &pool_no)||pool_no>255)/*pool_no is invalid*/   //changed by liyb 20050829
	     	{
	     	  fprintf(stderr,"%s::%02u%03u:%s(-pno:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
	     	}	

        }else{
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (argc == 6){ /*for "-aid -pno"*/
                exit(diskList_pooll(array_id,pool_no,128));
        }
	else{ 
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))
                    exit(FCSAN_ERROR_CODE);
                else
                    exit(diskList_pooll(array_id, pool_no,lcount));
        }
    case 22: /* -lpool */
        if (argc!=6|| strcmp(argv[4],PARAM_NLD  )) // delete && argc!=8  by liyb 20050829
        {
            outUsages(optionCase);
                      exit(FCSAN_ERROR_CODE);
        }
        if (convert_ldno(argv[5], &ld_no) )
        {
             fprintf(stderr,"%s::%02u%03u:%s(-nld:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
        }

        exit(diskList_lpool(array_id ,ld_no));  // delete parameter lcount by liyb 2050829

    case 23: /*-o*/
        if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_o(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is invalid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_o(array_id,lcount));
    case 24: /*-ol*/
        if (argc!=6 && argc!=8 || strcmp(argv[4],PARAM_OID))
        {
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        if (convert_oid(argv[5], &oid) )
        {
             fprintf(stderr,"%s::%02u%03u:%s(-oid:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
        }
        if (argc==8)
        {
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))
                  exit(FCSAN_ERROR_CODE);    
        }
        exit(diskList_ol(array_id ,oid ,lcount));
    case 25: /*-os*/
        if (argc <6 || argc > 9 || strcmp(argv[4],PARAM_ONAME))
        {
            outUsages(optionCase);
              exit(FCSAN_ERROR_CODE);
        }
        
        if (argc == 7 || argc == 9)
        {
            if (!strcmp(argv[6],PARAM_DETAIL))
                detail = 1;
            else{
                outUsages(optionCase);
                  exit(FCSAN_ERROR_CODE);
              }
        }
        
        if (isInvalidName(argv[5],18) )
        {
             fprintf(stderr,"%s::%02u%03u:%s(-oname:%s)\n",CMDNAME_ISADISKLIST,MSGNO_FCSAN_PREFIX,
               MSGNO_PARAM_ERROR,PARAM_ERR_INFO,argv[5]);
                exit(FCSAN_ERROR_CODE);
        }
        if (argc==8)
        {
            if (check_lcount(argv[6],argv[7],optionCase,&lcount))
                     exit(FCSAN_ERROR_CODE);    
        }
        if (argc == 9){
            if (check_lcount(argv[7],argv[8],optionCase,&lcount))
                     exit(FCSAN_ERROR_CODE);    
        }
        exit(diskList_os(array_id ,argv[5],detail,lcount));
   case 26: /*-pf*/    

           if (argc != 4 && argc != 6){/*the number of parameters is not correct*/
            outUsages(optionCase);
            exit(FCSAN_ERROR_CODE);
        }
        if (argc == 4)
            exit(diskList_pf(array_id,128));
            
        /*argc == 6*/
        if (check_lcount(argv[4],argv[5],optionCase,&lcount)){/*lcount is invalid*/
            exit(FCSAN_ERROR_CODE);
        }else
            exit(diskList_pf(array_id,lcount));
            
    default:
        outUsages(optionCase);
        exit(FCSAN_ERROR_CODE);
    }
    return 0;
}
