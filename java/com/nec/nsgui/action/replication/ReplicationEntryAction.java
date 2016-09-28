/*
 *      Copyright (c) 2005-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

public class ReplicationEntryAction extends Action implements ReplicationActionConst {
    private static String cvsid = "@(#) $Id: ReplicationEntryAction.java,v 1.3 2006/02/24 03:17:08 wangzf Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        // check replication license
        LicenseInfo licence = LicenseInfo.getInstance();
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        
        if (licence.checkAvailable(nodeNo, "mvdsync") == 0) {
            request.setAttribute("licenseKey", "mvdsync");
            return mapping.findForward("noLicense");
        }
        
       // nsadmin
        String module = (String)(request.getAttribute("module"));
        String from   = (String)(request.getAttribute("from"));
        // if come from volume or filesystem, get volume info 
        if ((module != null) && (from != null)) {
            NSActionUtil.setSessionAttribute(request, "module", module);
            VolumeInfoBean volumeInfo = new VolumeInfoBean();
            
            if (from.equals("volume")) {
                volumeInfo.setVolumeName(request.getParameter("volumeInfo.volumeName"));
                volumeInfo.setMountPoint(request.getParameter("volumeInfo.mountPoint"));
                volumeInfo.setFsType(request.getParameter("volumeInfo.fsType"));
            } else {
                String volumeName = request.getParameter("fsInfo.lvPath");
                volumeName = volumeName.split("#")[0];
                if (volumeName.startsWith("NV_LVM_")) {
                   volumeName = volumeName.replaceFirst("NV_LVM_","");
                }
                volumeInfo.setVolumeName(volumeName);
                volumeInfo.setMountPoint(request.getParameter("fsInfo.mountPoint"));
                volumeInfo.setFsType(request.getParameter("fsInfo.fsType"));                
            }
            
            NSActionUtil.setSessionAttribute(request, SESSION_VOLUME_INFO_4REPLI, volumeInfo);
        } else {
            // modify for LUN initialization:  get adminTarget, then set it to session
            
            HttpSession session = request.getSession();
            String target=request.getParameter("target");
            String targetSession=(String)session.getAttribute("target");
            if(target!=null){
                if( (targetSession==null) || (!target.equals(targetSession)) ) {
                    session.setAttribute("clusterMyNum", null);
                }
                session.setAttribute("target", target);
            }
            
            NSActionUtil.setSessionAttribute(request, "module", "original");    
        }
              
        if (NSActionUtil.isNsview(request)) {
            return mapping.findForward("replicationEntry4Nsview");
        } else {
            return mapping.findForward("replicationEntry4Nsadmin");   
        }
         
    }    
}