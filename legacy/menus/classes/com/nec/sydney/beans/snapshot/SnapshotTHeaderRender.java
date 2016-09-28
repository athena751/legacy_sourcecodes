/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnapshotTHeaderRender.java,v 1.4 2007/05/31 06:42:44 liy Exp $
 */
 
package com.nec.sydney.beans.snapshot;

import javax.servlet.http.HttpSession;

import com.nec.nsgui.taglib.nssorttab.*;
import com.nec.sydney.framework.NSMessageDriver;

public class SnapshotTHeaderRender extends STAbstractRender {

	/**
	 * Get the HTML code of the table Header which specified by (rowIndex,
	 * colName)
	 * 
	 * @param rowIndex
	 * @param colName
	 * @return HTML code
	 * @throws Exception
	 */

	public String getCellRender(int rowIndex, String colName) {

		SortTagInfo tagInfo = getSortTagInfo();
		String thMsg = tagInfo.getHeaderMsg(colName);
		HttpSession session = tagInfo.getPageContext().getSession();

		thMsg = String2HTML(thMsg);
		String queryStr = tagInfo.getQueryString();
		// display a button
		if (tagInfo.isSortable(colName)) {

			if (queryStr == null || (queryStr.trim()).equals("")) {
				queryStr = "";
			} else {
				queryStr = queryStr + "&";
			}
		thMsg="<input type=\"button\" value=\"" 
					+thMsg+ 
	                 "\" onclick=\"window.location=window.location.href.split('?')[0] + '?" 
					+ queryStr + "SORTTABLE_ID=" + tagInfo.getId()
					+ "&SORTTABLE_COL=" + colName + "'\" />";
		} // display the text
		
		if (colName.equals("scheduleList")) {
			return "<th rowspan=\"2\" nowrap>&nbsp;</th>";
		} else if (colName.equals("scheduleName")) {
			return "<th rowspan=\"2\" nowrap>"+thMsg+"</th>";
		} else if (colName.equals("generation")) {

			return "<th colspan=\"2\" nowrap>"
					+ NSMessageDriver.getInstance().getMessage(session,
							"nas_snapshot/snapschedule/th_addSchedule")
					+ "</th><th colspan=\"2\" nowrap>"
					+ NSMessageDriver.getInstance().getMessage(session,
							"nas_snapshot/snapschedule/th_deleteSchedule")
					+ "</th></tr><tr>" + "<th nowrap>" + thMsg + "</th>";

		} else {

			return "<th nowrap>" + thMsg + "</th>";
		}

	}
}