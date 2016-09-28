/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

public class PasswordTag extends BaseTag {
    
    private static final String cvsid = "@(#) $Id: PasswordTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";
    
    protected String maxlength;
    protected String size;
    protected boolean readonly;

    protected String buildPrefix() {
        return "input type=\"password\"";
    }
    
    public void setMaxlength(int maxlength) {
        this.maxlength = "" + maxlength;
    }
    
    public void setSize(int size) {
        this.size = "" + size;
    }

    public void setReadonly(boolean readonly) {
        this.readonly = readonly;
    }

    /**
     * Change "onfocus" to disabled the password
     * If the password is in readonly mode, (on NN4.76 only),
     *  when it is focused, blur the focus.
     * In this situation, the other scripts(on focus) 
     * that is user specified still work.
     */
    protected void buildDisabledCode() {
        if (readonly == true) {
            onfocus = "this.blur();" + ((onfocus == null) ? "" : onfocus);
        }
        if (onfocus == null || onfocus.equals("")) {
            onfocus = "";
        } else {
            onfocus = " else {" + onfocus + "}";
        }
        onfocus = "if(this.disabled) this.blur();" + onfocus;
    }
}