/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.snmp;

/**
 *
 */
public class UserInfoBean {
    private static final String cvsid =
        "@(#) $Id: UserInfoBean.java,v 1.2 2005/08/24 09:00:29 zhangj Exp $";

    private String user = "";
    private String authProtocol = "SHA";
    private String password = "";
    private String privProtocol = "DES";
    private String passphrase = "";

    /**
     * @return
     */
    public String getAuthProtocol() {
        return authProtocol;
    }

    /**
     * @return
     */
    public String getPassphrase() {
        return passphrase;
    }

    /**
     * @return
     */
    public String getPassword() {
        return password;
    }

    /**
     * @return
     */
    public String getPrivProtocol() {
        return privProtocol;
    }

    /**
     * @return
     */
    public String getUser() {
        return user;
    }

    /**
     * @param string
     */
    public void setAuthProtocol(String string) {
        authProtocol = string;
    }

    /**
     * @param string
     */
    public void setPassphrase(String string) {
        passphrase = string;
    }

    /**
     * @param string
     */
    public void setPassword(String string) {
        password = string;
    }

    /**
     * @param string
     */
    public void setPrivProtocol(String string) {
        privProtocol = string;
    }

    /**
     * @param string
     */
    public void setUser(String string) {
        user = string;
    }
}