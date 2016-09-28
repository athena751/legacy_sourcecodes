/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.ddr;

import java.util.List;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.DdrVolInfoBean;
import org.apache.struts.util.LabelValueBean;

public class PairCreateShowAction extends DispatchAction implements DdrActionConst {
    private static final String cvsid = "@(#) $Id: PairCreateShowAction.java,v 1.2 2008/05/24 09:00:04 liuyq Exp $";
    
	public ActionForward showAlways(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// Set usage for devide the use of the pair 
		request.setAttribute(REQUEST_D2D_USAGE, USAGE_ALWAYS);
		
		// Check if in the Generation Backup module
		String clearMark = request.getParameter("clearFormBeanInSession");
		if((clearMark != null) && clearMark.equalsIgnoreCase("true")){
		    // Clear FormBean in session
			request.getSession().removeAttribute("PairCreateShowForm");
		}
		
		if(NSActionUtil.hasActiveAsyncVolume(request)
		   || NSActionUtil.hasActiveAsyncPair(request)){
			request.setAttribute(SESSION_DDR_ASYNCVOL,"true");
	        return mapping.findForward("showSyncVol");
		}
		
		List freeMvList = DdrHandler.getFreeMvList();
		if(freeMvList.size()==0){
			request.setAttribute(REQUEST_MV_NAME_AND_VALUE, "");
			return mapping.findForward("showNoMv");
		}
		List nameAndValueList = getNameAndValue4ShowList(freeMvList);
		request.setAttribute(REQUEST_MV_NAME_AND_VALUE, nameAndValueList);
		
		return mapping.findForward("showAlways");
	}	
	public ActionForward showGeneration(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        // Set usage for devide the use of the pair 
		request.setAttribute(REQUEST_D2D_USAGE, USAGE_GENERATION);
		
		// Check if in the Generation Backup module
		String clearMark = request.getParameter("clearFormBeanInSession");
		if((clearMark != null) && clearMark.equalsIgnoreCase("true")){
		    // Clear FormBean in session
			request.getSession().removeAttribute("PairCreateShowForm");
		}
		
		if(NSActionUtil.hasActiveAsyncVolume(request)
		   || NSActionUtil.hasActiveAsyncPair(request)){
			request.setAttribute(SESSION_DDR_ASYNCVOL,"true");
	        return mapping.findForward("showSyncVol");
		}
		List freeMvList = DdrHandler.getFreeMvList();
		if(freeMvList.size()==0){
			request.setAttribute(REQUEST_MV_NAME_AND_VALUE, "");
			return mapping.findForward("showNoMv");
		}
		List nameAndValueList = getNameAndValue4ShowList(freeMvList);
		request.setAttribute(REQUEST_MV_NAME_AND_VALUE, nameAndValueList);
		return mapping.findForward("showGeneration");
	}
	
	protected List getNameAndValue4ShowList(List<DdrVolInfoBean> freeMvList) throws Exception{
		List<LabelValueBean> nameAndValue4ShowList = new ArrayList<LabelValueBean>();
		for (DdrVolInfoBean mv : freeMvList){
			nameAndValue4ShowList.add(new LabelValueBean(mv.getMvName4Show(),mv.getMvValue4Show()));
		}
		return nameAndValue4ShowList;
	}
}