/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.snmp.SnmpCmdHandler;
import com.nec.nsgui.model.entity.snmp.UserInfoBean;

/**
 *Actions for user
 */
public class SnmpUserAction extends SnmpAction {
    private static final String cvsid = "@(#) $Id: SnmpUserAction.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";

    //edit by cuihw
    public ActionForward displayList(
            ActionMapping mapping,
            ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        clearSession(request);
        HashMap infoHash = SnmpCmdHandler.getSnmpUserList(false);
        HashMap errorHash = new HashMap();
        
        errorHash.put(ERRCODE_RECOVERY, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                request.setAttribute("userList", info);
                request.setAttribute("recoveryFlag", "true");
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        errorHash.put(ERRCODE_USER, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                request.setAttribute("userList", info);
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
		errorHash.put(ERRCODE_USER_IPTABLE, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				request.setAttribute("userList", info);
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
			}
		});
        exceptionHandler(request,infoHash,errorHash,new NormalProcessor(){
            public void processNormal(Object info)throws Exception{
                request.setAttribute("userList", info);
            }
        });
        return mapping.findForward("displayListTop");
    }
    
    //edit by zhangjun
    public ActionForward displaySetFrame(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response){
        String userName = request.getParameter("selectedUser");
        NSActionUtil.setSessionAttribute(request, "userName", userName);
        
        return mapping.findForward("displaySetFrame");
    }
    //edit by zhangjun
    public ActionForward displaySet(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        DynaActionForm userForm = (DynaActionForm)
                NSActionUtil.getSessionAttribute( request, SESSION_SNMP_USERFORM );
        
        if( userForm == null ){
            String userName = (String)NSActionUtil.getSessionAttribute( request, "userName");
            if(userName.equals("")){
                ((DynaActionForm) form).set("operate","add");
                ((DynaActionForm) form).set("userInfo",new UserInfoBean() );
            }else{
                ((DynaActionForm) form).set("operate","modify");
                UserInfoBean userInfo = SnmpCmdHandler.getUserInfo(userName);
                ((DynaActionForm) form).set("userInfo",userInfo);
            }
        }else{
            ((DynaActionForm) form).set("userInfo",(UserInfoBean)userForm.get("userInfo"));
            ((DynaActionForm) form).set("operate",(String)userForm.get("operate"));
        }
        
        return mapping.findForward("displaySetTop");
    }
    //edit by zhangjun
    public ActionForward add(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        NSActionUtil.setSessionAttribute(request, SESSION_SNMP_USERFORM, (DynaActionForm)form);

        final UserInfoBean userInfo = (UserInfoBean)((DynaActionForm)form).get("userInfo");
        partnerFailedHandle(request,new PartnerFailedProcessor(){
            public void process()throws Exception{
                SnmpCmdHandler.addUser(userInfo);
            }
        });
        
        return mapping.findForward("enterUserList");
    }
    //edit by zhangjun
    public ActionForward modify(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        NSActionUtil.setSessionAttribute(request, SESSION_SNMP_USERFORM, (DynaActionForm)form);

        final UserInfoBean userInfo = (UserInfoBean)((DynaActionForm)form).get("userInfo");
        partnerFailedHandle(request,new PartnerFailedProcessor(){
            public void process()throws Exception{
                SnmpCmdHandler.modifyUser(userInfo);
            }
        });
        
        return mapping.findForward("enterUserList");
    }
    //edit by cuihw
    public ActionForward delete(
           ActionMapping mapping,
           ActionForm form,
           HttpServletRequest request,
           HttpServletResponse response)
           throws Exception {
       
       final String userName = request.getParameter("selectedUser");
       partnerFailedHandle(request,new PartnerFailedProcessor(){
           public void process()throws Exception{
               SnmpCmdHandler.deleteUser(userName);
           }
       });
       return mapping.findForward("enterUserList");
    }
}