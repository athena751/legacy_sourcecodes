/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nstaglib;

public class ButtonTag extends BaseTag {
    
    private static final String cvsid = "@(#) $Id: ButtonTag.java,v 1.2300 2003/11/24 00:54:53 nsadmin Exp $";
    
    protected String buildPrefix() {
        return "input type=\"button\"";
    }

    protected void buildDisabledCode() {}
}