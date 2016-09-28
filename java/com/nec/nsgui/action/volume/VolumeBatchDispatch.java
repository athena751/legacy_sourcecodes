/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;


/**
 *
 */
public class VolumeBatchDispatch extends DispatchAction{
    private static final String     cvsid = "@(#) $Id: VolumeBatchDispatch.java,v 1.4 2007/07/09 06:04:51 jiangfx Exp $";
    
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {
            
	        // add license capacity check for procyon by jiangfx, 2007.7.5
	        VolumeAddShowAction.setLicenseChkSession(request);
        
    		if(NSActionUtil.isNashead(request)){
                return mapping.findForward("volumeList");
            }else{
                return mapping.findForward("volumepoolinfolist");
            }
        }
}
