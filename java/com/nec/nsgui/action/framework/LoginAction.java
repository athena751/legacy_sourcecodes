/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.framework;

import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.Globals;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.account.UserManager;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.framework.LoginHandler;
import com.nec.nsgui.model.biz.system.NodeManager;
import com.nec.nsgui.model.entity.account.NSUser;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;
import com.nec.nsgui.model.biz.framework.NSTimeout;
import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.entity.framework.FrameworkConst;

public class LoginAction extends Action {
    public static final String cvsid =
        "@(#) $Id: LoginAction.java,v 1.7 2009/04/10 09:21:33 liul Exp $";

    public synchronized ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        
        NSTimeout.getInstance().fresh();
        SessionManager sm = SessionManager.getInstance();
        LoginHandler loginHandler = LoginHandler.getInstance();
        
        DynaActionForm inputForm = (DynaActionForm) form;
        
        request.getSession().invalidate();
        
        Locale userLocale = request.getLocale();
        request.getSession().setAttribute(Globals.LOCALE_KEY, userLocale);
        
        String titleHost = "";
        String hostName = loginHandler.getHostname();
        if (hostName != null && !hostName.trim().equals("")) {
            titleHost = "(" + hostName.trim() + ")";
        }
        request.getSession().setAttribute("titleHost", titleHost);

        if(!loginHandler.checkProductName()[0].equals("normal")){
        	return mapping.findForward("loginShow");
        }
        
        if(sm.isExistSession(request.getSession().getId())){
            request.setAttribute("USERWRONG", "EXISTSESSION");
            setRemainder2request(null , request);
            return mapping.findForward("userwrong");
        }

        String userName = (String) inputForm.get("username");
        if((userName == null) || userName.equals("")){
            ///deal for request framework/login.do directly
            return mapping.findForward("loginShow");
        }
        userName =
            NSActionUtil.reqStr2EncodeStr(userName, NSActionConst.BROWSER_ENCODE);
        inputForm.set("username", userName);
        
        String password = (String) inputForm.get("_password");
        boolean isSuperUser = false;
        if (userName.equals("-nsadmin")) {
            isSuperUser = true;
            userName = userName.substring(1);
        }

        // 1.check password
        int result = checkPasswd(userName, password);
        if (result == 1) {
            request.setAttribute("USERWRONG", "PERMISSION");
            request.setAttribute("username", userName);
            return mapping.findForward("userwrong");
        } else if (result == 2) {
            request.setAttribute("USERWRONG", "PASSWORD");
            request.setAttribute("username", userName);
            return mapping.findForward("userwrong");
        }
        NSReporter.getInstance().report(NSReporter.DEBUG,
                                userName+": password OK");
                                
        // 2 check max session
        if (!sm
            .checkMaxSessions(
                userName,
                isSuperUser,
                request.getSession())) {
            request.setAttribute("username", userName);
            request.setAttribute("maxsession", "" + sm.getMaxSession(userName));

            Vector vec =
                (Vector) (sm.getActiveSessionsInfo(request).get(userName));
            SortTableModel tableMode = new ListSTModel(vec);
            request.setAttribute("loginUsers", tableMode);
            setRemainder2request(userName, request);
            return mapping.findForward("maxsession");
        }

        NSReporter.getInstance().report(
            NSReporter.INFO,
            userName
                + "("
                + request.getRemoteAddr()
                + "): "
                + getResources(request).getMessage(
                    request.getLocale(),
                    "login.success"));

        request.getSession().setAttribute(
            NSActionConst.SESSION_AUTHENTICATED,
            "true");
        request.getSession().setAttribute(
            NSActionConst.SESSION_USERINFO,
            userName);
        request.getSession().setAttribute(
            NSActionConst.SESSION_BROWSER,
            request.getHeader("user-agent"));
        request.getSession().setAttribute(
            NSActionConst.SESSION_REMOTEADDR,
            request.getRemoteAddr());
        request.getSession().setAttribute(
            NSActionConst.SESSION_LOGINTIME,
            new Date());
        request.getSession().setAttribute(
            NSActionConst.SESSION_LANG,
            request.getParameter("currentLang"));
        
        if(userName.equals(NSActionConst.NSUSER_NSADMIN)) {
            String timeout = NSTimeout.getInstance().getNsadminTimeout();
            request.getSession().setMaxInactiveInterval(Integer.parseInt(timeout) * 60);
            } else {
                String timeout = NSTimeout.getInstance().getNsviewTimeout();
                request.getSession().setMaxInactiveInterval(timeout.startsWith("-") ? -1 : 
                    Integer.parseInt(timeout) * 60);
            }

        if (NodeManager.getInstance().isNeedClusterSetting()) {
            ///must be nsadmin
            return mapping.findForward("settingcluster");
        } else {
            return mapping.findForward("main");
        }

    }
    
    private void setRemainder2request(String userName, HttpServletRequest request) throws Exception{
        if (userName != null && !userName.equals(NSActionConst.NSUSER_NSADMIN)){
            return;
        }
        long remainder = 0; 
        if (userName == null ){// for the case of duplicaton session logged in.
            remainder =  request.getSession().getMaxInactiveInterval()/60;
        }else{//for the case of nsadmin has already logged in.
            SessionManager sm = SessionManager.getInstance();
            List tmpVec = sm.getUserActiveSessions(userName);
            Iterator it = tmpVec.iterator();
            while (it.hasNext()){
                HttpSession tmpSession = (HttpSession)it.next();
                long tmp = (System.currentTimeMillis() 
                           - tmpSession.getLastAccessedTime())/60000;
                tmp =  tmpSession.getMaxInactiveInterval()/60 - tmp;
                if (remainder < tmp){
                    remainder = tmp;
                }
            }
        }
        request.setAttribute("remainder","" + remainder);
        String versionType = NSModelUtil.getValueByProperty(
                FrameworkConst.PATH_OF_TOMCAT_CONF, FrameworkConst.VERSION_KEY);
        request.setAttribute("versionType", versionType);
    }

    /**
    * @param name
    * @param passwd
    * @return
    *      0 -- right
    *      1 -- user not permission
    *      2 -- password wrong 
    * @throws Exception
    */
    public int checkPasswd(String name, String passwd) throws Exception {
        if (name == null) {
            return 1;
        }
        NSUser user = UserManager.getInstance().getNSUserByUserName(name);
        if (user == null) {
            return 1;
        } else if (!(UserManager.getInstance().checkLogin(name, passwd))) {
            return 2;
        }
        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            name + ": password OK");
        return 0;
    }
    
}
