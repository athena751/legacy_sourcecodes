/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.filesystem;

import java.util.Vector;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.actions.DispatchAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;


import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.filesystem.FilesystemHandler;
import com.nec.nsgui.model.entity.filesystem.*;

import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.action.volume.VolumeAddShowAction;
/**
 * @author Zhangjx
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class FilesystemAddAction extends DispatchAction implements FilesystemConst{
	public static final String cvsid =
		"@(#) $Id: FilesystemAddAction.java,v 1.6 2007/07/09 07:38:38 jiangfx Exp $";

	public ActionForward display(ActionMapping mapping,
							     ActionForm form,
							     HttpServletRequest request,
							     HttpServletResponse response)
	throws Exception { 	
	   DynaValidatorForm thisForm = (DynaValidatorForm)form;
	   FilesystemInfoBean fsInfo = (FilesystemInfoBean)thisForm.get("fsInfo");
	   if (fsInfo.getLvPath()==null || fsInfo.getLvPath().equals("")){
	   		fsInfo.setQuota(new Boolean("true"));
	   		fsInfo.setFormat(new Boolean("true"));
		    fsInfo.setUpdateAccessTime(new Boolean("true"));
	   }
	   int nodeNum = NSActionUtil.getCurrentNodeNo(request);
	   Vector freeLvVec = FilesystemHandler.getFreeLvVec(nodeNum);
	   Collections.sort(freeLvVec,new Comparator() {
	   	public int compare(Object a, Object b){
        FreeLvInfoBean lv1 = (FreeLvInfoBean)a;
        FreeLvInfoBean lv2 = (FreeLvInfoBean)b;
        return lv1.getValue4Show().compareTo(lv2.getValue4Show());
        }
	   });
	   request.setAttribute(SESSION_FREE_LV_VEC,freeLvVec);	
	   LicenseInfo license = LicenseInfo.getInstance();
	   String hasReplicLicense =
	   		 license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"mvdsync") != 0 ? "true" : "false";
	   request.setAttribute("hasReplicLicense", hasReplicLicense);
	   
       boolean isNashead = NSActionUtil.isNashead(request);
       if (isNashead) {
           String hasGfsLicense =
                       license.checkAvailable(NSActionUtil.getCurrentNodeNo(request),"gfs") != 0 ? "true" : "false";
           request.setAttribute("hasGfsLicense", hasGfsLicense);
           request.setAttribute("isNashead", "true");
       } else {
           request.setAttribute("isNashead", "false");
       }
       
       // add license capacity check for procyon by jiangfx, 2007.7.5
       VolumeAddShowAction.setLicenseChkSession(request);
       
	   return mapping.findForward("addShow");
    }
   
    public ActionForward addFS(ActionMapping mapping,
						     ActionForm form,
						     HttpServletRequest request,
						     HttpServletResponse response)
	throws Exception { 	
		DynaValidatorForm thisForm = (DynaValidatorForm)form;
		FilesystemInfoBean fsInfo = (FilesystemInfoBean)thisForm.get("fsInfo");
    NSActionUtil.setSessionAttribute(request, VolumeActionConst.VOLUME_INFO_VOLUME_NAME, fsInfo.getLvPath().split("#")[0]);
		
        try {
            FilesystemHandler.createFS(fsInfo, NSActionUtil.getCurrentNodeNo(request));
        } catch(NSException e) {
            if(e.getErrorCode().equals(ERR_CODE_CODEPAGE_UTF8)){
                String matchineType = (String)NSActionUtil.getSessionAttribute(request, 
        		                                  FrameworkConst.SESSION_MACHINE_SERIES);
                if (matchineType.equals(FrameworkConst.MACHINE_SERIES_PROCYON)) {
                    e.setErrorCode(ERR_CODE_CODEPAGE_UTF8_4Mac);
                }
            }
            throw e;		
        }

        if (fsInfo.getRepli()!=null && (fsInfo.getRepli()).booleanValue()){
            request.setAttribute("from", "filesystem");
            request.setAttribute("module", 
                       fsInfo.getReplicationType().equals("replic") ? "replica" : "original");
            return mapping.findForward("forwardReplication");                                
        }

		NSActionUtil.setSessionAttribute(request,NSActionConst.SESSION_SUCCESS_ALERT,"true");
		return mapping.findForward("fsList");
    }	 
}