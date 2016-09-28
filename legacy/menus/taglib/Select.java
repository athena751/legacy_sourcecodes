/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package org.apache.taglibs.input;

import java.util.*;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;


public class Select extends TagSupport {


    private static final String     cvsid = "@(#) $Id: Select.java,v 1.2300 2003/11/24 00:55:17 nsadmin Exp $";


    private String name;        // name of the select element
    private String dVal;        // default value if none is found
    private Map attributes;     // attributes of the <select> element
    private Map options;        // what are our options? :)
    private String nodata;        // what to display if there is no data
    private String nest;        // used for NFS

    public void setName(String x) {
        name = x;
    }

    public void setAttributes(Map x) {
        attributes = x;
    }

    public void setDefault(String x) {
        dVal = x;
    }

    public void setOptions(Map x) {
        options = x;
    }

    public void setNodata(String x) {
        nodata = x;
    }
    public void setNest(String x){
        nest = x;
    }

    public int doStartTag() throws JspException {
        try {
            // sanity check
            if (name == null || name.equals(""))
                throw new JspTagException("invalid null or empty 'name'");

            // get what we need from the page
            ServletRequest req = pageContext.getRequest();
            JspWriter out = pageContext.getOut();

            // start building up the tag
            out.print("<select name=\"" + Util.quote(name) + "\" ");

            // include any attributes we've got here
            Util.printAttributes(out, attributes);

            // end the starting tag
            out.println(">");

            /*
             * Print out our options, selecting one or more if appropriate.
             * If there are multiple selections but the page doesn't call
             * for a <select> that accepts them, ignore the selections.
             * This is preferable to throwing a JspException because the
             * (end) user can control input, and we don't want the user
             * causing exceptions in our application.
             */

            // get the current selection
            String[] selected = req.getParameterValues(name);
            if (selected != null && selected.length > 1 &&
                    (attributes == null || 
                    !attributes.containsKey("multiple")))
                selected = null;

            // load up the selected values into a hash table for faster access
            HashMap chosen = new HashMap();
            if (selected != null)
                for (int i = 0; i < selected.length; i++)
                    chosen.put(selected[i], null);

            // actually print the <option> tags
            if (options != null) {
                if(options.size()==0){
                    out.print("<option value=");
                    out.print(Util.quote(nodata));
                    out.print(">");
                    out.print(Util.quote(nodata));
                    out.println("</option>");
                }else{
                Iterator i = options.keySet().iterator();
                while (i.hasNext()) {
                    Object oKey = i.next();
                    Object oVal = options.get(oKey);

                    /* If the option contains non-Strings, give the user
                     * a more meaningful message than what he or she would get
                     * if we just propagated a ClassCastException back.
                     * (This'll get caught below).
                     */
                    if (!(oKey instanceof String) ||
                            (oVal != null && !(oVal instanceof String)))
                        throw new JspException(
                            "all members in options Map must be Strings");
                    String key = (String) oKey;
                    String value = (String) oVal;
                    if (value == null)
                        value = key;        // use key if value is null

                    out.print("<option");
                    if (!value.equals(key))
                        out.print(" value=\"" + Util.quote(value) + "\"");
                    /*
                     * This may look confusing: we match the VALUE of
                     * this option pair with the KEY of the 'chosen' Map
                     * (We want to match <option>s on values, not keys.)
                     */

                    /************************************************
                    / 2002/03/26
                    / Fun
                    / Modified for NFSMain.jsp
                    /
                    if ((selected != null && chosen.containsKey(value))
                            || (selected == null && dVal != null &&
                            value.equals(dVal)))
                        out.print(" selected=\"selected\"");
                    
                    */
                    if(nest!=null){
                        if (dVal != null ){
                            if(key.endsWith(nest)){
                                dVal=dVal+nest;
                            }
                            if(key.equals(dVal)){
                                out.print(" selected=\"selected\"");
                            }
                        }
                    }else{
                        if ((selected != null && chosen.containsKey(value))
                                || (selected == null && dVal != null &&
                                value.equals(dVal)))
                            out.print(" selected=\"selected\"");
                    }
                    out.print(">");
                    out.print(Util.quote(key));
                    out.println("</option>");
                }
            }
            }else
                throw new JspTagException("invalid select: no options");

            // close off the surrounding select
            out.print("</select>");

        } catch (Exception ex) {
            throw new JspTagException(ex.getMessage());
        }
        return SKIP_BODY;
    }
}
