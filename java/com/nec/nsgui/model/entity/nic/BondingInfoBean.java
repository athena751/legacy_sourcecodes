package com.nec.nsgui.model.entity.nic;

public class BondingInfoBean {
	private String mode = "active-backup";

	private String selectedIFs = "";

	private String primaryIF = "";

	private String interval = "100";
	
	private String bondName = "";

	public String getInterval() {
		return interval;
	}
	

	public void setInterval(String interval) {
		this.interval = interval;
	}
	

	public String getMode() {
		return mode;
	}
	

	public void setMode(String mode) {
		this.mode = mode;
	}
	

	public String getPrimaryIF() {
		return primaryIF;
	}
	

	public void setPrimaryIF(String primaryIF) {
		this.primaryIF = primaryIF;
	}
	

	public String getSelectedIFs() {
		return selectedIFs;
	}
	

	public void setSelectedIFs(String selectedIFs) {
		this.selectedIFs = selectedIFs;
	}


	public String getBondName() {
		return bondName;
	}
	


	public void setBondName(String bondName) {
		this.bondName = bondName;
	}
	
	
}
