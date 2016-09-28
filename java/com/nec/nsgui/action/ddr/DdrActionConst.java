/*
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
*/
package com.nec.nsgui.action.ddr;

public interface DdrActionConst {
	public static final String cvsid = "@(#) $Id: DdrActionConst.java,v 1.4 2008/05/04 05:05:56 yangxj Exp $";

	// session constant.
	public final static String SESSION_MV_NAME = "SESSION_MV_NAME";
	public final static String SESSION_DDR_ISNSVIEW = "SESSION_DDR_ISNSVIEW";
	public final static String REQUEST_MV_NAME_AND_VALUE = "MV_NAME_VALUE_FOR_SHOW";
	public static final String SESSION_DDR_HAS_VOLSCAN = "SESSION_DDR_HAS_VOLSCAN";
	public static final String SESSION_DDR_ACTIVE_ASYNCVOL = "SESSION_DDR_HAS_ACTIVE_ASYNC_VOLUME";
	public static final String SESSION_DDR_ACTIVE_ASYNCPAIR = "SESSION_DDR_HAS_ACTIVE_ASYNC_PAIR";
	public static final String SESSION_DDR_ASYNCVOL = "SESSION_DDR_HAS_ASYNC_VOLUME";
	public static final String SESSION_DDR_ASYNCPAIR = "SESSION_DDR_HAS_ASYNC_PAIR";
	public static final String SESSION_DDR_CUR_NODE_HAS_STATUS = "SESSION_DDR_CUR_NODE_HAS_STATUS";
	public static final String SESSION_DDR_CUR_NODE_HAS_ERROR = "SESSION_DDR_CUR_NODE_HAS_ERROR";
	public static final String SESSION_DDR_CUR_NODE_NEED_CLEARBUTTON = "SESSION_DDR_CUR_NODE_NEED_CLEARBUTTON";
	public static final String SESSION_DDR_CUR_NODE_ABNORMAL_COMPOSITION = "SESSION_DDR_CUR_NODE_HAS_ABNORMAL_COMPOSITION";

	// the column of pair info.
	public final static String PAIR_LIST_COL_RADIO = "radio";
    public final static String PAIR_LIST_COL_USAGE = "usage";
    public final static String PAIR_LIST_COL_MVNAME = "mvname";
    public final static String PAIR_LIST_COL_RVNAME = "rvname";
    public final static String PAIR_LIST_COL_SYNCSTATE = "syncstate";
    public final static String PAIR_LIST_COL_PROGRESSRATE = "progressrate";
    public final static String PAIR_LIST_COL_SYNCSTARTTIME = "syncstarttime";
    public final static String PAIR_LIST_COL_SCHEDULE = "schedule";
    public final static String PAIR_LIST_COL_STATUS = "status";
    public final static String PAIR_LIST_COL_ERRORCODE = "errorcode";
    public final static String PAIR_LIST_COL_CLEARBUTTON = "clearbutton";
    
    // error code for pair sync status.
    public static final String DDR_OPERATING_CODE = "0x137f0000";
    public static final String DDR_OPERATED_CODE = "0x137fffff";
    public static final String DDR_OPERATE_STOP_CODE = "0x137ffffe";
    public static final String DDR_EXCEP_FAILED_TO_CREATE_SCHED = "0x13700051";
    public static final String DDR_EXCEP_ABNORMAL_COMPOSITION = "0x137fcccc";
    
	// for usage.
    public final static String REQUEST_D2D_USAGE = "usage";
	public final static String USAGE_ALWAYS = "always";
	public final static String USAGE_D2D2T = "d2d2t";
	public final static String USAGE_GENERATION = "generation";
	
	public final static String INFO_NODATA = "--";
	public final static String INFO_NOTHING = "nothing";
	public final static String SYNCSTATE_ALWAYSREPL_MARK = "";
	public final static String SYNCSTATE_SYNC_NOTHING_MARK = "--";
	public final static String SYNCSTATE_SYNC_NOTHING = "sync_nothing";
	public final static String SYNCSTATE_SEPARATED = "separated";
	public final static String SYNCSTATE_CANCEL = "cancel";
	public final static String SYNCSTATE_FAULT = "fault";
	
	public final static String PAIRINFO_STATUS_ABNORMALITYCOMPOSITION = "abnormalcomposition";
	public final static String PAIRINFO_STATUS_EXTEND_MV_FAIL = "extendmvfail";
	public final static String PAIRINFO_STATUS_EXTEND_FAIL = "extendfail";
	public final static String PAIRINFO_STATUS_CREATE_SCHED_FAIL = "createschedfail";
	public final static String PAIRINFO_STATUS_CREATE_FAIL = "createfail";
	
	// Separator
	public final static String SEPARATOR_DOLLAR = "$";
	public final static String SEPARATOR_NUMBERSIGN = "#";
	public final static String SEPARATOR_COMMA = ",";
	public final static String SEPARATOR_COLON = ":";
	public final static String SEPARATOR_NEWLINE = "<br>";
	
	public final static String SEPARATOR_BETWEEN_MVINFO = SEPARATOR_DOLLAR;
	public final static String SEPARATOR_BETWEEN_RVINFO = SEPARATOR_NUMBERSIGN;
	public final static String SEPARATOR_BETWEEN_SCHEDULE = SEPARATOR_NUMBERSIGN;
    
    public final static String COMMON_MSGKEY_UNKNOWN = "pair.detail.async.error.unknown";
    public final static String PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS ="pair.info.status.";
    public final static String PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR = "pair.detail.async.error.";
    public final static String PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_SCHEDULE = "pair.detail.async.error.schedule.";
    public final static String PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_NSVIEW = "pair.detail.async.error.nsview.";
    public final static String PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_DEAL = "pair.detail.async.error.deal.";
    public final static String PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_EXTEND = "pair.detail.async.error.deal.extend";
    public final static String PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_CREATE = "pair.detail.async.error.deal.create";
    public final static String PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_SCHEDULE = "pair.detail.async.error.deal.schedule";
    public final static String VOLUME_MSGKEY_PREFIX_ASYNC_ERR = "info.async.error.";
    public final static String VOLUME_MSGKEY_PREFIX_ASYNC_ERR_NSVIEW = "info.async.error.nsview.";
    public final static String VOLUME_MSGKEY_ASYNC_ERR_DEAL_EXTEND = "info.async.error.deal.extend";
    public final static String VOLUME_MSGKEY_ASYNC_ERR_DEAL_CREATE = "info.async.error.deal.create";

    public final static String MSGKEY_PREFIX_SYNCSTATE = "pair.info.syncstate.";
    public final static String MSGKEY_PREFIX_COPYCONTROLSTATE = "pair.detail.copyctrlstate.";
   
    public final static String PAIR_DETAIL_TH_RVNAME = "info.rvName";
    public final static String PAIR_DETAIL_TH_NODE = "pair.detail.node";
    public final static String PAIR_DETAIL_TH_NODE_TEXT = "pair.detail.node.text";
    public final static String PAIR_DETAIL_TH_CAPACITY = "info.storage.capacity";
    public final static String PAIR_DETAIL_TH_POOLNAMENO = "pair.detail.poolnameno";
    public final static String PAIR_DETAIL_TH_RAIDTYPE = "info.pool.raidType";
    public final static String PAIR_DETAIL_TH_SYNCSTATE = "pair.info.syncstate";
    public final static String PAIR_DETAIL_TH_COPYCTRLSTATE = "pair.detail.copyctrlstate";
    public final static String PAIR_DETAIL_TH_PROCESS = "pair.info.progressrate";
    public final static String PAIR_DETAIL_TH_SYNCSTARTTIME = "pair.info.syncstarttime";
    public final static String PAIR_DETAIL_TH_STATUS = "pair.info.status";
    public final static String PAIR_DETAIL_TH_ERRORCODE = "pair.info.errorcode";
    public final static String PAIR_DETAIL_TH_ERRORMSG = "pair.detail.errMsg";
    
    public static final String SESSION_DDR_DETAIL_RVHTMLCODE = "ddrPairDetailRVHtmlCode";
    public static final String SESSION_DDR_DETAIL_MVBEAN = "ddrPairDetailMVBean";
    public static final String SESSION_DDR_DETAIL_TYPE = "ddrPairDetailType";
    
    public static final String PAIR_DETAIL_ERR_OPRSTOP = "0x137ffffe";
    public static final String PAIR_DETAIL_ERR_ABNSTOP = "0x137f0005";
    
    public static final String REQUEST_DDR_MVNAME4SHOW = "mvName4Show";
    public static final String REQUEST_DDR_RVNAME4SHOW = "rvName4Show";
    public static final String REQUEST_DDR_SCHEDULE4SHOW = "schedule4Show";
    public static final String REQUEST_DDR_RVINFOLIST = "rvInfoList";
    
    public static int DDR_CRON_PERIOD_WEEKDAY   = 1;
    public static int DDR_CRON_PERIOD_MONTHDAY  = 2;
    public static int DDR_CRON_PERIOD_DAILY     = 3;
    public static int DDR_CRON_PERIOD_DIRECT    = 4;
    
    public static final String MV_NO_SNAPSHOT = "no";
    public static final String MV_HAS_SNAPSHOT = "yes";
    public static float HASSNAPSHOT_MV_ALLOWABLESIZE = 20;
    public static float NOSNAPSHOT_MV_ALLOWABLESIZE = 130;
    public static final String MV_NO_MOUNTPOINT = "--";
    public static final String STARTWITH_NV_RV0 = "NV_RV0";
    public static final String STARTWITH_NV_RV1 = "NV_RV1";
    public static final String STARTWITH_NV_RV2 = "NV_RV2";
    public static final String MSG_EXTEND_MV_NO_MOUNTPOINT = "ddr.extend.msg.nomountpoint";
    public static final String MSG_EXTEND_RAIDTYPE_INVALID = "ddr.extend.msg.raidtype.invalid";
    public static final String RAIDTYPE_IS_RAID6 = "6";
}
