/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Vector;
import java.util.Collections;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoConfirmBean;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.action.disk.DiskCommon;
/**
 * volume batch create action
 */
public class VolumeBatchCreateAction
    extends DispatchAction
    implements VolumeActionConst {
    private static final String cvsid =
        "@(#) $Id: VolumeBatchCreateAction.java,v 1.9 2007/09/07 08:39:33 liq Exp $";
    public ActionForward create(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        request.getSession().removeAttribute("volumeBatchCreateForm");
        ServletContext application = request.getSession().getServletContext();
        //if APPLICATION_VOLUME_PROCESS is existed, means the batch config is configuring.
        String statusString = (String)application.getAttribute(APPLICATION_VOLUME_PROCESS);
        if(statusString!=null){
            return mapping.findForward("result");
        }
        VolumeInfoBean[] vVolumes = (VolumeInfoBean[]) ((DynaActionForm) form).get("volumes");
        Vector volumes = new Vector(Arrays.asList(vVolumes));
        //remove the unselected volumes. 
        boolean isNasHead = NSActionUtil.isNashead(request);
        for(int i=0; i<volumes.size(); ){
            VolumeInfoBean volume = (VolumeInfoBean)volumes.get(i);
            volume.setMachineType(isNasHead?"NASHEAD":"NV");
            if((!isNasHead && (volume.getPoolNo() == null || volume.getPoolNo().equals("")))
                || (isNasHead && (volume.getLun() == null || volume.getLun().equals("")))){
                    volumes.remove(i);
            }else{
                volume.setVolumeName("NV_LVM_"+volume.getVolumeName());
                volume.setWwnn(volume.getWwnn()+"("+volume.getLun()+")");
                volume.setStatus("");
                volume.setStatusDetailInfo("");
                //volume.setMountPoint(NSActionUtil.getExportGroupPath(request)+"/"+volume.getMountPoint());
                if(volume.getReplication().booleanValue()){
                    volume.setReplicType("original");
                }
                i++;
            }
        }
        //sort the volumes according to mountpoint
        Collections.sort(volumes, new Comparator() {
            public int compare(Object o1, Object o2) {
                VolumeInfoBean vib1 = (VolumeInfoBean) o1;
                VolumeInfoBean vib2 = (VolumeInfoBean) o2;
                return vib1.getMountPoint().compareTo(vib2.getMountPoint());
            }
        });
        //set the displayed information into application for result page.
        application.setAttribute(APPLICATION_VOLUME_TIP, "msg.create.mountpoint.fine");
        application.setAttribute(
                APPLICATION_VOLUME_CREATE_RESULT_H3,
                "title.create.processing.h3");
        application.setAttribute(
                APPLICATION_VOLUME_PROCESS,
                "msg.create.status.start");
        String nodeNum = ""+NSActionUtil.getCurrentNodeNo(request);
        application.setAttribute(VOLUME_BATCH_CREATE_NODE_NUM, nodeNum);             
        application.setAttribute(
            APPLICATION_VOLUME_VOLUMEINFO,
            volumes);
        //new a thread to do the batch setting            
        new VolumeBatchCreate(
            volumes,
            request,
            NSActionUtil.getCurrentNodeNo(request))
            .start();
        return mapping.findForward("result");
    }
    

    public ActionForward specifyCreate(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        request.getSession().removeAttribute("volumeBatchCreateForm");
        ServletContext application = request.getSession().getServletContext();
        //if APPLICATION_VOLUME_PROCESS is existed, means the batch config is configuring.
        String statusString = (String)application.getAttribute(APPLICATION_VOLUME_PROCESS);
        if(statusString!=null){
            return mapping.findForward("result");
        }

        //VolumeInfoBean[] vVolumes = (VolumeInfoBean[]) ((DynaActionForm) form).get("volumes");
        //Vector volumes = new Vector(Arrays.asList(vVolumes));
        int volNum = Integer.valueOf((String)request.getSession().getAttribute("volNum")).intValue();
        String aid = (String)request.getSession().getAttribute("aid");
        String raidType = (String)request.getSession().getAttribute("raidType");
        Vector pools = (Vector)request.getSession().getAttribute("pools");
        String volBase = ((VolumeInfoConfirmBean)request.getSession().getAttribute("volume_confirmVolume")).getVolumeName();
        String mp = ((VolumeInfoConfirmBean)request.getSession().getAttribute("volume_confirmVolume")).getMountPoint();
        String fsType = ((VolumeInfoConfirmBean)request.getSession().getAttribute("volume_confirmVolume")).getFsType();
        String capacity = (String)request.getSession().getAttribute("capacity");
        String unit = (String)request.getSession().getAttribute("unit");
        if(unit.equals("tb")) {
            capacity = Double.toString(Double.valueOf(capacity).doubleValue()*1024);
        }
        String quota = (String)request.getSession().getAttribute("quota");
        String atime = (String)request.getSession().getAttribute("atime");
        String replication = (String)request.getSession().getAttribute("replication");
        
        StringBuffer sb = new StringBuffer();
        
        for(int i=0; i<pools.size(); i++) {
            if(i != pools.size()-1) {
                sb.append((String)pools.get(i)).append(",");
            } else{
                sb.append((String)pools.get(i));
            }
        }

        Vector volumes = new Vector(volNum);
        for(int i=0; i<volNum; i++) {
            VolumeInfoBean vib = new VolumeInfoBean();
            vib.setMachineType("NV");
            vib.setAid(aid);
            vib.setRaidType(raidType);
            vib.setPoolNo(sb.toString());
            vib.setVolumeName("NV_LVM_" + volBase + "_" + i);
            vib.setCapacity(capacity);
            vib.setMountPoint(mp + "_" + i);
            vib.setFsType(fsType);
            vib.setQuota(new Boolean(quota!=null&&quota.equals("on")));
            vib.setNoatime(new Boolean(atime!=null&&atime.equals("on")));
            vib.setReplication(new Boolean(replication!=null&&replication.equals("on")));
            if(vib.getReplication().booleanValue()){
                vib.setReplicType("original");
            }
            volumes.add(vib);
        }
        
        //set the displayed information into application for result page.
        application.setAttribute(APPLICATION_VOLUME_TIP, "msg.create.mountpoint.fine");
        application.setAttribute(
                APPLICATION_VOLUME_CREATE_RESULT_H3,
                "title.create.processing.h3");
        application.setAttribute(
                APPLICATION_VOLUME_PROCESS,
                "msg.create.status.start");
        String nodeNum = ""+NSActionUtil.getCurrentNodeNo(request);
        application.setAttribute(VOLUME_BATCH_CREATE_NODE_NUM, nodeNum);             
        application.setAttribute(
            APPLICATION_VOLUME_VOLUMEINFO,
            volumes);
        //new a thread to do the batch setting            
        new VolumeBatchCreate(
            volumes,
            request,
            NSActionUtil.getCurrentNodeNo(request))
            .start();
        return mapping.findForward("result");
    }
    
    public ActionForward result(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
                ServletContext application = request.getSession().getServletContext();
                String statusString = (String)application.getAttribute(APPLICATION_VOLUME_PROCESS);
                //if the operation is finished. forward to list
                if (statusString == null){
                    return mapping.findForward("forwardToList");
                }
                //if from volumeList.do
                if(request.getParameter("toResult")!=null){
                    request.setAttribute("fromVolumeList", "fromVolumeList");
                }
                return mapping.findForward("result");
            }
    /*
     * inner class
     * new a thread for creating a batch of volumes.
     */
    class VolumeBatchCreate extends Thread {
        Vector volumes;
        ServletContext application;
        HttpServletRequest request;
        int nodeNum;
        boolean isSSeries;
        public VolumeBatchCreate(
            Vector volumeInfo,
            HttpServletRequest request,
            int num) {
            this.volumes = volumeInfo;
            this.request = request;
            this.application = request.getSession().getServletContext();
            this.nodeNum = num;
            this.isSSeries = DiskCommon.isSSeries(request);
        }
        public void run() {
            //beginning status.
            String finishStatus = "msg.create.status.start";
            String failedMountPoint = null;
            for (int i = 0; i < volumes.size(); i++) {
                VolumeInfoBean volume = (VolumeInfoBean) volumes.get(i);
                //if the super mountpoint is failed, 
                //then the sub mountpoint is failed too.
                if (failedMountPoint!= null && volume
                    .getMountPoint()
                    .startsWith(failedMountPoint)) {
                    volume.setStatus("msg.volume.status.cancel");
                    continue;
                } else {
                    failedMountPoint = null;
                }
                //start to process
                volume.setStatus("msg.volume.status.processing");
                try {
                    VolumeHandler.addVolume(volume, nodeNum, true,isSSeries);
                    volume.setStatus("msg.volume.status.success");
                } catch (Exception e) {
                    //when bug occurred.
                    if (! (e instanceof NSException)){
                        finishStatus = "msg.create.status.break";
                        break;
                    }
                    //analyse error code when error occurred.
                    NSException exception=(NSException)e;  
                    volume.setStatusDetailInfo(exception.getDetail());
                    String errorcode = exception.getErrorCode();
                    if (errorcode.startsWith("0x1080001")
                        || errorcode.startsWith("0x1080004")
                        || errorcode.startsWith("0x1080005")) {
                        volume.setStatus("msg.volume.status.mount.failed");
                    } else if (
                        errorcode.startsWith("0x1080002")
                            || errorcode.startsWith("0x1080006")) {
                        volume.setStatus("msg.volume.status.lv.failed");
                    } else if (
                        errorcode.startsWith("0x1080003")
                            || errorcode.startsWith("0x1080008")) {
                        volume.setStatus("msg.volume.status.ld.failed");
                    } else {
                        volume.setStatus("msg.volume.status.othernode.failed");
                        finishStatus = "msg.create.status.break";
                        break;
                    }
                    failedMountPoint = volume.getMountPoint()+"/";
                }
            }
            //finish the batch setting.
            application.setAttribute(
                APPLICATION_VOLUME_CREATE_RESULT_H3,
                "title.create.result.h3");
            if (!finishStatus.equals("msg.create.status.break")) {
                finishStatus = "msg.create.status.over";
            }
            application.setAttribute(
                APPLICATION_VOLUME_PROCESS,
                finishStatus);
        }   
    }
}
