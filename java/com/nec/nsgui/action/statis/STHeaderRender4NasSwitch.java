/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import javax.servlet.jsp.PageContext;

import com.nec.nsgui.taglib.nssorttab.*;

import org.apache.struts.taglib.TagUtils;

public class STHeaderRender4NasSwitch
	extends STAbstractRender
	implements StatisActionConst {
	public static final String cvsid =
		"@(#) $Id: STHeaderRender4NasSwitch.java,v 1.3 2007/05/09 05:36:26 hetao Exp $";

	public String getCellRender(int rowIndex, String colName)
		throws Exception {
		SortTagInfo tagInfo = getSortTagInfo();
		PageContext context = tagInfo.getPageContext();
		String thMsg = tagInfo.getHeaderMsg(colName);
		String uriStr = "window.location.href.split('?')[0]"; //tagInfo.getRequestURI();
		String queryStr = tagInfo.getQueryString();
		if (queryStr == null || (queryStr.trim()).equals("")) {
			queryStr = "";
		} else {
			queryStr = queryStr + "&";
		}
		if (colName.equals("subItemCheckbox")) {
			return "<th rowspan=\"2\">&nbsp;</th>";
		} else if (colName.equals("subItem")) {
			StringBuffer sb = new StringBuffer();
			sb.append("<th align=\"center\" rowspan=\"2\">");
			sb.append(
				"<input type=\"button\" value=\""
					+ thMsg
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append(colName);
			sb.append("'\" /></th>");
			return sb.toString();
		} else if (colName.equals("node")) {
			return "<th rowspan=\"2\" align=\"center\">" + thMsg + "</th>";
		} else if (colName.equals("access_average")) {
			StringBuffer sb = new StringBuffer();
			String access =
				TagUtils.getInstance().message(
					context,
					null,
					null,
					"statis.nasswitch.th.title.access");
			sb.append(" <th align=\"center\" colspan=\"2\">");
			sb.append(access);
			sb.append("</th>");
			String response =
				TagUtils.getInstance().message(
					context,
					null,
					null,
					"statis.nasswitch.th.title.response");
			sb.append(" <th align=\"center\" colspan=\"2\">");
			sb.append(response);
			sb.append("</th>");
			String rover =
				TagUtils.getInstance().message(
					context,
					null,
					null,
					"statis.nasswitch.th.title.rover");
			sb.append(" <th align=\"center\" colspan=\"2\">");
			sb.append(rover);
			sb.append("</th>");
			return sb.toString();
		} else if (colName.equals("stockPeriod")) {
			StringBuffer sb = new StringBuffer();
			sb.append("<th align=\"center\" rowspan=\"2\">");
			sb.append(
				"<input type=\"button\" value=\""
					+ thMsg
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append(colName);
			sb.append("'\" /></th>");
			return sb.toString();
		} else if (colName.equals("interval")) {
			StringBuffer sb = new StringBuffer();
			sb.append("<th align=\"center\" rowspan=\"2\">");
			sb.append(
				"<input type=\"button\" value=\""
					+ thMsg
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append(colName);
			sb.append("'\" /></th>");

			String max =
				TagUtils.getInstance().message(
					context,
					null,
					null,
					"statis.nasswitch.th.title.max");
			String average =
				TagUtils.getInstance().message(
					context,
					null,
					null,
					"statis.nasswitch.th.title.average");

			sb.append("</tr><tr> <th align=\"center\" >");
			sb.append(
				"<input type=\"button\" value=\""
					+ average
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append("access_average");
			sb.append("'\" /></th>");

			String access_max =
				TagUtils.getInstance().message(
					context,
					null,
					null,
					"statis.nasswitch.th.title.access_max");
			sb.append("<th align=\"center\" > ");
			sb.append(
				"<input type=\"button\" value=\""
					+ max
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append("access_max");
			sb.append("'\" /></th>");

			sb.append("<th align=\"center\" >");
			sb.append(
				"<input type=\"button\" value=\""
					+ average
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append("response_average");
			sb.append("'\" /></th>");

			sb.append("<th align=\"center\" > ");
			sb.append(
				"<input type=\"button\" value=\""
					+ max
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append("response_max");
			sb.append("'\" /></th>");

			sb.append("<th align=\"center\" >");
			sb.append(
				"<input type=\"button\" value=\""
					+ average
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append("rover_average");
			sb.append("'\" /></th>");

			sb.append("<th align=\"center\" > ");
			sb.append(
				"<input type=\"button\" value=\""
					+ max
					+ "\""
					+ " onClick=\"window.location=");
			sb.append(uriStr);
			sb.append("+'?" + queryStr);
			sb.append("SORTTABLE_ID=");
			sb.append(tagInfo.getId());
			sb.append("&SORTTABLE_COL=");
			sb.append("rover_max");
			sb.append("'\" /></th>");
			return sb.toString();
		} else {
			return "";
		}

	}
}
