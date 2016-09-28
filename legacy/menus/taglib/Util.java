/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

/*
 * ====================================================================
 *
 * The Apache Software License, Version 1.1
 *
 * Copyright (c) 1999 The Apache Software Foundation.  All rights 
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution, if
 *    any, must include the following acknowlegement:  
 *       "This product includes software developed by the 
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowlegement may appear in the software itself,
 *    if and wherever such third-party acknowlegements normally appear.
 *
 * 4. The names "The Jakarta Project", "Tomcat", and "Apache Software
 *    Foundation" must not be used to endorse or promote products derived
 *    from this software without prior written permission. For written 
 *    permission, please contact apache@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache"
 *    nor may "Apache" appear in their names without prior written
 *    permission of the Apache Group.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */ 
package org.apache.taglibs.input;

import java.util.*;
import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 *
 *  This class includes several utility functions used by various input
 *  tags.  Functionality common to several classes is located here on
 *  the relatively renegade premise that building variability into a design
 *  is better than using even single inheritance.  (For example, the interfaces
 *  to all utility functions is clearly outlined here , and the utility
 *  functions don't have access to private members of the "interesting"
 *  classes.)  I'll defend that this is more straightforward than a base
 *  class that includes these any day.
 *
 *  @version 0.90
 *  @author Shawn Bayern
 *  @author Lance Lavandowska
 */

class Util  {


    private static final String     cvsid = "@(#) $Id: Util.java,v 1.2300 2003/11/24 00:55:17 nsadmin Exp $";


    /** Print out any HTML tag attributes we might have been passed. */
    public static void printAttributes(JspWriter out, Map attributes)
            throws JspTagException, IOException {
        if (attributes != null) {
            Iterator i = attributes.keySet().iterator();
            while (i.hasNext()) {
                Object oKey = i.next();
                Object oVal = attributes.get(oKey);

                /*
                 * If the attribute contains non-Strings, give the user
                 * a more meaningful message than what he or she would get
                 * if we just propagated a ClassCastException back.
                 * (This'll get caught below.)
                 */
                if (!(oKey instanceof String) || 
                        (oVal != null && !(oVal instanceof String)))
                    throw new JspTagException(
                        "all members in attributes Map must be Strings");
                String key = (String) oKey;
                String value = (String) oVal;

                // check for illegal keys
                if (key.equals("name") || key.equals("value")
                        || key.equals("type") || key.equals("checked"))
                    throw new JspTagException(
                        "illegal key '" + key + "'found in attributes Map");

                /*
                 * Print the key and value.
                 * If the value is null, make it equal to the key.
                 * This follows the conventions of XHTML 1.0
                 * and does not break regular HTML.
                 */
                if (value == null) value = key;

                out.print(quote(key) + "=\"" + quote(value) + "\" ");
            }
        }
    }

    /** Quote metacharacters in HTML. */
    public static String quote(String x) {
        if (x == null)
            return null;
        else {
            // deal with ampersands first so we can ignore the ones we add later
            int c, oldC = -1;
            while ((c = x.substring(oldC + 1).indexOf('&')) != -1) {
                c += oldC + 1;          // adjust back to real string start
                x = new String((new StringBuffer(x)).replace(c, c+1, "&amp;"));
                oldC = c;
            }
            while ((c = x.indexOf('"')) != -1)
                x = new String((new StringBuffer(x)).replace(c, c+1, "&quot;"));
            while ((c = x.indexOf('<')) != -1)
                x = new String((new StringBuffer(x)).replace(c, c+1, "&lt;"));
            while ((c = x.indexOf('>')) != -1)
                x = new String((new StringBuffer(x)).replace(c, c+1, "&gt;"));
            return x;
        }
    }
}
