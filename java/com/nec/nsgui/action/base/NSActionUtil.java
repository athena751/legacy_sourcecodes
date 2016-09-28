/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.base;

import java.text.DateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Locale;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.Globals;
import java.io.*;

import com.nec.nsgui.model.biz.base.NSModelUtil;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
/**
 *
 */
public class NSActionUtil implements NSActionConst {
    public static final String cvsid =
        "@(#) $Id: NSActionUtil.java,v 1.43 2008/04/26 06:45:24 pizb Exp $";

    /**
     * Get the machine type.
     * @param request
     * @return success - "Single"|"NasCluster"|"NasheadCluster"|"NasheadSingle"|"OneNodeSirius"
     *         errors - "ErrorMachineType"
     */
    public static String getMachineType(HttpServletRequest request) {
        String machineType =
            (String) request.getSession().getAttribute(SESSION_MACHINE_TYPE);
        return (machineType == null)
            ? MACHINE_TYPE_ERRORMACHINETYPE
            : machineType;
    }

    /**
     * Judge the machine type (cluster or not) according to the session.
     * @param request
     * @return true -- "NasCluster"|"NasheadCluster"|"OneNodeSirius"|"ErrorMachineType"
     *         false -- "Single"|"NasheadSingle"
     */
    public static boolean isCluster(HttpServletRequest request) {
        String machineType = getMachineType(request);
        if (machineType.equals(MACHINE_TYPE_SINGLE)
            || machineType.equals(MACHINE_TYPE_NASHEADSINGLE)) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * Judge the machine type (nashead or not) according to the session.
     * @param request
     * @return true -- "NasheadSingle"|"NasheadCluster"
     *         false -- "Single"|"NasCluster"|"OneNodeSirius"|"ErrorMachineType"
     */
    public static boolean isNashead(HttpServletRequest request) {
        String machineType = getMachineType(request);
        if (machineType.equals(MACHINE_TYPE_NASHEADCLUSTER)
            || machineType.equals(MACHINE_TYPE_NASHEADSINGLE)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Judge the machine type (OneNodeSirius or not) according to the session.
     * @param request
     * @return true -- "OneNodeSirius"
     *         false -- "Single"|"NasCluster"|"NasheadSingle"|"NasheadCluster"|"ErrorMachineType"
     */
    public static boolean isOneNodeSirius(HttpServletRequest request) {
        return getMachineType(request).equals(MACHINE_TYPE_ONENODESIRIUS);
    }

    /**
     * Judge the machine type (singleNode or not) according to the session.
     * @param request
     * @return false -- "NasCluster"|"NasheadCluster"|"ErrorMachineType"
     *         true -- "Single"|"NasheadSingle"|"OneNodeSirius"
     */
    public static boolean isSingleNode(HttpServletRequest request) {
        String machineType = getMachineType(request);
        if (machineType.equals(MACHINE_TYPE_SINGLE)
            || machineType.equals(MACHINE_TYPE_NASHEADSINGLE)
            || machineType.equals(MACHINE_TYPE_ONENODESIRIUS)) {
            return true;
        } else {
            return false;
        }
    }


    /**
     * Get export group path in session according to node number
     * @param request
     * @return 
     *      - if have return export group path (example: /export/public)
     *      - else return "";    
     */
    public static String getExportGroupPath(HttpServletRequest request) {
        int nodeNo = getCurrentNodeNo(request);
        if (nodeNo == -1) {
            return "";
        }
        String expgrpPath =
            (String) request.getSession().getAttribute(
                SESSION_EXPORTGROUP_PATH + nodeNo);
        return (expgrpPath == null) ? "" : expgrpPath;
    }

    /**
     * return current encoding of export group.("EUC-JP", "SJIS", "English", "UTF-8"); 
     * @param request
     * @return
     *       - if the export is exist return the encoding of it.
     *       - else return "";
     */
    public static String getExportGroupEncoding(HttpServletRequest request) {
        int nodeNo = getCurrentNodeNo(request);
        if (nodeNo == -1) {
            return "";
        }
        String expgrpEncoding =
            (String) request.getSession().getAttribute(
                SESSION_EXPORTGROUP_ENCODING + nodeNo);
        return (expgrpEncoding == null) ? "" : expgrpEncoding;
    }

    /**
     * Get current node number in session .
     * @param request
     * @return
     *       - if have return node number as int format
     *       - else return -1
     */
    public static int getCurrentNodeNo(HttpServletRequest request) {
        String nodeNo =
            (String) request.getSession().getAttribute(SESSION_NODE_NUMBER);
        return (nodeNo == null) ? -1 : Integer.parseInt(nodeNo);
    }

    /**
     * Get current language.
     * @param request
     * @return
     *       - "en" or "ja"
     */
    public static String getCurrentLang(HttpServletRequest request) {
        Locale locale =
            (Locale) request.getSession().getAttribute(Globals.LOCALE_KEY);
        if (locale == null) {
            locale = request.getLocale();
        }
        String language = LANGUAGE_ENGLISH;
        if (locale
            .getLanguage()
            .equals(new Locale(LANGUAGE_JAPANESE, "", "").getLanguage())) {
            language = LANGUAGE_JAPANESE;
        }
        return language;
    }

    /**
     * replace &, <, >, ", ' to &amp; &lt; &gt; &quot; &#39;
     * @param the charactors which will be displayed in the web page
     * @return
     *       - "en" or "ja"
     */
    static public String sanitize(String str) {
        return sanitize(str, true);
    }

    // sanitizing
    // flag = true : replace '&', '<', '>', '"', ''', ' '
    //        false: replace '&', '<', '>', '"', '''
    static public String sanitize(String str, boolean flag) {
        str =
            str.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(
                ">",
                "&gt;");
        str = str.replaceAll("\"", "&quot;").replaceAll("'", "&#39;");
        if (flag) {
            str = str.replaceAll("\\s", "&nbsp;");
        }
        return str;
    }
    
    //2005-1-14 liq add for display a string in html
    // replace '&', '<', '>', '"', '''
    //         \t,\n,\s
    static public String htmlSanitize(String str) {
        str = sanitize(str, false);
        str = str.replaceAll("\n", "<br>");
        str = str.replaceAll("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
        str = str.replaceAll("\\s", "&nbsp;");
        return str;
    }

    
    /* convert the request string to encode String */
    public static String reqStr2EncodeStr(String reqStr, String destEncode)
        throws Exception {
        String systemEncode = System.getProperty("file.encoding");
        if (systemEncode.equalsIgnoreCase(destEncode)) {
            return reqStr;
        }

        return new String(reqStr.getBytes(systemEncode), destEncode);
    }
    //encoding is the exportroot code.
    public static String page2Perl(
        String pageStr,
        String encoding,
        String browseCoding)
        throws Exception {

        if (encoding.equalsIgnoreCase(browseCoding)) {
            return new String(pageStr);
        }
        encoding =
            (encoding.equals(ENCODING_English)) ? ENCODING_ISO8859_1 : encoding;
        encoding = (encoding.equals(ENCODING_SJIS)) ? ENCODING_MS932 : encoding;
        encoding = (encoding.equals(ENCODING_UTF_8_NFC)) ? ENCODING_UTF_8 : encoding;
        String euc_str = reqStr2EncodeStr(pageStr, browseCoding);
        String perl_str =
            new String(
                euc_str.getBytes(encoding),
                System.getProperty("file.encoding"));
        return perl_str;
    }

    public static String perl2Page(String perlStr, String encoding)
        throws Exception {
        encoding =
            (encoding.equals(ENCODING_English)) ? ENCODING_ISO8859_1 : encoding;
        encoding = (encoding.equals(ENCODING_SJIS)) ? ENCODING_MS932 : encoding;
        encoding = (encoding.equals(ENCODING_UTF_8_NFC)) ? ENCODING_UTF_8 : encoding;
        String Unicode_Str =
            new String(
                perlStr.getBytes(System.getProperty("file.encoding")),
                encoding);
        return Unicode_Str;
    }

    public static String page2Perl(String pageStr, HttpServletRequest request)
        throws Exception {
        String encoding = getExportGroupEncoding(request);
        return page2Perl(pageStr, encoding, BROWSER_ENCODE);
    }

    public static String perl2Page(String perlStr, HttpServletRequest request)
        throws Exception {
        String encoding = getExportGroupEncoding(request);
        return perl2Page(perlStr, encoding);
    }
    public static String getHexString(int dispLength, String str)
        throws Exception {
        String hexStr = "";
        try {
            hexStr = Integer.toHexString((new Integer(str)).intValue());
        } catch (Exception e) {
            return str;
        }
        StringBuffer sb = new StringBuffer();

        if (hexStr.length() < dispLength) {
            for (int i = 0; i < dispLength - hexStr.length(); i++) {
                sb.append("0");
            }
        }
        sb.append(hexStr);
        sb.append("h");
        return sb.toString();
    }
    static public void setSuccess(HttpServletRequest request) {
        request.getSession().setAttribute(
            NSActionConst.SESSION_SUCCESS_ALERT,
            "true");
    }
    /*
     * Add by zhangjun
     */
    public static void setNoFailedAlert(HttpServletRequest request){
        request.getSession().setAttribute(
                    NSActionConst.SESSION_NOFAILED_ALERT,
                    "true");
    }
    /*
     * Add by zhangjun
     */
    public static void setNotDisplayDetail(HttpServletRequest request){
        request.getSession().setAttribute(
                            NSActionConst.SESSION_NOT_DISPLAY_DETAIL,
                            "true");
    }
    
    /* convert the ascii string to hard bytes string */
    public static String ascii2hStr(String asciiStr)throws Exception {
        
        StringBuffer destBuffer = new StringBuffer(asciiStr.length() * 4);
        byte[] asciiBytes = asciiStr.getBytes();

        for (int i = 0; i < asciiBytes.length; i++) {
            destBuffer.append("0x").append(Integer.toHexString(asciiBytes[i]));             
        }
        
        return destBuffer.toString();
    }

    static public String[] getLocalDate_Time(String year, String month, String day, 
            String hour, String minute, String second, HttpServletRequest request){
        
        GregorianCalendar gc = new GregorianCalendar(Integer.parseInt(year), NSModelUtil.getMonthInt(month) 
                                , Integer.parseInt(day), Integer.parseInt(hour), Integer.parseInt(minute)
                                , Integer.parseInt(second));
        Date theDate = gc.getTime();
            
        Locale locale = request.getLocale();
        DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM , locale);
            
        String theDateString = df.format(theDate);  
        df = DateFormat.getTimeInstance(DateFormat.MEDIUM , locale);
        String theTimeString = df.format(theDate);
        String[] date_time = {theDateString, theTimeString};
        return date_time;
    }

    static public String[] getLocalDate_Time(String dateString, 
                        String timeString, HttpServletRequest request){
        String[] dateInfo = dateString.trim().split("\\s+");
        String[] timeInfo = timeString.split(":");
        return getLocalDate_Time(dateInfo[0], dateInfo[1], dateInfo[2], 
                                 timeInfo[0], timeInfo[1], timeInfo[2], request);
    }
  
    /**
     * getLocalDateTime:change to local datetime
     * 
     * @param year
     * @param month
     * @param day
     * @param hour
     * @param minute
     * @param second
     * @param request
     * @return String[]
     *           [0]:date string
     *           [1]:time string
     */
    public static String[] getLocalDateTime(String year, String month, String day, 
            String hour, String minute, String second, HttpServletRequest request){
        
        GregorianCalendar gc = 
            new GregorianCalendar(
                    Integer.parseInt(year), 
                    Integer.parseInt(month) - 1, 
                    Integer.parseInt(day), 
                    Integer.parseInt(hour), 
                    Integer.parseInt(minute), 
                    Integer.parseInt(second));

        Date theDate = gc.getTime();            
        Locale locale = request.getLocale();
        DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM , locale);            
        String theDateString = df.format(theDate);  
        df = DateFormat.getTimeInstance(DateFormat.MEDIUM , locale);
        String theTimeString = df.format(theDate);

        String[] date_time = {theDateString, theTimeString};
        return date_time;
    }

    /**
     * getLocalDateTimeStr:
     *     separate input string,
     *     call method 'getLocalDateTime(String,String,String,String,String,String,HttpServletRequest'
     * 
     * @param dateTimeString
     * @param dateSeparate:separator between year,month,day
     * @param timeSeparate:separator between hour,minute,second
     * @param dtSeparate:separator between datestring and timestring
     * @param request
     * @return String:datetime string
     */
    public static String getLocalDateTimeStr(
        String dateTimeString,
        String dateSeparate,
        String timeSeparate,
        String dtSeparate,
        HttpServletRequest request){
        
        if (null == dateTimeString || "".equals(dateTimeString)) {
            return dateTimeString;
        }
        if (null == dateSeparate || "".equals(dateSeparate)) {
            return dateTimeString;
        }
        if (null == timeSeparate || "".equals(timeSeparate)) {
            return dateTimeString;
        }
        if (null == dtSeparate || "".equals(dtSeparate)) {
            return dateTimeString;
        }
        
        String[] dateTimeArrs = dateTimeString.trim().split(dtSeparate);
        if (2 != dateTimeArrs.length) {
            return dateTimeString;
        }
        
        String[] dateInfo = dateTimeArrs[0].trim().split(dateSeparate);
        String[] timeInfo = dateTimeArrs[1].trim().split(timeSeparate);
        if (3 != dateInfo.length || 3 != timeInfo.length) {
            return dateTimeString;
        }
        dateTimeArrs = getLocalDateTime(dateInfo[0], dateInfo[1], dateInfo[2], 
                                 timeInfo[0], timeInfo[1], timeInfo[2], request);
        String dateTimeStr = dateTimeArrs[0] + dtSeparate + dateTimeArrs[1];
        return dateTimeStr;
    }

    /**
     * getLocalDateTimeStr:
     *     separate input string,
     *     call method 'getLocalDateTime(String,String,String,String,String,String,HttpServletRequest'
     * 
     * @param dateTimeString
     * @param request
     * @return String:datetime string
     */
    public static String getLocalDateTimeStr(
        String dateTimeString,
        HttpServletRequest request){

        return getLocalDateTimeStr(dateTimeString, "/", ":", " ", request);
    }
    
    /**
     * Set attribute of session
     * @param request - http servlet request
     * @param name - name of session attribute
     * @param value - value of session attribute
     */
    static public void setSessionAttribute(
        HttpServletRequest request,
        String name,
        Object value) {
        HashSet sessionContainer = getSessionContainer(request);
        HttpSession session = request.getSession();
        sessionContainer.add(name);
        session.setAttribute(name, value);
    }
    /**
     * Get the value of special attribute
     * @param request - http servlet request
     * @param name - name of session attribute
     * @return value of session attribute
     */
    static public Object getSessionAttribute(
        HttpServletRequest request,
        String name) {
        return request.getSession().getAttribute(name);
    }
    /**
     * Remove an attribute of session
     * @param request - http servlet request
     * @param name - name of session attribute
     * @return value of session attribute removed
     */
    static public Object removeSessionAttribute(
        HttpServletRequest request,
        String name) {
        HashSet sessionContainer = getSessionContainer(request);
        HttpSession session = request.getSession();
        Object value = session.getAttribute(name);
        session.setAttribute(name, null);
        sessionContainer.remove(name);
        return value;
    }
    /**
     * Invalidate all session attribute in container 
     * @param request - http servlet request 
     */
    static public void clearSession4NAS(HttpServletRequest request) {
        HashSet sessionContainer = getSessionContainer(request);
        HttpSession session = request.getSession();
        Iterator names = sessionContainer.iterator();
        while (names.hasNext()) {
            String name = (String) names.next();
            session.setAttribute(name, null);
        }
        sessionContainer.clear();
    }
    /**
     * Get session container
     * @param request - http servlet request
     * @return container of session
     */
    static private HashSet getSessionContainer(HttpServletRequest request) {
        HttpSession session = request.getSession();
        HashSet sessionContainer =
            (HashSet) session.getAttribute(SESSION_ATTRIBUTE_CONTAINER);
        if (sessionContainer == null) {
            sessionContainer = new HashSet();
            session.setAttribute(SESSION_ATTRIBUTE_CONTAINER, sessionContainer);
        }
        return sessionContainer;
    }
    /**
     * @param request
     * @return
     * @throws Exception
     */
    public static String getCurUserName(HttpServletRequest request) throws Exception{
        String userName = (String) request.getSession().getAttribute(SESSION_USERINFO);
        return userName;
    }

    /**
     * @param request
     * @return
     * @throws Exception
     */
    public static boolean isNsview(HttpServletRequest request) throws Exception{
        return ((String)request.getSession().getAttribute(SESSION_USERINFO)).equals(USER_NSVIEW);
    }
    
    /**
     * @param date
     * @param locale
     * @return
     * @throws Exception
     */
    public static String date2Str(Date date, Locale locale)throws Exception{
        DateFormat df = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM, locale);
        String str = df.format(date);  
        return str;
    }
    /*
     *  @param key:the message's key
     *  @param encoding: the client browser's language
     *  @return the message's value
     *  @throws Exception
     *  added by dengyp
     */

    public static String getMessage(
        String fileName,
        String key,
        String encoding)
        throws Exception {

        //open file get find message's value    
        File file = new File(fileName);
        if (!file.isFile() || !file.canRead()) {
            return null;
        }
        FileInputStream fileStream = new FileInputStream(file);
        BufferedReader bufferReader =
            new BufferedReader(new InputStreamReader(fileStream, encoding));
        String line = null;
        while ((line = bufferReader.readLine()) != null) {
            String tmp[] = line.split("=");
            if (tmp.length >= 2 && tmp[0].trim().equals(key)) {
                tmp[1] = tmp[1].trim();                
                if ((tmp[1].startsWith("\"") && tmp[1].endsWith("\""))
                    || (tmp[1].startsWith("'") && tmp[1].endsWith("'"))) {
                    tmp[1] = tmp[1].substring(1, tmp[1].length() - 1);
                }
                tmp[1] = sanitize(tmp[1]);
                bufferReader.close();
                return tmp[1];
            }
        }
        bufferReader.close();
        return null;
    }
    /**
     * added by dengyp 2005/05/18 for multiple user login.
     */
    public static String getLang(HttpSession sess) {
        if (sess != null
            && sess.getAttribute(Globals.LOCALE_KEY) != null) {
            Locale locale =
                (Locale) sess.getAttribute(Globals.LOCALE_KEY);
            return locale.getLanguage().equals(
                (new Locale("ja", "", "")).getLanguage())
                ? "ja"
                : "en";
        } else {
            return "en"; // for old component that not yet been strutsed.
        }
    }
    /* convert the bytes array to hard hex String ,the format of the hard bytes string is "0xnn0xnn..." */ 
    public static String bytes2hStr(byte[] byteArray) throws Exception {
    
        StringBuffer hexBuffer = new StringBuffer(byteArray.length * 4);

        for (int i = 0; i < byteArray.length; i++) {
            hexBuffer.append("0x");
            int byteValue = (int) byteArray[i] & 0xff;
            String hexStr = Integer.toHexString(byteValue);

            if (hexStr.length() < 2) {
                hexBuffer.append("0").append(hexStr);
            } else {
                hexBuffer.append(hexStr);
            }
        }
        
        return hexBuffer.toString();
    }
    /* convert the hard bytes string to byte array,the format of the hard bytes string is "0xnn0xnn..." */ 
    //add by zhangjun
    public static byte[] hStr2Bytes(String hStr) throws Exception {
        int len = hStr.length() / 4;
        byte[] rstBytes = new byte[len];
        int start = 0;
        for (int i = 0; i < len; i++) {
            rstBytes[i] = Integer.decode(hStr.substring(start, start + 4)).byteValue();
            start += 4;
        }
        return rstBytes;
    }
    /* convert hard bytes string to encode string */
    //add by zhangjun
    public static String hStr2Str(String hStr, String srcEncode)throws Exception {
        srcEncode  = (srcEncode.equals(ENCODING_English)) ? ENCODING_ISO8859_1 : srcEncode;
        srcEncode  = (srcEncode.equals(ENCODING_SJIS)) ? ENCODING_MS932 : srcEncode;
        srcEncode = (srcEncode.equals(ENCODING_UTF_8_NFC)) ? ENCODING_UTF_8 : srcEncode;
        return new String(hStr2Bytes(hStr), srcEncode);
    }
    /* convert String to hard hex String */
    public static String str2hStr(String srcStr, String encoding) throws Exception {
        encoding = encoding.equalsIgnoreCase(ENCODING_English) ? ENCODING_EUC_JP : encoding;
        encoding = (encoding.equals(ENCODING_UTF_8_NFC)) ? ENCODING_UTF_8 : encoding;
        return bytes2hStr(srcStr.getBytes(encoding));
    }

    public static boolean hasAsyncVolume(HttpServletRequest request) throws Exception {
        String[] asyncInfo = VolumeHandler.getAsyncInfo();
        return (asyncInfo.length > 0 );
    }

    private final static String ASYNC_NO_ERROR = "0x00000000";
        
    public static boolean hasActiveAsyncVolume(HttpServletRequest request) throws Exception {
        if( hasActiveBatchVolume(request) ){
            return true;
        }
        
        String[] asyncInfo = VolumeHandler.getAsyncInfo();
        for(int i=0; i<asyncInfo.length;i++){
            if(asyncInfo[i].trim().endsWith(ASYNC_NO_ERROR)){
                return true;
            }
        }
        
        return false;
    }
    
    public static boolean hasActiveBatchVolume(HttpServletRequest request) throws Exception {
        ServletContext application = request.getSession().getServletContext();
        String statusString = (String)application.getAttribute(APPLICATION_VOLUME_PROCESS);
    
        if(statusString!=null){
            return true;
        }
        
        return false;
    }
    
    public static boolean isProcyon(HttpServletRequest request) {
        String machineSeries = (String) request.getSession().getAttribute(FrameworkConst.SESSION_MACHINE_SERIES);    
        if (machineSeries.equals(FrameworkConst.MACHINE_SERIES_PROCYON)){
            return true;
        }else return false;
    }
    public static boolean isCallisto(HttpServletRequest request) {
        String machineSeries = (String) request.getSession().getAttribute(FrameworkConst.SESSION_MACHINE_SERIES);    
        if (machineSeries.equals(FrameworkConst.MACHINE_SERIES_CALLISTO)){
            return true;
        }else return false;
    }
    public static boolean hasAsyncPair(HttpServletRequest request) throws Exception {
        String[] asyncPairInfo = DdrHandler.getAsyncPairInfo();
        return (asyncPairInfo.length > 0 );
    }
    private final static String ASYNC_PAIR_OPERATING = "0x137f0000";
    public static boolean hasActiveAsyncPair(HttpServletRequest request) throws Exception {
        String[] asyncPairInfo = DdrHandler.getAsyncPairInfo();
        for(int i=0; i<asyncPairInfo.length;i++){
            if(asyncPairInfo[i].trim().endsWith(ASYNC_PAIR_OPERATING)){
                return true;
            }
        }
        return false;
    }
}
