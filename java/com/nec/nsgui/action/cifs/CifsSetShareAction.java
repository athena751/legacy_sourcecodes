/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.HashMap;

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
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.model.entity.cifs.ShareOptionBean;

/**
 *Actions for direct edit page
 */
public class CifsSetShareAction extends DispatchAction implements CifsActionConst{
    private static final String cvsid = "@(#) $Id: CifsSetShareAction.java,v 1.12 2008/12/09 10:11:28 chenbc Exp $";
    
	private ActionForward displayForAdd(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response)
			throws Exception {
        
			int group = NSActionUtil.getCurrentNodeNo(request);
			HttpSession session = request.getSession();
            String domainName = (String)session.getAttribute(CifsActionConst.SESSION_DOMAIN_NAME);
            String computerName = (String)session.getAttribute(CifsActionConst.SESSION_COMPUTER_NAME);

			ShareOptionBean shareOptionBean = new ShareOptionBean();
			shareOptionBean.setConnection("yes");
			shareOptionBean.setSettingPassword("yes");
            String globalVirusScanMode = CifsCmdHandler.getVirusScanMode(group, domainName, computerName);
            if(globalVirusScanMode.equalsIgnoreCase("yes")) {
                shareOptionBean.setAntiVirusForGlobal("yes");
            } else {
                shareOptionBean.setAntiVirusForGlobal("no");
            }
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
		  ((DynaValidatorForm)form).set("shareOption", shareOptionBean);
	
		  return mapping.findForward("displayPage");

		}
	

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


    /**
     * add or modify share
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
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
        boolean isSetGlobalOption =false;        
        changEncodingForForm(shareOptionBean);
        
        changEncodingForPerl(optionObject, request);

        try{
            CifsCmdHandler.setShareOption(group, domainName, computerName, optionObject);
        }catch (NSException e){
            if(e.getErrorCode().equals(ERROR_CODE_CORRESPONDING_VOLUME_USING_DMAPI)){
                //the corresponding volume is using DMAPI
                session.setAttribute(SESSION_ALERT_DMAPI_OPTION, "true");
                return mapping.findForward("displayPage");
            }else if(e.getErrorCode().equals(ERROR_CODE_SET_DIR_ACCESS_FOR_SXFSFW)){
                session.setAttribute(SESSION_ALERT_DIRACCESS_FORSXFSFW, "true");
                return mapping.findForward("displayPage");
			}else if(e.getErrorCode().equals(ERROR_CODE_SET_GLOBALOPTION)){
				isSetGlobalOption=true;
            }else if(e.getErrorCode().equals(ERRCODE_STRING_TOOLONG_BY_EXPORTENCODING)){
                //added for 0805 cifs limit
                NSActionUtil.setSessionAttribute(request, SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING, "yes");
                return mapping.findForward("displayPage");
            }else{
                throw e;
            }
        }
        if(optionObject.getShadowCopy().equals("yes")){
            
            //need to check the snapshot schedule
            String[] scheduleInfo = CifsCmdHandler.needConfirmToSnapSchedule(group, optionObject.getDirectory());
            if(scheduleInfo[0].equals("true")){
                //need confirm the user to add the snapshot schedule
                session.setAttribute(SESSION_MOUNT_POINT_FOR_SNAP_SCHEDULE, scheduleInfo[1]);

                if(shareOptionBean.getOldshadowCopy().equals("yes")){
					if(isSetGlobalOption){
                        session.setAttribute(SESSION_IS_SET_GLOBAL_DIRACCESS,"true");	
					}else{
						NSActionUtil.setSuccess(request);
					}	
                }else{
					if(isSetGlobalOption){
                        session.setAttribute(SESSION_IS_SET_GLOBAL_DIRACCESS,"true");	
					}
                    if(shareOptionBean.getOldFileTimes().equals("no")) {
                        session.setAttribute(SESSION_ALERT_FOR_SHADOWCOPY,"true");
                    } else {
                        session.setAttribute(SESSION_ALERT_FOR_SHADOWCOPY,"false");
                    }
                }
                session.setAttribute(SESSION_ALERT_FOR_SNAPSHOT,"true");
                
                return mapping.findForward("displayPage");//Display the [Add] or [Modify] share page
            }else{
                if(shareOptionBean.getOldshadowCopy().equals("yes")){
					setSuccess(isSetGlobalOption,request);
                }else{
					if(isSetGlobalOption){
						session.setAttribute(SESSION_IS_SET_GLOBAL_DIRACCESS,"true");	
					}
                    if(shareOptionBean.getOldFileTimes().equals("no")) {
                        session.setAttribute(SESSION_ALERT_FOR_SHADOWCOPY,"true");
                    } else {
                        session.setAttribute(SESSION_ALERT_FOR_SHADOWCOPY,"false");
                    }
                }
            }
        }else{
            setSuccess(isSetGlobalOption,request);
        }
        
        return mapping.findForward("forwardShareList");
    }
    
	private void  setSuccess(boolean isSetGlobalOption,HttpServletRequest request){
		if(isSetGlobalOption){
			HttpSession session = request.getSession();
			session.setAttribute(SESSION_IS_SET_GLOBAL_DIRACCESS,"true");	
		}else{
			NSActionUtil.setSuccess(request);
		}	
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

    public ActionForward addSnapshotSchedule(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        return mapping.findForward("toSnapSchedulePage");
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
	   ShareOptionBean shareOptionBean = new ShareOptionBean();
	   
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
		 
		 HashMap settingPasswordValue_key = new HashMap();
		 settingPasswordValue_key.put("yes", "cifs.shareDetail.td_yes");
		 settingPasswordValue_key.put("no", "cifs.shareDetail.td_no");
		 CommonUtil.setMsgInObj(shareOptionBean, "settingPassword", settingPasswordValue_key, getResources(request), request); 
		 
		HashMap serverProtectValue_key = new HashMap();
		serverProtectValue_key.put("yes", "cifs.shareDetial.td_serverProtect_yes");
		serverProtectValue_key.put("no", "cifs.shareDetial.td_serverProtect_no");
		CommonUtil.setMsgInObj(shareOptionBean, "serverProtect", serverProtectValue_key, getResources(request), request); 
	    
		HashMap shadowCopyValue_key = new HashMap();
		shadowCopyValue_key.put("yes", "cifs.shareDetial.td_shadowCopy_yes");
		shadowCopyValue_key.put("no", "cifs.shareDetial.td_shadowCopy_no");
		CommonUtil.setMsgInObj(shareOptionBean, "shadowCopy", shadowCopyValue_key, getResources(request), request); 
		
		HashMap dirAccessControlAvailableValue_key = new HashMap();
		dirAccessControlAvailableValue_key.put("yes", "cifs.shareDetial.td_dirAccessControlAvailable_yes");
		dirAccessControlAvailableValue_key.put("no", "cifs.shareDetial.td_dirAccessControlAvailable_no");
		CommonUtil.setMsgInObj(shareOptionBean, "dirAccessControlAvailable", dirAccessControlAvailableValue_key, getResources(request), request); 
        
        HashMap<String, String> pseudoABEValue_key = new HashMap<String, String>();
        pseudoABEValue_key.put("yes", "cifs.shareOption.checkbox_ABE_on");
        pseudoABEValue_key.put("no", "cifs.shareOption.checkbox_ABE_off");
        CommonUtil.setMsgInObj(shareOptionBean, "pseudoABE", pseudoABEValue_key, getResources(request), request); 
        
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "comment", getResources(request), request);
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "directory", getResources(request), request); 
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "writeList", getResources(request), request); 
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "validUser_Group", getResources(request), request); 
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "invalidUser_Group", getResources(request), request); 
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "hostsAllow", getResources(request), request);
		CommonUtil.setNoContentMsgInObj(shareOptionBean, "hostsDeny", getResources(request), request); 
		changEncodingForPage(shareOptionBean, request);		
		 ((DynaValidatorForm)form).set("shareOption", shareOptionBean);
		
		 return mapping.findForward("displayDetail");
   } 
}
