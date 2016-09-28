/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.ddr;

import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.*;
import org.apache.struts.actions.*;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.*;

public final class DdrScheduleAction extends DispatchAction implements
		DdrActionConst {

	private static final String cvsid = "@(#) $Id: DdrScheduleAction.java,v 1.2 2008/04/30 10:40:52 pizb Exp $";

	
	public ActionForward modify(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		DynaActionForm ddrPairListForm = (DynaActionForm) form;
		DdrPairInfoBean info = (DdrPairInfoBean)ddrPairListForm.get("ddrPairInfo");
		DdrScheduleBean dsi = (DdrScheduleBean)ddrPairListForm.get("schedule");
        String mvName = info.getMvName();
        String rvName = getSortedRV(info.getRvName());
        String timeStr = info.getSchedule();
        String newTimeStr = ScheduleUtil.ddr2Cron(dsi);
        DdrHandler.modifySchedule( mvName, rvName, timeStr, newTimeStr, nodeNo);
		NSActionUtil.setSessionAttribute(request,
				NSActionConst.SESSION_SUCCESS_ALERT, "true");
		return mapping.findForward("globalForward2PairList");
	}

	public ActionForward modifyShow(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm ddrPairListForm = (DynaActionForm) form;
		DdrPairInfoBean info = (DdrPairInfoBean)ddrPairListForm.get("ddrPairInfo");
		String mvName = info.getMvName();
	    String rvName = getSortedRV(info.getRvName());
	    String timeStr = info.getSchedule();
	    request.getSession().setAttribute(SESSION_MV_NAME, mvName);
		request.setAttribute(REQUEST_DDR_MVNAME4SHOW,mvName.replaceFirst("NV_LVM_",""));
		request.setAttribute(REQUEST_DDR_RVNAME4SHOW,rvName.replaceAll(SEPARATOR_COMMA,SEPARATOR_NEWLINE));
		DdrScheduleBean dsi = ScheduleUtil.cron2Ddr(timeStr);
		ddrPairListForm.set("schedule", dsi);
		return mapping.findForward("forwardDdrModify");
	}
	
	private String getSortedRV(String rv){
		String[] rvs = rv.split(SEPARATOR_NUMBERSIGN);
		Arrays.sort(rvs);
		return ScheduleUtil.joinArray2String(rvs,SEPARATOR_COMMA);
	}
	
}
