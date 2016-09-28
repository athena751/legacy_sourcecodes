/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.filesystem;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.action.volume.VolumeAddShowAction;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.volume.VolumeHandler;

public class FilesystemExtendShowAction extends  Action implements VolumeActionConst,FilesystemConst {
    private static final String cvsid = "@(#) $Id: FilesystemExtendShowAction.java,v 1.7 2008/05/24 12:10:18 liuyq Exp $Exp $";
    
    public ActionForward execute(ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) 
        throws Exception {
        
        boolean  isNashead = NSActionUtil.isNashead(request);
        int nodeNo         = NSActionUtil.getCurrentNodeNo(request); 
        // get FS info for extend top frame
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        VolumeInfoBean fsInfo = (VolumeInfoBean)dynaForm.get("fsInfo");
        if ((fsInfo != null) && (fsInfo.getVolumeName() != null) 
                             && (!fsInfo.getVolumeName().equals(""))) {
            NSActionUtil.setSessionAttribute(request, SESSION_FS_INFO_OBJ, fsInfo);
            NSActionUtil.setSessionAttribute(request, VOLUME_INFO_VOLUME_NAME, fsInfo.getVolumeName()); 
        } else {
            dynaForm.set("fsInfo", NSActionUtil.getSessionAttribute(request, SESSION_FS_INFO_OBJ));
        } 
      
        VolumeInfoBean fsInfo_session =(VolumeInfoBean)NSActionUtil.getSessionAttribute(request, SESSION_FS_INFO_OBJ);
        String mountPoint = fsInfo_session.getMountPoint();
        String hasSnapshot = VolumeHandler.hasSnapshotSet(mountPoint, nodeNo);
        String hasReplication = VolumeHandler.isSyncFS(mountPoint,nodeNo);
        
        // get free LD 
        LicenseInfo license = LicenseInfo.getInstance();
        if (isNashead) {
            String hasGfsLicense =
                        license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
            NSActionUtil.setSessionAttribute(request, "hasGfsLicense", hasGfsLicense);
            NSActionUtil.setSessionAttribute(request, "isNashead", "true");
        } else {
            NSActionUtil.setSessionAttribute(request, "isNashead", "false");
        }

        String from = request.getParameter("from");
        if (from != null && from.equals("list")) {
            FilesystemHandler.checkBeforeExtend(fsInfo.getMountPoint(), nodeNo);    
        }
        
        FilesystemHandler filesystemHandler = new FilesystemHandler();
        String usage = VolumeActionConst.CONST_DISPLAYMVLUN;
        if(hasReplication.equalsIgnoreCase("yes")){
            usage = VolumeActionConst.CONST_NOTDISPLAYMVLUN;
        }
        Vector freeLdVector = filesystemHandler.getFreeLd(isNashead, nodeNo , usage);
        
        // store free LD info in session         
        if ((freeLdVector != null) && (freeLdVector.size() > 0)) {
            SortTableModel tableMode = new ListSTModel(freeLdVector);
            NSActionUtil.setSessionAttribute(request, SESSION_FREELD_TABLE_MODEL, tableMode);
        } else {
            NSActionUtil.setSessionAttribute(request, SESSION_FREELD_TABLE_MODEL, null);
        }
        // add license capacity check for procyon by jiangfx, 2007.7.5
        VolumeAddShowAction.setLicenseChkSession(request);
       
        NSActionUtil.setSessionAttribute(request, "hasSnapshot", hasSnapshot);
        NSActionUtil.setSessionAttribute(request, "hasReplication", hasReplication);

        return mapping.findForward("forwardToExtend"); 
    }
}