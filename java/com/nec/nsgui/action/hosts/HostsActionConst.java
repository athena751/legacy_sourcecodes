/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.hosts;

/**
 *
 */
public interface HostsActionConst {
    public static final String cvsid =
        "@(#) $Id: HostsActionConst.java,v 1.2 2007/05/29 09:26:11 wanghui Exp $";
    
    public final static String SUDO_COMMAND = "sudo";
    public final static String SCRIPT_HOME = "/home/nsadmin";
    public final static String GET_HOSTS_SETTING_INFO_SCRIPT = "/bin/hosts_getInfo.pl";
    public final static String GET_HOSTS_SYNCHRONIZE_SCRIPT = "/bin/hosts_synchronizePartner.pl";
    public final static String HOSTS_RECOVERED = "Recovered:";
    public final static String HOSTS_NODE0= "Node0:";
    public final static String HOSTS_NODE1= "Node1:";
   
    public final static String SESSION_DIRECTEDIT_NOWARNING  = "hosts_directEditNoWarn";
    public final static String SESSION_DIRECTEDIT_DISACCORD  ="hosts_disaccordFlag";
    public final static String SESSION_SYNC_WRITE_FLAG = "hosts_syncWriteFlag";
    public final static String SESSION_NODE_NUM = "hosts_nodeNum";
    public final static String SYNC_WRITE_UNSUCCESS = "FAIL_WRITE_OTHERNODE";
    public final static String SYNC_WRITE_SUCCESS_NOGRARD = "SUCCESS";
    public final static String SYNC_WRITE_SUCCESS_GUARD = "GUARD_USER_SETTING";
    public final static String RECOVERED = "Recovered:";
    public final static String ERRCODE_WRITETO_OTHERNODE_ERROR = "0x13400021";
    public final static String ERRCODE_SERVICERESTART_CURRENTNODE_ERROR = "1";
    public final static String ERRCODE_SERVICERESTART_PARTNERNODE_ERROR = "2";
    public final static String SESSION_SERVICERESTART_ERROR = "hosts_servicerestart_error";
}
