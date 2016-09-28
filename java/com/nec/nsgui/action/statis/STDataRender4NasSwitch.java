/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.AbstractList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.statis.NasSwitchMaxAverBean;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class STDataRender4NasSwitch
	extends STAbstractRender
	implements StatisActionConst {
	public static final String cvsid =
		"@(#) $Id: STDataRender4NasSwitch.java,v 1.2 2007/04/25 02:04:08 yangxj Exp $";

	public String getCellRender(int rowIndex, String colName)
		throws Exception {
		PageContext context = getSortTagInfo().getPageContext();
		AbstractList exportsList =
			((ListSTModel) getTableModel()).getDataList();
		NasSwitchSubItemInfoBean exportObj =
			(NasSwitchSubItemInfoBean) exportsList.get(rowIndex);
		String isWhichNode = exportObj.getIsWhichNode();
		String checked = "";
		List subItemList_checked =
			(List) NSActionUtil.getSessionAttribute(
				(HttpServletRequest) context.getRequest(),
				SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED);
		if (subItemList_checked != null) {
			for (int i = 0; i < subItemList_checked.size(); i++) {
				NasSwitchSubItemInfoBean temp =
					(NasSwitchSubItemInfoBean) subItemList_checked.get(i);
				if (exportObj.getSubItem().equals(temp.getSubItem())) {
					checked = "checked";
					break;
				}
			}
		}
		if (colName.equals("subItemCheckbox")) {
			StringBuffer cellStr =
				new StringBuffer(
					"<input name=\"subItemCheckbox\" type=\"checkbox\" "
						+ " value=\"");
			cellStr.append(exportObj.getSequence());
			cellStr.append("\" id=\"subItemCheckbox" + rowIndex);
			cellStr.append("\" " + checked);
			cellStr.append(" onClick=\"return checkNum(");
			cellStr.append(");\">");
			cellStr.append("<script language=\"javascript\">");
			cellStr.append(
				"subItem['"
					+ exportObj.getSequence()
					+ "']='"
					+ exportObj.getInterval()
					+ "';");
			cellStr.append("</script>");
			if (isWhichNode.equals("both")) {
				return "<td nowrap align=center rowspan=\"2\">"
					+ cellStr.toString()
					+ "</td>";
			} else {
				return "<td nowrap align=center>"
					+ cellStr.toString()
					+ "</td>";
			}
		}
		if (colName.equals("subItem")) {
			String subItem =
				NSActionUtil.sanitize(
					NSActionUtil.perl2Page(
						exportObj.getSubItem(),
						NSActionConst.ENCODING_EUC_JP));
			if (isWhichNode.equals("both")) {
				return "<td nowrap align=left rowspan=\"2\">"
					+ "<label for=\"subItemCheckbox"
					+ rowIndex
					+ "\">"
					+ subItem
					+ "</label>"
					+ "</td>";
			} else {
				return "<td nowrap align=left>"
					+ "<label for=\"subItemCheckbox"
					+ rowIndex
					+ "\">"
					+ subItem
					+ "</label>"
					+ "</td>";
			}
		}
		if (colName.equals("node")) {
			String node_message = "";
			String collectionId =
				(String) NSActionUtil.getSessionAttribute(
					(HttpServletRequest) context.getRequest(),
					SESSION_COLLECTION_ID);
			if (collectionId.trim().equals(NSW_NFS_Virtual_Export)) {
				node_message =
					TagUtils.getInstance().message(
						context,
						null,
						null,
						"statis.nasswitch.group");
			}
			if (collectionId.trim().equals(NSW_NFS_Server)) {
				node_message =
					TagUtils.getInstance().message(
						context,
						null,
						null,
						"statis.nasswitch.node");
			}
			if (isWhichNode.equals("both") || isWhichNode.equals("group0"))
				return "<td nowrap align=left>" + node_message + "0</td>";
			if (isWhichNode.equals("both") || isWhichNode.equals("group1"))
				return "<td nowrap align=left>" + node_message + "1</td>";
		}
		if (colName.equals("access_average")
			|| colName.equals("access_max")
			|| colName.equals("response_average")
			|| colName.equals("response_max")
			|| colName.equals("rover_average")
			|| colName.equals("rover_max")) {
			NasSwitchMaxAverBean nodeInfo = new NasSwitchMaxAverBean();
			if (isWhichNode.equals("both") || isWhichNode.equals("group0")) {
				nodeInfo = exportObj.getBean4Node0();
			} else {
				nodeInfo = exportObj.getBean4Node1();
			}
			String content =
				PropertyUtils.getProperty(nodeInfo, colName).toString();

			if (content.equals("--")) {
				return "<td nowrap align=center>" + content + "</td>";
			} else {
				return "<td nowrap align=right>" + content + "</td>";
			}
		}
		if (colName.equals("stockPeriod")) {
			String stockPeriod = exportObj.getStockPeriod();
			if (!isWhichNode.equals("both")
				&& stockPeriod.trim().equals("--")) {
				return "<td nowrap align=center>" + stockPeriod + "</td>";
			} else if (
				!isWhichNode.equals("both")
					&& !stockPeriod.trim().equals("--")) {
				return "<td nowrap align=right>" + stockPeriod + "</td>";
			} else if (
				isWhichNode.equals("both")
					&& stockPeriod.trim().equals("--")) {
				return 
					"<td nowrap align=center rowspan=\"2\">"
						+ stockPeriod
						+ "</td>";
			} else if (
				isWhichNode.equals("both")
					&& !stockPeriod.trim().equals("--")) {
				return
					"<td nowrap align=right rowspan=\"2\">"
						+ stockPeriod
						+ "</td>";
			}			
		}
		if (colName.equals("interval")) {
			String interval = exportObj.getInterval();
			StringBuffer cell = new StringBuffer();
			if (!isWhichNode.equals("both") && interval.trim().equals("--")) {
				return "<td nowrap align=center>" + interval + "</td>";
			} else if (
				!isWhichNode.equals("both") && !interval.trim().equals("--")) {
				return "<td nowrap align=right>"
					+ Integer.parseInt(interval) / 60
					+ "</td>";
			} else if (
				isWhichNode.equals("both") && interval.trim().equals("--")) {
				cell.append(
					"<td nowrap align=center rowspan=\"2\">"
						+ interval
						+ "</td>");
			} else if (
				isWhichNode.equals("both") && !interval.trim().equals("--")) {
				cell.append(
					"<td nowrap align=right rowspan=\"2\">"
						+ Integer.parseInt(interval) / 60
						+ "</td>");
			}
			if (isWhichNode.equals("both")) {
				NasSwitchMaxAverBean node1Info = exportObj.getBean4Node1();
				String access_average = node1Info.getAccess_average();
				String access_max = node1Info.getAccess_max();
				String response_average = node1Info.getResponse_average();
				String response_max = node1Info.getResponse_max();
				String rover_average = node1Info.getRover_average();
				String rover_max = node1Info.getRover_max();
				String node_message = "";
				String collectionId =
					(String) NSActionUtil.getSessionAttribute(
						(HttpServletRequest) context.getRequest(),
						SESSION_COLLECTION_ID);
				if (collectionId.equals(NSW_NFS_Virtual_Export)) {
					node_message =
						TagUtils.getInstance().message(
							context,
							null,
							null,
							"statis.nasswitch.group");
				}
				if (collectionId.equals(NSW_NFS_Server)) {
					node_message =
						TagUtils.getInstance().message(
							context,
							null,
							null,
							"statis.nasswitch.node");
				}
				cell.append("</tr><tr><td nowrap align=center>");
				cell.append(node_message);
				cell.append("1</td>");
				if (access_average.equals("--")) {
					cell.append(
						"<td nowrap align=center>" + access_average + "</td>");
				} else {
					cell.append(
						"<td nowrap align=right>" + access_average + "</td>");
				}
				if (access_max.equals("--")) {
					cell.append(
						"<td nowrap align=center>" + access_max + "</td>");
				} else {
					cell.append(
						"<td nowrap align=right>" + access_max + "</td>");
				}
				if (response_average.equals("--")) {
					cell.append(
						"<td nowrap align=center>"
							+ response_average
							+ "</td>");

				} else {
					cell.append(
						"<td nowrap align=right>" + response_average + "</td>");
				}
				if (response_max.equals("--")) {
					cell.append(
						"<td nowrap align=center>" + response_max + "</td>");

				} else {
					cell.append(
						"<td nowrap align=right>" + response_max + "</td>");
				}
				if (rover_average.equals("--")) {
					cell.append(
						"<td nowrap align=center>" + rover_average + "</td>");

				} else {
					cell.append(
						"<td nowrap align=right>" + rover_average + "</td>");
				}
				if (rover_max.equals("--")) {
					cell.append(
						"<td nowrap align=center>" + rover_max + "</td>");

				} else {
					cell.append(
						"<td nowrap align=right>" + rover_max + "</td>");
				}
			}
			return cell.toString();
		}
		return "";
	}
}