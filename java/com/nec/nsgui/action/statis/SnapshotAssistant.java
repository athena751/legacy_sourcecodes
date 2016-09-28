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
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.SnapshotGraphDef;
import com.nec.nsgui.model.biz.statis.SnapshotHandler;
import com.nec.nsgui.model.biz.statis.TargetDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
import com.nec.nsgui.model.entity.statis.ChartInfoBean;
import com.nec.nsgui.model.entity.statis.DeviceInfoBean;

/**
 *
 */
public class SnapshotAssistant
    extends GraphAssistantBase
    implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: SnapshotAssistant.java,v 1.2 2005/10/20 14:23:43 zhangj Exp $";
    private SnapshotGraphDef sgd;
    private String sSnapshotType;
    private String sFullWidth;
    private String sHeight;

    public void init(HttpServletRequest request) {
        super.init(request);
        sgd =
            (SnapshotGraphDef) NSActionUtil.getSessionAttribute(
                request,
                SESSION_SGD);
        sSnapshotType = sgd.getType().trim();
        sFullWidth = sgd.getGraphWidth(sSnapshotType).trim();
        sHeight = sgd.getGraphHeight(sSnapshotType).trim();
    }
    public String getWatchItemKey() {
        return "statis.snapshot.h1." + wid.getID().trim();
    }
    public String getWatchItemId() {
        return watchItemId;
    }
    public String getSFullWidth() {
        return sFullWidth;
    }
    public String getSHeight() {
        return sHeight;
    }
    public String getSSnapshotType() {
        return sSnapshotType;
    }
    public HashMap loadOneDevice(String targetID, String deviceID)
        throws Exception {
        return SnapshotHandler.getOneDevice(watchItemId, targetID, deviceID);
    }
    //Generate html code in the page
    public List getGraphInfoList(
        String graphType,
        String [] sortBy,
        String [] order)
        throws Exception {
        List graphInfoList = new ArrayList();
        List targetList = getTargetList();
        int targetListSize = targetList.size();
        for (int i = 0; i < targetListSize; i++) {
            ChartInfoBean cInfo = new ChartInfoBean();
            String tempTargetId = (String) targetList.get(i);
            TargetDef tDef = mc.getTargetDef(tempTargetId);
            cInfo.setTargetId(tempTargetId);
            cInfo.setNickName(tDef.getNickName());
            HashMap deviceListResult =
                SnapshotHandler.getDeviceList(watchItemId, tempTargetId);
            String returnValue = (String) deviceListResult.get("exitValue");
            cInfo.setReturnValue(returnValue);
            if (returnValue.equals("0")) {
                ArrayList deviceList =
                    (ArrayList) deviceListResult.get("deviceList");
                deviceList = OSInfoFilter(deviceList);
                double lMaxTotal = getLMaxOfDevices(deviceList);
                sort(deviceList, sortBy[i], order[i]);
                if (graphType.equals("Pie")) {
                    cInfo.setGraphTableHtml(
                        generatePieHtml(deviceList, tempTargetId, i));
                } else {
                    cInfo.setGraphTableHtml(
                        generateBarHtml(deviceList, lMaxTotal));
                }
            }
            graphInfoList.add(cInfo);
        }
        return graphInfoList;
    }
    private double getLMaxOfDevices(ArrayList deviceList){
        double lMaxOfDevices = 0;
        for( int i=0; i<deviceList.size(); i++){
            DeviceInfoBean di = (DeviceInfoBean) deviceList.get(i);
            if (di.getTotal() > lMaxOfDevices) {
                lMaxOfDevices = di.getTotal();
            }
        }
        return lMaxOfDevices;
    }
    private ArrayList OSInfoFilter(ArrayList deviceList) {
        String displayOSInfo =
            (String) _request.getSession().getAttribute(
                SESSION_DISPLAY_OS_INFO);
        if (displayOSInfo == null || displayOSInfo.equals("false")) {
            ArrayList newDevList = new ArrayList();
            for (int j = 0; j < deviceList.size(); j++) {
                DeviceInfoBean devInfo =
                    (DeviceInfoBean) deviceList.get(j);
                if (!devInfo.getSDevice()
                    .startsWith(FILE_SYSTEM_KEY_HMD)
                    && !devInfo.getSDevice().startsWith(
                        FILE_SYSTEM_KEY_LD)){
                            newDevList.add(devInfo);    
                    }
            }
            deviceList = newDevList;        
        }
        return deviceList;
    }

    //All function below here are private function
    private void sort(ArrayList deviceList, String key, String order)
        throws Exception {
        class deviceCompare implements Comparator {
            String order = "true";
            String key = MOUNT_POINT;
            public deviceCompare(String key, String order) {
                this.order = order;
                this.key = key;
            }
            private int compareDir(String s1, String s2) {
                String[] sa1 = s1.split("/");
                String[] sa2 = s2.split("/");
                int len = sa1.length < sa2.length ? sa1.length : sa2.length;
                for (int i = 0; i < len; i++) {
                    int ret = sa1[i].compareTo(sa2[i]);
                    if (ret != 0) {
                        return ret;
                    }
                }
                return sa1.length - sa2.length;
            }
            public int compare(Object a, Object b) {
                int ret = 0;
                if (key.equalsIgnoreCase(MOUNT_POINT)) {
                    ret =
                        compareDir(
                            ((DeviceInfoBean) a).getSMountPoint(),
                            ((DeviceInfoBean) b).getSMountPoint());
                } else if (key.equalsIgnoreCase(USE)) {
                    ret =
                        new Double(
                            ((DeviceInfoBean) a).getUsedRate()).compareTo(
                            new Double(((DeviceInfoBean) b).getUsedRate()));
                } else if (key.equalsIgnoreCase(TOTAL)) {
                    ret =
                        new Double(((DeviceInfoBean) a).getTotal()).compareTo(
                            new Double(((DeviceInfoBean) b).getTotal()));
                } else if (key.equalsIgnoreCase(USED)) {
                    ret =
                        new Double(((DeviceInfoBean) a).getUsed()).compareTo(
                            new Double(((DeviceInfoBean) b).getUsed()));
                } else if (key.equalsIgnoreCase(AVAILABLE)) {
                    ret =
                        new Double(
                            ((DeviceInfoBean) a).getAvailable()).compareTo(
                            new Double(((DeviceInfoBean) b).getAvailable()));
                } else if (key.equalsIgnoreCase(TYPE)) {
                    ret =
                        ((DeviceInfoBean) a).getSType().compareTo(
                            ((DeviceInfoBean) b).getSType());
                } else if (key.equalsIgnoreCase(DEVICE)) {
                    ret =
                        compareDir(
                            ((DeviceInfoBean) a).getSDevice(),
                            ((DeviceInfoBean) b).getSDevice());
                }
                return order.equals("true") ? ret : (-ret);
            }
        }
        Collections.sort(deviceList, new deviceCompare(key, order));
    }

    private String generatePieHtml(
        ArrayList deviceList,
        String sTargetID,
        int index)
        throws Exception {
        StringBuffer sPieGraphHtml = new StringBuffer();
        String arrayFlag = null;
        int size = deviceList.size();
        if (size != 0) {
            sPieGraphHtml = sPieGraphHtml.append("<table border=\"0\">");
            if (watchItemId.equals(WatchItemDef.Disk_Used_Rate)) {
                arrayFlag = "data";
            } else {
                arrayFlag = "file";
            }
            for (int i = 0; i < size; i++) {
                DeviceInfoBean deviceRec = (DeviceInfoBean) deviceList.get(i);
                String ID = sTargetID + ":" + deviceRec.getSDevice();
                String winName =
                    "statis_snapshot_" + arrayFlag + index + "_" + i;
                if (i % PIE_CHART_COLUMNS == 0) {
                    sPieGraphHtml.append("<tr>");
                }
                sPieGraphHtml
                    .append("<td><span title=\"")
                    .append(deviceRec.getSMountPoint())
                    .append("\"><a href=\"#\" onclick='")
                    .append("createWin(\"")
                    .append(arrayFlag)
                    .append("\",\"")
                    .append(winName)
                    .append("\",\"")
                    .append(ID)
                    .append("\");return false;'>")
                    .append("<img src=\"")
                    .append(NSActionConst.CONFIG_ROOT_PATH)
                    .append("/cgi")
                    .append("/GDPieCGI.pl?us=")
                    .append(deviceRec.getUsedRate())
                    .append("&wd=")
                    .append(sFullWidth)
                    .append("&ht=")
                    .append(sHeight)
                    .append("&id=0\" border=\"1\"></a></span></td>");
                if ((i + 1) % PIE_CHART_COLUMNS == 0) {
                    sPieGraphHtml.append("</tr>");
                }
            }
            if ((size % PIE_CHART_COLUMNS) != 0) {
                sPieGraphHtml.append("</tr>");
            }
            sPieGraphHtml.append("</table><br>");
        }
        return sPieGraphHtml.toString();
    }

    private String generateBarHtml(ArrayList deviceList, double lMaxTotal)
        throws Exception {
        StringBuffer sTableBodyHtml = new StringBuffer();
        int size = deviceList.size();
        for (int i = 0; i < size; i++) {
            DeviceInfoBean deviceRec = (DeviceInfoBean) deviceList.get(i);
            String sMountPoint = deviceRec.getSMountPoint();
            StringBuffer sTotal = new StringBuffer();
            StringBuffer sUsed = new StringBuffer();
            StringBuffer sAvailable = new StringBuffer();
            if (watchItemId.equalsIgnoreCase(WatchItemDef.Disk_Used_Rate)) {
                sTotal.append(deviceRec.getTotal());
                sUsed.append(deviceRec.getUsed());
                sAvailable.append(deviceRec.getAvailable());
            } else {
                sTotal.append((long) deviceRec.getTotal());
                sUsed.append((long) deviceRec.getUsed());
                sAvailable.append((long) deviceRec.getAvailable());
            }
            int iWidth = Integer.parseInt(sFullWidth);
            if (sSnapshotType.equalsIgnoreCase(SnapshotGraphDef.BAR2)) {
                iWidth =
                    (int) (iWidth * deviceRec.getTotal() / (double) lMaxTotal);
                if (iWidth < 2) {
                    iWidth = 2;
                }
            }
            sTableBodyHtml
                .append("<tr><td>")
                .append("<span title=\"")
                .append(deviceRec.getSMountPoint())
                .append("\"><img src=\"")
                .append(NSActionConst.CONFIG_ROOT_PATH)
                .append("/cgi")
                .append("/GDBarCGI.pl?wd=")
                .append(iWidth)
                .append("&ht=")
                .append(sHeight)
                .append("&pr=")
                .append(deviceRec.getUsedRate())
                .append("\" border=\"0\"></span></td><td align=\"right\">")
                .append(deviceRec.getUsedRate())
                .append("</td><td align=\"right\">")
                .append(sTotal)
                .append("</td><td align=\"right\">")
                .append(sUsed)
                .append("</td><td align=\"right\">")
                .append(sAvailable)
                .append("</td><td>")
                .append(deviceRec.getSType())
                .append("</td><td>")
                .append(deviceRec.getSDevice())
                .append("</td><td>")
                .append(sMountPoint)
                .append("</td></tr>");
        }
        return sTableBodyHtml.toString();
    }
}