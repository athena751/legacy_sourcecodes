/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.snmp;

/*
 *
 */
public class SystemInfoBean {
    private static final String cvsid =
            "@(#) $Id: SystemInfoBean.java,v 1.2 2005/08/24 09:00:29 zhangj Exp $";
            
    private String contact = "";
    private String location = "";

    /**
     * @return
     */
    public String getContact() {
        return contact;
    }
    
    /**
     * @return
     */
    public String getLocation() {
        return location;
    }

    /**
     * @param string
     */
    public void setContact(String string) {
        contact = string;
    }
    /**
     * @param string
     */
    public void setLocation(String string) {
        location = string;
    }
}