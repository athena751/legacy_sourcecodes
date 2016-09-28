/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.nsgui.exception;

import java.io.InputStream;

import javax.servlet.ServletException;

import org.apache.commons.digester.Digester;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

import com.nec.nsgui.exception.conf.Dispatcher;
import com.nec.nsgui.exception.conf.ErrorMessage;
import com.nec.nsgui.exception.conf.ExceptionConf;
import com.nec.nsgui.exception.conf.ExceptionConfMap;
import com.nec.nsgui.exception.conf.ProcessRule;



public class NSExceptionPlugIn implements PlugIn {

    private static final String cvsid =
            "@(#) $Id: NSExceptionPlugIn.java,v 1.2 2004/07/13 03:49:13 wangli Exp $";
    private String confFile ="";

   /**
   * Firstly Get the ExcptiongConf Object  according to the exception config file;
   * @param servlet The ActionServlet making this request
   * @param config Module config of the module 
   */
    public void init(ActionServlet servlet, ModuleConfig config)
        throws ServletException {
        ExceptionConf exceptionConf = new ExceptionConf();
        if (confFile == null || confFile.equals("")) {
            throw new ServletException("The conf file of NSExceptionPlugIn has not been specified.");
        }
        try {
            String[] files = confFile.split(",");
            if (files != null) {
                for (int i = 0; i < files.length; i++) {
                    InputStream input =
                        servlet.getServletContext().getResourceAsStream(
                            files[i].trim());
                    exceptionConf.addAll(parse(input));
                }
            }
            ExceptionConfMap.getInstance().addExceptionConf(
                config.getPrefix(),
                exceptionConf);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
    public void destroy() {
    }
    public String getConfFile() {
        return confFile;
    }
    public void setConfFile(String file) {
        confFile = file;
    }
  
    /**
      * read the exception config file by means of Digester,
      * and genetat the responding object
      * @param servlet The ActionServlet making this request
      * @param inputStream The Exception config file content 
      * 
      */
    
    protected ExceptionConf parse(InputStream inputStream) throws Exception{

        Digester dgstr = new Digester();
        ExceptionConf exConf ;
        dgstr.setValidating(false);
        dgstr.setUseContextClassLoader(true);

        dgstr.addObjectCreate("ExceptionConf", ExceptionConf.class);
        
        //creat and add the ProcessRule object
        dgstr.addObjectCreate("ExceptionConf/ProcessRule", ProcessRule.class);
        dgstr.addSetProperties("ExceptionConf/ProcessRule");
        dgstr.addSetNext("ExceptionConf/ProcessRule", "addProcessRule");
        
        //creat and add the ProcessRule object 's child (ErrorMessage)
        dgstr.addObjectCreate(
            "ExceptionConf/ProcessRule/ErrorMessage",
            ErrorMessage.class);
        dgstr.addSetProperties("ExceptionConf/ProcessRule/ErrorMessage");
        //add the ErrorMessage 's child (arg)
        dgstr.addCallMethod(
            "ExceptionConf/ProcessRule/ErrorMessage/arg",
            "addArg",1);
        dgstr.addCallParam("ExceptionConf/ProcessRule/ErrorMessage/arg",0,"property");
        dgstr.addSetNext("ExceptionConf/ProcessRule/ErrorMessage", "addErrMsg");
        
        //creat and add the ProcessRule object 's child (Dispatcher)
        dgstr.addObjectCreate(
            "ExceptionConf/ProcessRule/Dispatcher",
            Dispatcher.class);
        dgstr.addSetProperties("ExceptionConf/ProcessRule/Dispatcher");
        dgstr.addObjectCreate("ExceptionConf/ProcessRule/Dispatcher/ErrorMessage",ErrorMessage.class);
        dgstr.addSetNext("ExceptionConf/ProcessRule/Dispatcher/ErrorMessage","addErrMsg");
        dgstr.addSetProperties("ExceptionConf/ProcessRule/Dispatcher/ErrorMessage");
        dgstr.addSetNext(
            "ExceptionConf/ProcessRule/Dispatcher",
            "addDispatcher");    
        
        exConf = (ExceptionConf) dgstr.parse(inputStream);
      
        return exConf;
    }

}