/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FTPConstants.java,v 1.2302 2008/12/23 03:24:02 gaozf Exp $";
 */


package  com.nec.sydney.atom.admin.ftp;

public interface FTPConstants{


    public static final int FTP_EXCEP_GET_CONFFILE_FAILED	=   0x00006101;
    public static final int FTP_EXCEP_RUN_IPTABLES_FAILED	=   0x00006102;
    public static final int FTP_EXCEP_SET_BASIC_FAILED	        =   0x00006103;
    public static final int FTP_EXCEP_WRITE_FILE_FAILED	        =   0x00006104;
    public static final int FTP_EXCEP_STATUS_CHANGED_FAILED	=   0x00006105;
    public static final int FTP_EXCEP_SET_AUTH_FAILED           =   0x00006106;
    public static final int FTP_EXCEP_SET_CLIENTLIST_MODE_FAILED=   0x00006107;
    public static final int FTP_EXCEP_EXEC_FTPMKCNF_FAILED      =   0x00006108;    

    
    public static String BAS_ACCESSMODE_READONLY	    = "ReadOnly";
    public static String BAS_ACCESSMODE_READWRITE	    = "ReadWrite";
    public static String BAS_CLIENTMODE_ALLOW	            = "Allow";
    public static String BAS_CLIENTMODE_DENY	            = "Deny";
    public static String BAS_FTPD_DEFAULT_PORT              = "21";
    public static String BAS_PASSIVE_DEFAULT_PORT_START     = "36864";
    public static String BAS_PASSIVE_DEFAULT_PORT_END     = "40960";
    //shench 2008.12.3 start
    public static String BAS_IDENTDMODE_USE              = "on";
    public static String BAS_IDENTDMODE_NOTUSE           = "off";
    //end shench
    
    public static String AUTH_DBTYPE_NIS	            = "nis";
    public static String AUTH_DBTYPE_PWD	            = "pwd";
    public static String AUTH_DBTYPE_PDC	            = "dmc";
    public static String AUTH_DBTYPE_LDAP	            = "ldu";
    public static String AUTH_ACCESSTYPE_ALLOW	            = "allow";
    public static String AUTH_ACCESSTYPE_DENY	            = "deny";
    public static String AUTH_USERMAPPINGMODE_INVALID       = "Direct";
    public static String AUTH_USERMAPPINGMODE_VALID	    = "Normal";
    public static String AUTH_USERMAPPINGMODE_ANON	    = "Anonymous";
    public static String AUTH_ANONUSERNAME_NOBODY	    = "nobody";
    public static String AUTH_HOMEDIR_MODE_AUTHDB	    = "AuthDB";
    public static String AUTH_HOMEDIR_MODE_FSSPECIFY        = "FSSpecify";
    
    public static String ANON_ACCESSMODE_DOWNLOADONLY       = "DownloadOnly";
    public static String ANON_ACCESSMODE_UPLOADONLY	    = "UploadOnly";
    public static String ANON_ACCESSMODE_READWRITE	    = "ReadWrite";
    public static String ANON_CLIENTMODE_ALLOW	            = "Allow";
    public static String ANON_CLIENTMODE_DENY	            = "Deny";
    public static String ANON_USERNAME_FTP	            = "ftp";
    
    public static String SERVICE_STATUS_STOPPED	            = "stopped";
    public static String SERVICE_STATUS_RUNNING	            = "running...";
    public static String SERVICE_STATUS_UNKNOWN	            = "unknown";
    
    public static String FTPD_MIDDLE_CONFIG_FILE0           = "proftpd.conf.0";
    public static String FTPD_MIDDLE_CONFIG_FILE1           = "proftpd.conf.1"; //when failover
    public static String FTPD_AUTH_USERS_FILE               = "ftpusers";
    public static String FTPD_AUTH_GROUP_FILE0              = "/etc/pam.d/ftpd-group0";
    public static String FTPD_AUTH_GROUP_FILE1              = "/etc/pam.d/ftpd-group1" ;   
    public static String FTPD_AUTH_FILE                     = "proftpd_auth.conf";
}