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

public class RankRebTimeChangeShowBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: RankRebTimeChangeShowBean.java,v 1.2303 2005/09/21 05:00:38 wangli Exp $";


    private Vector ranknumbers;
    public RankRebTimeChangeShowBean()
    {
        ranknumbers = new Vector();
    }
    
    public void beanProcess()throws Exception
    {
        String aid=request.getParameter("diskarrayid");
        //get ranklist from session
         Vector ranklist = (Vector)session.getAttribute(SESSION_RANK_LIST);
          String pdgroupnumber = request.getParameter("pdgroupnumber");
        if(ranklist==null || pdgroupnumber==null||pdgroupnumber.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
         //get ranknubmers
        //DiskArrayRankInfo diskarrayrankinfo = new DiskArrayRankInfo();
        String temp="";
        int i;
        for(i=0;i<ranklist.size();i++){
            DiskArrayRankInfo diskarrayrankinfo = (DiskArrayRankInfo)ranklist.get(i);
            temp= (diskarrayrankinfo.getPoolNo()).trim();
            if(getPDGByPool(aid, temp).equals(pdgroupnumber)){
                ranknumbers.add(diskarrayrankinfo);                
            }
        }
   }

    public Vector getRanknumbers()
    {
        return ranknumbers;
    }

}