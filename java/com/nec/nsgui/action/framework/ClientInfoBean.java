/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.action.framework;

public class ClientInfoBean {
    private static final String cvsid =
        "@(#) $Id: ClientInfoBean.java,v 1.3 2005/10/19 01:40:05 fengmh Exp $";
    private String user;
    private String from;
    private String loginTime;
    private String lastAccessTime;
    private String timeout;
    private String idleTime;
    private String sessionId;

    /**
     *
     */

    public ClientInfoBean() {
        super();
    }
    
    /**
     *
     */
    public ClientInfoBean(String user, String from, String loginTime, String lastAccessTime, String timeout, String idleTime, String sessionId) throws Exception{
        this.user = user;
        this.from = from;
        this.loginTime = loginTime;
        this.lastAccessTime = lastAccessTime;
        this.timeout = timeout;
        this.idleTime = idleTime;
        this.sessionId = sessionId;
    }
    

    /**
     * @return
     */
    public String getFrom() {
        return from;
    }

    /**
     * @return
     */
    public String getLastAccessTime() {
        return lastAccessTime;
    }

    /**
     * @return
     */
    public String getLoginTime() {
        return loginTime;
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
    public void setFrom(String string) {
        from = string;
    }

    /**
     * @param string
     */
    public void setLastAccessTime(String string) {
        lastAccessTime = string;
    }

    /**
     * @param string
     */
    public void setLoginTime(String string) {
        loginTime = string;
    }

    /**
     * @param string
     */
    public void setUser(String string) {
        user = string;
    }

    public String getTimeout() {
        return timeout;
    }
    

    public void setTimeout(String timeout) {
        this.timeout = timeout;
    }

    public String getIdleTime() {
        return idleTime;
    }
    

    public void setIdleTime(String idleTime) {
        this.idleTime = idleTime;
    }

    public String getSessionId() {
        return sessionId;
    }
    

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    
    
    
}
    