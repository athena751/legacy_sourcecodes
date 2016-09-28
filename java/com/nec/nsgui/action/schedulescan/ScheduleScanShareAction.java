/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.schedulescan;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.schedulescan.ScheduleScanHandler;

public class ScheduleScanShareAction extends DispatchAction implements
		ScheduleScanActionConst {
	private static final String cvsid = "@(#) $Id: ScheduleScanShareAction.java,v 1.1 2008/05/08 08:59:23 chenbc Exp $";

	public ActionForward getShareInfo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNum = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String computer = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_COMPUTERNAME);
		String vComputer = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);

		if (vComputer == null
				|| vComputer.matches("\\s*")
				|| ScheduleScanHandler.haveSetGlobal(nodeNum, domainName,
						vComputer).equals(CONST_SCHEDULESCAN_NO)) {
			return mapping.findForward("nosetting");
		}
		try {
			String[] result = ScheduleScanHandler.getShareInfo(nodeNum,
					domainName, computer, vComputer);
			setRequestArribute(request, result[0], result[1]);
		} catch (NSException nse) {
			NSActionUtil.setNoFailedAlert(request);
			nse.setErrorCode(ERRCODE_GET_INFO);
			throw nse;
		} catch (Exception e) {
			NSActionUtil.setNoFailedAlert(request);
			NSException nse = new NSException();
			nse.setErrorCode(ERRCODE_GET_INFO);
			throw nse;
		}

		return mapping.findForward("scansharetop");
	}

	public ActionForward checkConnection(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String vComputer = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);

		String flag = ScheduleScanHandler.haveSmbConnection(nodeNo, domainName,
				vComputer);

		if (flag.equals(CONST_SCHEDULESCAN_YES)) {
			request.setAttribute(CONST_REQUEST_HAVE_CONNECTION,
					CONST_SCHEDULESCAN_YES);
			DynaActionForm shareForm = (DynaActionForm) form;
			String unusedShare = shareForm.getString("unusedScanShareSet");
			String usedShare = shareForm.getString("usedScanShareSet");
			setRequestArribute(request, unusedShare, usedShare);
			return mapping.findForward("scansharetop");
		}

		return setShareInfo(mapping, form, request, response);
	}

	public ActionForward setShareInfo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		int nodeNum = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String vsComputer = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_COMPUTERNAME);
		String ssComputer = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);
		DynaActionForm shareForm = (DynaActionForm) form;
		String unusedShare = shareForm.getString("unusedScanShareSet");
		String usedShare = shareForm.getString("usedScanShareSet");
		setRequestArribute(request, unusedShare, usedShare);
		try {
			ScheduleScanHandler.setShareInfo(nodeNum, domainName, vsComputer,
					ssComputer, usedShare);
			NSActionUtil.setSuccess(request);
		} catch (NSException nse) {
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		} catch (Exception e) {
			NSException nse = new NSException();
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		}

		return mapping.findForward("scansharetop");
	}

	/**
	 * set the unusedShare String and usedShare String to the request
	 * 
	 * @param request
	 * @param strs
	 */
	private void setRequestArribute(HttpServletRequest request, String... strs) {
		if (!strs[0].matches("\\s*")) {
			String[] unusedShare = strs[0].split("\\,");
			request.setAttribute(CONST_REQUEST_SHARES_UNUSED,
					unusedShare);
		}
		if (strs.length > 1 && !strs[1].matches("\\s*")) {
			String[] usedShare = strs[1].split("\\,");
			request.setAttribute(CONST_REQUEST_SHARES_USED, usedShare);
		}
	}
}