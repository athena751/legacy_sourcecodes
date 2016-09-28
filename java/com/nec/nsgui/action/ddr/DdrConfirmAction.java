/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.ddr;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.*;
import org.apache.struts.actions.*;

import com.nec.nsgui.model.entity.ddr.*;
import java.util.ArrayList;

public final class DdrConfirmAction extends DispatchAction implements
		DdrActionConst {

	private static final String cvsid = "@(#) $Id: DdrConfirmAction.java,v 1.1 2008/04/19 10:01:49 liuyq Exp $";
	
	public ActionForward addSchedule(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm createShowForm = (DynaActionForm) form;
        DdrVolInfoBean mvInfo = (DdrVolInfoBean)createShowForm.get("mvInfo");
        ArrayList rvInfoList = getRvList(createShowForm);
        String rvName4Show = ((DdrVolInfoBean)rvInfoList.get(0)).getName();
        for(int i=1;i<rvInfoList.size();i++){
        	rvName4Show = rvName4Show + SEPARATOR_NEWLINE + ((DdrVolInfoBean)rvInfoList.get(i)).getName();;
        }
        request.setAttribute(REQUEST_DDR_MVNAME4SHOW, mvInfo.getMvName4Show());
        request.setAttribute(REQUEST_DDR_RVNAME4SHOW, rvName4Show);
		return mapping.findForward("forwardAddSchedule");
	}

	public ActionForward confirm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm createShowForm = (DynaActionForm) form;
        ArrayList rvInfoList = getRvList(createShowForm);
        DdrVolInfoBean mvInfo = (DdrVolInfoBean)createShowForm.get("mvInfo");
        request.setAttribute(REQUEST_DDR_MVNAME4SHOW, mvInfo.getMvName4Show());
        request.setAttribute(REQUEST_DDR_RVINFOLIST, rvInfoList);
        DdrScheduleBean schedule = (DdrScheduleBean)createShowForm.get("schedule");
        String schedule4Show = ScheduleUtil.getSchedule(ScheduleUtil.ddr2Cron(schedule),request);
        request.setAttribute(REQUEST_DDR_SCHEDULE4SHOW, schedule4Show);
		return mapping.findForward("forwardConfirm");
	}
	
	private ArrayList getRvList(DynaActionForm form){
		ArrayList<DdrVolInfoBean> list =new ArrayList<DdrVolInfoBean>();
		for(int i=0;i<3;i++){
			DdrVolInfoBean rvInfo = (DdrVolInfoBean)form.get("rv"+i+"Info");
			if(rvInfo!=null&&!rvInfo.getPoolName().equals("")){
				list.add(rvInfo);
			}
		}
		return list;
	}
	
}
