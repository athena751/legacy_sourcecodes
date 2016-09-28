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

public class RankExpandingShowBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: RankExpandingShowBean.java,v 1.2303 2005/09/21 05:00:38 wangli Exp $";


    private Vector ranknumbers;
    private Vector pdnumbers;
    public RankExpandingShowBean()
    {
        ranknumbers = new Vector();
        pdnumbers = new Vector();
    }
    
    public void beanProcess()throws Exception
    {
        //get ranklist and pdlist from session
        Vector ranklist = (Vector)session.getAttribute(SESSION_RANK_LIST);
        Vector pdlist = (Vector)session.getAttribute(SESSION_PD_LIST);
         String pdgroupnumber = request.getParameter("pdgroupnumber");
        if(ranklist==null||pdlist==null
            || pdgroupnumber==null||pdgroupnumber.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        //get ranknubmers and pdnumbers 
        DiskArrayRankInfo diskarrayrankinfo = new DiskArrayRankInfo();
        DiskArrayPDInfo diskarraypdinfo = new DiskArrayPDInfo();
        String temp;
        int i;
        for(i=0;i<ranklist.size();i++){
            diskarrayrankinfo = (DiskArrayRankInfo)ranklist.get(i);
            //there are some problems
            temp = (diskarrayrankinfo.getPoolNo()).trim();
            if((diskarrayrankinfo. getRaidType()).equals("5")
                    &&temp.substring(0,2).equals(pdgroupnumber))
                ranknumbers.add(temp.substring(4));
        }
        for(i=0;i<pdlist.size();i++){
            diskarraypdinfo = (DiskArrayPDInfo)pdlist.get(i);
            temp = (diskarraypdinfo.getPdNo()).trim();
            if((diskarraypdinfo.getPdDivision()).equals("none") 
                    &&temp.substring(0,2).equals(pdgroupnumber))
                pdnumbers.add(temp.substring(4));
        }
     }
    

    public Vector getRanknumbers()
    {
        return ranknumbers;
    }

    public Vector getPdnumbers()
    {
        return pdnumbers;
    }

}