/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: NasConstants.java,v 1.2315 2008/05/28 03:32:04 liy Exp $";
 */


package  com.nec.sydney.atom.admin.base;

public interface NasConstants extends CommonConst{

    public static final String MKFS_FINISHED             = "END";
    //urn name
    public static String URN_TIME_NTP_SERVICE         = "urn:TimeNTPConf";
    public static String URN_NIC_SERVICE             = "urn:NICConf";
    public static String URN_FILTER_SERVICE         = "urn:SecurityFilterConf";
    public static String URN_SNAPSHOT_SERVICE         = "urn:SnapshotConf";
    public static String URN_COMMON_SERVICE         = "urn:MapdCommonConf";
    public static String URN_QUOTA_SERVICE             = "urn:QuotaConf";

     //web service constants
     //-------------NTP/SysTime----------------------------
     //System Files

    public static String SYSTIME_SOAPCLIENT_PATH
                                            = "com.nec.sydney.beans.ntp.SysTimeSOAPClient";
    public static String FILE_CLOCK         = "/etc/sysconfig/clock";
        //public static String FILE_CLOCK     = "clock_test";
    public static String FILE_CRONTAB1         = "/var/spool/cron/root";
    public static String FILE_CRONTAB2         = "/var/spool/cron/nsadmin";
    public static String SCRIPT_SETNTPSRV = "ntp_setsrv.pl";
    public static String SCRIPT_GETNTPSRV = "ntp_getsrv.pl";

    public static String ZONE_INFO_LOCATION     = "/usr/share/zoneinfo";
        //public static String ZONE_INFO_LOCATION = "zonelist_test";

    public static String ISO3166                 = "iso3166.tab";
        //Commands
    public static String COMMAND_DATE             = "date";
        //public static String COMMAND_DATE = "datetest";
    public static String COMMAND_GET_DATE         = "date +%Y%m%d%T";
        //public static String COMMAND_GET_DATE = "datetest +%Y%m%d%T";
    public static String COMMAND_SYNC_HW_CLOCK     = "/sbin/hwclock --systohc";
        //public static String COMMAND_SYNC_HW_CLOCK = "hwclocktest --systohc";
    public static String COMMAND_ADJTIMEX         = "/usr/sbin/ntpdate -s ";
    public static String COMMAND_TIME_CONFIG     = "/usr/sbin/timeconfig";
        //public static String COMMAND_TIME_CONFIG = "timeconfigtest";
        //PERL Scripts
    public static String SCRIPT_SETCRONTAB         = "ntp_setcrontab.pl";
    public static String SCRIPT_SETCLOCK         = "ntp_setclockfile.pl";
        //Null ntpsrv name
    public static String NULL_NTPSRV_NAME         = "n\tull";

        //time zone
    public static String DEFAULT_ZONE_DIR         = "-----";
    public static String DEFAULT_ZONE             = "-----";
    public static String OTHER_ZONE_DIR         = "Others";
    public static String END_ZONE_DIR             = "./.";

        //these names must be identical to those in the JSP file
    public static String TARGET                 = "target";
    public static String TIME_ZONE_ARRAY         = "zonearray";
    public static String TIME_ARRAY_INIT         = "initArray";
        //push button
    public static String TIME_NTP_SYNC             = "Sync/Set";
    public static String TIME_SET_TIME             = "Set Time";
    public static String TIME_SET_ZONE             = "Set TimeZone";
        //radio
    public static String TIME_SYS                 = "sys";
        //select
    public static String TIME_YEAR                 = "year";
    public static String TIME_MONTH             = "month";
    public static String TIME_DAY                 = "day";
    public static String TIME_HOUR                 = "hour";
    public static String TIME_MINUTE             = "minute";
    public static String TIME_SECOND             = "second";
    public static String TIME_DIR                  = "dir";
    public static String TIME_ZONE                 = "zone";
        //checkbox
    public static String TIME_GMT                 = "gmt";
    public static String TIME_SYNC                 = "sync";
    public static String TIME_CHECKBOX_ON         = "on";
        //text
    public static String TIME_NTPSRV             = "ntp_server";
        //submit
    public static String TIME_ACTION             = "action";
        //hidden
    public static String TIME_ZONEINDEX         = "zoneIndex";
    public static String TIME_DIRINDEX             = "dirIndex";
    //----------NTP/SysTime Definition End---------------

    //-------------DNSClient-----------------------------
    public static String COMMAND_HOSTNAME         = "hostname";
    public static String FILE_RESOLV             = "/etc/resolv.conf";
    public static String FILE_NSSWITCH_CONF     = "/etc/nsswitch.conf";
    public static String FILE_HOST_CONF         = "/etc/host.conf";
    public static String FILE_NETWORKNAME        = "/etc/sysconfig/network";
    public static String FILE_HOSTSNAME         = "/etc/hosts";
    public static String SCRIPT_SET_HOSTNAMEFILES     = "dnsclient_sethostnamefiles.pl";
    public static String SCRIPT_GET_DNSANDDOMAIN     = "dnsclient_getdnsanddomain.pl";
    public static String SCRIPT_SET_DNSANDDOMAIN     = "dnsclient_setdnsanddomain.pl";
    public static String SCRIPT_SET_RESOLVORDER     = "dnsclient_setresolvorder.pl";
    public static String NSSWITCH_RESOLVORDER         = "hosts: files dns";
    public static String HOST_RESOLVORDER             = "order hosts,bind";
        //------------DNSClient End-------------------------

    //------------LVM Start----------------------
    public static String COMMAND_VG_DISPLAY         = "/sbin/vgdisplay --colon";
    public static String COMMAND_VG_DISPLAYDETAIL        = "/sbin/vgdisplay -D -v";
    public static String COMMAND_VG_CHANGE             = "/sbin/vgchange";
    public static String COMMAND_VG_EXTEND             = "/sbin/vgextend";
    public static String COMMAND_VG_REMOVE             = "/sbin/vgremove";
    public static String COMMAND_VG_CREATE             = "/sbin/vgcreate -s 32M";
    public static String COMMAND_LV_EXTEND             = "/sbin/lvextend -l";
    public static String COMMAND_LV_REMOVE             = "/sbin/lvremove";
    public static String COMMAND_LV_CREATE             = "/sbin/lvcreate -l";
    public static String COMMAND_PV_CREATE             = "/sbin/pvcreate";
    public static String COMMAND_LVMAKE                = "/sbin/lvmake";
    public static String COMMAND_LVDELETE              = "/sbin/lvdelete";
    public static String COMMAND_LVINCREASE            = "/sbin/lvincrease";
    public static String COMMAND_VG_EXPORT            ="/sbin/vgexport";
    public static String COMMAND_VG_IMPORT            ="/sbin/vgimport";
    public static String COMMAND_GET_PLATFORM_TYPE     = "cat /proc/sys/kernelplatform-type";
    public static String FILE_PLATFORM_TYPE         = "/proc/sys/kernelplatform-type";
    public static String FILE_VG_PATH                 = "/proc/lvm/VGs/";
    public static String FILE_MTAB                     = "/etc/fstab";
    public static String FILE_PROC_SCSI             = "/proc/scsi/scsi";
    public static String SCRIPT_CREATECLUSTERLV        ="lvm_createClusterLV";
    public static String SCRIPT_CREATELV            ="lvm_createLV";
    public static String SCRIPT_REMOVEACTIVELV        ="removeActiveLV";
    public static String SCRIPT_REMOVEINACTIVELV        ="removeInActiveLV";
    //delete some lvm_*.pl used by soap xingyh 2007/04/25
    public static int LOCATION_PE_SIZE                 = 13;
    public static String DISK_TYPE_0                 = "0";
    public static String DISK_TYPE_8E                 = "8e";
    public static int NO_VG                         = 5;
    public static String NAS_HEAD_MACHINE_FLAG         = "10000";
    public static String NAS_ETC_FILENAME             = "vg_assign";
    //add by maojb on 6.5
    public static String USRLOCALBINLVM            = "/usr/local/bin/lvm";
    public static String SCRIPT_CLUSTERCOPY            = "cluster_copy2myfriend.sh";
    public static String NODE0ETCFILENAME            = "/etc/group0/vg_assign";
    public static String NODE1ETCFILENAME            = "/etc/group1/vg_assign";
    public static String NODE0MOUNTPOINTFILE        = "/etc/group0/cfstab";
    public static String NODE1MOUNTPOINTFILE        = "/etc/group1/cfstab";

    //added by hujing on 6/26/2002
    public static String CFSTAB_FILE_NAME       = "cfstab";


    //------------LVM End------------------------

    //------------NIC constants------------------
    public static String SCRIPT_GET_NICINFO     = "nic_getnic.pl";
    public static String SCRIPT_GET_ROUTEINFO   = "nic_getroute.pl";
    public static String SCRIPT_SHOW_PURPOSE    = "nic_needshowpurpose.pl";
    public static String SCRIPT_SET_NIC_ONBOOT  = "nic_setnic.pl";
    public static String SCRIPT_GET_PURPOSE     = "nic_getpurpose.pl";
    public static String NIC_PURPOSE_FILE_NAME  = "/etc/sysconfig/kamuifw";
    public static String NIC_PURPOSE_UNDEFINED  = "Undefined";
    public static String FILE_STATIC_ROUTES     = "/etc/sysconfig/static-routes";
    public static String FILE_STATIC_ROUTES_IN_FRIEND_NODE = "/etc/sysconfig/static-routes:0";
    //------------NIC End------------------------
    //------------Filter constants---------------
    //public static String COMMAND_SETRULES = "/sbin/iptables -A";
    //public static String COMMAND_GETRULES = "/sbin/iptables -L";
    public static String COMMAND_FLUSHDEFAULT        = "/sbin/iptables -F Defaultchain";
    public static String SCRIPT_FILTER_GET_RULES    = "securityfilter_getrules.pl";
    public static String SCRIPT_FILTER_GET_DEFAULT    = "securityfilter_getdefault.pl";
    public static String SCRIPT_FILTER_GET_CHAINS    = "securityfilter_getchains.pl";
    public static String SCRIPT_FILTER_MODIFYCHAIN    = "securityfilter_rulesaction.pl";
    public static String SCRIPT_FILTER_FIRSTTIME    = "securityfilter_firsttime.pl";
    public static String nasServices[]={"telnet","ftp","NFS","MVDSync","CIFS","RPC"
                ,"NDMP","Rsh","SSH","iscsi"};
    public static int INSERT_RULE    = 1;
    public static int DELETE_RULE    = 2;
    public static int EDIT_RULE        = 3;
    public static int WARNING_FILTER_NOTSTARTNFS = 3;

    //------------Snapshot------------------------
    /**** used in MountPointBean.java ****/
    public static final String MP_REDIRECT_ADDR_SNAPSHOT
                        = "../snapshot/snapShow.jsp"
                    ,MP_REDIRECT_ADDR_SNAPSHOT_NSVIEW
                    = "../snapshot/snapshot4nsview.jsp"
                    ,MP_REDIRECT_ADDR_SNAPSHOT_REPLICA_LIST
                    = "/nsadmin/snapshot/replicaSnapshotList.do"
                    ,MP_REDIRECT_ADDR_SNAPSHOT_REPLICA_LIST_NSVIEW
                    = "/nsadmin/snapshot/replicaSnapshotListTop.do"
                    // ADDED BY BAIWQ 2002-01-21 FOR MAPD.JSP
                    ,MP_REDIRECT_ADDR_MAPD
                        = "../mapd/getvolumeinfo.jsp?Previous=mountList"
                    ,MP_REDIRECT_ADDR_QUOTA
                        = "../quota/quotaset.jsp"
                    ,MP_REDIRECT_ADDR_MAPD_UNIX
                        = "../mapd/unix.jsp"
                    ,MP_REDIRECT_OTHER_ADDR
                        = "where"
                    ,MP_SELECT_EXPORTROOT_NAME
                        = "exportRoot"
                    ,MP_SELECT_MOUNTPOINT_NAME
                        = "mountPoint"
                    ,MP_SELECT_HEX_MOUNTPOINT_NAME
                        = "hexMountPoint"
                    ,MP_SESSION_EXPORTROOT
                        = "SESSION_MAPD_EXPORTROOT"
                    ,MP_SESSION_MOUNTPOINT
                        = "SESSION_MAPD_MOUNTPOINT"
                    ,MP_SESSION_HEX_MOUNTPOINT
                        = "SESSION_MAPD_HEX_MOUNTPOINT"
                    ,MP_NEXT_ACTION_PARAM
                        = "nextAction"
                    ,MP_NEXT_ACTION_SNAPSHOT
                        = "Snapshot"
                    ,MP_NEXT_ACTION_MAPD
                        = "mapd"
                    ,MP_NEXT_ACTION_QUOTA
                        = "quota"
                    ,MP_ERROR_WORD
                        = "Can't get export root list and mount point list !"
                    ,MP_NULL_OPTION
                        = "--------"
                    ;
    /**** used in SnapSOAPClient.java ****/
    public static String    SOAPCLIENT_GETROOTLIST
                        = "getRootList"
                    ,SOAPCLIENT_GETSNAPSCHEDULE
                        = "getSnapSchedule"
                    ,SOAPCLIENT_ADDSNAPSCHEDULE
                        = "addSnapSchedule"
                    ,SOAPCLIENT_DELETESNAPSCHEDULE
                        = "deleteSnapSchedule"
                    ,SOAPCLIENT_SETCOWLIMIT
                        = "setCOWLimit"
                    ,SOAPCLIENT_GETCOWLIMIT
                        = "getCOWLimit"
                    ,SOAPCLIENT_CREATESNAP
                        = "createSnap"
                    ,SOAPCLIENT_DELETESNAP
                        = "deleteSnap"
                    ,SOAPCLIENT_GETSNAPLIST
                        = "getSnapList"
                    ,SOAPCLIENT_PATH_AND_NAME
                        = "com.nec.sydney.beans.snapshot.SnapSOAPClient"
                    ;

    //following constants add by Wang Zhoufei, 2002/1/4
    public static int CRON_PERIOD_WEEKDAY   = 1
                    ,CRON_PERIOD_MONTHDAY   = 2
                    ,CRON_PERIOD_DAILY      = 3
                    ,CRON_PERIOD_DIRECTEDIT = 4;
    //used in SnapShowBean, added by bai weiqin,2002/1/7
    public static String SESSION_MOUNT_POINT            = "mountPoint";
    public static String SNAPSHOT                       = "snapshot";
    public static String URL_MOUNT_POINT_JSP            
                            = "../common/mountpoint.jsp?nextAction=Snapshot";
    public static String URL_SNAP_SHOW_JSP              = "snapShow.jsp";
    public static String URL_SNAP_SCHEDULE_JSP          = "snapSchedule.jsp";
    public static String REQUEST_PARAMETER_ACT          = "act";
    public static String REQUEST_PARAMETER_DUSERNAME    = "dusername";

    public static String REQUEST_PARAMETER_COW_LIMIT    = "cowLimit";
    public static String REQUEST_PARAMETER_TYPE    = "type";
    public static String FORM_ACTION_SET_LIMIT          = "setLimit";
    public static String FORM_ACTION_CREATE_SNAPSHOT    = "createSnap";
    public static String REQUEST_PARAMETER_SNAP_NAME    = "snapName";
    public static String REQUEST_PARAMETER_DELETE_SNAP_NAME = "deleteSnapName";
    public static String FORM_ACTION_DELETE_SNAPSHOT        = "deleteSnap";
    public static String SNAPSHOT_ADMIN_NOT_SET             
                                = "The NAS Administrator has not been set!";

    public static String PATH_SNAPSHOT_CRON         = "/var/spool/cron/";
    public static String SCRIPT_SNAP_CRONJOB        = "sudo /home/nsadmin/bin/snap_cronjob.pl";
    public static String SCRIPT_SNAP_GETSCHEDULE    = "snap_getSchedule.pl";
    public static String SCRIPT_ADD_SNAP_SCHEDULE   = "snap_addSchedule.pl";
    public static String SCRIPT_DEL_SNAP_SCHEDULE   = "snap_deleteSchedule.pl";
    public static String SCRIPT_SNAP_HEXMP2DEVNAME  = "snap_hexMP2DevName.pl";//2003/07/14 add by maojb
    public static String COMMAND_SNAPSETLIMIT       = "/bin/snap_setLimit.pl";//"sxfs_snapshot -p" limit mountPoint
    public static String COMMAND_SNAPGETLIMIT       = "/bin/snap_getLimit.pl";//"sxfs_snapshot -P" mountPoint
    public static String COMMAND_SNAPCREATE         = "/bin/snap_createSnap.pl";//"sxfs_snapshot -c -n" name mountPoint
    public static String COMMAND_SNAPDELETE         = "/bin/snap_deleteSnap.pl";//"sxfs_snapshot -d -n" name mountPoint
    public static String COMMAND_SNAPGETLIST        = "/bin/snap_getSnap.pl";//"sxfs_snapshot" mountPoint
    //------------Snapshot End------------------------

    //------------MAPD Start----------------------
    public static String SCRIPT_MAPD_ADD             = "mapd_add.pl ";
    public static String SCRIPT_MAPD_REPLACE         = "mapd_replace.pl ";
    public static String SCRIPT_MAPD_GETREGION         = "mapd_getregion.pl";
    public static String SCRIPT_MAPD_AUTH             = "mapd_auth.pl";
    public static String FILE_MAPD_YPCONF             = "/etc/yp.conf";
    public static String FILE_MAPD_SMBCONF             = "/etc/smb.conf";
    public static String COMMAND_IMS_DOMAIN         = "/usr/bin/ims_domain";
    public static String COMMAND_SMB_RM         = "rm -f";
    public static String COMMAND_SMB_RM_PATH         = "nas_cifs";
    public static String COMMAND_SMB_RM_FILE         = "secrets.tdb";

    public static String COMMAND_SMBPASSWD_SH         = "/bin/ns_smbpasswd.sh";
    public static String COMMAND_CIFSSTART_SH         = "/bin/ns_nascifsstart.sh";

    public static String COMMAND_MOUNT                 = "mount";
    public static String FILETYPE_UNIX                 = "sxfs";
    public static String FILETYPE_NT                 = "sxfsfw";
    public static String SESSION_EXPORT_ROOT         = "exportRoot";
    public static String REQUEST_PARAMETER_USAGE    = "usage";
    public static String REQUEST_PARAMETER_USAGE_NFSVALUE         = "nfsUsage";
    public static String REQUEST_PARAMETER_USAGE_CIFSVALUE         = "cifsUsage";

    public static String REQUEST_PARAMETER_PASSWORD                = "password";
    public static String REQUEST_PARAMETER_USERNAME                = "username";

    public static String REQUEST_PARAMETER_DOMAIN                = "domain";
    public static String REQUEST_PARAMETER_SERVER                = "server";
    public static String REQUEST_PARAMETER_FIRSTSERVER            = "firstServer";
    public static String REQUEST_PARAMETER_UNSET                = "unset";
    public static String REQUEST_PARAMETER_UNSET_VALUE            = "unSet";
    public static String REQUEST_PARAMETER_CIFSACCESS            = "cifsAdd";
    public static String REQUEST_PARAMETER_CIFSACCESS_VALUE        = "checked";
    public static String REQUEST_PARAMETER_USEMAP                 = "nfsMap";
    public static String REQUEST_PARAMETER_USEMAP_VALUE            = "useMapOption";
    public static String REQUEST_PARAMETER_USENOMAP_VALUE        = "noMapOption";
    public static String REQUEST_PARAMETER_PREVIOUS             = "Previous";
    public static String REQUEST_PARAMETER_PREVIOUS_MOUNT         = "mount";
    public static String REQUEST_PARAMETER_PREVIOUS_MOUNTLIST     = "mountList";
    public static String REQUEST_PARAMETER_AUTH                 = "auth";
    public static String REQUEST_PARAMETER_AUTHNIS                = "authNIS";
    public static String REQUEST_PARAMETER_AUTHPWD                = "authPass";
    public static String REQUEST_PARAMETER_AUTHSHR                = "authSHR";
    public static String REQUEST_PARAMETER_AUTHDMC                = "authDMC";
    public static String REQUEST_PARAMETER_NAMECHANGE             = "nameChange";
    public static String REQUEST_PARAMETER_NAMECHANGE_VALUE     = "yes";
    public static String REQUEST_PARAMETER_SET                     = "set";
    public static String REQUEST_PARAMETER_SET_VALUE             = "Set";
    public static String REQUEST_PARAMETER_UNAME                = "userName";
    public static String REQUEST_PARAMETER_GNAME                = "groupName";
    public static String REQUEST_PARAMETER_GID                    = "GID";
    public static String REQUEST_PARAMETER_UID                    = "UID";
    public static String AUTH_SHR_PATH                        = "/etc/samba/%r/%D/smbpasswd";

    public static String SCRIPT_MAPD_SMB_ADD         = "mapd_smb_add.pl ";
    public static String PASSWD                        = "passwd";
    public static String GROUP                        = "group";
    public static String GLOBALDOMAIN                = "DEFAULT";
    public static String MAPD_UNAME                    = "uname=";
    public static String MAPD_UID                    = "uid=";
    public static String MAPD_GNAME                    = "gname=";
    public static String MAPD_GID                    = "gid=";

    public static String COMMON_CHECKOUT            = "checkout";
    public static String COMMON_CHECKIN                = "checkin";
    public static String COMMON_ROLLBACK            = "rollback";
    public static String SCRIPT_COMMON_GETSMBCONF    = "common_getsmbconf.pl";
    //------------MAPD End----------------------

    //------------nfs Start----------------------
    public static int NAS_ERROR_EXPORT_DUPLICATED      = 20;
    public static int NAS_ERROR_EXEC_IMS_DOMAIN        = 2;
    public static int NAS_ERROR_EXEC_IMS_NATIVE        = 3;
    public static int NAS_WARNING_PATH_NO_EXIST        = 2;
    public static int NAS_WARNING_VERSION_NOT_CONSISTENT= 100;
    public static int NAS_WARNING_VERSION_NOT_EXIST= 101;

    public static String COMMAND_IMS_NATIVE            = "/usr/bin/ims_native";

    public static String SCRIPT_NFS_GET_EXPORT_DETAIL    = "nfs_GetExportDetail.pl ",
                    SCRIPT_NFS_GET_EXPORT_LIST            = "nfs_GetExportDir.pl ",
                    SCRIPT_NFS_GET_PICKUP_LIST            = "nfs_GetPickupList.pl ",
                    SCRIPT_NFS_CHANGE_EXPORT_INFO        = "nfs_ChangeExportInfo.pl ",
                    SCRIPT_NFS_ADD_EXPORT_INFO            = "nfs_AddExportInfo.pl ",
                    SCRIPT_NFS_CHANE_ORDER                = "nfs_ChangeOrder.pl ",
                    SCRIPT_NFS_GET_DIR                    = "nfs_GetDir.pl ";
    public static String    NFS_NATIVETYPE_NIS            = "NIS";
    public static String    NFS_NATIVETYPE_PWD            = "PWD";
    public static String    NFS_PASSWD_FILE                = "passwd";
    public static String    NFS_VERSION                    = "VERSION";

    public static int NFS_NOMAP        = 1;
    public static int NFS_MAP        = 0;
    public static int NFS_ACCESS    = 1;
    public static int NFS_NOACCESS    = 0;
    public static int NFS_READONLY    = 1;
    public static int NFS_WRITEREAD    = 0;
    public static int NFS_SUBTREECHECK_ON    = 1;
    public static int NFS_SUBTREECHECK_OFF    = 0;
    public static int NFS_NEST_NO            = 1;
    public static int NFS_NEST_YES            = 0;
    public static int NFS_EVERYBODY            = 1;
    public static int NFS_NOBODY            = 0;
    public static int NFS_HIDE                = 1;
    public static int NFS_NOHIDE            = 0;
    public static int NFS_ANON                = 0;
    public static int NFS_NOANON            = 1;

    //code
    public static String    SJIS            = "SJIS",
                            EUC                = "EUC";
    //------------nfs End----------------------

    //------------exportroot Start----------------------
    public static String EXPORTROOT_SOAPCLIENT_PATH        = "com.nec.sydney.beans.mapdcommon.ExportRootSOAPClient";
    public static String MKDIR_COMMAND                    = "/bin/exportroot_add_expgrps.pl";
    public static String REMOVE_DIR_COMMAND                = "/bin/exportroot_del_expgrps.pl";
    public static String SCRIPT_DEL_NFS                    = "/bin/exportroot_deleteNFS.pl";
    public static String SCRIPT_DEL_LOCAL_DOMAIN_PATH    = "exportroot_delLocalDomainPath.pl";
    public static String SCRIPT_DEL_ER                    = "exportroot_deleteVs.pl";
    public static String SCRIPT_DEL_FSTAB                = "exportroot_deletefstab.pl";
    public static String REQUEST_PARAMETER_EXPORT_ROOT_ACT            = "act";
    public static String REQUEST_PARAMETER_EXPORT_ROOT_NAME            = "exportRootName";
    public static String REQUEST_PARAMETER_CODE_PAGE                = "codePage";
    public static String REQUEST_PARAMETER_DELETE_EXPORT_ROOT_NAME     = "deleteName";
    public static String URL_EXPORT_ROOT_JSP                        = "exportRoot.jsp";
    public static String EXPORTROOT_FORM_ACTION_ADD                    = "add";
    public static String EXPORTROOT_FORM_ACTION_DELETE                = "delete";
    public static String FAILED_TO_ADD_EXPORTROOT_IN_XML_File         = "Failed to add exportRoot in XML File!";
    public static String STILL_HAVE_MOUNT                             = "Still Have mount point been not umounted!";
    public static final int     WHICH_NODE_ID0 = 256;
    public static final int     WHICH_NODE_ID1 = 257;


    //------------exportroot End----------------------

    public static String SCRIPT_GETDIRECTMP        = "mapdcommon_getPathList.pl";
    public static String SCRIPT_ISSUBMOUNT        = "mapdcommon_isPathExist.pl";

    //------------Quota Start-------------------------
    //modify by zhangjun:support the space
    public static String COMMAND_SETREPORT           = "\"/usr/sbin/setquota\"";
    public static String COMMAND_SETGRACETIME_USER   = "-tu";
    public static String COMMAND_SETGRACETIME_GROUP  = "-tg";
    public static String COMMAND_SETGRACETIME_DIR    = "-dt";
    public static String COMMAND_GETREPORT           = "\"/usr/sbin/repquota\"";
    public static String COMMAND_GET_OPTION_USER     = "-uv";
    public static String COMMAND_GET_OPTION_USER_DIR = "-uvd";
    public static String COMMAND_GET_OPTION_GROUP    = "-gv";
    public static String COMMAND_GET_OPTION_GROUP_DIR= "-gvd";
    public static String COMMAND_GET_OPTION_DIR      = "-vd";
    
    public static String COMMAND_ON                  = "\"/sbin/quotaon\"";
    public static String COMMAND_OFF                 = "\"/sbin/quotaoff\"";
    public static String COMMAND_OPTION_ENFORCE      = "enforce";
    public static String COMMAND_OPTION_QUOTA        = "-x";
    public static String COMMAND_OPTION_DIRQUOTA     = "-ugdx";
    
    public static String SCRIPT_GETQUOTA_GRACETIME   = "/bin/quota_getGraceTime.pl";
    public static String SCRIPT_DIRQUOTA_GETDATASET  = "/bin/dirquota_getDataSet.pl";
    public static String SCRIPT_GETONEREPORT         = "quota_getOneReport.pl";
    //end of modify
    
    public static int DAY_SECONDS                     = 86400 ;
    public static String TEMPLATE_FLAG                 = "TEMPLATE";
    public static String REP_STATUS_START            = "*** Status";
    public static String IMS_CTL_ERR_START            = "ioctl failed";
    public static String REPQUOTA_STATUS_ON            = "ON";
    public static String REPQUOTA_STATUS_OFF        = "OFF";
    public static String SCRIPT_SETQUOTA             = "quota_setquota.pl";
    public static String SCRIPT_SETQUOTA_GRACETIME     = "quota_setgracetime.pl";
    public static String SCRIPT_GETREPORT             = "quota_getreport.pl";
    public static String SCRIPT_CHANGEQUOTA         = "quota_changequota.pl";

    public static String SCRIPT_GET_FS_TYPE            = "quota_getfstype.pl";
    public static String SCRIPT_GET_ID_BY_NAME        = "quota_getidbyname.pl";
    public static String SCRIPT_GET_NAME_BY_ID        = "quota_getnamebyid.pl";

    public static String FS_UID_FLAG                = "user";
    public static String FS_GID_FLAG                = "group";

    public static String NAMETOID_CONVERTERR_MSG     = "ioctl failed";
    public static final int BLOCK_SIZE      = 1024;

    //-------------Quota End---------------------------

    //------------fileSystem Start----------------------
    public static String FS_FILESYSTEM_SOAPCLIENT_PATH    = "com.nec.sydney.beans.filesystem.FileSystemSOAPClient";

    public static String FS_SCRIPT_CHECK_MOUNT            = "/bin/filesystem_canMount.pl";
    public static String FS_COMMAND_MKFS                = "/sbin/mkfs";
    public static String FS_COMMAND_SCRIPT_MOUNT        = "/bin/filesystem_mount.pl";



    /////////
    public static String FS_REQUEST_PARAMETER_ACT             = "act";
    public static String FS_FORM_ACTION_EXPORT_IN_SESSION     = "exportInSession";
    public static String FS_FORM_ACTION_PICK_UP             = "pickup";
    public static String FS_FORM_ACTION_CREATE                 = "create";
    public static String FS_FORM_ACTION_EXTEND                 = "extend";
    public static String FS_FORM_ACTION_U_MOUNT             = "umount";
    public static String FS_FORM_ACTION_MOUNT                 = "mount";


    public static String FS_FORM_VALUE_OF_CHECKED_TEMP         = "yes";
    public static String FS_FORM_VALUE_OF_CHECKED_MOPTION     = "yes";
    public static String FS_MOUNT_POINT_UMOUNT_SUCCESS         = "Umount success!";
    public static String FS_REQUEST_PARAMETER_EXPORT_ROOT_NAME = "exportroot";
    public static String FS_REQUEST_PARAMETER_DEVICE_NAME     = "deviceName";
    public static String FS_REQUEST_PARAMETER_TEMP             = "temp";
    public static String FS_REQUEST_PARAMETER_CONFIG_OPTION = "moption";
    public static String FS_REQUEST_PARAMETER_MOUNT_POINT_NAME = "mountPointName";
    public static String FS_REQUEST_PARAMETER_HEX_MOUNT_POINT = "hexMountPoint";
    //////////////

    public static int NAS_EXCEP_NO_FILESYSTEM_UMOUNT_DEVICE_BUSY = 0x0000220A;
    public static int FILESYSTEM_DIRECT_RELATION             = 1;
    public static int FILESYSTEM_TYPE_RELATION                 = 2;

    public static String FILESYSTEM_TYPE_SXFSFW             = "sxfsfw";

    public static String FS_SCRIPT_FILESYSTEM_AUTHCMD        = "filesystem_authcmd.pl";

    public static String FS_FILESYSTEM_HASFORGOTTEN            = "true";
    public static String FS_MARK                            = "0x2f";
    public static String FILESYSTEM_FAILED                     = "0";
    public static String FILESYSTEM_FAILED_FORGOT             = "1";
    public static String FILESYSTEM_SUCCESS_FORGOT             = "2";
    public static String FILESYSTEM_SUCCESS                 = "3";
    public static String CODEPAGE_EUC_JP    = "EUC-JP";
    public static String CODEPAGE_SJIS      = "SJIS";
    public static String CODEPAGE_ENGLISH   = "English";
//utf-8 maojb 2004.1.6 
    public static String CODEPAGE_UTF8   = "UTF8";   

    //------------fileSystem End----------------------

    // ++++++++++++++++ CIFS START ++++++++++++++++++++++++

    public static String SCRIPT_CIFS_SET_SMB_GLOBAL_OPTION_NOCHECK = "cifs_setSmbGlobalOptionNoCheck.pl";

    // ++++++++++++++++ CIFS END   ++++++++++++++++++++++++

    // ++++++++++++++++ REPLICATION START   ++++++++++++++++++++++
    public static final int AUTO_CHECK = 1;
    public static final int CODEPAGE_CHECK = 2;

    public static final String REPLICATION_FSET_STATUS_UNUSED = "local";
    public static final String REPLICATION_FSET_STATUS_EXPORTED = "export";
    public static final String REPLICATION_FILESET_SEPARATOR="#";
    // ++++++++++++++++ REPLICATION END   ++++++++++++++++++++++++

    // ++++++++++++++++ Port Failover START   ++++++++++++++++++++++

    public static final String PORT_FAILOVER_PARAMETER_VALUE_GROUPINSESSION="groupInSession";
    public static final String PORT_FAILOVER_PRIORITY_SEPERATOR = ":";
    // ++++++++++++++++ Port Failover END   ++++++++++++++++++++++++

    // ++++++++++++++++ Cluster START   ++++++++++++++++++++++
    public static final String CLUSTER_DIR_ETC_GROUP    = "/etc/group%/";
    public static final String CLUSTER_FILE_CFSTAB      = CLUSTER_DIR_ETC_GROUP + "cfstab";
    public static final String CLUSTER_FILE_EXPORTS     = CLUSTER_DIR_ETC_GROUP + "exports";
    public static final String CLUSTER_DIR_NAS_CIFS     = CLUSTER_DIR_ETC_GROUP + "nas_cifs";
    public static final String CLUSTER_FILE_IMS_CONF    = "/etc/group%/ims.conf";
    public static final String CLUSTER_FILE_SMB_CONF    = CLUSTER_DIR_NAS_CIFS + "smb.conf";
    public static final String CLUSTER_FILE_MVD_FILESET = CLUSTER_DIR_ETC_GROUP + "mvdsync.fileset";
    public static final String CLUSTER_FILE_MVD_EXPORT  = CLUSTER_DIR_ETC_GROUP + "mvdsync.export";
    public static final String CLUSTER_FILE_MVD_IMPORT  = CLUSTER_DIR_ETC_GROUP + "mvdsync.import";
    public static final String CLUSTER_FILE_GROUP_EXPGRPS = CLUSTER_DIR_ETC_GROUP + "expgrps";
    // ++++++++++++++++ Cluster END   ++++++++++++++++++++++++
}
