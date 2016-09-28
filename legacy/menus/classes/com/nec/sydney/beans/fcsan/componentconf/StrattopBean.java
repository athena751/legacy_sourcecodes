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

public class StrattopBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: StrattopBean.java,v 1.2303 2005/09/21 05:00:38 wangli Exp $";


    private Vector ranknumbers;
    public StrattopBean()
    {
        ranknumbers = new Vector();
    }
    
    public void beanProcess()throws Exception
    {
        //get ranklist from session
         Vector ranklist = (Vector)session.getAttribute(SESSION_RANK_LIST);
        if(ranklist==null){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        //get pdgroupnumber from request
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        if(pdgroupnumber==null||pdgroupnumber.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        
        //get ranknubmers
        //DiskArrayRankInfo diskarrayrankinfo = new DiskArrayRankInfo();
        int i;
        try{
            for(i=0;i<ranklist.size();i++){
                DiskArrayRankInfo diskarrayrankinfo = (DiskArrayRankInfo)ranklist.get(i);
                //there are some problems
                String temp = (diskarrayrankinfo.getPoolNo()).trim();
                if(temp.substring(0,2).equals(pdgroupnumber)&&diskarrayrankinfo.getType().equals("reduce")){
                    //ranknumbers.add(diskarrayrankinfo.getRebuildingTime()+","+temp.substring(4)); 
                    ranknumbers.add(diskarrayrankinfo);        
                }
            }
        }catch(Exception e)
        {
            throw e;
        }
    }

    public Vector getRanknumbers()
    {
        return ranknumbers;
    }
}