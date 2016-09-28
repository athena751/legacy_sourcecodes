/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.disk.DiskCommon;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.action.volume.VolumeAddShowAction;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.replication.ReplicaHandler;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.replication.MountPointBean;
import com.nec.nsgui.model.entity.replication.ReplicaInfoBean;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

/**
 *
 */
public class ReplicaCreateShowAction
    extends Action
    implements ReplicationActionConst {
    public static final String cvsid =
        "@(#) $Id: ReplicaCreateShowAction.java,v 1.10 2008/05/28 02:38:46 liy Exp $";

    /* (non-Javadoc)
     * @see org.apache.struts.action.Action#execute(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm inputForm = (DynaValidatorForm) form;
        request.setAttribute(
                    "interfaceVec",
                    getInterfaceVec(NSActionUtil.getCurrentNodeNo(request)));
        request.setAttribute(
            "filesetNameSuffixVec",
            getFilesetNameSuffixVec(getEncoding4Replication(request)));

        VolumeInfoBean volumeInfo =
            (VolumeInfoBean) request.getSession().getAttribute(
            SESSION_VOLUME_INFO_4REPLI);
        // get flag for failed to create replica 
        String errorFlag = (String)request.getParameter("errorFromFlag");
        
        // forward to replica create page after failed to create replica
     	if ((errorFlag != null) && errorFlag.equalsIgnoreCase(ERR_FLAG_FOR_FSorVol)) {
     		return mapping.findForward("fromOthers");
     	}
        
        boolean fromReplication = true;
        ReplicaHandler repliHandler = ReplicaHandler.getInstance();
        if (volumeInfo != null) { //from volume or filesystem
            fromReplication = false;
            ReplicaInfoBean replicaInfo =
                (ReplicaInfoBean) inputForm.get("replicaInfo");
            replicaInfo.setMountPoint(volumeInfo.getMountPoint());
            if (volumeInfo.getFsType().equals("sxfsfw")) {
                inputForm.set(
                    "filesetNameSuffix",
                    volumeInfo.getFsType()
                        + "#"
                        + getEncoding4Replication(request));
            } else {
                inputForm.set(
                    "filesetNameSuffix",
                    volumeInfo.getFsType());
            }
            request.getSession().removeAttribute(SESSION_VOLUME_INFO_4REPLI);
            return mapping.findForward("fromOthers");
        } else { //else from replication
        	// hold the status of format checkbox when failed to create replica
        	if (errorFlag == null) {
        		inputForm.set("format", new Boolean(true));
        	}
        	
            VolumeInfoBean volumeInfoForm =
                            (VolumeInfoBean) inputForm.get("volumeInfo");
            if(volumeInfoForm.getVolumeName() == null || volumeInfoForm.getVolumeName().equals("")){
                volumeInfoForm.setNoatime(new Boolean("true"));
                volumeInfoForm.setQuota(new Boolean("true"));
            } else {
            	volumeInfoForm.setStorage(NSActionUtil.reqStr2EncodeStr(volumeInfoForm.getStorage(),
                                                                        NSActionUtil.BROWSER_ENCODE));	
            }
            String export = NSActionUtil.getExportGroupPath(request);
            request.setAttribute(
                "availVolume",
                getShowAvailVolumeVec(
                    repliHandler.getFreeMP(
                        NSActionUtil.getCurrentNodeNo(request),
                        export,
                        "replica"),
                    export));
            if (NSActionUtil.isNashead(request)) {
                // get license infomation of GFS
                LicenseInfo license = LicenseInfo.getInstance();    
                String hasGfsLicense =
                            (license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0) ? "true" : "false";
                request.setAttribute("hasGfsLicense", hasGfsLicense);                   
                
                request.setAttribute("isNashead", "true");
            } else {
                DiskCommon.setDiskArrayTypeToSession(request);
                request.setAttribute("isNashead", "false");
            }
            request.setAttribute(
                "exportGroup",
                NSActionUtil.getExportGroupPath(request));
            // add license capacity check for procyon by jiangfx, 2007.7.5
            VolumeAddShowAction.setLicenseChkSession(request);
            if(DiskCommon.isCondorLiteSeries(request)){
                NSActionUtil.setSessionAttribute(request, VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES, "true");
            }else{
                NSActionUtil.setSessionAttribute(request, VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES, "false");
            }
            
            NSActionUtil.setSessionAttribute(request, "module4ErrPage", "replication");
            NSActionUtil.setSessionAttribute(request, VolumeActionConst.VOLUME_FLAG_SHOWLUN4SYNCFS, "create4syncfs");
            return mapping.findForward("fromReplication");
        }
    }

    /**
     * @param map
     * @return
     */
    protected Map getShowAvailVolumeVec(List list, String export)
        throws Exception {
        MountPointBean mountPoint;
        Map m = new TreeMap();
        Vector sxfsVolume4Show = new Vector();
        Vector sxfsfwVolume4Show = new Vector();
        m.put("sxfsfw", sxfsfwVolume4Show);
        m.put("sxfs", sxfsVolume4Show);

        if (list == null || list.isEmpty()) {
            return m;
        }
        Iterator it = list.iterator();
        while (it.hasNext()) {
            mountPoint = (MountPointBean) (it.next());
            LabelValueBean labelValueBean =  new LabelValueBean(
                                    mountPoint.getMountPoint().replaceFirst(
                                        export + "/",
                                        ""),
                                    mountPoint.getMountPoint());
            if (mountPoint.getFsType().equals("sxfs")) {
                sxfsVolume4Show.add(labelValueBean);
            } else {
                sxfsfwVolume4Show.add(labelValueBean);
            }
        }
        return m;
    }

    /**
     * @return
     */
    protected Vector getFilesetNameSuffixVec(String encoding)
        throws Exception {
        Vector vec4Show = new Vector();
        vec4Show.add(new LabelValueBean("sxfs", "sxfs"));
        vec4Show.add(
            new LabelValueBean(
                "sxfsfw#" + encoding,
                "sxfsfw#" + encoding));
        return vec4Show;

    }

    /**Not contain item "Not Specified", it must be add in jsp
     * @return
     */
    public static Vector getInterfaceVec(int nodeNum) throws Exception {
        ReplicaHandler repliHandler = ReplicaHandler.getInstance();
        Vector vec4Show = new Vector();
        Vector vec = repliHandler.getInterfaceVec(nodeNum);
        if (vec == null || vec.size() == 0) {
            return vec4Show;
        }
        for (int i = 0; i < vec.size(); i = i + 2) {
            String ip = (String) (vec.get(i));
            String interfaceName = (String) (vec.get(i + 1));
            vec4Show.add(
                new LabelValueBean(ip + "(" + interfaceName + ")", ip));
        }
        return vec4Show;
    }

    // change UTF-8 to UTF8
    public static String getEncoding4Replication(HttpServletRequest request) {
        String encoding = NSActionUtil.getExportGroupEncoding(request);
        
        if (encoding.equals(FrameworkConst.ENCODING_UTF_8)) {
            encoding = FrameworkConst.ENCODING_UTF8;    
        }
        return encoding;
    }
}
