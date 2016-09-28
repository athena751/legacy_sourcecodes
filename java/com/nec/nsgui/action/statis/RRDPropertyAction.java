/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.LabelValueBean;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
import com.nec.nsgui.model.entity.statis.OptionInfoBean;
import com.nec.nsgui.model.entity.statis.SampleInfoBean;
import com.nec.nsgui.model.entity.statis.TimeInfoBean;
import com.nec.nsgui.model.biz.statis.SamplingHandler;
import com.nec.nsgui.model.biz.base.NSException;

/**
 *
 */
public class RRDPropertyAction
    extends DispatchAction
    implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: RRDPropertyAction.java,v 1.6 2007/04/03 11:05:54 yangxj Exp $";
    private static final String ERRCODE_FAILED_CLUSTER_SET = "0x12700010";

    public ActionForward display(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        RRDGraphDef rgd =null;
        MonitorConfigBase mc =
            (MonitorConfigBase) NSActionUtil.getSessionAttribute(
                request,
                SESSION_MC);
        if(mc instanceof MonitorConfig){
        	if(NSActionUtil.getSessionAttribute(
                    request,
                    NSActionConst.SESSION_EXCEPTION_MESSAGE) != null){
        		rgd =
        			(RRDGraphDef) NSActionUtil.getSessionAttribute(
        					request,
        					SESSION_RGD_EXCEPTION);
        	}else{
        		rgd =
        			(RRDGraphDef) NSActionUtil.getSessionAttribute(
        					request,
        					SESSION_RGD);
        	}
        }else{
            rgd =
                (RRDGraphDef) NSActionUtil.getSessionAttribute(
                    request,
                    SESSION_RGD_4NSW);
        }
        OptionInfoBean optionInfo = initOptionInfo(rgd);
        setOption(request, optionInfo, false);
        ((DynaActionForm) form).set("optionInfo", optionInfo);
        return mapping.findForward("display");
    }

    public ActionForward displayForSurvey(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {

        RRDGraphDef rgd =
            (RRDGraphDef) NSActionUtil.getSessionAttribute(
                request,
                SESSION_RGD_4SURVEY);
        OptionInfoBean optionInfo = initOptionInfo(rgd);
        setOption(request, optionInfo, true);
        ((DynaActionForm) form).set("optionInfo", optionInfo);
        request.setAttribute("is4Survey", "true");
        return mapping.findForward("displayForSurvey");
    }

    public ActionForward saveOption(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        RRDGraphDef rgd =null;
        MonitorConfigBase mc =
            (MonitorConfigBase) NSActionUtil.getSessionAttribute(
                request,
                SESSION_MC);
        if(mc instanceof MonitorConfig){
            rgd =
                (RRDGraphDef) NSActionUtil.getSessionAttribute(
                    request,
                    SESSION_RGD);
        }else{
            rgd =
                (RRDGraphDef) NSActionUtil.getSessionAttribute(
                    request,
                    SESSION_RGD_4NSW);
        }
        OptionInfoBean optionInfo =
            (OptionInfoBean) ((DynaActionForm) form).get("optionInfo");
        TimeInfoBean fromTimeInfo = optionInfo.getFromTimeInfo();
        TimeInfoBean toTimeInfo = optionInfo.getToTimeInfo();
        SampleInfoBean sampleInfo = optionInfo.getSampleInfo();

        int checkResult = TimeValidCheck(fromTimeInfo, toTimeInfo, request, -1);
        if (checkResult != 0) {
            return mapping.findForward("failed");
        }

        //get the data from the optionInfo,then set to the rgd
        RRDGraphDef tempRgd = new RRDGraphDef();
        tempRgd.setAutoReloadFlag(rgd.getAutoReloadFlag());
        tempRgd.setAutoReloadInterval(rgd.getAutoReloadInterval());
        tempRgd.setAutoReloadUnit(rgd.getAutoReloadUnit());
        tempRgd.setDefaultPeriod(rgd.getDefaultPeriod());
        tempRgd.setPeriodFrom(rgd.getPeriodFrom());
        tempRgd.setPeriodFromAbsolute(rgd.getPeriodFromAbsolute());
        tempRgd.setPeriodFromRelative(rgd.getPeriodFromRelative());
        tempRgd.setPeriodFromRelativeUnit(rgd.getPeriodFromRelativeUnit());
        tempRgd.setPeriodTo(rgd.getPeriodTo());
        tempRgd.setPeriodToAbsolute(rgd.getPeriodToAbsolute());
        tempRgd.setPeriodToRelative(rgd.getPeriodToRelative());
        tempRgd.setPeriodToRelativeUnit(rgd.getPeriodFromRelativeUnit());
        tempRgd.setSamplingFlag(rgd.getSamplingFlag());
        tempRgd.setSamplingInterval(rgd.getSamplingInterval());
        tempRgd.setSamplingUnit(rgd.getSamplingUnit());
        setRGDOptions(rgd, fromTimeInfo, toTimeInfo, sampleInfo);

        setRGDOptions(rgd, fromTimeInfo, toTimeInfo, sampleInfo);

        String userID =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_USERINFO);
        
        if(mc instanceof MonitorConfig){
            request.getSession().setAttribute(SESSION_RGD, rgd);
        }else{
            request.getSession().setAttribute(SESSION_RGD_4NSW, rgd);
        }
        if (!NSActionUtil.isNsview(request)) {
            
        	try{
        	    mc.saveRRDGraphDef(userID, rgd);
        	}catch(NSException e)
        	{ 
        		String me=e.getMessage();
        		if(me.equals(CollectionConst.EXCEPTION_MSG1))
    			{
        			
        			e.setErrorCode(CollectionConst.EXCEPTION_ERRCODE_02);
    				  NSActionUtil.setSessionAttribute( request,NSActionConst.SESSION_EXCEPTION_MESSAGE,"true");
    				request.getSession().setAttribute(SESSION_RGD_EXCEPTION, rgd);
    				request.getSession().setAttribute(SESSION_RGD, tempRgd);
    				
    			}
    			throw e;
        	    
        	}
        	
        	SamplingHandler.syncGraphDef();
        	
        }
        NSActionUtil.setSuccess(request);
        return mapping.findForward("success");
    }

    private void setRGDOptions(
        RRDGraphDef rgd,
        TimeInfoBean fromTimeInfo,
        TimeInfoBean toTimeInfo,
        SampleInfoBean sampleInfo) {
        if (fromTimeInfo.getFlag().equals(RRDGraphDef.ABSOLUTE)) {
            String fromABSTime = getABSTime(fromTimeInfo);
            rgd.setPeriodFrom(RRDGraphDef.ABSOLUTE);
            rgd.setPeriodFromAbsolute(fromABSTime);
        } else {
            rgd.setPeriodFrom(RRDGraphDef.RELATIVE);
            rgd.setPeriodFromRelative(fromTimeInfo.getTime());
            rgd.setPeriodFromRelativeUnit(fromTimeInfo.getTimeUnit());
        }
        if (toTimeInfo.getFlag().equals(RRDGraphDef.ABSOLUTE)) {
            String toABSTime = getABSTime(toTimeInfo);
            rgd.setPeriodTo(RRDGraphDef.ABSOLUTE);
            rgd.setPeriodToAbsolute(toABSTime);
        } else if (toTimeInfo.getFlag().equals(RRDGraphDef.RELATIVE)) {
            rgd.setPeriodTo(RRDGraphDef.RELATIVE);
            rgd.setPeriodToRelative(toTimeInfo.getTime());
            rgd.setPeriodToRelativeUnit(toTimeInfo.getTimeUnit());
        } else {
            rgd.setPeriodTo(RRDGraphDef.NOW);
        }
        if (sampleInfo != null) {

            if (sampleInfo.getSample().equals(RRDGraphDef.SPECIFIC)) {
                rgd.setSamplingFlag(RRDGraphDef.SPECIFIC);
                rgd.setSamplingInterval(sampleInfo.getSampleInterval());
                rgd.setSamplingUnit(sampleInfo.getSampleUnit());
            } else {
                rgd.setSamplingFlag(RRDGraphDef.AUTO);
            }
        }
    }

    public ActionForward saveOptionForSurvey(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        RRDGraphDef rgd =
            (RRDGraphDef) NSActionUtil.getSessionAttribute(
                request,
                SESSION_RGD_4SURVEY);
        OptionInfoBean optionInfo =
            (OptionInfoBean) ((DynaActionForm) form).get("optionInfo");
        TimeInfoBean fromTimeInfo = optionInfo.getFromTimeInfo();
        TimeInfoBean toTimeInfo = optionInfo.getToTimeInfo();

        MonitorConfig2 mc2 = new MonitorConfig2();
        mc2.loadDefs();
        String target =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_TARGET_ID);
        String watchItemId =
            (String) NSActionUtil.getSessionAttribute(
                request,
                SESSION_WATCHITEM_ID);
        WatchItemDef wid = mc2.getWatchItemDef(watchItemId);
        String collectionItemId = wid.getCollectionItem();
        int stockPeriod = 7;

        int checkResult =
            TimeValidCheck(fromTimeInfo, toTimeInfo, request, stockPeriod);
        if (checkResult != 0) {
            return mapping.findForward("failedForSurvey");
        }
        setRGDOptions(rgd, fromTimeInfo, toTimeInfo, null);
        request.getSession().setAttribute(SESSION_RGD_4SURVEY, rgd);
        return mapping.findForward("successForSurvey");
    }

    private OptionInfoBean initOptionInfo(RRDGraphDef rgd) {
        OptionInfoBean optionInfo = new OptionInfoBean();
        TimeInfoBean fromTimeInfo = new TimeInfoBean();
        TimeInfoBean toTimeInfo = new TimeInfoBean();
        SampleInfoBean sampleInfo = new SampleInfoBean();

        GregorianCalendar graphTime = new GregorianCalendar();

        //set fromTimeInfo
        String timeString = rgd.getPeriodFromAbsolute();
        long currentTime = System.currentTimeMillis();
        if (timeString == null || timeString.equals("")) {
            graphTime.setTimeInMillis(currentTime - SECONDS_OF_ONE_YEAR*1000);
        } else {
            graphTime.setTimeInMillis(Long.parseLong(timeString) * 1000);
        }
        fromTimeInfo.setFlag(rgd.getPeriodFrom());
        fromTimeInfo.setTime(rgd.getPeriodFromRelative());
        fromTimeInfo.setTimeUnit(rgd.getPeriodFromRelativeUnit());
        setTimeInfo(fromTimeInfo, graphTime);

        //set toTimeInfo
        timeString = rgd.getPeriodToAbsolute();
        if (timeString == null || timeString.equals("")) {
            graphTime.setTimeInMillis(currentTime);
        } else {
            graphTime.setTimeInMillis(Long.parseLong(timeString) * 1000);
        }
        toTimeInfo.setFlag(rgd.getPeriodTo());
        toTimeInfo.setTime(rgd.getPeriodToRelative());
        toTimeInfo.setTimeUnit(rgd.getPeriodToRelativeUnit());
        setTimeInfo(toTimeInfo, graphTime);

        //set sampleInfo
        sampleInfo.setSample(rgd.getSamplingFlag());
        sampleInfo.setSampleInterval(rgd.getSamplingInterval());
        sampleInfo.setSampleUnit(rgd.getSamplingUnit());

        optionInfo.setFromTimeInfo(fromTimeInfo);
        optionInfo.setToTimeInfo(toTimeInfo);
        optionInfo.setSampleInfo(sampleInfo);

        return optionInfo;
    }

    private void setTimeInfo(
        TimeInfoBean fromTimeInfo,
        GregorianCalendar graphTime) {
        fromTimeInfo.setYear(graphTime.get(Calendar.YEAR));
        fromTimeInfo.setMonth(graphTime.get(Calendar.MONTH) + 1);
        fromTimeInfo.setDay(graphTime.get(Calendar.DATE));
        fromTimeInfo.setHour(graphTime.get(Calendar.HOUR_OF_DAY));
        fromTimeInfo.setMinute(graphTime.get(Calendar.MINUTE));
        fromTimeInfo.setSecond(graphTime.get(Calendar.SECOND));
    }

    private String getABSTime(TimeInfoBean timeInfo) {
        GregorianCalendar graphTime = new GregorianCalendar();
        graphTime.set(
            timeInfo.getYear(),
            timeInfo.getMonth() - 1,
            timeInfo.getDay(),
            timeInfo.getHour(),
            timeInfo.getMinute(),
            timeInfo.getSecond());
        String ABSTime = String.valueOf(graphTime.getTimeInMillis() / 1000);
        return ABSTime;
    }

    private void setAlertMessage(HttpServletRequest request, String msgKey) {
        MessageResources commonMsgRsrc =
            (MessageResources) getServlet().getServletContext().getAttribute(
                "common");
        String msgFailed =
            commonMsgRsrc.getMessage(
                request.getLocale(),
                "common.alert.failed");
        String msg =
            getResources(request).getMessage(request.getLocale(), msgKey);
        request.getSession().setAttribute(
            NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
            msgFailed + "\\r\\n" + msg);
    }

    private int TimeValidCheck(
        TimeInfoBean fromTimeInfo,
        TimeInfoBean toTimeInfo,
        HttpServletRequest request,
        int stockPeriod) {
        String fromABSTime = getABSTime(fromTimeInfo);
        String toABSTime = getABSTime(toTimeInfo);
        long tFromABSTime = Long.parseLong(fromABSTime);
        long tToABSTime = Long.parseLong(toABSTime);
        long tNowTime = StatisActionCommon.CurrentTime();
        long stockPeriodInSec = stockPeriod * 24 * 60 * 60;

        //return 1:if the (absolute to time) is later than now
        if (toTimeInfo.getFlag().equals(RRDGraphDef.ABSOLUTE)) {
            if (tToABSTime > tNowTime) {
                setAlertMessage(request, "statis.properties.endlaternow");
                return 1;
            }
            if (stockPeriodInSec > 0
                && tNowTime - tToABSTime > stockPeriodInSec) {
                setAlertMessage(
                    request,
                    "statis.properties.totime.period.too.large");
                return 7;
            }
        }

        if (fromTimeInfo.getFlag().equals(RRDGraphDef.ABSOLUTE)) {
            if (stockPeriodInSec > 0
                && tNowTime - tFromABSTime > stockPeriodInSec) {
                setAlertMessage(
                    request,
                    "statis.properties.fromtime.period.too.large");
                return 7;
            }
            if (toTimeInfo.getFlag().equals(RRDGraphDef.NOW)) {
                //return 2:if the (absolute from time) is later than now
                if (tFromABSTime >= tNowTime) {
                    setAlertMessage(request, "statis.properties.laternow");
                    return 2;
                }
            } else if (toTimeInfo.getFlag().equals(RRDGraphDef.ABSOLUTE)) {
                //return 3:if the (absolute from time) is later than (absolute to time)
                if (tFromABSTime >= tToABSTime) {
                    setAlertMessage(request, "statis.properties.laterend");
                    return 3;
                }
            } else if (toTimeInfo.getFlag().equals(RRDGraphDef.RELATIVE)) {
                long tToRELTime =
                    StatisActionCommon.ChangeTime(
                        toTimeInfo.getTime(),
                        toTimeInfo.getTimeUnit());
                //return 4:if the (absolute from time) is later than (relative to time)
                if (tFromABSTime >= tToRELTime) {
                    setAlertMessage(request, "statis.properties.laterend");
                    return 4;
                }
            }
        } else {
            long tFromRELTime =
                StatisActionCommon.ChangeTime(
                    fromTimeInfo.getTime(),
                    fromTimeInfo.getTimeUnit());
            if (toTimeInfo.getFlag().equals(RRDGraphDef.ABSOLUTE)) {
                //return 5:if the (relative from time) is later than (absolute to time)
                if (tFromRELTime >= tToABSTime) {
                    setAlertMessage(request, "statis.properties.laterend");
                    return 5;
                }
            } else if (toTimeInfo.getFlag().equals(RRDGraphDef.RELATIVE)) {
                long tToRELTime =
                    StatisActionCommon.ChangeTime(
                        toTimeInfo.getTime(),
                        toTimeInfo.getTimeUnit());
                //return 6:if the (relative from time) is later than (relative to time)
                if (tFromRELTime >= tToRELTime) {
                    setAlertMessage(request, "statis.properties.laterend");
                    return 6;
                }
            } else if (toTimeInfo.getFlag().equals(RRDGraphDef.NOW)) {
                return 0;
            }
        }
        return 0;
    }

    //All below here are for the option
    private void setOption(
        HttpServletRequest request,
        OptionInfoBean optionInfo,
        boolean is4Survey) {
        request.setAttribute("yearSet", getYear());
        request.setAttribute("monthSet", getMonth());
        request.setAttribute("daySet", getDay());
        request.setAttribute("hourSet", getHour());
        request.setAttribute("minuteSet", getMinute());
        request.setAttribute("secondSet", getSecond());
        request.setAttribute(
            "fromTimeSet",
            getRelativeTime(
                optionInfo.getFromTimeInfo().getTimeUnit(),
                is4Survey));
        request.setAttribute(
            "toTimeSet",
            getRelativeTime(
                optionInfo.getToTimeInfo().getTimeUnit(),
                is4Survey));
    }
    private Vector getYear() {
        Calendar rightnow = Calendar.getInstance();
        int CurYear = rightnow.get(Calendar.YEAR);
        return getTime(CurYear - 1, CurYear, true);
    }
    private Vector getMonth() {
        return getTime(MIN_MONTH, MAX_MONTH, true);
    }
    private Vector getDay() {
        return getTime(MIN_DAY, MAX_DAY, true);
    }
    private Vector getHour() {
        return getTime(MIN_HOUR, MAX_HOUR, true);
    }
    private Vector getMinute() {
        return getTime(MIN_MINUTE, MAX_MINUTE, true);
    }
    private Vector getSecond() {
        return getTime(MIN_SECOND, MAX_SECOND, true);
    }
    public Vector getRelativeTime(String timeUnit, boolean is4Survey) {
        if (timeUnit.equals(RRDGraphDef.HOURS)) {
            if (is4Survey) {
                return getTime(MIN_REL_HOURS, MAX_REL_HOURS_4SURVEY, false);
            } else {
                return getTime(MIN_REL_HOURS, MAX_REL_HOURS, false);
            }
        } else if (timeUnit.equals(RRDGraphDef.DAYS)) {
            if (is4Survey) {
                return getTime(MIN_REL_DAYS, MAX_REL_DAYS_4SURVEY, false);
            } else {
                return getTime(MIN_REL_DAYS, MAX_REL_DAYS, false);
            }
        } else if (timeUnit.equals(RRDGraphDef.WEEKS)) {
            if (is4Survey) {
                return getTime(MIN_REL_WEEKS, MAX_REL_WEEKS_4SURVEY, false);
            } else {
                return getTime(MIN_REL_WEEKS, MAX_REL_WEEKS, false);
            }
        } else if (timeUnit.equals(RRDGraphDef.MONTHS)) {
            return getTime(MIN_REL_MONTHS, MAX_REL_MONTHS, false);
        } else if (timeUnit.equals(RRDGraphDef.YEARS)) {
            return getTime(FIX_REL_YEARS, FIX_REL_YEARS, false);
        } else {
            return getTime(MIN_REL_MONTHS, MAX_REL_MONTHS, false);
        }
    }
    private Vector getTime(int startTime, int endTime, boolean appendZero) {
        Vector timeSet = new Vector();
        for (int i = startTime; i <= endTime; i++) {
            String index = String.valueOf(i);
            StringBuffer label = new StringBuffer(2);
            if (index.length() == 1 && appendZero) {
                label.append("0");
            }
            label.append(index);
            timeSet.add(new LabelValueBean(label.toString(), index));
        }
        return timeSet;
    }
}