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

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.schedulescan.ScheduleScanActionConst;
import com.nec.nsgui.model.biz.schedulescan.ScheduleScanHandler;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;

public class ScheduleScanConfigAction extends Action implements
		ScheduleScanActionConst {
	private static final String cvsid = "@(#) $Id: ScheduleScanConfigAction.java,v 1.1 2008/05/08 08:59:23 chenbc Exp $";

	/**
	 * check whether is in ADS domain
	 * 
	 * @param securityMode
	 * @return true if in, otherwise false
	 */
	private boolean checkAds(String securityMode) {
		return null == securityMode ? false : securityMode
				.equalsIgnoreCase(CONST_SCHEDULESCAN_ADS);
	}

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
		String exportGroupName = NSActionUtil.getExportGroupPath(request)
				.replaceAll("\\/*$", "");
		String[] computerInfo = CifsCmdHandler.getComputerInfo(nodeNumber,
				exportGroupName, true);
		String securityMode = computerInfo[2];

		if (!checkAds(securityMode)) {
			return mapping.findForward("noads");
		}
		String domainName = computerInfo[0];
		String computerName = computerInfo[1];
		String virtualComputerName = ScheduleScanHandler
				.getVirtualComputerName(nodeNumber, exportGroupName, domainName);
		//set target value to session for adding user database
		NSActionUtil.setSessionAttribute(request, CONST_SCHEDULESCAN_TARGET,
				request.getParameter(CONST_SCHEDULESCAN_TARGET));
		NSActionUtil.setSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME, domainName);
		NSActionUtil.setSessionAttribute(request,
				SESSION_SCHEDULESCAN_COMPUTERNAME, computerName);
		NSActionUtil.setSessionAttribute(request,
				SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME, virtualComputerName);
		if (NSActionUtil.isNsview(request)) {
			return mapping.findForward("tabentry4nsview");
		} else {
			return mapping.findForward("tabentry");
		}
	}
}
