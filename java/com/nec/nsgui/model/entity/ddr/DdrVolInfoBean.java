/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.ddr;

public class DdrVolInfoBean {
	
	public static final String cvsid = "@(#) $Id: DdrVolInfoBean.java,v 1.2 2008/05/24 09:00:39 liuyq Exp $";
	private String name = "";
	private String mp	= "";
	private String capacity = "";
	private String aname = "";
	private String aid = "";
	private String wwnn = "";
	private String poolName = "";
	private String poolNo = "";
	private String poolNameAndNo = "";
	private String raidType = "";
	private String usableCap = "";
	private String codePage = "";
	private String mvValue4Show = "";
	private String mvName4Show = "";
	private String capacityUnit = "GB";
    private String node = "";
    private String schedule = "";
    private String status = "";
    private String mvStatusMsg = "";
    private String schedStatusMsg = "";
    private String mvResultCode = "";
    private String rvResultCode = "";
    private String schedResultCode = "";
    private String mvErrMsg = "";
    private String schedErrMsg = "";

    /**
     * @return Returns the mvErrMsg.
     */
    public String getMvErrMsg() {
        return mvErrMsg;
    }
    /**
     * @param mvErrMsg The mvErrMsg to set.
     */
    public void setMvErrMsg(String mvErrMsg) {
        this.mvErrMsg = mvErrMsg;
    }
    /**
     * @return Returns the schedErrMsg.
     */
    public String getSchedErrMsg() {
        return schedErrMsg;
    }
    /**
     * @param schedErrMsg The schedErrMsg to set.
     */
    public void setSchedErrMsg(String schedErrMsg) {
        this.schedErrMsg = schedErrMsg;
    }
    /**
     * @return Returns the mvStatusMsg.
     */
    public String getMvStatusMsg() {
        return mvStatusMsg;
    }
    /**
     * @param mvStatusMsg The mvStatusMsg to set.
     */
    public void setMvStatusMsg(String mvStatusMsg) {
        this.mvStatusMsg = mvStatusMsg;
    }
    /**
     * @return Returns the schedStatusMsg.
     */
    public String getSchedStatusMsg() {
        return schedStatusMsg;
    }
    /**
     * @param schedStatusMsg The schedStatusMsg to set.
     */
    public void setSchedStatusMsg(String schedStatusMsg) {
        this.schedStatusMsg = schedStatusMsg;
    }
    /**
     * @return Returns the node.
     */
    public String getNode() {
        return node;
    }
    /**
     * @param node The node to set.
     */
    public void setNode(String node) {
        this.node = node;
    }
    /**
     * @return Returns the mvResultCode.
     */
    public String getMvResultCode() {
        return mvResultCode;
    }
    /**
     * @param mvResultCode The mvResultCode to set.
     */
    public void setMvResultCode(String mvResultCode) {
        this.mvResultCode = mvResultCode;
    }
    /**
     * @return Returns the rvResultCode.
     */
    public String getRvResultCode() {
        return rvResultCode;
    }
    /**
     * @param rvResultCode The rvResultCode to set.
     */
    public void setRvResultCode(String rvResultCode) {
        this.rvResultCode = rvResultCode;
    }
    /**
     * @return Returns the schedResultCode.
     */
    public String getSchedResultCode() {
        return schedResultCode;
    }
    /**
     * @param schedResultCode The schedResultCode to set.
     */
    public void setSchedResultCode(String schedResultCode) {
        this.schedResultCode = schedResultCode;
    }
    /**
     * @return Returns the status.
     */
    public String getStatus() {
        return status;
    }
    /**
     * @param status The status to set.
     */
    public void setStatus(String status) {
        this.status = status;
    }
    /**
     * @return Returns the schedule.
     */
    public String getSchedule() {
        return schedule;
    }
    /**
     * @param schedule The schedule to set.
     */
    public void setSchedule(String schedule) {
        this.schedule = schedule;
    }
    public String getMvValue4Show() {
		StringBuffer value = new StringBuffer(this.getMvName4Show());
		value.append("#");
		value.append(this.getCapacity()).append("#");
		value.append(this.getPoolNameAndNo()).append("#");
		value.append(this.getPoolNo()).append("#");
		value.append(this.getRaidType()).append("#");
		value.append(this.getWwnn()).append("#");
		value.append(this.getAname()).append("#");
		value.append(this.getAid());	
		return value.toString();
	}
	public void setMvValue4Show(String mvValue4Show) {
		this.mvValue4Show = mvValue4Show;
	}
	public String getCapacityUnit() {
		return capacityUnit;
	}
	public void setCapacityUnit(String capacityUnit) {
		this.capacityUnit = capacityUnit;
	}

	public String getName(){
		return name;
	}
	public String getMp(){
		return mp;
	}
	public String getCapacity(){
		return capacity;
	}
	public String getAname(){
		return aname;
	}
	public String getAid(){
		return aid;
	}
	public String getWwnn(){
		return wwnn;
	}
	public String getPoolName(){
		return poolName;
	}
	public String getPoolNo(){
		StringBuffer tmpPoolNo = new StringBuffer("");
		String curPoolNameAndNo = this.getPoolNameAndNo();
		if(!curPoolNameAndNo.equals("")){
			// If have several pool ,just as "Pool001(0001),Pool002(0002)"
			// Split the pool name "0001 0002"and join them by ","
	    	String[] poolNameAndNoAry = curPoolNameAndNo.split("<br>");
	    	for(int j = 0; j< poolNameAndNoAry.length; j++){
	    		int nameEndIndex = poolNameAndNoAry[j].indexOf("(");
	    		int noEndIndex = poolNameAndNoAry[j].indexOf(")");
	    		tmpPoolNo.append(poolNameAndNoAry[j].substring(nameEndIndex+1, noEndIndex));
	    	    if(j+1 < poolNameAndNoAry.length){
	    		    tmpPoolNo.append(",");
	    	    }
	    	}
		}
		return tmpPoolNo.toString();
    }
	public String getPoolNameAndNo(){
		return poolNameAndNo.replaceAll(",", "<br>");
	}
    public String getPoolNameAndNoForDetail(){
        return poolNameAndNo;
    }   
	public String getRaidType(){
		return raidType;
	}
	public String getUsableCap() {
		return usableCap;
	}
	public void setName(String name){
		this.name = name;
	}
	public void setMp(String mp){
		this.mp = mp;
	}
	public void setCapacity(String capacity){
		this.capacity = capacity;
	}
	public void setAname(String aname){
		this.aname = aname;
	}
	public void setAid(String aid){
		this.aid = aid;
	}
	public void setWwnn(String wwnn){
		this.wwnn = wwnn;
	}
	public void setPoolName(String poolName){
		this.poolName = poolName;
	}
	public void setPoolNo(String poolNo){
	    this.poolNo = poolNo;
	}
	public void setPoolNameAndNo(String poolNameAndNo){
		this.poolNameAndNo = poolNameAndNo;
    }
	public void setRaidType(String raidType){
		this.raidType = raidType;
	}

	public void setUsableCap(String usableCap) {
		this.usableCap = usableCap;
	}
	public String getCodePage() {
		return codePage;
	}
	public void setCodePage(String codePage) {
		this.codePage = codePage;
	}
	public String getMvName4Show() {
		return name.replaceFirst("NV_LVM_", "");
	}
	public void setMvName4Show(String mvName4Show) {
		this.mvName4Show = mvName4Show;
	}
	
}
