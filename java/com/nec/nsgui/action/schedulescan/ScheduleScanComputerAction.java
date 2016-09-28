/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.schedulescan;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.usermapping.UsermappingCommon;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.domain.DomainHandler;
import com.nec.nsgui.model.biz.schedulescan.ScheduleScanHandler;

public class ScheduleScanComputerAction extends DispatchAction implements
		ScheduleScanActionConst {
	private static final String cvsid = "@(#) $Id: ScheduleScanComputerAction.java,v 1.4 2008/05/29 04:45:12 chenjc Exp $";

	public ActionForward load(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm computerForm = (DynaActionForm) form;
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String exportGroupPath = NSActionUtil.getExportGroupPath(request)
				.replace("\\/*$", "");
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String vComputerName = ScheduleScanHandler.getVirtualComputerName(
				nodeNo, exportGroupPath, domainName);
		NSActionUtil.setSessionAttribute(request,
				SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME, vComputerName);
		computerForm.set(CONST_FORM_COMPUTER_NAME, vComputerName);

		setHostName(request);

		return mapping.findForward("computersettop");
	}

	public ActionForward checkConnection(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String vComputerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);
		// if it is first set(vComputerName is ""),there is no need to check
		// connection,but to set immediately
		if (!vComputerName.equals("")) {
			String flag = ScheduleScanHandler.haveSmbConnection(nodeNo,
					domainName, vComputerName);

			if (flag.equals(CONST_SCHEDULESCAN_YES)) {
				setHostName(request);
				request.setAttribute(CONST_REQUEST_HAVE_CONNECTION,
						CONST_SCHEDULESCAN_YES);
				return mapping.findForward("computersettop");
			}
		}

		return set(mapping, form, request, response);
	}

	public ActionForward set(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm computerForm = (DynaActionForm) form;
		String vComputerName = computerForm.getString(CONST_FORM_COMPUTER_NAME);

		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		boolean isCluster = NSActionUtil.isCluster(request);
		String exportPath = (String) NSActionUtil.getExportGroupPath(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String computerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_COMPUTERNAME);
		String oldVComputerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);
		setHostName(request);

		try {
			// check whether the old and new computer has user mapping or not
			String[] UserMapping = ScheduleScanHandler.haveUserMapping(nodeNo,
					domainName, oldVComputerName, vComputerName);
			String oldUserMapping = UserMapping[0];
			String newUserMapping = UserMapping[1];

			if (!oldVComputerName.equals(vComputerName)) {
				if (oldUserMapping.equals(CONST_SCHEDULESCAN_NO)) {
					if (oldVComputerName.equals("")) {
						ScheduleScanHandler.setNewComputerInfo(nodeNo,
								exportPath, domainName, computerName,
								vComputerName);
					} else {
						ScheduleScanHandler.setComputerInfo(nodeNo, exportPath,
								domainName, oldVComputerName, vComputerName);
					}
				} else {
					UsermappingCommon.changeComputerName(nodeNo, isCluster,
							domainName, vComputerName, oldVComputerName, true);
				}
				// reset the virtual computer name in the session
				NSActionUtil.setSessionAttribute(request,
						SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME,
						vComputerName);
			}
			if (oldUserMapping.equals(CONST_SCHEDULESCAN_NO)
					&& newUserMapping.equals(CONST_SCHEDULESCAN_NO)) {
				request.setAttribute(CONST_REQUEST_TO_ADD_USER,
						CONST_SCHEDULESCAN_YES);
			} else {
				NSActionUtil.setSuccess(request);
			}
		} catch (NSException nse) {
			String errorCode = nse.getErrorCode();
			if (errorCode.equalsIgnoreCase("0x14100031")) {
				errorCode = ERRCODE_SCHEDULESCAN_COMPUTER_EXIST;
			} else if (errorCode.equalsIgnoreCase("0x14100001")) {
				errorCode = ERRCODE_SCHEDULESCAN_USER_COMPUTER_EXIST;
			} else if (errorCode.matches("0x141.*")) {
				nse.setErrorCode(ERRCODE_CHECK_INFO);
			}
			String alertMessage = getAlertMessage(errorCode, request);
			if (alertMessage != null) {
				NSActionUtil.setSessionAttribute(request,
						NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
						alertMessage);
			} else {
				// check vs and smb file are in pair or not
				String isPair = ScheduleScanHandler.checkVSSmbPair(nodeNo);
				if (isPair.equals(CONST_SCHEDULESCAN_NO)) {
					nse.setErrorCode(ERRCODE_SCHEDULESCAN_VS_SMB_PAIR);
				}
				throw nse;
			}
		} catch (Exception e) {
			NSException nse = new NSException();
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		}

		return mapping.findForward("computersettop");
	}

	private void setHostName(HttpServletRequest request) throws Exception {
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String[] hostName = DomainHandler.getHostName(nodeNo);
		request.setAttribute(CONST_REQUEST_HOST_NAME, hostName);
	}

	private String getAlertMessage(String errorCode, HttpServletRequest request) {
		String alertMessage = null;
		Locale locale = request.getLocale();
		MessageResources messages = getResources(request);
		if (errorCode.equalsIgnoreCase(ERRCODE_SCHEDULESCAN_COMPUTER_EXIST)) {
			alertMessage = messages.getMessage(locale,
					"schedulescan.alert.computer.exist");
		} else if (errorCode
				.equalsIgnoreCase(ERRCODE_SCHEDULESCAN_USER_NOT_ADS)) {
			alertMessage = messages.getMessage(locale,
					"schedulescan.alert.computer.notads");
		} else if (errorCode
				.equalsIgnoreCase(ERRCODE_SCHEDULESCAN_USER_NOT_PWD)) {
			alertMessage = messages.getMessage(locale,
					"schedulescan.alert.computer.notpwd");
		} else if (errorCode
				.equalsIgnoreCase(ERRCODE_SCHEDULESCAN_USER_COMPUTER_EXIST)) {
			alertMessage = messages.getMessage(locale,
					"schedulescan.alert.computer.exist.possibility");
		} else if (errorCode
				.equalsIgnoreCase(ERRCODE_SCHEDULESCAN_NO_AVAILABLE_INTERFACE)) {
			alertMessage = messages.getMessage(locale,
					"schedulescan.alert.computer.noAvailableInterfaces");
		}
		if (alertMessage != null) {
			MessageResources commonMessages = (MessageResources) getServlet()
					.getServletContext().getAttribute("common");
			alertMessage = commonMessages.getMessage(locale,
					"common.alert.failed")
					+ "\\r\\n" + alertMessage;
		}
		return alertMessage;
	}
}
