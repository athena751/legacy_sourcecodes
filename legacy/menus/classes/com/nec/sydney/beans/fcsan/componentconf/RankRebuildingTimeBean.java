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

public class RankRebuildingTimeBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: RankRebuildingTimeBean.java,v 1.2303 2005/09/21 05:00:38 wangli Exp $";


    private int result;
    public RankRebuildingTimeBean()
    {
        result = 0;
    }

    public void beanProcess()throws Exception
    {
        //get all parameters from request
        String diskarrayname = request.getParameter("diskarrayname");
        String rebuildingtime = request.getParameter("rebuildingtime");
        String poolname = request.getParameter("poolname");
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        if(diskarrayname==null||diskarrayname.equals("") 
                || pdgroupnumber==null||pdgroupnumber.equals("") 
                || poolname==null||poolname.equals("")
                || rebuildingtime==null||rebuildingtime.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
           //do command: sudo /usr/ism-cli/bin/iSAsetrank -c -aname
            String cmd = CMD_DISKSETPOOL_C+" "+diskarrayname+" -pdg "+pdgroupnumber+"h -pname "+poolname+" -rbtime "+rebuildingtime+" -restart";
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