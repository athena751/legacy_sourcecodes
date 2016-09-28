/*
 *      Copyright (c) 2004-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: ColumnInfo.java,v 1.2 2006/12/14 06:00:31 xingyh Exp $
 *
 *		$Log: ColumnInfo.java,v $
 *		Revision 1.2  2006/12/14 06:00:31  xingyh
 *		Content:[nsgui-necas-sv4:20728],Add a "beforeSort" event to the tag
 *		Modifier:xingyh
 *		Reviewer:liuyq
 *		
 *		Revision 1.1  2004/06/18 06:26:32  xingh
 *		no message
 *		
 *		Revision 1.2  2004/05/27 01:44:55  necas2
 *		no message
 *		
 *		Revision 1.1  2004/05/26 04:38:15  necas2
 *		no message
 *		
 */


package com.nec.nsgui.taglib.nssorttab;


public class ColumnInfo {
	private String name = null;
	private String sortable = null;
	private String thCellRender = null;		//table header render`s name
	private String tdCellRender = null;		//table cell render`s name
	private String comparator = null;		//the class name of Comparator
	private String sidesort = null;			//the other refenrence column names
	private String thMessage = null;		//the message string to be displayed in th
	private String beforeSort = null;		//the java script function to do before sort the table


	public ColumnInfo(){
	}

	public void setName(String name){
		this.name = name;
	}

	public String getName(){
		return this.name;

	}

	public void setSortable(String sortable){
		this.sortable = sortable;
	}

	public String getSortable(){
		return this.sortable;
	}
		

	public void setThCellRender(String render){
		this.thCellRender = render;
	}

	public String getThCellRender(){
		return this.thCellRender;
	}

	public void setTdCellRender(String render){
		this.tdCellRender = render;
	}

	public String getTdCellRender(){
		return this.tdCellRender;
	}

	public void setComparator(String comp){
		this.comparator = comp;
	}

	public String getComparator(){
		return this.comparator;
	}

	public void setSidesort(String sidesort){
		this.sidesort = sidesort;
	}

	public String getSidesort(){
		return this.sidesort;
	}

	public void setThMessage(String msg){
		this.thMessage = msg;
	}

	public String getThMessage(){
		return this.thMessage;
	}

	public String getBeforeSort() {
		return beforeSort;
	}

	public void setBeforeSort(String beforeSort) {
		this.beforeSort = beforeSort;
	}


}