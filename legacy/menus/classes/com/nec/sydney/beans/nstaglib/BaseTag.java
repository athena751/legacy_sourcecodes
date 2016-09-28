/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

import java.io.*;
import java.lang.reflect.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

public abstract class BaseTag extends TagSupport{

    private static final String cvsid = "@(#) $Id: BaseTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";

    public static final String FORM_NUMBER = "FORM_NUMBER";
    public static final String FORM_ELEMENTS = "FORM_ELEMENTS";
    public static final String SUBMIT_NAME = "html_taglib_submit_name";
    public static final String EXCEPTION_NO_FORM =
        "The nshtml tag is not included in the tag \"nshtml:form\".";
    public static final String EXCEPTION_NO_FORM_SUFFIX =
        "The \"nshtml:form\" should have a suffix.";
    public static final String EXCEPTION_NO_NAME =
        "The attribute name is not correct.";

    protected String name = null;
    protected String value = null;
    protected boolean disabled = false;
    protected String onfocus = null;
    protected String onblur = null;
    protected String onclick = null;
    protected String ondblclick = null;
    protected String onchange = null;
    protected String onsubmit = null;
    protected String onmousedown = null;
    protected String onmouseup = null;
    protected String onmouseout = null;
    protected String onmouseover = null;
    protected String onmousemove = null;
    protected String onkeyup = null;
    protected String onkeydown = null;
    protected String onkeypress = null;
    protected String onselect = null;
    protected String others = null;

    public String getName() {
        return name;
    }

    public boolean getDisabled() {
        return disabled;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public void setDisabled(boolean disabled) {
        this.disabled = disabled;
    }

    public void setOnfocus(String onfocus) {
        this.onfocus = "if(!this.disabled){" + onfocus + "}";
    }

    public void setOnblur(String onblur) {
        this.onblur = "if(!this.disabled){" + onblur + "}";
    }

    public void setOnclick(String onclick) {
        this.onclick = "if(!this.disabled){" + onclick + "}";
    }

    public void setOndblclick(String ondblclick) {
        this.ondblclick = "if(!this.disabled){" + ondblclick + "}";
    }

    public void setOnchange(String onchange) {
        this.onchange = "if(!this.disabled){" + onchange + "}";
    }

    public void setOnmousedown(String onmousedown) {
        this.onmousedown = "if(!this.disabled){" + onmousedown + "}";
    }

    public void setOnmouseup(String onmouseup) {
        this.onmouseup = "if(!this.disabled){" + onmouseup + "}";
    }

    public void setOnmouseover(String onmouseover) {
        this.onmouseover = "if(!this.disabled){" + onmouseover + "}";
    }

    public void setOnmouseout(String onmouseout) {
        this.onmouseout = "if(!this.disabled){" + onmouseout + "}";
    }

    public void setOnmousemove(String onmousemove) {
        this.onmousemove = "if(!this.disabled){" + onmousemove + "}";
    }

    public void setOnkeydown(String onkeydown) {
        this.onkeydown = "if(!this.disabled){" + onkeydown + "}";
    }

    public void setOnkeyup(String onkeyup) {
        this.onkeyup = "if(!this.disabled){" + onkeyup + "}";
    }

    public void setOnkeypress(String onkeypress) {
        this.onkeypress = "if(!this.disabled){" + onkeypress + "}";
    }

    public void setOnselect(String onselect) {
        this.onselect = "if(!this.disabled){" + onselect + "}";
    }

    public void setOthers(String others) {
        this.others = others;
    }

    public void setOnsubmit(String onsubmit) {
        this.onsubmit = onsubmit;
    }

    abstract protected void buildDisabledCode() throws Exception;

    abstract protected String buildPrefix();

    protected String buildTagBody() {
        return null;
    }

    public static String convertChars(String s){
        if (s == null) {
            return null;
        }

        s.replaceAll("<","&lt;");
        s.replaceAll(">","&gt;");
        s.replaceAll("&","&amp;");
        s.replaceAll("\"","&quot;");
        s.replaceAll("'","&#39;");

        return s;
    }

    protected void addDisabledStatus() throws Exception {

        FormElements elements = (FormElements)pageContext
                .getAttribute(FORM_ELEMENTS);
        if (elements == null) {
            throw new Exception(EXCEPTION_NO_FORM);
        }
        //elements.addElement(this.name,this.disabled);
        elements.addElement(this);

    }

    public String htmlKeyValue(Field[] field) throws Exception {

        String s = "";
        for (int i = 0; i < field.length; i++){
            
            if( field[i].getModifiers()!=Modifier.PUBLIC
                    && field[i].getModifiers()!=Modifier.PROTECTED ){
                continue;
            }

            String htmlKey = field[i].getName();
            String htmlValue = null;
            if (field[i].get(this) != null) {
                htmlValue = field[i].get(this).toString();
            }

            if (htmlKey.equals("name")) {
                continue;
            }

            if (htmlKey.equals("disabled")
                    || htmlKey.equals("readonly")
                    || htmlKey.equals("checked")){
                if (htmlValue.equalsIgnoreCase("true")) {
                    s += " " + htmlKey;
                }
            } else if (htmlKey.equals("others") 
                    && htmlValue != null 
                    && !htmlValue.equals("")){
                s += " " + htmlValue;
            } else {
                if (htmlValue!=null && !htmlValue.equals("")) {
                    s += " " + htmlKey + "=\"" + htmlValue + "\"";
                }
            }
        }

        return s;
    }

    protected String buildTagPrefix() throws Exception {

        String front = "<" + buildPrefix() + " name=\"" + name + "\"";

        Field[] superField = this.getClass().getSuperclass().getDeclaredFields();
        front += htmlKeyValue(superField);

        Field[] thisField = this.getClass().getDeclaredFields();
        front += htmlKeyValue(thisField);

        front += ">\n";
        return front;
    }

    public int doStartTag() throws JspException {

        try {
            if (name == null || name.equals("")) {
                throw new Exception(EXCEPTION_NO_NAME);
            }

            addDisabledStatus();
            buildDisabledCode();

            JspWriter out = pageContext.getOut();
            out.write(buildTagPrefix());
        } catch (Exception e) {
            throw new JspException(e);
        }
        return EVAL_PAGE;
    }

    public int doEndTag() throws JspException {

        JspWriter out = pageContext.getOut();
        try {
            String body=buildTagBody();

            //if object is not select or textarea, body is null
            if (body != null) {
                String suffix="";
                if (!body.equals("")) {
                    suffix += body;
                }
                suffix += "</" + buildPrefix() + ">\n";
                out.write(suffix);
            }
        } catch (Exception e) {
            throw new JspException(e);
        }
        return EVAL_PAGE;
    }

}