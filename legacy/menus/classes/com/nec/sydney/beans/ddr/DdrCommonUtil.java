/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DdrCommonUtil.java,v 1.2 2005/08/29 04:44:21 wangzf Exp $
 */
package com.nec.sydney.beans.ddr;

import javax.servlet.http.HttpSession;
import java.util.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.ddr.*;
import com.nec.sydney.atom.admin.base.*;

public class DdrCommonUtil implements DdrConstants,NasConstants{
    private static final String cvsid = "@(#) DdrCommonUtil.java,v 1.1 2004/08/24 09:50:22 wangw Exp";
	
    public static String[] DdrSchedule4Display(DdrScheduleInfo dsi, HttpSession session) {
    	java.text.DecimalFormat df = new java.text.DecimalFormat("00");
    	String[] alertMsg = {"","","","",""};
    	int period = dsi.getPeriod();
    	switch(period){
            case DDR_CRON_PERIOD_WEEKDAY:
                alertMsg[0] = NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_weekday");
            	String[] weekday = {
            	    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_sun"),
            	    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_mon"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_tue"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_wed"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_thu"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_fri"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/display_sat")
                };
                String[] displayDay = dsi.getDay().split(",");
                for(int i=0; i<displayDay.length; i++){
                    displayDay[i] = weekday[Integer.parseInt(displayDay[i])];
                }
                alertMsg[1] = joinArray2String(displayDay
                                ,NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/separateSign"));
                alertMsg[2] = NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_time");
                alertMsg[3] = dsi.getHour() 
                            + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_hour");
                alertMsg[4] = df.format(Double.parseDouble(dsi.getMinute()))
                            + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_minute");
            	break;
            case DDR_CRON_PERIOD_MONTHDAY:
            	alertMsg[0] = NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_monthday");
                alertMsg[1] = dsi.getDay();
                alertMsg[2] = NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_time");
                alertMsg[3] = dsi.getHour() 
                            + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_hour");
                alertMsg[4] = df.format(Double.parseDouble(dsi.getMinute()))
                            + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_minute");
            	break;
            case DDR_CRON_PERIOD_DAILY:
            	alertMsg = new String[]{
            	            NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_daily")
                            ,NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_time")
                            ,dsi.getHour() 
                                    + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_hour")
                            ,df.format(Double.parseDouble(dsi.getMinute()))
                                    + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/schedule_add/td_minute")
                            };
            	break;
            case DDR_CRON_PERIOD_DIRECT:
                alertMsg = new String[]{dsi.getDirectEditInfo()};
            	break;
    	}
    	return alertMsg;
    }
    
    public static String joinArray2String(String[] paramArray,String joinSign){
        StringBuffer tmpResult = new StringBuffer();
        for(int i=0; i<paramArray.length; i++){
            tmpResult.append(paramArray[i]);
            if(i!=paramArray.length-1){
                tmpResult.append(joinSign);
            }
        }
        return tmpResult.toString();
    }
}