
/*
 *      Copyright (c) 2004-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: Column.java,v 1.2 2006/12/14 05:58:56 xingyh Exp $
 *
 */



package com.nec.nsgui.taglib.nssorttab;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import java.io.BufferedReader;
import java.io.IOException;
/**
 * class to store the information of entire nssorttab taglib 
 * 
 *
 * @author  $Author: xingyh $
 * @version $Revision: 1.2 $
 */

public class Column extends BodyTagSupport{

	private final	String YES = "yes";
	private final	String NO = "no";

	private	JspWriter	out    = null;

	private String name = null;
	private String sortable = NO;
	private String th = null;
	private String td = null;
	private String comparator = null;
	private String sidesort = null;
	private String thmessage = "";
	private String beforeSort = "";		//the java script function to do before sort the table
	
	private void init(){
		name = null;
		sortable = NO;
		th = null;
		td = null;
		comparator = null;
		sidesort = null;
		thmessage= "";
        beforeSort = "";
	}

	public Column(){
		init();
	}

	public void setName(String name){
		this.name = name;
	}

	public void setSortable(String sortable){
		this.sortable = sortable;
	}

	public void setTh( String thrender){
		this.th = thrender;

	}

	public void setTd(String tdrender){
		this.td = tdrender;

	}

	public void setComparator(String comparator){
		this.comparator = comparator;

	}
	public void setSidesort(String order){
		this.sidesort = order;

	}

	public void setPageContext(PageContext pageContext) {
		super.setPageContext(pageContext);
		out = pageContext.getOut();
	}

	public int doStartTag() throws JspException{
		return super.doStartTag();
	}

	public int doAfterBody()throws JspException {
		BodyContent		bc = getBodyContent();
		BufferedReader	br = new BufferedReader(bc.getReader());
		String			line = null;


		/****************************************
		 * Collect the message for th displaying
		 * and get rid of the blank lines.
		 */
		thmessage = "";
		try{
			line = br.readLine();
			while(line != null){
				thmessage = thmessage + line.trim();
				line = br.readLine();
			}
		}catch(IOException ex){

		}


		return EVAL_PAGE;

	}

	public int doEndTag() throws JspException{

        Tag parent = findAncestorWithClass(this, SortTable.class);

		if (parent == null){
			throw new JspException("[nssorttab:column]  nssorttab:table is required!");
		}


		/*********************************************
		 *check the attributes of this column 
		 */

		CheckAttributes();

		/*********************************************
		 * prepare for adding columninfo to parent tag
		 */

		ColumnInfo colinfo = new ColumnInfo();

		colinfo.setName(name);
		colinfo.setSortable(sortable);
		colinfo.setThCellRender(th);
		colinfo.setTdCellRender(td);
		colinfo.setComparator(comparator);
		colinfo.setSidesort(sidesort);
		colinfo.setThMessage(thmessage);
		colinfo.setBeforeSort(beforeSort);

		/*********************************************
		 * add this columnifo to parent
		 */
        SortTable sorttable = (SortTable) parent;
        sorttable.addColumn(colinfo);

		init();
		return EVAL_PAGE;
	}

	/**************************************************
	*
	*check the following attributes' value
	*     name
	*     sortable : yes|no
	*     th
	*     td
	*/

	private void CheckAttributes() throws JspException {
		if((name==null) || ("".equals(name.trim()))){
			throw new JspException("[nssorttab:column] Invalid Parameter: name.");
		}

		if(! (YES.equals(sortable) || NO.equals(sortable))){
			throw new JspException("[nssorttab:column] Invalid Parameter: sortable.");
		}
		if(th == null){
			throw new JspException("[nssorttab:column] Invalid Parameter: th.");
		}
		if(td == null){
			throw new JspException("[nssorttab:column] Invalid Parameter: td.");
		}
	}

	public String getBeforeSort() {
		return beforeSort;
	}

	public void setBeforeSort(String beforeSort) {
		this.beforeSort = beforeSort;
	}
}