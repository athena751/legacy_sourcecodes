/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.Action;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;

public class EntryDdrAction extends Action {
	private static final String cvsid = "@(#) $Id: EntryDdrAction.java,v 1.4 2008/04/26 08:58:29 pizb Exp $";
	
	public ActionForward execute(ActionMapping mapping,
			                     ActionForm form,
			                     HttpServletRequest request,
			                     HttpServletResponse response) throws Exception{
        NSActionUtil.setNoFailedAlert(request); 
        
        LicenseInfo licence = LicenseInfo.getInstance();
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        
        if (licence.checkAvailable(nodeNo, "diskrep") == 0) {
            request.setAttribute("licenseKey", "diskrep");
            return mapping.findForward("noLicense");
        }

        if(!NSActionUtil.isNsview(request)){
            // when entry DDR menu, clear the session SESSION_DDR_HAS_VOLSCAN, which means
            // we should execute the volscan again.
            NSActionUtil.removeSessionAttribute(request, DdrActionConst.SESSION_DDR_HAS_VOLSCAN);
            // when entry DDR menu, clear the session SESSION_MV_NAME.
            NSActionUtil.removeSessionAttribute(request, DdrActionConst.SESSION_MV_NAME);
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ISNSVIEW, "false");
        }else{
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ISNSVIEW, "true");
        }

/*        if(NSActionUtil.hasActiveAsyncVolume(request)){
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ACTIVE_SYNCVOL, "true");
        }else{
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ACTIVE_SYNCVOL, "false");
        }*/
        
		return mapping.findForward("entryDdr");
	}
}