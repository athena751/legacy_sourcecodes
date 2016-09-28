/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.framework;

public class HTMLUtil {
    private static final String	cvsid = "@(#) $Id: HTMLUtil.java,v 1.2300 2003/11/24 00:54:32 nsadmin Exp $";

    public HTMLUtil() {
    }

    static public String sanitize(String str) {
	return sanitize(str, true);
    }

    // sanitizing
    // flag = true : replace &, <, >, ", '
    //        false: replace &, <, > 
    static public String sanitize(String str, boolean flag) {
	str = str.replaceAll("&", "&amp;").
	    replaceAll("<", "&lt;").
	    replaceAll(">", "&gt;");
	if (flag) {
	    str = str.replaceAll("\"", "&quot;").
		replaceAll("'", "&#39;");
	}
	return str;
    }
}
