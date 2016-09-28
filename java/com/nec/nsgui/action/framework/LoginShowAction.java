/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.framework;

import java.net.InetAddress;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.Globals;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.framework.LoginHandler;

public class LoginShowAction extends Action {
    public static final String cvsid =
        "@(#) $Id: LoginShowAction.java,v 1.2 2008/06/06 01:16:36 hetao Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
         
        LoginHandler loginHandler = LoginHandler.getInstance();
        String  currentLang;
        Locale userLocale = request.getLocale();
        if (userLocale.getLanguage().equals(new Locale("ja", "", "").getLanguage())) {
            currentLang = "ja";
        }else{
            currentLang = "en";
        }
        request.setAttribute("currentLang", currentLang);
        
        //NSMessageDriver.getInstance().setCurrentLang(currentLang); set in login.jsp
        request.getSession().setAttribute(Globals.LOCALE_KEY, userLocale);
        
        /// 1.set titleHost to request 
        String titleHost = "";
        String hostName = loginHandler.getHostname();
        if(hostName != null && !hostName.trim().equals("")){
            titleHost = "(" + hostName.trim() + ")";
        }
        request.getSession().setAttribute("titleHost", titleHost);
        request.setAttribute("titleHost", titleHost);
        
        /// to check if this url is on the fip node
        String myName = request.getServerName().toString();
        String myAddr = null;
        try{
            InetAddress addr = InetAddress.getByName(myName);
            myAddr = addr.getHostAddress();
        }catch(Exception e){
            NSReporter.getInstance().report(NSReporter.INFO,e.toString());
        }
        String nodeFip = loginHandler.getUrlNodeFip(myAddr);
        String[] array = nodeFip.split("#");
        if(!array[0].equals("0")){
            Integer myPort = new Integer(request.getServerPort());
            String URL = null;
            if(myPort.toString().equals("8585")){
                URL = "http://"+ array[1] +":"+ myPort +"/nsadmin/";
            }else{
                URL = "https://"+ array[1] +":"+ myPort +"/nsadmin/";
            }
            
            String urlType = array[0].equals("1") ? "NORMAL_TOE" : "REDUCE_TOE";
            request.setAttribute("IPTYPE" , urlType);
            request.setAttribute("URL" , URL);
            return mapping.findForward("nofip");
        }
        
        /// 2.get information for browser: userAgent and from
        String userAgent = ""; 
        if(request.getHeader("user-agent") != null){
            userAgent = request.getHeader("user-agent");
        }else{
            userAgent = getResources(request).getMessage(userLocale , "login.notice.unknown");            
        }
        request.setAttribute("userAgent" , userAgent);
        
        String from = request.getRemoteAddr();
        if (request.getRemoteHost() != null &&
            !request.getRemoteHost().equals(from)){
                from = from + " (" + request.getRemoteHost() + ")";
        }
        request.setAttribute("from" , from);

        /// 3.get notesFile and othersFile 's content
        String notesFile  = NSActionConst.ETC_PATH + "/notes/nsgui." + currentLang;
        String othersFile = NSActionConst.ETC_PATH + "/notes/other";
        StringBuffer sb = loginHandler.getFileContent(notesFile , "EUC-JP");
        if(sb != null){
            request.setAttribute("notesFile" , sb.toString());                
        }
        sb = loginHandler.getFileContent(othersFile, "EUC-JP");
        if(sb != null){
            request.setAttribute("othersFile" , sb.toString());
        }

        /// 4 set session variable 
        //request.getSession().setAttribute(NSActionConst.SESSION_AUTHENTICATED, "-");
        //request.getSession().removeAttribute(NSActionConst.SESSION_USERINFO);
        String  originalURI = (String)request.getAttribute(NSActionConst.FORM_ORIGINALURI);
        originalURI = (originalURI == null) ? "main.jsp" : originalURI;
        request.setAttribute("originalURI", originalURI);
        
        return mapping.findForward("login");
    }
}
