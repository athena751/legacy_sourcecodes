/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.ddr;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.atom.admin.ddr.DdrConstants;
import com.nec.sydney.atom.admin.ddr.DdrInfo;
import com.nec.sydney.beans.base.TemplateBean;
import java.util.*;

public class DdrListBean extends TemplateBean implements DdrConstants {
    private static final String     cvsid = "@(#) $Id: DdrListBean.java,v 1.2 2007/04/26 05:42:00 liy Exp $";
    private Vector ddrInfoList = new Vector();
    private boolean displayBatchButton = false;
    private boolean displayDelPairingButton = false;
    
    public void onDisplay() throws Exception {
        String account = DDR_CRON_FILE_NAME;
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allInfoList;
        allInfoList = DdrScheduleHandler.getDDRPairingInfo(account,groupNo);
        session.setAttribute(DDR_SESSION_ALL_PAIR, allInfoList);
        for(int i=0; i<allInfoList.size(); i++){
            DdrInfo di = (DdrInfo)allInfoList.get(i);
            if(!di.getHasDelete()){
                ddrInfoList.add(di);
            }else{
                displayDelPairingButton = true;
            }
            if(di.getHasSchedule().equals("false")){
                displayBatchButton = true;
            }
        }
    }
    
    public boolean hasUnSchPairing () throws Exception {
        return displayBatchButton;
    }

    public boolean hasDeletedPairing () throws Exception {
        return displayDelPairingButton;
    }

    public Vector getPairingInfo(){
        return ddrInfoList;
    }
}
