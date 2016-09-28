
/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.sydney.framework.taglib;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 * This class provide the tag set the message replacements
 */
public class ReplacementTag extends TagSupport{

    private static final String	cvsid = "@(#) MessageTagLib.java,v 1.1 2002/03/18 07:08:08 matsuoka Exp";
   
    /**
     * Add the replacement in the MessageTagLib
     */     
    public int doStartTag() throws JspException{
        MessageTagLib parent = (MessageTagLib) getParent();    
        parent.addReplacement(replacement);
        return SKIP_BODY;
    }
    
    /**
     * Set the member replacement 
     */ 
    public void setValue(String replacement){
        this.replacement = replacement;
    }

    /** replacement string */
    private String replacement;
    
}
