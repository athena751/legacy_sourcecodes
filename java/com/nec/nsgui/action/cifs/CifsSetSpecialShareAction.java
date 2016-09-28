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
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.entity.cifs.ShareOptionBean;

/**
 *Actions for direct edit page
 */
public class CifsSetSpecialShareAction extends DispatchAction implements CifsActionConst{
    private static final String cvsid = "@(#) $Id: CifsSetSpecialShareAction.java,v 1.6 2008/12/18 08:04:06 chenbc Exp $";

    public ActionForward loadTop(
          ActionMapping mapping,
          ActionForm form,
          HttpServletRequest request,
          HttpServletResponse response)
          throws Exception {
        
          int group = NSActionUtil.getCurrentNodeNo(request);
          HttpSession session = request.getSession();
          String action = (String)session.getAttribute(SESSION_ACTION_FOR_SHARE_OPTION);
          if(action != null && action.equals("modify")){
            return displayForModify(mapping,form,request,response);
          }else{
            return displayForAdd(mapping,form,request,response);
          } 
    } 
    
    private ActionForward displayForAdd(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
            
            int group = NSActionUtil.getCurrentNodeNo(request);
            HttpSession session = request.getSession();
            String exportGroup = NSActionUtil.getExportGroupPath(request);
            String domainName = (String) session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
            String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);

            ShareOptionBean shareOptionBean = new ShareOptionBean();
            shareOptionBean.setConnection("yes");
            String[] directMp = CifsCmdHandler.getDirectMP(group, exportGroup, "all");
            String[] hasSetedRealtimeScanmp = (String[]) session.getAttribute(SESSION_SPECIALSHARE_MP);
            if(hasSetedRealtimeScanmp == null){
                hasSetedRealtimeScanmp = new String[]{};
            }
            List<String> dirForDisplay = new ArrayList<String>();
            List<String> dirForOptionValues = new ArrayList<String>();
            boolean hasUsed = false;
            if(directMp != null && directMp.length > 0 && !directMp[0].equals("")) {
                for(int i = 0; i < directMp.length; i ++) {
                    String directMpWhitoutFs = directMp[i].replaceAll("\\s*\\(.*\\)\\s*$", "");
                    hasUsed = false;
                    for(int j = 0; j < hasSetedRealtimeScanmp.length; j ++) {
                        if(directMpWhitoutFs.equals(hasSetedRealtimeScanmp[j])) {
                            hasUsed = true;
                            break;
                        }
                    }
                    if(!hasUsed) {
                        dirForDisplay.add(directMp[i]);
                        dirForOptionValues.add(directMpWhitoutFs);
                    }
                }
            }
            NSActionUtil.setSessionAttribute(request, SESSION_AVAILABLEDIRFORSCAN, dirForDisplay);
            NSActionUtil.setSessionAttribute(request, SESSION_AVAILABLEDIRFORSCAN_OPTION_VALUES, dirForOptionValues);
            
            session.removeAttribute(SESSION_SPECIALSHARE_MP);
            
            String[] realtimeUserAndServer = CifsCmdHandler.getRealtimeScanUserAndServer(group, domainName, computerName);
            shareOptionBean.setValidUserForRealtimeScan(realtimeUserAndServer[0]);
            shareOptionBean.setAllowHostForRealtimeScan(realtimeUserAndServer[1]);
            
            String[] scheduleUserAndServer = CifsCmdHandler.getScheduleScanUserAndServer(group, domainName, computerName);
            shareOptionBean.setValidUserForScheduleScan(scheduleUserAndServer[0]);
            shareOptionBean.setAllowHostForScheduleScan(scheduleUserAndServer[1]);
            
            String[] privilegeUserForBackup = CifsCmdHandler.getPrivilegeUser(group, domainName, computerName, "backup");
            if(privilegeUserForBackup != null && privilegeUserForBackup.length > 0
                    && !privilegeUserForBackup[0].equals("")) {
                NSActionUtil.setSessionAttribute(request, SESSION_ALLBACKUPUSER, privilegeUserForBackup);
            }

            shareOptionBean.setSharePurpose("realtime_scan");

            ((DynaValidatorForm)form).set("shareOption", shareOptionBean);
            return mapping.findForward("displayPage");
        }

    
    private ActionForward displayForModify(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        
          int group = NSActionUtil.getCurrentNodeNo(request);
          HttpSession session = request.getSession();
          String shareName = (String)session.getAttribute(SESSION_SHARE_NAME_FOR_MODIFY);
          shareName = NSActionUtil.page2Perl(shareName, request);        
          String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
          String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
          ShareOptionBean shareOptionBean = CifsCmdHandler.getShareInfo(group, domainName, computerName, shareName);
          changEncodingForPage(shareOptionBean, request);
          if(shareOptionBean.getSharePurpose().equals("realtime_scan")) {
              String[] realtimeUserAndServer = CifsCmdHandler.getRealtimeScanUserAndServer(group, domainName, computerName);
              shareOptionBean.setValidUserForRealtimeScan(realtimeUserAndServer[0]);
              shareOptionBean.setAllowHostForRealtimeScan(realtimeUserAndServer[1]);
          } else if (shareOptionBean.getSharePurpose().equals("backup")){
              String[] privilegeUserForBackup = CifsCmdHandler.getPrivilegeUser(group, domainName, computerName, "backup");
              if(privilegeUserForBackup != null && privilegeUserForBackup.length > 0
                      && !privilegeUserForBackup[0].equals("")) {
                  NSActionUtil.setSessionAttribute(request, SESSION_ALLBACKUPUSER, privilegeUserForBackup);
              }
              shareOptionBean.setValidUserForBackup(getUsers(shareOptionBean.getValidUser_Group()));
              shareOptionBean.setAllowHostForBackup(shareOptionBean.getHostsAllow());
          }
          ((DynaValidatorForm)form).set("shareOption", shareOptionBean);
          return mapping.findForward("displayPage");
        }
        
        private void changEncodingForPerl(ShareOptionBean shareOptionBean, HttpServletRequest request)throws Exception{
            shareOptionBean.setShareName(
                NSActionUtil.page2Perl(
                    shareOptionBean.getShareName(),request)
                );
            shareOptionBean.setDirectory(
                NSActionUtil.page2Perl(
                    shareOptionBean.getDirectory(),request)
                );
            shareOptionBean.setComment(
                NSActionUtil.page2Perl(
                    shareOptionBean.getComment(),request)
                );
        }
        private void changEncodingForForm(ShareOptionBean shareOptionBean)throws Exception{
                shareOptionBean.setShareName(
                    NSActionUtil.reqStr2EncodeStr(
                        shareOptionBean.getShareName(),NSActionConst.BROWSER_ENCODE)
                    );
                shareOptionBean.setDirectory(
                    NSActionUtil.reqStr2EncodeStr(
                        shareOptionBean.getDirectory(),NSActionConst.BROWSER_ENCODE)
                    );
                shareOptionBean.setComment(
                    NSActionUtil.reqStr2EncodeStr(
                        shareOptionBean.getComment(),NSActionConst.BROWSER_ENCODE)
                    );
            }
        
        private void changEncodingForPage(ShareOptionBean shareOptionBean, HttpServletRequest request)throws Exception{
            shareOptionBean.setShareName(
                NSActionUtil.perl2Page(
                    shareOptionBean.getShareName(),request)
                );
            shareOptionBean.setDirectory(
                NSActionUtil.perl2Page(
                    shareOptionBean.getDirectory(),request)
                );
            shareOptionBean.setComment(
                NSActionUtil.perl2Page(
                    shareOptionBean.getComment(),request)
                );
        }
        
        public ActionForward addOrmodify_Share(
                ActionMapping mapping,
                ActionForm form,
                HttpServletRequest request,
                HttpServletResponse response)
                throws Exception {
            int group = NSActionUtil.getCurrentNodeNo(request);
            HttpSession session = request.getSession();
            String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
            String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
            ShareOptionBean shareOptionBean = (ShareOptionBean)((DynaValidatorForm) form).get("shareOption");
            
            ShareOptionBean optionObject = (ShareOptionBean)BeanUtils.cloneBean(shareOptionBean);     
            changEncodingForForm(shareOptionBean);
            changEncodingForPerl(optionObject, request);
            try{
                CifsCmdHandler.setShareOption(group, domainName, computerName, optionObject);
            }catch (NSException e){
                if(e.getErrorCode().equals(ERRCODE_STRING_TOOLONG_BY_EXPORTENCODING)){
                    //added for 0805 cifs range
                    NSActionUtil.setSessionAttribute(request, SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING, "yes");
                    return mapping.findForward("displayPage");
                }
                if(!e.getErrorCode().equals(ERROR_CODE_CORRESPONDING_VOLUME_USING_DMAPI) &&
                        !e.getErrorCode().equals(ERROR_CODE_SET_DIR_ACCESS_FOR_SXFSFW) &&
                        !e.getErrorCode().equals(ERROR_CODE_SET_GLOBALOPTION)) {
                    throw e;
                }
            }

            String sharePurpose = optionObject.getSharePurpose();
            String fsType = optionObject.getFsType();
            if("realtime_scan".equalsIgnoreCase(sharePurpose) && "sxfsfw".equalsIgnoreCase(fsType)){
                String[] realtimeUserAndServer = CifsCmdHandler.getRealtimeScanUserAndServer(group, domainName, computerName);
                String realtimeUser = "";
                try{
                    realtimeUser = realtimeUserAndServer[0];
                }catch(Exception e){}
                if("".equals(realtimeUser)){
                    Locale locale = getLocale(request);
                    String alertMessage = getResources(request).getMessage(
                            getLocale(request),
                            "cifs.alert.antiVirusShare.sxfsfw.noScanUser");
                    MessageResources commonResource = (MessageResources) getServlet().getServletContext().getAttribute("common");
                    String commonSuccess = commonResource.getMessage(locale,NSActionConst.SUCCESS_ALERT_KEY);
                    alertMessage = commonSuccess+ "\\r\\n" + alertMessage;
                    NSActionUtil.setSessionAttribute(request,
                            NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                            alertMessage);
                    return mapping.findForward("forwardShareList");
                }
            }
            
            NSActionUtil.setSuccess(request);
            return mapping.findForward("forwardShareList");
        }
        
        public ActionForward checkScheduleScanConnection(
                ActionMapping mapping,
                ActionForm form,
                HttpServletRequest request,
                HttpServletResponse response)
                throws Exception {
            int group = NSActionUtil.getCurrentNodeNo(request);
            HttpSession session = request.getSession();
            String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
            String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
            ShareOptionBean shareOptionBean = (ShareOptionBean)((DynaValidatorForm) form).get("shareOption");
            String shareName = shareOptionBean.getShareName();
            String connecting = CifsCmdHandler.checkScheduleScanConnection(group, domainName, computerName, shareName);
            if(connecting.equalsIgnoreCase("true")){
                NSActionUtil.setSessionAttribute(request, "cifs_needConfirm4ScheduleShare", "yes");
                changEncodingForForm(shareOptionBean);
                return mapping.findForward("displayPage");
            }
            return addOrmodify_Share(mapping, form, request, response);
        }
    
        public ActionForward displayDetail(
               ActionMapping mapping,
               ActionForm form,
               HttpServletRequest request,
               HttpServletResponse response)
               throws Exception {
            
               int group = NSActionUtil.getCurrentNodeNo(request);
               String shareName = request.getParameter("shareName");
               shareName = NSActionUtil.page2Perl(shareName, request);
               HttpSession session = request.getSession();
               String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
               String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
               ShareOptionBean shareOptionBean;
               
               try{
                    shareOptionBean = CifsCmdHandler.getShareInfo(group, domainName, computerName, shareName);
               }catch (Exception e){
                    request.setAttribute(CANNOT_GET_DETAIL,"true"); 
                    return mapping.findForward("displayDetail");
               
               }
             
                //set the corresponding message for the property
                 HashMap connectionValue_key = new HashMap();
                 connectionValue_key.put("yes", "cifs.td.valid");
                 connectionValue_key.put("no", "cifs.td.invalid");
                 CommonUtil.setMsgInObj(shareOptionBean, "connection", connectionValue_key, getResources(request), request);
                
                 HashMap readOnlyValue_key = new HashMap();
                 readOnlyValue_key.put("yes", "cifs.shareOption.radio_ro");
                 readOnlyValue_key.put("no", "cifs.shareOption.radio_rw");
                 CommonUtil.setMsgInObj(shareOptionBean, "readOnly", readOnlyValue_key, getResources(request), request); 
                 
                HashMap serverProtectValue_key = new HashMap();
                serverProtectValue_key.put("yes", "cifs.shareDetial.td_serverProtect_yes");
                serverProtectValue_key.put("no", "cifs.shareDetial.td_serverProtect_no");
                CommonUtil.setMsgInObj(shareOptionBean, "serverProtect", serverProtectValue_key, getResources(request), request); 
                
                HashMap shadowCopyValue_key = new HashMap();
                shadowCopyValue_key.put("yes", "cifs.shareDetial.td_shadowCopy_yes");
                shadowCopyValue_key.put("no", "cifs.shareDetial.td_shadowCopy_no");
                CommonUtil.setMsgInObj(shareOptionBean, "shadowCopy", shadowCopyValue_key, getResources(request), request);  
                
                HashMap browseable_key = new HashMap();
                browseable_key.put("yes", "cifs.specialShareDetial.browseable_yes");
                browseable_key.put("no", "cifs.specialShareDetial.browseable_no");
                CommonUtil.setMsgInObj(shareOptionBean, "browseable", browseable_key, getResources(request), request); 
                
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "comment", getResources(request), request);
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "directory", getResources(request), request); 
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "writeList", getResources(request), request); 
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "validUser_Group", getResources(request), request); 
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "hostsAllow", getResources(request), request);
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "validUserForScheduleScan", getResources(request), request);
                CommonUtil.setNoContentMsgInObj(shareOptionBean, "allowHostForScheduleScan", getResources(request), request);
                changEncodingForPage(shareOptionBean, request);     
                 ((DynaValidatorForm)form).set("shareOption", shareOptionBean);
                
                 return mapping.findForward("displayDetail");
            }
        
        private static String[] getUsers(String str) {
            if(str.indexOf("\"") == -1) {
                return str.split("\\s+");
            }
            List userList = new ArrayList();
            String[] str1 = str.split("\"");
            int i = 1;
            for(int j = 0; j < str1.length; j ++) {
                if(i == 1) {
                    String[] str2 = str1[j].split("\\s+");
                    if(str2 != null && str2.length > 0) {
                        for(int h = 0; h < str2.length; h ++) {
                            if(!str2[h].equals("")) {
                                userList.add(str2[h]);
                            }
                        }
                    }
                } else {
                    if(!str1[j].trim().equals("")) {
                        userList.add(str1[j].trim());
                    }
                }
                i *= -1;
            }
            String[] users = {};
            users = (String[])userList.toArray(users);
            return users;
        }
}