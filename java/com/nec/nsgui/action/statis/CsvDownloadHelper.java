/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.util.LabelValueBean;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.statis.CsvDownloadHandler;
import com.nec.nsgui.model.biz.statis.DisplayInfos;
import com.nec.nsgui.model.biz.statis.MonitorConfig3;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
import com.nec.nsgui.model.entity.statis.CsvDownloadCmdOpts;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.entity.statis.CsvDownloadOption;
import com.nec.nsgui.model.entity.statis.CsvDownloadUtil;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;
import com.nec.nsgui.model.entity.statis.SamplingConf;
import com.nec.nsgui.model.entity.statis.StatisConst;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;

/**
 *
 */
public class CsvDownloadHelper implements StatisActionConst, StatisConst {
    private static final String cvsid =
        "@(#) $Id: CsvDownloadHelper.java,v 1.6 2008/05/19 10:15:17 zhangjun Exp $";
    static String[] prepareItemList(
        MonitorConfigBase mc,
        String originalWatchItemID) {

        DisplayInfos dis =
            mc.getWatchItemDef(originalWatchItemID).getDisplayInfos();
        List tmpList = dis.getIDList();
        String[] itemList = new String[tmpList.size()];
        for (int i = 0; i < tmpList.size(); i++) {
            itemList[i] = dis.get((String) tmpList.get(i)).getDesc();
        }
        return itemList;
    }

    static String[] prepareItemList4NSW(
        MonitorConfig3 mc,
        String collectionItemId) {
        String[] itemList = new String[3];
        String[] watchItemList =
            NasSwitchAssistant.getWatchItemId(collectionItemId);
        for (int j = 0; j < watchItemList.length; j++) {
            String originalWatchItemID = watchItemList[j];
            DisplayInfos dis =
                mc.getWatchItemDef(originalWatchItemID).getDisplayInfos();
            List tmpList = dis.getIDList();
            itemList[j] = dis.get((String) tmpList.get(0)).getDesc();
        }
        return itemList;
    }

    static String prepareResources(
        Vector resourceList,
        String defaultResource,
        String originalWatchItemID) {
        for (int i = 0; i < resourceList.size(); i++) {
            String tempResourceInfo = (String) resourceList.get(i);
            if (originalWatchItemID.equals(WatchItemDef.Nvavs_Request) || originalWatchItemID.equals(WatchItemDef.Nvavs_TAT)){
            	int index = tempResourceInfo.indexOf("#");
            	resourceList.set(i,new LabelValueBean(tempResourceInfo.substring(index+1),tempResourceInfo));
            }else{
	            if (originalWatchItemID.equals(WatchItemDef.Disk_Used_Rate)
	                || originalWatchItemID.equals(WatchItemDef.Inode_Used_Rate)
	                ||originalWatchItemID.equals(WatchItemDef.Disk_Used_Quantity)
	                ||originalWatchItemID.equals(WatchItemDef.Inode_Used_Quantity)) {
	                tempResourceInfo =
	                    CsvDownloadHelper.getNetMountPoint(tempResourceInfo);
	                if (tempResourceInfo.startsWith(defaultResource + " ")) {
	                    defaultResource = tempResourceInfo;
	                }
	            }
	            resourceList.set(
	                i,
	                new LabelValueBean(tempResourceInfo, tempResourceInfo));
	        }
        }
        return defaultResource;
    }

    static void prepareOptions(Vector resourceList) {
        for (int i = 0; i < resourceList.size(); i++) {
            String tempResourceInfo = (String) resourceList.get(i);
            resourceList.set(
                i,
                new LabelValueBean(tempResourceInfo, tempResourceInfo));
        }
    }

    public static String getNetMountPoint(String i_resourceInfo) {
        String[] resourceInfo = i_resourceInfo.split("\\s+");
        String mountPoint = resourceInfo[1];
        if (mountPoint.length() > 37) {
            mountPoint = mountPoint.substring(0, 33) + "...)";
        }
        return resourceInfo[0] + " " + mountPoint;
    }

    static String correctDefaultPeriod(
        String defaultPeriod,
        String periodType,
        HttpServletRequest request)
        throws Exception {
        if (defaultPeriod.equals(RRDGraphDef.DAILY)
            || defaultPeriod.equals(RRDGraphDef.USER_SPEC)) {
            return defaultPeriod;
        }
        if (defaultPeriod.equals(RRDGraphDef.WEEKLY)) {
            if (periodType == Integer.toString(PERIOD_WITHIN_DAY)) {
                return RRDGraphDef.DAILY;
            }
        }
        if (defaultPeriod.equals(RRDGraphDef.MONTHLY)) {
            if (periodType == Integer.toString(PERIOD_WITHIN_DAY)
                || periodType == Integer.toString(PERIOD_WITHIN_WEEK)) {
                return RRDGraphDef.DAILY;
            }
        }
        if (defaultPeriod.equals(RRDGraphDef.YEARLY)) {
            if (periodType == Integer.toString(PERIOD_WITHIN_DAY)
                || periodType == Integer.toString(PERIOD_WITHIN_WEEK)
                || periodType == Integer.toString(PERIOD_WITHIN_MONTH)) {
                return RRDGraphDef.DAILY;
            }
        }
        return defaultPeriod;
    }

    public static Vector preparePeriodOption(
        int periodType,
        MessageResources mr,
        Locale locale) {
        Vector options = new Vector();
        options.add(
            new LabelValueBean(
                mr.getMessage(locale, "csvdownload.option_hourly"),
                StatisConst.PAGE_NAME_DAILY));

        if (periodType == PERIOD_WITHIN_WEEK) {
            options.add(
                new LabelValueBean(
                    mr.getMessage(locale, "csvdownload.option_daily"),
                    StatisConst.PAGE_NAME_WEEKLY));

        } else if (periodType == PERIOD_WITHIN_MONTH) {
            options.add(
                new LabelValueBean(
                    mr.getMessage(locale, "csvdownload.option_daily"),
                    StatisConst.PAGE_NAME_WEEKLY));
            options.add(
                new LabelValueBean(
                    mr.getMessage(locale, "csvdownload.option_weekly"),
                    StatisConst.PAGE_NAME_MONTHLY));
        } else if (periodType == PERIOD_WITHIN_YEAR) {
            options.add(
                new LabelValueBean(
                    mr.getMessage(locale, "csvdownload.option_daily"),
                    StatisConst.PAGE_NAME_WEEKLY));
            options.add(
                new LabelValueBean(
                    mr.getMessage(locale, "csvdownload.option_weekly"),
                    StatisConst.PAGE_NAME_MONTHLY));
            options.add(
                new LabelValueBean(
                    mr.getMessage(locale, "csvdownload.option_monthly"),
                    RRDGraphDef.YEARLY));

        }
        options.add(
            new LabelValueBean(
                mr.getMessage(locale, "csvdownload.option_custom"),
                RRDGraphDef.USER_SPEC));

        return options;
    }

    public static String processPreviousDownload(HttpServletRequest request)
        throws Exception {
        String downloadWinKey = request.getParameter("downloadWinKey");
        /*if (downloadWinKey == null) {
            return "false";
        }*/
        HttpSession session = request.getSession();
        String waitSign =
            (String) SyncDownloadSession.getInfoHashFromSession(
                session,
                STATIS_DOWNLOAD_END_WAIT,
                downloadWinKey);
        if (waitSign != null) {
            if (waitSign.equals("")) {
                return "true";
            } else {
                SyncDownloadSession.removeHashInfoFromSession(
                    session,
                    STATIS_DOWNLOAD_END_WAIT,
                    downloadWinKey);
            }
        }
        return "false";

    }

    public static String makeResourceOption(
        String originalWatchItemID,
        String allOrSelectedRadio,
        String[] selectedResources) {
        StringBuffer resourceOption = new StringBuffer("");
        if (allOrSelectedRadio.equals(PAGE_RADIO_VALUE_ALL)) {
        } else {
            for (int i = 0; i < selectedResources.length; i++) {
                String tmpResource = selectedResources[i];
                if (originalWatchItemID.equals(WatchItemDef.Disk_Used_Rate)
                    || originalWatchItemID.equals(WatchItemDef.Inode_Used_Rate)
                    ||originalWatchItemID.equals(WatchItemDef.Disk_Used_Quantity)
                    ||originalWatchItemID.equals(WatchItemDef.Inode_Used_Quantity)) {
                    tmpResource = (tmpResource.split("\\s+"))[0];
                }
                resourceOption.append(tmpResource).append(OPTION_SEPERATOR);
            }
        }
        return resourceOption.toString();
    }

    public static HashMap makeTimeOption(
        HttpServletRequest request,
        CsvDownloadInfoBean downloadInfo)
        throws Exception {
        // String period =
        //     convertDefaultPeriod(downloadInfo.getDefaultPeriod(), request);
        String period = downloadInfo.getDefaultPeriod();
        HashMap timeOption = new HashMap();
        if (period.equals(RRDGraphDef.DAILY)) {
            timeOption.put("startTimeOption", STARTTIME_OPTION_RELATIVE_DAY);
            timeOption.put("endTimeOption", RRD2CSV_END_TIME_OPT_NOW);
        } else if (period.equals(RRDGraphDef.WEEKLY)) {
            timeOption.put("startTimeOption", STARTTIME_OPTION_RELATIVE_WEEK);
            timeOption.put("endTimeOption", RRD2CSV_END_TIME_OPT_NOW);
        } else if (period.equals(RRDGraphDef.MONTHLY)) {
            timeOption.put("startTimeOption", STARTTIME_OPTION_RELATIVE_MONTH);
            timeOption.put("endTimeOption", RRD2CSV_END_TIME_OPT_NOW);
        } else if (period.equals(RRDGraphDef.YEARLY)) {
            timeOption.put("startTimeOption", STARTTIME_OPTION_RELATIVE_YEAR);
            timeOption.put("endTimeOption", RRD2CSV_END_TIME_OPT_NOW);
        } else if (period.equals(RRDGraphDef.USER_SPEC)) {
            timeOption.put(
                "startTimeOption",
                downloadInfo.getCustomStartTime());
            timeOption.put("endTimeOption", downloadInfo.getCustomEndTime());
        } else {
            CsvDownloadUtil.makeNSException(
                CsvDownloadHelper.class,
                CsvDownloadAction.ERROR_MSG_INVALID_PERIOD,
                null,
                NSReporter.FATAL);
        }
        return timeOption;
    }

    public static String makeItemsOption(
        String[] selectedItems,
        DisplayInfos dis) {

        List tmpList = dis.getIDList();
        HashMap displayInfoHash = new HashMap();
        for (int i = 0; i < tmpList.size(); i++) {
            displayInfoHash.put(
                dis.get((String) tmpList.get(i)).getDesc(),
                (String) tmpList.get(i));
        }
        return makeItemsOptionStr(selectedItems, displayInfoHash);
    }
    public static String makeItemsOption4NSW(
        String[] selectedItems,
        String collectionItemId,
        MonitorConfig3 mc) {
        String[] itemList = new String[3];
        String[] watchItemList =
            NasSwitchAssistant.getWatchItemId(collectionItemId);
        HashMap displayInfoHash = new HashMap();
        for (int j = 0; j < watchItemList.length; j++) {
            String originalWatchItemID = watchItemList[j];
            DisplayInfos dis =
                mc.getWatchItemDef(originalWatchItemID).getDisplayInfos();
            List tmpList = dis.getIDList();
            displayInfoHash.put(
                dis.get((String) tmpList.get(0)).getDesc(),
                (String) tmpList.get(0));
        }
        return makeItemsOptionStr(selectedItems, displayInfoHash);
    }

    private static String makeItemsOptionStr(
        String[] selectedItems,
        HashMap displayInfoHash) {
        //change selected items to item option
        StringBuffer itemsOption = new StringBuffer();
        for (int i = 0; i < selectedItems.length; i++) {
            itemsOption.append(
                (String) displayInfoHash.get(selectedItems[i])).append(
                CsvDownloadHelper.OPTION_SEPERATOR);
        }
        return itemsOption.toString();
    }

    public static CsvDownloadCmdOpts makeCsvdownloadCmdOpts(
        HttpServletRequest request,
        CsvDownloadInfoBean downloadInfo,
        CsvDownloadOption downloadOption)
        throws Exception {
        String originalWatchItemID = downloadInfo.getOriginalWatchItemID();

        // change the period to start time and end time
        HashMap timeOption = makeTimeOption(request, downloadInfo);

        //make items option 
        MonitorConfigBase mc =
            (MonitorConfigBase) request.getSession().getAttribute(
                StatisActionConst.SESSION_MC);
        String version = "1";
        if (downloadInfo.getIsSurvey().equals("true")) {
            mc =
                (MonitorConfigBase) request.getSession().getAttribute(
                    StatisActionConst.SESSION_MC_4SURVEY);
            version = "2";
        } 
        DisplayInfos dis =
            mc.getWatchItemDef(originalWatchItemID).getDisplayInfos();
        String itemsOption = makeItemsOption(downloadOption.getItemList(), dis);

        //make resource option
        String resourceOption =
            makeResourceOption(
                originalWatchItemID,
                downloadOption.getAllOrSelected(),
                downloadOption.getSelectedResources());

        //change selected filesystem radio to mountpoint option
        String useMountpointOption =
            makeUseMountpointOption(
                downloadOption.getDisplayFSType(),
                originalWatchItemID);

        //make infotype
        String infotype =
            CsvDownloadUtil.changeWatchItem2Infotype(originalWatchItemID);

        //construct CsvDownloadCmdOpts
        CsvDownloadCmdOpts opts = new CsvDownloadCmdOpts();
        opts.setHost(downloadInfo.getHost());
        opts.setInfotype(infotype);
        opts.setStartTimeOption((String) timeOption.get("startTimeOption"));
        opts.setEndTimeOption((String) timeOption.get("endTimeOption"));
        opts.setResourceOption(resourceOption);
        opts.setItemsOption(itemsOption);
        opts.setUseMountpointOption(useMountpointOption);
        opts.setVersion(version);
        opts.setCpName(downloadInfo.getCpName());
        return opts;
    }

    public static CsvDownloadCmdOpts makeCsvdownloadCmdOpts4NSW(
        HttpServletRequest request,
        CsvDownloadInfoBean downloadInfo,
        CsvDownloadOption downloadOption)
        throws Exception {
        String collectionItemId = downloadInfo.getCollectionItemId();

        // change the period to start time and end time
        HashMap timeOption = makeTimeOption(request, downloadInfo);

        //make items option 
        MonitorConfig3 mc =
            (MonitorConfig3) request.getSession().getAttribute(
                StatisActionConst.SESSION_MC);

        String itemsOption =
            makeItemsOption4NSW(
                downloadOption.getItemList(),
                collectionItemId,
                mc);

        //make resource option
        String resourceOption =
            makeResourceOption(
                "",
                downloadOption.getAllOrSelected(),
                downloadOption.getSelectedResources());

        //change selected filesystem radio to mountpoint option
        String useMountpointOption =
            makeUseMountpointOption(downloadOption.getDisplayFSType(), "");

        //make infotype
        String infotype =
            CsvDownloadUtil.changeCollectionItem2Infotype(collectionItemId);

        //construct CsvDownloadCmdOpts
        CsvDownloadCmdOpts opts = new CsvDownloadCmdOpts();
        opts.setHost(downloadInfo.getHost());
        opts.setInfotype(infotype);
        opts.setStartTimeOption((String) timeOption.get("startTimeOption"));
        opts.setEndTimeOption((String) timeOption.get("endTimeOption"));
        opts.setResourceOption(resourceOption);
        opts.setItemsOption(itemsOption);
        opts.setUseMountpointOption(useMountpointOption);
        opts.setVersion("3");
        return opts;
    }

    private static String makeUseMountpointOption(
        String displayFSType,
        String originalWatchItemID) {
        String useMountpointOption = "0";
        if (originalWatchItemID.equals(WatchItemDef.Disk_Used_Rate)
            || originalWatchItemID.equals(WatchItemDef.Inode_Used_Rate)
            ||originalWatchItemID.equals(WatchItemDef.Disk_Used_Quantity)
            ||originalWatchItemID.equals(WatchItemDef.Inode_Used_Quantity)) {
            if (displayFSType.equals(PAGE_RADIO_VALUE_MOUNTPOINT)) {
                useMountpointOption = "1";
            }
        }
        return useMountpointOption;
    }

    public static void processDownload(
        HttpServletRequest request,
        MessageResources msgResource,
        CsvDownloadInfoBean downloadInfo,
        CsvDownloadOption downloadOption)
        throws Exception {
        CsvDownloadCmdOpts opts =
            CsvDownloadHelper.makeCsvdownloadCmdOpts(
                request,
                downloadInfo,
                downloadOption);
        NSCmdResult result = CsvDownloadHandler.downloadCsv(opts);
        int exitNo = result.getExitValue();
        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            "csvdownload failed:" + exitNo);
        if (exitNo == CSV_DOWNLOAD_PERL_SCRIPT_EXEC_SUCCEED) {
            request.setAttribute("tmpCsvFilename", result.getStdout()[0]);
        } else if (exitNo == ERROR_CODE_DOWNLOAD_DISK_SPACE_NOT_ENOUGH) {
            NSException ne = new NSException(
                    Class.forName("com.nec.nsgui.action.statis.CsvDownloadHelper"));
            StringBuffer errorStr = new StringBuffer("There is a possibility that there is not enough space of the partition of work.\n");
            ne.setDetail(errorStr);
            ne.setErrorCode("0x12800007");
            NSReporter.getInstance().report(ne);
            throw ne;
        } else {
            NSException ne = new NSException(
                    Class.forName("com.nec.nsgui.action.statis.CsvDownloadHelper"));
            StringBuffer errorStr = new StringBuffer("Failed to read the graph data for download.\n");
            ne.setDetail(errorStr);
            ne.setErrorCode("0x12800008");
            NSReporter.getInstance().report(ne);
            throw ne;
        }
    }
    public static void processDownload4NSW(
        HttpServletRequest request,
        MessageResources msgResource,
        CsvDownloadInfoBean downloadInfo,
        CsvDownloadOption downloadOption)
        throws Exception {
        CsvDownloadCmdOpts opts =
            CsvDownloadHelper.makeCsvdownloadCmdOpts4NSW(
                request,
                downloadInfo,
                downloadOption);

        NSCmdResult result = CsvDownloadHandler.downloadCsv(opts);
        int exitNo = result.getExitValue();
        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            "csvdownload failed:" + exitNo);
        if (exitNo == CSV_DOWNLOAD_PERL_SCRIPT_EXEC_SUCCEED) {
            request.setAttribute("tmpCsvFilename", result.getStdout()[0]);
        } else if (exitNo == ERROR_CODE_DOWNLOAD_DISK_SPACE_NOT_ENOUGH) {
            request.setAttribute(
                "downloadErrMsgKey",
                "csvdownload.alert.no_space");

        } else {
            request.setAttribute(
                "downloadErrMsgKey",
                "csvdownload.alert.get_data_failed");
        }
    }
    public static final String OPTION_SEPERATOR = ",";

    public static final String PAGE_RADIO_VALUE_ALL = "all";

    public static final String PAGE_RADIO_VALUE_MOUNTPOINT = "mountpoint";

    public static int getPeriodNeedShow(int iStockPeriod) throws Exception {
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

    /**
     * @param request
     * @param collectionItemId
     * @param downloadInfo
     * @param downloadOption
     */
    public static Vector getAllCheckItems(
        HttpServletRequest request,
        CsvDownloadInfoBean downloadInfo,
        CsvDownloadOption downloadOption)
        throws Exception {
        Vector checked = new Vector();
        String[] selectedResouceList =
            request.getParameterValues("subItemCheckbox");
        String defaultResource = downloadInfo.getDefaultResource();
        ListSTModel listSTModel =
            (ListSTModel) NSActionUtil.getSessionAttribute(
                request,
                SESSION_STATIS_NASSWITCH_TABLE_MODE);
        List subItemList = listSTModel.getDataList();
        List checkedListForSession = new ArrayList();

        if (!defaultResource.equals("") || selectedResouceList != null) {
            //come from detail page or resource list page
            if (selectedResouceList == null) {
                String[] tmp = { defaultResource };
                selectedResouceList = tmp;
            }
            for (int i = 0; i < subItemList.size(); i++) {
                NasSwitchSubItemInfoBean subItemInfo =
                    (NasSwitchSubItemInfoBean) subItemList.get(i);
                int sequence = subItemInfo.getSequence();
                for (int j = 0; j < selectedResouceList.length; j++) {
                    if (sequence == Integer.parseInt(selectedResouceList[j])) {
                        checked.add(subItemInfo.getSubItem());
                        checkedListForSession.add(subItemInfo);
                        continue;
                    }
                }
            }
            if (defaultResource.equals("")) {
                NSActionUtil.setSessionAttribute(
                    request,
                    SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED,
                    checkedListForSession);
            }
        } else { //come from graph list page
            subItemList =
                (List) NSActionUtil.getSessionAttribute(
                    request,
                    SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED);
            for (int i = 0; i < subItemList.size(); i++) {
                NasSwitchSubItemInfoBean subItemInfo =
                    (NasSwitchSubItemInfoBean) subItemList.get(i);
                checked.add(subItemInfo.getSubItem());
            }
        }
        return checked;
    }

    private static String getMinValue(String a, String b) {
        return (Integer.parseInt(a) > Integer.parseInt(b)) ? b : a;
    }
    private static String getMaxValue(String a, String b) {
        return (Integer.parseInt(a) > Integer.parseInt(b)) ? a : b;
    }

    /**
     * @param samplingConfs
     * @param checkedList
     * @return
     */
    public static String getDefaultInterval(
        Map samplingConfs,
        Vector checkedList)
        throws Exception {
        String minInterval = Integer.toString(INTERVAL_UPPER_LIMIT);
        boolean hasInterval = false;
        for (int i = 0; i < checkedList.size(); i++) {
            SamplingConf sc =
                (SamplingConf) samplingConfs.get(checkedList.get(i));
            if (sc != null) {
                minInterval = getMinValue(minInterval, sc.getInterval());
                hasInterval = true;
            }
        }
        if (!hasInterval) {
            return "";
        }
        return minInterval;
    }

    /**
     * @param samplingConfs
     * @param resourceList
     * @return
     */
    public static Vector getIntervalList(
        Map samplingConfs,
        Vector resourceList)
        throws Exception {
        Vector result = new Vector();
        for (int i = 0; i < resourceList.size(); i++) {
            SamplingConf sc =
                (SamplingConf) samplingConfs.get(resourceList.get(i));
            if (sc != null && !result.contains(sc.getInterval())) {
                result.add(sc.getInterval());
            }
        }
        return result;
    }

    /**
     * @param samplingConfs
     * @param resourceList
     */
    public static Vector getResouceList(
        Map samplingConfs,
        Vector resourceList,
        String defaultInterval)
        throws Exception {
        Vector result = new Vector();
        for (int i = 0; i < resourceList.size(); i++) {
            SamplingConf sc =
                (SamplingConf) samplingConfs.get(resourceList.get(i));
            if (sc != null
                && defaultInterval.trim().equals(sc.getInterval().trim())) {
                result.add(resourceList.get(i));
            }
        }
        return result;
    }

    /**
     * @param request
     * @param mr
     * @param samplingConfs
     * @param resourceList
     * @return
     */
    public static int getPeriodNeedShow(Map samplingConfs, Vector resourceList)
        throws NumberFormatException, Exception {
        String maxPeriod = Integer.toString(STOCK_PERIOD_LOWER_LIMIT);

        for (int i = 0; i < resourceList.size(); i++) {
            SamplingConf sc =
                (SamplingConf) samplingConfs.get(resourceList.get(i));
            if (sc != null) {
                maxPeriod = getMaxValue(maxPeriod, sc.getPeriod());
            }
        }
        return getPeriodNeedShow(Integer.parseInt(maxPeriod));
    }

    /**
     * @param request
     * @param checkedList
     * @param resourceList
     * @param downloadOption
     */
    public static void setSelectedResource(
        Vector checkedList,
        Vector resourceList,
        CsvDownloadOption downloadOption) {
        Vector selected = new Vector();
        String radioValue = "all";
        for (int i = 0; i < checkedList.size(); i++) {
            if (resourceList.contains(checkedList.get(i))) {
                selected.add(checkedList.get(i));
                radioValue = "specific";
            }
        }
        downloadOption.setAllOrSelected(radioValue);
        downloadOption.setSelectedResources(
            (String[]) selected.toArray(new String[0]));
    }

    /**
     * @param intervalList
     */
    public static void prepareIntervalOptions(Vector intervalList) {
        Collections.sort(intervalList, new Comparator() {
            public int compare(Object a, Object b) {
                return Integer.parseInt((String) a)
                    - Integer.parseInt((String) b);
            }
        });
        for (int i = 0; i < intervalList.size(); i++) {
            String tempResourceInfo = (String) intervalList.get(i);
            intervalList.set(
                i,
                new LabelValueBean(
                    Integer.toString(Integer.parseInt(tempResourceInfo) / 60),
                    tempResourceInfo));
        }

    }

    //    private static void tester(String message) throws Exception{
    //            String[] cmd = {"/home/nsadmin/test.pl",message};
    //            CmdExecBase.localExecCmd(cmd, null, false);    
    //        }
}
