/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.volume;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

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

public class VolumeDetailAction extends Action {
    public static final String cvsid =
        "@(#) $Id: VolumeDetailAction.java,v 1.12 2008/05/28 09:38:10 jiangfx Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        
        String from = request.getParameter("from");
        VolumeInfoBean volumeInfo;

        if ((from != null) && from.equals("filesystem")) {
            volumeInfo = (VolumeInfoBean) dynaForm.get("fsInfo");    
        } else {
            volumeInfo = (VolumeInfoBean) dynaForm.get("volumeInfo");
        }
 
        // get diskarray name for show
        volumeInfo.setAname(compactAndSort(volumeInfo.getAname()));
        
        // get poolNameAndNo for show
        volumeInfo.setPoolNameAndNo(compactAndSort(volumeInfo.getPoolNameAndNo()));        
               
        // get capacity for show
        volumeInfo.setCapacity(getCapacity4Show(volumeInfo.getCapacity()));
        volumeInfo.setFsSize(getCapacity4Show(volumeInfo.getFsSize()));
        
        volumeInfo.setStorage(
                NSActionUtil.reqStr2EncodeStr(
                    volumeInfo.getStorage(),
                    NSActionUtil.BROWSER_ENCODE));

        NSActionUtil.setSessionAttribute(request, "volumeInfo", volumeInfo);
        
        if (NSActionUtil.isNashead(request)) {
            LicenseInfo license = LicenseInfo.getInstance();
            String hasGfsLicense =
                license.checkAvailable(NSActionUtil.getCurrentNodeNo(request), "gfs")
                    != 0  ? "true" : "false";
            NSActionUtil.setSessionAttribute(request, "hasGfsLicense", hasGfsLicense);
        }
        return mapping.findForward("toVolumeDetail");
    }


    public static String getCapacity4Show(String capacity) throws Exception {
        try{
            Double d = new Double(capacity); 
            return (new java.text.DecimalFormat("#,##0.0")).format(d);
        } catch(NumberFormatException e) {
            return capacity;  
        }      
    }

    public static String compactAndSort(String beforeCompact) {
        if (beforeCompact == null) {
            return beforeCompact;
        }
        
        String[] tmpArr = beforeCompact.split(",");
      
        if (tmpArr.length == 1) {
            return beforeCompact;
        }
        TreeSet tmpSet = new TreeSet(); // use TreeSet to sort
        for (int i = 0; i < tmpArr.length; i++) {
            tmpSet.add(tmpArr[i]);
        }

        Iterator itr = tmpSet.iterator();
        StringBuffer sb = new StringBuffer();
        while (itr.hasNext()) {
            sb.append("<br>").append((String)itr.next()); // get pool String
        }
        return sb.toString().substring(4);
    }
    
    public String getMessageByErrCode(String errCode, String action, HttpServletRequest request) throws Exception {
        
        String msg = "";
        String unexpectMsg = getResources(request).getMessage(request.getLocale(), "info.async.error.unknown");
        Set  specifyErrCode = new HashSet();
        specifyErrCode.add("0x10800033");
        specifyErrCode.add("0x1080003a");
        specifyErrCode.add("0x12400063");
        specifyErrCode.add("0x12400065");
        specifyErrCode.add("0x12400051");
        
        if(specifyErrCode.contains(errCode)){
            String key = "info.async.error.";
            if (NSActionUtil.isNsview(request)) {
                key = "info.async.error.nsview."; 
            }
            msg = getResources(request).getMessage(request.getLocale(), key + errCode); 
            return msg == null ? unexpectMsg : msg;
        }else{
            msg = getResources(request).getMessage(request.getLocale(), "info.async.error." + errCode);
            if(msg == null) {
                return unexpectMsg;
            }
            
            if (!NSActionUtil.isNsview(request)) {
                msg += "<BR>" ;
                if(action.equals("extend")){
                    msg += getResources(request).getMessage(request.getLocale(), "info.async.error.deal.extend");
                }else{
                    msg += getResources(request).getMessage(request.getLocale(), "info.async.error.deal.create");
                }
            }
        }
        return msg;
    }
}