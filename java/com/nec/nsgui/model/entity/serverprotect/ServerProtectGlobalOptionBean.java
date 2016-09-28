/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.serverprotect;

/**
 * @author chenbc
 *
 */
public class ServerProtectGlobalOptionBean {
    private static final String cvsid = "@(#) $Id: ServerProtectGlobalOptionBean.java,v 1.2 2007/03/23 06:35:44 wanghb Exp $";
   
    private String ludbUser = "";
    private String extension = "";
    private String defaultExtension = "";
    
    /**
     * @return Returns the ludbUser.
     */
    public String getLudbUser() {
        return ludbUser;
    }
    /**
     * @param ludbUser:The ludbUser to set.
     */
    public void setLudbUser(String ludbUser) {
        this.ludbUser = ludbUser;
    }
    
    /**
     * @return Returns the extension.
     */
    public String getExtension() {
        return extension;
    }
    /**
     * @param extension: The extension to set.
     */
    public void setExtension(String extension) {
        this.extension = extension;
    }
 
    /**
     * @return Returns the defaultExtension.
     */
    public String getDefaultExtension() {
        return defaultExtension;
    }
    /**
     * @param defaultExtension: The defaultExtension to set.
     */
    public void setDefaultExtension(String defaultExtension) {
        this.defaultExtension = defaultExtension;
    }
}
