/*
 *      Copyright (c) 2005-2008 NEC Corporation
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
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;

public class FilesystemMoveShowAction extends  Action implements VolumeActionConst{
    private static final String cvsid = "@(#) $Id: FilesystemMoveShowAction.java,v 1.3 2008/07/02 03:53:15 xingyh Exp $Exp $";
    
    public ActionForward execute(ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) 
        throws Exception {
        
        // get source mount point info for move page      
        VolumeInfoBean fsInfo = (VolumeInfoBean)((DynaValidatorForm)form).get("fsInfo");
        if ((fsInfo != null) && (fsInfo.getVolumeName() != null) 
                             && (!fsInfo.getVolumeName().equals(""))) {
            NSActionUtil.setSessionAttribute(request, VOLUME_INFO_VOLUME_NAME, fsInfo.getVolumeName()); 
        } 
        
        //check the specified volume is paired or not when volume is RV
        String volName = (String)NSActionUtil.getSessionAttribute(request, VOLUME_INFO_VOLUME_NAME);
        if (!volName.startsWith("NV_LVM_")) {
        	DdrHandler.isPaired(volName);
        } 
        
        // check before mount point move 
        String srcMountPoint = fsInfo.getMountPoint(); 
        int nodeNo           = NSActionUtil.getCurrentNodeNo(request);
        FilesystemHandler.checkBeforeMove(srcMountPoint, nodeNo);
        
        return mapping.findForward("forwardToMove"); 
    }
}