/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.krb5;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.*;
import org.apache.struts.actions.*;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.krb5.Krb5Handler;

public final class Krb5DirectEditAction extends DispatchAction implements
		Krb5ActionConst {

	private static final String cvsid = "@(#) $Id: Krb5DirectEditAction.java,v 1.1 2006/11/06 06:13:55 liy Exp $";

	public ActionForward readKrb5File(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		String[] krb5Info = Krb5Handler.readKrb5File(nodeNo);

		// get differnet flag
		String diffFlag = krb5Info[0];

		// transfer the content of krb5.conf to string
		StringBuffer strBuf = new StringBuffer();
		if (krb5Info.length > 1) {
			strBuf.append(krb5Info[1]);
			for (int i = 2; i < krb5Info.length; i++) {
				strBuf.append("\n");
				strBuf.append(krb5Info[i]);
			}
		}

		// set the string of krb5.conf to directEditForm
		DynaActionForm directEditForm = (DynaActionForm) form;
		directEditForm.set("fileContent", strBuf.toString());

		// if the setting of two node is different
		// set error code to NSException and throw it
		if (diffFlag.equals("1")) {
			NSException ex = new NSException();
			if (NSActionUtil.isNsview(request)) {
				ex.setErrorCode(CONST_ERR_KRB5_DIFF_4NSVIEW);
			} else {
				ex.setErrorCode(CONST_ERR_KRB5_DIFF_4NSADMIN);
			}
			NSActionUtil.setSessionAttribute(request,
					NSActionConst.SESSION_NOFAILED_ALERT, "true");
			throw ex;
		}

		// forward to page for nsview or nsadmin
		if (NSActionUtil.isNsview(request)) {
			return mapping.findForward("krb5ToNsview");
		} else {
			return mapping.findForward("krb5ToNsadmin");
		}
	}

	public ActionForward writeKrb5File(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// set flag for do not display alert when load the info of krb5.conf
		NSActionUtil.setSessionAttribute(request, SESSION_NOWARNING, "true");

		// get nodeNo and content of the textarea
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		DynaActionForm fileForm = (DynaActionForm) form;
		String content = (String) fileForm.get("fileContent");

		// write content to krb5.conf
		try {
			Krb5Handler.writeKrb5File(nodeNo, content);
			NSActionUtil.setSessionAttribute(request,
					NSActionConst.SESSION_SUCCESS_ALERT, "true");
		} catch (NSException e) {
			if (e.getErrorCode().equals(CONST_ERR_FILE_SYNC)) {
				NSActionUtil.setSessionAttribute(request,
						SESSION_SYNC_WRITE_FLAG, CONST_ERR_FILE_SYNC);
			} else {
				throw e;
			}
		}

		
		return mapping.findForward("krb5ListFile");
	}
}
