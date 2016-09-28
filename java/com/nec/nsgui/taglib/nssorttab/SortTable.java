/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: SortTable.java,v 1.6 2004/09/07 02:22:02 xingh Exp
 *
 *
 */

package com.nec.nsgui.taglib.nssorttab;
import com.nec.nsgui.action.base.NSActionConst;
import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import javax.servlet.http.*;


public class SortTable extends BodyTagSupport  {

	private		final	String		YES	= "yes";
	private		final	String		NO	= "no";
	private		final	String		REQ_TABLE_ID = "SORTTABLE_ID";
	private		final	String		REQ_TABLE_COL = "SORTTABLE_COL";
	private		final	String		ASCEND = "ascend";
	private		final	String		DESCEND = "descend";
	private		final	String		SESSION_KEY = "SORTTABLE_INFO_KEY";



	private		JspWriter	out				= null;

	private		SortTableModel tm       = null;     //store the data passed from user
	private		String		table		= null;		//store the table start tag string
	private		String		sortonload  = null;		// column:ascend|descend
	private		SortTagInfo	sorttaginfo = null;
	private		int	titleTrNum;

    /*************************************************
    * Private utility methods
	*
    * resets internal state
	*/
    private void init() {
		tm = null;
		table = null;
		sortonload = null;
		sorttaginfo = null;
		titleTrNum = 1;
		setId(null);
    }

	public SortTable(){
		init();


	}

	public void setPageContext(PageContext pageContext) {
		super.setPageContext(pageContext);
		out = pageContext.getOut();
	}

	public void setTablemodel(SortTableModel tm){
		this.tm = tm;
	}

	public void setTable(String table){
		this.table = table;
	}

	public void setSortonload(String sortonload){
		this.sortonload = sortonload;
	}

	public void setTitleTrNum(int titleTrNum){
		this.titleTrNum = titleTrNum;
	}
	// Handle the tag
	public int doStartTag() throws JspException {

		Hashtable infos = getInfos();
		if(infos == null){
			infos = new Hashtable();
		}
		/*********************************************
		 *get the URI and QueryString from pageContext
		 */

		String queryString = getQueryString(pageContext);
		
		String requestURL  = getRequestURL(pageContext);

		/*********************************************
		* check the format of sortonload, if failed
		* throw JspException
		*/
		if(!checkSortonload(sortonload)){
			throw new JspException("[nssorttab:table] Invalid Parameter:sortonload.");
		}

		/*********************************************
		 *check the id attribute, if failed throw
		 *JspException
		 */
		 String tagid= getId();
		 if(tagid == null || "".equals(tagid.trim()) || !tagid.matches("\\w+")){
			 throw new JspException("[nssorttab:table] Invalid Parameter:id.");
		 }


		String debug= (String)pageContext.getAttribute("DEBUG");
		if(debug != null){

			DEBUG(out, " RELOAD FROM TAG:" + ReloadFromTag(pageContext));
			DEBUG(out, " I AM THE FIRST:" + IamTheFirstTag(pageContext));
			DEBUG(out, " URL = "  + getRequestURL(pageContext));
			DEBUG(out, " QueryString = " + getQueryString(pageContext));

			DEBUG(out, "  sort column = " + getRequestParameter(pageContext,REQ_TABLE_COL));
			DEBUG(out, "  table to be sorted= " + getRequestParameter(pageContext,REQ_TABLE_ID));
		}

		if(ReloadFromTag(pageContext)){
			/*****************************************
			 *
			 *update the sortinfo in Hashtable that has
			 *the same id  in the request
			 */
			if(IamTheFirstTag(pageContext)){

				String req_id = getRequestParameter(pageContext,REQ_TABLE_ID);
				String req_col = getRequestParameter(pageContext,REQ_TABLE_COL);
				SortInfo si = (SortInfo)infos.get(req_id);

				if (si == null){
					si = new SortInfo();

				}

				si.setSortInfo(req_col);

			    infos.put(req_id,si);
			}

		}else{//JSP page was refreshed

			if(IamTheFirstTag(pageContext)){

				/*********************************************
				*
				*destroy the old infos,and create a new one.
				*/

				if(infos != null) infos.clear();


			}



			/*********************************************
			*Add self's sortinfo into the  Hashtable
			*/
			SortInfo si = new SortInfo();


			si.setId(getId());
			si.setLastColumn(getColonStrPre(sortonload));
			si.setSortorder(getColonStrSuf(sortonload));

			infos.put(getId(),si);

		}
		setInfos(infos);
        /*********************************************
		 *sorttaginfo must be initialized before the
		 *calling of addColumn() method
		 */

		sorttaginfo = new SortTagInfo();
		sorttaginfo.setId(getId());
		sorttaginfo.setPageContext(pageContext);
		sorttaginfo.setQueryString(queryString);
		sorttaginfo.setRequestURI(requestURL);

		return super.doStartTag();
	}

	public int doEndTag() throws JspException {

		/****************************************
		 *
		 *check tablemodel
		 */

		if(tm == null){
			init();
			return EVAL_PAGE;
		}

		if(tm.getRowCount() == 0){
			init();
			return EVAL_PAGE;
		}

		/****************************************
		 *
		 *check the count of columns
		 */
		 int col_count = sorttaginfo.getColumnCount();
		 if(col_count == 0){
			init();
			 return EVAL_PAGE;
		 }
		Hashtable infos = getInfos();
		SortInfo si= (SortInfo)infos.get(getId());
		if(si == null){
			//something wrong
			init();
			return EVAL_PAGE;
		}


		/****************************************
		 * column with the same  name?
		 */

		Hashtable comparators	= new Hashtable();
		Hashtable headerRenders = new Hashtable();
		Hashtable cellRenders	= new Hashtable();
		String    sidesort		= "" ;

		for(int i=0 ; i<col_count; i++){

			ColumnInfo ci = sorttaginfo.getColumn(i);
			String col_name = ci.getName();
			String thrender = ci.getThCellRender();
			String tdrender = ci.getTdCellRender();
			String comparator = ci.getComparator();
			if(col_name.equals(si.getLastColumn())){
				//sidesort maybe null
				sidesort = ci.getSidesort();
			}
			if((comparator!=null) && (!comparators.containsKey(col_name))){
				//instant the comparator

				comparators.put(col_name,InstantComparator(comparator));
			}
			if(!headerRenders.containsKey(thrender)){
				STCellRender stcr = (STCellRender)InstantRender(thrender);

				stcr.setSortTagInfo(sorttaginfo);
				stcr.setTableModel(this.tm);

				headerRenders.put(thrender,stcr);
			}
			if(!cellRenders.containsKey(tdrender)){
				STCellRender stcr = (STCellRender)InstantRender(tdrender);

				stcr.setSortTagInfo(sorttaginfo);
				stcr.setTableModel(this.tm);
				cellRenders.put(tdrender,stcr);
			}

		}

		String debug= (String)pageContext.getAttribute("DEBUG");
		if(debug != null){
			DEBUG(out ,"------------------------------");
			DEBUG(out,"SortInfo");
			DEBUG(out,"&nbsp;&nbsp;id="+ si.getId());
			DEBUG(out,"&nbsp;&nbsp;column="+ si.getLastColumn());
			DEBUG(out,"&nbsp;&nbsp;sortorder=" + si.getSortorder());
			DEBUG(out,"--------------------------------");
			DEBUG(out,"Comparators <---");
			DEBUG(out,"&nbsp;&nbsp; " + comparators.keySet().toString());
			DEBUG(out,"Comparators --->");

			DEBUG(out,"header renders <---");
			DEBUG(out,"&nbsp;&nbsp;" + headerRenders.keySet().toString());
			DEBUG(out,"header renders --->");

			DEBUG(out,"cell renders <---");
			DEBUG(out,"&nbsp;&nbsp;" + cellRenders.keySet().toString());
			DEBUG(out,"cell renders --->");
		}

		if(si.getLastColumn() == null){
			//don't sort

		}else{

			//call sort
            //parameter1: colName,parameter2:isAscend,parameter3:sidesort,parameter4: Hashtable comparators

			tm.sort(si.getLastColumn(),ASCEND.equals(si.getSortorder()),sidesort,comparators);
		}


		StringBuffer bf = new StringBuffer();




		//output the table start tag
		bf.append("<table");
		if(this.table != null){
			bf.append(" "+ table);
		}
		bf.append(">\n");


		//output headers
		for(int j=0; j<titleTrNum; j++){
                    bf.append("<tr>\n");
                    
                    for(int i = 0; i< col_count; i++){
                    	ColumnInfo ci = sorttaginfo.getColumn(i);
                    	String col_name = ci.getName();
                    	String render = ci.getThCellRender();
                    
                    	STCellRender stcr = (STCellRender)headerRenders.get(render);
                    	try{
                    		bf.append(stcr.getCellRender(j,col_name));
                    	}catch(Exception e){
                    		throw new JspException("Table header: getCellRender() failed");
                    	}
                    	bf.append("\n");
                    }
                    bf.append("</tr>\n");
                }
		//output other cells
		for(int i = 0; i< tm.getRowCount(); i++){
			bf.append("<tr>\n");

			for(int j = 0; j<col_count; j++){
				ColumnInfo ci = sorttaginfo.getColumn(j);
				String col_name = ci.getName();
				String render = ci.getTdCellRender();

				STCellRender stcr = (STCellRender)cellRenders.get(render);
				try{
					bf.append(stcr.getCellRender(i,col_name));
				}catch(Exception e){
					throw new JspException("Table cell: getCellRender() failed at row " + i + " column " + col_name);

				}

			}

			bf.append("\n</tr>\n");
		}



		//close table
		bf.append("</table>\n");


		OUTPUT(out,bf.toString());


		init();
		return EVAL_PAGE;
	}


    public void release() {

        super.release();
		init();
    }

	/*********************************************************
	*
	*/
	protected void addColumn(ColumnInfo col) throws JspException{
		for(int i=0; i<sorttaginfo.getColumnCount();i++)
		{
			if(col.getName().equals(sorttaginfo.getColumnName(i))){
				throw new JspException("[nssorttab:column] Invalid Parameter:name =" + col.getName());
			}
		}
		sorttaginfo.addColumn(col);

	}

	private Object InstantComparator(String name) throws JspException{
			try{
				Class com = Class.forName(name);
				Object obj = com.newInstance();
				return obj;
			}catch(Exception baseE){
				String pkg = SortTable.class.getPackage().getName();
				if(pkg != null) name = pkg + "." + name;
				try{
					Class com = Class.forName(name);
					Object obj = com.newInstance();
					return obj;
				}catch(Exception e){
					throw new JspException("[nssorttab:column] Invalid Parameter: comparator " + name );
				}
			}

	}

	private Object InstantRender(String name) throws JspException{
			try{
				Class com = Class.forName(name);
				Object obj = com.newInstance();
				return obj;
			}catch(Exception baseE){
				String pkg = SortTable.class.getPackage().getName();
				if(pkg != null) name = pkg + "." + name;
				try{
					Class com = Class.forName(name);
					Object obj = com.newInstance();
					return obj;
				}catch(Exception e){

					throw new JspException("[nssorttab:column] Invalid Parameter: cellrender " + name);
				}
			}
	}
	private void OUTPUT( JspWriter out, String str){
		try{
			out.println(str);
		}catch(IOException ex){
		}
	}

	private void DEBUG( JspWriter out , String function ){
		try{
			out.println(function + "<br>");
		}catch(IOException ex){

		}
	}

	/*************************************************
	 * @param pc  the PageContext of JSP
	 *  @return true if JSP page was refreshed by sorttab tag
	 *          else return false
	 */
	private boolean ReloadFromTag(PageContext pc){
		HttpServletRequest request =(HttpServletRequest) pageContext.getRequest();
		String req_colname = (String)request.getParameter(REQ_TABLE_COL);
		String req_id = (String)request.getParameter(REQ_TABLE_ID);
		return ((req_colname != null) && (req_id!=null));

	}

	/*************************************************
	 * @param pc  the PageContext of JSP
	 *  @return the URI string of current request
	 *
	 */
	private String getRequestURL(PageContext pc){

        ServletRequest req = pageContext.getRequest();
		HttpServletRequest request =(HttpServletRequest) req;
		// return request.getRequestURI();   2004-07-10
		return request.getRequestURL().toString();

	}

	/*************************************************
	 * @param pc  the PageContext of JSP
	 *  @return the query string of current request
	 *
	 */
	private String getQueryString(PageContext pc){
        String systemEncode = System.getProperty("file.encoding");

        ServletRequest req = pageContext.getRequest();
        HttpServletRequest request =(HttpServletRequest) req;
        
        StringBuffer uri = new StringBuffer();
        Enumeration e = request.getParameterNames();
        try{
        
            while (e != null && e.hasMoreElements()){
                String paraname=(String)e.nextElement();
                String [] params;
                params = request.getParameterValues(paraname);
                for (int i = 0; i<params.length; i++) {
                    if ( !paraname.equals(REQ_TABLE_ID) && !paraname.equals(REQ_TABLE_COL)){
                        String tmp = params[i];
                        if (!systemEncode.equalsIgnoreCase(NSActionConst.BROWSER_ENCODE)) {
                      
                            tmp = new String( tmp.getBytes(systemEncode), NSActionConst.BROWSER_ENCODE);
                        }
                        tmp=java.net.URLEncoder.encode(tmp,NSActionConst.BROWSER_ENCODE);
                        
                        uri.append(paraname).append("=").append(tmp).append("&");
                    }
                }
            }
        }catch (Exception ex){
            
        }
        if(uri.length()>0 && (uri.lastIndexOf("&")==uri.length()-1)){
            uri.deleteCharAt(uri.length()-1);
        }
           
	    return uri.toString();
	}

	/*************************************************
	 * valid format
	 *           colname:[ascend|descend]
	 * @param sortonload
	 * @return  ture if valid else false.
	 */
	private boolean checkSortonload(String sortonload){

		if(sortonload == null) return true;
		String pre = getColonStrPre(sortonload);
		if ( (pre==null) || "".equals(pre.trim())){
			return false;
		}
		String suf = getColonStrSuf(sortonload);
		if(suf == null ) {
			return false;
		}
		if(!suf.equals(ASCEND) && !suf.equals(DESCEND)){
			return false;
		}

		return true;
	}

	private String getColonStrPre(String sortonload){
		if  (sortonload == null)
		{
			return null;
		}else{
			String[] str = sortonload.split(":");
			return str[0];
		}
	}

	private String getColonStrSuf(String sortonload){
		if (sortonload == null)
		{
			return null;
		}else{
			String [] str = sortonload.split(":");
			if(str.length ==2){
				return str[1];
			}else{
				return ASCEND;
			}
		}
	}
	/*************************************************
	 * @param pc  the PageContext of JSP
	 * @return true if this is the first sorttab tag,
	 *         else return false.
	 */
	private boolean IamTheFirstTag(PageContext pc){
		String attrname = "FIRST_SORT_TABLE";

		String str = (String) pageContext.getAttribute(attrname);

		if( str != null && !str.equals("YES"+getId())){
			return false;
		}else{
			pageContext.setAttribute(attrname,"YES" + getId());
		}
		return true;
	}

	private String getRequestParameter(PageContext pc , String attr){
		HttpServletRequest request =(HttpServletRequest) pageContext.getRequest();
		return request.getParameter(attr);
	}
	
	private Hashtable getInfos(){
		return (Hashtable)pageContext.getSession().getAttribute(SESSION_KEY);
	}
	private void setInfos(Hashtable hash){
		pageContext.getSession().setAttribute(SESSION_KEY,hash);
	}
}
