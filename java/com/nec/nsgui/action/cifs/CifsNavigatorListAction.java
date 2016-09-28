/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.cifs;


import java.util.Locale;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.cifs.CIFSNavigatorList;
import com.nec.nsgui.model.entity.base.DirectoryInfoBean;

public class CifsNavigatorListAction extends DispatchAction implements NSActionConst{
    
    private static final String     cvsid = "@(#) $Id: CifsNavigatorListAction.java,v 1.22 2008/05/20 02:46:48 chenbc Exp $";
    
    public ActionForward callGlobal(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory");
        
        String perlNowDirectory = NSActionUtil.page2Perl(nowDirectory , request);
        
        String displayNowDirectory = NSActionUtil.reqStr2EncodeStr(nowDirectory , BROWSER_ENCODE);
        
        
        String displayDirectory = displayNowDirectory;
        
        
        HttpSession session = request.getSession(false);
        session.setAttribute("rootDirectory" , rootDirectory);
        session.setAttribute("nowDirectory" , displayNowDirectory);
        session.setAttribute("displayDirectory" , NSActionUtil.sanitize(displayDirectory , false));
        
        Locale locale = request.getLocale();
        
        CIFSNavigatorList cifsNL = new CIFSNavigatorList();
        
        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = cifsNL.onListGlobal(rootDirectory , perlNowDirectory , locale , check , nodeNo);
        
        String nowDirTrue = (String)allDirectoryInfo.remove(0);
        
        nowDirTrue = NSActionUtil.perl2Page(nowDirTrue , request);
        ((DynaActionForm)form).set("nowDirectory" , NSActionUtil.sanitize(nowDirTrue , false));
        if(nowDirTrue.equals("/var/log") || nowDirTrue.equals("/export") ){
            ((DynaActionForm)form).set("rootDirectory" , nowDirTrue);
        }
        
        DirectoryInfoBean oneDir;
        filterPath(allDirectoryInfo, request);
        
        for (int i=0 ; i<allDirectoryInfo.size() ; i++) {
            oneDir = (DirectoryInfoBean)allDirectoryInfo.get(i);
            oneDir.setDisplayedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplayedPath() , request)));
            oneDir.setWholePath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getWholePath() , request) , false));
            oneDir.setDisplaySelectedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplaySelectedPath() , request) , false));
        }
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
        session.setAttribute("CIFSGlobalAllDirectoryInfo" , allDirectoryInfo);
        return mapping.findForward("success_call");
    }
    
    
    public ActionForward listGlobal(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {                          
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory");   
        
        String perlNowDirectory = NSActionUtil.page2Perl(nowDirectory , request);
        
        String displayNowDirectory = NSActionUtil.reqStr2EncodeStr(nowDirectory , BROWSER_ENCODE);
        
        ((DynaActionForm)form).set("nowDirectory" , NSActionUtil.sanitize(displayNowDirectory , false));
        if(displayNowDirectory.equals("/var/log") || displayNowDirectory.equals("/export") ){
            ((DynaActionForm)form).set("rootDirectory" , displayNowDirectory);
        }
                            
        Locale locale = request.getLocale();
        
        CIFSNavigatorList cifsNL = new CIFSNavigatorList();
        
        boolean check = false;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = cifsNL.onListGlobal(rootDirectory , perlNowDirectory , locale , check , nodeNo);
        filterPath(allDirectoryInfo, request);
        DirectoryInfoBean oneDir;
        
        for (int i=0 ; i<allDirectoryInfo.size() ; i++) {
            oneDir = (DirectoryInfoBean)allDirectoryInfo.get(i);
            oneDir.setDisplayedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplayedPath() , request)));
            oneDir.setWholePath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getWholePath() , request) , false));
            oneDir.setDisplaySelectedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplaySelectedPath() , request) , false));
        }
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
        request.setAttribute("CIFSGlobalAllDirectoryInfo" , allDirectoryInfo);      
        return mapping.findForward("success_list");
    }
    
    
    public ActionForward callShare(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory");
        
        String notListfsType = (String)request.getParameter("notListfsType");
        NSActionUtil.setSessionAttribute(request, "notListfsType", notListfsType);
        notListfsType = (String) request.getSession().getAttribute("notListfsType");
        
        String perlNowDirectory = NSActionUtil.page2Perl(nowDirectory , request);
        String displayNowDirectory = NSActionUtil.reqStr2EncodeStr(nowDirectory , BROWSER_ENCODE);
        
        String rootDirectoryForDisplay = NSActionUtil.reqStr2EncodeStr(rootDirectory, BROWSER_ENCODE);
        
        String directoryName = (String)((DynaActionForm)form).get("directoryName");
        String directoryNameForDisplay = NSActionUtil.reqStr2EncodeStr(directoryName, BROWSER_ENCODE);
        ((DynaActionForm)form).set("directoryName" , NSActionUtil.sanitize(directoryNameForDisplay, false));
        
        HttpSession session = request.getSession(false);
        session.setAttribute("rootDirectory" , rootDirectoryForDisplay);
        session.setAttribute("nowDirectory" , displayNowDirectory);
        String displayDirectory ;
        if (rootDirectory.equals(nowDirectory)) {
            displayDirectory = "";
        } else {
            displayDirectory = displayNowDirectory.substring(rootDirectoryForDisplay.length() + 1);
        }
        session.setAttribute("displayDirectory" , NSActionUtil.sanitize(displayDirectory , false));
        
        Locale locale = request.getLocale();
        
        int group = NSActionUtil.getCurrentNodeNo(request);
        String domainName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_COMPUTER_NAME);
        
        CIFSNavigatorList cifsNL = new CIFSNavigatorList();
        
        String canBeModified = cifsNL.canModifyDirectory(group, domainName, computerName, NSActionUtil.page2Perl(nowDirectory, request));
        String mpType = "";
        String parentHasACL = "";
        if(canBeModified.equalsIgnoreCase("yes")){
            mpType = cifsNL.getMPType(group, domainName, computerName, NSActionUtil.page2Perl(nowDirectory, request));
            if(mpType.equalsIgnoreCase("sxfsfw")){
                parentHasACL = cifsNL.haveParentACL(group, domainName, computerName, NSActionUtil.page2Perl(nowDirectory, request));
            }else{
                parentHasACL = "yes";
            }
        }
        session.setAttribute("cifs_canBeModified", canBeModified);
        session.setAttribute("cifs_mpType", mpType);
        session.setAttribute("cifs_parentHasACL", parentHasACL);
        
        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = cifsNL.onListShare(NSActionUtil.page2Perl(rootDirectory , request) , perlNowDirectory , locale , check , nodeNo, notListfsType);
        
        String nowDirTrue = (String)allDirectoryInfo.remove(0);
        nowDirTrue = NSActionUtil.perl2Page(nowDirTrue , request);
        ((DynaActionForm)form).set("nowDirectory" , NSActionUtil.sanitize(nowDirTrue , false));
        ((DynaActionForm)form).set("rootDirectory" , NSActionUtil.sanitize(rootDirectoryForDisplay, false));
        
        filterPath(allDirectoryInfo, request);
        DirectoryInfoBean oneDir;
        for (int i=0 ; i<allDirectoryInfo.size() ; i++) {
            oneDir = (DirectoryInfoBean)allDirectoryInfo.get(i);
            oneDir.setDisplayedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplayedPath() , request)));
            oneDir.setWholePath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getWholePath() , request) , false));
            oneDir.setDisplaySelectedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplaySelectedPath() , request) , false));
        }
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
        session.setAttribute("CIFSShareAllDirectoryInfo" , allDirectoryInfo);
        return mapping.findForward("success_call");
    }
    public ActionForward makeDirectory(ActionMapping mapping , ActionForm form , 
            HttpServletRequest request ,
            HttpServletResponse response) throws Exception {
        int group = NSActionUtil.getCurrentNodeNo(request);
        String domainName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_COMPUTER_NAME);
        String directoryName = (String)((DynaActionForm)form).get("directoryName");
        String nfcDirLength = request.getParameter("nfcLength");  // added for 0805 cifs limit
        
        CIFSNavigatorList cifsNL = new CIFSNavigatorList();
        try{
            cifsNL.makeDirectory(group, domainName, computerName, NSActionUtil.page2Perl(directoryName, request), nfcDirLength);
            setSuccess(request);
        }catch(NSException e){
            String errorCode = e.getErrorCode();
          // added for 0805 cifs limit
            if(errorCode.equals(CifsActionConst.ERRCODE_DIRECTORY_OVER144_BY_UTF8_NFC)){
                request.setAttribute("nfcLengthOver144", "yes");
                return listShare(mapping, form, request, response);
            }
            if(errorCode.equals(CifsActionConst.ERRCODE_CIFS_DIRMAKE_MKDIR_ERROR)){
                errorCode = CifsActionConst.ERRCODE_CIFS_DIRMAKE_MK_FAILED;
            }
            String errorMessage = getErrorMessage(errorCode, request);
            if(errorMessage != null){
                if(errorCode.equals(CifsActionConst.ERRCODE_CIFS_DIRMAKE_DIR_EXISTS)){
                    request.setAttribute("directoryExists", "yes");
                }else if(errorCode.equals(CifsActionConst.ERRCODE_CIFS_DIRMAKE_DIR_TOOLONG) 
                      || errorCode.equals(CifsActionConst.ERRCODE_DIRECTORY_OVER240_BY_UTF8_NFC)){ // added for 0805 cifs limit
                    request.setAttribute("dirNameTooLong", "yes");
                }
                request.setAttribute("errorMessage", errorMessage);
            }else{
                throw e;
            }
        }
        return listShare(mapping, form, request, response);
    }
    
    public ActionForward deleteDirectory(ActionMapping mapping , ActionForm form , 
            HttpServletRequest request ,
            HttpServletResponse response) throws Exception { 
        int group = NSActionUtil.getCurrentNodeNo(request);
        String domainName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_COMPUTER_NAME);
        String directoryName = (String)((DynaActionForm)form).get("directoryName");
        
        CIFSNavigatorList cifsNL = new CIFSNavigatorList();
        try{
            cifsNL.deleteDirectory(group, domainName, computerName, NSActionUtil.page2Perl(directoryName, request));
            request.setAttribute("deleteSuccess", "yes");
            setSuccess(request);
        }catch(NSException e){
            String errorMessage = getErrorMessage(e.getErrorCode(), request);
            if(errorMessage != null){
                request.setAttribute("errorMessage", errorMessage);
            }else{
                throw e;
            }
        }
        return listShare(mapping, form, request, response);
    }
    
    public ActionForward listShare(ActionMapping mapping , ActionForm form , 
                              HttpServletRequest request ,
                              HttpServletResponse response) throws Exception {                          
        String rootDirectory = (String)((DynaActionForm)form).get("rootDirectory");
        String rootDirectoryForDisplay = NSActionUtil.reqStr2EncodeStr(rootDirectory, BROWSER_ENCODE);
        ((DynaActionForm)form).set("rootDirectory" , NSActionUtil.sanitize(rootDirectoryForDisplay, false));
        String nowDirectory = (String)((DynaActionForm)form).get("nowDirectory"); 
        String notListfsType = (String) request.getSession().getAttribute("notListfsType"); 
        
        String perlNowDirectory = NSActionUtil.page2Perl(nowDirectory , request);
        String displayNowDirectory = NSActionUtil.reqStr2EncodeStr(nowDirectory , BROWSER_ENCODE);
        
        ((DynaActionForm)form).set("nowDirectory" , NSActionUtil.sanitize(displayNowDirectory , false));
        
        String directoryName = (String)((DynaActionForm)form).get("directoryName");
        String directoryNameForDisplay = NSActionUtil.reqStr2EncodeStr(directoryName, BROWSER_ENCODE);
        ((DynaActionForm)form).set("directoryName" , NSActionUtil.sanitize(directoryNameForDisplay, false));
                            
        Locale locale = request.getLocale();
        
        int group = NSActionUtil.getCurrentNodeNo(request);
        String domainName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)NSActionUtil.getSessionAttribute(request, CifsActionConst.SESSION_COMPUTER_NAME);
        
        CIFSNavigatorList cifsNL = new CIFSNavigatorList();
        
        String canBeModified = cifsNL.canModifyDirectory(group, domainName, computerName, NSActionUtil.page2Perl(nowDirectory, request));
        String mpType = "";
        String parentHasACL = "";
        if(canBeModified.equals("yes")){
            mpType = cifsNL.getMPType(group, domainName, computerName, NSActionUtil.page2Perl(nowDirectory, request));
            if(mpType.equalsIgnoreCase("sxfsfw")){
                parentHasACL = cifsNL.haveParentACL(group, domainName, computerName, NSActionUtil.page2Perl(nowDirectory, request));
            }else{
                parentHasACL = "yes";
            }
        }
        request.setAttribute("cifs_canBeModified", canBeModified);
        request.setAttribute("cifs_mpType", mpType);
        request.setAttribute("cifs_parentHasACL", parentHasACL);
        
        boolean check = true;
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        Vector allDirectoryInfo = cifsNL.onListShare(NSActionUtil.page2Perl(rootDirectory, request), perlNowDirectory, locale, check, nodeNo, notListfsType);
        String nowDirTrue = (String)allDirectoryInfo.remove(0);
        nowDirTrue = NSActionUtil.perl2Page(nowDirTrue , request);
        ((DynaActionForm)form).set("nowDirectory" , NSActionUtil.sanitize(nowDirTrue , false));
        filterPath(allDirectoryInfo, request);
        DirectoryInfoBean oneDir;
        for (int i=0 ; i<allDirectoryInfo.size() ; i++) {
            oneDir = (DirectoryInfoBean)allDirectoryInfo.get(i);
            oneDir.setDisplayedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplayedPath() , request)));
            oneDir.setWholePath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getWholePath() , request), false));
            oneDir.setDisplaySelectedPath(NSActionUtil.sanitize(NSActionUtil.perl2Page(oneDir.getDisplaySelectedPath() , request) , false));
        }
        DirectoryInfoBean.sortByDisplayedPath(allDirectoryInfo);
        request.setAttribute("CIFSShareAllDirectoryInfo" , allDirectoryInfo);
        return mapping.findForward("success_list");
    }
    
    
    private void filterPath(Vector directorInfo, HttpServletRequest request) throws Exception{
        DirectoryInfoBean oneDir;
        for(int i = 0; i < directorInfo.size(); i++){
            oneDir = (DirectoryInfoBean)directorInfo.get(i);
            String displayedPath = NSActionUtil.perl2Page(oneDir.getDisplayedPath() , request);
            if(!isValidPath(displayedPath)){
                directorInfo.remove(i);
                i--;
            }
        }
    }

    private boolean isValidPath(String path){
        //invalid charactor is \:,;*?"<>|
        String[] invalidChars = {"\\", ":", ",", ";", "*", "?", "\"", "<", ">", "|"};
        for(int i = 0; i < invalidChars.length; i++){
            if(path.indexOf(invalidChars[i]) != -1){
                return false;
            }
        }
        return true;
    }
    
    private void setSuccess(HttpServletRequest request){
        NSActionUtil.setSessionAttribute(request, NSActionConst.SESSION_SUCCESS_ALERT, "true");
    }
    
    private String getErrorMessage(String errorCode, HttpServletRequest request){
        String errorMessage = null;
        Locale locale = request.getLocale();
        MessageResources messages = getResources(request);
        MessageResources commonMessages = (MessageResources) getServlet().getServletContext().getAttribute("common");
        //getResources(request, "common");
        
        if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRMAKE_DIR_EXISTS)){
            errorMessage = commonMessages.getMessage(locale,"common.alert.failed") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.directory_make.dirExists.alert");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRMAKE_MK_FAILED)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirMakeFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirMakeFailed.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRMAKE_DIR_TOOLONG)){
            errorMessage = commonMessages.getMessage(locale, "common.alert.failed") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.directory.too_long") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.directory255_fullPath4095") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.exportEncoding");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_NOT_EMPTY)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirNotEmpty.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_IN_CIFS_SHARE)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirCIFSOccupy.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_IN_NFS_SHARE)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirNFSOccupy.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_DIR_ACCESS_CTR)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirAccessCtrl.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_READONLY_FS)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.underReadonlyFS.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_UNDER_NV_RESV)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.underNVResv.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_MOUNT_POINT)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.mountPoint.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRDEL_DIR_NOT_EXIST)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirDeleteFailed.generalInfo") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirNotExists.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRMAKE_WRONG_ACL_ENC)){
            errorMessage = commonMessages.getMessage(locale,"common.alert.failed") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.error.dirMakeACLorEncoding.detailInfo");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRMAKE_CHOWN_ERROR)){
            errorMessage = messages.getMessage(locale, "cifs.error.dirMakeFailed.unknownError");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_DIRECTORY_OVER240_BY_UTF8_NFC)){
            errorMessage = commonMessages.getMessage(locale, "common.alert.failed") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.directory.too_long") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.utf8nfc_over240");
        }else if(errorCode.equalsIgnoreCase(CifsActionConst.ERRCODE_CIFS_DIRMAKE_FULL_PATH_OVER4095)){
            errorMessage = commonMessages.getMessage(locale, "common.alert.failed") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.fullPath.too_long") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.directory255_fullPath4095") + "\\r\\n" +
                           messages.getMessage(locale, "cifs.alert.invalidLength.exportEncoding");
        }
        return errorMessage;
    }
}