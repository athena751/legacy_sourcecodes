/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

public class RadioTag extends BaseTag {
   
    private static final String cvsid = "@(#) $Id: RadioTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";
   
    protected boolean checked;
    
    protected String buildPrefix() {
        return "input type=\"radio\"";
    }

    public boolean getChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
    
    /**
     * Change "onfocus" and "onclick" to disabled the radio
     * If the radio is in disabled mode, (on NN4.76 only),
     *  when it is focused, store the checked radio
     *  when it is clicked, unchecked itself, then restore the checked radio
     * The function above is implemented in javascript functions 
     * "radioFocusDisale" and "radioClickDisable"
     */
    protected void buildDisabledCode() throws Exception {
        String formNO = pageContext.getAttribute(BaseTag.FORM_NUMBER).toString();
        if (formNO == null) {
            throw new Exception(EXCEPTION_NO_FORM);
        }

        String param = "'forms["+formNO+"]',this";

        if (onclick == null) onclick = "";
        
        onclick = "if(this.disabled) return radioClickDisable("+ param +");"
                    + "radioRecordStatus("+ param +");"
                    + onclick ;
    }
}