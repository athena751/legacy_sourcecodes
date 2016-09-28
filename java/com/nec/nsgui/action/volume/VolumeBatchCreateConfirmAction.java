/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.volume;

import java.util.Vector;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.entity.volume.*;

public class VolumeBatchCreateConfirmAction extends DispatchAction implements VolumeActionConst {
    
    private static final String     cvsid = "@(#) $Id: VolumeBatchCreateConfirmAction.java,v 1.6 2008/05/24 12:12:54 liuyq Exp $";
    
    public ActionForward confirm(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        VolumeInfoBean [] volumes = (VolumeInfoBean [])((DynaActionForm)form).get("volumes");
        
        double specifiedCap = 0;
        VolumeInfoBean [] selectedVolumes;
        if (NSActionUtil.isNashead(request)) {   
            String [] selectOrNot = request.getParameterValues("selectOrNot");
            selectedVolumes = new VolumeInfoBean[selectOrNot.length];  //all selected volumes
            
            int selectStart = 0;
            int i;
            for (i=0 ; i<volumes.length ; i++) {
                if (selectStart == selectOrNot.length) { // all selected volumes have been set into array .
                    break;
                }
                if (i == Integer.parseInt(selectOrNot[selectStart])) {
                    String theReplication = request.getParameter("replication"+i);
                    String theQuota = request.getParameter("quota"+i);
                    String theNoatime = request.getParameter("noatime"+i);
                    String theDmapi = request.getParameter("dmapi"+i);
                    dealWithCheckOption(theReplication , theQuota , theNoatime , theDmapi, volumes[i]);
                    
                    selectedVolumes[selectStart] = volumes[i];
                    selectStart++;
                } else {
                    volumes[i].setLun("");
                }
            }
            for ( ; i<volumes.length ; i++) {
                volumes[i].setLun("");
            }
            
            request.setAttribute("volume_machineType" , "nashead");
        } else { // not nashead
            Vector tempVolumes = new Vector();
            for (int i=0 ; i<volumes.length ; i++) {
                if (volumes[i].getPoolNo() != "") {
                    String theReplication = request.getParameter("replication"+i);
                    String theQuota = request.getParameter("quota"+i);
                    String theNoatime = request.getParameter("noatime"+i);
                    String theDmapi = request.getParameter("dmapi"+i);
                    dealWithCheckOption(theReplication , theQuota , theNoatime , theDmapi, volumes[i]);
                    
                    tempVolumes.add(volumes[i]);
                }
            }
            
            selectedVolumes = new VolumeInfoBean[tempVolumes.size()];
            
            selectedVolumes = (VolumeInfoBean [])tempVolumes.toArray(selectedVolumes);
            /*for (int i=0 ; i<tempVolumes.size() ; i++) {
                selectedVolumes[i] = (VolumeInfoBean)tempVolumes.get(i); 
            }*/
            
            request.setAttribute("volume_machineType" , "nas");
        }
        
        ((DynaActionForm)form).set("volumes" , volumes);
        
        
        //add export group into mountpoint
        String eg = NSActionUtil.getExportGroupPath(request);
        for (int i=0 ; i<selectedVolumes.length ; i++) {
            String theMountPoint = selectedVolumes[i].getMountPoint();
            theMountPoint = eg + "/" + theMountPoint;
            theMountPoint = theMountPoint.replaceAll("\\/+" , "/");
            
            if (theMountPoint.charAt(theMountPoint.length() - 1) == '/') {
                theMountPoint = theMountPoint.substring(0 , theMountPoint.length() - 1);
            }
            
            selectedVolumes[i].setMountPoint(theMountPoint);
            // get the specified capacity, add by jiangfx, 2007.7.5
            specifiedCap += Double.parseDouble(selectedVolumes[i].getCapacity());
        }

        // get license capacity, total volume capacity, add by jiangfx, 2007.7.5
        request.setAttribute("volumeLicense_exceed" , "false");
        if (NSActionUtil.isProcyon(request)) {
	        String licenseCap = (String)NSActionUtil.getSessionAttribute(request, SESSION_VOL_LIC_LICENSECAP);
	        String totalFSCap = (String)NSActionUtil.getSessionAttribute(request, SESSION_VOL_LIC_TOTALFSCAP);
	
	        // set flag whether license is exceeded, add by jiangfx, 2007.7.5
	        if (!totalFSCap.equals(DOUBLE_HYPHEN) 
		        && !licenseCap.equals(DOUBLE_HYPHEN) 
		        && (Double.parseDouble(totalFSCap) <= Double.parseDouble(licenseCap)) 
	        	&& (specifiedCap + Double.parseDouble(totalFSCap)) > Double.parseDouble(licenseCap)) {
	        	request.setAttribute("volumeLicense_exceed" , "true");
	        }
        }
        
        Vector confirmVolumes = VolumeHandler.confirmSelectedVolumes(selectedVolumes, NSActionUtil.getCurrentNodeNo(request), NSActionUtil.isNashead(request));
        
        boolean confirmHasErr = false;
        for (int i=0 ; i<confirmVolumes.size() ; i++) {
            VolumeInfoConfirmBean volumeInfoConfirm = (VolumeInfoConfirmBean)confirmVolumes.get(i);
            
            if (volumeInfoConfirm.isUsePairedLd4Syncfs()) {
                request.setAttribute("volume_confirmError" , "UsePairedLds4SyncfsError");
                confirmHasErr = true;
                break;
            }
            
            if (volumeInfoConfirm.getVolumeNameExist()) {
                request.setAttribute("volume_confirmError" , "volumeSameNameError");
                confirmHasErr = true;
                break;
            }
            
            if (volumeInfoConfirm.getMPNameExist()) {
                request.setAttribute("volume_confirmError" , "MPSameNameError");
                confirmHasErr = true;
                break;
            }
            
            if (Integer.parseInt(volumeInfoConfirm.getMPErrorCode()) != 0) {
                request.setAttribute("volume_confirmError" , "mpError");
                confirmHasErr = true;
                break;
            }
        }
        
        
        if (!confirmHasErr) {
            request.setAttribute("volume_confirmError" , "none");
        }
        
        request.setAttribute("volume_confirmVolumes" , confirmVolumes);
        return mapping.findForward("success");   
    }

    public ActionForward specifyConfirm(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {

        String volBase = (String)request.getParameter("volBase");
        String mpBase = (String)request.getParameter("mpBase");
        String fsType = (String)request.getParameter("fsType");
        
        VolumeInfoBean vib = new VolumeInfoBean();
        vib.setVolumeName(volBase);
        String mountPoint = (String)request.getSession().getAttribute("volume_exportgroup")+ "/" + mpBase;
        mountPoint = mountPoint.replaceAll("\\/+" , "/");
        vib.setMountPoint(mountPoint);
        vib.setFsType(fsType);
        

        VolumeInfoConfirmBean volumeInfoConfirm = VolumeHandler.confirmSelectedVolumes(vib, NSActionUtil.getCurrentNodeNo(request));        
        boolean confirmHasErr = false;

        if (volumeInfoConfirm.getVolumeNameExist()) {
            request.setAttribute("volume_confirmError" , "volumeSameNameError");
            confirmHasErr = true;
        }
        
        if (volumeInfoConfirm.getMPNameExist()) {
            request.setAttribute("volume_confirmError" , "MPSameNameError");
            confirmHasErr = true;
        }
        
        if (Integer.parseInt(volumeInfoConfirm.getMPErrorCode()) != 0) {
            request.setAttribute("volume_confirmError" , "mpError");
            confirmHasErr = true;
        }

        
        if (!confirmHasErr) {
            request.setAttribute("volume_confirmError" , "none");
        }

        
        // get license capacity, total volume capacity and the specified capacity, add by jiangfx, 2007.7.5
        request.setAttribute("volumeLicense_exceed" , "false");
        if (NSActionUtil.isProcyon(request)) {
	        String licenseCap = (String)NSActionUtil.getSessionAttribute(request, SESSION_VOL_LIC_LICENSECAP);
	        String totalFSCap = (String)NSActionUtil.getSessionAttribute(request, SESSION_VOL_LIC_TOTALFSCAP);
	        
	        String volNum = (String)request.getParameter("volNumValue");
	        String capacity = (String)request.getParameter("capacityValue");
	        String unit = (String)request.getParameter("unitValue");
	        
	        double specifiedCap = Double.parseDouble(volNum) * Double.parseDouble(capacity);
	        if (unit.equalsIgnoreCase(VolumeActionConst.UNIT_TB)) {
	        	specifiedCap *= 1024;
	        }

	        // set flag whether license is exceeded, add by jiangfx, 2007.7.5
	        if (!totalFSCap.equals(DOUBLE_HYPHEN) 
			    && !licenseCap.equals(DOUBLE_HYPHEN) 
			    && (Double.parseDouble(totalFSCap) <= Double.parseDouble(licenseCap)) 
	        	&& (specifiedCap + Double.parseDouble(totalFSCap)) > Double.parseDouble(licenseCap)) {
	        	request.setAttribute("volumeLicense_exceed" , "true");
	        }
        }
        
        NSActionUtil.setSessionAttribute(request, "volume_confirmVolume" , volumeInfoConfirm);
        NSActionUtil.setSessionAttribute(request, "volNum", (String)request.getParameter("volNumValue"));
        NSActionUtil.setSessionAttribute(request, "capacity", (String)request.getParameter("capacityValue"));
        NSActionUtil.setSessionAttribute(request, "unit", (String)request.getParameter("unitValue"));
        NSActionUtil.setSessionAttribute(request, "quota", (String)request.getParameter("quota"));
        NSActionUtil.setSessionAttribute(request, "atime", (String)request.getParameter("atime"));
        NSActionUtil.setSessionAttribute(request, "replication", (String)request.getParameter("replication")==null?"":(String)request.getParameter("replication"));
              
        return mapping.findForward("specifySuccess"); 
    }
    
    private void dealWithCheckOption(String replication , String quota , String noatime , String dmapi, VolumeInfoBean volume) {
        if (replication == null) {
            volume.setReplication(new Boolean(false));
        } else {
            volume.setReplication(new Boolean(true));
        }
                    
        if (quota == null) {
            volume.setQuota(new Boolean(false));
        } else {
            volume.setQuota(new Boolean(true));
        }
                    
        if (noatime == null) {
            volume.setNoatime(new Boolean(false));
        } else {
            volume.setNoatime(new Boolean(true));
        }
        
        if (dmapi == null) {
            volume.setDmapi(new Boolean(false));
        } else {
            volume.setDmapi(new Boolean(true));
        }
    }
}