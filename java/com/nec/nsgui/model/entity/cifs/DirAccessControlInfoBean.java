/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.cifs;

public class DirAccessControlInfoBean {
    private static final String cvsid = "@(#) $Id: DirAccessControlInfoBean.java,v 1.1 2005/05/26 01:23:42 baiwq Exp $";
    
    private String directory;
    private String allowHost;
    private String denyHost;
    private String directory_td;
    private String dirAccessInfo;
    
    /**
     * @return
     */
    public String getAllowHost() {
        return allowHost;
    }

    /**
     * @return
     */
    public String getDenyHost() {
        return denyHost;
    }

    /**
     * @return
     */
    public String getDirectory() {
        return directory;
    }

    /**
     * @param string
     */
    public void setAllowHost(String string) {
        allowHost = string;
    }

    /**
     * @param string
     */
    public void setDenyHost(String string) {
        denyHost = string;
    }

    /**
     * @param string
     */
    public void setDirectory(String string) {
        directory = string;
    }

    /**
     * @return
     */
    public String getDirAccessInfo() {
        return dirAccessInfo;
    }

    /**
     * @return
     */
    public String getDirectory_td() {
        return directory_td;
    }

    /**
     * @param string
     */
    public void setDirAccessInfo(String string) {
        dirAccessInfo = string;
    }

    /**
     * @param string
     */
    public void setDirectory_td(String string) {
        directory_td = string;
    }

}
    