/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.base;

import  org.apache.log4j.*;


public class NSReporter { 
    private static final String cvsid = "@(#) $Id: NSReporter.java,v 1.2 2007/04/26 06:07:21 liul Exp $";
    protected   NSReporter() {
        cat = Logger.getLogger("com.nec.nsgui");
        config = null;
    }
    static private NSReporter   _instance = null;
    static public NSReporter    getInstance() {
        if (_instance == null) {
            _instance = new NSReporter();
        }
        return _instance;
    }
    /*
     * init() must be called from NSFilter.init() only once at boot-time.
     */
    public void init(String conf) {
        config = new String(conf);
        PropertyConfigurator.configure(config);
    }
    public void trace(String message) {
        String  msg;
        try {
            msg = new String(message.getBytes("EUC_JP"), "ISO8859_1");
        } catch (Exception ex) {
            msg = message;
        }
        report(cat, INFO, msg);
    }
    public void report(Category tempcat, int level, String message) {
        tempcat.log(Level.toLevel(level), message);
    }
    public void report(int level, String message) {
        String  msg;
        try {
            msg = new String(message.getBytes("EUC_JP"), "ISO8859_1");
        } catch (Exception ex) {
            msg = message;
        }
        cat.log(Level.toLevel(level), msg);
    }
    public void report(int level, NSException ex) {
        /*
         * NSException:message:detail
         */
        StringBuffer    msg = new StringBuffer("NSExeption:");
        msg.append(ex.getMessage());
        String  detail = ex.getDetail();
        if (detail != null) {
            msg.append(":" + detail);
        }
        report(Logger.getLogger(ex.getCategory()), level, msg.toString());
        Level    p = Level.toLevel(level);
        if (p.isGreaterOrEqual(Level.ERROR))
            trace("REPORT: "+msg.toString());
    }
    public void report(NSException ex) {
        report(ex.getReportLevel(), ex);
    }
    public  void    report(Throwable ex) {
        report(ERROR, ex.getMessage());
    }
    public boolean  isDebugEnabled() {
        return cat.isDebugEnabled();
    }
    private Logger    cat;
    private String      config;
    /* We wrapps Log4J. */
    public static int   DEBUG = org.apache.log4j.Level.DEBUG_INT;
    public static int   INFO = org.apache.log4j.Level.INFO_INT;
    public static int   WARN = org.apache.log4j.Level.WARN_INT;
    public static int   ERROR = org.apache.log4j.Level.ERROR_INT;
    public static int   FATAL = org.apache.log4j.Level.FATAL_INT;
}

