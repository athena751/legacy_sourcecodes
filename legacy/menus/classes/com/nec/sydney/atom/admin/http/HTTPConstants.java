/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: HTTPConstants.java,v 1.2301 2007/04/27 01:38:16 zhangjx Exp $";
 */


package  com.nec.sydney.atom.admin.http;

public interface HTTPConstants{
    public static final String   BASIC_CONFIG_BEGIN = "<BasicConfig>";                                      
    public static final String   BASIC_CONFIG_END = "</BasicConfig>";  
    public static final String   MAIN_SERVER_BEGIN = "<MainServerConfig>";                                      
    public static final String   MAIN_SERVER_END = "</MainServerConfig>"; 
    public static final String   DIRECTORY_BEGIN = "<Directory ";                                      
    public static final String   DIRECTORY_END = "</Directory>";
    public static final String   VIRTUAL_HOST_BEGIN = "<VirtualHostConfig ";                                      
    public static final String   VIRTUAL_HOST_END = "</VirtualHostConfig>";
    public static final String   HOST_BEGIN = "<VirtualHost ";                                      
    public static final String   HOST_END = "</VirtualHost>";   
    public static final String   LISTEN = "Listen ";                                      
    public static final String   DOCUMENTROOT = "DocumentRoot ";
    public static final String   SERVERNAME = "ServerName ";                                      
    public static final String   SERVERADMIN = "ServerAdmin ";
    public static final String   USER_UNIX_NAME = "user_unix_semantics_name ";                                      
    public static final String   USER_UNIX_ID = "user_unix_semantics_id ";
    public static final String   GROUP_UNIX_NAME = "group_unix_semantics_name ";                                      
    public static final String   GROUP_UNIX_ID = "group_unix_semantics_id ";
    public static final String   USER_WINDOWS_NAME = "user_windows_semantics_name ";                                      
    public static final String   GROUP_WINDOWS_NAME = "group_windows_semantics_name ";
    public static final String   TRANSFERLOG = "TransferLog ";                                      
    public static final String   CUSTOMLOG = "CustomLog ";
    public static final String   ERRORLOG = "ErrorLog ";                                                                           
    public static final String   LOGLEVEL = "LogLevel ";
    public static final String   ACCESSFILENAME = "AccessFileName ";
    public static final String   USERDIR = "UserDir ";                                      
    public static final String   DIR_DISABLE = "disable";
    public static final String   DIR_ENABLE = "enable";      
    public static final String   DIR_DISABLE_ONLY = "disable only";
    public static final String   DIR_ENABLE_ONLY = "enable only";                                   
    public static final String   NAME_BASED = "NameVirtualHost ";
    public static final String   IPADDRESS = "IPAddress ";                                      
    public static final String   ALLOW_FROM = "Allow from ";
    public static final String   DENY_FROM = "Deny from "; 
    public static final String   TRANSFERLOGMODE_STANDARD = "standard";
    public static final String   TRANSFERLOGMODE_CUSTOM = "custom";
    public static final String   ERRORLOGMODE_STANDARD = "standard";
    public static final String   ERRORLOGMODE_CUSTOM = "custom";
    public static final String   ERRORLOGMODE_SYSLOG = "syslog";
    public static final String   NAME_VIRTUAL_HOST = "NameVirtualHost ";
    public static final String   VIRTUALHOSTMOD_IP_BASED = "ipbased";
    public static final String   VIRTUALHOSTMOD_NAME_BASED = "namebased";
    public static final String   USEDIPADDSMODE_ALL = "all";
    public static final String   USEDIPADDRSMODE_CUSTOM = "custom";
    public static final String   ORDER_ALLOW_DENY = "Order allow,deny";
    public static final String   ORDER_DENY_ALLOW = "Order deny,allow";
    public static final String   ALL_ALLOW = "Allow from all";
    public static final String   USER_DEFAULT_NAME = "apache";
    public static final String   ERRORLOG_DEFAULT_LEVEL = "warn";
    public static final String   HTTP = "http";
    
    public static final String   USERDIRMODE_NOLIMIT = "onlimit";
    public static final String   USERDIRMODE_TRANSLATE = "translate";
    public static final String   USERDIRMODE_DENY = "deny";

    public static final String   SESSION_DIRECTORIES = "modifiedDirectories";
    public static final String   SET_DIR_ADD = "addDirectory";
    public static final String   SET_DIR_EDIT = "editDirectory";
    public static final String   SET_DIR_DEL = "deleteDirectory";
    
    public static final String   FILE_HTTPD_0 = "/etc/group0.setupinfo/httpd/interim/httpd.conf";
    public static final String   FILE_HTTPD_1 = "/etc/group1.setupinfo/httpd/interim/httpd.conf";
    public static final String   FILE_MAIN0_0 = "/etc/group0.setupinfo/httpd/interim/main0.conf";
    public static final String   FILE_MAIN0_1 = "/etc/group0.setupinfo/httpd/interim/main1.conf";
    public static final String   FILE_MAIN1_0 = "/etc/group1.setupinfo/httpd/interim/main0.conf";
    public static final String   FILE_MAIN1_1 = "/etc/group1.setupinfo/httpd/interim/main1.conf";
    public static final String   FILE_VIRTUAL0_0 = "/etc/group0.setupinfo/httpd/interim/virtual0.conf";
    public static final String   FILE_VIRTUAL0_1 = "/etc/group0.setupinfo/httpd/interim/virtual1.conf";
    public static final String   FILE_VIRTUAL1_0 = "/etc/group1.setupinfo/httpd/interim/virtual0.conf";
    public static final String   FILE_VIRTUAL1_1 = "/etc/group1.setupinfo/httpd/interim/virtual1.conf";
    
    public static final String   PAGE_MAINEDIT = "main_edit";
    public static final String   PAGE_VIRTUALADD = "virtual_add";
    public static final String   PAGE_VIRTUALEDIT = "virtual_edit";
    public static final int   ERRORCODE_VIRTUALHOST_EXIST = 2;  
    public static final int   ERRORCODE_DIRECTORY_EXIST = 3;  
    public static final int   ERRORCODE_PORT_USED = 4;
    public static final String   SESSION_DIRECTORY = "session_directory";  
    public static final String   NO_DIRECTORY = "not_directory";
}
