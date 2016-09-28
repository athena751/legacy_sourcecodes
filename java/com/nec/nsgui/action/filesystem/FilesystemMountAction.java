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

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;


import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.volume.VolumeActionConst;
/**
 * @author Zhangjx
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class FilesystemMountAction extends DispatchAction implements FilesystemConst{
	public static final String cvsid =
		"@(#) $Id: FilesystemMountAction.java,v 1.6 2008/04/20 10:17:26 jiangfx Exp $";

	public ActionForward display(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response)
	throws Exception { 			
		VolumeInfoBean fsInfo = (VolumeInfoBean)((DynaValidatorForm)form).get("fsInfo");
		NSActionUtil.setSessionAttribute(request,VolumeActionConst.VOLUME_INFO_VOLUME_NAME,fsInfo.getVolumeName());
		NSActionUtil.setSessionAttribute(request, SESSION_IS_PAIRED, "false");
		
		try{
			FilesystemHandler.checkBeforMount(fsInfo.getMountPoint(),NSActionUtil.getCurrentNodeNo(request));
	        //check the specified volume is paired or not when volume is RV
	        String volName = fsInfo.getVolumeName();
	        if (!volName.startsWith("NV_LVM")) {
	        	DdrHandler.isPaired(volName);
	        } 
		} catch (NSException e){
			if(e.getErrorCode().equals(ERR_IS_PAIRED)){
				NSActionUtil.setSessionAttribute(request, SESSION_IS_PAIRED, "true");
			} else if(e.getErrorCode().equals(ERR_CODE_HAS_MOUNTED)){
				//the corresponding volume is has been mounted
				String alertMessage = getResources(request).getMessage(
								      request.getLocale(),
								      "msg.alert.has.mounted");
				NSActionUtil.setSessionAttribute(request,NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,alertMessage);	
				return mapping.findForward("fsList");			
			}else{
				throw e;
			}
		}
        
        LicenseInfo license = LicenseInfo.getInstance();
        boolean isNashead = NSActionUtil.isNashead(request);
        if (isNashead) {
            String hasGfsLicense = license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
            request.setAttribute("hasGfsLicense", hasGfsLicense); 
            request.setAttribute("isNashead", "true");
        } else {
            request.setAttribute("isNashead", "false");
        }
        
	    return mapping.findForward("mountShow");
	}
   
	public ActionForward mount(ActionMapping mapping,
							 ActionForm form,
							 HttpServletRequest request,
							 HttpServletResponse response)
	throws Exception { 	
		VolumeInfoBean fsInfo = (VolumeInfoBean)((DynaValidatorForm)form).get("fsInfo");

        String isPaired = (String)NSActionUtil.getSessionAttribute(request, SESSION_IS_PAIRED);
        if (isPaired.equals("true")) {
        	// get option's value from request 
        	String quota = (String)request.getParameter("oldQuota");
        	String noatime = (String)request.getParameter("oldNoatime");
        	String replication = (String)request.getParameter("oldRepli");
        	String norecovery = (String)request.getParameter("oldNorecovery");
        	String useGfs = (String)request.getParameter("oldUseGfs");
        	String accessMode = (String)request.getParameter("oldAccessMode");

        	// set option's vale to fsInfo
            fsInfo.setQuota(Boolean.valueOf(quota));
            fsInfo.setNoatime(Boolean.valueOf(noatime));
            fsInfo.setReplication(Boolean.valueOf(replication));
            fsInfo.setNorecovery(Boolean.valueOf(norecovery));
        	fsInfo.setUseGfs(useGfs); 
        	fsInfo.setAccessMode(accessMode);
        }
      
		FilesystemHandler.mountFS(fsInfo,NSActionUtil.getCurrentNodeNo(request));
		NSActionUtil.setSessionAttribute(request,NSActionConst.SESSION_SUCCESS_ALERT,"true");
		return mapping.findForward("mountSuccess");
	}	 
}