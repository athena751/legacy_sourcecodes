/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

public class CheckboxTag extends BaseTag {
    
    private static final String cvsid = "@(#) $Id: CheckboxTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";
    
    protected boolean checked;

    protected String buildPrefix() {
        return "input type=\"checkbox\"";
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    /**
     * Change onfocus and onclick to disable the checkbox
     * if the checkbox is disabled, (on NN4.76 only)
     *  when it is focused, store the check status
     *  when it is click, restore the check status
     */
    protected void buildDisabledCode() {
        if (onclick == null || onclick.equals("")) {
            onclick = "";
        }
        onclick = "if(!this.checked_status) this.checked_status=" + checked
                + "; if(this.disabled) this.checked=this.checked_status; else {"
                + " this.checked_status=this.checked;"
                + onclick + "}";
    }
}