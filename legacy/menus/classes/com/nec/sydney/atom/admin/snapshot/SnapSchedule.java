/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.snapshot;



public class SnapSchedule implements Comparable

{


    private static final String     cvsid = "@(#) $Id: SnapSchedule.java,v 1.2303 2007/05/30 09:57:15 liy Exp $";

    //subitems of SnapSchedule

    //The member variable mountPoint and deviceName are the actual mountpoint or devicename . Their values
    //can't be trusted . 
    private String mountPoint,deviceName,scheduleName,generation,
                   day,hour,minute,directEditInfo;
    private int period;

    //constructor
    public SnapSchedule(){
        mountPoint      = "";
        deviceName	= "";
        scheduleName    = "";
        generation      = "";
        day             = "";
        hour            = "";
        minute          = "";
        period          = 0;
    }

    //some GET methods
    public String getMountPoint(){
        return mountPoint;
    }
    public String getDeviceName(){
        return deviceName;
    }
    public String getScheduleName(){
        return scheduleName;
    }
    public String getGeneration(){
        return generation;
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

    //some SET
    public void setMountPoint(String paramMP){
        mountPoint      = paramMP;
    }
    public void setDeviceName(String paramDN){
        deviceName      = paramDN;
    }
    public void setScheduleName(String paramSN){
        scheduleName    = paramSN;
    }
    public void setGeneration(String paramGen){
        generation = paramGen;
    }
    public void setPeriod(int paramPeriod){
        period          = paramPeriod;
    }
    public void setDay(String paramDay){
        day             = paramDay;
    }
    public void setMinute(String paramMinute){
        minute          = paramMinute;
    }
    public void setHour(String paramHour){
        hour            = paramHour;
    }
    public void setDirectEditInfo(String paramDirectEditInfo){
        directEditInfo = paramDirectEditInfo;
    }

    //compare the double objects of SnapSchedule
    public int compareTo (Object i_ss){
        String i_sn    = ((SnapSchedule)i_ss).getScheduleName();
        return (scheduleName.compareTo(i_sn)<0? -1:(scheduleName.compareTo(i_sn) == 0? 0 :1));
    }
}
