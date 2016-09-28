/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.account;

import java.util.*;

public class RoleInfo {
    private static final String cvsid =
        "@(#) RoleInfo.java,v 1.1 2004/08/11 05:36:55 k-nishi Exp";

    private String role = new String();
    private Vector targets = new Vector();

    public void setRole(String role) {
        this.role = role;
    }
    public String getRole() {
        return role;
    }
    public void setTarget(String target, String type) {
        TargetInfo targetinfo = new TargetInfo();
        targetinfo.setTarget(target, type);
        targets.add(targetinfo);
    }
    public Vector getTargets() {
        return targets;
    }

}
