/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.framework;

/**
 *
 */
public interface FrameworkConst {
    public static final String cvsid =
        "@(#) $Id: FrameworkConst.java,v 1.14 2008/05/09 01:21:09 zhangjun Exp $";

    public static final String BUTTON_DISABLE = "disable";
    public static final String BUTTON_ENABLE = "enable";
    public static final String MACHINE_TYPE_SINGLE = "Single";
    public static final String MACHINE_TYPE_NASCLUSTER = "NasCluster";
    public static final String MACHINE_TYPE_NASHEADCLUSTER = "NasheadCluster";
    public static final String MACHINE_TYPE_NASHEADSINGLE = "NasheadSingle";
    public static final String MACHINE_TYPE_ONENODESIRIUS = "OneNodeSirius";
    public static final String MACHINE_TYPE_ERRORMACHINETYPE =
        "ErrorMachineType";
        
    public static final String VERSION_TYPE_JAPAN = "japan";
    public static final String VERSION_TYPE_ABROAD = "others";
    public static final String MENU_MSG_KEY_JAPAN = "base.istorageManager";
    public static final String MENU_MSG_KEY_ABROAD = "base.necIstorageManager";
    public static final String MENU_MSG_KEY_JAPAN_PASSWD = "base.istorageManager.account";
    public static final String MENU_MSG_KEY_ABROAD_PASSWD = "base.necIstorageManager.account";
    public static final String MENU_MSG_KEY_JAPAN_CON_NETWORK = "base.istorageManager.connectNetwork";
    public static final String MENU_MSG_KEY_ABROAD_CON_NETWORK = "base.necIstorageManager.connectNetwork";
    public static final String MENU_DETAIL_MSG_KEY_JAPAN = "base.istorageManager.detailMsg";
    public static final String MENU_DETAIL_MSG_KEY_ABROAD = "base.necIstorageManager.detailMsg";
    public static final String MENU_DETAIL_MSG_KEY_JAPAN_PASSWD = "base.istorageManager.account.detailMsg";
    public static final String MENU_DETAIL_MSG_KEY_ABROAD_PASSWD = "base.necIstorageManager.account.detailMsg";
    public static final String MENU_DETAIL_MSG_KEY_JAPAN_CON_NETWORK = "base.istorageManager.connectNetwork.detailMsg";
    public static final String MENU_DETAIL_MSG_KEY_ABROAD_CON_NETWORK = "base.necIstorageManager.connectNetwork.detailMsg";
        
    public static final String SCIRPT_GET_MACHINE_TYPE =
        "/bin/menu_getMachineType.pl";
    public static final String SCIRPT_GET_EXPORT_GROUP =
        "/bin/nsgui_getExportGroup.pl";
    public static final String COMMAND_GET_VERSION_TYPE =
        "/bin/nsgui_property.sh";
    public static final String COMMAND_IS_SINGLE_NVRAM =
        "/bin/nsgui_isSingleNVRAM.sh";
    public static final String COMMAND_IS_DISPLAY_DDR_MENU =
        "/bin/menu_isDisplayDDRMenu.pl";
    public static final String MACHINE_TYPE_SEPARATOR = ":";
    public static final String RPQ_NOT_PREFIX = "^";
    public static final String SUDO_COMMAND = "sudo";
    public static final String TOMCAT_KEY = "tomcat";
    public static final String VERSION_KEY = "NSGUI_TITLE";

    public  static final String ERRCODE_CLUSTER_NODE0_ERROR = "0x10000008";
    public  static final String ERRCODE_CLUSTER_NODE1_ERROR = "0x10000009";
    
    public static final String CONFIG_FILE_SEPARATOR = ",";
    public static final String CONFIG_FILE_TAG_NSMENUS = "NSMenus";
    public static final String CONFIG_FILE_TAG_CATEGORY = "Category";
    public static final String CONFIG_FILE_TAG_SUBCATEGORY = "SubCategory";
    public static final String CONFIG_FILE_TAG_ITEM = "Item";
    public static final String CONFIG_FILE_TAG_HIDDEN = "Hidden";
    public static final String CONFIG_FILE_TAG_SEPARATER = "/";

    public static final String TARGET_SEPARATOR_TYPE = "@";
    public static final String TARGET_SEPARATOR_CLUSTER = "/";
    public static final String TARGET_TYPE_NAS = "NAS";
    public static final String TARGET_TYPE_NASIPSAN = "NASIPSAN";
    public static final String TARGET_TYPE_ADMIN = "adminTarget";
    public static final String TARGET_TYPE_NODE = "nodeTarget";

    public static final String PREFIX_EXPORT_GROUP = "/export/";
    public static final String ETC_GROUP_PATH = "/etc/group";
    public final static String PATH_OF_TOMCAT_CONF = "/home/nsadmin/etc/properties/tomcat.conf";
    public final static String PATH_OF_TIMEOUT_CONF = "/home/nsadmin/etc/properties/timeout.conf";
    
    public static final String MENU_KEY_SEPARATOR = "@";
    public static final String ENCODING_UTF8 = "UTF8";
    public static final String ENCODING_UTF_8 = "UTF-8";
    
    public static final String SESSION_ISNASHEAD = "isnashead";
    public static final int     MAX_INACTIVE_INTERVAL = 10;
    public static int   DEFAULT_NSGUI_TIMEOUT = MAX_INACTIVE_INTERVAL;
    public static final String NSADMIN_TIMEOUT = "NSADMIN_TIMEOUT";
    public static final String NSVIEW_TIMEOUT = "NSVIEW_TIMEOUT";
    
    public static final String SESSION_MACHINE_SERIES = "machineSeries";
    public static final String MACHINE_SERIES_PROCYON = "Procyon";
    public static final String MACHINE_SERIES_CALLISTO = "Callisto";
    public static final String SCIRPT_GET_MACHINE_SERIES = "/bin/nsgui_getMachineSeries.pl";
}
