/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.snmp;

public interface SnmpActionConst{
    public static final String cvsid = "@(#) $Id: SnmpActionConst.java,v 1.5 2007/09/10 01:21:34 lil Exp $";
    
    public final static String validContactLocation4Alert = "~`!@#$%^&*()-_+=|{}[];:?/<>.,\\\\\\'\\\"";
    public final static String validContactLocation = "~`!@#$%^&*()-_+={}[]|\\\\\\\";\\':?/<>,.";
    public final static String validCommunity       = "~`!@#$%^&*()-_+={}[]|\\\\\\\";\\':?/<>,.";
    public final static String validUser            = "~`!@#$%^&*()-_+={}[]|;:?/<>,.";
    public final static String validPasswd          = "~`!@#$%^&*()-_+={}[]|;:?/<>,.";
    public final static String validPassphrase      = "~`!@#$%^&*()-_+={}[]|;:?/<>,.";
    
    public final static String SESSION_SNMP_PARTNERFAILED            = "SESSION_SNMP_PARTNERFAILED";
    public final static String SESSION_SNMP_COMMUNITYFORM            = "SESSION_SNMP_COMMUNITYFORM";
    public final static String SESSION_SNMP_USERFORM                 = "SESSION_SNMP_USERFORM";
    public final static String SESSION_SNMP_SYSTEMFORM               = "SESSION_SNMP_SYSTEMFORM";
    public final static String SESSION_SNMP_NAMECHANGEFAILED         = "SESSION_SNMP_NAMECHANGEFAILED";
    public final static String SESSION_SNMP_RECOVERYCONVERTFAILED    = "SESSION_SNMP_RECOVERYCONVERTFAILED";
    public final static String SESSION_SNMP_ERRORHOSTS               = "SESSION_SNMP_ERRORHOSTS";
    public final static String SESSION_SNMP_COMMUNITY_MAX            = "SESSION_SNMP_COMMUNITY_MAX";

    public final static String ERRCODE_PARTNERFAILED            = "0x12700100";
    public final static String ERRCODE_RECOVERY                 = "0x12700200";
    public final static String ERRCODE_INFORECOVERY             = "0x12700210";
    public final static String ERRCODE_INFORECOVERY4NSVIEW      = "0x12700211";
    public final static String ERRCODE_CONVERTFAILED            = "0x12700220";
	public final static String ERRCODE_RECOVERYCONVERTFAILED    = "0x12700230";
    public final static String ERRCODE_USER                     = "0x12700240";
    public final static String ERRCODE_COMMUNITY                = "0x12700250";
    public final static String ERRCODE_COMMUNITY4COMMUNITY      = "0x12700251";
    public final static String ERRCODE_COMMUNITY_USER           = "0x12700260";
    public final static String ERRCODE_USER_IPTABLE             = "0x12700270";
    public final static String ERRCODE_COMMUNITY_IPTABLE        = "0x12700280";
    public final static String ERRCODE_COMMUNITY_USER_IPTABLE   = "0x12700290";
    public final static String ERRCODE_COMMON4NSVIEW            = "0x12700300";
    public final static String ERRCODE_FAILED_CONVERT_ADDCOM    = "0x12700310";
}