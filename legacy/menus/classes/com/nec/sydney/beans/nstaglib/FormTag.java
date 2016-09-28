/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

import javax.servlet.jsp.*;

public class FormTag extends BaseTag {

    private static final String cvsid = "@(#) $Id: FormTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";

    protected String action;
    protected String method = "post";
    protected String target;
    
    public FormTag() {
        this.name = "formname";
    }

    protected String buildPrefix() {
        return "form";
    }

    public void setAction(String action) {
        this.action = action;
    }
    
    /**
     * @param method The method name
     * Do nothing, the method always is "post"
     */
    public void setMethod(String method) {}
    
    public void setTarget(String target) {
        this.target = target;
    }
    
    protected String buildTagBody() {
        return "";
    }
   
    /**
     * Change onsubmit to disable the submit
     * the process of javascript is:
     *       if(!this.html_taglib_submit_name) {
     *          do something user specified
     *       } else if(eval('this.'+this.html_taglib_submit_name.value+'.disabled')==true)
     *          return false;
     *       } else {
     *          do something user specified
     *       }
     */
    protected void buildDisabledCode() {
        if (onsubmit == null) {
            onsubmit = "";
        }
        onsubmit = "if(submitDisable(this)==true){"
                 +      onsubmit + ";"
                 +      "return true;"
                 + "}else {return false;}";
    }
    
    /**
     * Change some form context, process:
     * 1. add a new FormElements into the page context
     * 2. get form number from the page context
     * 3. if no form number in the page context, put 0 in it
     *    else put current number+1 in it
     */
    protected void addDisabledStatus() throws Exception {

        Integer formNumber;
        FormElements fe;

        fe = (FormElements) pageContext.getAttribute(BaseTag.FORM_ELEMENTS);
        if (fe != null ) {
            throw new Exception(BaseTag.EXCEPTION_NO_FORM_SUFFIX);
        }
        pageContext.setAttribute(BaseTag.FORM_ELEMENTS, new FormElements()
                , PageContext.PAGE_SCOPE);       
        formNumber = (Integer) pageContext.getAttribute(BaseTag.FORM_NUMBER);
        if (formNumber == null ) {
            pageContext.setAttribute(BaseTag.FORM_NUMBER, new Integer(0)
                    , PageContext.PAGE_SCOPE);       
        } else {
            formNumber = new Integer(formNumber.intValue() + 1);
            pageContext.setAttribute(BaseTag.FORM_NUMBER, formNumber
                    , PageContext.PAGE_SCOPE);       
        }
    }

    /**
     * Return EVAL_PAGE
     * remove some form context, and output initailzing javascript
     */
    public int doEndTag() throws JspException {

        JspWriter out = pageContext.getOut();
        FormElements elements;

        try {
            elements = (FormElements) pageContext
                    .getAttribute(BaseTag.FORM_ELEMENTS);
            if (elements == null ) {
                throw new JspException(BaseTag.EXCEPTION_NO_FORM);
            }
            super.doEndTag();
            out.print(elements.getInitScript());
            pageContext.removeAttribute(BaseTag.FORM_ELEMENTS);
        } catch (Exception e) {
            throw new JspException(e.getMessage());
        }
        return EVAL_PAGE;
    }
}