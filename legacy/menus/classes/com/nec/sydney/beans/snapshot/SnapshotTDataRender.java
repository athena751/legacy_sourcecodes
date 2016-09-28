/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: SnapshotTDataRender.java,v 1.2 2007/05/30 10:03:37 liy Exp $
 */

package com.nec.sydney.beans.snapshot;

import javax.servlet.http.HttpSession;

import com.nec.nsgui.taglib.nssorttab.*;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.framework.NSMessageDriver;

public class SnapshotTDataRender extends STAbstractRender implements
		NasConstants {

	/**
	 * Get the HTML code which specified by (rowIndex, colName)
	 * 
	 * @param rowIndex
	 * @param colName
	 * @return HTML code
	 * @throws Exception
	 */
	public String getCellRender(int rowIndex, String colName) throws Exception {
		SortTableModel tableModel = getTableModel();
		String cellData = getCellData(rowIndex, colName);
		String htmlCode;
		String scheduleName = tableModel.getValueAt(rowIndex, "scheduleName")
				.toString();
		if (colName.equals("scheduleList")) {
			htmlCode = "<td nowrap><input type=\"radio\" name=\"scheduleList\" id=\"delete";
			htmlCode = htmlCode + rowIndex;
			htmlCode = htmlCode + "\"value=\"\" onclick=\"setDeleteName('";
			htmlCode = htmlCode + "" + scheduleName
					+ "') \"></td><script language=JavaScript> schName[";
			htmlCode = htmlCode + rowIndex + "]=\"" + scheduleName
					+ "\"</script>";
			
		} else if (colName.equals("scheduleName")) {
			htmlCode = "<td nowrap><label for=\"delete" + rowIndex + "\">"
					+ scheduleName + "</label></td>";
		} else {
			htmlCode = "<td nowrap>";
			htmlCode = htmlCode + cellData;
			htmlCode = htmlCode + "</td>";
		}
		return htmlCode;

	}

	/**
	 * Get the HTML code between
	 * <td> and </td>
	 * which specified by (rowIndex, colName)
	 * 
	 * @param rowIndex
	 * @param colName
	 * @return HTML code
	 * @throws Exception
	 */
	private String getCellData(int rowIndex, String colName) throws Exception {

		SortTagInfo tagInfo = getSortTagInfo();
		HttpSession session = tagInfo.getPageContext().getSession();
		java.text.DecimalFormat df = new java.text.DecimalFormat("00");
		String[] weekday = {
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_sun"),
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_mon"),
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_tue"),
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_wed"),
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_thu"),
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_fri"),
				NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/nsview_sat") };
		String[] displayDay;

		SortTableModel tableModel = getTableModel();

		String dataStr = "";
		boolean isDeleteSchedule = colName.startsWith("delete");
		int period = Integer.parseInt(tableModel.getValueAt(rowIndex, "period")
				.toString());
		int deletePeriod = Integer.parseInt(tableModel.getValueAt(rowIndex,
				"deletePeriod").toString());

		if (tableModel != null) {
			if (isDeleteSchedule && deletePeriod == 0) {
				return "&nbsp;--&nbsp;";
			}
			if (colName.equals("deleteGeneration"))
				return tableModel.getValueAt(rowIndex, "deleteGeneration")
						.toString();
			switch (isDeleteSchedule ? deletePeriod : period) {
			case CRON_PERIOD_WEEKDAY:
				displayDay = tableModel.getValueAt(rowIndex,
						isDeleteSchedule ? "deleteDay" : "day").toString()
						.split(",");
				for (int i = 0; i < displayDay.length; i++) {
					displayDay[i] = weekday[Integer.parseInt(displayDay[i])];
				}
				dataStr = joinArray2String(displayDay, NSMessageDriver
						.getInstance().getMessage(session,
								"nas_snapshot/snapschedule/separateSign"));
				break;
			case CRON_PERIOD_MONTHDAY:
				dataStr = tableModel.getValueAt(rowIndex,
						isDeleteSchedule ? "deleteDay" : "day").toString()
						+ NSMessageDriver.getInstance().getMessage(session,
								"nas_snapshot/snapschedule/unit_day");
				break;
			case CRON_PERIOD_DAILY:
				dataStr = NSMessageDriver.getInstance().getMessage(session,
						"nas_snapshot/snapschedule/td_daily");
				break;
			case CRON_PERIOD_DIRECTEDIT:
				dataStr = tableModel.getValueAt(
						rowIndex,
						isDeleteSchedule ? "deleteDirectEditInfo"
								: "directEditInfo").toString();
				break;
			}

			if ((isDeleteSchedule ? deletePeriod : period) != CRON_PERIOD_DIRECTEDIT) {

				dataStr = dataStr
						+ "&nbsp;&nbsp;"
						+ tableModel.getValueAt(rowIndex,
								isDeleteSchedule ? "deleteHour" : "hour")
								.toString()
						+ NSMessageDriver.getInstance().getMessage(session,
								"nas_snapshot/snapschedule/unit_hour")
						+ df.format(Double.parseDouble(tableModel.getValueAt(
								rowIndex,
								isDeleteSchedule ? "deleteMinute" : "minute")
								.toString()))
						+ NSMessageDriver.getInstance().getMessage(session,
								"nas_snapshot/snapschedule/unit_minute");
			}

		}
		if (dataStr.trim().equals(""))
			return "&nbsp;--&nbsp;";
		else
			return "&nbsp;" + dataStr + "&nbsp;";
	}

	private String joinArray2String(String[] paramArray, String joinSign) {
		StringBuffer tmpResult = new StringBuffer();
		for (int i = 0; i < paramArray.length; i++) {
			tmpResult.append(paramArray[i]);
			if (i != paramArray.length - 1) {
				tmpResult.append(joinSign);
			}
		}
		return tmpResult.toString();
	}
}