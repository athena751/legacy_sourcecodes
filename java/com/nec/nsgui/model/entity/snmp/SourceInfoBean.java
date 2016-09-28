/*
 *      Copyright (c) 2005-2007 NEC Corporation
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
public class SourceInfoBean {
    private static final String cvsid = "@(#) $Id: SourceInfoBean.java,v 1.2 2007/07/11 11:58:55 hetao Exp $";
    
    private String source = "";
    private String read = "";
    private String write = "";
    private String notify ="";
    private String snmpversion="";
    private String filteringStatus = "";
    
    /**
     * @return
     */
    public String getFilteringStatus() {
        return filteringStatus;
    }

    /**
     * @return
     */
    public String getNotify() {
        return notify;
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
    public String getSource() {
        return source;
    }

    /**
     * @return
     */
    public String getWrite() {
        return write;
    }

    /**
     * @param string
     */
    public void setFilteringStatus(String string) {
        filteringStatus = string;
    }

    /**
     * @param string
     */
    public void setNotify(String string) {
        notify = string;
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
    public void setSource(String string) {
        source = string;
    }

    /**
     * @param string
     */
    public void setWrite(String string) {
        write = string;
    }

	/**
	 * @return Returns the snmpversion.
	 */
	public String getSnmpversion() {
		return snmpversion;
	}

	/**
	 * @param snmpversion The snmpversion to set.
	 */
	public void setSnmpversion(String snmpversion) {
		this.snmpversion = snmpversion;
	}

}