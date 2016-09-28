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

public class DiskArrayPortGetBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: DiskArrayPortGetBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


   private Vector port;
   private int result;

   //constructor
   public DiskArrayPortGetBean()
   {
    result = 0;
   }

   //beanProcess execute command "iSAdisklist -dap -aid(diskarrayID)
   public void beanProcess() throws Exception
   {
     String diskid = request.getParameter("diskid");
     if(diskid == null||diskid.equals("")){
     NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
     throw ex;
     }
          
     try{
     String cmd = CMD_DISKLIST_DAP+" "+diskid; 
     BufferedReader readbuf = execCmd(cmd);
     if(readbuf==null){
            result = 1;
     }else{
       port = new Vector();
       result = 0;
       String line = readbuf.readLine();
       while(!line.startsWith(SEPARATED_LINE)){
          line = readbuf.readLine();
       }
       line = readbuf.readLine();
       while(line !=null){
          StringTokenizer token = new StringTokenizer(line);
          if(token.countTokens()==5){
            DiskArrayPortInfo portinfo = new DiskArrayPortInfo();
            portinfo.setPortNo(token.nextToken().trim());
            portinfo.setName(token.nextToken().trim());
            portinfo.setMode(token.nextToken().trim());
            port.add(portinfo);
          }
          line = readbuf.readLine();  
        }
        if (port.size() == 0) {
            setErrorCode(71);
            specialErrMsgHash.put(new Integer(71), NSMessageDriver.getInstance()
            		.getMessage(session,"fcsan_common/specialmessage/msg_disk_err_popup"));
            result = 1;
        } else {
            Collections.sort(port, new Comparator() {
                    public int compare(Object a, Object z){
                        String info1=((DiskArrayPortInfo)a).getPortNo();
                        String info2=((DiskArrayPortInfo)z).getPortNo();
                        return info1.compareTo(info2);
                    }
       		});
        }
     }//end of else
     }catch(Exception ex){
      throw ex;
      }
   }

   public Vector getPort()
   {
       return port;
   }

    public int getResult()
    {
        return result;
    }
}
   