/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;

import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import java.util.*;
import java.io.*;

public class StratbottomBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: StratbottomBean.java,v 1.2302 2005/08/29 09:21:01 huj Exp $";


    private Vector pdnumbers;
    private Vector sparenumbers;
    private int result; 
    public StratbottomBean()
    {
        pdnumbers = new Vector();
        sparenumbers = new Vector();
        result = 0;
    }
    
    public void beanProcess()throws Exception
    {
        //get pdlist from session
         Vector pdlist = (Vector)session.getAttribute(SESSION_PD_LIST);
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        String diskarrayid = request.getParameter("diskarrayid");
        String ranknumber = request.getParameter("ranknumber");
        if(pdlist==null || pdgroupnumber==null||pdgroupnumber.equals("")
                || diskarrayid==null||diskarrayid.equals("")
                || ranknumber==null||ranknumber.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
         DiskArrayPDInfo diskarraypdinfo = new DiskArrayPDInfo();
        int i;
            //get pdnubmers
            for(i=0;i<pdlist.size();i++){
                diskarraypdinfo = (DiskArrayPDInfo)pdlist.get(i);
                String temp= (diskarraypdinfo.getPdNo()).trim();
                if(temp.substring(0,2).equals(pdgroupnumber)&&diskarraypdinfo.getPdDivision().equals("spare")){
                    sparenumbers.add(temp.substring(4));             
                }
            }

            //do command iSAdisklist -rp -aid
            String cmd = CMD_DISKLIST_RP+" "+diskarrayid+" "+"-nrank"+" "+pdgroupnumber+"h-"+ranknumber;
            BufferedReader resultbuf = execCmd(cmd);
            //get pdnumbers
            if(resultbuf!=null){
                result = 0;
                String line = resultbuf.readLine();
                   while(!line.startsWith(SEPARATED_LINE)){
                       line = resultbuf.readLine();
                   }
                   line = resultbuf.readLine();
                   while(line != null){           
                       StringTokenizer token = new StringTokenizer(line);
                       //int count = token.countTokens();
                       //if(count==4){
                    if(!line.startsWith(DISKLIST_CMD_NAME)&&token.countTokens()!=0){                        
                          String pdnumber = token.nextToken().trim();
                        pdnumbers.add(pdnumber.substring(4));
                    }
                       line = resultbuf.readLine();  
                   }//end of while           
                if (pdnumbers.size() == 0) {
                	setErrorCode(71);
            		specialErrMsgHash.put(new Integer(71), NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_disk_err_popup"));
            		result = 1;
                } else {
                	Collections.sort(pdnumbers);
                }
            }//end of if
            else{
                result = 1;
            }
    }

    public Vector getPdnumbers()
    {
        return pdnumbers;
    }

    public Vector getSparenumbers()
    {
        return sparenumbers;
    }
    public int getResult()
    {
        return result;
    }

}