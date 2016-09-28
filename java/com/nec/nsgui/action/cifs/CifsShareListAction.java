/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.entity.cifs.ShareInfoBean;
import com.nec.nsgui.action.serverprotect.ServerProtectActionConst;

/**
 *Actions for direct edit page
 */
public class CifsShareListAction extends DispatchAction implements CifsActionConst{
    private static final String cvsid = "@(#) $Id: CifsShareListAction.java,v 1.11 2007/03/23 06:41:11 chenbc Exp $";
    /**
     * display the share list
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward loadTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        String exportGroup = NSActionUtil.getExportGroupPath(request);
        List shareInfoList = CifsCmdHandler.getShareList(group, domainName, computerName, "normal");
        changEncodingForPage(shareInfoList, request);
        
        //set the corresponding message for the property
        HashMap connectionValue_key = new HashMap();
        connectionValue_key.put("yes", "cifs.td.valid");
        connectionValue_key.put("no", "cifs.td.invalid");
        CommonUtil.setMsgInObj(shareInfoList, "connection", connectionValue_key, getResources(request), request);

        HashMap readOnlyValue_key = new HashMap();
        readOnlyValue_key.put("yes", "cifs.shareOption.radio_ro");
        readOnlyValue_key.put("no", "cifs.shareOption.radio_rw");
        CommonUtil.setMsgInObj(shareInfoList, "readOnly", readOnlyValue_key, getResources(request), request);
        
        HashMap antiVirus_key = new HashMap();
        antiVirus_key.put("yes", "cifs.antiVirus.enabled");
        antiVirus_key.put("no", "cifs.antiVirus.disabled");
        antiVirus_key.put("", "cifs.antiVirus.meanNothing");
        CommonUtil.setMsgInObj(shareInfoList, "antiVirus", antiVirus_key, getResources(request), request);
        
        request.setAttribute("shareList", shareInfoList);
        request.setAttribute("canAddShare", CifsCmdHandler.canAddShare(group, exportGroup));
        request.setAttribute("hasAvailableNicForCIFS", CifsCmdHandler.hasAvailableNicForCIFS(group));
        String interfaceWanted = "false";
        if(CifsCmdHandler.getInterfacesFromSmb(group, domainName, computerName).equals("")){
            interfaceWanted = "true";
        }
        request.setAttribute("interfaceWanted", interfaceWanted);
        return mapping.findForward("displayTop");
    }

    /**
     * display the share list
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward enterCIFS(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int group = NSActionUtil.getCurrentNodeNo(request);
        
        LicenseInfo license = LicenseInfo.getInstance();
        if ((license.checkAvailable(group,"cifs")) == 0){
            request.setAttribute("licenseKey","cifs");
            return mapping.findForward("noLicense");
        }
        
        if((license.checkAvailable(group, ServerProtectActionConst.CONST_LICENSE_KEY_SERVERPROTECT)) == 0) {
            NSActionUtil.setSessionAttribute(request, SESSION_HASANTIVIRUSSCAN_LICENSE, "no");
        } else {
            NSActionUtil.setSessionAttribute(request, SESSION_HASANTIVIRUSSCAN_LICENSE, "yes");
        }
        
        HttpSession session = request.getSession();
        String exportGroup = NSActionUtil.getExportGroupPath(request);
        String[] computerInfo = CifsCmdHandler.getComputerInfo(group, exportGroup);
        String domainName = computerInfo[0];
        String computerName = computerInfo[1];
        String securityMode = computerInfo[2];
        String hasSetDirectHosting = computerInfo[3];
        if(domainName != null && !domainName.equals("") 
            && computerName != null && !computerName.equals("")
            && securityMode != null && !securityMode.equals("")){
            session.setAttribute(CifsActionConst.SESSION_COMPUTER_NAME, computerName);
            session.setAttribute(CifsActionConst.SESSION_DOMAIN_NAME, domainName);
            session.setAttribute(CifsActionConst.SESSION_EXPORT_GROUP_ENCODING,
                                 NSActionUtil.getExportGroupEncoding(request));
            session.setAttribute(CifsActionConst.SESSION_SECURITY_MODE, securityMode);
            if(securityMode.equals(CifsActionConst.SECURITYMODE_ADS)) {
                String passwdServer = CifsCmdHandler.getPasswdServer(group, domainName, computerName);
                passwdServer = passwdServer.equals("") ? "*" : passwdServer;
                session.setAttribute(CifsActionConst.SESSION_PASSWDSERVER, passwdServer);
            }
            if(NSActionUtil.isNsview(request)) {
                return mapping.findForward("displayFrame4Nsview");
            } else {
                return mapping.findForward("displayFrame");
            }
        }else{
            session.setAttribute(CifsActionConst.SESSION_COMPUTER_NAME, null);
            session.setAttribute(CifsActionConst.SESSION_DOMAIN_NAME, null);
            session.setAttribute(CifsActionConst.SESSION_EXPORT_GROUP_ENCODING, null);
            if(hasSetDirectHosting != null && hasSetDirectHosting.equals("yes")) {
                if(NSActionUtil.isNsview(request)) {
                    return mapping.findForward("notRefer4nsview");
                } else {
                    return mapping.findForward("hasSetDirectHosting");
                }
            } else {
                if(NSActionUtil.isNsview(request)) {
                    return mapping.findForward("notRefer4nsview");
                } else {
                    return mapping.findForward("toAddDomain");
                }
            }
        }
        
    }
    
    private void changEncodingForPage(List shareList, HttpServletRequest request)throws Exception{
        int size =  shareList.size();
        for(int i = 0; i< size; i++){
            ShareInfoBean shareInfo = (ShareInfoBean)shareList.get(i);
            shareInfo.setShareName(
                    NSActionUtil.perl2Page(
                        shareInfo.getShareName(),request)
                );
            shareInfo.setShareName_td(shareInfo.getShareName());
            shareInfo.setDirectory(
                    NSActionUtil.perl2Page(
                        shareInfo.getDirectory(),request)
                );
            shareInfo.setComment(
                    NSActionUtil.perl2Page(
                        shareInfo.getComment(),request)
                );
            shareInfo.setShareInfo(shareInfo.getShareName()+ ","
                    + shareInfo.getFsType() + "," + shareInfo.getDirectory()
                );
        }
    }

    /**
     * display the botton [Modify...] 
     *          [Access Log (Share) Configuration ...] [Delete]
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward loadBottom(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        String hasSetAccessLog = CifsCmdHandler.hasSetAccessLog(group, domainName, computerName);
        request.setAttribute("hasSetAccessLog", hasSetAccessLog);
        return mapping.findForward("displayBottom");
    }

    /**
     * delete a share
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward deleteShare(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int group = NSActionUtil.getCurrentNodeNo(request);
        String shareName = request.getParameter("shareName");
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        shareName = NSActionUtil.page2Perl(shareName, request);
        String needCheck = request.getParameter("needCheck");
        if(needCheck.equals("true")){
            String isWorkingShare = CifsCmdHandler.isWorkingShare(
                            group, domainName, computerName, shareName);
            if(isWorkingShare.equals("true")){
                request.setAttribute("needConfirm", "true");
                return mapping.findForward("reloadTop");
            }
        }
        //delete the shareName
        CifsCmdHandler.deleteShare(group, domainName, computerName, shareName);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("reloadTop");
        
    }

    
}
