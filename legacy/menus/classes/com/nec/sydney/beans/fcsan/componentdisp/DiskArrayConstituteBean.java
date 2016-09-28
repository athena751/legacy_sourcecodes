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

public class DiskArrayConstituteBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: DiskArrayConstituteBean.java,v 1.2301 2005/08/29 08:47:12 huj Exp $";


   private DiskArrayInfo  diskarrayinfo;
   private String diskarrayname;
   private int result;
   //constructor
   public DiskArrayConstituteBean()
   {
        result = 0;
   }

   //beanProcess execute command "iSAdisklist -dd -aid(diskarrayID)
   public void beanProcess() throws Exception
   {
     //String home = System.getProperty("user.home");
     String diskid = request.getParameter("diskid");
     if(diskid == null||diskid.equals("")){
     NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
     throw ex;
     }
          
     try{

     String cmd = CMD_DISKLIST_DD+" "+diskid;    
     BufferedReader readbuf = execCmd(cmd);
     if(readbuf==null){
            result = 1;
       }else{
           result = 0;
           String line = readbuf.readLine();
           while(!line.startsWith(DISK_ARRAY)){
                line = readbuf.readLine();
           }
           StringTokenizer token_name = new StringTokenizer(line,":");
           if (token_name.countTokens()==2) {
                 token_name.nextToken();
                 diskarrayname = (token_name.nextToken()).trim();
           } else {
                diskarrayname = "&nbsp;"; 
           } 
           
           line = readbuf.readLine();
           while(!line.startsWith(SEPARATED_LINE)){
                line = readbuf.readLine();
           }
           line = readbuf.readLine();
           
           //modified for the wrong aid, modified by zhangjx 2003.01.28
           if(line !=null) {
                StringTokenizer token = new StringTokenizer(line);
                if(token.countTokens()!=3)
                    return;
          } 
          
           Vector type = new Vector();
           Vector portstate = new Vector();
           Vector cnt = new Vector();
           while(line !=null){                   
               StringTokenizer token = new StringTokenizer(line);  
               if(token.countTokens()==3){
                    type.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+token.nextToken()));
                    portstate.add(token.nextToken());
                    cnt.add(token.nextToken());
               }
               line = readbuf.readLine();              
           }    
           diskarrayinfo = new DiskArrayInfo();
           diskarrayinfo.setComponentTypes(type);
           diskarrayinfo.setComponentStates(portstate);
           diskarrayinfo.setEntryCounts(cnt); 
      }
     }catch(Exception ex){
      throw ex;
      }
   }

   public DiskArrayInfo getDiskArrayinfo()
   {
       return diskarrayinfo;
   }

   public int getResult()
   {
        return result;
   }
   
   public String getDiskArrayName()
   {
        return diskarrayname;
   }
}
   