/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.model.entity.ddr.DdrScheduleBean;
import com.nec.nsgui.action.ddr.DdrActionConst;
public class ScheduleUtil implements DdrActionConst {

	private static final String cvsid = "@(#) $Id: ScheduleUtil.java,v 1.2 2008/05/14 01:10:16 liy Exp $";

	public static String getSchedule(String scheduleLine,
			HttpServletRequest request) throws Exception {
		if (scheduleLine == null || scheduleLine.equals("") || scheduleLine.equals("--")) {
			return scheduleLine;
		}

		MessageResources mr = MessageResources
				.getMessageResources("com.nec.nsgui.messages.DdrResource");
		String[] weekdays = {
				mr.getMessage(request.getLocale(), "pair.info.schedule.sunday"),
				mr.getMessage(request.getLocale(), "pair.info.schedule.monday"),
				mr
						.getMessage(request.getLocale(),
								"pair.info.schedule.tuesday"),
				mr.getMessage(request.getLocale(),
						"pair.info.schedule.wednesday"),
				mr.getMessage(request.getLocale(),
						"pair.info.schedule.thursday"),
				mr.getMessage(request.getLocale(), "pair.info.schedule.friday"),
				mr.getMessage(request.getLocale(),
						"pair.info.schedule.saturday")};

		StringBuffer dataStr = new StringBuffer();
		String[] scheduleInfo = scheduleLine.split("\\s+");

		String minute = scheduleInfo[0];
		String hour = scheduleInfo[1];
		String monthday = scheduleInfo[2];
		String month = scheduleInfo[3];
		String weekday = scheduleInfo[4];

		// get the way of schedule-setting.
		int period;
		if (isMinuteValid(minute) && isHourValid(hour)) {
			if (monthday.equals("*") && month.equals("*")
					&& isDayValid(weekday)) {
				period = DDR_CRON_PERIOD_WEEKDAY;
			} else if (month.equals("*") && weekday.equals("*")
					&& isMonthDayValid(monthday)) {
				period = DDR_CRON_PERIOD_MONTHDAY;
			} else if (monthday.equals("*") && month.equals("*")
					&& weekday.equals("*")) {
				period = DDR_CRON_PERIOD_DAILY;
			} else {
				period = DDR_CRON_PERIOD_DIRECT;
			}
		} else {
			period = DDR_CRON_PERIOD_DIRECT;
		}

		// set the schedule's info.
		switch (period) {
			case DDR_CRON_PERIOD_WEEKDAY :
				String[] displayDay = weekday.split(",");
				for (int j = 0; j < displayDay.length; j++) {
					displayDay[j] = weekdays[Integer.parseInt(displayDay[j])];
				}
				dataStr
						.append(joinArray2String(displayDay, mr.getMessage(
								request.getLocale(),
								"pair.info.schedule.separatesign")));
				break;
			case DDR_CRON_PERIOD_MONTHDAY :
				dataStr.append(monthday).append(
						mr.getMessage(request.getLocale(),
								"pair.info.schedule.unitday"));
				break;
			case DDR_CRON_PERIOD_DAILY :
				dataStr.append(mr.getMessage(request.getLocale(),
						"pair.info.schedule.daily"));
				break;
			case DDR_CRON_PERIOD_DIRECT :
				dataStr.append(scheduleLine);
				break;
		}

		// if the way of schedule-setting is not 'directedit'.
		if (period != DDR_CRON_PERIOD_DIRECT) {
			// parse the hour and minute.
			dataStr.append("&nbsp;&nbsp;").append(hour).append(
					mr.getMessage(request.getLocale(),
							"pair.info.schedule.unithour")).append(minute)
					.append(
							mr.getMessage(request.getLocale(),
									"pair.info.schedule.unitminute"));
		}

		if (dataStr.toString().trim().equals("")) {
			return "--";
		} else {
			return dataStr.toString();
		}
	}
	/*
	 * when the way of schedule-setting is 'weekday',format the way of
	 * displaying.
	 */
	public static String joinArray2String(String[] paramArray, String joinSign) {
		StringBuffer tmpResult = new StringBuffer();
		for (int i = 0; i < paramArray.length; i++) {
			tmpResult.append(paramArray[i]);
			if (i != paramArray.length - 1) {
				tmpResult.append(joinSign);
			}
		}
		return tmpResult.toString();
	}

	/*
	 * check whether the day is correct.
	 */
	private static boolean isDayValid(String day) {
		if (day.matches("^\\d+$")) {
			int iDay = Integer.parseInt(day);
			if (iDay >= 0 && iDay <= 6) {

				return true;
			}
		} else if (day.matches("^\\d+(,\\d+)+$")) {
			String[] monthdayNum = day.split(",");
			for (int i = 0; i < monthdayNum.length; i++) {
				int iDay = Integer.parseInt(monthdayNum[0]);
				if (iDay < 0 || iDay > 6) {
					return false;
				}
			}
			return true;
		}
		return false;
	}
	/*
	 * check whether the day is correct.
	 */
	private static boolean isMonthDayValid(String monthDay) {
		if (monthDay.matches("^\\d+$")) {
			int iDay = Integer.parseInt(monthDay);
			if ( iDay >= 1 && iDay <= 31) {

				return true;
			}
		} else if (monthDay.matches("^\\d+(,\\d+)+$")) {
			String[] monthdayNum = monthDay.split(",");
			for (int i = 0; i < monthdayNum.length; i++) {
				int iDay = Integer.parseInt(monthdayNum[0]);
				if (iDay < 1 || iDay > 31) {
					return false;
				}
			}
			return true;
		}
		return false;
	}
	/*
	 * check whether the minute is correct.
	 */
	private static boolean isMinuteValid(String minute) {
		if (minute.matches("^\\d{1,2}$")) {
			int minuteNum = Integer.parseInt(minute);
			if (minuteNum >= 0 && minuteNum <= 59) {
				return true;
			}
		}
		return false;
	}

	/*
	 * check whether the hour is correct.
	 */
	private static boolean isHourValid(String hour) {
		// hour must like ("^\\d+(\\-\\d+)?(,?\\d+(\\-\\d+)?)*$")
		String[] hourNumList = hour.split(",");
		for (int i = 0; i < hourNumList.length; i++) {
			if (hourNumList[i].matches("^\\d+$")) {
				int hourNum = Integer.parseInt(hourNumList[i]);
				if (hourNum < 0 || hourNum > 23) {
					return false;
				}
			} else if (hourNumList[i].matches("^\\d+\\-\\d+$")) {
				int beginHour = Integer
						.parseInt((hourNumList[i].split("-"))[0]);
				int endHour = Integer.parseInt((hourNumList[i].split("-"))[1]);
				if (beginHour < 0 || beginHour > 23 || endHour < 0
						|| endHour > 23) {
					return false;
				}
				if (beginHour >= endHour) {
					return false;
				}
			} else {
				return false;
			}
		}
		if (hourNumList.length != 0) {
			return true;
		}
		return false;
	}
	/*
	 * get DdrScheduleBean in formbean for displaying.
	 */
	public static DdrScheduleBean cron2Ddr(String infoLine){
    	DdrScheduleBean dsi = new DdrScheduleBean();
     	infoLine = infoLine.trim();
     	//default input status if infoLine is ""
     	if(infoLine.equals("")){
     		return dsi;
     	}
     	//get the time string of cron
     	String[] timeInfo = infoLine.split("\\s+");
     	if(timeInfo.length==5 && isMinuteValid(timeInfo[0]) && isHourValid(timeInfo[1])){
            if(timeInfo[2].equals("*") && timeInfo[3].equals("*")
     	            && isDayValid(timeInfo[4])){
     	    	setWeekdayByCron(timeInfo[4],dsi);
     	        dsi.setTimeset("indirectEdit");
     	        dsi.setDay("weekday");
                dsi.setMinute(timeInfo[0]);
     	        dsi.setHour(timeInfo[1]);
     	    }else if(timeInfo[3].equals("*") && timeInfo[4].equals("*")
     	            && isMonthDayValid(timeInfo[2])){
                dsi.setMonthday(timeInfo[2]);
     	        dsi.setTimeset("indirectEdit");
     	        dsi.setDay("monthday");
                dsi.setMinute(timeInfo[0]);
     	        dsi.setHour(timeInfo[1]);
       	    }else if(timeInfo[2].equals("*") && timeInfo[3].equals("*")
       	                && timeInfo[4].equals("*")){
     	        dsi.setTimeset("indirectEdit");
    	        dsi.setDay("daily");
                dsi.setMinute(timeInfo[0]);
     	        dsi.setHour(timeInfo[1]);
     	    }else{
             	dsi.setDirectedit(infoLine);
     	        dsi.setTimeset("directedit");
                dsi.setMinute("");
     	        dsi.setHour("");
     	    }
     	}else{
         	dsi.setDirectedit(infoLine);
         	dsi.setTimeset("directedit");
            dsi.setMinute("");
 	        dsi.setHour("");
     	}
     	return dsi;
    }

	/*
	 * get cron string from DdrScheduleBean in formbean for setting cron file.
	 */
    public static String ddr2Cron(DdrScheduleBean dsi){
    	String schedule = "";
    	int period = getPeriod(dsi);
		switch (period) {
			case DDR_CRON_PERIOD_WEEKDAY:
				schedule = dsi.getMinute() + " " + dsi.getHour() + " * * "
						+ getWeekdayCron(dsi);
				break;
			case DDR_CRON_PERIOD_MONTHDAY:
				schedule = dsi.getMinute() + " " + dsi.getHour() + " "
						+ dsi.getMonthday() + " * *";
				break;
			case DDR_CRON_PERIOD_DAILY:
				schedule = dsi.getMinute() + " " + dsi.getHour() + " * * *";
				break;
			case DDR_CRON_PERIOD_DIRECT:
				schedule = dsi.getDirectedit();
				break;
		}
		return schedule;
	}

    //get weekday of cron string by weekdays array property in DdrScheduleBean.
	private static String getWeekdayCron(DdrScheduleBean dsi){
		return ScheduleUtil.joinArray2String(dsi.getWeekday(),",");
 	}

    //set weekdays array property in DdrScheduleBean by weekday of cron string.
	private static void setWeekdayByCron(String paramWeekdayCron,DdrScheduleBean dsi){
		String[] strs= paramWeekdayCron.split(",");
		for(int i=0;i<strs.length;i++){
			int day=Integer.parseInt(strs[i]);
      		dsi.setWeekday(day,String.valueOf(day));
      	}
	}
	
	//single quote weekdays array property  
	public static String getQuotedCronTime(String timeStr){
		String[] times = timeStr.split("\\s+");
  		for(int i=0;i<times.length;i++){
  			times[i] = "'"+ times[i]+"'";
  		}
  		return ScheduleUtil.joinArray2String(times," ");
	}

	public static int getPeriod(DdrScheduleBean dsi){
		if(dsi.getTimeset().equals("indirectEdit")){
			String day = dsi.getDay();
      		if(day.equals("weekday")){
      			return DDR_CRON_PERIOD_WEEKDAY;
      		}else if(day.equals("monthday")){
      			return DDR_CRON_PERIOD_MONTHDAY;
      		}else if(day.equals("daily")){
      			return DDR_CRON_PERIOD_DAILY;
      		}
		}
      	return DDR_CRON_PERIOD_DIRECT;
	}
}