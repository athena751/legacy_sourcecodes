/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

import java.util.*;

public class SelectTag extends BaseTag {
    
    private static final String cvsid = "@(#) $Id: SelectTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";
    
    protected String selected; 
    private Map options;

    protected String buildPrefix() {
        return "select";
    }
    
    public void setOptions(Map options) {
        this.options = options;
    }
    
    public void setSelected(String selected) {
        this.selected = selected;
    }
    
    /**
     * Return a String including options information
     * 
     */
    protected String buildTagBody() {

        String composeString = "";
        String key, val;
        Iterator iter;

        if(options == null)
            return "";
        iter = options.keySet().iterator();
        while (iter.hasNext()) {
            key = (String)iter.next();
            val = (String)options.get(key);
            val = BaseTag.convertChars(val);
            if ( selected != null && key.equals(selected)) {
                composeString += "\t<option value=\"" + key + "\" selected>" 
                        + val + "</option>\n";
            } else {
                composeString += "\t<option value=\"" + key + "\">" 
                        + val + "</option>\n";
            }       
        }
        return composeString;
    }
    
    protected void buildDisabledCode() {
        if (onfocus == null || onfocus.equals("")) {
            onfocus = "";
        } else {
            onfocus = " else {" + onfocus + "}";
        }
        if (onchange == null || onchange.equals("")) {
            onchange = "";
        } else {
            onchange = " else {" + onchange + "}";
        }
        onfocus = "if(this.disabled) this.select_index=this.selectedIndex;" 
                + onfocus;
        onchange = "if(this.disabled) this.selectedIndex=this.select_index;"
                + onchange;
    }
}