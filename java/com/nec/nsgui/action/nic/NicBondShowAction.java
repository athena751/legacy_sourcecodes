/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicBondSetAction.java,v 3.2 2005/06/13 02:01:04 wanghb Exp
 *      
 */
package com.nec.nsgui.action.nic;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;

public class NicBondShowAction extends Action {
	private static final String cvsid = "@(#) NicDetailTopAction.java,v 1.1 2005/08/25 07:37:58 changhs Exp";

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
                NSActionUtil.removeSessionAttribute(request,"selectedRedundantInterface");
		String from = (String) ((DynaActionForm) form).get("from4bond");
		from = (from == null || from.equals("")) ? "list":from;
		NSActionUtil.setSessionAttribute(request, "from4bond", from);
		String bondName = NicHandler.getNewBondName(NSActionUtil
				.getCurrentNodeNo(request));
		NSActionUtil.setSessionAttribute(request, "bondName", bondName);
		Vector nics = NicHandler.getAvaiNicForCreatingBond(NSActionUtil
				.getCurrentNodeNo(request));
		Vector nics4Show = new Vector();
		Vector nics4create = new Vector();
        
		for (int i = 0; i < nics.size(); i++) {
			String[] tmp = ((String) nics.get(i)).split(",");
			nics4create.add(tmp[0]);
			nics4Show.add(tmp[0] + "(" + tmp[1] + ")");
		}
        String havAvailableNic4Bond="true";
        if(nics4create.size() < 2){
            havAvailableNic4Bond = "false";
        }
		NSActionUtil.setSessionAttribute(request, "nics4create", nics4create);
		NSActionUtil.setSessionAttribute(request, "nics4Show", nics4Show);
        NSActionUtil.setSessionAttribute(request, "havAvailableNic4Bond", havAvailableNic4Bond);
		return mapping.findForward("nicBondShow");
	}
}