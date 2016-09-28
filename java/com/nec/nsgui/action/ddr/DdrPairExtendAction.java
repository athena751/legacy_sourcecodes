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

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.ddr.DdrExtendPairBean;
import com.nec.nsgui.model.biz.ddr.DdrHandler;

public class DdrPairExtendAction extends DispatchAction implements DdrActionConst {
	private static final String cvsid = "@(#) $Id: DdrPairExtendAction.java,v 1.2 2008/05/05 00:43:24 liuyq Exp $";

	public ActionForward executePairExtend(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
	throws Exception {
		DdrExtendPairBean mvInfo = (DdrExtendPairBean)((DynaActionForm)form).get("mvInfo");
		DdrExtendPairBean rv0Info = (DdrExtendPairBean)((DynaActionForm)form).get("rv0Info");
		DdrExtendPairBean rv1Info = (DdrExtendPairBean)((DynaActionForm)form).get("rv1Info");
		DdrExtendPairBean rv2Info = (DdrExtendPairBean)((DynaActionForm)form).get("rv2Info");
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		DdrHandler.extendPair(mvInfo, rv0Info, rv1Info, rv2Info, nodeNo);
		NSActionUtil.setSuccess(request);
		return mapping.findForward("globalForward2PairList");
	}
}