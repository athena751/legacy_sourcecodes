/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.ddr;

public class DdrExtendPairBean extends DdrVolInfoBean {
    public static final String cvsid = "@(#) $Id: DdrExtendPairBean.java,v 1.2 2008/05/04 05:19:00 yangxj Exp $";
    
	private String selectedPoolNameAndNo = "";
	private String selectedPoolName = "";
	private String selectedPoolNo = "";
	private String selectedPoolAvailSize = "";
	private String extendSize = "";
	private String extendUnit = "";
	private String bltime = "24";
	private String striping = "false";
	private String poolNameAndNo4extend = "";
	private String poolNo4extend = "";
	
	

	public String getPoolNo4extend() {
		return poolNo4extend;
	}

	public void setPoolNo4extend(String poolNo4extend) {
		this.poolNo4extend = poolNo4extend;
	}

	public void setPoolNameAndNo4extend(String poolNameAndNo4extend) {
		this.poolNameAndNo4extend = poolNameAndNo4extend;
	}
	
	public String getPoolNameAndNo4extend() {
		return poolNameAndNo4extend;
	}

	public String getSelectedPoolName() {
		return selectedPoolName;
	}
	public void setSelectedPoolName(String selectedPoolName) {
		this.selectedPoolName = selectedPoolName;
	}
	
	public String getCapacity4Show() {
		try{
            Double d = new Double(getCapacity()); 
            return (new java.text.DecimalFormat("#,##0.0")).format(d);
        } catch(NumberFormatException e) {
            return getCapacity();  
        }
	}
	/*
	public void setCapacity4Show(String capacity4Show) {
		this.capacity4Show = capacity4Show;
	}
	*/
	public String getBltime() {
		return bltime;
	}
	public String getExtendSize() {
		return extendSize;
	}
	public String getExtendUnit() {
		return extendUnit;
	}
	public String getSelectedPoolAvailSize() {
		return selectedPoolAvailSize;
	}
	public String getStriping() {
		return striping;
	}
	public void setBltime(String bltime) {
		this.bltime = bltime;
	}
	public void setExtendSize(String extendSize) {
		this.extendSize = extendSize;
	}
	public void setExtendUnit(String extendUnit) {
		this.extendUnit = extendUnit;
	}
	public String getSelectedPoolNameAndNo() {
		return selectedPoolNameAndNo;
	}
	public void setSelectedPoolNameAndNo(String selectedPoolNameAndNo) {
		this.selectedPoolNameAndNo = selectedPoolNameAndNo;
		
	}
	public void setSelectedPoolAvailSize(String selectedPoolAvailSize) {
		this.selectedPoolAvailSize = selectedPoolAvailSize;
	}
	public void setStriping(String striping) {
		this.striping = striping;
	}
	public String getSelectedPoolNo() {
		return selectedPoolNo;
	}
	public void setSelectedPoolNo(String selectedPoolNo) {
		this.selectedPoolNo = selectedPoolNo;
	}
	
}
