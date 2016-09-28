/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.volume;

public class LunInfoBean {
    private static final String cvsid =
        "@(#) $Id: LunInfoBean.java,v 1.3 2005/09/21 11:16:16 jiangfx Exp $";
    private String wwnn ;
    private String storage;
    private String lun;
    private String size;
    
    private String ldPath;
            
    /**
     * @return
     */
    public String getLun() {
        return lun;
    }

    /**
     * @return
     */
    public String getSize() {
        return size;
    }

    /**
     * @return
     */
    public String getStorage() {
        return storage;
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
    public void setLun(String string) {
        lun = string;
    }

    /**
     * @param string
     */
    public void setSize(String string) {
        size = string;
    }

    /**
     * @param string
     */
    public void setStorage(String string) {
        storage = string;
    }

    /**
     * @param string
     */
    public void setWwnn(String string) {
        wwnn = string;
    }
    /**
     * @return
     */
    public String getLdPath() {
        return ldPath;
    }

    /**
     * @param string
     */
    public void setLdPath(String string) {
        ldPath = string;
    }
}
    