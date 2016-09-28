/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

/**
 *
 */
public class CsvDownloadCmdOpts {
    private static final String cvsid =
               "@(#) $Id: CsvDownloadCmdOpts.java,v 1.2 2007/03/07 06:29:42 yangxj Exp $";
    String host;
    String infotype;
    String startTimeOption;
    String endTimeOption;
    String resourceOption;
    String itemsOption;
    String useMountpointOption;
    String version = "1";
    String cpName = "";
    /**
     *
     */

    public CsvDownloadCmdOpts() {
        super();
    }

    /**
     * @return
     */
    public String getEndTimeOption() {
        return endTimeOption;
    }

    /**
     * @return
     */
    public String getHost() {
        return host;
    }

    /**
     * @return
     */
    public String getInfotype() {
        return infotype;
    }

    /**
     * @return
     */
    public String getItemsOption() {
        return itemsOption;
    }

    /**
     * @return
     */
    public String getResourceOption() {
        return resourceOption;
    }

    /**
     * @return
     */
    public String getStartTimeOption() {
        return startTimeOption;
    }

    /**
     * @return
     */
    public String getUseMountpointOption() {
        return useMountpointOption;
    }

    /**
     * @param string
     */
    public void setEndTimeOption(String string) {
        endTimeOption = string;
    }

    /**
     * @param string
     */
    public void setHost(String string) {
        host = string;
    }

    /**
     * @param string
     */
    public void setInfotype(String string) {
        infotype = string;
    }

    /**
     * @param string
     */
    public void setItemsOption(String string) {
        itemsOption = string;
    }

    /**
     * @param string
     */
    public void setResourceOption(String string) {
        resourceOption = string;
    }

    /**
     * @param string
     */
    public void setStartTimeOption(String string) {
        startTimeOption = string;
    }

    /**
     * @param string
     */
    public void setUseMountpointOption(String string) {
        useMountpointOption = string;
    }

    /**
     * @return
     */
    public String getVersion() {
        return version;
    }

    /**
     * @param string
     */
    public void setVersion(String string) {
        version = string;
    }

	public String getCpName() {
		return cpName;
	}

	public void setCpName(String cpName) {
		this.cpName = cpName;
	}

}
