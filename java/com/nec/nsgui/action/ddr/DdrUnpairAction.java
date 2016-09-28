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

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.DdrPairInfoBean;

public class DdrUnpairAction extends Action {
	private static final String cvsid = "@(#) $Id: DdrUnpairAction.java,v 1.2 2008/04/30 10:38:24 pizb Exp $";

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		DdrPairInfoBean ddrPairInfo = (DdrPairInfoBean) ((DynaActionForm) form)
				.get("ddrPairInfo");
		String mvName = ddrPairInfo.getMvName();
		request.getSession().setAttribute(DdrActionConst.SESSION_MV_NAME, mvName);
		
		String rvName = ddrPairInfo.getRvName().replaceAll("#", ",");
		DdrHandler.unpair(mvName, rvName, nodeNo);
		NSActionUtil.setSessionAttribute(request,
				NSActionConst.SESSION_SUCCESS_ALERT, "true");
		return mapping.findForward("globalForward2PairList");
	}
}