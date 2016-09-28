/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.ddr.DdrActionConst;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.biz.replication.ReplicaHandler;
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

import com.nec.nsgui.model.biz.volume.VolumeHandler;

/**
 * 
 *
 */
public class ReplicaListAction extends DispatchAction implements ReplicationActionConst,VolumeActionConst {
    private static final String cvsid = "@(#) $Id: ReplicaListAction.java,v 1.10 2008/04/26 08:05:49 pizb Exp $";
        
    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        // forward replica create page if come from volume or filesystem
        VolumeInfoBean volumeInfo =
            (VolumeInfoBean) request.getSession().getAttribute(
                ReplicationActionConst.SESSION_VOLUME_INFO_4REPLI);
        if (volumeInfo != null) { //from volume
            return mapping.findForward("replicaCreate");
        }
        
        // get replica info
        String exportGroup = NSActionUtil.getExportGroupPath(request);
        int    nodeNo      = NSActionUtil.getCurrentNodeNo(request);
        
        ReplicaHandler replicaHandler = new ReplicaHandler();
        List replicaInfoList = replicaHandler.getReplicaInfo(exportGroup, nodeNo);
        request.setAttribute("replicaInfoList", replicaInfoList);
        NSActionUtil.setSessionAttribute(request, "asyncReplica", "false");
        NSActionUtil.setSessionAttribute(request, "asyncErr", "false");
        if(!NSActionUtil.isNashead(request)) {
            for (int i = 0; i < replicaInfoList.size(); i++) {
                ReplicaInfoBean replicaInfo = (ReplicaInfoBean) replicaInfoList.get(i);
                if (!replicaInfo.getAsyncStatus().equals(SESSION_ASYNC_STATUS_NORMAL)) {
                    NSActionUtil.setSessionAttribute(request, "asyncReplica", "true");
                    if (!replicaInfo.getErrCode().equals(ASYNC_NO_ERROR)) {
                        NSActionUtil.setSessionAttribute(request, "asyncErr", "true");
                        break;                    
                    }
                }
            }
        }

        NSActionUtil.setSessionAttribute(request, "asyncVol", "false"); 
        if (NSActionUtil.isNashead(request)) {
            NSActionUtil.setSessionAttribute(request, "isNashead", "true");
        } else {
            NSActionUtil.setSessionAttribute(request, "isNashead", "false");
            if (!NSActionUtil.isNsview(request)) {
            	String[] asyncInfo = VolumeHandler.getAsyncInfo();
           		String asyncReplica = (String)NSActionUtil.getSessionAttribute(request, "asyncReplica");
               	if ((asyncInfo.length > 0) || asyncReplica.equals("true") || NSActionUtil.hasActiveBatchVolume(request)) {
                	NSActionUtil.setSessionAttribute(request, "asyncVol", "true");
                }
               // judge that whether there is any operation of async pair, add by jiangfx, 2008/4/19.
          	   NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ASYNCPAIR, NSActionUtil.hasAsyncPair(request));
            }
        }
         
        // forward to replica list page        
        if (NSActionUtil.isNsview(request)) {
            return mapping.findForward("replicaList4Nsview");
        } else {
            return mapping.findForward("replicaList4Nsadmin");       
        }
    }
    
    public ActionForward delete(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

            ReplicaInfoBean replicaInfo = (ReplicaInfoBean)((DynaValidatorForm)form).get("replicaInfo");
            String mountPoint = replicaInfo.getMountPoint();
            NSActionUtil.setSessionAttribute(request, SESSION_MOUNT_POINT, mountPoint); 
            
            int nodeNo = NSActionUtil.getCurrentNodeNo(request);

            // delete replica
            ReplicaHandler.delReplica(mountPoint, nodeNo);
            
            // if [Delete the volume] checkbox is checked, delete volume
            if (request.getParameter("delVolumeFlag").equals("true")) {             
                VolumeHandler.delVolume(mountPoint, nodeNo);
                // delete rrd file about  statistic, base on [nsgui-necas-sv4:04165]
                String volumeName = replicaInfo.getVolumeName();
                try{
                    VolumeHandler.deleteRRDFile(volumeName, VOLUME_NAS_LV_IO, nodeNo);
                    VolumeHandler.deleteRRDFile(volumeName, VOLUME_FILE_SYSTEM, nodeNo);
                    VolumeHandler.deleteRRDFile(volumeName, VOLUME_FILE_SYSTEM_QUANTITY, nodeNo);
                } catch (Exception e) {
                }                
            }

            NSActionUtil.setSuccess(request);
            return mapping.findForward("replicaList");       
        }
}