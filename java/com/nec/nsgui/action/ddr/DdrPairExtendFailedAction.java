/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.volume.VolumeAddShowAction;
import com.nec.nsgui.model.entity.ddr.DdrExtendPairBean;

public class DdrPairExtendFailedAction
    extends Action
    implements DdrActionConst {
	private static final String cvsid = "@(#) $Id: DdrPairExtendFailedAction.java,v 1.1 2008/05/04 05:05:56 yangxj Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    	
    	DynaActionForm dynaForm = (DynaActionForm)form;
    	String mvName = ((DdrExtendPairBean)dynaForm.get("mvInfo")).getName();
		request.getSession().setAttribute(SESSION_MV_NAME, mvName);
		// mvAllowableSize unit is GB
		String allowableSize = (String)request.getParameter("mvAllowableSize");
		request.setAttribute("mvAllowableSize", allowableSize);
		String hasSnapshot = (String)request.getParameter("mvHasSnapshot");
		request.setAttribute("mvHasSnapshot", hasSnapshot);
		
		String rv0Name = ((DdrExtendPairBean)dynaForm.get("rv0Info")).getName();
		if(rv0Name.equals("")){
			request.setAttribute("existRv0Info", "no");
		}else{
			request.setAttribute("existRv0Info", "yes");
		}
		String rv1Name = ((DdrExtendPairBean)dynaForm.get("rv1Info")).getName();
		if(rv1Name.equals("")){
			request.setAttribute("existRv1Info", "no");
		}else{
			request.setAttribute("existRv1Info", "yes");
		}
		String rv2Name = ((DdrExtendPairBean)dynaForm.get("rv2Info")).getName();
		if(rv2Name.equals("")){
			request.setAttribute("existRv2Info", "no");
		}else{
			request.setAttribute("existRv2Info", "yes");
		}
		VolumeAddShowAction.setLicenseChkSession(request);
		return mapping.findForward("pairExtendTop");
    }
}
