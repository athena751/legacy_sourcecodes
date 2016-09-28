/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.base;

import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import java.lang.reflect.*;

public abstract class TemplateBean extends AbstractJSPBean {

    private static final String cvsid = "@(#) $Id: TemplateBean.java,v 1.2301 2007/04/26 05:42:47 liul Exp $";
    
    public static final String FIRST_LOAD = "display";
    private static final String METHOD_PREFIX = "on";
    private String operation;           // submit operation in page
    private String redirectUrl;         // the page url to redirect after operation finished

    public TemplateBean() {
    }

    /** Override method in AbstractJSPBean. 
     *  According to the operation, invoke the method that implements in it's subClass.
     */
    protected void beanProcess() throws Exception {
        if(operation == null || operation.trim().equals("")) {
            operation = FIRST_LOAD;
        }
        String methodName = getMethodName(operation);
        Method method = this.getClass().getDeclaredMethod(methodName, new Class[0]);
        try {
            init();
            try {
                method.invoke(this, new Object[0]);
            } catch(InvocationTargetException ex) {
                Throwable throwable = ex.getTargetException();
                if(throwable instanceof NSException){
                    throw (NSException)throwable;
                } else {
                    throw new Exception(throwable);
                }
            }
        } catch(Exception ex) {
            errorHandle(ex);
        }

        if(redirectUrl != null) {
            response.sendRedirect(response.encodeRedirectURL(redirectUrl));
        }
    }
    
    /** To deal with the errors that throws in the methods handling operations.
     */
    protected void errorHandle(Exception ex) throws Exception {
        throw ex;
    }
    
    /** This method will be call before the method handling operation.
     */
    protected void init() throws Exception {
    }
    
    /** Deal with the operation "display".
     *  "display" means that the page displays in browser, no submit is done.
     */
    public abstract void onDisplay() throws Exception;
    
    /** Make the method name according to the value of operation.
     * @op -- the operation.
     */
    private String getMethodName(String op) {
        return METHOD_PREFIX + (op.toUpperCase()).charAt(0) + op.substring(1);
    }
    
    public void setRedirectUrl(String url) {
        redirectUrl = url;
    }
    
    public void setSession(String s_name, Object s_obj) {
        session.setAttribute(s_name, s_obj);
    }
    
    public Object getSession(String s_name) {
        return session.getAttribute(s_name);
    }

    public void setOperation(String op) {
        operation = op;
    }

    public String getOperation() {
        return operation;
    }
}