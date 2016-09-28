/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.volume.VolumeHandler;

public class VolumeAddShowAction extends Action implements VolumeActionConst {
    public static final String cvsid =
        "@(#) $Id: VolumeAddShowAction.java,v 1.13 2008/02/25 05:49:12 liy Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        VolumeInfoBean volumeInfo = (VolumeInfoBean) dynaForm.get("volumeInfo");
        if(volumeInfo.getVolumeName() == null || volumeInfo.getVolumeName().equals("")){//from list
            volumeInfo.setNoatime(new Boolean("true"));
            volumeInfo.setQuota(new Boolean("true"));
            volumeInfo.setJournal("standard");
            ((DynaValidatorForm) form).set("volumeInfo" , volumeInfo);
        }else{//from createShow
            volumeInfo.setStorage(NSActionUtil.reqStr2EncodeStr(
                                                        volumeInfo.getStorage(),
                                                        NSActionUtil.BROWSER_ENCODE));
        }
        
        LicenseInfo license = LicenseInfo.getInstance();
        boolean isNashead = NSActionUtil.isNashead(request);
        request.setAttribute(
            "exportGroup",
            NSActionUtil.getExportGroupPath(request));
        if (isNashead) {
            String hasGfsLicense =
                        license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
            request.setAttribute("hasGfsLicense", hasGfsLicense);
            request.setAttribute("isNashead", "true");
        } else {
            request.setAttribute("isNashead", "false");
        }

        // get license infomation of MVD sync
        String hasReplicLicense =
            license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"mvdsync") != 0 ? "true" : "false";
        request.setAttribute("hasReplicLicense", hasReplicLicense);

        // add license capacity check for procyon by jiangfx, 2007.7.5
        setLicenseChkSession(request);
        
        return mapping.findForward("forwardToAddShow");
    }
    
    /** set session according with the license capacity and total volume capacity
     * @param  request
     * @author jiangfx 
     * @since 2007.7.5
     */
    public static void setLicenseChkSession(HttpServletRequest request) throws Exception {
        // add license capacity for procyon
        if (NSActionUtil.isProcyon(request)) {
	        // get license capacity and total filesystem capacity
	        String licenseCap = VolumeHandler.getLicenseCap();
	        String totalFSCap = VolumeHandler.getTotalFSCap();

	        // whether license is nolimit
            if(licenseCap.equals(LICENSE_UNLIMITED)){
            	NSActionUtil.setSessionAttribute(request, SESSION_DISPLAY_LIC_NOLIMIT, "true"); // register nolimit license
            	licenseCap = DOUBLE_HYPHEN;   //no license check
            }else{
                NSActionUtil.setSessionAttribute(request, SESSION_DISPLAY_LIC_NOLIMIT, "false");
            }	        
	        
	        // whether license capacity is exceeded
	        if (!totalFSCap.equals(DOUBLE_HYPHEN) 
	            && !licenseCap.equals(DOUBLE_HYPHEN) 
	            && (Double.parseDouble(totalFSCap) > Double.parseDouble(licenseCap))) {
	        	NSActionUtil.setSessionAttribute(request, SESSION_VOL_LIC_EXCEEDLICENSE, "true");
	        } else {
	        	NSActionUtil.setSessionAttribute(request, SESSION_VOL_LIC_EXCEEDLICENSE, "false");
	        }
	        
	        // set license capacity and total filesystem capacity to request
	        NSActionUtil.setSessionAttribute(request, SESSION_VOL_LIC_LICENSECAP, licenseCap);
	        NSActionUtil.setSessionAttribute(request, SESSION_VOL_LIC_TOTALFSCAP, totalFSCap);
	        NSActionUtil.setSessionAttribute(request, SESSION_MACHINE_PROCYON, "true");
        } else {
        	NSActionUtil.setSessionAttribute(request, SESSION_MACHINE_PROCYON, "false");
        }
    }

}
