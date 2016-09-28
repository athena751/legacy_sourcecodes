/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.volume;

public class PoolInfoBean {
    private static final String cvsid = "@(#) $Id: PoolInfoBean.java,v 1.3 2008/10/15 02:18:08 jiangfx Exp $";

    private String aid;
    private String aname;
    private String raidType;
    private String poolName;
    private String poolNo;
    private String totalCap;
    private String usedCap;
    private String maxFreeCap;
    private String totalFreeCap;
    private String pdNoList;  //eg: 00h-01h,00h-02h
    private String ldNoList;
    private String vgList;
    private String pdtype; // eg: SATA/SAS/FC
    private String manageCapOfLD;
         
     
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
    public String getLdNoList() {
        return ldNoList;
    }

    /**
     * @return
     */
    public String getMaxFreeCap() {
        return maxFreeCap;
    }

    /**
     * @return
     */
    public String getPoolName() {
        return poolName;
    }

    /**
     * @return
     */
    public String getPoolNo() {
        return poolNo;
    }

    /**
     * @return
     */
    public String getRaidType() {
        return raidType;
    }

    /**
     * @return
     */
    public String getTotalCap() {
        return totalCap;
    }

    /**
     * @return
     */
    public String getTotalFreeCap() {
        return totalFreeCap;
    }

    /**
     * @return
     */
    public String getUsedCap() {
        return usedCap;
    }

    /**
     * @return
     */
    public String getVgList() {
        return vgList;
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
    public void setLdNoList(String string) {
        ldNoList = string;
    }

    /**
     * @param string
     */
    public void setMaxFreeCap(String string) {
        maxFreeCap = string;
    }

    /**
     * @param string
     */
    public void setPoolName(String string) {
        poolName = string;
    }

    /**
     * @param string
     */
    public void setPoolNo(String string) {
        poolNo = string;
    }

    /**
     * @param string
     */
    public void setRaidType(String string) {
        raidType = string;
    }

    /**
     * @param string
     */
    public void setTotalCap(String string) {
        totalCap = string;
    }

    /**
     * @param string
     */
    public void setTotalFreeCap(String string) {
        totalFreeCap = string;
    }

    /**
     * @param string
     */
    public void setUsedCap(String string) {
        usedCap = string;
    }

    /**
     * @param string
     */
    public void setVgList(String string) {
        vgList = string;
    }

    /**
     * @return
     */
    public String getPdNoList() {
        return pdNoList;
    }

    /**
     * @param string
     */
    public void setPdNoList(String string) {
        pdNoList = string;
    }
    /**
     * @return
     */
    public String getPdtype() {
        return pdtype;
    }

    /**
     * @param string
     */
    public void setPdtype(String string) {
        pdtype = string;
    }

	public String getManageCapOfLD() {
		return manageCapOfLD;
	}

	public void setManageCapOfLD(String manageCapOfLD) {
		this.manageCapOfLD = manageCapOfLD;
	}

}