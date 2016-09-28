/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.Calendar;
import java.util.GregorianCalendar;

import com.nec.nsgui.model.entity.base.GrapherCalendar;
import com.nec.nsgui.model.biz.statis.RRDGraphDef;

/**
 *
 */
public class StatisActionCommon {
    public static final String cvsid 
            = "@(#) $Id: StatisActionCommon.java,v 1.3 2005/10/19 02:42:49 het Exp $";    
    static public String URLEncode(String value) {
        //Added by Yang Aihua
        char hexchars[] =
            {
                '0',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                'A',
                'B',
                'C',
                'D',
                'E',
                'F' };
        //define HEXadecimal charactors  
        int length = value.length();
        int result_length = length * 3 + 1;
        //create a temporary buffer to contain result                    
        StringBuffer resultBuff = new StringBuffer(result_length);

        int j = 0; //pointing to the last char in resultBuff         

        //begin to convert                                           
        for (int i = 0; i < length; i++) {
            char ch = value.charAt(i);
            //get a charactor from the string                                                            
            //a) convert ' ' to '+'                                                                                                   
            if (ch == ' ') {
                resultBuff.insert(j++, '+');
            }
            //b) if the current char is a letter or digit number , or it is one of '*'                                                
            //'-' '.' '_' ,copy it to the destination buffer (do not convert)                                                         
            else if (Character.isLetterOrDigit(ch)
                    || (ch == '*')
                    || (ch == '-')
                    || (ch == '.')
                    || (ch == '_')) {
                resultBuff.insert(j++, ch);
            }
            //c) convert other charactor to the form of  "%Hex"                                                                       
            else {
                resultBuff.insert(j++, '%');
                resultBuff.insert(j++, hexchars[ch >> 4]);
                resultBuff.insert(j++, hexchars[ch & 0x0F]);
            }
        } //end of  "for"   

        //return conversion result                                                                                                                                                                                                                   
        String resultStr = resultBuff.substring(0, j);
        return resultStr;

    } //end of URLEncode() 
    static public int convertInterval(String sTime, String sUnit)
            throws Exception {
            //convert String to int
            int iTime = Integer.parseInt(sTime);
            if (sUnit.equalsIgnoreCase(RRDGraphDef.MINUTES)) {
                return iTime * 60; //convert minutes to seconds     
            }
            if (sUnit.equalsIgnoreCase(RRDGraphDef.HOURS)) {
                return iTime * 3600; //convert hours to seconds            
            }
            return iTime;

        }
    static public int CurrYear() {
        Calendar rightnow = Calendar.getInstance();
        return rightnow.get(Calendar.YEAR);
    }
    static public int CurrMonth() {
        Calendar rightnow = Calendar.getInstance();
        int temp = rightnow.get(Calendar.MONTH) + 1;
        return temp;
    }
    static public int CurrDay() {
        Calendar rightnow = Calendar.getInstance();
        return rightnow.get(Calendar.DAY_OF_MONTH);
    }
    static public int CurrHour() {
        Calendar rightnow = Calendar.getInstance();
        return rightnow.get(Calendar.HOUR_OF_DAY);
    }
    static public int CurrMinute() {
        Calendar rightnow = Calendar.getInstance();
        return rightnow.get(Calendar.MINUTE);
    }
    static public int CurrSecond() {
        Calendar rightnow = Calendar.getInstance();
        return rightnow.get(Calendar.SECOND);
    }
    /**
       get the total seconds of now 
    */
    static public long CurrentTime() {
        return System.currentTimeMillis() / 1000;
    }

    /**
       judge the year whether is leap year
       if it is ,return true
       else return false
    */
    static public boolean isSpecialYear(int year) {
        return new GregorianCalendar().isLeapYear(year);
    }

    /**
       count the seconds which equals the relative time
       then return the result
    */
    static public long ChangeTime(String relTimeString, String unit) {

        int year = 0;
        int month = 0;
        GrapherCalendar graphTime = new GrapherCalendar();
        //Get the total seconds from 1970 to now
        long totalnow = CurrentTime();
        int relTime = Integer.parseInt(relTimeString);
        if (relTime <= 0) {
            relTime = 0;
        }

        if (unit.equalsIgnoreCase(RRDGraphDef.HOURS)) {
            return totalnow - relTime * 3600;
        } else if (unit.equalsIgnoreCase(RRDGraphDef.DAYS)) {
            return totalnow - relTime * 24 * 3600;
        } else if (unit.equalsIgnoreCase(RRDGraphDef.WEEKS)) {
            return totalnow - relTime * 7 * 24 * 3600;
        } else if (unit.equalsIgnoreCase(RRDGraphDef.MONTHS)) {
            //if the number of the relative months is bigger than 12 
            if (relTime > 12) {
                //first, minus the year
                year = CurrYear() - relTime / 12;
                //second,get the rest number  
                relTime = relTime % 12;
                //third,
                //if the rest equal the number of current month
                if (relTime == CurrMonth()) {
                    year--;
                    month = 12;
                } else if (relTime > CurrMonth()) {
                    //the rest is bigger than the current month number 
                    year--;
                    month = 12 + CurrMonth() - relTime;
                } else { //else the rest is smaller
                    month = CurrMonth() - relTime;
                }
            } else {
                //else the number is smaller than 12 or equal to 12
                if (relTime == CurrMonth()) {
                    year = CurrYear();
                    year--;
                    month = 12;
                } else if (relTime > CurrMonth()) {
                    year = CurrYear();
                    year--;
                    month = 12 + CurrMonth() - relTime;
                } else {
                    year = CurrYear();
                    month = CurrMonth() - relTime;
                }
            }
            // if now it is the end of a month
            if (31 == CurrDay()
                || (30 == CurrDay()
                    && (CurrMonth() == 4
                        || CurrMonth() == 6
                        || CurrMonth() == 9
                        || CurrMonth() == 11))
                || (29 == CurrDay() && CurrMonth() == 2)
                || (28 == CurrDay()
                    && (!isSpecialYear(year))
                    && CurrMonth() == 2)) {
                if (month == 4 || month == 6 || month == 9 || month == 11) {
                    graphTime.set(
                        year,
                        month - 1,
                        30,
                        CurrHour(),
                        CurrMinute(),
                        CurrSecond());
                    return graphTime.getMillis() / 1000;
                } else if (
                    month == 1
                        || month == 3
                        || month == 5
                        || month == 7
                        || month == 8
                        || month == 10
                        || month == 12) {
                    graphTime.set(
                        year,
                        month - 1,
                        31,
                        CurrHour(),
                        CurrMinute(),
                        CurrSecond());
                    return graphTime.getMillis() / 1000;
                } else if (isSpecialYear(year)) {
                    graphTime.set(
                        year,
                        1,
                        29,
                        CurrHour(),
                        CurrMinute(),
                        CurrSecond());
                    return graphTime.getMillis() / 1000;
                } else {
                    graphTime.set(
                        year,
                        1,
                        28,
                        CurrHour(),
                        CurrMinute(),
                        CurrSecond());
                    return graphTime.getMillis() / 1000;
                }
            }
            if (CurrMonth() != 2
                && CurrDay() == 29
                && month == 2
                && (!isSpecialYear(year))) {
                graphTime.set(
                    year,
                    1,
                    28,
                    CurrHour(),
                    CurrMinute(),
                    CurrSecond());
                return graphTime.getMillis() / 1000;
            }

            //accord the year and month get the total seconds
            graphTime.set(
                year,
                month - 1,
                CurrDay(),
                CurrHour(),
                CurrMinute(),
                CurrSecond());
            return graphTime.getMillis() / 1000;
        }
        //if unit is "Years"
        else if (unit.equalsIgnoreCase("years")) {
            graphTime.set(
                CurrYear() - relTime,
                CurrMonth() - 1,
                CurrDay(),
                CurrHour(),
                CurrMinute(),
                CurrSecond());
            return graphTime.getMillis() / 1000;
        } else {
            return -1;
        }
    }

}
