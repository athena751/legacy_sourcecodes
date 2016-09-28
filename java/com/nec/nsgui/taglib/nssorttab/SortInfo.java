
/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: SortInfo.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 *
 */



package com.nec.nsgui.taglib.nssorttab;


/**
 * class to store the information of entire nssorttab taglib 
 * 
 *
 * @author  $Author: xingh $
 * @version $Revision: 1.1 $
 */

public class SortInfo {
	private		final	String		ASCEND = "ascend";
	private		final	String		DESCEND = "descend";

	private String id = null;
	private String lastcolumn = null;
	private String sortorder = ASCEND;


	
	SortInfo(){
	}
	public void setId(String id){
		this.id = id;
	}

	public String getId(){
		return this.id;
	}
	public void setLastColumn(String colName){
		this.lastcolumn = colName;
	}
	public String getLastColumn(){
		return this.lastcolumn;
	}
	public void setSortorder(String order){
		this.sortorder = order;
	}
	public String getSortorder(){
		return this.sortorder;
	}
	public void setSortInfo(String colName){
		if(colName.equals(lastcolumn)){
			if(sortorder.equals(ASCEND)){
				sortorder = DESCEND;

			}else{
				sortorder = ASCEND;
			}

		}else{
			lastcolumn = colName;
			sortorder =  ASCEND;
		}
	}
}