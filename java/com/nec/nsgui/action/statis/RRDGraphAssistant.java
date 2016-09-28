/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.RRDGraphHandler;
import com.nec.nsgui.model.entity.statis.GraphInfoBean;
import com.nec.nsgui.model.biz.statis.CollectionItemDef;
import com.nec.nsgui.model.biz.statis.DisplayInfo;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.RRDFile;
import com.nec.nsgui.model.biz.statis.RRDFilesInfo;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.biz.statis.TargetDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
import com.nec.nsgui.model.biz.system.NasManager;
import com.nec.nsgui.model.entity.statis.YInfoBean;
import com.nec.nsgui.model.biz.statis.SamplingHandler;

/**
 *  
 */
public class RRDGraphAssistant
    extends StatisAssistantBase
    implements StatisActionConst {
    public static final String cvsid =
        "@(#) $Id: RRDGraphAssistant.java,v 1.17 2007/09/04 02:12:46 yangxj Exp $";
    private String isInvestGraph;
    private String watchItemId;
    private WatchItemDef wid;
    private RRDFilesInfo rfi;
    private String computerName;
    private int nodeNo;
    public void init(
        MessageResources msgRes,
        HttpServletRequest request,
        String _isInvestGraph) {
        if (_isInvestGraph.equals("1")) {
            super.initInvest(request, msgRes);
        } else {
            super.initNormal(request, msgRes);
        }
        watchItemId =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_WATCHITEM_ID);
        wid = mc.getWatchItemDef(watchItemId);
        isInvestGraph = _isInvestGraph;
        msgResource = msgRes;
        computerName = (String)NSActionUtil.getSessionAttribute(request, SESSION_COMPUTER_NAME);
        nodeNo = NSActionUtil.getCurrentNodeNo(request);
    }

    public static String getWatchItemKey(String watchItem) {
        return "h1." + watchItem;
    }

    public String getStockPeriod(String tarId) throws Exception {
        String collectionItem = wid.getCollectionItem();
        if (this.isInvestGraph.equals("0")) {
            MonitorConfig mc1 = (MonitorConfig) mc;
            return mc1.getStockPeriod(tarId, collectionItem);
        } else {
            MonitorConfig2 mc2 = (MonitorConfig2) mc;
            return mc2.getStockPeriod(tarId, collectionItem);
        }
    }

    public String getCollectionItem() {
        return wid.getCollectionItem().trim();
    }

    public String getIllustration() {
        List displayInfoIDList = wid.getDisplayInfos().getIDList();
        Iterator it = displayInfoIDList.iterator();
        StringBuffer illusbuf = new StringBuffer();
        while (it.hasNext()) {
            String displayInfoID = (String) it.next();
            DisplayInfo di = wid.getDisplayInfos().get(displayInfoID);
            String desc = di.getDesc();
            // such as "CPU Used"
            String color = di.getColor(); // such as "#00ff00"
            //generate html for showing color definition on the web page

            illusbuf
                .append("<table border=\"0\"><tr><td bgcolor=\"")
                .append(color)
                .append("\">&nbsp;</td><td>")
                .append(desc)
                .append("</td></tr></table>");
        }
        return illusbuf.toString();
    }
    public List getGraphInfoList(String graphType) throws Exception {
        List graphInfoList = new ArrayList();
        List targetList = getTargetList();
        int targetListSize = targetList.size();
        Map onlyOsFsExistMap = new HashMap();
        for (int i = 0; i < targetListSize; i++) {
            if (watchItemId.trim().equals(WatchItemDef.Nvavs_Request)
                    || watchItemId.trim().equals(WatchItemDef.Nvavs_TAT)){
                if( nodeNo != i ){
                    continue;
                }
            }
            GraphInfoBean gInfo = new GraphInfoBean();
            String tagId = (String) targetList.get(i);
            TargetDef tDef = mc.getTargetDef(tagId);
            gInfo.setTargetId(tagId);
            gInfo.setNickName(tDef.getNickName());
            gInfo.setHasDownloadButton(
                Boolean.toString(getSubItemList(tagId).size() != 0));
            gInfo.setGraphTableHtml(getGraph(tagId, graphType, i));
            String onlyOsFsExist =
                (String) _request.getAttribute("only_osfs_exist");
            if (onlyOsFsExist != null) {
                onlyOsFsExistMap.put(tagId, onlyOsFsExist);
            } else {
                onlyOsFsExistMap.put(tagId, "false");
            }
            _request.removeAttribute("only_osfs_exist");
            gInfo.setPeriodNeedShow(PERIOD_WITHIN_YEAR);
            graphInfoList.add(gInfo);
        }
        _request.setAttribute("only_osfs_exist", onlyOsFsExistMap);
        return graphInfoList;
    }

    /* 2003/08/07 lhy added for download */
    /**
     * @function according to stockperiod of targetID to decide periods needed
     *           showing *@param targetID: target ID
     */
    public int getPeriodNeedShow(String targetID) throws Exception {
        int iStockPeriod = Integer.parseInt(getStockPeriod(targetID));
        if (iStockPeriod >= 32) {
            return PERIOD_WITHIN_YEAR;
        } else if (iStockPeriod >= 8) {
            return PERIOD_WITHIN_MONTH;
        } else if (iStockPeriod >= 2) {
            return PERIOD_WITHIN_WEEK;
        } else {
            return PERIOD_WITHIN_DAY;
        }
    }

    public String getGraph(String targetID, String type, int targetNo)
        throws Exception {
        // Generate html codes for displaying graphs
        StringBuffer sGraph = new StringBuffer();
        String watchItem =
            (String) NSActionUtil.getSessionAttribute(
                _request,
                SESSION_WATCHITEM_ID);
        String session_y = "statis_" + watchItem + targetID;
        YInfoBean yInfoBean =
            (YInfoBean) _request.getSession().getAttribute(session_y);
        String max = "0";
        String isAuto = "0";
        if (yInfoBean != null
            && !yInfoBean.getDisplaymax().equals("default")) {
            max = yInfoBean.getDisplaymax();
            isAuto = "0";
        } else {
            if (watchItemId.trim().equals(WatchItemDef.CPU_States)
                || watchItemId.trim().equals(WatchItemDef.Disk_Used_Rate)
                || watchItemId.trim().equals(WatchItemDef.Inode_Used_Rate)) {
                max = "0";
            } else {
                max = getMaxData(type, targetID);
            }
            
            isAuto = "1";
        }
        // convert fromDate and toDate to required format
        String fromDate = convertDateFrom();
        String toDate = convertDateTo();
        String sCollectionID = wid.getCollectionItem().trim();
        if (getClusterTag().equals("false")) {
            List subItemList = getSubItemList(targetID);

            sGraph.append("<br>");
            generateGraphTable(
                sGraph,
                targetID,
                fromDate,
                toDate,
                type,
                max,
                isAuto,
                false,
                filterFileSystem(subItemList),
                targetNo,
                sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem)||sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem_Quantity),
                subItemList.size() != 0);
            return sGraph.toString();
        } else {
            if (sCollectionID.equalsIgnoreCase(CollectionItemDef.CPU_States)
                    || sCollectionID.equalsIgnoreCase(CollectionItemDef.Network_IO)
                    || sCollectionID.equalsIgnoreCase(CollectionItemDef.Anti_Virus_Scan)) {
                sGraph.append("<br>");
                generateGraphTable(
                    sGraph,
                    targetID,
                    fromDate,
                    toDate,
                    type,
                    max,
                    isAuto,
                    false,
                    getSubItemList(targetID),
                    targetNo,
                    sCollectionID.equalsIgnoreCase(
                        CollectionItemDef.Filesystem)||sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem_Quantity),
                    getSubItemList(targetID).size() != 0);
                return sGraph.toString();
            } else if (
                sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem)
                    || sCollectionID.equalsIgnoreCase(
                        CollectionItemDef.NAS_LV_IO)||sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem_Quantity)) {
                HashMap volumeMap = getVolumeList(targetID);
                TreeSet adminVolumeList =
                    (TreeSet) volumeMap.get(HASH_KEY_ADMIN_VOLUME_LIST);
                TreeSet otherVolumeList =
                    (TreeSet) volumeMap.get(HASH_KEY_OTHER_VOLUME_LIST);

                generateAdminOtherGraphHtml(
                    sGraph,
                    targetID,
                    fromDate,
                    toDate,
                    type,
                    max,
                    isAuto,
                    adminVolumeList,
                    otherVolumeList,
                    "Volume",
                    targetNo,
                    sCollectionID.equalsIgnoreCase(
                        CollectionItemDef.Filesystem)||sCollectionID.equalsIgnoreCase(
                                CollectionItemDef.Filesystem_Quantity));
                return sGraph.toString();
            } 
        }
        return sGraph.toString();
    }

    private void generateAdminOtherGraphHtml(
        StringBuffer sGraph,
        String targetID,
        String fromDate,
        String toDate,
        String type,
        String max,
        String flag,
        Collection adminList,
        Collection otherList,
        String message,
        int targetNo,
        boolean isFS)
        throws Exception {
        boolean hasResources = true;
        if (otherList.size() == 0 && adminList.size() == 0) {
            hasResources = false;
        }
        if (isFS) {
            otherList = filterFileSystem(otherList);
            adminList = filterFileSystem(adminList);
        }
        if (otherList.size() == 0) {
            sGraph.append("<br>");
            generateGraphTable(
                sGraph,
                targetID,
                fromDate,
                toDate,
                type,
                max,
                flag,
                false,
                adminList,
                targetNo,
                isFS,
                hasResources);
            return;
        }
        sGraph.append(
            "<h4>"
                + msgResource.getMessage(
                    _request.getLocale(),
                    "h4.admin" + message + "List")
                + "</h4>");
        generateGraphTable(
            sGraph,
            targetID,
            fromDate,
            toDate,
            type,
            max,
            flag,
            false,
            adminList,
            targetNo,
            isFS,
            hasResources);
        sGraph.append(
            "<h4>"
                + msgResource.getMessage(
                    _request.getLocale(),
                    "h4.other" + message + "List")
                + "</h4>");
        generateGraphTable(
            sGraph,
            targetID,
            fromDate,
            toDate,
            type,
            max,
            flag,
            true,
            otherList,
            targetNo,
            isFS,
            hasResources);

    }

    private void generateGraphTable(
        StringBuffer sGraph,
        String targetID,
        String fromDate,
        String toDate,
        String type,
        String max,
        String isAuto,
        boolean grayBackColor,
        Collection subItemList,
        int targetNo,
        boolean isFS,
        boolean hasResources)
        throws Exception {
        /*
         * Parameters: sGraph: the StringBuffer to contain html code
         * targetID:identify the target whose graphs will be showed FromDate:
         * the beginning time in RRDGraph-required format ToDate: the end time
         * in RRDGraph-required format type: Daily,Weekly ...... max: the max
         * vlaue in RRD graph Function: when the specified target is not
         * CLUSTER,this function is called to generate html codes to display its
         * graphs Called by: getGraph()
         */

        //add table head identifier
        sGraph = sGraph.append("<table border =\"0\">");
        /*
         * iNumOfShowedGraph stands for the number of subItem in this node
         */
        if (!hasResources) {
            String message = "";
            String watchItemId =
                (String) NSActionUtil.getSessionAttribute(
                    _request,
                    SESSION_WATCHITEM_ID);
            WatchItemDef wid = mc.getWatchItemDef(watchItemId);
            String collectionItemId = wid.getCollectionItem();
            boolean targetStatus = false;
            if (this.isInvestGraph.equals("0")) {
                MonitorConfig mc1 = (MonitorConfig) mc;
                targetStatus = mc1.getTargetStatus(targetID);
            } else {
                MonitorConfig2 mc2 = (MonitorConfig2) mc;
                targetStatus = mc2.getTargetStatus(targetID, collectionItemId);
            }
            if (targetStatus) {
                message =
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.collection_begin_msg");
            } else {
                message =
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.no_collection_msg");
            }
            sGraph.append("<tr><td>").append(message).append(
                "</td></tr>").append(
                "</table><br>");
            return;
        }
        if (isFS) {
            if (subItemList.size() == 0) {
                if (!grayBackColor) {
                    _request.setAttribute("only_osfs_exist", "true");
                    String filterFlag =
                        (String) NSActionUtil.getSessionAttribute(
                            _request,
                            SESSION_STATIS_FILTER_FLAG);
                    if (filterFlag != null && filterFlag.trim().equals("0")) {
                        sGraph
                            .append("<tr><td>")
                            .append(
                                msgResource.getMessage(
                                    _request.getLocale(),
                                    "RRDGraph.message.NoDevices"))
                            .append("</td></tr>")
                            .append("</table><br>");
                    } else {
                        sGraph
                            .append("<tr><td>")
                            .append(
                                msgResource.getMessage(
                                    _request.getLocale(),
                                    "RRDGraph.message.NoDevicesExceptforOS"))
                            .append("</td></tr>")
                            .append("</table><br>");
                    }
                    return;
                }
            }
            _request.setAttribute("only_osfs_exist", "false");
        } else {
            if (subItemList.size() == 0) {
                if (!grayBackColor) {
                    sGraph
                        .append("<tr><td>")
                        .append(
                            msgResource.getMessage(
                                _request.getLocale(),
                                "RRDGraph.message.NoResources"))
                        .append("</td></tr>")
                        .append("</table><br>");
                    return;
                }
            }
        }
        //check whether sampleInterval is larger than display period
        String message = comSampleIntervalAndDisPeriod(type);
        if (!message.equalsIgnoreCase("no")) {
            //sampleInterval is larger than display period
            _request.setAttribute("msg_big_interval", "1");
            sGraph.append("<tr><td>").append(message).append(
                "</td></tr>").append(
                "</table><br>");
            return;
        }
        //generate graph for each subItem of this target
        int iNumOfShowedGraph = 0;
        Iterator subItemIt = subItemList.iterator();
        while (subItemIt.hasNext()) {
            String subItemID = (String) subItemIt.next();
            /*
             * a) if the watchItem is CPU_States or 3,6,9...graphs have been
             * showed ,start a new line
             */
            if (needAppendMarker(iNumOfShowedGraph, false)) {
                sGraph.append("<tr>");
            } //end of "if"

            /* b)generate html to show graph of this subItem */
            String subitemNo =
                (grayBackColor == true)
                    ? "invalid" + iNumOfShowedGraph
                    : "valid" + iNumOfShowedGraph;
            //keep the image id not same
            String imageName =
                new StringBuffer("target_")
                    .append(targetID)
                    .append("_")
                    .append("subitem_")
                    .append(subitemNo)
                    .toString();
            generateSubItemGraphHtml(
                sGraph,
                targetID,
                subItemID,
                fromDate,
                toDate,
                type,
                max,
                isAuto,
                imageName,
                grayBackColor,
                targetNo,
                subitemNo);
            iNumOfShowedGraph++;
            // count the number of graphs that have been showed
            if (needAppendMarker(iNumOfShowedGraph, false)) {
                sGraph.append("</tr>");
            } //end of "if"

        } //end of "while"

        /*
         * if the last line of the table contains only 1 or 2 graphs and column
         * number is 3 ,then add tabel rear identifier to html
         */
        if (needAppendMarker(iNumOfShowedGraph, true)) {
            sGraph.append("</tr>");
        } //end of "if"

        //add table rear identifier
        sGraph.append("</table><br>");

    } //end of generateGraphHtml()

    private void generateSubItemGraphHtml(
        StringBuffer sGraph,
        String targetID,
        String subItemID,
        String fromDate,
        String toDate,
        String type,
        String max,
        String isAuto,
        String imageName,
        boolean grayBackColor,
        int targetNo,
        String subItemNo)
        throws Exception {
        /*
         * Parameters: targetID: identifier of the target the subitem belongs
         * to.(such as "nas1") subItemID: identifier of the subItem whose graph
         * will be displayed .(such as "cpu0") fromDate: the beginning time of
         * the period toDate: the end time of the period type: Daily , Weekly,
         * ... Function: generate html for displaying the graph of the specified
         * subitem whose identifier is equal to subItemID Called
         * by:generateGraphHtml()
         */

        String watchItem =
            (String) NSActionUtil.getSessionAttribute(
                _request,
                SESSION_WATCHITEM_ID);
        String session_y = "statis_" + watchItem + targetID;
        YInfoBean yInfoBean =
            (YInfoBean) _request.getSession().getAttribute(session_y);

        String mountPointForDisplay = getMountPoint(targetID, subItemID);
        String sCollectionID_CGI =
            StatisActionCommon.URLEncode(wid.getCollectionItem().trim());
        //encoding
        String targetID_CGI = StatisActionCommon.URLEncode(targetID);
        String watchItemID_CGI = StatisActionCommon.URLEncode(watchItemId);
        String sWidth_CGI =
            StatisActionCommon.URLEncode(wid.getGraphSmallWidth().trim());
        String sHeight_CGI =
            StatisActionCommon.URLEncode(wid.getGraphSmallHeight().trim());
        String subItemID_CGI = StatisActionCommon.URLEncode(subItemID);
        String max_CGI = StatisActionCommon.URLEncode(max);
        
        sGraph.append("<td><span title = \"");
        
        String sCollectionID = wid.getCollectionItem().trim();
        if (sCollectionID.equalsIgnoreCase(CollectionItemDef.Anti_Virus_Scan)){
            sGraph.append(getHostname(targetID, subItemID));
        }else{
            sGraph.append(getMountPoint(targetID, subItemID));
        }
        
        sGraph
            .append("\"><a href=\"rrdgraph.do?operation=displayDetail&targetID=")
            .append(targetID)
            .append("&targetNo=")
            .append(targetNo)
            .append("&subWatchItem=")
            .append(subItemID_CGI)
            .append("&defaultGraphType=")
            .append(type)
            .append("&grayBackColor=")
            .append(grayBackColor)
            .append("&subItemNo=")
            .append(subItemNo)
            .append("#")
            .append(type);
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
            .append(watchItemID_CGI);
        String sSampleFlag = rgd.getSamplingFlag().trim();
        String sInterval = rgd.getSamplingInterval().trim();
        String sUnit = rgd.getSamplingUnit().trim();
        int iSampleInterval =
            StatisActionCommon.convertInterval(sInterval, sUnit);
        if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)) {
            sGraph.append("&si=").append(iSampleInterval);
        }
        sGraph.append("&wd=").append(sWidth_CGI).append("&ht=").append(
            sHeight_CGI);

        //        if (type.equalsIgnoreCase(StatisConst.PAGE_NAME_DEFAULT)) {
        //            type = rgd.getDefaultPeriod();
        //        }
        if (type.equalsIgnoreCase(RRDGraphDef.DAILY)) {
            //generate Daily Graph
            sGraph
                .append("&pft=")
                .append(StatisActionCommon.ChangeTime("1", RRDGraphDef.DAYS))
                .append("&ptt=")
                .append(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.WEEKLY)) { //generate
            // Weekly Graph
            sGraph
                .append("&pft=")
                .append(StatisActionCommon.ChangeTime("1", RRDGraphDef.WEEKS))
                .append("&ptt=")
                .append(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.MONTHLY)) { //generate
            // Monthly
            // Graph
            sGraph
                .append("&pft=")
                .append(StatisActionCommon.ChangeTime("1", RRDGraphDef.MONTHS))
                .append("&ptt=")
                .append(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.YEARLY)) { //generate
            // Yearly Graph
            sGraph
                .append("&pft=")
                .append(StatisActionCommon.ChangeTime("1", RRDGraphDef.YEARS))
                .append("&ptt=")
                .append(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.USER_SPEC)) { //generate
            // User
            // Specified
            // Graph
            sGraph =
                sGraph.append("&pft=").append(fromDate).append("&ptt=").append(
                    toDate);
        }
        if (yInfoBean != null
            && !yInfoBean.getDisplaymin().equals("default")) {
            sGraph.append("&min=").append(yInfoBean.getDisplaymin());
        }
        if (isInvestGraph.trim().equals("1")) {
            sGraph.append("&isInvestGraph=1");
        }
        sGraph
            .append("&isAuto=")
            .append(isAuto)
            .append("&ni=")
            .append(targetID_CGI)
            .append("&sbi=")
            .append(subItemID_CGI)
            .append("&ci=")
            .append(sCollectionID_CGI)
            .append("&max=")
            .append(max_CGI)
            .append("&grayBackColor=")
            .append(grayBackColor)
            .append("&id=0\"></a></span></td>");
    } //end of "generateSubItemGraphHtml()"

    private boolean needAppendMarker(int iNumOfShowedGraph, boolean isLastLine)
        throws Exception {
        /*
         * Function: decide whether <tr> or </tr> should be appended to html
         * Parameters: iNumOfShowedGraph---number of graphs that have been
         * showed isLastLine=true: all the graphs have been displayed =false:
         * not all the graphs have been displayed Return Value: true--need
         * append <tr> or </tr> false--needn't append
         */
        if (!isLastLine) {
            return (
                iNumOfShowedGraph % Integer.parseInt(wid.getRRDCols()) == 0);
        } else { //isLastLine==true
            return (
                iNumOfShowedGraph % Integer.parseInt(wid.getRRDCols()) != 0);
        } //end of "if"

    } //end of "needAppendMarker()"

    public String getMaxData(String type, String targetID) throws Exception {
        String max = "0";
        //date[0] is fromDate;date[1] is toDate
        String[] date = getSampleDate(type);
        String maxDefined = wid.getMax();

        String collectionID = wid.getCollectionItem().trim();
        if (maxDefined == null || maxDefined.equals("")) {
            //need to calculate the max data
            int sampleInterval = 0;
            if (rgd.getSamplingFlag().trim().equals(RRDGraphDef.SPECIFIC)) {
                sampleInterval = getSampleInterval();
            }
            String isFilesystem_Quantity="no";
            String fs_isDisplayOs="no";
            String isFilter="no";
            if(collectionID.equalsIgnoreCase(CollectionItemDef.Filesystem_Quantity)){
                isFilesystem_Quantity="yes";
                String filterFlag =
                    (String) NSActionUtil.getSessionAttribute(
                      _request,
                      SESSION_STATIS_FILTER_FLAG);
                if (filterFlag != null && filterFlag.trim().equals("0")) {
                     fs_isDisplayOs="yes";
                  }
            }
            if(isFilesystem_Quantity.equals("yes")&&fs_isDisplayOs.equals("no")){
                isFilter="yes";
            }
            
            if(watchItemId.trim().equals(WatchItemDef.Nvavs_Request)
                || watchItemId.trim().equals(WatchItemDef.Nvavs_TAT)){
                return RRDGraphHandler.getMaxByTarget(
                    targetID,
                    date[0],
                    date[1],
                    sampleInterval,
                    collectionID,
                    watchItemId,
                    isInvestGraph,
                    isFilter,
                    computerName);
            }else{
                return RRDGraphHandler.getMaxByTarget(
                    targetID,
                    date[0],
                    date[1],
                    sampleInterval,
                    collectionID,
                    watchItemId,
                    isInvestGraph,
                    isFilter);
            }
        } else {
            return max;
        }
    }

    private Collection filterFileSystem(Collection subItemList)
        throws Exception {
        String filterFlag =
            (String) NSActionUtil.getSessionAttribute(
                _request,
                SESSION_STATIS_FILTER_FLAG);
        if (filterFlag != null && filterFlag.trim().equals("0")) {
            return subItemList;
        }
        Iterator lvmIt = subItemList.iterator();
        List otherItemList = new ArrayList();
        while (lvmIt.hasNext()) {
            String item = (String) lvmIt.next();
            if (item.startsWith(FILE_SYSTEM_KEY_LD)
                || item.startsWith(FILE_SYSTEM_KEY_HMD)) {
                continue;
            } else {
                otherItemList.add(item);
            }
        }
        return otherItemList;
    }

    private HashMap getVolumeList(String targetID) throws Exception {
        HashMap volumeHash = new HashMap();
        List subItemList = getSubItemList(targetID);
        //move the filter process to generateGraphTable
        //  subItemList = filterFileSystem(subItemList); 
        TreeSet adminVolumeList = new TreeSet();
        TreeSet otherVolumeList = new TreeSet();
       if(RRDGraphHandler.checkStatus().equals("abnormal")){
            for(int i=0;i<subItemList.size();i++){
                adminVolumeList.add(subItemList.get(i));
            }
            volumeHash.put(HASH_KEY_ADMIN_VOLUME_LIST, adminVolumeList);
            volumeHash.put(HASH_KEY_OTHER_VOLUME_LIST, otherVolumeList);
            _request.setAttribute("statis_cluster_status_abnormal", "true");
            return volumeHash;            
        }else{
            _request.setAttribute("statis_cluster_status_abnormal", "false");
        }
        int groupNo = RRDGraphHandler.getGroupNoByTargetID(targetID);
        if (wid
            .getCollectionItem()
            .trim()
            .equalsIgnoreCase(CollectionItemDef.Filesystem)||wid
            .getCollectionItem()
            .trim()
            .equalsIgnoreCase(CollectionItemDef.Filesystem_Quantity)) {
            getFilesystemList(
                targetID,
                subItemList,
                groupNo,
                adminVolumeList,
                otherVolumeList);
        } else {
            getDiskIOList(
                targetID,
                subItemList,
                groupNo,
                adminVolumeList,
                otherVolumeList);
        }
        volumeHash.put(HASH_KEY_ADMIN_VOLUME_LIST, adminVolumeList);
        volumeHash.put(HASH_KEY_OTHER_VOLUME_LIST, otherVolumeList);
        return volumeHash;
    }

    /**
     * @param subItemList
     * @param adminVolumeList
     * @param otherVolumeList
     */
    private void getFilesystemList(
        String targetID,
        List subItemList,
        int groupNo,
        TreeSet adminVolumeList,
        TreeSet otherVolumeList)
        throws Exception {
        Iterator lvmIt = subItemList.iterator();
        List otherItemList = new ArrayList();
        //classes fs on OS
        while (lvmIt.hasNext()) {
            String item = (String) lvmIt.next();
            if (item.startsWith(FILE_SYSTEM_KEY_LD)
                || item.startsWith(FILE_SYSTEM_KEY_HMD)) {
                if (getMountPoint(targetID, item)
                    .equals("/etc/group" + (1 - groupNo) + ".setupinfo")) {
                    otherVolumeList.add(item);
                } else {
                    adminVolumeList.add(item);
                }
            } else {
                otherItemList.add(item);
            }
        }
        //classes fs made by GUI
        getDiskIOList(
            targetID,
            otherItemList,
            groupNo,
            adminVolumeList,
            otherVolumeList);

    }

    private void getDiskIOList(
        String targetID,
        List subItemList,
        int groupNo,
        TreeSet adminVolumeList,
        TreeSet otherVolumeList)
        throws Exception {
        Iterator lvmIt = subItemList.iterator();
        //how to distingue manage node?
        if (NasManager.getInstance().getServerById(targetID).getMyNode()
            == Integer.parseInt(RRDGraphHandler.getAdminNodeNum())) {
            HashSet myLvmSet = RRDGraphHandler.getLvmSetByGroupNo(1 - groupNo);
            while (lvmIt.hasNext()) {
                String item = (String) lvmIt.next();
                if (myLvmSet.contains(item)) {
                    otherVolumeList.add(item);
                } else {
                    adminVolumeList.add(item);
                }
            }
        } else {
            HashSet lvmSet = RRDGraphHandler.getLvmSetByGroupNo(groupNo);
            while (lvmIt.hasNext()) {
                String item = (String) lvmIt.next();
                if (lvmSet.contains(item)) {
                    adminVolumeList.add(item);
                } else {
                    otherVolumeList.add(item);
                }
            }
        }
    }

    private List getSubItemList(String target) throws Exception {
        String collectionItem=wid.getCollectionItem().trim();
        String fileDir=mc.getRRDFilesDir(target,collectionItem);
        rfi = mc.loadRRDFilesInfo(target, collectionItem); 
        List idList=rfi.getIDList();
        String sCollectionID = getCollectionItem();
        List resultList=new ArrayList();
        for(int i=0;i<idList.size();i++){
            String id=(String)idList.get(i);
            String fileName=rfi.get(id).getFName();
            if(sCollectionID.equalsIgnoreCase(CollectionItemDef.Anti_Virus_Scan)){
                if( ! ((String)rfi.get(id).get("ComputerName")).equals(computerName) ){
                    continue;
                }
            }else if(sCollectionID.equalsIgnoreCase(CollectionItemDef.CPU_States)
            		&& ((String)rfi.get(id).getID()).equals("CPU3")
            		&& (SamplingHandler.needDispCpu3().equals("no"))){
            		continue;
            }
            if(isFileExist(fileDir,fileName)){
                resultList.add(id);
            }            
        }
        return resultList;
    }
    private boolean isFileExist(String fileDir,String fileName){
        String file = fileDir + "/"+fileName;
        File f = new File(file);
        if (f.exists()){
            return true; 
        }else{
            return false;
        }
    }
    public String getDetailGraph(
        String targetID,
        String subItemID,
        String grayBackColor)
        throws Exception {
        String watchItem =
            (String) NSActionUtil.getSessionAttribute(
                _request,
                SESSION_WATCHITEM_ID);
        String session_y = "statis_" + watchItem + targetID;
        YInfoBean yInfoBean =
            (YInfoBean) _request.getSession().getAttribute(session_y);

        /*
         * Parameters: targetID: e.g. nas0, nasa, etc. subItemID:e.g.
         * cpu0,/dev/hd0 etc. Return value: Html codes for display detail graph
         * Function: 1) generate html for displaying detail graph 2) when the
         * corresponding small graph is clicked,this function will be called to
         * show detail graph Called by: RRDDetailGraph.jsp
         */

        StringBuffer sDetailGraph = new StringBuffer();

        String sCollectionID_CGI =
            StatisActionCommon.URLEncode(wid.getCollectionItem());
        //encoding
        String targetID_CGI = StatisActionCommon.URLEncode(targetID);

        String watchItemID_CGI = StatisActionCommon.URLEncode(watchItemId);
        String sDetailWidth_CGI =
            StatisActionCommon.URLEncode(wid.getGraphNormalWidth().trim());
        String sDetailHeight_CGI =
            StatisActionCommon.URLEncode(wid.getGraphNormalHeight().trim());
        String sSubItemID_CGI = StatisActionCommon.URLEncode(subItemID);
        
        //get the span info for the Virus Detection
        String sCollectionID = wid.getCollectionItem().trim();
        String spanInfo="";
        if (sCollectionID.equalsIgnoreCase(CollectionItemDef.Anti_Virus_Scan)){
            spanInfo=getHostname(targetID, subItemID);
        }
        
        StringBuffer StrHead =
            new StringBuffer("<span title = \"")
                .append(spanInfo)
                .append("\">")
                .append("<img src=\"")
                .append(NSActionConst.CONFIG_ROOT_PATH)
                .append("/cgi")
                .append("/RRDToolCGI.pl?wi=")
                .append(watchItemID_CGI);
        String sSampleFlag = rgd.getSamplingFlag().trim();
        String sInterval = rgd.getSamplingInterval().trim();
        String sUnit = rgd.getSamplingUnit().trim();
        int iSampleInterval =
            StatisActionCommon.convertInterval(sInterval, sUnit);
        if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)) {
            StrHead.append("&si=").append(iSampleInterval);
        } else {
            iSampleInterval = 0;
        }
        boolean isAuto = false;
        if (yInfoBean != null
            && !yInfoBean.getDisplaymax().equals("default")) {
            StrHead.append("&max=").append(yInfoBean.getDisplaymax());
        } else {
            StrHead.append("&isAuto=1");
            isAuto = true;
        }
        if (yInfoBean != null
            && !yInfoBean.getDisplaymin().equals("default")) {
            StrHead.append("&min=").append(yInfoBean.getDisplaymin());
        }
        if (isInvestGraph.trim().equals("1")) {
            StrHead.append("&isInvestGraph=1");
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
                .append("&id=1\" border=\"1\">")
                .append("</span>");
        long startTime = 0;
        long endTime = 0;
        /*
         * generate html for showing daily detail graph No matter what the value
         * of iStockPeriod is, daily graph will be displayed
         */
        if (isInvestGraph.trim().equals("0")) {
            sDetailGraph
                .append("<h4 class=\"title\"><a name=\"Daily\">")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.daily_graph"))
                .append("</a></h4>");
            if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)
                && iSampleInterval > 24 * 3600) {
                sDetailGraph
                    .append("<table><tr><td>")
                    .append(
                        msgResource.getMessage(
                            _request.getLocale(),
                            "RRDGraph.msg_big_interval"))
                    .append("</td></tr></table><br>");
            } else {
                //No.1 mod daily_graph=>hourly_graph
                startTime =
                    StatisActionCommon.ChangeTime("1", RRDGraphDef.DAYS);
                endTime = StatisActionCommon.CurrentTime();
                sDetailGraph
                    .append(StrHead)
                    .append("&pft=")
                    .append(startTime)
                    .append("&ptt=")
                    .append(endTime);
                //display daily graph
                if (isAuto) {
                    sDetailGraph.append("&max=").append(
                        RRDGraphHandler.getOneRRDMaxByTarget(
                            targetID,
                            Long.toString(startTime),
                            Long.toString(endTime),
                            iSampleInterval,
                            wid.getCollectionItem().trim(),
                            watchItemId,
                            "0",
                            subItemID));
                }
                sDetailGraph.append(StrRear);
            }

            /*
             * generate html for showing weekly detail graph; weekly graph will
             * be showed on condition that iStockPeriod is between 2 and 366
             */
            startTime = StatisActionCommon.ChangeTime("1", RRDGraphDef.WEEKS);
            endTime = StatisActionCommon.CurrentTime();
            sDetailGraph
                .append("<h4 class=\"title\"><a name=\"Weekly\">")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.weekly_graph"))
                .append("</a></h4>")
            //No.1 mod weekly_graph=>daily_graph
            .append(StrHead).append("&pft=").append(startTime).append(
                "&ptt=").append(
                endTime);
            //display weekly graph
            if (isAuto) {
                sDetailGraph.append("&max=").append(
                    RRDGraphHandler.getOneRRDMaxByTarget(
                        targetID,
                        Long.toString(startTime),
                        Long.toString(endTime),
                        iSampleInterval,
                        wid.getCollectionItem().trim(),
                        watchItemId,
                        "0",
                        subItemID));
            }
            sDetailGraph.append(StrRear);
            /*
             * generate html for showing monthly detail graph monthly graph will
             * be showed on condition that iStockPeriod is between 8 and 366
             */
            startTime = StatisActionCommon.ChangeTime("1", RRDGraphDef.MONTHS);
            endTime = StatisActionCommon.CurrentTime();
            sDetailGraph
                .append("<h4 class=\"title\"><a name=\"Monthly\">")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.monthly_graph"))
                .append("</a></h4>")
                .append(StrHead)
                .append("&pft=")
                .append(startTime)
                .append("&ptt=")
                .append(endTime);
            //display monthly graph
            if (isAuto) {
                sDetailGraph.append("&max=").append(
                    RRDGraphHandler.getOneRRDMaxByTarget(
                        targetID,
                        Long.toString(startTime),
                        Long.toString(endTime),
                        iSampleInterval,
                        wid.getCollectionItem().trim(),
                        watchItemId,
                        "0",
                        subItemID));
            }
            sDetailGraph.append(StrRear);
            /*
             * generate html for showing yearly detail graph yearly graph will
             * be showed on condition that iStockPeriod is between 32 and 366
             */
            startTime = StatisActionCommon.ChangeTime("1", RRDGraphDef.YEARS);
            endTime = StatisActionCommon.CurrentTime();
            sDetailGraph
                .append("<h4 class=\"title\"><a name=\"Yearly\">")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.yearly_graph"))
                .append("</a></h4>") //No.1
            // mod
            // yearly_graph=>monthly_graph
            .append(StrHead).append("&pft=").append(startTime).append(
                "&ptt=").append(
                endTime);
            //display yearly graph
            if (isAuto) {
                sDetailGraph.append("&max=").append(
                    RRDGraphHandler.getOneRRDMaxByTarget(
                        targetID,
                        Long.toString(startTime),
                        Long.toString(endTime),
                        iSampleInterval,
                        wid.getCollectionItem().trim(),
                        watchItemId,
                        "0",
                        subItemID));
            }
            sDetailGraph.append(StrRear);
        }

        //convert beginning time and end time
        String fromDate, toDate;
        fromDate = convertDateFrom();
        toDate = convertDateTo();

        /*
         * generate html for displaying userSpec graph No matter what the value
         * of iStockPeriod is, userSpec graph will be displayed
         */

        if (isInvestGraph.trim().equals("0")) {
            sDetailGraph
                .append("<h4 class=\"title\"><a name=\"User Specification\">")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.speci_graph"))
                .append("</a></h4>");

        } else {
            sDetailGraph
                .append("<h4 class=\"title\">")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.invest_graph"))
                .append("</h4>");
        }
        //added by baiwq for (nas 3633) [nas-dev-necas:03122] at 2002.07.17
        if (sSampleFlag.equals(RRDGraphDef.SPECIFIC)
            && (iSampleInterval
                > (Long.parseLong(toDate) - Long.parseLong(fromDate)))) {
            sDetailGraph
                .append("<table><tr><td>")
                .append(
                    msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.msg_big_interval"))
                .append("</td></tr></table><br>");
        } else {
            sDetailGraph
                .append(StrHead)
                .append("&pft=")
                .append(fromDate)
                .append("&ptt=")
                .append(toDate);
            if (isAuto) {
                sDetailGraph.append("&max=").append(
                    RRDGraphHandler.getOneRRDMaxByTarget(
                        targetID,
                        fromDate,
                        toDate,
                        iSampleInterval,
                        wid.getCollectionItem().trim(),
                        watchItemId,
                        isInvestGraph,
                        subItemID));
            }
            sDetailGraph.append(StrRear);
        }
        //display userSpec graph graph

        return sDetailGraph.toString();
    } //end of "getsDetailGraph()"

    public String getMountPoint(String targetID, String subItemID)
        throws Exception {
        String mountPoint = "";
        String sCollectionID = wid.getCollectionItem().trim();
        if (sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem)||sCollectionID.equalsIgnoreCase(CollectionItemDef.Filesystem_Quantity)) {
            //   RRDFilesInfo rfi = mc.loadRRDFilesInfo(targetID, sCollectionID);
            if (rfi == null) {
                rfi =
                    mc.loadRRDFilesInfo(
                        targetID,
                        wid.getCollectionItem().trim());
            }
            RRDFile rf = rfi.get(subItemID);
            mountPoint = rf.get(XML_ELEMENT_MOUNT_POINT);
        }
        return mountPoint;
    }
    
    //get host name of the nvavs's subitem
    private String getHostname(String targetID, String subItemID)
        throws Exception {
        String hostname = "";
        if (rfi == null) {
            rfi = mc.loadRRDFilesInfo(targetID,wid.getCollectionItem().trim());
        }
        RRDFile rf = rfi.get(subItemID);
        hostname = rf.get("Host");
        return hostname;
    }
    /**
     * @return
     */
    public HttpServletRequest get_request() {
        return _request;
    }

    /**
     * @return
     */
    public MonitorConfigBase getMc() {
        return mc;
    }

    /**
     * @return
     */
    public RRDGraphDef getRgd() {
        return rgd;
    }

    /**
     * @return
     */
    public String getTargetId() {
        return targetId;
    }

    /**
     * @return
     */
    public String getWatchItemId() {
        return watchItemId;
    }

    /**
     * @return
     */
    public WatchItemDef getWid() {
        return wid;
    }

    /**
     * @param request
     */
    public void set_request(HttpServletRequest request) {
        _request = request;
    }

    /**
     * @param config
     */
    public void setMc(MonitorConfigBase config) {
        mc = config;
    }

    /**
     * @param def
     */
    public void setRgd(RRDGraphDef def) {
        rgd = def;
    }

    /**
     * @param string
     */
    public void setTargetId(String string) {
        targetId = string;
    }

    /**
     * @param string
     */
    public void setWatchItemId(String string) {
        watchItemId = string;
    }

    /**
     * @param def
     */
    public void setWid(WatchItemDef def) {
        wid = def;
    }

    /**
     * nasswitch function as follows
     */

}