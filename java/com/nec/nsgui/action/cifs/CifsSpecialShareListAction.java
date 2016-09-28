/*
 *      Copyright (c) 2007-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.ArrayList;
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

public class CifsSpecialShareListAction extends DispatchAction implements CifsActionConst{
    private static final String cvsid = "@(#) $Id: CifsSpecialShareListAction.java,v 1.4 2008/12/18 08:04:06 chenbc Exp $";

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
            List shareInfoList = CifsCmdHandler.getSpecialShareList(group, domainName, computerName, "special");
            ShareInfoBean shareInfo = new ShareInfoBean();
            List mpHasSetForRealtimeScan = new ArrayList();
            String mp;
            for(int i = 0 ; i < shareInfoList.size(); i ++) {
                shareInfo = (ShareInfoBean) shareInfoList.get(i);
                if(shareInfo.getSharePurpose().equals("realtime_scan")) {
                    mp = shareInfo.getDirectory().split("/+")[3];
                    mpHasSetForRealtimeScan.add(mp);
                }
            }
            String[] hasSetedRealtimeScanmp = {};
            hasSetedRealtimeScanmp = (String[]) mpHasSetForRealtimeScan.toArray(hasSetedRealtimeScanmp);
            NSActionUtil.setSessionAttribute(request, SESSION_SPECIALSHARE_MP, hasSetedRealtimeScanmp);
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
            
            HashMap sharePurpose_key = new HashMap();
            sharePurpose_key.put("realtime_scan", "cifs.sharePurpose.realtime_scan");
            sharePurpose_key.put("backup", "cifs.sharePurpose.backup");
            sharePurpose_key.put("normal", "cifs.sharePurpose.normal");
            CommonUtil.setMsgInObj(shareInfoList, "sharePurpose", sharePurpose_key, getResources(request), request);
            
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
                    + shareInfo.getFsType() + "," + shareInfo.getSharePurpose()
                    + "," + shareInfo.getDirectory()
                );
        }
    }
    
    public ActionForward deleteShare(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        
            int group = NSActionUtil.getCurrentNodeNo(request);
            String shareName = request.getParameter("shareName");
            String sharePurpose = request.getParameter("sharePurpose");
            HttpSession session = request.getSession();
            String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
            String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
            shareName = NSActionUtil.page2Perl(shareName, request);
            if(sharePurpose.equals("realtime_scan")) {
                String hasSetAntiVirusScan = CifsCmdHandler.hasSetAntiVirusScan(group, domainName, computerName, shareName);
                if(hasSetAntiVirusScan.equals("realtime_scan")){
                    request.setAttribute("needAlert_hasSetAntiVirusScan", "true");
                    return mapping.findForward("reloadTop");
                }
                if(hasSetAntiVirusScan.equals("schedule_scan")){
                    request.setAttribute("needAlert_hasSetScheduleScan", "true");
                    return mapping.findForward("reloadTop");
                }
            }

            //delete the shareName
            CifsCmdHandler.deleteShare(group, domainName, computerName, shareName);
            NSActionUtil.setSuccess(request);
            return mapping.findForward("reloadTop");
            
        }
}