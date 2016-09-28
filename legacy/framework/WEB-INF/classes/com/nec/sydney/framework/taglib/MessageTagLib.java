/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.framework.taglib;

import	java.io.*;

import  javax.servlet.*;
import  javax.servlet.http.*;
import	javax.servlet.jsp.*;
import	javax.servlet.jsp.tagext.*;
import  java.util.*;

import	com.nec.sydney.framework.*;

public class MessageTagLib extends TagSupport {
    private static final String	cvsid = "@(#) $Id: MessageTagLib.java,v 1.2302 2005/06/13 07:17:18 liuyq Exp $";
    public MessageTagLib() {
    	super();
    	key = null;
    	alt = "unknown message";
    	sess = null;
    	replacements = null;
    	separate = false;
    }

    public int doStartTag() throws JspException{
        return EVAL_BODY_INCLUDE;
    }
	
    public int doEndTag() throws JspException{
    	try {
            JspWriter out = pageContext.getOut();
            String	mess = NSMessageDriver.getInstance().getMessage(pageContext.getSession(), key, alt,replacements,separate);
            if (mess == null) {
            	mess = "unknown message("+key+")";
            }
            out.write(mess);
    	} catch (IOException ioe) {
            NSReporter.getInstance().report(NSReporter.ERROR, ioe.toString());
    	}
    	key = null;
    	alt = "unknown message";
    	sess = null;
    	replacements = null;
    	separate = false;
    	return EVAL_PAGE;

    }

    public void	setKey(String key) {
    	this.key = key;
    }
    public void	setAlt(String alt) {
    	this.alt = alt;
    }
    public void	setSess(HttpSession sess) {
    	this.sess = sess;
    }
    
    /**
     * Set the separate attribute 
     */  
    public void setSeparate(boolean separate){
        this.separate = separate;
    }
    
    /**
     * Set the first replacement attribute
     */
    public void setFirstReplace(String replacement){
        addReplacement(replacement);        
    }
    
    /**
     * Add the replacement in the replacements vector.
     * This function will be invoked by the subtag ReplacementTag.
     * @param replacement replacement string
     */
    public void addReplacement(String replacement){
        if ( this.replacements == null ){
            this.replacements = new Vector();
        }
        this.replacements.add(replacement);
    }

    private String	key;
    private String	alt;
    private HttpSession	sess;

    /**  The vector contains all replacement string */   
    private Vector  replacements; 
    
    /** Whether separate the result message */
    private boolean separate;  


}
