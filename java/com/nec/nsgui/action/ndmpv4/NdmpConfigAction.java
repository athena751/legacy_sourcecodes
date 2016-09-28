/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ndmpv4;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.ndmpv4.NdmpHandler;
import com.nec.nsgui.model.entity.ndmpv4.NdmpInfoBean;

/**
 * Actions for direct edit page
 */
public class NdmpConfigAction extends DispatchAction implements NdmpActionConst {
    private static final String cvsid = "@(#) $Id: NdmpConfigAction.java,v 1.6 2007/08/23 04:58:03 fengmh Exp $";
    
    private boolean checkNdmpLicense(int nodeNum) throws Exception{
        if(ClusterUtil.getMyStatus().equals("2")) {
            int myNode = ClusterUtil.getInstance().getMyNodeNo();
            if(myNode != -1 && myNode != nodeNum ) {
                return true;
            }
        }
        LicenseInfo license = LicenseInfo.getInstance();
        if ((license.checkAvailable(nodeNum,"ndmp")) == 0){
            return false;
        }
        
        return true;
    }
    /**
     * enter ndmp
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */    
    public ActionForward ndmpEntry(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {        
        int group = NSActionUtil.getCurrentNodeNo(request);       
        if(checkNdmpLicense(group)) {            
            return mapping.findForward("havaLicense");            
        } else {
            request.setAttribute("licenseKey","ndmp");
            return mapping.findForward("noLicense");
        }        
    }

    /**
     * display the NDMP config info
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward getNdmpConfigInfo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        int groupNum = NSActionUtil.getCurrentNodeNo(request); 
        NdmpInfoBean ndmpInfoBean = NdmpHandler.getNdmpConfigInfo(groupNum);  
        request.setAttribute("ndmpInfoBean", ndmpInfoBean);
        return mapping.findForward("ndmpConfigInfo");
    }
    
     /**
     * display the NDMP config info for setting
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward getNdmpConfigForSet(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        DynaValidatorForm dynaForm = (DynaValidatorForm) form;
        int groupNum = NSActionUtil.getCurrentNodeNo(request);
        String[] interfaces = NdmpHandler.getAllInterfaces(groupNum);
        int arrayLength = interfaces[0].split("\\s+").length;
        String[] control_interfaces = new String[arrayLength];
        String[] control_interfacesLabel = new String[arrayLength];
        String[] data_interfaces = new String[arrayLength];
        String[] data_interfacesLabel = new String[arrayLength];
        if(!interfaces[0].equals("")) {
            String[] IPs = interfaces[0].split("\\s+");
            String[] cards = interfaces[1].split("\\s+");
            for (int i = 0; i < arrayLength; i ++) {
                control_interfaces[i] = IPs[i];
                control_interfacesLabel[i] = IPs[i] + "(" + cards[i] + ")";
                data_interfaces[i] = IPs[i];
                data_interfacesLabel[i] = IPs[i] + "(" + cards[i] + ")";
            }
        } else {
            interfaces = null;
            control_interfacesLabel = null;
            data_interfaces = null;
            data_interfacesLabel = null;
        }
        
        NdmpInfoBean ndmpConfigInfo = new NdmpInfoBean();
        ndmpConfigInfo = NdmpHandler.getNdmpConfigInfo(groupNum);
        ndmpConfigInfo.setHasSetPassword(ndmpConfigInfo.getHasSetPassword().equals("") ? "no" : ndmpConfigInfo.getHasSetPassword());
        
        request.setAttribute(CONTROL_INTERFACES, control_interfaces);
        request.setAttribute(CONTROL_INTERFACESLABEL, control_interfacesLabel);
        request.setAttribute(DATA_INTERFACES, data_interfaces);
        request.setAttribute(DATA_INTERFACESLABEL, data_interfacesLabel);
        dynaForm.set(NDMP_CONFIGINFO, ndmpConfigInfo);
        return mapping.findForward("ndmpConfigInfoForSet");
    }
    
    /**
     * set NDMP config info
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward setNdmpConfigInfo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {       
        int groupNum = NSActionUtil.getCurrentNodeNo(request);   
        String version = NdmpHandler.getRunningVersion(groupNum);
        
        if (!version.equals("2")) {
            String sessionPath = NdmpHandler.getSessionPath(groupNum);
            String haveSession = NdmpHandler.haveSessionInfo(groupNum, sessionPath);
            if (haveSession.equalsIgnoreCase("true")) {
                NSActionUtil.setSessionAttribute(request,
                    "ndmp_set_needToAlert", "true");
                return mapping.findForward("setNdmpConfigInfo");
            } 
        }              
        
        NdmpInfoBean ndmpInfo = (NdmpInfoBean)((DynaValidatorForm) form).get(NDMP_CONFIGINFO);
        NdmpHandler.setNdmpConfig(groupNum, ndmpInfo);        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setNdmpConfigInfo");
    }
}
