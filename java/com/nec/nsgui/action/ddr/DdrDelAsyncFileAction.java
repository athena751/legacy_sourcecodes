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

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;

public class DdrDelAsyncFileAction extends Action {
	private static final String cvsid = "@(#) $Id: DdrDelAsyncFileAction.java,v 1.2 2008/04/30 10:38:11 pizb Exp $";

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String mvName = request.getParameter("mvName");
		request.getSession().setAttribute(DdrActionConst.SESSION_MV_NAME, mvName);
		
		DdrHandler.delAsyncFile(mvName, nodeNo);
		NSActionUtil.setSuccess(request);
		return mapping.findForward("globalForward2PairList");
	}
}