/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nfs;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.model.entity.nfs.NFSConstant;

public class AddedOptionsAction extends DispatchAction {
	private static final String cvsid = "@(#) $Id: AddedOptionsAction.java,v 1.2 2005/11/23 03:19:38 liul Exp $";
	private static String noFailed = "on";
	public ActionForward display(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		if (noFailed.equals("on")) {
			NSActionUtil.setNoFailedAlert(request);
		} else {
			NSActionUtil.setSessionAttribute(request,
					NSActionConst.SESSION_NOFAILED_ALERT, null);
		}
		NSActionUtil.removeSessionAttribute(request, "thisResult");

		noFailed = "on";
    	String thisResult = NFSModel.getAccessStatus(nodeNo);

		if (!NSActionUtil.isSingleNode(request)) {
			String friendResult = NFSModel.getAccessStatus(1 - nodeNo);
			if ((!thisResult.equals(friendResult))
					|| ((thisResult.equals("undefined")) && (!friendResult
							.equals("undefined")))) {
				NSActionUtil.setSessionAttribute(request, "thisResult",
						thisResult);
				NSException exc = new NSException();
				exc.setErrorCode("0x11F00011");
				throw exc;
			}
		}
		request.setAttribute(NFSConstant.ACCESS_STATUS, thisResult);
		return mapping.findForward("display");

	}
	public ActionForward display4nsview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String result = NFSModel.getAccessStatus(NSActionUtil
				.getCurrentNodeNo(request));
		request.setAttribute(NFSConstant.ACCESS_STATUS, result);

		return mapping.findForward("addedoptions4nsview");

	}
	public ActionForward setAccessStatus(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		DynaActionForm dynaForm = (DynaActionForm) form;
		String accessStatus = (String) dynaForm.get("accessRight");

		noFailed = "off";
		NFSModel.setAccessStatus(NSActionUtil.getCurrentNodeNo(request),
				accessStatus);
		if (NSActionUtil.isSingleNode(request)) {
			NSActionUtil.setSuccess(request);
		} else {
			try {
				NFSModel.setAccessStatus(1 - NSActionUtil
						.getCurrentNodeNo(request), accessStatus);
			} catch (NSException e) {
				e.setErrorCode("0x11F00012");
                                NSActionUtil.setSessionAttribute(request, "thisResult",
						accessStatus);
				throw e;
			}
			String alertMessage = getResources(request).getMessage(
					request.getLocale(),
					"addedoptions4nsview.access.success.message");
			NSActionUtil.setSessionAttribute(request,
					NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
					alertMessage);

		}
		return mapping.findForward("load");
	}

}