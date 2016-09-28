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
import com.nec.nsgui.model.entity.schedulescan.ScheduleScanGlobalBean;

public class ScheduleScanGlobalAction extends DispatchAction implements
		ScheduleScanActionConst {
	private static final String cvsid = "@(#) $Id: ScheduleScanGlobalAction.java,v 1.2 2008/05/15 00:38:10 chenjc Exp $";

	public ActionForward load(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm globalForm = (DynaActionForm) form;

		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String vComputerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);

		if (vComputerName.matches("\\s*")) {
			return mapping.findForward("nocomputer");
		}
		try {
			setRequestAttribute(request, nodeNo, domainName, vComputerName);
			ScheduleScanGlobalBean globalBean = ScheduleScanHandler
					.getGlobalInfo(nodeNo, domainName, vComputerName);
			globalForm.set(CONST_FORM_GLOBAL_BEAN, globalBean);
		} catch (NSException nse) {
			globalForm
					.set(CONST_FORM_GLOBAL_BEAN, new ScheduleScanGlobalBean());
			NSActionUtil.setNoFailedAlert(request);
			nse.setErrorCode(ERRCODE_GET_INFO);
			throw nse;
		} catch (Exception e) {
			globalForm
					.set(CONST_FORM_GLOBAL_BEAN, new ScheduleScanGlobalBean());
			NSActionUtil.setNoFailedAlert(request);
			NSException nse = new NSException();
			nse.setErrorCode(ERRCODE_GET_INFO);
			throw nse;
		}

		return mapping.findForward("globalsettop");
	}

	public ActionForward checkConnection(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String vComputerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);
		try {
			String flag = ScheduleScanHandler.haveSmbConnection(nodeNo,
					domainName, vComputerName);

			if (flag.equals(CONST_SCHEDULESCAN_YES)) {
				setRequestAttribute(request, nodeNo, domainName, vComputerName);
				request.setAttribute(CONST_REQUEST_HAVE_CONNECTION,
						CONST_SCHEDULESCAN_YES);
				return mapping.findForward("globalsettop");
			}
		} catch (NSException nse) {
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		} catch (Exception e) {
			NSException nse = new NSException();
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		}

		return set(mapping, form, request, response);
	}

	public ActionForward set(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm globalForm = (DynaActionForm) form;

		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) NSActionUtil.getSessionAttribute(request,
				SESSION_SCHEDULESCAN_DOMAINNAME);
		String computerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_COMPUTERNAME);
		String vComputerName = (String) NSActionUtil.getSessionAttribute(
				request, SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME);

		ScheduleScanGlobalBean globalBean = (ScheduleScanGlobalBean) globalForm
				.get(CONST_FORM_GLOBAL_BEAN);

		String scanServer = globalBean.getScanServer();
		String selectedInterfaces = globalBean.getSelectedInterfaces();
		String selectedUsers = globalBean.getSelectedUsers();
		String shouldRestart = globalForm.getString(CONST_FORM_SHOULD_RESTART);

		try {
			setRequestAttribute(request, nodeNo, domainName, vComputerName);
			ScheduleScanHandler.setGlobalInfo(nodeNo, domainName, computerName,
					vComputerName, selectedInterfaces, selectedUsers,
					scanServer, shouldRestart);

			NSActionUtil.setSuccess(request);
		} catch (NSException nse) {
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		} catch (Exception e) {
			NSException nse = new NSException();
			nse.setErrorCode(ERRCODE_SET_INFO);
			throw nse;
		}

		return mapping.findForward("globalsettop");
	}

	private void setRequestAttribute(HttpServletRequest request, int nodeNo,
			String domainName, String vComputerName) throws Exception {

		String[] interfaces = ScheduleScanHandler.getAllInterfaces(nodeNo,
				domainName, vComputerName);
		String[] allUser = ScheduleScanHandler.getAllUsers(nodeNo, domainName,
				vComputerName);
		if (!interfaces[0].matches("\\s*")) {
			String[] allInterfaces = interfaces[0].split("\\s+");
			String[] allInterfacesLabel = interfaces[1].split("\\s+");

			request.setAttribute(CONST_REQUEST_ALL_INTERFACES, allInterfaces);
			request.setAttribute(CONST_REQUEST_ALL_INTERFACES_LABEL,
					allInterfacesLabel);
		}

		request.setAttribute(CONST_REQUEST_ALL_USERS, allUser);
	}
}
