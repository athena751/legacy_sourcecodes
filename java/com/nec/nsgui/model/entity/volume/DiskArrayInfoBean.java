/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.volume;

public class DiskArrayInfoBean {
    private static final String cvsid = "@(#) $Id: DiskArrayInfoBean.java,v 1.1 2005/09/21 10:22:37 jiangfx Exp $";

    private String aid;
    private String aname;
    private String atype;
    private String wwnn;
    private String pdgList;
    
    

    /**
     * @return
     */
    public String getAid() {
        return aid;
    }

    /**
     * @return
     */
    public String getAname() {
        return aname;
    }

    /**
     * @return
     */
    public String getAtype() {
        return atype;
    }

    /**
     * @return
     */
    public String getPdgList() {
        return pdgList;
    }

    /**
     * @return
     */
    public String getWwnn() {
        return wwnn;
    }

    /**
     * @param string
     */
    public void setAid(String string) {
        aid = string;
    }

    /**
     * @param string
     */
    public void setAname(String string) {
        aname = string;
    }

    /**
     * @param string
     */
    public void setAtype(String string) {
        atype = string;
    }

    /**
     * @param string
     */
    public void setPdgList(String string) {
        pdgList = string;
    }

    /**
     * @param string
     */
    public void setWwnn(String string) {
        wwnn = string;
    }

}