/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.cifs;

/**
 *
 */
public class CifsOtherOptionsBean {
    private static final String cvsid =
        "@(#) $Id: CifsOtherOptionsBean.java,v 1.1 2006/11/06 06:14:53 fengmh Exp $";

    private String directHosting = "no";
    
    public String getDirectHosting() {
        return directHosting;
    }
    
    public void setDirectHosting(String directHosting) {
        this.directHosting = directHosting;
    }
    
}
