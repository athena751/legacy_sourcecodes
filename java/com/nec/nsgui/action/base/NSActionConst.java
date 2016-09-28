/*
 *      Copyright (c) 2007-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.base;

public interface NSActionConst {
    public static final String cvsid =
        "@(#) $Id: NSActionConst.java,v 1.36 2009/01/08 09:04:35 xingyh Exp $";
    public final static String SESSION_MACHINE_TYPE =
        "FRAMEWORK_SESSION_MACHINE_TYPE";
    public final static String SESSION_NODE_NUMBER =
        "FRAMEWORK_SESSION_NODE_NUMBER";
    public final static String SESSION_EXPORTGROUP_PATH =
        "FRAMEWORK_SESSION_EXPORTGROUP_PATH";
    public final static String SESSION_EXPORTGROUP_ENCODING =
        "FRAMEWORK_SESSION_EXPORTGROUP_ENCODING";
    public final static String SESSION_EXCEPTION_MESSAGE =
        "FRAMEWORK_SESSION_EXCEPTION_MESSAGE";
    public final static String SESSION_EXCEPTION_OBJECT =
        "FRAMEWORK_SESSION_EXCEPTION_OBJECT";
    public final static String SESSION_EXCEPTION_MESSAGE_DETAIL =
        "FRAMEWORK_SESSION_EXCEPTION_MESSAGE_DETAIL";
    public final static String DEFAULT_CSS_FILE_NAME =
        "/skin/default/default.css";
    public final static String CONFIG_FILE_SEPARATER = ",";
    public final static String LANGUAGE_ENGLISH = "en";
    public final static String LANGUAGE_JAPANESE = "ja";
    public static final String MACHINE_TYPE_SINGLE = "Single";
    public static final String MACHINE_TYPE_NASCLUSTER = "NasCluster";
    public static final String MACHINE_TYPE_NASHEADCLUSTER = "NasheadCluster";
    public static final String MACHINE_TYPE_NASHEADSINGLE = "NasheadSingle";
    public static final String MACHINE_TYPE_ONENODESIRIUS = "OneNodeSirius";
    public final static String APPLICATION_VOLUME_PROCESS = "VOLUME_APPLICATION_PROCESS";
    public static final String MACHINE_TYPE_ERRORMACHINETYPE =
        "ErrorMachineType";

    public static String BROWSER_ENCODE     = "UTF-8";
    public static String ENCODING_EUC_JP    = "EUC-JP";
    public static String ENCODING_SJIS      = "SJIS";
    public static String ENCODING_MS932     = "MS932";
    public static String ENCODING_English   = "English";
    public static String ENCODING_ISO8859_1 = "iso8859-1";
    public static String ENCODING_UTF_8     = "UTF-8";
    public static String ENCODING_UTF_8_NFC = "UTF8-NFC";
    
    public final static String SESSION_SUCCESS_ALERT =
        "FRAMEWORK_SESSION_SUCCESS_ALERT";
    public final static String SESSION_NOFAILED_ALERT =
        "FRAMEWORK_SESSION_NOFAILED_ALERT";
    public final static String SESSION_NOT_DISPLAY_DETAIL =
        "FRAMEWORK_SESSION_NOT_DISPLAY_DETAIL";
    
    public final static String SESSION_OPERATION_RESULT_MESSAGE =
        "FRAMEWORK_SESSION_OPERATION_RESULT_MESSAGE";
    public final static String SUCCESS_ALERT_KEY = "common.alert.done";
    public final static String FAILED_ALERT_KEY = "common.alert.failed";
    public final static String PATH_OF_CHECKED_GIF = "/nsadmin/images/nation/check.gif";
    public final static String PATH_OF_TIMEOUT_CONF = "/home/nsadmin/etc/properties/timeout.conf";


    public final static String CONFIG_ROOT_PATH = "/nsadmin";
    
    public final static String SESSION_ATTRIBUTE_CONTAINER =
			"FRAMEWORK_SESSION_ATTRIBUTE_CONTAINER";
            
    public final static String ETC_PATH = "/home/nsadmin/etc";
    public final static String RESOURPATH_NIC = "/opt/nv_network/messages/";
    
    public static final String  SESSION_AUTHENTICATED = "authenticated";
    public static final String  SESSION_USERINFO = "userinfo";
    public static final String  FORM_ORIGINALURI = "orignalURI";
    public static final String  SESSION_LANG = "lang";
    public static final String  SESSION_BROWSER = "browser";
    public static final String  SESSION_REMOTEADDR = "remoteaddr";
    public static final String  SESSION_LOGINTIME  = "logintime";
    
    public static final int     MAX_INACTIVE_INTERVAL = 600;
    public static int   NSGUI_TIMEOUT = MAX_INACTIVE_INTERVAL;
    
    public static final String  USER_NSVIEW  = "nsview";
    
	public static final String  NSUSER_NSADMIN  = "nsadmin";
	public static final String  NSUSER_NSVIEW  = "nsview";
    public static final String NSADMIN_TIMEOUT = "NSADMIN_TIMEOUT";
    public static final String NSVIEW_TIMEOUT = "NSVIEW_TIMEOUT";
    public static final String VERSION_TYPE_JAPAN = "japan";
    public static final String VERSION_TYPE_ABROAD = "others";
    public static final String  ERROR_LEVEL_ERROR  = "error";
    public static final String  ERROR_LEVEL_INFO  = "info";
    public static final String  ERROR_GET_BUSY_EXPORT_GROUP = "--";
}
