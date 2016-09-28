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
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.biz.statis.TargetDef;
import org.apache.struts.util.MessageResources;

/**
 *Actions for direct edit page
 */
public class StatisAssistantBase implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: StatisAssistantBase.java,v 1.1 2005/10/18 16:24:27 het Exp $";
    protected HttpServletRequest _request;
    protected MonitorConfigBase mc;
    protected RRDGraphDef rgd;
    protected String targetId;
    protected MessageResources msgResource;

    public void initInvest(HttpServletRequest request, MessageResources msgRes) {
        msgResource = msgRes;
        mc =
            (MonitorConfigBase) NSActionUtil.getSessionAttribute(
                request,
                SESSION_MC_4SURVEY);
        rgd =
            (RRDGraphDef) request.getSession().getAttribute(
                SESSION_RGD_4SURVEY);
        initCommon(request);

    }

    public void initNormal(HttpServletRequest request, MessageResources msgRes) {
        msgResource = msgRes;
        mc =
            (MonitorConfigBase) NSActionUtil.getSessionAttribute(
                request,
                SESSION_MC);
        rgd = (RRDGraphDef) request.getSession().getAttribute(SESSION_RGD);
        initCommon(request);
    }

    public void initNsw(HttpServletRequest request, MessageResources msgRes) {
        msgResource = msgRes;
        rgd = (RRDGraphDef) request.getSession().getAttribute(SESSION_RGD_4NSW);
        mc =
            (MonitorConfigBase) NSActionUtil.getSessionAttribute(
                request,
                SESSION_MC);
        initCommon(request);
        
    }

    private void initCommon(HttpServletRequest request) {
        targetId =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_TARGET_ID);
        _request = request;
    }

    public String getClusterTag() {
        TargetDef td = mc.getTargetDef(targetId);
        if (td.getType().equals(TargetDef.NASIPSAN)) {
            return "true";
        } else if (td.getType().equals(TargetDef.CLUSTER)) {
            return "true";
        } else {
            return "false";
        }
    }
    public String getNickName(String targetId) {
        return mc.getTargetDef(targetId).getNickName();
    }

    public String getAutoReloadInterval() throws Exception {
        String interval = rgd.getAutoReloadInterval().trim();
        String unit = rgd.getAutoReloadUnit().trim();
        return Integer.toString(
            StatisActionCommon.convertInterval(interval, unit));
    }

    public String getAutoReloadFlag() {
        return rgd.getAutoReloadFlag().trim();
    }
    
    protected String getRelativeTime(String time, String unit)
        throws Exception {
        StringBuffer tmp = new StringBuffer("-").append(time);
        if (unit.equalsIgnoreCase(RRDGraphDef.HOURS)) {
            tmp.append("h");
        } else if (unit.equalsIgnoreCase(RRDGraphDef.DAYS)) {
            tmp.append("d");
        } else if (unit.equalsIgnoreCase(RRDGraphDef.WEEKS)) {
            tmp.append("w");
        } else if (unit.equalsIgnoreCase(RRDGraphDef.MONTHS)) {
            tmp.append("m");
        } else {
            tmp.append("y");
        }
        return tmp.toString();
    }
    
    public String getCustomStartTime() throws Exception {
        if (rgd
            .getPeriodFrom()
            .trim()
            .equalsIgnoreCase(RRDGraphDef.ABSOLUTE)) {
            return rgd.getPeriodFromAbsolute().trim();
        } else { //use relative time
            return getRelativeTime(
                rgd.getPeriodFromRelative().trim(),
                rgd.getPeriodFromRelativeUnit().trim());
        }
    }

    protected int getSampleInterval() throws Exception {
        String sInterval = rgd.getSamplingInterval().trim();
        String sUnit = rgd.getSamplingUnit().trim();
        int iSampleInterval =
            StatisActionCommon.convertInterval(sInterval, sUnit);
        return iSampleInterval;
    }
    protected int getDisplayPeriod(
        String type,
        String fromDate,
        String toDate) {
        if (type.equalsIgnoreCase(RRDGraphDef.DAILY)) {
            return new Long(StatisActionCommon.CurrentTime()).intValue()
                - new Long(StatisActionCommon.ChangeTime("1", RRDGraphDef.DAYS))
                    .intValue();
        } else if (type.equalsIgnoreCase(RRDGraphDef.WEEKLY)) {
            return new Long(StatisActionCommon.CurrentTime()).intValue()
                - new Long(StatisActionCommon.ChangeTime("1", RRDGraphDef.WEEKS))
                    .intValue();
        } else if (type.equalsIgnoreCase(RRDGraphDef.MONTHLY)) {
            return new Long(StatisActionCommon.CurrentTime()).intValue()
                - new Long(
                    StatisActionCommon.ChangeTime("1", RRDGraphDef.MONTHS))
                    .intValue();
        } else if (type.equalsIgnoreCase(RRDGraphDef.YEARLY)) {
            return new Long(StatisActionCommon.CurrentTime()).intValue()
                - new Long(StatisActionCommon.ChangeTime("1", RRDGraphDef.YEARS))
                    .intValue();
        } else if (type.equalsIgnoreCase(RRDGraphDef.USER_SPEC)) {
            return Long.valueOf(toDate).intValue()
                - Long.valueOf(fromDate).intValue();
        }
        return Integer.MAX_VALUE;
    }
    /**
     * @function convert value of totime and tounit to time needed by rrd2csv
     */
    public String getCustomEndTime() throws Exception {
        if (rgd.getPeriodTo().trim().equalsIgnoreCase(RRDGraphDef.ABSOLUTE)) {
            return rgd.getPeriodToAbsolute().trim();
        } else if (
            rgd.getPeriodTo().trim().equalsIgnoreCase(RRDGraphDef.RELATIVE)) {
            return getRelativeTime(
                rgd.getPeriodToRelative().trim(),
                rgd.getPeriodToRelativeUnit().trim());
        } else {
            return RRD2CSV_END_TIME_OPT_NOW;
        }
    }
    protected String convertDateFrom() {
        if (rgd
            .getPeriodFrom()
            .trim()
            .equalsIgnoreCase(RRDGraphDef.ABSOLUTE)) {
            //use absolute time
            return rgd.getPeriodFromAbsolute().trim();
        } else { //use relative time
            return Long.toString(
                StatisActionCommon.ChangeTime(
                    rgd.getPeriodFromRelative().trim(),
                    rgd.getPeriodFromRelativeUnit().trim()));
        } //end of "else"
    }

    protected String convertDateTo() {
        if (rgd.getPeriodTo().trim().equalsIgnoreCase(RRDGraphDef.ABSOLUTE)) {
            //use absolute time
            return rgd.getPeriodToAbsolute().trim();
        } else if (
            rgd.getPeriodTo().trim().equalsIgnoreCase(RRDGraphDef.RELATIVE)) {
            //use relative time
            return Long.toString(
                StatisActionCommon.ChangeTime(
                    rgd.getPeriodToRelative().trim(),
                    rgd.getPeriodToRelativeUnit().trim()));
        } else {
            //use "NOW" as toTime
            return Long.toString(StatisActionCommon.CurrentTime());
        }
    }
    protected String[] getSampleDate(String type) {
        String[] date = new String[2];
        if (type.equalsIgnoreCase(RRDGraphDef.DAILY)) {
            //generate Daily Graph
            date[0] =
                Long.toString(
                    StatisActionCommon.ChangeTime("1", RRDGraphDef.DAYS));
            date[1] = Long.toString(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.WEEKLY)) {
            //generate Weekly Graph
            date[0] =
                Long.toString(
                    StatisActionCommon.ChangeTime("1", RRDGraphDef.WEEKS));
            date[1] = Long.toString(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.MONTHLY)) {
            //generate Monthly Graph
            date[0] =
                Long.toString(
                    StatisActionCommon.ChangeTime("1", RRDGraphDef.MONTHS));
            date[1] = Long.toString(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.YEARLY)) {
            //generate Yearly Graph
            date[0] =
                Long.toString(
                    StatisActionCommon.ChangeTime("1", RRDGraphDef.YEARS));
            date[1] = Long.toString(StatisActionCommon.CurrentTime());
        } else if (type.equalsIgnoreCase(RRDGraphDef.USER_SPEC)) {

            //generate User Specified Graph
            // convert fromDate and toDate to required format
            date[0] = convertDateFrom();
            date[1] = convertDateTo();
        }
        return date;
    }

    public String comSampleIntervalAndDisPeriod(String graphType) throws Exception {
        if (rgd.getSamplingFlag().trim().equals(RRDGraphDef.SPECIFIC)) {
            String fromDate = convertDateFrom();
            String toDate = convertDateTo();
            int displayPeriod = getDisplayPeriod(graphType, fromDate, toDate);
            int iSampleInterval = getSampleInterval();
            if (iSampleInterval > displayPeriod) {
                _request.setAttribute("msg_big_interval", "1");
                return msgResource.getMessage(
                        _request.getLocale(),
                        "RRDGraph.msg_big_interval");
            }else{
                return "no";
            }
        }else{
            return "no";
        }
    }

    public List getTargetList() {
        List targetList = new ArrayList();
        TargetDef td = mc.getTargetDef(targetId);
        if (getClusterTag().equals("true")) {
            targetList.addAll(td.getNodes());
        } else {
            targetList.add(targetId);
        }
        return targetList;
    }   

}
