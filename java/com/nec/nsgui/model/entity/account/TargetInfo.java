/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.account;

public class TargetInfo {
    private static final String cvsid =
        "@(#) TargetInfo.java,v 1.1 2004/08/11 05:37:24 k-nishi Exp";

    private String target;
    private String type;

    public void setTarget(String target, String type) {
        this.target = target;
        this.type = type;
    }
    public String getTarget() {
        return target;
    }
    public String getType() {
        return type;
    }
}
