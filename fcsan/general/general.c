/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

#if defined(nec_ews_svr4) || defined(_nec_ews_svr4)
#ident "@(#) $Id: general.c,v 1.2304 2007/05/10 04:54:00 xingyh Exp $"
#else
#if !defined(lint)
static char *cvsid = "@(#) $Id: general.c,v 1.2304 2007/05/10 04:54:00 xingyh Exp $";
#endif
#endif

#include "stdlib.h"
#include "string.h"
#include "ctype.h"
#include "iSMSMApi.h"
#include "iSMSMerr.h"
#include "general.h"
#include "errno.h"

//added by liyb 20050901 , used to convert pool capacity
int Char8ToInt64(char * char8, unsigned long long *ullRslt)
{
/*
   char * endptr=NULL;
   if(!ullRslt ||!char8)   return 1;   

   char hexchar16[17];  // convert char8[i] to hex ,which will be put into hexchar16[2i],hexchar16[2i+1]  liyb  20050901
   int i=0;
   for(i=0;i<8;i++){
	  sprintf(hexchar16+i*2,"%02x",char8[i]);	  
  }
   
  hexchar16[16]='\0';
  *ullRslt=strtoull(hexchar16,&endptr,16);
*/

char char8tmp1[8];
char char8tmp2[8];
int i;
//int sgmrm_endian64_n=1;
memset(char8tmp1 ,0,8);
memset(char8tmp2 ,0,8);
memcpy(char8tmp1, char8, 8);
for(i=0; i<8; i++){
char8tmp2[i] =char8tmp1[7-i];
}
memcpy(ullRslt, char8tmp2, 8);
  //memcpy(ullRslt, char8, 8);
  return 0;
  }


int convert_arrayid(char * id , unsigned char * array_id)                                           
{                                                                                                   
                                                                                                
    char *endptr=NULL;  
    unsigned long convertResult;                                                                
    if ( ! id )                                                                                 
    {                                                                                           
        return 1; /* array id is null,return false */                                       
    }                                                                                           
                                                                                                
    if (strlen(id)!=4 || *id=='-' || *id=='+' )                                                 
    {                                                                                           
        return 1; /* length of array id not correct or "id" begins with "-" or "+" */       
    }                                                                                           
    convertResult=strtoul(id,&endptr,10); 
    if ( *endptr!='\0' ) /* "id" includes non-digital char */                                    
    {                                                                                           
        return 1;                                                                           
    }                                                                                           
                                                                                                
    if (convertResult>255)
    {
        return 1;
    }
    *array_id=(unsigned char)convertResult ;                                                    
    return 0;                                                                                   
                                                                                                    
} /* end of "convert_arrayid" */      
int hex_char_unchar(char * source, unsigned char * destine)                                           
{                                                                                                   
    char *endptr=NULL;  
    unsigned long convertResult;                                                                
    if ( !source)                                                                                 
    {                                                                                           
        return 1; /* sourceis null,return false */                                       
    }                                                                                           
                                                                                                
    if (strlen(source)!=3 || *source=='-' || *source=='+'|| tolower(*(source+2))!='h' )                                                 
    {                                                                                           
        return 1; /* length of array source not correct or "source" begins with "-" or "+" */       
    }                                                                                           
    convertResult=strtoul(source,&endptr,16); 
    if (strlen(endptr)!=1)                                    
    {                                                                                           
        return 1;                                                                           
    }                                                                                           
    *destine=(unsigned char)convertResult ;                                                    
    return 0;                                                                                                 
                                                                                                    
} /* end of "convert char to unsigned char" (hex) */  

int address_char_unlong(char * source, unsigned long * destine)                                           
{                                                                                                   
    char *endptr=NULL;  
    unsigned long convertResult;                                                                
    if ( !source)                                                                                 
    {                                                                                           
        return 1; /* source is null,return false */                                       
    }                                                                                           
                                                                                                
    if (strlen(source)!=10 || *source=='-' || *source=='+'|| *source!='0'||tolower(*(source+1))!='x' )                                                 
    {                                                                                           
        return 1; /* length of array sourcenot correct or "source" begins with "-" or "+" */       
    }                                                                                            
    convertResult=strtoul(source,&endptr,16); 
    if ( *endptr!='\0' ) /* "source" includes non-digital char */                                    
    {                                                                                           
        return 1;                                                                           
    }                                                                                       
    *destine=convertResult ;                                                    
    return 0;                                                                                                 
                                                                                                    
} /* end of "convert char to unsigned long" (dec) */  
/* v5.1 add by xingyh */
int compute_size_block(double ld_size,int is_syscapa,unsigned long long * dest_full,unsigned long * dest_high, unsigned long * dest_low)
{
    unsigned long long  size_in_block;

    /* compute the block number from the size */
    size_in_block = ld_size*1024+0.9; /* change Gbyte to Mbyte and get larger integer*/
    if(is_syscapa==1){ 
	 	size_in_block+=2; /* system capacity use 2M */
    }
    size_in_block = size_in_block*2*1024;
    
    *dest_low = size_in_block & BIT_MASK;
    *dest_high  = (size_in_block >> FOUR_BYTE) & BIT_MASK;
    *dest_full= size_in_block;
    return 0;
}
/* change the string to two unsigned long high byte and low byte */
int address_char_unlonglong(const char * source, unsigned long long * dest_full,unsigned long * dest_high, unsigned long * dest_low)                            
{
    unsigned long long num_long; 
    char *endptr = NULL;
    
    if (!source){
        return 1; /* source is null,return false */
    }
    /* check the source string if like "0x"+ 16bitnumbers */
    if (strlen(source)!=(HEX+2) || *source=='-' || *source=='+'|| *source!='0'||tolower(*(source+1))!='x' ){ 
        return 1; /* length of array sourcenot correct or "source" begins with "-" or "+" */
    }
    num_long = strtoull(source,&endptr,16);
    if ( *endptr!='\0' ){ /* "source" includes non-digital char */
        return 1;
    }
    *dest_full = num_long;
    *dest_low = num_long & BIT_MASK;
    *dest_high = (num_long >> FOUR_BYTE) & BIT_MASK;
     return 0;
} /* end of "convert char to two unigned long" (dec) */
/* v5.1 xingyh added end here */

int dec_char_unchar(char * source, unsigned char * destine)                                           
{                                                                                                   
    char *endptr=NULL;  
    unsigned long convertResult;                                                                
    if ( !source)                                                                                 
    {                                                                                           
        return 1; /* source is null,return false */                                       
    }                                                                                           
                                                                                                
    if ( *source=='-' || *source=='+' )                                                 
    {                                                                                           
        return 1; /* length of array sourcenot correct or "source" begins with "-" or "+" */       
    }                                                                                                    
    convertResult=strtoul(source,&endptr,10); 
    if ( *endptr!='\0' ) /* "source" includes non-digital char */                                    
    {                                                                                           
        return 1;                                                                           
    }
    if(convertResult > 255)   
    {                                                                                           
        return 1;                                                                           
    }                                                                                             
    *destine=(unsigned char)convertResult ;                                                    
    return 0;                                                                                                 
                                                                                                    
} /* end of "convert char to unsigned long" (dec) */  

int dec_char_unlong(char * source, unsigned long * destine)                                           
{                                                                                                   
    char *endptr=NULL;  
    unsigned long convertResult;                                                                
    if ( !source)                                                                                 
    {                                                                                           
        return 1; /* source is null,return false */                                       
    }                                                                                           
                                                                                                
    if ( *source=='-' || *source=='+')                                                 
    {                                                                                           
        return 1; /* length of array sourcenot correct or "source" begins with "-" or "+" */       
    }                                                                                           
    convertResult=strtoul(source,&endptr,10); 
    //if (convertResult>4294967294||errno==ERANGE)
    if (errno==ERANGE)
    {
        return 1;
    }
    if ( *endptr!='\0' ) /* "source" includes non-digital char */                                    
    {                                                                                           
        return 1;                                                                           
    }                                                                                           
    *destine=convertResult ;                                                    
    return 0;                                                                                                 
                                                                                                    
} /* end of "convert char to unsigned long" (dec) */  

int dec_char_double(char * source, double * destine)                                           
{                                                                                                   
    char *endptr=NULL;  
    double convertResult;
    int i;
    if ( !source)                                                                         
    {                                                                                           
        return 1; /* source is null,return false */
    }                                                                                           
                                                                                                
    if ( *source=='-' || *source=='+')                                                 
    {                                                                                           
        return 1; /* length of array sourcenot correct or "source" begins with "-" or "+" */       
    }                                                                                           
    for(i=0;*(source+i)!='\0';i++){
        if(!isdigit(*(source+i)))
            return 1;
    }
    convertResult=strtod(source,&endptr);
    if(convertResult>512*(double)(0xffffffff)){
        return 1;
    }
    if (errno==ERANGE)
    {
        return 1;
    }
    if ( *endptr!='\0' ) /* "source" includes non-digital char */                                    
    {                                                                                           
        return 1;                                                                           
    }                                                                                           
    *destine=convertResult ;                                                    
    return 0;                                                                                                 
                                                                                                    
} /* end of "convert char to unsigned long" (dec) */  


int convert_ldset_no(char * id , unsigned short * ldset_no)                                           
{                                                                                                   
                                                                                                
    char *endptr=NULL;  
    unsigned long convertResult;                                                                
    if ( ! id )                                                                                 
    {                                                                                           
        return 1; /* array id is null,return false */                                       
    }                                                                                           
                                                                                                
    if (strlen(id)!=5 || *id=='-' || *id=='+' )                                                 
    {                                                                                           
        return 1; /* length of array id not correct or "id" begins with "-" or "+" */       
    }                                                                                           
    convertResult=strtoul(id,&endptr,10); 
    if ( *endptr!='\0' ) /* "id" includes non-digital char */                                    
    {                                                                                           
        return 1;                                                                           
    }                                                                                           
                                                                                                
    if (convertResult>65535)
    {
        return 1;
    }
    *ldset_no=(unsigned char)convertResult ;                                                    
    return 0;                                                                                   
                                                                                                    
} /* end of "convert_ldset_no" */                                                          
                                                                                                    
int convert_ldno(char * ld_no , unsigned short * ld_num)                                            
{  
//added by liyb 20050905
  return  hex4toushort(ld_no, ld_num);
                                                                          
} /* end of "convert_ldno" */                                                                       



// change pool_no from char*(0000h-ffffh) to unsigned short             added by liyb 20050829
int hex4toushort(char * source , unsigned short * dest)
{

    unsigned long convertResult ;
    char * endptr=NULL;
    if ( ! source)
    {
        return 1; /* pool_no is NULL */
    }

    if (strlen(source)!=5 || *source=='+' || *source=='-' || tolower(*(source+4))!='h')                                      
    {
        return 1; /* pool_no is invalid */
    }

    convertResult=strtoul(source,&endptr,16);
    if (strlen(endptr)==1)
    {
        *dest=(unsigned short)convertResult;
        return 0;     /* conversion succeeded */
    }

    return 1; /* pool_no is invalid */

} /* end of hex4toushort*/
int hex4toint(char * source , int * dest)                                            
{                                                                                                   
                                                                                                    
    unsigned long convertResult ;                                                               
    char * endptr=NULL;                                                                        
    if ( ! source)                                                                               
    {                                                                                           
        return 1; /* ld_no is NULL */                                                       
    }                                                                                           
                                                                                                    
    if (strlen(source)!=5 || *source=='+' || *source=='-' || tolower(*(source+4))!='h')                                         
    {                                                                                           
        return 1; /* ld_no is invalid */                                                                          
    }                                                                                           
                                                                                                
    convertResult=strtoul(source,&endptr,16); 
    if (strlen(endptr)==1)                
    {                                                                                           
        *dest=(int)convertResult;                                              
        return 0;     /* conversion succeeded */                                                                      
    }                                                                                           
                                                                                                
    return 1; /* ld_no is invalid */
                                                                                                
} /* end of "hex4toint" */                                                                       
                                                                                                    
int convert_port_rank_no(char * port_rank_no,unsigned char *dir_num,unsigned char *port_rank_num)                    
{                                                                                                   
                                                                                                
    unsigned long convertResult_dir , convertResult_port_rank ;                                      
    char * endptr_dir=NULL , * endptr_port_rank=NULL;                                              
    char * dir=NULL , *port_rank=NULL ; 
    
    if ( !port_rank_no || strlen(port_rank_no)!=7 || *(port_rank_no+3)!='-' ||
         tolower(*(port_rank_no+2))!='h' || tolower(*(port_rank_no+6))!='h' ||
         *port_rank_no=='+' || *port_rank_no=='-' || *(port_rank_no+4)=='+' ||
         *(port_rank_no+4)=='-') 
    {                                                                                           
        return 1;                                                                           
    }          
                                                                                         
    dir=port_rank_no ;                                                                                
    port_rank=dir+4;                                                                          
    *(dir+3)='\0';                                                                            
                                                                                                
    convertResult_dir=strtoul(dir,&endptr_dir,16);                                               
    convertResult_port_rank=strtoul(port_rank,&endptr_port_rank,16);                                            
                                                                                                    
    if (strlen(endptr_dir)==1 && strlen(endptr_port_rank)==1) 
    {                                                                                           
        *dir_num=(unsigned char)convertResult_dir;                                          
        *port_rank_num=(unsigned char)convertResult_port_rank;                                        
        return 0;  /* conversion succeeded */                                                                   
    }                                                                                           
    *(dir+3)='-'; /* undo *(dir+3)='\0' */
    return 1;                                                                                   
                                                                                                
} /* end of "convert_port_rank_no" */       

int convert_lcount(char* str, unsigned int* lcount)
{
    int i,value;
    char * endptr = NULL;

    if (!str)
        return -1;

    if ((value = strtol(str, &endptr, 10)) <= 0)
        return -1;
    else if (*endptr != '\0')
        return -1;
    else
        *lcount = (unsigned int)value;
   
    return 0;
}                        

int chars2str(char * charArray , int length, char * str)
{
    int pointer=0;
    int isEmptyCharArray=1;
    if (!charArray || !str || length<2)
        return 1;
    while (pointer<length && charArray[pointer]) 
    {
        if (!isblank(charArray[pointer]))
            isEmptyCharArray=0;
        str[pointer]=charArray[pointer];
        pointer++;
    }
    while (pointer<length)
        str[pointer++]=0x20;
    if (isEmptyCharArray)
        str[0]=str[1]='-';
    str[length]=0;
    return 0;
} /* end of "chars2str" */


void print_condition_code(iSMSMoutDataInfo o_inf)
{
    int i;
    printf("%s::%s=",CMDNAME_ISADISKLIST,CONDITION_CODE_LABEL);
    if (o_inf.watch_state==WATCH_STATE_MONITOR_OFF ||
        o_inf.watch_state==WATCH_STATE_MONITOR_OFF_ERROR ||
        o_inf.watch_state==WATCH_STATE_MONITOR_OFF_SEIZE)
    {
        printf("%s\n",CONDITION_CODE_STOPPED);
        return ;
    }
    printf("%1x%1x%1x%1x%1x%1x%1x%1x%1x",o_inf.recon_flg,o_inf.array_flg,
        o_inf.ld_flg,o_inf.pd_flg,o_inf.pool_flg,o_inf.dac_flg,
        o_inf.de_flg,o_inf.port_flg,o_inf.ldset_flg);
    for (i=0;i<7;i++)
    {
        printf("%1x",0x00);
    }
    printf("\n");

}

int isInvalidName(char * name , unsigned int required_max_len)
{

    if ( !name || strlen(name)>required_max_len || strlen(name)==0)
    {
        return FCSAN_ERROR_CODE ; /* name is invalid,return a non-zero number */
    }

    while (*name!='\0')
    {
        if ( !isdigit(*name) && !islower(*name) && !isupper(*name) 
            && *name!='/' && *name!='_') 
        {/* Specified name takes in invalid character */
            return FCSAN_ERROR_CODE; /* name is invalid,return a non-zero number */ 
        }
        else
        {
            name++;
        }
    }
    return FCSAN_SUCCESS_CODE ; /* name is valid,return 0 */

} /* end of "isInvalidName" */

int isInvalidLdType(char * ld_type)
{
    if ( !ld_type )
    {
        return FCSAN_ERROR_CODE;
    }
    if (strcmp(ld_type,"A4")!=0 && strcmp(ld_type,"A2")!=0 &&
        strcmp(ld_type,"NX")!=0 && strcmp(ld_type,"WN")!=0 &&
        strcmp(ld_type,"CX")!=0 && strcmp(ld_type,"LX")!=0 &&
        strcmp(ld_type,"AX")!=0)    
    {
        return FCSAN_ERROR_CODE;
    }
    else
    {
        return FCSAN_SUCCESS_CODE;
    }

} /* end of "isInvalidLdType" */

int isInvalidPF(char * platform)
{
    if ( !platform )
    {
        return FCSAN_ERROR_CODE;
    }
    if (strcmp(platform,"A4")!=0 && strcmp(platform,"A2")!=0 &&
        strcmp(platform,"NX")!=0 && strcmp(platform,"WN")!=0 &&
        strcmp(platform,"CX")!=0 && strcmp(platform,"LX")!=0 &&
        strcmp(platform,"DF")!=0 && strcmp(platform,"AX")!=0 &&
        strcmp(platform,"G8")!=0)    
    {
        return FCSAN_ERROR_CODE;
    }
    else
    {
        return FCSAN_SUCCESS_CODE;
    }

} /* end of "isInvalidLdType" */

int strtrim(char* source)
{
   int length;
   int index=-1,i,j;

   if (!source)
    return 1;
   length=strlen(source);
   for (i = 0;i<length;i++)
   {
        if (source[i]>32 && source[i]<127)
                break;
   }
   length = length-i;
   for (j=0;j<length;j++,i++){
        source[j]=source[i];
        if ((source[i]<=32 || source[i]==127)) {
            if (index < 0){
                index = j;
            }
        }else
                index = -1;
   }
   if (index < 0)
      source[j]='\0';
   else
      source[index]='\0';
   return 0;
}


int start_iSMSMCfg(char * arr_name, char * cmd_name, int fun_no, int error_no, iSMSMCfg_APIinfo_t * api_info, int restart,int nounlock,int force){
    int result;
    iSMSMConfigStart start_info;

    result = iSMSMCfgConnect(api_info);
    if (result!=iSMSM_NORMAL)
    {
        fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",cmd_name,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            fun_no,error_no,1);        
        return FCSAN_ERROR_CODE; 
    }
    iSMSM_INIT_CFGSTARTINFO(start_info);
    strncpy(start_info.arrayname,arr_name,strlen(arr_name));
    if(force == 1)
    {
        start_info.force= iSMSMCFG_FORCED_START;
        result= iSMSMCfgForcedStart(api_info, start_info);
    }else
    {
        start_info.force = iSMSMCFG_NORMAL_START;
        result= iSMSMCfgStart(api_info, start_info);
    }
    if (result!=iSMSM_NORMAL)
    {    
        fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",cmd_name,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            fun_no,error_no+1,1);    
        stop_iSMSMCfg_exception(cmd_name,fun_no,error_no,api_info, nounlock, restart);
        return FCSAN_ERROR_CODE;
    }
    return FCSAN_SUCCESS_CODE;
}

int stop_iSMSMCfg(char * cmd_name, int fun_no, int error_no, iSMSMCfg_APIinfo_t* api_info, int nounlock, int restart){
    int result;
    iSMSMConfigStop stop_info;
    if (nounlock == 0)
    {
        iSMSM_INIT_CFGSTOPINFO(stop_info);

        if (restart == 1)
        {
            stop_info.restart= iSMSMCFG_MONITORING_RESTART;
        }
        else
        {
         stop_info.restart= iSMSMCFG_MONITORING_STOP;
        }

        result = iSMSMCfgStop(api_info,stop_info);
        if (result!=iSMSM_NORMAL)
        {
            fflush(stdout);
            fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",cmd_name,MSGNO_FCSAN_PREFIX,
                MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
                fun_no,error_no,1);        
            iSMSMCfgClose(api_info);//by mail 3157
            return FCSAN_ERROR_CODE; 
        }
    }

    result = iSMSMCfgClose(api_info);
    if (result!=iSMSM_NORMAL)
    {
        fflush(stdout);
        fprintf(stderr,"%s::%02u%03u:%s(%s=%d,%s=%02u%02u%04u)\n",cmd_name,MSGNO_FCSAN_PREFIX,
            MSGNO_ERROR_OCCURRED,COMMAND_PROCESS_ERR_INFO,ERROR_CODE_LABEL,result,COMMAND_CODE_LABEL,
            fun_no,error_no+1,1);        
        return FCSAN_ERROR_CODE;
    }
    return FCSAN_SUCCESS_CODE;
}

//add by keyan 2002-06-05

int stop_iSMSMCfg_exception(char * cmd_name, int fun_no, int error_no, iSMSMCfg_APIinfo_t* api_info, int nounlock, int restart){
    int result;
    iSMSMConfigStop stop_info;
    if (nounlock == 0)
    {
        iSMSM_INIT_CFGSTOPINFO(stop_info);

        if (restart == 1)
        {
            stop_info.restart= iSMSMCFG_MONITORING_RESTART;
        }
        else
        {
         stop_info.restart= iSMSMCFG_MONITORING_STOP;
        }

        iSMSMCfgStop(api_info,stop_info);
        
    }

    iSMSMCfgClose(api_info);
    
    return FCSAN_SUCCESS_CODE;
}


int isInvalidTypeName(char * text , unsigned int type_max_len , unsigned int name_max_len)
{ /* valid text pattern: "type:name"    */
    char * pos_of_colon=NULL ;
    
    if (!text || strlen(text)<=1)
        return 1;
    if ( ! (pos_of_colon=strchr(text,':')) )
        return 1; /* no colon has been found .*/
    *pos_of_colon=0; /* split string */
    if (strlen(text)>type_max_len) /* check type */
        return 1; 
    *pos_of_colon=':';
    return isInvalidName(pos_of_colon+1,name_max_len);
    
} /* end of isInvalidTypeName() */

int convert_oid(char *str, unsigned short *oid)
{
    int i,value;
    char * endptr = NULL;

    if (!str)
        return -1;

    if (strlen(str)!=4 || *str=='-' || *str=='+' )                                                 
    {                                                                                           
        return 1; /* length of array id not correct or "id" begins with "-" or "+" */       
    }                                                                                           

    value = strtoul(str, &endptr, 10);
    if (*endptr != '\0')
        return -1;
    if (value>65535)
    {
        return -1;
    }
    
    *oid = (unsigned short)value;
   
    return 0;
}

int getCutString(float f, char* result)
{
    int i = 0;
    int len;
    sprintf(result,"%f",f);
    len = strlen(result);
    while (result[i] != '\0'){
        if (result[i] == '.'){
            result[i+2] = '\0';
        }
        i++;
    }
    if (i >= len)
        return -1;
    return 0;
}
