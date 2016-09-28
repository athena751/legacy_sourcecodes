/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.filesystem;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;

public class FilesystemMoveAction extends  Action {
    private static final String cvsid = "@(#) $Id: FilesystemMoveAction.java,v 1.1 2005/06/10 09:43:23 jiangfx Exp $Exp $";
    
    public ActionForward execute(ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) 
        throws Exception {
        
        // check before mount point move      
        VolumeInfoBean fsInfo = (VolumeInfoBean)((DynaValidatorForm)form).get("fsInfo");
        String mountPointShow = (String)((DynaValidatorForm)form).get("mountPointShow");
        
        String codepage = NSActionUtil.getExportGroupEncoding(request);
        int nodeNo      = NSActionUtil.getCurrentNodeNo(request);
        FilesystemHandler.moveFS(fsInfo, codepage, mountPointShow, nodeNo);
        
        NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_SUCCESS_ALERT, "true");   
        return mapping.findForward("moveSuccess"); 
    }
}