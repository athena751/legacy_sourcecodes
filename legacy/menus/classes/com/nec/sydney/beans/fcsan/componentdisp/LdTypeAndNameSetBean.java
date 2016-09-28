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

public class LdTypeAndNameSetBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: LdTypeAndNameSetBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";
    private int result;

   //constructor
   public LdTypeAndNameSetBean()
   {
      result=0;
   }

   //beanProcess execute command "iSAsetnaem -sl -aid(diskarrayID) -ld(ldNo) -ldtype(ldType) -name(ldName)
   public void beanProcess() throws Exception
   {
     //String home = System.getProperty("user.home");
     String diskid = request.getParameter("diskid");
     String ldID = request.getParameter("ldID");
     String ldName = request.getParameter("name");
     String ldType = request.getParameter("type");
     if(diskid == null || diskid.equals("") || ldID == null || ldID.equals("")
            || ldName == null || ldName.equals("") || ldType == null || ldType.equals("")){
        NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        throw ex;
     }
     specialErrMsgHash.put((new Integer(iSMSM_NOCHANGE))
            ,NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/err_same_name"));
     String cmd = CMD_DISKSETNAME_SL+" "+diskid+" "+"-ld"+" "+ldID+" "+"-ldtype"+" "+ldType+" "+"-name"+" "+ldName;     
     BufferedReader buf=execCmd(cmd);
     if(buf==null) {
        result = 1;
     }
   }

   public int getResult()
   {
       return result;
   }
}