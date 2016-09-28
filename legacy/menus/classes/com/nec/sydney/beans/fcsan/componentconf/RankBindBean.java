/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;

import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.framework.*;
import java.io.*;

public class RankBindBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: RankBindBean.java,v 1.2302 2005/08/29 09:21:01 huj Exp $";


    private boolean success;

    public RankBindBean()
    {
    }

    public void beanProcess() throws Exception
    {
        String diskarrayname=request.getParameter("diskarrayname");
        String pdgroupnumber=request.getParameter("pdgroupnumber");
        String pdno=request.getParameter("pdno"); //two byte type 00h
        String rankno=request.getParameter("rankno"); //two byte type 00h
        String raidtype=request.getParameter("raidtype");
        String rebuildingtime=request.getParameter("rebuildingtime");

        if(diskarrayname==null||pdgroupnumber==null||pdno==null||
            rankno==null||raidtype==null||rebuildingtime==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        StringBuffer command=new StringBuffer(CMD_DISKSETRANK_B);
        command.append(" ");
        command.append(diskarrayname);
        command.append(" -pdg ");
        command.append(pdgroupnumber);
        command.append("h");
        command.append(" -pdn ");
        command.append(pdno);
        command.append(" -rank ");
        command.append(rankno);
        command.append("h");
        command.append(" -raid ");
        command.append(raidtype);
        command.append(" -rbtime ");
        command.append(rebuildingtime);
        //Add by maojb on 5.24 corresponding for mail 2888
        command.append(" -restart");

        String cmd=command.toString();
        BufferedReader buf=execCmd(cmd);
        
        if(buf!=null)
        {
            success=true;
        }
        else
        {
            success=false;
                
        }
    }

    public boolean getSuccess()
    {
        return success;
    }
}