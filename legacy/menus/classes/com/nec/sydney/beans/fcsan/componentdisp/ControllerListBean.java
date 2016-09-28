/*
 *      Copyright (c) 2001-2007 NEC Corporation
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

public class ControllerListBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: ControllerListBean.java,v 1.2302 2007/05/09 07:28:23 liuyq Exp $";


   private Vector controllers;
   private int result;
   //constructor
   public ControllerListBean()
   {
        result = 0;
   }

   //beanProcess execute command "iSAdisklist -c -aid(diskarrayID)
   public void beanProcess() throws Exception
   {
     String diskid = request.getParameter("diskArrayID");
     if(diskid == null||diskid.equals("")){
        NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        throw ex;
     }
          
     String cmd = CMD_DISKLIST_C+" "+diskid;     
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
        controllers = new Vector(); 
        while(line != null&&!line.startsWith(DISKLIST_CMD_NAME)){           
            StringTokenizer token = new StringTokenizer(line);
            int count = token.countTokens();
            DiskArrayDacInfo dacinfo = new DiskArrayDacInfo(); 
            // modify by jiangfx,2007.4.27
            // get DAC type according resource type and director type
            String resType = token.nextToken();
            String dirType = token.nextToken();

            String keyofType = "ETC";
            if (resType.startsWith("8")) {
                if (dirType.equals("10h") || dirType.equals("20h")) {
                    keyofType = "dir_" + dirType;
                }
            } else if (resType.startsWith("9")) {
                if (dirType.equals("30h")) {
                    keyofType = "dir_" + dirType;
                }
            } else if (resType.startsWith("a")) {
                keyofType = "CHE";
            } else if (resType.equals("43h") || resType.equals("44h")) {
                keyofType = "PS";
            } else if (resType.equals("65h") || resType.equals("66h")) {
                keyofType = "battery";
            } else if (resType.equals("68h") || resType.equals("69h")) {
                keyofType = "fan"; 
            } else if (resType.equals("b0h") || resType.equals("b1h")) {
                keyofType = "backboard";       
            } else if (resType.equals("41h") || resType.equals("6ch") 
                       || resType.equals("b3h") || resType.equals("b5h")
                       || resType.equals("b6h") || resType.equals("b7h")
                       || resType.equals("b8h") || resType.equals("b9h")
                       || resType.equals("bbh") || resType.equals("cfh")) { 
                    keyofType = resType;
            }
            
            dacinfo.setType(NSMessageDriver.getInstance()
                            .getMessage(session,"fcsan_hashvalue/hashvalue/" + keyofType));         

            dacinfo.setCtlName(token.nextToken());            
            dacinfo.setCtlNo(token.nextToken());
            dacinfo.setState(token.nextToken());
            String complment = token.nextToken();
            if(complment.startsWith(FCSAN_CTL_CAPACITY)) {
                complment = complment.replaceFirst(FCSAN_CTL_CAPACITY,NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/controller/msg_capacity"));
            }
            for(int i=7;i<=count;i++){
                complment = complment+" "+token.nextToken();
            }
            if (complment.equals(FCSAN_NOMEAN_VALUE)){
                complment = "&nbsp;";
            }
            dacinfo.setComplement(complment);
            controllers.add(dacinfo);
            line = readbuf.readLine();  
          }//while           
        }//else
    }

   public Vector getControllers()
   {
       return controllers;
   }

    public int getResult()
    {
        return result;
    }
}
   