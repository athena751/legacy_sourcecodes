/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: SubTabTagInfo.java,v 1.2 2005/08/29 01:08:10 wangw Exp $
 *
 */

package com.nec.nsgui.taglib.nstab;

public class SubTabTagInfo {
	private String urlString = null;   //the url address that will be used when the tab is clicked
	private String tabMessage = null;  //the message string to be displayed on tab
	private String enableExportGroup = null;  //this tab whether can change the exportgroup
	private String enableNode = null;  //this tab whether can change the node

	public SubTabTagInfo(){
	}

	public void setUrlString(String urlString){
		this.urlString = urlString;
	}

	public String getUrlString(){
		return this.urlString;
	}

	public void setTabMessage(String tabMessage){
		this.tabMessage = tabMessage;
	}

	public String getTabMessage(){
		return this.tabMessage;
	}

	public String getEnableExportGroup(){
		return this.enableExportGroup;
	}

	public void setEnableExportGroup(String enableExportGroup){
		this.enableExportGroup = enableExportGroup;
	}

	public String getEnableNode(){
		return this.enableNode;
	}

	public void setEnableNode(String enableNode){
		this.enableNode = enableNode;
	}
}