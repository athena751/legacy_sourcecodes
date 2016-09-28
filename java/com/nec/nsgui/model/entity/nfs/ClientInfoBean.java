/*
 *      Copyright (c) 2004 NEC Corporation
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
public class ClientInfoBean {
    private static final String cvsid =
        "@(#) $Id: ClientInfoBean.java,v 1.1 2004/08/16 02:42:10 het Exp $";

    private String clientName = "";
    private String option = "";
        
    public ClientInfoBean() {
 
     }

    /**
     * @return
     */
    public String getClientName() {
        return clientName;
    }

    /**
     * @return
     */
    public String getOption() {
        return option;
    }

    /**
     * @param string
     */
    public void setClientName(String string) {
        clientName = string;
    }

    /**
     * @param string
     */
    public void setOption(String string) {
        option = string;
    }

}
