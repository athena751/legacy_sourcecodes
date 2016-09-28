/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans. fcsan.statemon;
import java.io.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
public class DiskArrayMonitorBean extends FcsanAbstractBean implements FCSANConstants 
{

    private static final String     cvsid = "@(#) $Id: DiskArrayMonitorBean.java,v 1.2301 2005/08/29 08:51:01 huj Exp $";

    private boolean result;
    //private String errorMsg;
    public DiskArrayMonitorBean(){
        result = true;
    }
    public boolean isSuccess(){
        return result;
    }
    public void beanProcess() throws Exception{
        String action=request.getParameter("behave");
        String diskarrayid=request.getParameter("diskid");
        BufferedReader readbuf = null;
        if (action!=null&&action.startsWith("start")) {
            if (diskarrayid == null || diskarrayid == "" ) {
                throw new Exception(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
                
            }
            readbuf = super.execCmd(CMD_DISKSETMON_START+" "+diskarrayid);
            if (readbuf == null){
                 result= false;
                 setSpecialErrMsg();
                // errorMsg = super.getErrorMessage(readbuf);
                 //read.close();
                 setErrorMessage();
                // return;
            } else {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
            }
            if (!result){
                    super.response.sendRedirect(super.response.encodeRedirectURL("diskarraywatchbottom.jsp"));
            }
        } else if (action!=null&&action.startsWith("stop")) {
            if (diskarrayid == null || diskarrayid == "" ) {
                throw new Exception(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
                
            }
            readbuf = super.execCmd(CMD_DISKSETMON_STOP+" "+diskarrayid);
            if (readbuf == null){
                //errorMsg=super.getErrorMessage(readbuf);
                result = false;
                setSpecialErrMsg();
                //read.close();
                setErrorMessage();
                //return;
            } else {
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
            }
            if(!result){  
                super.response.sendRedirect(super.response.encodeRedirectURL("diskarraywatchbottom.jsp"));
            }

         }else if (action!=null&&action.startsWith("fstop")){
             if (diskarrayid == null || diskarrayid == "" ) {
                throw new Exception(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
                
                }
               readbuf = super.execCmd(CMD_DISKSETMON_FSTOP+" "+diskarrayid);
               if (readbuf == null){
                   result = false;
                   setSpecialErrMsg();
                     //read.close();
                   setErrorMessage();
                   //return;
                }else{
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
                }
                if(!result){
                    super.response.sendRedirect(super.response.encodeRedirectURL("diskarraywatchbottom.jsp"));
                }
         }
        
    }
    private void setErrorMessage()
    {
        if (errorCode ==-7||errorCode == -8||errorCode == -9||errorCode == -20||errorCode == -21||errorCode == -22){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                         +"\\r\\n"
                         +NSMessageDriver.getInstance().getMessage(session,"fcsan_statemon/alert/curr_state_wrong"));
            return;
        }    
        super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")
                          +"\\r\\n"+errMsg.replaceAll("<br>|<bR>|<BR>|<Br>","\\\\r\\\\n"));
        return;
    }
    public String getErrorMsg()
    {
        return errMsg;
    }
}
