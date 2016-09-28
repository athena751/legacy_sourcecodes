/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ndmpv4;

/**
 *
 */
public interface NdmpActionConst {
    public static final String cvsid =
        "@(#) $Id: NdmpActionConst.java,v 1.4 2007/01/03 03:35:11 wanghui Exp $";
        public final static String NDMP_CONFIGINFO = "ndmpConfig";
        //public final static String NDMP_ALLINTERFACES = "ndmp_allInterfaces";
        //public final static String NDMP_ALLINTERFACESLABEL = "ndmp_allInterfacesLabel";
        public final static String CONTROL_INTERFACES = "control_interfaces";
        public final static String CONTROL_INTERFACESLABEL = "control_interfacesLabel";
        public final static String DATA_INTERFACES = "data_interfaces";
        public final static String DATA_INTERFACESLABEL = "data_interfacesLabel";

        public final static String SESSION_INFO_LIST = "ndmp_sessionInfoList";
        public final static String REQUEST_NDMP_SYSDATE= "ndmp_sysDate";
        public final static String SESSION_DETAIL_INFO = "ndmp_session_detail_info";

        public final static String NDMPD_EXEC_RET = "ndmpd_script_exec_ret";
        public final static String SESSION_TYPE_LOCAL = "LOCAL";
        public final static String SESSION_TYPE_MOVER = "MOVER";
        public final static String SESSION_TYPE_DATA = "DATA";
        public final static String SESSION_TYPE_UNKNOWN = "IDLE";
        public final static String SESSION_LOCAL_LIST = "ndmp_session_local_list";
        public final static String SESSION_MOVER_LIST = "ndmp_session_mover_list";
        public final static String SESSION_DATA_LIST =  "ndmp_session_data_list";
        public final static String SESSION_UNKNOWN_LIST =  "ndmp_session_unknown_list";
        public final static String NDMP_SERVER_EXEC_RET = "ndmpd_script_exec_ret";
}