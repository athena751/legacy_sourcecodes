/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.schedulescan;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.schedulescan.ScheduleScanHandler;
import com.nec.nsgui.model.entity.schedulescan.ScheduleScanGlobalBean;

public class ScheduleScanListAction extends DispatchAction implements
		ScheduleScanActionConst {
	private static final String cvsid = "@(#) $Id: ScheduleScanListAction.java,v 1.2 2008/05/24 10:15:18 chenjc Exp $";

	public ActionForward display(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String exportGroupName = NSActionUtil.getExportGroupPath(request)
				.replaceAll("\\/*$", "");
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String virtualComputerName = "";
		try {
			virtualComputerName = ScheduleScanHandler.getVirtualComputerName(
					nodeNo, exportGroupName, domainName);
		} catch (Exception e) {
			NSActionUtil.setNoFailedAlert(request);
			NSException ex = new NSException();
			ex.setErrorCode(ERRCODE_GET_INFO);
			throw ex;
		} finally {
			NSActionUtil.setSessionAttribute(request,
					SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME,
					virtualComputerName);
		}
		if (virtualComputerName == null
				|| virtualComputerName.matches("^\\s*$")) {
			return mapping.findForward("listtop");
		}
		try {
			ScheduleScanGlobalBean globalInfo = ScheduleScanHandler
					.getGlobalInfo(nodeNo, domainName, virtualComputerName);
			String scanServer = globalInfo.getScanServer();
			String scanInterface = globalInfo.getSelectedInterfaces();
			String scanUser = globalInfo.getSelectedUsers();
			if (scanServer.matches("^\\s*$") && scanInterface.matches("^\\s*$")
					&& scanUser.matches("^\\s*$")) {
				request.setAttribute("noScanServer", "yes");
				return mapping.findForward("listtop");
			}
			String[] interfaceNames = (scanInterface.matches("^\\s*$") ? "--"
					: scanInterface).split("\\s+");
			String[] scanServers = (scanServer.matches("^\\s*$") ? "--"
					: scanServer).split("\\s+");
			String[] scanUsers = NSActionUtil.htmlSanitize(
					scanUser.matches("^\\s*$") ? "--" : scanUser).split(
					"\\s*:\\s*");
			request.setAttribute("interfaceNames", interfaceNames);
			request.setAttribute("scanServers", scanServers);
			request.setAttribute("scanUsers", scanUsers);
		} catch (NSException ex) {
			request.setAttribute("noScanServer", "yes");
			NSActionUtil.setNoFailedAlert(request);
			ex.setErrorCode(ERRCODE_GET_INFO);
			throw ex;
		} catch (Exception e) {
			request.setAttribute("noScanServer", "yes");
			NSActionUtil.setNoFailedAlert(request);
			NSException nsEx = new NSException();
			nsEx.setErrorCode(ERRCODE_GET_INFO);
			throw nsEx;
		}

		try {
			List scanShare = ScheduleScanHandler.getScanShareList(nodeNo,
					domainName, virtualComputerName);
			request.setAttribute("scanShare", scanShare);
		} catch (NSException ex) {
			request.setAttribute("scanShare", new ArrayList());
			NSActionUtil.setNoFailedAlert(request);
			ex.setErrorCode(ERRCODE_GET_INFO);
			throw ex;
		} catch (Exception e) {
			request.setAttribute("scanShare", new ArrayList());
			NSActionUtil.setNoFailedAlert(request);
			NSException nEx = new NSException();
			nEx.setErrorCode(ERRCODE_GET_INFO);
			throw nEx;
		}

		return mapping.findForward("listtop");
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String deleteConfirm = (String) request.getParameter("deleteConfirm");
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String exportGroupName = NSActionUtil.getExportGroupPath(request)
				.replaceAll("\\/*$", "");
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String computerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);
		if (deleteConfirm.equals("yes")
				|| !ScheduleScanHandler.haveSmbConnection(nodeNo, domainName,
						computerName).equals(CONST_SCHEDULESCAN_YES)) {
			try {
				ScheduleScanHandler.deleteConfigFile(nodeNo, exportGroupName,
						domainName, computerName);
				NSActionUtil.setSuccess(request);
			} catch (NSException e) {
				e.setErrorCode(ERRCODE_DELETE_INFO);
				throw e;
			} catch (Exception e) {
				NSException ex = new NSException();
				ex.setErrorCode(ERRCODE_DELETE_INFO);
				throw ex;
			}
		} else {
			NSActionUtil.setSessionAttribute(request,
					SESSION_SCHEDULESCAN_HAVE_CONNECTION,
					CONST_SCHEDULESCAN_YES);
		}
		return mapping.findForward("list");
	}
}
