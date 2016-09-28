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

public class FormElements {

    private static final String cvsid = "@(#) $Id: FormElements.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";

    private Hashtable elements = new Hashtable();

    /**
     *  Constructor
     */
    public FormElements() {}


    /**
     * Add html object name and its attribute "disabled" in elements
     *
     * @param tag
     *
     */
    public void addElement(BaseTag bt) {
        String name = bt.getName();

        if (!elements.containsKey(name)) {
            elements.put(name, new ArrayList());
        }
        ((ArrayList) elements.get(name)).add(bt);
    }

    /**
     * Return a string including a javascript code to disable the html
     * object when page initializing
     *
     */
    public String getInitScript() {

        StringBuffer script = new StringBuffer();  // the variable to return
        String name;
        ArrayList boolList;
               
        for (Enumeration e = elements.keys();e.hasMoreElements();) {
            // for every html object with different name
            name = (String) e.nextElement();
            boolList = (ArrayList) elements.get(name);
            int size = boolList.size();
            for (int i = 0;i < size;i++) { //for every html element of same name
                String namei = (size > 1) ? name + "[" + i + "]" : name;
                BaseTag bt = (BaseTag) boolList.get(i);
                script = script.append("formname.")
                        .append(namei)
                        .append(".disabled=")
                        .append(bt.getDisabled())
                        .append(";\n");
                if (bt instanceof RadioTag) {
                    script = script.append("formname.")
                            .append(namei)
                            .append(".checked_status=")
                            .append(((RadioTag) bt).getChecked())
                            .append(";\n");   
                }                 
            }
        }

        if (elements.size() > 0) { // the form has at least one html object
            StringBuffer scriptPre = new StringBuffer();
            scriptPre = scriptPre.append("<script language=\"javascript\">\n")
                    .append("var formname = ")
                    .append("document.forms[document.forms.length-1];\n");
            script = scriptPre.append(script).append("</script>\n");
        }
        
        return script.toString();
    }
}
