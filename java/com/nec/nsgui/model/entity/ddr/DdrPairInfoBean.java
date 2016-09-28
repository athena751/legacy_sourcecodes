/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.ddr;

/**
 * The <code>PairInfoBean</code> class stores the pair's information. It
 * contains a pair's basic information as follow: <br>
 * <code>ldNameList</code> Pair's all LD names. <br>
 * <code>copyControlState</code> The pair's copy control state. <br>
 * <code>mvName</code> The mv's name. <br>
 * <code>rvName</code> The rv's name. <br>
 * <code>schedule</code> Pair's action schedule. <br>
 * <code>progressRate</code> Pair's progressRate of replication. <br>
 * <code>syncState</code> Pair's snyc state of action state of replication.<br>
 * <code>usage</code> Pair's usage.
 * 
 * @author Pizb
 * @version 0805, 2008/02/18
 * @since iStorage 0805
 */
public class DdrPairInfoBean {
	public static final String cvsid = "@(#) $Id: DdrPairInfoBean.java,v 1.1 2008/04/19 10:02:53 liuyq Exp $";

	/** The pair's copy control state. */
	private String copyControlState;
	
	/** Pair's mv LD's NameList. */
	private String mvLdNameList;
	
	/** Pair's rv LD's NameList. */
	private String rvLdNameList;

	/** The mv's name. */
	private String mvName;

	/** Pair's progressRate of replication. */
	private String progressRate;

	/** The rv's name. */
	private String rvName;

	/** Pair's action schedule. */
	private String schedule;
	
	/** Pair's action status. */
	private String status;
	
	/** mv's action result code. */
	private String mvResultCode;
	
	/** schedule action result code. */
	private String schedResultCode;
	
	/** rv's action result code. */
	private String rvResultCode;

	/** Pair's start time of replication. */
	private String syncStartTime;

	/** Pair's snyc state of action state of replication. */
	private String syncState;
	
	/** Pair's usage. */
	private String usage;

	/**
	 * @return the mvName
	 */
	public String getMvName() {
		return mvName;
	}

	/**
	 * @return the progressRate
	 */
	public String getProgressRate() {
		return progressRate;
	}

	/**
	 * @return the rvName
	 */
	public String getRvName() {
		return rvName;
	}

	/**
	 * @return the schedule
	 */
	public String getSchedule() {
		return schedule;
	}

	/**
	 * @return the syncStartTime
	 */
	public String getSyncStartTime() {
		return syncStartTime;
	}

	/**
	 * @return the syncState
	 */
	public String getSyncState() {
		return syncState;
	}

	/**
	 * @return the usage
	 */
	public String getUsage() {
		return usage;
	}

	public String getMvLdNameList() {
		return mvLdNameList;
	}

	public void setMvLdNameList(String mvLdNameList) {
		this.mvLdNameList = mvLdNameList;
	}

	public String getRvLdNameList() {
		return rvLdNameList;
	}

	public void setRvLdNameList(String rvLdNameList) {
		this.rvLdNameList = rvLdNameList;
	}

	/**
	 * @param mvName
	 *            the mvName to set
	 */
	public void setMvName(String mvName) {
		this.mvName = mvName;
	}

	/**
	 * @param progressRate
	 *            the progressRate to set
	 */
	public void setProgressRate(String progressRate) {
		this.progressRate = progressRate;
	}

	/**
	 * @param rvName
	 *            the rvName to set
	 */
	public void setRvName(String rvName) {
		this.rvName = rvName;
	}

	/**
	 * @param schedule
	 *            the schedule to set
	 */
	public void setSchedule(String schedule) {
		this.schedule = schedule;
	}

	/**
	 * @param syncStartTime
	 *            the syncStartTime to set
	 */
	public void setSyncStartTime(String syncStartTime) {
		this.syncStartTime = syncStartTime;
	}

	/**
	 * @param syncState
	 *            the syncState to set
	 */
	public void setSyncState(String syncState) {
		this.syncState = syncState;
	}

	/**
	 * @param usage
	 *            the usage to set
	 */
	public void setUsage(String usage) {
		this.usage = usage;
	}

	/**
	 * @return the copyControlState
	 */
	public String getCopyControlState() {
		return copyControlState;
	}

	/**
	 * @param copyControlState the copyControlState to set
	 */
	public void setCopyControlState(String copyControlState) {
		this.copyControlState = copyControlState;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRvResultCode() {
		return rvResultCode;
	}

	public void setRvResultCode(String rvResultCode) {
		this.rvResultCode = rvResultCode;
	}

	public String getMvResultCode() {
		return mvResultCode;
	}

	public void setMvResultCode(String mvResultCode) {
		this.mvResultCode = mvResultCode;
	}

	public String getSchedResultCode() {
		return schedResultCode;
	}

	public void setSchedResultCode(String schedResultCode) {
		this.schedResultCode = schedResultCode;
	}
}
