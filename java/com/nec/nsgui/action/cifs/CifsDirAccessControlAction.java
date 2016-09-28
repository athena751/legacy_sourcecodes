/*
 *      Copyright (c) 2004-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.validator.DynaValidatorForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.entity.cifs.DirAccessControlInfoBean;

/**
 *Actions for direct edit page
 */
public class CifsDirAccessControlAction extends DispatchAction implements CifsActionConst, NSActionConst{
    private static final String cvsid = "@(#) $Id: CifsDirAccessControlAction.java,v 1.4 2006/02/15 07:54:52 fengmh Exp $";
    
    /**
     * display the directory access control list
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward displayList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String shareName = request.getParameter("shareName");
        if(shareName != null){
            session.setAttribute(CifsActionConst.SESSION_SHARE_NAME, shareName);
        }
        String sharedDirectory; 
        sharedDirectory = request.getParameter("sharedDirectory");
        if(sharedDirectory != null){
            sharedDirectory = NSActionUtil.reqStr2EncodeStr(sharedDirectory, BROWSER_ENCODE);
            sharedDirectory = getValidDir(sharedDirectory);
            session.setAttribute(CifsActionConst.SESSION_SHARED_DIRECTORY, sharedDirectory);
        }
        return mapping.findForward("displayList");
    }
    
    private String getValidDir(String dir){
        while(dir.endsWith("/")){
            dir = dir.substring(0, dir.length()-1);
        }
        return dir;
    }

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
        String shareName = (String)session.getAttribute(CifsActionConst.SESSION_SHARE_NAME);
        
        request.setAttribute("shareNameForDisplay", NSActionUtil.reqStr2EncodeStr(shareName, BROWSER_ENCODE));
        
        shareName = NSActionUtil.page2Perl(shareName, request);
        

        List dirAccessInfoList = CifsCmdHandler.getDirAccessControlList(group, domainName, computerName, shareName);
        changEncodingForPage(dirAccessInfoList, request);
        request.setAttribute("dirAccessInfoList", dirAccessInfoList);
   
       
        return mapping.findForward("displayList_topPage");
    }

    
    private void changEncodingForPage(List dirAccessList, HttpServletRequest request)throws Exception{
        int size =  dirAccessList.size();
        for(int i = 0; i< size; i++){
            DirAccessControlInfoBean dirAccessInfo = (DirAccessControlInfoBean)dirAccessList.get(i);
            dirAccessInfo.setDirectory(
                    NSActionUtil.perl2Page(
                    dirAccessInfo.getDirectory(),request)
                );
            dirAccessInfo.setDirectory_td(dirAccessInfo.getDirectory());
            dirAccessInfo.setDirAccessInfo(dirAccessInfo.getAllowHost()+ ","
                    + dirAccessInfo.getDenyHost() + "," + dirAccessInfo.getDirectory()
                );
        }
    }

    /**
     * display the botton [Modify...] [Delete]
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
        
        return mapping.findForward("displayList_bottomPage");
    }

    /**
     * delete a directory access control
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward deleteDirAccessControl(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int group = NSActionUtil.getCurrentNodeNo(request);
        
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        String shareName = (String)session.getAttribute(CifsActionConst.SESSION_SHARE_NAME);
        shareName = NSActionUtil.page2Perl(shareName, request);
        
        String directory = request.getParameter("directory");
        directory = NSActionUtil.page2Perl(directory, request);
        
        //delete the directory entry
        CifsCmdHandler.deleteDirAccessControl(group, domainName, computerName, shareName, directory);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("reloadTop");
    }



    public ActionForward displaySettingPage(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        HttpSession session = request.getSession();
	
        String shareName = (String)session.getAttribute(CifsActionConst.SESSION_SHARE_NAME);
		session.setAttribute("shareNameForDisplay", NSActionUtil.reqStr2EncodeStr(shareName, BROWSER_ENCODE));
		String operationType =(String)session.getAttribute(CifsActionConst.SESSION_SET_DIR_OPERATION);
        ((DynaValidatorForm)form).set("operationType", operationType);		
       
        if(operationType != null && operationType.equals("modify")){
			DirAccessControlInfoBean sessionInfo=(DirAccessControlInfoBean)session.getAttribute(SESSION_SET_DIR_INFO);
            String directory = sessionInfo.getDirectory();
            directory = NSActionUtil.reqStr2EncodeStr(directory, BROWSER_ENCODE);   
			sessionInfo.setDirectory(directory);
			sessionInfo.setAllowHost(sessionInfo.getAllowHost());
			sessionInfo.setDenyHost(sessionInfo.getDenyHost());	
			((DynaValidatorForm)form).set("dirAccessControlInfo", sessionInfo);		
        }
	
        return mapping.findForward("displaySettingPage");
    }

    public ActionForward setDirAccessControl(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
    
        int group = NSActionUtil.getCurrentNodeNo(request);
        HttpSession session = request.getSession();
        String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
        String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
        String shareName = (String)session.getAttribute(CifsActionConst.SESSION_SHARE_NAME);
        
        request.setAttribute("shareNameForDisplay", NSActionUtil.reqStr2EncodeStr(shareName, BROWSER_ENCODE));
        
        shareName = NSActionUtil.page2Perl(shareName, request);
        String operationType = (String)((DynaValidatorForm) form).get("operationType");
        DirAccessControlInfoBean dirAccessInfo = (DirAccessControlInfoBean)((DynaValidatorForm) form).get("dirAccessControlInfo");

        DirAccessControlInfoBean tmpObject = (DirAccessControlInfoBean)BeanUtils.cloneBean(dirAccessInfo);

        dirAccessInfo.setDirectory(
            NSActionUtil.reqStr2EncodeStr(
                dirAccessInfo.getDirectory(),NSActionConst.BROWSER_ENCODE)
            );

        tmpObject.setDirectory(
            NSActionUtil.page2Perl(
                tmpObject.getDirectory(),request)
            );

        CifsCmdHandler.setDirAccessControl(group, domainName, computerName, operationType, shareName, tmpObject);
        
        NSActionUtil.setSuccess(request);
        return mapping.findForward("setDirForward");
    }
 
    public ActionForward backToList(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        return mapping.findForward("displayList");
    }
    
    public ActionForward loadTop4nsview(
          ActionMapping mapping,
          ActionForm form,
          HttpServletRequest request,
          HttpServletResponse response)
          throws Exception {
        
          int group = NSActionUtil.getCurrentNodeNo(request);
          HttpSession session = request.getSession();
          String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
          String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);
          String shareName = (String)session.getAttribute(CifsActionConst.SESSION_SHARE_NAME);
        
          request.setAttribute("shareNameForDisplay", NSActionUtil.reqStr2EncodeStr(shareName, BROWSER_ENCODE));
        
          shareName = NSActionUtil.page2Perl(shareName, request);
        
         String shareExist = CifsCmdHandler.getShareExist(group, domainName, computerName, shareName);
         request.setAttribute("shareExsit", shareExist);
      
          List dirAccessInfoList = CifsCmdHandler.getDirAccessControlList(group, domainName, computerName, shareName);
          changEncodingForPage(dirAccessInfoList, request);
          request.setAttribute("dirAccessInfoList", dirAccessInfoList);
     
          return mapping.findForward("displayList_topPage");
      }
   
}