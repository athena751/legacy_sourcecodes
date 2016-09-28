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
import java.util.*;
import java.io.*;

public class EnclosureListBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: EnclosureListBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


   private Vector enclosures;
   private int result;

   //constructor
   public EnclosureListBean()
   {
        result = 0;
   }

   //beanProcess execute command "iSAdisklist -e -aid(diskarrayID)
   public void beanProcess() throws Exception
   {
     //String home = System.getProperty("user.home");
     String diskid = request.getParameter("diskArrayID");
     if(diskid == null||diskid.equals("")){
     NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
     throw ex;
     }
     String cmd = CMD_DISKLIST_E+" "+diskid; 
     BufferedReader readbuf = execCmd(cmd);
     if(readbuf==null){
       result = 1;
     }else{
       result = 0;
       String line = readbuf.readLine();
       while(!line.startsWith(SEPARATED_LINE)){
           line = readbuf.readLine();
       }
       line = readbuf.readLine();
       enclosures = new Vector();
       while(line != null){
           StringTokenizer token = new StringTokenizer(line);
           DiskArrayDeInfo deinfo = new DiskArrayDeInfo(); 
           if(token.countTokens()==4){
              token.nextToken();
              String ctlname = token.nextToken();
              deinfo.setCtlName(ctlname);
              deinfo.setType(NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+ctlname));
              deinfo.setCtlNo(token.nextToken());
              deinfo.setState(token.nextToken());
              enclosures.add(deinfo);
           }
 
           line = readbuf.readLine();  
       }                  
      }//end of else
   }

   public Vector getEnclosures()
   {
       return enclosures;
   }
    
   public int getResult()
   {
        return result;
   }
}
   