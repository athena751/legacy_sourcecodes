/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.atom.admin.ddr;

public class DdrScheduleInfo {
    private static final String     cvsid = "@(#) $Id: DdrScheduleInfo.java,v 1.2 2007/04/26 05:38:00 liy Exp $";

    private String action,syncMode,day,hour,minute,directEditInfo;
    private int period;
    
    public String getAction(){
        return action;
    }
    public String getSyncMode(){
        return syncMode;
    }
    public int getPeriod(){
        return period;
    }
    public String getDay(){
        return day;
    }
    public String getHour(){
        return hour;
    }
    public String getMinute(){
        return minute;
    }
    public String getDirectEditInfo(){
        return directEditInfo;
    }

    public void setAction(String action){
        this.action = action;
    }
    public void setSyncMode(String syncMode){
        this.syncMode = syncMode;
    }
    public void setPeriod(int paramPeriod){
        period = paramPeriod;
    }
    public void setDay(String paramDay){
        day = paramDay;
    }
    public void setHour(String paramHour){
        hour = paramHour;
    }
    public void setMinute(String paramMin){
        minute = paramMin;
    }
    public void setDirectEditInfo(String directEditInfo){
        this.directEditInfo = directEditInfo;
    }
}
