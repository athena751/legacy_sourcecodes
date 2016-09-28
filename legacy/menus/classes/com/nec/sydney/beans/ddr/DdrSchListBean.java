/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DdrSchListBean.java,v 1.3 2007/04/26 05:42:00 liy Exp $
 */
package com.nec.sydney.beans.ddr;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.sydney.atom.admin.ddr.DdrConstants;
import com.nec.sydney.beans.base.TemplateBean;
import java.util.Vector;

public class DdrSchListBean extends TemplateBean implements DdrConstants {
    private static final String     cvsid = "@(#) DdrSchListBean.java,v 1.1 2004/08/24 09:50:22 wangw Exp";
    private Vector ddrSchInfoList ;
    private String mvName = "";
    private String rvName = "";
    
    public void onDisplay() throws Exception {
        mvName = request.getParameter("mvName");
        rvName = request.getParameter("rvName");
        String account = DDR_CRON_FILE_NAME;
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        ddrSchInfoList = DdrScheduleHandler.getDDRScheduleInfo(mvName, rvName, account,groupNo);
    }

    public void onDelete() throws Exception {
        mvName = request.getParameter("mvName");
        rvName = request.getParameter("rvName");
        String delTimeStr = request.getParameter("delTimeStr");
        String account = DDR_CRON_FILE_NAME;
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        DdrScheduleHandler.deleteDdrSchedule(mvName,rvName,delTimeStr,account,groupNo);
        setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        setRedirectUrl("../nas/ddr/ddrschedulelist.jsp?mvName="+mvName+"&rvName="+rvName);
    }

    public Vector getDdrSchInfoList (){
        return ddrSchInfoList;
    }
    
    public String getMvName(){
        return mvName;
    }

    public String getRvName(){
        return rvName;
    }
}
