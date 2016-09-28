/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

/**
 *
 */

public class TimeInfoBean{
    private static final String cvsid =
            "@(#) $Id: TimeInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
            
    private String      flag;

    private int         year;
    private int         month;
    private int         day;
    private int         hour;
    private int         minute;
    private int         second;

    private String      time;
    private String      timeUnit;

    /**
     * @return
     */
    public int getDay() {
        return day;
    }

    /**
     * @return
     */
    public String getFlag() {
        return flag;
    }

    /**
     * @return
     */
    public int getHour() {
        return hour;
    }

    /**
     * @return
     */
    public int getMinute() {
        return minute;
    }

    /**
     * @return
     */
    public int getMonth() {
        return month;
    }

    /**
     * @return
     */
    public int getSecond() {
        return second;
    }

    /**
     * @return
     */
    public String getTime() {
        return time;
    }

    /**
     * @return
     */
    public String getTimeUnit() {
        return timeUnit;
    }

    /**
     * @return
     */
    public int getYear() {
        return year;
    }

    /**
     * @param i
     */
    public void setDay(int i) {
        day = i;
    }

    /**
     * @param string
     */
    public void setFlag(String string) {
        flag = string;
    }

    /**
     * @param i
     */
    public void setHour(int i) {
        hour = i;
    }

    /**
     * @param i
     */
    public void setMinute(int i) {
        minute = i;
    }

    /**
     * @param i
     */
    public void setMonth(int i) {
        month = i;
    }

    /**
     * @param i
     */
    public void setSecond(int i) {
        second = i;
    }

    /**
     * @param string
     */
    public void setTime(String string) {
        time = string;
    }

    /**
     * @param string
     */
    public void setTimeUnit(String string) {
        timeUnit = string;
    }

    /**
     * @param i
     */
    public void setYear(int i) {
        year = i;
    }

}