/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentdisp;

import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import java.io.*;

public class DiskArrayNameSetBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: DiskArrayNameSetBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


   private int result;
   private String errorMessage;

   //constructor
   public DiskArrayNameSetBean()
   {
      result=0;
      errorMessage=new String();
   }

   //beanProcess execute command "iSAsetname -sa -aid(diskarrayID) -name(diskName)
   public void beanProcess() throws Exception
   {
     //String home = System.getProperty("user.home");
     String diskid = request.getParameter("diskid");
     String diskname = request.getParameter("diskname");
     if ( diskid == null || diskid.equals("") || diskname == null || diskname.equals("")){
     NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
     throw ex;
     }
     
//     try{
     //String cmd = home+CMD_DISKSETNAME_SA+" "+diskid+" "+"-name"+" "+diskname;
     specialErrMsgHash.put((new Integer(iSMSM_NOCHANGE))
            ,NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/err_same_name"));
     String cmd = CMD_DISKSETNAME_SA+" "+diskid+" "+"-name"+" "+diskname;       
     BufferedReader readbuf = execCmd(cmd);
     if(readbuf==null){
        result = 1;
     }

/*delete by caoyh 2002-9-27
     Runtime run = Runtime.getRuntime();
     Process proc = run.exec(cmd);
     proc.waitFor();

     result = proc.exitValue();
     if(result != FCSAN_SUCCESS){
       InputStreamReader read=new InputStreamReader(proc.getErrorStream());
       BufferedReader readbuf=new BufferedReader(read);
       errorMessage=getErrorMessage(readbuf);
     }
 */
//     }catch(Exception ex){
//      throw ex;
//      }
   }

   public int getResult()
   {
       return result;
   }

   public String getErrorMessage()
   {

       return errorMessage;
   }
}