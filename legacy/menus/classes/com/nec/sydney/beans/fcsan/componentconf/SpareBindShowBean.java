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

public class SpareBindShowBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: SpareBindShowBean.java,v 1.2302 2005/08/29 09:21:01 huj Exp $";


    private Vector pdnumbers;
    public SpareBindShowBean()
    {
        pdnumbers = new Vector();
    }
    
    public void beanProcess()throws Exception
    {
        //get pdlist from session
        Vector pdlist = (Vector)session.getAttribute(SESSION_PD_LIST);
        if(pdlist==null){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        //get pdgroupnumber and commandid from request
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        if(pdgroupnumber==null||pdgroupnumber.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        String commandid = request.getParameter("commandid");
        if(pdgroupnumber==null||pdgroupnumber.equals("")){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw ex;
        }
        
        //get pdnumbers 
        DiskArrayPDInfo diskarraypdinfo ;
        int i;
        try{
            if(commandid.equals("bind")){
                /*for(i=0;i<pdlist.size();i++){
                    diskarraypdinfo = (DiskArrayPDInfo)pdlist.get(i);
                    String temp = (diskarraypdinfo.getPdNo()).trim();
                    if((diskarraypdinfo.getPdDivision()).equals("none") &&temp.substring(0,2).equals(pdgroupnumber))
                        pdnumbers .add(temp.substring(4));
                }*/
                getPdnumbersToBeBind(pdlist,pdgroupnumber);
            }else{
                for(i=0;i<pdlist.size();i++){
                    diskarraypdinfo = (DiskArrayPDInfo)pdlist.get(i);
                    String temp = (diskarraypdinfo.getPdNo()).trim();
                    if((diskarraypdinfo.getPdDivision()).equals("spare") &&temp.substring(0,2).equals(pdgroupnumber))
                        pdnumbers .add(temp.substring(4));
                
                }
            }
        }catch(Exception e)
        {
            throw e;
        }
    
    }

    public Vector getPdnumbers()
    {
        return pdnumbers;
    }


//Note : the Vector pdlist has been sorted.
    private void getPdnumbersToBeBind(Vector pdlist , String pdgroupnumber) {

        DiskArrayPDInfo diskArrayPDInfo;
        String pdno;

        Vector allPdInPdGroup = new Vector();
        Vector PdOneDe = new Vector();
        int count = pdlist.size();
        int nowDe = 0;

        for (int i=0 ; i<count; i++) {
            diskArrayPDInfo = (DiskArrayPDInfo)pdlist.get(i);
            pdno = (diskArrayPDInfo.getPdNo()).trim();
            
            if (!(pdno.substring(0,2).equals(pdgroupnumber))) {
                continue;
            }

            int deOfPd = Integer.parseInt(pdno.substring(4,5) , 16);
            if (deOfPd != nowDe) {
                nowDe++;
                allPdInPdGroup.add(PdOneDe);
                PdOneDe = new Vector();
            }
            PdOneDe.add(diskArrayPDInfo);

//the code is error , because other pdgroup's pd's existing.
            /*if (i == (count-1)) {
                allPdInPdGroup.add(PdOneDe);
            }*/  
        }
        allPdInPdGroup.add(PdOneDe);
        
        int countDe = allPdInPdGroup.size();
        for (int i=0 ; i<countDe ; i++) {
            addPdnumbers((Vector)allPdInPdGroup.get(i));
        }
        
    }

    private void addPdnumbers(Vector PdOneDe) {
        int countPdOneDe = PdOneDe.size();
        int spareCount = 0;
        int noneCount = 0;
        
        DiskArrayPDInfo diskArrayPDInfo;
        String pdno;
        for (int i=0 ; i<countPdOneDe; i++) {
            diskArrayPDInfo = (DiskArrayPDInfo)PdOneDe.get(i);
            pdno = (diskArrayPDInfo.getPdNo()).trim();
            if((diskArrayPDInfo.getPdDivision()).equals("none")) {
                pdnumbers .add(pdno.substring(4));
                noneCount++;
            }

            if((diskArrayPDInfo.getPdDivision()).equals("spare")) {
                spareCount++;
            }
        }
        
        if (spareCount >= 2) {
            for (int i=0 ; i<noneCount; i++) {
                pdnumbers.remove(pdnumbers.size()-1);
            }
        }
    }
}