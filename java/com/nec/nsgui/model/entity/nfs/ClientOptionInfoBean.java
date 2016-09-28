/*
 *      Copyright (c) 2008-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.nfs;

/**
 *
 */
public class ClientOptionInfoBean {
    private static final String cvsid =
        "@(#) $Id: ClientOptionInfoBean.java,v 1.3 2009/04/10 01:40:03 yangxj Exp $";

    private String client = "";
    private String nisDomain = "";
    private String accessMode = "";
    private String usermapping = "";
    private String rootSquash = "";
    private String annonuid = "";
    private String annongid = "";
    private boolean subtree;
    private boolean hide;
    private boolean secure;
    private boolean secureLock;
    private boolean accesslog;
    private boolean unstablewrite;
    
    private String create;
    private String remove;
    private String write;
    private String read;
        
    public ClientOptionInfoBean() {
 
    }

    /**
     * @return
     */
    public boolean isAccesslog() {
        return accesslog;
    }

    /**
     * @return
     */
    public String getAccessMode() {
        return accessMode;
    }

    /**
     * @return
     */
    public String getAnnongid() {
        return annongid;
    }

    /**
     * @return
     */
    public String getAnnonuid() {
        return annonuid;
    }

    /**
     * @return
     */
    public String getClient() {
        return client;
    }

    /**
     * @return
     */
    public String getCreate() {
        return create;
    }

    /**
     * @return
     */
    public boolean isHide() {
        return hide;
    }

    /**
     * @return
     */
    public String getNisDomain() {
        return nisDomain;
    }

    /**
     * @return
     */
    public String getRead() {
        return read;
    }

    /**
     * @return
     */
    public String getRemove() {
        return remove;
    }

    /**
     * @return
     */
    public String getRootSquash() {
        return rootSquash;
    }

    /**
     * @return
     */
    public boolean isSecure() {
        return secure;
    }

    /**
     * @return
     */
    public boolean isSecureLock() {
        return secureLock;
    }

    /**
     * @return
     */
    public boolean isSubtree() {
        return subtree;
    }

    /**
     * @return
     */
    public String getUsermapping() {
        return usermapping;
    }

    /**
     * @return
     */
    public String getWrite() {
        return write;
    }

    /**
     * @param b
     */
    public void setAccesslog(boolean b) {
        accesslog = b;
    }

    /**
     * @param string
     */
    public void setAccessMode(String string) {
        accessMode = string;
    }

    /**
     * @param string
     */
    public void setAnnongid(String string) {
        annongid = string;
    }

    /**
     * @param string
     */
    public void setAnnonuid(String string) {
        annonuid = string;
    }

    /**
     * @param string
     */
    public void setClient(String string) {
        client = string;
    }

    /**
     * @param string
     */
    public void setCreate(String string) {
        create = string;
    }

    /**
     * @param b
     */
    public void setHide(boolean b) {
        hide = b;
    }

    /**
     * @param string
     */
    public void setNisDomain(String string) {
        nisDomain = string;
    }

    /**
     * @param string
     */
    public void setRead(String string) {
        read = string;
    }

    /**
     * @param string
     */
    public void setRemove(String string) {
        remove = string;
    }

    /**
     * @param string
     */
    public void setRootSquash(String string) {
        rootSquash = string;
    }

    /**
     * @param b
     */
    public void setSecure(boolean b) {
        secure = b;
    }

    /**
     * @param b
     */
    public void setSecureLock(boolean b) {
        secureLock = b;
    }

    /**
     * @param b
     */
    public void setSubtree(boolean b) {
        subtree = b;
    }

    /**
     * @param string
     */
    public void setUsermapping(String string) {
        usermapping = string;
    }

    /**
     * @param string
     */
    public void setWrite(String string) {
        write = string;
    }
    
    /**
     * @return
     */
	public boolean isUnstablewrite() {
		return unstablewrite;
	}

	/**
     * @return
     */
	public void setUnstablewrite(boolean unstablewrite) {
		this.unstablewrite = unstablewrite;
	}

}
