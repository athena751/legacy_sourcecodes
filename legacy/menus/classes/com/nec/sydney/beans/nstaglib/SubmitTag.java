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

public class SubmitTag extends BaseTag {

    private static final String cvsid = "@(#) $Id: SubmitTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";
   
    protected void buildDisabledCode() {
        if (onclick == null) {
            onclick = "";
        }
        this.onclick = "if(!this.disabled){" + onclick + "} else return false;";

    }
    
    protected String buildPrefix() {
        return "input type=\"submit\"";
    }

    public int doEndTag() throws JspException {
        try {
            JspWriter out = pageContext.getOut();
            out.println("\t<input type=\"hidden\" name=\"" 
                    + BaseTag.SUBMIT_NAME + "\" value=\"" + name + "\"/>");
        } catch (Exception e) {
            throw new JspException(e.getMessage());
        }                        
        return EVAL_PAGE;
    }
}