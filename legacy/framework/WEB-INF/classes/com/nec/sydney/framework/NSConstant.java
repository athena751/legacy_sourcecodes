/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.framework;

import  javax.servlet.*;

public class NSConstant {
	private static final String	cvsid = "@(#) $Id: NSConstant.java,v 1.2305 2005/10/19 01:38:46 fengmh Exp $";
	public static NSConstant	getInstance() {
		if (_instance == null)
			_instance = new NSConstant();
		return _instance;
	}
	public void	init(FilterConfig config) {
		/* initliaze absolute directories on the System */
		HomeDirectory = config.getInitParameter("home");
		if (HomeDirectory == null) 
			HomeDirectory = System.getProperty("user.home");
		SoapServices = HomeDirectory + "/services";
		MenuConfigs = HomeDirectory + "/etc/menu-config";
		Log4JConfigFile = config.getInitParameter("log4j-cfg");
		if (Log4JConfigFile == null) 
			Log4JConfigFile = HomeDirectory + "/etc/report.cfg";
		/* initialize Web application pathes */
		ConfigRootPath = config.getInitParameter("alias");
		if (ConfigRootPath == null)
			ConfigRootPath = "/nsadmin";
		DefaultCSS = ConfigRootPath + "/lib/default.css";
		LoginURI = config.getInitParameter("loginURI");
                if (LoginURI == null)
                        LoginURI = "/framework/loginShow.do";
		RELOGIN_PAGE = "/relogin.jsp";
		FOLDER_CLOSED_ICON = ConfigRootPath + "/images/icon/png/c_triangle.png";
		FOLDER_OPEN_ICON = ConfigRootPath + "/images/icon/png/o_triangle.png";
	}
	private NSConstant()	{ /* nothing to do */ }
	private static NSConstant	_instance = null;
	public void    setMytimeout() {
		int     DEFAULT = 10 * 60;      /* 10 minutes */
		int	MIN = 5 * 60;           /* 5 minutes */
		int     MAX = 6 * 60 * 60;      /* 6 hours */

		String  pval = System.getProperty("nsgui.timeout");
		NSReporter.getInstance().report(NSReporter.DEBUG,
						"nsgui.timeout: "+pval);
		if (pval == null) {
			NSGUI_TIMEOUT = DEFAULT;
			return;
		}
		int     ival;
		try {
			ival = Integer.parseInt(pval) * 60;
		} catch (Exception e) {
			ival = DEFAULT;
		}
		if (ival < MIN || ival > MAX) 
			ival = DEFAULT;
		NSGUI_TIMEOUT = ival;
		return;
	}
	public static String	ConfigRootPath = null;
	public static String	HomeDirectory = null;
	public static String	DefaultCSS = null;
	public static String	SoapServices = null;
	public static String	Log4JConfigFile = null;
	public static String	MenuConfigs = null;
	public static String	LoginURI = null;
	public static String	RELOGIN_PAGE = null;
	public static final String	MAIN_PAGE = "main.html";
	public static final String	MENUS_DIR = "menu";
	public static final String	FORM_ORIGINALURI = "orignalURI";
	public static final String	FORM_USERNAME = "username";
	public static final String	FORM_PASSWORD = "_password";
	public static final String	FORM_LANG = "lang";
	public static final String	FORM_HREF = "href";
	public static final String	FORM_FORWARD = "forward";
	public static final String	FORM_ID = "id";
	public static final String	FORM_MENU_RELOAD = "menureload";
	public static final String	LOGIN_PAGE = "login.jsp";
	public static final String	SESSION_AUTHENTICATED = "authenticated";
	public static final String	SESSION_USERINFO = "userinfo";
	public static final String	SESSION_LANG = "lang";
	public static final String	SESSION_REASON = "reason";
	public static final String	SESSION_BROWSER = "browser";
	public static final String	SESSION_REMOTEADDR = "remoteaddr";
	public static final String	SESSION_OTHERS = "othersessions";
	public static final String	SESSION_ISNASHEAD = "isnashead";
	public static final int		MAX_INACTIVE_INTERVAL = 600;
	public static final String	SEPERATOR_CLUSTER = "/";
	public static final String	SEPERATOR_TYPE = "@";
	public static String	FOLDER_CLOSED_ICON = null;
	public static String	FOLDER_OPEN_ICON = null;
	public static int	NSGUI_TIMEOUT = MAX_INACTIVE_INTERVAL;
	public static String	BROWER_NS47 = "Mozilla/4.7";
    public static final String    USER_NAME_NSAMDIN = "nsadmin";
    public static final String    USER_NAME_NSVIEW = "nsview";
}
