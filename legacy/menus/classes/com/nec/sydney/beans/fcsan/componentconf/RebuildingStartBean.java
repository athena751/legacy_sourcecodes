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

public class RebuildingStartBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: RebuildingStartBean.java,v 1.2302 2005/08/29 09:21:01 huj Exp $";


    int result;
    public RebuildingStartBean()
    {
        result = 0;
    }

    public void beanProcess()throws Exception
    {
        //get all parameters from request
        String diskarrayname = request.getParameter("diskarrayname");
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        String ranknumber = request.getParameter("ranknumber");
        String pdnumber = request.getParameter("pdnumber");
        String rebuildingtime = request.getParameter("rebuildingtime");
        String commandid = request.getParameter("commandid");
        if(diskarrayname==null||diskarrayname.equals("") 
                || pdgroupnumber==null||pdgroupnumber.equals("")
                || ranknumber==null||ranknumber.equals("")
                || pdnumber==null||pdnumber.equals("")
                || rebuildingtime==null||rebuildingtime.equals("")
                || commandid==null||commandid.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
            //do command: sudo /usr/ism-cli/bin/iSAsetrank -rp -aname or sudo /usr/ism-cli/bin/iSAsetrank -rs -aname
            String cmd;
            if(commandid.equals("rp1")||commandid.equals("rp2"))
                cmd = CMD_DISKRBRANK_RP+" "+diskarrayname+" -pdg "+pdgroupnumber+"h -rank "+ranknumber+" -pdn "+pdnumber+" -rbtime "+rebuildingtime+" -restart";
            else
                cmd = CMD_DISKRBRANK_RS+" "+diskarrayname+" -pdg "+pdgroupnumber+"h -rank "+ranknumber+" -pdn "+pdnumber+" -rbtime "+rebuildingtime+" -restart";
            BufferedReader resultbuf = execCmd(cmd);
            if(resultbuf!=null)
                result = 0;
            else
                result = 1;
    }

    public int getResult()
    {
        return result;
    }

}