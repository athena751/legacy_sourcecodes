/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.serverprotect;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.biz.serverprotect.ServerProtectHandler;

public class ServerProtectConfigAction extends Action implements ServerProtectActionConst{
    private static final String cvsid = "@(#) $Id: ServerProtectConfigAction.java,v 1.2 2007/03/23 09:36:54 wanghui Exp $";

    /**
     * check license
     * @param nodeNumber
     * @return true if license is availabe, otherwise false
     * @throws Exception
     */
    private boolean checkLicense(int nodeNumber, String category) throws Exception{
        if(ClusterUtil.getMyStatus().equals("2")) {
            int myNode = ClusterUtil.getInstance().getMyNodeNo();
            if(myNode != -1 && myNode != nodeNumber ) {
                return true;
            }
        }
        LicenseInfo license = LicenseInfo.getInstance();
        if ((license.checkAvailable(nodeNumber,category)) == 0){
            return false;
        }
        return true;
    }

    /**
     * check whether is in ADS domain
     * @param securityMode
     * @return true if in, otherwise false
     */
    private boolean checkAds(String securityMode){
        return null == securityMode ? false : securityMode.equalsIgnoreCase(CONST_SECURITY_MODE_ADS);
    }

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
            throws Exception{
        int nodeNumber = NSActionUtil.getCurrentNodeNo(request);
        if(!checkLicense(nodeNumber, CONST_LICENSE_KEY_SERVERPROTECT)) {
            request.setAttribute(CONST_LICENSE_KEY, CONST_LICENSE_KEY_SERVERPROTECT);
            return mapping.findForward("noLicense");
        }
        
        if(!checkLicense(nodeNumber, CONST_LICENSE_KEY_CIFS)){
            request.setAttribute(CONST_LICENSE_KEY, CONST_LICENSE_KEY_CIFS);
            return mapping.findForward("noLicense");
        }
        
        String exportGroupName = NSActionUtil.getExportGroupPath(request)
                .replaceAll("\\/*$", "");
        String[] computerInfo = CifsCmdHandler.getComputerInfo(nodeNumber, 
                exportGroupName, true);
        String securityMode = computerInfo[2];
        if(!checkAds(securityMode)){
            return mapping.findForward("noads");
        }
        
        String domainName = computerInfo[0];
        String computerName = computerInfo[1];             
        NSActionUtil.setSessionAttribute(request, 
                SESSION_SERVERPROTECT_DOMAINNAME, domainName);
        NSActionUtil.setSessionAttribute(request, 
                SESSION_SERVERPROTECT_COMPUTERNAME, computerName);
        
        if(NSActionUtil.isNsview(request)){
            return mapping.findForward("tabentry4nsview");
        }else{
            return mapping.findForward("tabentry");
        }
    }
}
