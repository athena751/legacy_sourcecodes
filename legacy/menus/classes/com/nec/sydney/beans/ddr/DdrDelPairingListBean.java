/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DdrDelPairingListBean.java,v 1.3 2007/04/26 05:42:00 liy Exp $
 */
package com.nec.sydney.beans.ddr;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.sydney.atom.admin.ddr.DdrConstants;
import com.nec.sydney.atom.admin.ddr.DdrInfo;
import com.nec.sydney.beans.base.TemplateBean;
import java.util.Vector;
import java.util.Arrays;

public class DdrDelPairingListBean extends TemplateBean implements DdrConstants {
    private static final String     cvsid = "@(#) DdrDelPairingListBean.java,v 1.1 2004/08/24 09:50:22 wangw Exp";
    private Vector ddrDelPairingist = new Vector();
    
    public void onDisplay() throws Exception {
        String account = DDR_CRON_FILE_NAME;
        Vector allPair = (Vector)session.getAttribute(DDR_SESSION_ALL_PAIR);
        for(int i=0; i<allPair.size(); i++){
            DdrInfo di = (DdrInfo)allPair.get(i);
            if(di.getHasDelete()){
                ddrDelPairingist.add(di);
            }
        }
    }

    public void onDeleteone() throws Exception {
        Vector paramPairing = new Vector();
        String onePairingName = request.getParameter("onepairing");
        paramPairing.add(onePairingName);
        String account = DDR_CRON_FILE_NAME;
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        DdrScheduleHandler.delDdrPairingSchedule(paramPairing,account,groupNo);
        deleteSessionInfo(onePairingName);
        setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
    }

    public void onDeletemulti() throws Exception {
        String[] tmparray = request.getParameterValues("multipairing");
        Vector paramPairing = new Vector(Arrays.asList(tmparray));
        String account = DDR_CRON_FILE_NAME;
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        DdrScheduleHandler.delDdrPairingSchedule(paramPairing,account,groupNo);
        for(int i=0;i<paramPairing.size();i++){
            deleteSessionInfo((String)paramPairing.get(i));
        }
    }

    public Vector getDdrDelPairingist (){
        return ddrDelPairingist;
    }

    private void deleteSessionInfo(String mvAndrv){
        Vector allPair = (Vector)session.getAttribute(DDR_SESSION_ALL_PAIR);
        for(int i=0; i<allPair.size(); i++){
            DdrInfo di = (DdrInfo)allPair.get(i);
            if(mvAndrv.equals(di.getMvName()+" "+di.getRvName())){
                allPair.remove(di);
                break;
            }
        }
    }        
}
