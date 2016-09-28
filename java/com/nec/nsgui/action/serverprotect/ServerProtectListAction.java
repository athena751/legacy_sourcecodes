/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.serverprotect;

import java.util.List;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import com.nec.nsgui.action.cifs.CommonUtil;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;
import com.nec.nsgui.model.entity.serverprotect.ServerProtectGlobalOptionBean;

public class ServerProtectListAction extends Action implements
		ServerProtectActionConst {
	private static final String cvsid = "@(#) $Id: ServerProtectListAction.java,v 1.2 2007/03/23 06:16:17 wanghb Exp $";

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		HttpSession session = request.getSession();
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String domainName = (String) session
				.getAttribute(ServerProtectActionConst.SESSION_SERVERPROTECT_DOMAINNAME);
		String computerName = (String) session
				.getAttribute(ServerProtectActionConst.SESSION_SERVERPROTECT_COMPUTERNAME);
		if (ServerProtectHandler.haveConfigFile(nodeNo, computerName, true)
				.equals("no")) {
			request.setAttribute("haveConfigFile", "no");
		} else {
			ServerProtectGlobalOptionBean globalOption = ServerProtectHandler
					.getGlobalOptionBean(nodeNo, computerName, true);
			List scanServer = ServerProtectHandler.getScanServer4List(nodeNo,
					computerName);
			HashMap connectstatus_key = new HashMap();
			connectstatus_key.put("connect",
					ServerProtectActionConst.MESSAGE_FOR_CONNECTSTATUS_CONNECT);
			connectstatus_key
					.put(
							"disconnect",
							ServerProtectActionConst.MESSAGE_FOR_CONNECTSTATUS_DISCONNECT);
			connectstatus_key.put("",
					ServerProtectActionConst.MESSAGE_FOR_CONNECTSTATUS_ERROR);
			CommonUtil.setMsgInObj(scanServer, "connectStatus",
					connectstatus_key, getResources(request), request);
			List scanTarget = ServerProtectHandler.getScanShareList(nodeNo,
					computerName, true);

			request.setAttribute("haveConfigFile", "yes");
			if (ServerProtectHandler.haveSetCifsGlobal(nodeNo, domainName,
					computerName).equals("yes")) {
				request.setAttribute("cifs_global", "yes");
			} else {
				request.setAttribute("cifs_global", "no");
			}
			request.setAttribute("globalOption", globalOption);
			request.setAttribute("scanServer", scanServer);
			request.setAttribute("scanTarget", scanTarget);
		}
		return mapping.findForward("display");
	}
}
