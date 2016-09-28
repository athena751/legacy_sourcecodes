/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.serverprotect;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.*;
import org.apache.struts.actions.*;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;

public class ServerProtectFileAction extends DispatchAction implements
		ServerProtectActionConst, NSActionConst {
	private static final String cvsid = "@(#) $Id: ServerProtectFileAction.java,v 1.5 2007/03/23 05:04:06 liy Exp $";

	public ActionForward readVrscanFile(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		int groupNumber = NSActionUtil.getCurrentNodeNo(request);
		HttpSession session = request.getSession();
		String domainName = (String) session.getAttribute(SESSION_SERVERPROTECT_DOMAINNAME);
		String computerName = (String) session.getAttribute(SESSION_SERVERPROTECT_COMPUTERNAME);
		String[] serverProtectInfo = ServerProtectHandler.readVrscanFile(
				groupNumber, domainName, computerName);
		// transfer the content of nvavs's configure file to string
		StringBuffer strBuf = new StringBuffer();
		if (serverProtectInfo.length > 0) {
			strBuf.append(serverProtectInfo[0]);
			for (int i = 1; i < serverProtectInfo.length; i++) {
				strBuf.append("\n");
				strBuf.append(serverProtectInfo[i]);
			}
		}
		// set the content of nvavs's configure file to directEditForm
		DynaActionForm directEditForm = (DynaActionForm) form;
		directEditForm.set("fileContent",NSActionUtil.perl2Page(strBuf.toString(), request));
		setHasConfigFileFlag(groupNumber, computerName, request);
			
		// forward to page for nsview or nsadmin
		if (NSActionUtil.isNsview(request)) {
			return mapping.findForward("serverProtectFileToNsview");
		} else {
			// set flag for if config file exists
			return mapping.findForward("serverProtectFileToNsadmin");
		}
	}

	public ActionForward writeVrscanFile(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// get groupNumber and content of the textarea
		int groupNumber = NSActionUtil.getCurrentNodeNo(request);
		DynaActionForm fileForm = (DynaActionForm) form;
		String content = (String) fileForm.get("fileContent");
		String contentForDisplay = NSActionUtil.reqStr2EncodeStr(content,
				BROWSER_ENCODE);
		fileForm.set("fileContent", contentForDisplay);
		HttpSession session = request.getSession();
		String domainName = (String)session.getAttribute(SESSION_SERVERPROTECT_DOMAINNAME);
		String computerName = (String)session.getAttribute(SESSION_SERVERPROTECT_COMPUTERNAME);

		// set flag for do not display alert when load the info of config file
		request.setAttribute(REQUEST_NOWARNING, "true");

		// write content to configure file and get error information
		try {
			ServerProtectHandler.writeVrscanFile(groupNumber, domainName,
					computerName,NSActionUtil.page2Perl(content, request));
			NSActionUtil.setSuccess(request);
			} catch (NSException e) {
			if (e.getErrorCode().equals(ERR_EXEC_NVAVS_CONFIG)) {
				String errorInfo = e.getDetail();
				String[] info = errorInfo.split("\n");
				request.setAttribute(REQUEST_ERRORINFO, info);
				request.setAttribute(REQUEST_DOFAILEDALERT,"true");
				setHasConfigFileFlag(groupNumber, computerName, request);
				return mapping.findForward("serverProtectFileToNsadmin");
			} else {
				throw e;
			}
		}
		return mapping.findForward("serverProtectFileReloadNsadmin");
	}

	public ActionForward deleteVrscanFile(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// get groupNumber and content of the textarea
		int groupNumber = NSActionUtil.getCurrentNodeNo(request);
		HttpSession session = request.getSession();
		String computerName = (String)session.getAttribute(SESSION_SERVERPROTECT_COMPUTERNAME);
		// set flag for do not display alert when load the info of config file
		request.setAttribute(REQUEST_NOWARNING, "true");
		ServerProtectHandler.deleteVrscanFile(groupNumber, computerName);
		NSActionUtil.setSuccess(request);
		return mapping.findForward("serverProtectFileReloadNsadmin");
	}
	
       // set flag for if config file exists
	private void setHasConfigFileFlag(int groupNumber, String computerName,
			HttpServletRequest request) throws Exception {
		
		if (ServerProtectHandler.haveConfigFile(groupNumber, computerName,true)
				.equals("yes")) {
			NSActionUtil.setSessionAttribute(request, SESSION_HASCONFIGFILE,
					"true");
		} else {
			NSActionUtil.setSessionAttribute(request, SESSION_HASCONFIGFILE,
					null);
		}
	}
}
