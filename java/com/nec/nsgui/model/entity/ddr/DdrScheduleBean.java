/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.ddr;

public class DdrScheduleBean {
    private static final String     cvsid = "@(#) $Id: DdrScheduleBean.java,v 1.1 2008/04/19 10:02:53 liuyq Exp $";

    private String monthday,directedit;
    private String hour = "0";
    private String minute = "0";
    private String timeset = "indirectEdit";
    private String day = "weekday";
    private String[] weekday = new String[7];
    
    public String getMonthday(){
        return monthday;
    }
    public String getHour(){
        return hour;
    }
    public String getMinute(){
        return minute;
    }
    public String getDirectedit(){
        return directedit;
    }
    public String getTimeset(){
    	return timeset;
    } 
    public String getDay(){
    	return day;
    }
    
    public void setMonthday(String paramMonthday){
    	monthday = paramMonthday;
    }
    public void setHour(String paramHour){
    	hour = paramHour;
    }
    public void setMinute(String paramMin){
    	minute = paramMin;
    }
    public void setDirectedit(String directEditInfo){
        this.directedit = directEditInfo;
    }
    public void setTimeset(String paraTimeset){
    	this.timeset = paraTimeset;
    }
    public void setDay(String paraDay){
    	this.day = paraDay;
    }
    public String[] getWeekday() {
        return weekday;
    }
    public void setWeekday(String[] weekday) {
        this.weekday = weekday;
    }
    public void setWeekday(int i ,String weekday) {
        this.weekday[i] = weekday;
    }
}
