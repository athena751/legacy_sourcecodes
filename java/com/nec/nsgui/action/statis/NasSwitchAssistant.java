/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.nec.nsgui.model.biz.system.NasManager;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.MonitorConfig3;
import com.nec.nsgui.model.biz.statis.NswStatisHandler;
import com.nec.nsgui.model.biz.statis.RRDFilesInfo;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
import com.nec.nsgui.model.entity.statis.NasSwitchMaxAverBean;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;
import com.nec.nsgui.model.entity.statis.YInfoBean;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class NasSwitchAssistant
	extends StatisAssistantBase
	implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: NasSwitchAssistant.java,v 1.1 2005/10/18 16:24:27 het Exp $";	    
	private String collectionID;
	private String isAuto = "0";
	public void init(MessageResources msgRes, HttpServletRequest request) {
		super.initNsw(request, msgRes);
		collectionID =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_COLLECTION_ID);

	}
	private List getCheckedSubItemList() {
		return (List) NSActionUtil.getSessionAttribute(
			_request,
			SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED);
	}
	public static String getCollectionItemKey(String collectionId) {
		return "h1." + collectionId.trim();
	}
  
	public String getMaxByDisplayItem(String watchItemId) {
		String session_y = "statis_" + collectionID + watchItemId;
		YInfoBean yInfo =
			(YInfoBean) _request.getSession().getAttribute(session_y);
		if (yInfo == null) {
			isAuto = "1";
			return (String) getMax().get(watchItemId);
		} else if (yInfo != null && yInfo.getDisplaymax().equals("auto")) {
			isAuto = "1";
			return (String) getMax().get(watchItemId);
		} else {
			isAuto = "0";
			return yInfo.getDisplaymax();
		}
	}
	public String getMinByDisplayItem(String watchItemId) {
		String session_y = "statis_" + collectionID + watchItemId;
		YInfoBean yInfo =
			(YInfoBean) _request.getSession().getAttribute(session_y);
		if (yInfo == null) {
			return null;
		} else if (yInfo != null && yInfo.getDisplaymin().equals("auto")) {
			return null;
		} else {
			return yInfo.getDisplaymin();
		}
	}

	public String generateGraph4SubItem(
		int index,
		String graphType,
		String subItem,
		String targetId,
		String targetNo)
		throws Exception {
		StringBuffer tr = new StringBuffer();
		tr.append("<tr>");
		if (!collectionID.equals(NSW_NFS_Node)
			&& !NSActionUtil.isSingleNode(_request)) {
			tr.append("<td>&nbsp</td>");
		}
		String access_message =
			msgResource.getMessage(
				_request.getLocale(),
				"statis.nasswitch.th.title.access.withunit");
		String response_message =
			msgResource.getMessage(
				_request.getLocale(),
				"statis.nasswitch.th.title.response.withunit");
		String rover_message =
			msgResource.getMessage(
				_request.getLocale(),
				"statis.nasswitch.th.title.rover.withunit");
		tr.append("<td align=center>" + access_message + "</td>");
		tr.append("<td align=center>" + response_message + "</td>");
		tr.append("<td align=center>" + rover_message + "</td>");
		tr.append("</tr>");
		tr.append("<tr>");
		String targetId_message =
			msgResource.getMessage(
				_request.getLocale(),
				"statis.nasswitch.node");
		if (collectionID.equals(NSW_NFS_Virtual_Export)) {
			targetId_message =
				msgResource.getMessage(
					_request.getLocale(),
					"statis.nasswitch.group");
		}
		if (!collectionID.equals(NSW_NFS_Node)
			&& !NSActionUtil.isSingleNode(_request)) {
			tr.append("<td>" + targetId_message + targetNo + "</td>");
		}
		String imageName = collectionID + "_" + index + "_" + targetNo + "_";
		String[] watchItem = getWatchItemId(collectionID);
		for (int i = 0; i < watchItem.length; i++) {
			tr.append(
				generateGraph4WatchItem(
					index,
					graphType,
					subItem,
					targetId,
					watchItem[i],
					targetNo,
					this.getMaxByDisplayItem(watchItem[i]),
					this.getMinByDisplayItem(watchItem[i]),
					isAuto,
					false,
					imageName + i));
		}
		tr.append("</tr>");
		return tr.toString();
	}
	public String generateGraphTable3(
		NasSwitchSubItemInfoBean subItemInfo,
		String graphType)
		throws Exception {
		StringBuffer table = new StringBuffer();
		String subItem = subItemInfo.getSubItem();
		int index = subItemInfo.getSequence();
		String isWhichNode = subItemInfo.getIsWhichNode();
		table.append("<table border=\"1\"><tr><th align=\"left\">");
		String subItem_message = "";
		if (collectionID.equals(NSW_NFS_Virtual_Export)) {
			subItem_message =
				msgResource.getMessage(
					_request.getLocale(),
					"h1.NFS_Virtual_Path.quote");
		}
		if (collectionID.equals(NSW_NFS_Server)) {
			subItem_message =
				msgResource.getMessage(
					_request.getLocale(),
					"h1.NFS_Server.quote");
		}
		if (collectionID.equals(NSW_NFS_Node)) {
			subItem_message =
				msgResource.getMessage(
					_request.getLocale(),
					"h1.NFS_Node.quote");
		}
		subItem =
			NSActionUtil.sanitize(
				NSActionUtil.perl2Page(subItem, NSActionConst.ENCODING_EUC_JP));
		table.append(subItem_message + subItem);
		table.append("</th></tr><tr><td><table style=\"background-image: url(\'blank.gif\');background-color: White;\"");
		if (isWhichNode.equals("group0") || isWhichNode.equals("both")) {
			String targetId = subItemInfo.getBean4Node0().getNode();
			table.append(
				generateGraph4SubItem(
					index,
					graphType,
					subItem,
					targetId,
					"0"));

		}
		if (isWhichNode.equals("group1") || isWhichNode.equals("both")) {
			String targetId = subItemInfo.getBean4Node1().getNode();
			table.append(
				generateGraph4SubItem(
					index,
					graphType,
					subItem,
					targetId,
					"1"));
		}
		table.append("</table></td></tr></table>");
		return table.toString();
	}
    public String getGraphInfoList3(String graphType) throws Exception {
        String comSampleInterval=comSampleIntervalAndDisPeriod(graphType);
        if(!comSampleInterval.equals("no")){            
            return  "<table border =\"0\"><tr><td>"+
            comSampleInterval
            +"</td></tr></table>";
        }
		StringBuffer graphInfo = new StringBuffer();
		List subItemInfoList = getCheckedSubItemList();
		for (int i = 0; i < subItemInfoList.size(); i++) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) subItemInfoList.get(i);
			graphInfo.append(generateGraphTable3(subItemInfo, graphType));
			graphInfo.append("<br>");
		}
		return graphInfo.toString();
	}

	public String generateGraph4WatchItem(
		int index,
		String graphType,
		String subItem,
		String targetId,
		String watchItemId,
		String targetNo,
		String max,
		String min,
		String isAuto,
		boolean grayBackColor,
		String imageName)
		throws Exception {
		StringBuffer sGraph = new StringBuffer();
		String fromDate = convertDateFrom();
		String toDate = convertDateTo();
		String sCollectionID_CGI = StatisActionCommon.URLEncode(collectionID);
		//encoding
		String targetID_CGI = StatisActionCommon.URLEncode(targetId);
		String watchItemID_CGI = StatisActionCommon.URLEncode(watchItemId);
		WatchItemDef wid = mc.getWatchItemDef(watchItemId);
		String sWidth_CGI =
			StatisActionCommon.URLEncode(wid.getGraphSmallWidth().trim());
		String sHeight_CGI =
			StatisActionCommon.URLEncode(wid.getGraphSmallHeight().trim());
		String subItemID_CGI = NSActionUtil.str2hStr(subItem, "EUC_JP");
		sGraph.append("<td align=\"center\">").append(
			"<a href=\"nasSwitchGraph.do?operation=displayDetailGraph&targetID=");

		sGraph
			.append(targetId)
			.append("&targetNo=")
			.append(targetNo)
			.append("&graphType=")
			.append(graphType)
			.append("&grayBackColor=")
			.append(grayBackColor)
			.append("&watchItem=")
			.append(watchItemId)
			.append("&index=")
			.append(index)
			.append("#")
			.append(graphType);

		sGraph
			.append("\"")
			.append(" onclick=\"return disableErrGraphAnchor(")
			.append("document.getElementById('")
			.append(imageName)
			.append("'));\">")
			.append("<img id=\"")
			.append(imageName)
			.append("\" src=\"")
			.append(NSActionConst.CONFIG_ROOT_PATH)
			.append("/cgi")
			.append("/RRDToolCGI.pl?wi=")
			.append(watchItemID_CGI)
			.append("&isNsw=1");
		String sSampleFlag = rgd.getSamplingFlag().trim();
		int iSampleInterval = getSampleInterval();
		if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)) {
			sGraph.append("&si=").append(iSampleInterval);
		}
		sGraph.append("&wd=").append(sWidth_CGI).append("&ht=").append(
			sHeight_CGI);
		sGraph.append("&max=" + max + "&isAuto=" + isAuto);
		if (min != null) {
			sGraph.append("&min=" + min);
		}

		//        if (type.equalsIgnoreCase(StatisConst.PAGE_NAME_DEFAULT)) {
		//            type = rgd.getDefaultPeriod();
		//        }
		if (graphType.equalsIgnoreCase(RRDGraphDef.DAILY)) {
			//generate Daily Graph
			sGraph
				.append("&pft=")
				.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.DAYS))
				.append("&ptt=")
				.append(StatisActionCommon.CurrentTime());
		} else if (graphType.equalsIgnoreCase(RRDGraphDef.WEEKLY)) { //generate
			// Weekly Graph
			sGraph
				.append("&pft=")
				.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.WEEKS))
				.append("&ptt=")
				.append(StatisActionCommon.CurrentTime());
		} else if (
			graphType.equalsIgnoreCase(RRDGraphDef.MONTHLY)) { //generate
			// Monthly
			// Graph
			sGraph
				.append("&pft=")
				.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.MONTHS))
				.append("&ptt=")
				.append(StatisActionCommon.CurrentTime());
		} else if (
			graphType.equalsIgnoreCase(RRDGraphDef.USER_SPEC)) { //generate
			// User
			// Specified
			// Graph
			sGraph =
				sGraph.append("&pft=").append(fromDate).append("&ptt=").append(
					toDate);
		}
		sGraph
			.append("&ni=")
			.append(targetID_CGI)
			.append("&sbi=")
			.append(subItemID_CGI)
			.append("&ci=")
			.append(sCollectionID_CGI)
			.append("&grayBackColor=")
			.append(grayBackColor)
			.append("&id=0\"></a></td>");
		return sGraph.toString();
	}
	public String getDetailGraph3(
		String targetID,
		String index,
		String watchItemId,
		String grayBackColor)
		throws Exception {
		StringBuffer sDetailGraph = new StringBuffer();

		String sCollectionID_CGI = StatisActionCommon.URLEncode(collectionID);
		//encoding
		String targetID_CGI = StatisActionCommon.URLEncode(targetID);
		String watchItemID_CGI = StatisActionCommon.URLEncode(watchItemId);
		WatchItemDef wid = mc.getWatchItemDef(watchItemId);
		String sDetailWidth_CGI =
			StatisActionCommon.URLEncode(wid.getGraphNormalWidth().trim());
		String sDetailHeight_CGI =
			StatisActionCommon.URLEncode(wid.getGraphNormalHeight().trim());
		String subItem = "";
		Iterator iterator = getCheckedSubItemList().iterator();
		while (iterator.hasNext()) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) iterator.next();
			if (subItemInfo.getSequence() == Integer.parseInt(index)) {
				subItem = subItemInfo.getSubItem();
				break;
			}
		}
		String subItem_temp =
			NSActionUtil.sanitize(
				NSActionUtil.perl2Page(subItem, NSActionConst.ENCODING_EUC_JP));
		String sSubItemID_CGI = NSActionUtil.str2hStr(subItem_temp, "EUC_JP");
		_request.setAttribute("subItem", subItem_temp);
		String max = this.getMaxByDisplayItem(watchItemId);
		String min = this.getMinByDisplayItem(watchItemId);
		StringBuffer StrHead =
			new StringBuffer("<img src=\"")
				.append(NSActionConst.CONFIG_ROOT_PATH)
				.append("/cgi")
				.append("/RRDToolCGI.pl?wi=")
				.append(watchItemID_CGI)
				.append("&isNsw=1");
		String sSampleFlag = rgd.getSamplingFlag().trim();
		int iSampleInterval = getSampleInterval();
		if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)) {
			StrHead.append("&si=").append(iSampleInterval);
		}

		StrHead.append("&max=").append(max);

		if (min != null) {
			StrHead.append("&min=").append(min);
		}
		StrHead.append("&wd=").append(sDetailWidth_CGI).append(
			"&ht=" + sDetailHeight_CGI);

		StringBuffer StrRear =
			new StringBuffer("&ni=")
				.append(targetID_CGI)
				.append("&sbi=")
				.append(sSubItemID_CGI)
				.append("&grayBackColor=")
				.append(grayBackColor)
				.append("&ci=")
				.append(sCollectionID_CGI)
				.append("&id=1\" border=\"1\">");

		/*
		 * generate html for showing daily detail graph No matter what the value
		 * of iStockPeriod is, daily graph will be displayed
		 */
		String watchItem_message = "";
		String[] watchItem = getWatchItemId(collectionID);
		if (watchItemId.equals(watchItem[0])) {
			watchItem_message =
				msgResource.getMessage(
					_request.getLocale(),
					"statis.nasswitch.th.title.access");
		}
		if (watchItemId.equals(watchItem[1])) {
			watchItem_message =
				msgResource.getMessage(
					_request.getLocale(),
					"statis.nasswitch.th.title.response");
		}
		if (watchItemId.equals(watchItem[2])) {
			watchItem_message =
				msgResource.getMessage(
					_request.getLocale(),
					"statis.nasswitch.th.title.rover");
		}
		sDetailGraph
			.append("<h4 class=\"title\"><a name=\"Daily\">")
			.append(
				msgResource.getMessage(
					_request.getLocale(),
					"statis.nasswitch.daily_graph",
					watchItem_message))
			.append("</a></h4>");
		if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)
			&& iSampleInterval > 24 * 3600) {
			sDetailGraph
				.append(
					msgResource.getMessage(
						_request.getLocale(),
						"RRDGraph.msg_big_interval"))
				.append("<br>");
		} else {
			//No.1 mod daily_graph=>hourly_graph
			sDetailGraph
				.append(StrHead)
				.append("&pft=")
				.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.DAYS))
				.append("&ptt=")
				.append(StatisActionCommon.CurrentTime())
				.append(StrRear);
			//display daily graph
		}

		/*
		 * generate html for showing weekly detail graph; weekly graph will
		 * be showed on condition that iStockPeriod is between 2 and 366
		 */
			sDetailGraph
				.append("<h4 class=\"title\"><a name=\"Weekly\">")
				.append(
					msgResource.getMessage(
						_request.getLocale(),
						"statis.nasswitch.weekly_graph",
						watchItem_message))
				.append("</a></h4>")
			//No.1 mod weekly_graph=>daily_graph
			.append(StrHead)
			.append("&pft=")
			.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.WEEKS))
			.append("&ptt=")
			.append(StatisActionCommon.CurrentTime())
			.append(StrRear);
			//display weekly graph		

		/*
		 * generate html for showing monthly detail graph monthly graph will
		 * be showed on condition that iStockPeriod is between 8 and 366
		 */
			sDetailGraph
				.append("<h4 class=\"title\"><a name=\"Monthly\">")
				.append(
					msgResource.getMessage(
						_request.getLocale(),
						"statis.nasswitch.monthly_graph",
						watchItem_message))
				.append("</a></h4>")
				.append(StrHead)
				.append("&pft=")
				.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.MONTHS))
				.append("&ptt=")
				.append(StatisActionCommon.CurrentTime())
				.append(StrRear);
			//display monthly graph

		/*
		 * generate html for showing yearly detail graph yearly graph will
		 * be showed on condition that iStockPeriod is between 32 and 366
		 */
			sDetailGraph
				.append("<h4 class=\"title\"><a name=\"Yearly\">")
				.append(
					msgResource.getMessage(
						_request.getLocale(),
						"statis.nasswitch.yearly_graph",
						watchItem_message))
				.append("</a></h4>") //No.1
			// mod
			// yearly_graph=>monthly_graph
			.append(StrHead)
			.append("&pft=")
			.append(StatisActionCommon.ChangeTime("1", RRDGraphDef.YEARS))
			.append("&ptt=")
			.append(StatisActionCommon.CurrentTime())
			.append(StrRear);
			//display yearly graph

		//convert beginning time and end time
		String fromDate, toDate;
		fromDate = convertDateFrom();
		toDate = convertDateTo();

		/*
		 * generate html for displaying userSpec graph No matter what the value
		 * of iStockPeriod is, userSpec graph will be displayed
		 */

		sDetailGraph
			.append("<h4 class=\"title\"><a name=\"User Specification\">")
			.append(
				msgResource.getMessage(
					_request.getLocale(),
					"statis.nasswitch.speci_graph",
					watchItem_message))
			.append("</a></h4>");

		//added by baiwq for (nas 3633) [nas-dev-necas:03122] at 2002.07.17
		if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)
			&& (iSampleInterval
				> (Long.parseLong(toDate) - Long.parseLong(fromDate)))) {
			sDetailGraph
				.append(
					msgResource.getMessage(
						_request.getLocale(),
						"RRDGraph.msg_big_interval"))
				.append("<br>");
		} else {
			sDetailGraph
				.append(StrHead)
				.append("&pft=")
				.append(fromDate)
				.append("&ptt=")
				.append(toDate)
				.append(StrRear);

		}
		//display userSpec graph graph

		return sDetailGraph.toString();

	}

	public List getAllSubItemInfoList(String type) throws Exception {
		String[] date = getSampleDate(type);
		int sampleInterval = 0;
		if (rgd.getSamplingFlag().trim().equals(RRDGraphDef.SPECIFIC)) {
			sampleInterval = getSampleInterval();
		}
		int subItemNum = 0;
		List targetList = getTargetList();
		Map resultMap = new HashMap();
		for (int i = 0; i < targetList.size(); i++) {			
			String targetID = (String) targetList.get(i);
			int nodeNo =
				NasManager
					.getInstance()
					.getServerById(targetID)
					.getMyNode();
			List subItemList = this.getSubItemList(targetID);
			for (int j = 0; j < subItemList.size(); j++) {
				String subItem = (String) subItemList.get(j);
				NasSwitchMaxAverBean bean = new NasSwitchMaxAverBean();
				bean.setNode(targetId);
				if (i > 0) {
					if (resultMap.containsKey(subItem)) {
						NasSwitchSubItemInfoBean subItemInfo_temp =
							(NasSwitchSubItemInfoBean) resultMap.get(subItem);
						if (nodeNo == 0 || nodeNo == -1) {
							subItemInfo_temp.setBean4Node0(bean);
						} else {
							subItemInfo_temp.setBean4Node1(bean);
						}
						subItemInfo_temp.setIsWhichNode("both");
						resultMap.put(subItem, subItemInfo_temp);
						subItemNum++;
						continue;
					}
				}
				NasSwitchSubItemInfoBean subItemInfo =
					new NasSwitchSubItemInfoBean();
				String stockPeriod = this.getStockPeriod(targetID, subItem);
				String interval = this.getInterval(targetID, subItem);
				subItemInfo.setSequence(subItemNum);
				subItemInfo.setSubItem(subItem);
				subItemInfo.setStockPeriod(stockPeriod);
				subItemInfo.setInterval(interval);
				if (nodeNo == 0 || nodeNo == -1) {
					subItemInfo.setBean4Node0(bean);
					subItemInfo.setIsWhichNode("group0");
				} else {
					subItemInfo.setBean4Node1(bean);
					subItemInfo.setIsWhichNode("group1");
				}
				resultMap.put(subItem, subItemInfo);
				subItemNum++;
			}
		}
		if (collectionID.equals(NSW_NFS_Node)) {
			return Arrays.asList(resultMap.values().toArray());
		} else {
			if (resultMap.size() <= 0) {
				return new ArrayList();
			} else {
				return NswStatisHandler.getSubItemInfoList(
					subItemNum,
					date[0],
					date[1],
					collectionID,
					String.valueOf(sampleInterval),
					resultMap);
			}
		}

	}
	public static String[] getWatchItemId(String collectionId) {
		String[] watchItem = new String[3];
		if (collectionId.equals(NSW_NFS_Virtual_Export)) {
			watchItem[0] = NSW_NFS_VE_Access;
			watchItem[1] = NSW_NFS_VE_Response_Time_Average;
			watchItem[2] = NSW_NFS_VE_Retry;
			return watchItem;
		} else if (collectionId.equals(NSW_NFS_Server)) {
			watchItem[0] = NSW_NFS_VS_Access;
			watchItem[1] = NSW_NFS_VS_Response_Time_Average;
			watchItem[2] = NSW_NFS_VS_Retry;
			return watchItem;
		} else {
			watchItem[0] = NSW_NFS_VN_Access;
			watchItem[1] = NSW_NFS_VN_Response_Time_Average;
			watchItem[2] = NSW_NFS_VN_Retry;
			return watchItem;
		}
	}
	public HashMap getMax() {
		HashMap maxMap = new HashMap();
		String accessMax = "--";
		String responseMax = "--";
		String roverMax = "--";
		LineNumComparator com = new LineNumComparator();
		List subItemInfoList = getCheckedSubItemList();
		Iterator i = subItemInfoList.iterator();
		while (i.hasNext()) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) i.next();
			String temp_accessMax = subItemInfo.getAccess_max();
			String temp_respnseMax = subItemInfo.getResponse_max();
			String temp_roverMax = subItemInfo.getRover_max();
			if (com.compare(accessMax, temp_accessMax) < 0) {
				accessMax = temp_accessMax;
			}
			if (com.compare(responseMax, temp_respnseMax) < 0) {
				responseMax = temp_respnseMax;
			}
			if (com.compare(roverMax, temp_roverMax) < 0) {
				roverMax = temp_roverMax;
			}
		}
		if (accessMax.equals("--")) {
			accessMax = "0";
		}
		if (responseMax.equals("--")) {
			responseMax = "0";
		}
		if (roverMax.equals("--")) {
			roverMax = "0";
		}
		String watchItem[] = getWatchItemId(collectionID);
		maxMap.put(watchItem[0], accessMax);
		maxMap.put(watchItem[1], responseMax);
		maxMap.put(watchItem[2], roverMax);
		return maxMap;
	}
	private List getSubItemList(String target) throws Exception {
		RRDFilesInfo rfi = mc.loadRRDFilesInfo(target, collectionID);
		return rfi.getIDList();
	}
	private String getStockPeriod(String targetID, String subItem)
		throws Exception {
		MonitorConfig3 mc3 = (MonitorConfig3) mc;
		return mc3.getStockPeriod(targetID, collectionID, subItem);
	}
	private String getInterval(String targetID, String subItem)
		throws Exception {
		MonitorConfig3 mc3 = (MonitorConfig3) mc;
		return mc3.getInterval(targetID, collectionID, subItem);
	}
}
