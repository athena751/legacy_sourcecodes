/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: ServerProtectTHeaderRender.java,v 1.3 2007/05/09 06:44:28 wanghb Exp $
 */

package com.nec.nsgui.action.serverprotect;

import javax.servlet.jsp.PageContext;
import org.apache.struts.taglib.TagUtils;
import com.nec.nsgui.taglib.nssorttab.*;

public class ServerProtectTHeaderRender extends STAbstractRender {

	/**
	 * Get the HTML code of the table Header which specified by (rowIndex,
	 * colName)
	 * 
	 * @param rowIndex
	 * @param colName
	 * @return HTML code
	 * @throws Exception
	 */

	public String getCellRender(int rowIndex, String colName) throws Exception {

		SortTagInfo tagInfo = getSortTagInfo();
		String thMsg = tagInfo.getHeaderMsg(colName);
		PageContext context = tagInfo.getPageContext();

		if (thMsg == null || (thMsg.trim()).equals("")) {
			return (rowIndex == 0) ? "<th rowspan=\"2\">&nbsp;</th>" : "";
		}
		thMsg = String2HTML(thMsg);
		// display a button
		if (tagInfo.isSortable(colName)) {
			String queryStr = tagInfo.getQueryString();
			if (queryStr == null || (queryStr.trim()).equals("")) {
				queryStr = "";
			} else {
				queryStr = queryStr + "&";
			}
			thMsg = "<input type=\"button\" value=\"" + thMsg
					+ "\" onclick=\"window.location=window.location.href.split('?')[0]+'?"
					+ queryStr + "SORTTABLE_ID=" + tagInfo.getId()
					+ "&SORTTABLE_COL=" + colName + "'\" />";
		} // display the text

		if (rowIndex == 0 && colName.equals("readCheck")) {
			return "<th colspan=\"2\" nowrap>"
					+ TagUtils.getInstance().message(context, null, null,
							"serverprotect.scantarget.scantiming.th") + "</th>";
		} else if (rowIndex == 0 && colName.equals("shareName")) {
			return "<th rowspan=\"2\" nowrap>" + thMsg + "</th>";
		} else if (rowIndex == 1 && colName.equals("readCheck")) {
			return "<th nowrap>" + thMsg + "</th>";
		} else if (rowIndex == 1 && colName.equals("writeCheck")) {
			return "<th nowrap>" + thMsg + "</th>";
		} else if (rowIndex == 0 && colName.equals("sharePath")) {
			return "<th rowspan=\"2\" nowrap>" + thMsg + "</th>";
		} else {
			return "";
		}
	}
}
