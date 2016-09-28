
/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: SortTagInfo.java,v 1.1 2004/06/18 06:26:32 xingh Exp $
 *
 *	$Log: SortTagInfo.java,v $
 *	Revision 1.1  2004/06/18 06:26:32  xingh
 *	no message
 *	
 *	Revision 1.7  2004/06/01 00:43:19  necas2
 *	no message
 *	
 *	Revision 1.6  2004/05/31 04:09:40  necas2
 *	no message
 *	
 *	Revision 1.5  2004/05/28 08:55:09  necas2
 *	no message
 *	
 *	Revision 1.4  2004/05/27 04:24:03  necas2
 *	no message
 *	

      --------------------
      |   id             |
	  --------------------
      |   columns        |
	  --------------------+---------\--------------
	  |   pageContext    |           | ColumnInfo |
	  --------------------           --------------
	  |   shareObj       |           | ColumnInfo |
	  --------------------           --------------
      |   requestURI     |           | ColumnInfo |
      --------------------           --------------  
      |   queryString    |
      --------------------
 */



package com.nec.nsgui.taglib.nssorttab;

import javax.servlet.jsp.*;
import java.util.Vector;

/**
 * class to store the information of entire nssorttab taglib 
 * 
 *
 * @author  $Author: xingh $
 * @version $Revision: 1.1 $
 */

public class SortTagInfo {
	private String id = null;
	private Vector columns = null;
	private PageContext pageContext = null;
	private Object shareObj = null;
	private String requestURI = null;
	private String queryString = null;

	
	public SortTagInfo(){
	}
	public void setId(String id){
		this.id = id;
	}

	public String getId(){
		return this.id;
	}

	public void setPageContext(PageContext pageContext){
		this.pageContext = pageContext;
	}

	public PageContext getPageContext(){
		return this.pageContext;
	}

	/******************************************
	*@param column's Name
	*@return true if the column is sortable ,else false
	*/

	public boolean isSortable(String columnName){
		int       idx	= getColumnIndex(columnName);
		ColumnInfo ci	= (ColumnInfo)columns.get(idx);
		String sortable = ci.getSortable();

		return "yes".equals(sortable);
	
	}

	/******************************************
	*@param column's index
	*@return the name of specified index
	*/

	public String getColumnName(int columnIdx){

		if(columns==null) return null;
		if(columnIdx <0) return null;
		if(columnIdx>=columns.size())	return null;
		
		ColumnInfo ci = (ColumnInfo)columns.get(columnIdx);
		if (ci != null){
			return ci.getName();
		}else{
			return null;
		}
		
	}

	/******************************************
	*@param column's name
	*@return the index of specified column name
	*/

	public int getColumnIndex(String columnName){
		if (columns == null) return Integer.MIN_VALUE;

		ColumnInfo ci;
		for (int i = 0; i<columns.size() ; i++ )
		{
			ci = (ColumnInfo) columns.get(i);
			if (ci.getName().equals(columnName)){
				return i;
			}
		}
		return Integer.MIN_VALUE;
	}

	/******************************************
	*@param column's index
	*@return the header message of specified index
	*/
	public String getHeaderMsg(int columnIdx){
		if(columns == null) return null;
		if(columnIdx < 0) return null;
		if(columnIdx >= columns.size()) return null;

		ColumnInfo ci = (ColumnInfo)columns.get(columnIdx);
		return ci.getThMessage();

	}

	/******************************************
	*@param column's name
	*@return the header message of specified column name
	*/

	public String getHeaderMsg(String colName){
		return getHeaderMsg(getColumnIndex(colName));
	}


	/******************************************
	*@return the  count of total columns
	*/
	
	public int getColumnCount(){
		if ( columns == null)	return 0;
		return columns.size();
	}

	public void addColumn(ColumnInfo colInfo)
	{
		if (colInfo == null)	return;
		if(columns == null )	columns = new Vector();

		columns.add( colInfo );

	}
	public ColumnInfo getColumn(int idx){
		if(columns == null) return null;
		if(idx < 0) return null;
		if(idx >= columns.size()) return null;

		return (ColumnInfo)columns.get(idx);
	}

	public Object getShareObj(){
		return this.shareObj;
	}

	public void setShareObj(Object object){
		this.shareObj = object;
	}

	public String getRequestURI(){

		return this.requestURI;
	}

	public String getQueryString(){
		return this.queryString;
	}

	public void setRequestURI(String str){
		this.requestURI = str;
	}

	public void setQueryString(String str){
		this.queryString = str;
	}

}