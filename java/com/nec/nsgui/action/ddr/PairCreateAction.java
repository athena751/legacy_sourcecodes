package com.nec.nsgui.action.ddr;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.DdrVolInfoBean;
import com.nec.nsgui.model.entity.ddr.DdrScheduleBean;

public class PairCreateAction extends DispatchAction implements DdrActionConst {
	public ActionForward alwaysRepl(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm inputForm = (DynaActionForm) form;

		DdrVolInfoBean  mvInfo = (DdrVolInfoBean) inputForm.get("mvInfo");
		DdrVolInfoBean  rvInfo = (DdrVolInfoBean) inputForm.get("rv0Info");

		DdrHandler.createPair( mvInfo,rvInfo,NSActionUtil.getCurrentNodeNo(request));
		request.getSession().setAttribute(SESSION_MV_NAME, mvInfo.getName());
		request.getSession().removeAttribute("PairCreateShowForm");
		NSActionUtil.setSuccess(request);
		return mapping.findForward("success");
	
	}
	public ActionForward generationRepl(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm inputForm = (DynaActionForm) form;
		DdrVolInfoBean  mvInfo = (DdrVolInfoBean) inputForm.get("mvInfo");
		DdrVolInfoBean [] rvsInfo  = {
				                  (DdrVolInfoBean) inputForm.get("rv0Info"),
				                  (DdrVolInfoBean) inputForm.get("rv1Info"),
				                  (DdrVolInfoBean) inputForm.get("rv2Info")
		                           };
		
		DdrScheduleBean schedule = (DdrScheduleBean)inputForm.get("schedule");
		String strSchedule = ScheduleUtil.ddr2Cron(schedule);
		DdrHandler.createPair(mvInfo,rvsInfo,strSchedule,NSActionUtil.getCurrentNodeNo(request));
		request.getSession().setAttribute(SESSION_MV_NAME, mvInfo.getName());
		request.getSession().removeAttribute("PairCreateShowForm");
        NSActionUtil.setSuccess(request);
		return mapping.findForward("success");
	
	}
}