/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;

import com.nec.sydney.framework.*;
import com.nec.sydney.beans.base.*;
import com.nec.nsgui.model.biz.base.NSProcess;
import java.util.*;
import java.io.*;

/**
*
*  Reversion History
*  add method "getDiskArrayMonState"
*
*/

public abstract class FcsanAbstractBean extends AbstractJSPBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: FcsanAbstractBean.java,v 1.2308 2006/01/09 09:35:26 wangli Exp $";


       protected Hashtable specialErrMsgHash;
       public String errMsg;
       public int errorCode=NO_ERRORCODE;
   //constructor
    public int getErrorCode()
    {
        return errorCode;
    }
    public void setErrorCode(int errorcode)
    {
        errorCode=errorcode;
    }
   public FcsanAbstractBean()
   {
        specialErrMsgHash = new Hashtable();            
  }
    
   protected abstract void beanProcess() throws Exception;


   public String getErrorMessage(BufferedReader output) throws Exception
   { 
     try{
      boolean flag = true;
      Vector lines = new Vector();
      String firstline = output.readLine();
      while(firstline != null){
         String nextline = firstline;
         lines.add(nextline);         
         firstline = output.readLine(); 
      }  

      int size = lines.size();
      for(int i=size-1; i>=0&&flag; i--){      
          String message = (String)lines.get(i);
          if((message.indexOf("::"))!=-1){
             StringTokenizer token = new StringTokenizer(message,":");
             token.nextToken();
             message = token.nextToken();
             message = message.trim();
             Integer inte = new Integer(message.substring(2,message.length()));
             int num = inte.intValue();
             if(num>99){
                flag = false;
                errMsg = token.nextToken();
                while(token.hasMoreTokens())
                    errMsg = errMsg+":"+(token.nextToken()).trim();
                for(int n=i+1;n<=size-1;n++){
                    errMsg = errMsg+" "+lines.get(n);
                }
             }
             //get error code
            message=(String)lines.get(i);
            if (message.indexOf(ERROR_CODE)!=-1)
            {
                String e_code=message.substring(message.indexOf("=")+1,message.indexOf(","));
                errorCode=Integer.parseInt(e_code);
            }
          }       
      }//end of for  
     }catch(Exception ex){
       throw ex;
        }
    return errMsg;
   }


   /**
   * The function do the same work as GetDouble(double dvalue, int precision, int mode = 0 ), except that 
   * the first parameter which is the String to convert to Double
   */
    public String GetDouble(String doubleString,int precision) throws Exception{
        return GetDouble(doubleString, precision, 0);
    }

   /**
   * The function do the same work as GetDouble(double dvalue, int precision, int mode ), except that 
   * the first parameter which is the String to convert to Double
   */
    public String GetDouble(String doubleString,int precision, int mode) throws Exception{
        double dvalue = (new Double(doubleString)).doubleValue();
        return GetDouble(dvalue, precision, mode);
    }

 
   /**
   * The function do the same work as GetDouble(double dvalue, int precision, int mode = 0)
   */
    public String GetDouble(double dvalue,int precision) throws Exception{
        return GetDouble(dvalue, precision, 0);
    }


   /**
   * The function formats a double value as the specified precision; The formated double value is rounded.
   * 
   * @param dvalue    : the double value which need to change 
   *        precision : the specified precision ( the digit number after the point)
   *        mode      : =0, use numeric part "#,##0"
   *                    !=0, not use numeric part but use "#0" 
   * @return the changed double valule string. If the changed double value is equal to 0, then retusn "0".
   */
    public String GetDouble(double dvalue,int precision, int mode) throws Exception {
        if (dvalue == 0){
            return "0";
        }

        /* The DecimalFormat's rounding mode is ROUND_HALF_EVEN; but we expect the rounding mode is 
        *  ROUND_HALF_UP
        *  In the following source code, I added the process to make the rounding mode is ROUND_HALF_UP
        */
        
        //get the non-scientic format double value 
        String doubleString = changeScienticDouble(dvalue);
        //cut the double string at the position precision+1;
        StringTokenizer st = new StringTokenizer(doubleString, ".");
        String stleft = st.nextToken();
        String strright = st.nextToken();
        if (strright.length() > precision){
            strright = strright.substring(0, precision + 1);
        }
        StringBuffer strBuf = new StringBuffer(stleft);
        strBuf.append(".");
        strBuf.append(strright);

        dvalue = (new Double(strBuf.toString())).doubleValue();
        //start to change the double to the specified format
        StringBuffer buf = new StringBuffer("#0."); 
        java.text.DecimalFormat form = new java.text.DecimalFormat();  
        StringBuffer resultBuf ;
       
        /* The DecimalFormat's rounding mode is ROUND_HALF_EVEN; but we expect the rounding mode is 
        *  ROUND_HALF_UP
        *  In the following source code, I added the process to make the rounding mode is ROUND_HALF_UP
        */
        
        for (int i = 0;i <= precision; i++){
            buf.append("0");
        }
        form.applyPattern(buf.toString());
   
        resultBuf = new StringBuffer(form.format(dvalue));
        
        int strLen = resultBuf.length();
        char decideChar;
        int location = (precision == 0 ? strLen -3 : strLen - 2);
        
        decideChar = resultBuf.charAt(location);

        if ( decideChar == '0' || decideChar == '2' || decideChar == '4' 
                || decideChar == '6' || decideChar == '8'){
            if ((resultBuf.charAt(strLen - 1)) == '5'){ //
                decideChar = (char)(decideChar + 1);
                resultBuf.setCharAt(location, decideChar);
                resultBuf.setCharAt(strLen - 1, '4');
            }
        }

        /* To compare the formatted value with 0, get the formatted value 
         * which is not formatted by "#,###". 
         * Reason: If the format is "#,###", the doubleValue() will throws exception         
        */
        strLen = buf.length();
        buf = buf.delete(strLen - 1, strLen);
        form.applyPattern(buf.toString());
        
        String result = form.format( (new Double(resultBuf.toString())).doubleValue() );
        
        if (((new Double(result)).doubleValue()) == 0){
            return "0";
        }

        //If the double vaule is not equal to 0, get the final result.     
        if (mode == 0){    
            buf = (precision != 0 ? new StringBuffer("#,##0.") : new StringBuffer("#,##0"));
        }else{
            buf = (precision != 0 ? new StringBuffer("#0.") : new StringBuffer("#0"));
        }
            
        for (int i = 0;i < precision; i++){
            buf.append("0");
        }
    
        form.applyPattern(buf.toString());
        
        result = form.format( (new Double(resultBuf.toString())).doubleValue() );
        return result;
    }
    
    //This function change the double value with scientic format to with non-scientic format
    private String changeScienticDouble(double dvalue){
        String str = (new Double(dvalue)).toString();        
        StringTokenizer st = new StringTokenizer(str,"E");
        String strleft = st.nextToken();
        if (!st.hasMoreTokens()){
            st = new StringTokenizer(str,"e");
            strleft = st.nextToken();
            if (!st.hasMoreTokens()){
                return str;
            }
        }
        int numAfterE = (new Integer(st.nextToken())).intValue();
        StringTokenizer ptToken = new StringTokenizer(strleft,".");
        String beforePoint = ptToken.nextToken();
        String afterPoint = ptToken.nextToken();
        StringBuffer strbuf = new StringBuffer();
        if (numAfterE> 0){
            strbuf.append(beforePoint);
            int length = afterPoint.length();
            if (length > numAfterE){
                strbuf.append(afterPoint.substring(0,numAfterE));
                strbuf.append(".");
                strbuf.append(afterPoint.substring(numAfterE,length));
            }else{
                strbuf.append(afterPoint);
                for (int j = 0;j < numAfterE - length;j++)
                   strbuf.append("0");
                strbuf.append(".0");
            }
        }else{
           int bpValue = (new Integer(beforePoint)).intValue();
           if (bpValue >= 0){
                strbuf.append("0.");
           }else{
                strbuf.append("-0.");
                beforePoint = (new Integer(bpValue * -1)).toString();
           }
           for (int j = 0; j < numAfterE * (-1) - 1;j++)
               strbuf.append("0");
           strbuf.append(beforePoint);
           strbuf.append(afterPoint);
        }

        String result = strbuf.toString();
        return result;

    }

    public String getErrMsg()
    {
        return errMsg;
    }
    
    public void setErrMsg(String msg)
    {
        errMsg = msg;
    }
    
    public BufferedReader execCmd(String cmd) throws Exception
      {
         if (cmd == null || cmd.equals(""))
            return null;

        //create the runtime object
        Runtime run=Runtime.getRuntime();
        //execute the linux command
        NSProcess proc = new NSProcess(run.exec(cmd));
        //wait for the process object has terminated
        proc.waitFor();
        InputStreamReader read;
        BufferedReader readbuf;
        if ( proc.exitValue() == 0){
            read = new InputStreamReader(proc.getInputStream());
            readbuf = new BufferedReader(read);            
        }else{
            read = new InputStreamReader(proc.getErrorStream());
            readbuf = new BufferedReader(read);
            errMsg = getErrorMessage(readbuf);
            readbuf = null;
        }
        return readbuf;
    }
    
    public BufferedReader execCmd(String[] cmds) throws Exception
      {
          if (cmds == null || cmds.length == 0)
              return null;
        //create the runtime object
        Runtime run=Runtime.getRuntime();
        //execute the linux command
        NSProcess proc = new NSProcess(run.exec(cmds));
        //wait for the process object has terminated
        proc.waitFor();
        InputStreamReader read;
        BufferedReader readbuf;
        if ( proc.exitValue() == 0){
            read = new InputStreamReader(proc.getInputStream());
            readbuf = new BufferedReader(read);            
        }else{
            read = new InputStreamReader(proc.getErrorStream());
            readbuf = new BufferedReader(read);
            errMsg = getErrorMessage(readbuf);
            readbuf = null;
        }
        return readbuf;
    }
    

    public boolean setSpecialErrMsg()
    {
/*        if (getErrorCode()==FCSANConstants.iSMSM_SVR_NOTREADY)
        {
            setErrMsg(NSMessageDriver.getInstance()
                    .getMessage("fcsan_common/specialmessage/msg_svr_notready"));
            return true;
        }else if (getErrorCode()==FCSANConstants.iSMSM_NOTREADY)
        {
            setErrMsg(NSMessageDriver.getInstance()
                    .getMessage("fcsan_common/specialmessage/msg_notready"));
            return true;
        }else if (getErrorCode()==FCSANConstants.iSMSM_CFG_RUNNING)
        {
            setErrMsg(NSMessageDriver.getInstance()
                    .getMessage("fcsan_common/specialmessage/msg_config"));
            return true;
        }else if (getErrorCode()==FCSANConstants.iSMSM_ENTRY_OVER)
        {
            setErrMsg(NSMessageDriver.getInstance()
                    .getMessage("fcsan_common/specialmessage/msg_entry_over"));
            return true;
        }*/
        specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_SVR_NOTREADY)
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_svr_notready"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_NOTREADY)
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_notready"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_CFG_RUNNING)
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_config"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_ENTRY_OVER) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_entry_over"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_TBL_UPDATE) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_tbl_update"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_SVR_ETC_ERR) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_server_err"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_NOSUPPORT_COMMAND) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_notsupport_err"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_EXIST) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_repeat_err"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_ARG_ERR) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_parameter_err"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_MON_STARTRUN) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_mon_startrun"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_INVALID_ARRAY) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_tbl_update"));
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_NOENTRY) 
                ,NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_tbl_update"));
            
        String errmsg = (String) specialErrMsgHash.get(new Integer(getErrorCode()));
        if (errmsg != null) {
            setErrMsg(errmsg);
            return true;
        }
        return false;
    }
/**
*  This mothod is called when getting monitoring state of diskarray
*  State includes "running", "start demand", "stop" etc
*  @param diskarray id
*  @return monitoring state
*/
    private String diskArrayName = null;

    public String getDiskArrayMonState(String diskarrayid) throws Exception{

        if(diskarrayid == null){
            return null;
        }
        
        String cmd = CMD_DISKLIST_DS + " " + diskarrayid;

        BufferedReader buf = execCmd(cmd);
        if(buf != null){
            buf.readLine();//skip diskarray id
            //get diskarray name
            StringTokenizer st = new StringTokenizer(buf.readLine(),":");
            if(st.countTokens()==2) {
            	st.nextToken();
            	diskArrayName = st.nextToken().trim();
            	buf.readLine();//skip diskarray type
            	buf.readLine();//skip diskarray state
            	st = new StringTokenizer(buf.readLine(),":");
            	st.nextToken();
            	return st.nextToken().trim();
            }else {
            	diskArrayName = "";
            	return "";
            }
        }
        return null;
     }

     public String getDiskArrayName(String diskarrayid) throws Exception{
        if (diskArrayName == null) {
            getDiskArrayMonState(diskarrayid);
        }
        return diskArrayName;
     }
    

    public BufferedReader execiSMCmd(String cmds) throws Exception {
        if (cmds == null)
            return null;
            
        StringTokenizer token = new StringTokenizer (cmds);
        int tokenCnt = token.countTokens();
        String[] cmdarray = new String[tokenCnt];
        int i = 0;
        while (token.hasMoreTokens()){
            cmdarray[i] = token.nextToken();
            i++;
        }
 
        return execiSMCmd(cmdarray);
        
    }

     
      public BufferedReader execiSMCmd(String[] cmds) throws Exception
      {
          if (cmds == null || cmds.length == 0)
              return null;
              
        //create the runtime object
        Runtime run=Runtime.getRuntime();
        
        //execute the linux command
        NSProcess proc = new NSProcess(run.exec(cmds));
        
        //wait for the process object has terminated
        proc.waitFor();
        InputStreamReader read = new InputStreamReader(proc.getInputStream());
        BufferedReader readbuf = new BufferedReader(read);;
        
        errorCode = proc.exitValue();
        if ( errorCode != 0){
            StringBuffer buf = new StringBuffer();
            String line;

            buf.append(readbuf.readLine());
            line = readbuf.readLine();
            while (line != null){
                buf.append("<br>");
                buf.append(line);
                line = readbuf.readLine();
            }
            errMsg = buf.toString();
            readbuf = null;
        }
        return readbuf;
    }


    public String decideLVExist(String ldn) throws Exception {
        String diskarrayid = request.getParameter("diskarrayid");
        String ret = null;

        if (diskarrayid == null || ldn == null ) {
            throw new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        }

        ret = execLDUsed(diskarrayid, ldn);

        if (ret == null){
            setErrMsg(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/alert_neterror"));
        }
        
        return ret;        
    }
    
    private String execLDUsed(String aid, String ldn) throws Exception {
        String[] ldns;
        String returnLine;
        String ret;
        int i;

        HashSet ac = new HashSet();
        ldns = ldn.split(",");
        Runtime run=Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(CMD_LD_USED));
        proc.waitFor();
        InputStreamReader read;
        BufferedReader readbuf;
        if ( proc.exitValue() == 0){
            read = new InputStreamReader(proc.getInputStream());
            readbuf = new BufferedReader(read);            
        }else{
            return null;
        }
        
        if ((returnLine = readbuf.readLine()) == null || returnLine.trim().equals("")) {
            return "";
        }
        
        while ( returnLine != null) {
            String retAid    = (returnLine.split(":"))[0].trim();
            String retLun    = (returnLine.split(":"))[1].trim();
            String retVgname = (returnLine.split(":"))[2].trim();
            if (retAid.equals(aid)){
                for ( i=0; i<ldns.length; i++) {
                    if (Integer.parseInt(retLun) == Integer.parseInt(ldns[i].substring(0,4),16)){
                        ac.add(retVgname);
                        break;
                    }
                }
            }
            returnLine = readbuf.readLine();
        }
        if(ac.size()==0){
            return "";
        }
        Iterator iter = ac.iterator();
        ret = (String)iter.next();
  
        for( i= 0 ;i<2&&iter.hasNext();i++) {
            ret += "," + (String)iter.next();
        }
        return iter.hasNext()? ret + "..." : ret;
    }
    
    public String getPDGByPoolCLI(String aid, String poolNo)throws Exception{
        String PDG = "";        
        String cmd=CMD_DISKLIST_POOLP+" "+aid+" "+"-pno"+" "+poolNo;
        BufferedReader buf=execCmd(cmd);
        
        if(buf!=null){
            String resultOneLine=buf.readLine();
            while (resultOneLine!=null){
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
                resultOneLine=buf.readLine();
            }
            resultOneLine=buf.readLine();
            while(resultOneLine!=null){
                if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME))){
                    StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                    PDG = resultValue.nextToken().substring(0,2);
                    break;
                }
                resultOneLine=buf.readLine();
            }
        }
        return PDG;   
    }
    
    public String getPDGByPool(String aid, String poolNo)throws Exception{
        String PDG = "";
        List poolList = (List)session.getAttribute(SESSION_RANK_LIST);
        if (poolList!=null && poolList.size() !=0){
            for(int i = 0; i < poolList.size(); i++){
                DiskArrayRankInfo info = (DiskArrayRankInfo)poolList.get(i);
                if(info.getPoolNo().equals(poolNo)){
                    PDG = info.getPDG();
                }
            }
        }
        if (PDG.equals("")){
            return getPDGByPoolCLI(aid, poolNo);
        }else{
            return PDG;
        }
    }
    
    public boolean isFirstArray(String aid)throws Exception{
        String cmd = CMD_ISFIRST_ARY + " " + aid;
        BufferedReader buf = execCmd(cmd);
        if(buf != null){
            String result = buf.readLine();
            if (result != null && result.equals("false")){
                return false;
            }else{
                return true;
            }
        }
        return true;
    }
    
    public String getWWNNByAid(String aid)throws Exception{
        String WWNN = "";
        String cmd = CMD_DISKLIST_DS + " " + aid;
        BufferedReader buf = execCmd(cmd);
        if(buf != null){
            String resultOneLine = buf.readLine();
            while (resultOneLine != null){
                String ret[] = resultOneLine.split(":");
                if (ret.length == 2 && ret[0].trim().equals("WWNN")){
                    WWNN = ret[1].trim();
                    break;
                }
                resultOneLine = buf.readLine();
            }                        
        }
        return WWNN;
    }
}

    