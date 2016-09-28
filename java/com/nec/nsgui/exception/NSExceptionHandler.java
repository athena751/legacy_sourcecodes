/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.nsgui.exception;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.Globals;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ExceptionHandler;
import org.apache.struts.config.ExceptionConfig;
import org.apache.struts.util.MessageResources;
import org.apache.struts.util.RequestUtils;
import org.apache.struts.util.ModuleUtils;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.exception.conf.Dispatcher;
import com.nec.nsgui.exception.conf.ErrorMessage;
import com.nec.nsgui.exception.conf.ExceptionConf;
import com.nec.nsgui.exception.conf.ExceptionConfMap;
import com.nec.nsgui.exception.conf.ProcessRule;
import com.nec.nsgui.model.biz.base.NSException;

/**
 * An ExceptionHandler is configured in the Struts configuration file 
 * to handle the NSException thrown by an Action's execute method.
 */

public class NSExceptionHandler
    extends ExceptionHandler
    implements NSActionConst {

    private static final String cvsid =
        "@(#) $Id: NSExceptionHandler.java,v 1.12 2008/05/28 03:08:07 liy Exp $";
    /**
    * Firstly Get the ExcptiongConf Object from ServletContent according to the module name;
    * Then according to error code ,get the message from ExcptiongConf.
    * put the responding message into NSException Object,then put NSException object
    * into request or session.
    * Return the ActionForward instance (if any) accoring to the ExcptiongConf ;
    * @param mapping The ActionMapping used to select this instance
    * @param formInstance The optional ActionForm bean for this request (Here is no use)
    * @param request The HTTP request we are processing
    * @param response The HTTP response we are creating(Here is no use )
    * @param ec The ExceptionConfig corresponding to the exception
    * @param ex Action's execute method throw the exception 
    */
    public ActionForward execute(
        Exception ex,
        ExceptionConfig ec,
        ActionMapping mapping,
        ActionForm formInstance,
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException {
        
        //add exception object to session for error display by wangli 2004/7/12
        request.getSession().setAttribute(SESSION_EXCEPTION_OBJECT, ex);

        if (!(ex instanceof NSException)) {
            throw new ServletException(ex);

        }
        NSExceptionMessage nsem = new NSExceptionMessage();
        ActionForward forward = mapping.getInputForward(); /*default forward*/
        com.nec.nsgui.model.biz.base.NSException nsex = (NSException) ex; 
        ServletContext context = request.getSession().getServletContext();
        String module = ModuleUtils.getInstance().getModuleName(request, context);
        ExceptionConfMap confMap = ExceptionConfMap.getInstance();
        ExceptionConf conf = confMap.getExceptionConf(module);
        if (conf == null) {
            throw new ServletException(nsex);
        }
 
        String errCode = nsex.getErrorCode();
        ProcessRule pr = conf.getProcessRule(errCode);
        if (pr == null) {
            throw new ServletException(nsex);
        }
        String displayDetail = pr.getDisplayDetail();
        
        if (displayDetail == null || displayDetail.equals("")){
            displayDetail = "true";
        }   
        nsem.setDisplayDetail(displayDetail);
        nsem.setLevel(pr.getLevel()==null?ERROR_LEVEL_ERROR:pr.getLevel());
        
        // modify for support DispatchAction's  parameter
        Dispatcher dp = null;
        String actionPath = mapping.getPath();
        String dispatchActionPath = null;
        String actionParameter = mapping.getParameter();
        if(actionParameter != null){
            // only DispatchAction has parameter
            String operation =(String)request.getParameter(actionParameter);
            if(operation != null){
                dispatchActionPath = actionPath + "?"+ actionParameter + "=" + operation;
                //get dispatcher for DispatchAction method
                dp = pr.getDispatcher(dispatchActionPath); 
            }
        }

        if (dp == null) {
            //if DispatchAction method's dispatcher is not defined, 
            //get dispatch for DispathAction  or common Action
            dp = pr.getDispatcher(actionPath);
        }
        
        if (dp == null) {
            //get Default Dispatcher
            dp = pr.getDispatcher("");
        }
          
        if (dp == null) {

            if (forward == null) {
                throw new ServletException("Can not get the input forward according to the struts config file.");
            }
            storeErrMsg(nsem,nsex, request, pr.getErrMsgList(), ec.getScope());
            return forward;
        } else {
            List sonList = dp.getErrMsgList();
            List parentList = pr.getErrMsgList();
            List errList = overrideMessage(parentList,sonList);
            if (errList != null && errList.size() > 0) {
                storeErrMsg(nsem,nsex, request, errList, ec.getScope());
            }

            forward = mapping.findForward(dp.getForward());
            if (forward == null) {
                throw new ServletException(
                    "Can not get the forward '"
                        + dp.getForward()
                        + "' according to the exception config file.");
            } 
            return forward;
        }

    }
    /**
    * Get the resource according to the specified bundle
    * get the message accoring to the key from the resource
    * When message need the args ,get the args from request(parameter/attribute) or session.
    * @param ex Action's execute method throw the exception 
    * @param errMsgList The errorMsg list specified in the config xml
    * @param request The HTTP request we are processing
    * @param scope Session/Request
    */
    private void storeErrMsg(NSExceptionMessage nsem,
        NSException ex,
        HttpServletRequest request,
        List errMsgList,
        String scope)
        throws ServletException {

        
        MessageResources resources;
        Locale userLocale;
        String[] argMsgArray;
        String key = "";
        String type = "";
        List args;
        String msg = "";
      
        for (int i = 0; i < errMsgList.size(); i++) {
            ErrorMessage err = (ErrorMessage) errMsgList.get(i);
            userLocale = retrieveUserLocale(request);
            resources = retrieveResources(request, err.getBundle());
            argMsgArray = organizeArg(request, err.getArgList());
            key = err.getKey();
            type = err.getType();
           
            if (argMsgArray != null && (argMsgArray.length != 0)) {
                msg = resources.getMessage(userLocale, key, argMsgArray);
            } else {
                msg = resources.getMessage(userLocale, key);
            }
            if (msg == null || msg.equals("")) {
                throw new ServletException(
                    "Can not get the message according the key '" + key + "'.");
            }
            if (type.equals("generalInfo")) {
                nsem.appendGeneralInfo(msg);
            } else if (type.equals("generalDeal")) {
                nsem.appendGeneralDeal(msg);
            } else if (type.equals("detailInfo")) {
                nsem.appendDetailInfo(msg);
            } else if (type.equals("detailDeal")) {
                nsem.appendDetailDeal(msg);
            }

            nsem.setCauseException(ex);
           
            if (scope.equals("request")) {
                request.setAttribute(SESSION_EXCEPTION_MESSAGE, nsem);
            } else {
                request.getSession().setAttribute(
                    SESSION_EXCEPTION_MESSAGE,
                    nsem);
            }
        } //end for 

    }

    /**
    * Get the arg form request or session.
    * @param request The HTTP request we are processing
    * @param args The arg list specified in the config xml 
    */
    private String[] organizeArg(HttpServletRequest request, List args)
        throws ServletException {
        if (args == null || (args.size() == 0)) {
            return new String[0];
        }
        String[] argMsgArray = new String[args.size()];
        String tmpMsg = "";
        String arg = "";
        for (int i = 0; i < args.size(); i++) {
            arg = (String) args.get(i);
            tmpMsg = (String) request.getParameter(arg);
            if (tmpMsg == null) {
                if ((tmpMsg = (String) request.getAttribute(arg)) == null) {
                    if ((tmpMsg =
                        (String) request.getSession().getAttribute(arg))
                        == null) {
                        tmpMsg =
                            (String) request
                                .getSession()
                                .getServletContext()
                                .getAttribute(
                                arg);
                    }
                }
            }
            if (tmpMsg == null) {
                throw new ServletException(
                    "The arg '"
                        + arg
                        + "' does not exist in session or request.");

            }
            argMsgArray[i] = tmpMsg;
        }
        return argMsgArray;
    }

    /**
    * Get the MessageResources form request or ServletContext.
    * @param request The HTTP request we are processing
    * @param bundle The MessageResources bundle key which is specified in the config xml 
    */
    private MessageResources retrieveResources(
        HttpServletRequest request,
        String bundle)
        throws ServletException {
        if (bundle == null || bundle.equals("")) {
            bundle = Globals.MESSAGES_KEY;
        }
        MessageResources resources =
            (MessageResources) request.getAttribute(bundle);
        if (resources == null) {
            resources =
                (MessageResources) request
                    .getSession()
                    .getServletContext()
                    .getAttribute(
                    bundle);
            if (resources == null) {
                throw new ServletException(
                    "Can not get the resource message according to the bundle '"
                        + bundle
                        + "'.");
            }
        }
        return resources;
    }

    /**
    * Look up and return current user locale
    * @param request The HTTP request we are processing
    */
    private Locale retrieveUserLocale(HttpServletRequest request) {
        Locale userLocale = null;
        HttpSession session = request.getSession();

        // Only check session if sessions are enabled
        if (session != null) {
            userLocale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
        }

        if (userLocale == null) {
            // Returns Locale based on Accept-Language header or the server default
            userLocale = request.getLocale();
        }

        return userLocale;
    }
    
    private List overrideMessage(List parentList, List sonList){
        List retList = new ArrayList();
        
        if (sonList != null && sonList.size()>0){        
            retList.addAll(sonList);
        }
        if (parentList != null && parentList.size()>0){
            for (int i = 0; i < parentList.size(); i++){
                ErrorMessage em = (ErrorMessage)parentList.get(i);
                if (!hasType(em.getType(),sonList)){
                    retList.add(em);
                }
            }
        }
        return retList;
    }
    
    private boolean hasType(String type, List msgList){
        for (int i = 0; i < msgList.size(); i++){
            ErrorMessage em = (ErrorMessage)msgList.get(i);
            if (em.getType().equals(type)){
                return true;            
            }
        }
        return false;    
    }
}
