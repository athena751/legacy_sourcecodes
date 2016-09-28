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
import java.io.*;

public class SpareBindUnbindBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: SpareBindUnbindBean.java,v 1.2302 2005/08/29 09:21:00 huj Exp $";


    private int result;
    public SpareBindUnbindBean()
    {
        result = 0;
    }

    public void beanProcess()throws Exception
    {
        //get all parameters from request
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        String pdnumber = request.getParameter("pdnumber");
        String commandid = request.getParameter("commandid");
        String diskarrayname = request.getParameter("diskarrayname");
        if(diskarrayname == null || diskarrayname.equals("")
             || pdgroupnumber == null || pdgroupnumber.equals("")
             || pdnumber == null || pdnumber.equals("") || commandid == null
             || commandid.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
 
        try{
            //do command: sudo /usr/ism-cli/bin/iSAsetspare -b -aname of sudo /usr/ism-cli/bin/iSAsetspare -r -aname
            String cmd;
            if(commandid.equals("bind"))
                cmd = CMD_DISKSETSPARE_B+" "+diskarrayname+" -pdg "+pdgroupnumber+"h -pdn "+pdnumber+" -restart";
            else
                cmd = CMD_DISKSETSPARE_R+" "+diskarrayname+" -pdg "+pdgroupnumber+"h -pdn "+pdnumber+" -restart";
            BufferedReader resultbuf = execCmd(cmd);
            if(resultbuf!=null)
                result = 0;
            else
                result = 1;
        }catch(Exception e)
        {
            throw e;
        }
    }

    public int getResult()
    {
        return result;
    }

}