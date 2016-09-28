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

public class PortNameSetBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: PortNameSetBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


   private int result;

   //constructor
   public PortNameSetBean()
   {
      result=0;
   }

   //beanProcess execute command "iSAsetnaem -sp -aid(diskarrayID) -port(portNo) -name(portName)
   public void beanProcess() throws Exception
   {
     String diskid = request.getParameter("id");
     String portno = request.getParameter("port");
     String name = request.getParameter("portname");
     if(diskid == null||diskid.equals("")
            ||portno == null||portno.equals("")
            ||name == null||name.equals("")){
        NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        throw ex;
     }
     specialErrMsgHash.put((new Integer(iSMSM_NOCHANGE))
            ,NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/err_same_name"));
     String cmd = CMD_DISKSETNAME_SP+" "+diskid+" "+"-port"+" "+portno+" "+"-name"+" "+name;  
     BufferedReader readbuf = execCmd(cmd);
     if(readbuf==null){
            result = 1;
     }
   }

   public int getResult()
   {
       return result;
   }
}