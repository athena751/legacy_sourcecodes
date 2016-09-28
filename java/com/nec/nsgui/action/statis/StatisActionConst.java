/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

/**
 *
 */
public interface StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: StatisActionConst.java,v 1.4 2007/04/03 11:05:54 yangxj Exp $";    
	public static final String SESSION_USERINFO = "userinfo";
	public static final String SESSION_WATCHITEM_ID =
		"SESSION_STATIS_WATCHITEM_ID";
	public static final String SESSION_SELECTED_NUM="12";
	public static final String SESSION_COLLECTION_ID = "SESSION_STATIS_COLLECTION_ID";
	public static final String SESSION_MC = "SESSION_STATIS_MONITOR_CONF";
	public static final String SESSION_MC_4SURVEY =
		"SESSION_STATIS_MONITOR_CONF_4SURVEY";
	public static final String SESSION_RGD = "SESSION_STATIS_RRD_GRAPH_DEF";
	public static final String SESSION_RGD_EXCEPTION = "SESSION_STATIS_RRD_GRAPH_DEF_EXCEPTION";
    public static final String SESSION_RGD_4NSW = "SESSION_STATIS_RRD_GRAPH_DEF_NSW";
    public static final String SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED =
		"SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED";
	public static final String SESSION_STATIS_NASSWITCH_TABLE_MODE =
		"SESSION_STATIS_NASSWITCH_TABLE_MODE";
	public static final String HASH_KEY_ADMIN_NIC_LIST = "admin";
	public static final String HASH_KEY_OTHER_NIC_LIST = "other";

	public static final String SESSION_STATIS_FILTER_FLAG =
		"SESSION_STATIS_FILTER_FLAG";
	public static final String SESSION_RGD_4SURVEY =
		"SESSION_STATIS_RRD_GRAPH_DEF_4SURVEY";
	public static final String SESSION_IS_INVESTGRAPH =
		"SESSION_STATIS_IS_INVESTGRAPH";
	public static final String SESSION_SGD = "SESSION_STATIS_SGD";
	public static final String SESSION_TARGET_ID = "SESSION_STATIS_TARGET_ID";
	public static final String SESSION_DISPLAY_OS_INFO =
		"SESSION_STATIS_DISPLAY_OS_INFO";
	public static final String SESSION_GRAPH_TYPE = "SESSION_STATIS_GRAPH_TYPE";
    
    public static final String SESSION_COMPUTER_NAME="SESSION_STATIS_COMPUTER_NAME";
    public static final String SESSION_DOMAIN_NAME="SESSION_STATIS_DOMAIN_NAME";
    public static final String SESSION_EXPORT_GROUP="SESSION_STATIS_EXPORT_GROUP";
    public static final String WATCHITEM_NVAVS_REQUEST = "Nvavs_Request";
    public static final String WATCHITEM_NVAVS_TAT = "Nvavs_TAT";
    public static final String WATCHITEM_NVAVS_CACHE_HIT = "Nvavs_Cache_Hit";
    
	public static final String HASH_KEY_ADMIN_VOLUME_LIST = "admin";
	public static final String HASH_KEY_OTHER_VOLUME_LIST = "other";

	public static final String FILE_SYSTEM_KEY_HMD = "/dev/hmd";
	public static final String FILE_SYSTEM_KEY_LD = "/dev/ld";
	public static final String XML_ELEMENT_MOUNT_POINT = "MountedOn";
	public static final int PERIOD_WITHIN_DAY = 1;
	//sign hourly should be showed
	public static final int PERIOD_WITHIN_WEEK = 2;
	//sign hourly/daily should be showed
	public static final int PERIOD_WITHIN_MONTH = 3;
	//sign hourly/daily/weekly should be showed
	public static final int PERIOD_WITHIN_YEAR = 4;
	//sign hourly/daily/weekly/monthly should be showed
	public static final String RRD2CSV_END_TIME_OPT_NOW = "now";

	public static final int STOCK_PERIOD_LOWER_LIMIT = 1;
	public static final int STOCK_PERIOD_DAY_POINT = 2;
	public static final int STOCK_PERIOD_WEEK_POINT = 8;
	public static final int STOCK_PERIOD_MONTH_POINT = 32;
	public static final int STOCK_PERIOD_YEAR_POINT = 366;
	public static final int STOCK_PERIOD_UPPER_LIMIT = 366;

	public static final String NSW_NFS_Virtual_Export="NSW_NFS_Virtual_Export"; 
	public static final String NSW_NFS_Server="NSW_NFS_Server"; 
	public static final String NSW_NFS_Node="NSW_NFS_Node"; 

    public static final int INTERVAL_LOWER_LIMIT = 60; // unit: second
    public static final int INTERVAL_UPPER_LIMIT = 60*60; // unit: second
    public static final long SECONDS_OF_ONE_YEAR = 365 * 24 * 60 * 60;
    
    public static final String INFOTYPE_NFS_Virtual_Export="export"; 
    public static final String INFOTYPE_NFS_Server="server"; 
    public static final String INFOTYPE_NFS_Node="node";

	public static final String NSW_NFS_VE_Access="NSW_NFS_VE_Access"; 
	public static final String NSW_NFS_VE_Response_Time_Average="NSW_NFS_VE_Response_Time_Average"; 
	public static final String NSW_NFS_VE_Retry="NSW_NFS_VE_Retry"; 
	public static final String NSW_NFS_VS_Access="NSW_NFS_Server_Access"; 
	public static final String NSW_NFS_VS_Response_Time_Average="NSW_NFS_Server_Response_Time_Average"; 
	public static final String NSW_NFS_VS_Retry="NSW_NFS_Server_Retry"; 
	public static final String NSW_NFS_VN_Access="NSW_NFS_Node_Access"; 
	public static final String NSW_NFS_VN_Response_Time_Average="NSW_NFS_Node_Response_Time_Average"; 
	public static final String NSW_NFS_VN_Retry="NSW_NFS_Node_Retry"; 	

		
	public static final int MIN_AUTO_RELOAD_INTERVAL = 1,
		MAX_AUTO_RELOAD_INTERVAL = 60,
		MIN_SAMPLE_INTERVAL = 1,
		MAX_SAMPLE_INTERVAL = 60,
		MIN_YEAR = 1970,
		MAX_MONTH = 12,
		MIN_MONTH = 1,
		MAX_DAY = 31,
		MIN_DAY = 1,
		MAX_HOUR = 23,
		MIN_HOUR = 0,
		MAX_MINUTE = 59,
		MIN_MINUTE = 0,
		MAX_SECOND = 59,
		MIN_SECOND = 0,
		MAX_REL_HOURS_4SURVEY = 168,
		MAX_REL_HOURS = 512,
		MIN_REL_HOURS = 1,
		MAX_REL_DAYS_4SURVEY = 7,
		MAX_REL_DAYS = 366,
		MIN_REL_DAYS = 1,
		MAX_REL_WEEKS_4SURVEY = 1,
		MAX_REL_WEEKS = 52,
		MIN_REL_WEEKS = 1,
		MAX_REL_MONTHS = 12,
		MIN_REL_MONTHS = 1,
		FIX_REL_YEARS = 1,
		MAX_FROM_TIME = 512,
		MIN_FROM_TIME = 1,
		MAX_TO_TIME = 512,
		MIN_TO_TIME = 1;

	public static final String DISK_SPACE_UNIT = "GB";

	public static final String MOUNT_POINT = "mountPoint",
		GRAPH = "graph",
		USE = "use",
		TOTAL = "total",
		USED = "used",
		AVAILABLE = "available",
		TYPE = "type",
		DEVICE = "device";

	public static int PIE_CHART_COLUMNS = 5;
	public static final String INFOTYPE_CPU = "cpu";
	public static final String INFOTYPE_DISKIO = "diskio";
	public static final String INFOTYPE_NETTRAFFIC = "nettraffic";
	public static final String INFOTYPE_NETERRORS = "neterrors";
	public static final String INFOTYPE_NETPACKETS = "netpackets";
	public static final String INFOTYPE_VOLUME = "volume";
	public static final String INFOTYPE_INODE = "inode";
    public static final String INFOTYPE_VOLUME_QUANTITY = "volume_quantity";
    public static final String INFOTYPE_INODE_QUANTITY = "inode_quantity";
	public static final String INFOTYPE_ISCSISESSION = "iscsisession";
	public static final String INFOTYPE_ISCSILOGIN = "iscsilogin";
	public static final String INFOTYPE_ISCSILOGOUT = "iscsilogout";
    public static final String INFOTYPE_NVAVS_REQUEST = "nvavsrequest";
    public static final String INFOTYPE_NVAVS_TAT = "nvavstat";
	public static final String STARTTIME_OPTION_RELATIVE_DAY = "-1d";
	public static final String STARTTIME_OPTION_RELATIVE_WEEK = "-1w";
	public static final String STARTTIME_OPTION_RELATIVE_MONTH = "-1m";
	public static final String STARTTIME_OPTION_RELATIVE_YEAR = "-1y";
	public static final int CSV_DOWNLOAD_PERL_SCRIPT_EXEC_SUCCEED = 0;
	//execute rrdlist or rrd2csv successfully
	public static final int ERROR_CODE_DOWNLOAD_SCRIPT_UNKNOWN_EXCEPTION = 1;
	public static final int ERROR_CODE_DOWNLOAD_DISK_SPACE_NOT_ENOUGH = 2;
	public static final String STATIS_DOWNLOAD_END_WAIT =
		"statis_waitHeartbeat";
	public static final String SESSION_STATIS_DOWNLOAD_INFO =
		"statis_downloadInfo";
	public static final String SESSION_STATIS_DOWNLOAD_EXCEPTION =
		"statis_downloadException";
	public static final String STATIS_DOWNLOAD_FINISHED = "statis_downloadEnd";
	public static final String PREFIX_EXPORT_GROUP = "/export/";
}
