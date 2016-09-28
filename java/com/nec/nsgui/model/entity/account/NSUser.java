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

public class NSUser {
    private static final String cvsid =
        "@(#) NSUser.java,v 1.1 2004/08/11 05:36:42 k-nishi Exp";

    private String usrname;
    private String passwd;
    private String fullname;
    private String mail;
    private String max;
    private String organization;
    private String tel;

    /** oldver */
    private List role = new Vector();
    private List targets = new Vector();
    private List type = new Vector();
    /*****/

    Map roles = new HashMap();

    public void setName(String str) {
        usrname = str;
    }
    public String getName() {
        return usrname;
    }
    public void setPasswd(String str) {
        passwd = str;
    }
    public String getPasswd() {
        return passwd;
    }
    public void setFullName(String str) {
        fullname = str;
    }
    public String getFullName() {
        return fullname;
    }
    public void setMailAddress(String str) {
        mail = str;
    }
    public String getMailAddress() {
        return mail;
    }
    public void setSession(String str) {
        max = str;
    }
    public String getSession() {
        return max;
    }
    public void setOrganization(String str) {
        organization = str;
    }
    public String getOrganization() {
        return organization;
    }
    public void setTel(String str) {
        tel = str;
    }
    public String getTel() {
        return tel;
    }

    /** oldver */
    public void setRole(List list) {
        role = list;
    }

    public List getRole() {
        Set set = roles.entrySet();
        Iterator it = set.iterator();
        while (it.hasNext()) {
            Map.Entry entry = (Map.Entry) it.next();
            RoleInfo rlinfo = (RoleInfo) entry.getValue();
            role.add(rlinfo.getRole());
        }
        return role;
    }

    public void setTargets(List list) {
        targets = list;
    }

    public List getTargets() {
        if (roles.isEmpty())
            return null;
        Set set = roles.entrySet();
        Iterator it = set.iterator();
        while (it.hasNext()) {
            Map.Entry mapentry = (Map.Entry) it.next();
            TargetInfo tg = (TargetInfo) mapentry.getValue();
            targets.add(tg.getTarget());
            type.add(tg.getType());
        }
        return targets;
    }
    public void setType(List list) {
        type = list;
    }

    public List getType() {
        if (roles.isEmpty())
            return null;
        Set set = roles.entrySet();
        Iterator it = set.iterator();
        while (it.hasNext()) {
            Map.Entry mapentry = (Map.Entry) it.next();
            TargetInfo tg = (TargetInfo) mapentry.getValue();
            type.add(tg.getType());
        }
        return type;
    }
    public void setRoleInfo(RoleInfo roleinfo) {
        roles.put(roleinfo.getRole(), roleinfo);
    }
    public Map getRoleInfo() {
        return roles;
    }

    public Vector getAllTarget() {
        if (roles.isEmpty())
            return null;
        Vector vec = new Vector();
        Set set = roles.entrySet();
        Iterator it = set.iterator();
        while (it.hasNext()) {
            Map.Entry mapentry = (Map.Entry) it.next();
            RoleInfo rlinfo = (RoleInfo) mapentry.getValue();
            Vector tg = rlinfo.getTargets();
            if (tg != null)
                vec.addAll(tg);
        }
        return vec;
    }
}
