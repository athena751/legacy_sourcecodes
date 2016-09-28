/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: NSExceptionMsg.java,v 1.2305 2008/06/17 06:41:18 liy Exp $";
 */

package  com.nec.sydney.atom.admin.base;
 

public interface NSExceptionMsg {


    // The common the error NO. and msg  (0x00000001 - 0x00000100)
    public static final int     NAS_EXCEP_NO_INVALID_PARAMETER         = 0x00000001;
    public static final int     NAS_EXCEP_NO_SOAP_INIT_FAULT             = 0x00000002;
    public static final int     NAS_EXCEP_NO_SOAP_CALL_FAULT             = 0x00000003;
    public static final int     NAS_EXCEP_NO_SOAP_SET_PARAMETER_FAULT     = 0x00000004;


    public static final int NAS_EXCEP_NO_CHECKOUT_FAILED             = 0x00000005;
    public static final int NAS_EXCEP_NO_CHECKIN_FAILED             = 0x00000006;
    public static final int NAS_EXCEP_NO_FILE_ROLLBACK_FAILED         = 0x00000007;

    public static final int NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED         = 0x00000008;
    public static final int NAS_EXCEP_NO_CMD_FAILED                 = 0x00000009;

    //used in SysTimeSOAPServer.java
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_GETCLOCKINFO     = 0x00000103;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_GETNTPSRV     = 0x00000104;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_GETTIMEZONE     = 0x00000105;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_SETDATE         = 0x00000106;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_SETTIMEZONE     = 0x00000107;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_WRITECLOCKFILE= 0x00000108;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_SETSYNC         = 0x00000109;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_SETNTPSRV     = 0x0000010A;
    public static final int NAS_EXCEP_NO_SOAP_SYSTIME_WRITECRONFILE = 0x0000010B;
    public static final int     NAS_EXCEP_NO_SOAP_SET_DNSCLIENT_DNSRESOLVORDER = 0x00000157;            

    public static final int     NAS_EXCEP_NO_SOAP_GET_HOSTNAME                 = 0x00000159;            
    public static final int     NAS_EXCEP_NO_SOAP_SET_HOSTNAMEFILE             = 0x0000015A;            
    public static final int     NAS_EXCEP_NO_SOAP_GET_NAMESERVERANDDOMAIN         = 0x0000015B;            
    public static final int     NAS_EXCEP_NO_SOAP_SET_NAMESERVERANDDOMAIN         = 0x0000015C;            
    // end of DNSClientSOAPServer and DNSClientBean
        
    //LVM Exception NO. and msg    (0x00000201 - 0x00000700)
    // lvcreate exception NO. = 0x00000201 + return value (0x00000201 - 0x00000270)
    public static final int NAS_EXCEP_NO_LVM_LVCREATE_CMD = 0x00000201;            

    // lvremove exception NO. = 0x00000271 + return value (0x00000271 - 0x000002e0)
    public static final int NAS_EXCEP_NO_LVM_LVREMOVE_CMD = 0x00000271;            

    // lvextend exception NO. = 0x000002e1 + return value (0x000002e1 - 0x00000350)
    public static final int     NAS_EXCEP_NO_LVM_LVEXTEND_CMD = 0x000002e1;            

    // vgchange exception NO. = 0x00000351 + return value (0x00000351 - 0x000003C0)
    public static final int     NAS_EXCEP_NO_LVM_VGCHANGE_CMD = 0x00000351;            

    // vgdisplay exception NO. = 0x000003c1 + return value (0x000003C1 - 0x00000430)
    public static final int     NAS_EXCEP_NO_LVM_VGDISPLAY_CMD = 0x000003c1;            

    // vgcreate exception NO. = 0x00000431 + return value (0x00000431 - 0x000004a0)
    public static final int     NAS_EXCEP_NO_LVM_VGCREATE_CMD = 0x00000431;            

    // vgextend exception NO. = 0x000004a1 + return value (0x000004a1 - 0x00000510)
    public static final int     NAS_EXCEP_NO_LVM_VGEXTEND_CMD = 0x000004a1;            

    // vgremove exception NO. = 0x00000511 + return value (0x00000511 - 0x00000580)
    public static final int     NAS_EXCEP_NO_LVM_VGREMOVE_CMD = 0x00000511;            

    // pvcreate exception NO. = 0x00000581 + return value (0x00000581 - 0x000005f0)
    public static final int     NAS_EXCEP_NO_LVM_PVCREATE_CMD = 0x00000581;            

    // LVM other exception (0x000005f1 - 0x00000660)
    public static final int NAS_EXCEP_NO_LVM_JAVA_CMD         = 0x000005f1;

    public static final int NAS_EXCEP_NO_LVM_LFDISK_L_CMD     = 0x000005f2;

    public static final int NAS_EXCEP_NO_LVM_GETDISK         = 0x000005f5;
    
    public static final int NAS_EXCEP_NO_LVM_CREATEDISK     = 0x000005f6;

    public static final int NAS_EXCEP_NO_LVM_CREATELV         = 0x000005f7;
    
    public static final int NAS_EXCEP_NO_LVM_GETMOUNT         = 0x000005f8;

    // Other Component exception(0x00000661 - )

    //NIC Exception NO. and msg    (0x00000701 - 0x00000800)
    public static final int NAS_EXCEP_NO_NIC_GETNICDETAIL_CMD       = 0x00000701;
    public static final int NAS_EXCEP_NO_NIC_SETNICDETAIL_CMD       = 0x00000702;

    public static final int NAS_EXCEP_NO_NIC_GETNICINFO_CMD         = 0x00000704;
    public static final int NAS_EXCEP_NO_NIC_SETGATEWAY_CMD         = 0x00000705;
    
    public static final int NAS_EXCEP_NIC_IP_EXIST                  = 0x00000707;
    public static final int NAS_EXCEP_NIC_SET_FAILED                = 0x00000708;
    
    public static final int NAS_EXCEP_NIC_ROUTE_DEL_FAILED          = 0x00000709;
    public static final int NAS_EXCEP_NIC_ROUTE_ADD_FAILED          = 0x0000070a;
    public static final int NAS_EXCEP_NIC_ROUTE_EXIST               = 0x0000070b;
    public static final int NAS_EXCEP_NIC_FAILED_CHANGE_STATIC_ROUTES   = 0x0000070c;
    public static final int NAS_EXCEP_NIC_ACTION_FAILED_IN_FRIEND_NODE  = 0x00000710;
    public static final int NAS_EXCEP_NIC_DIFFERENT_NETWORK_OR_NETMASK  = 0x00000711;
    public static final int NAS_EXCEP_NIC_FAILED_UP_NETWORK_INTERFACE   = 0x00000712;
    //end of NIC Exception  (0x00000801 - 0x00000900)

    //Filter Exception NO. and msg    (0x00000701 - 0x00000800)

    public static final int NAS_EXCEP_NO_FILTER_INVALID_RULESPARAM  = 0x0000080a;
    public static final int NAS_EXCEP_NO_FILTER_MODIFYCHAIN_CMD     = 0x0000080d;
    public static final int NAS_EXCEP_NO_FILTER_NOTSTARTNFS         = 0x0000080e;
    public static final int NAS_EXCEP_NO_FILTER_SERVICENOTEXIST     = 0x0000080f;

    //end of Filter Exception  (0x00000801 - 0x00000900)
    
    //snapShot exception NO. and Msg.
    
    public static final int NAS_EXCEP_NO_SNAPSHOT_BEAN_SCHEULENAME          = 0x0000090A;
    public static final int NAS_EXCEP_NO_SNAPSHOT_BEAN_GENERATION           = 0x0000090B;
    public static final int NAS_EXCEP_NO_SNAPSHOT_BEAN_SCHEDULE_EXIST       = 0x0000090C;
    public static final int NAS_EXCEP_NO_SNAPSHOT_ADD_SCHEDULE_FAILED       = 0x0000090d;
    public static final int NAS_EXCEP_NO_MOUNTPOINT_BEAN_NEXTACTION         = 0x0000090E;
    public static final int NAS_EXCEP_NO_SNAPSHOT_BEAN_SCHEDULE_TIME_EXIST  = 0x0000090F;
    public static final int NAS_EXCEP_NO_ADD_SNAPSHOT_CMD_FAILED            = 0x00000910;
    public static final int NAS_EXCEP_NO_ADD_SNAPSHOT_NAME_WRONG            = 0x00000911;
    public static final int NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED       = 0x00000912;
    public static final int NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED_DELSCH      = 0x00000913;

    //end of snapShot Exception  (0x00000901 - 0x0000095D)
    
    //Mapd exception NO. and Msg.(0x0000095E - 0x00000A00)
    
    public static final int NAS_EXCEP_NO_MAPD_ADDXMLFAILED                = 0x00000957;
    public static final int NAS_EXCEP_NO_MAPD_EDITXML_ERROR_NOTDOMAIN    = 0x00000958;
    public static final int NAS_EXCEP_NO_MAPD_EDITXML_ERROR_CANNOTEDIT    = 0x00000959;
    public static final int NAS_EXCEP_NO_MAPD_LOCALDOMAIN_FAILED        = 0x0000095A;
    public static final int NAS_EXCEP_NO_MAPD_NIS_EXIST_FAILED            = 0x0000095B;
    public static final int NAS_EXCEP_NO_MAPD_NIS_SERVER_FAILED            = 0x0000095c;
    public static final int NAS_EXCEP_NO_MAPD_DMC_SMBPASSWD_FAILED            = 0x0000095d;
    public static final int NAS_EXCEP_NO_MAPD_LDAP_ADD_FAILED            = 0x0000095e;

    //end of Mapd Exception (0x0000090E - 0x00000A00)
    
    //ExportRoot exception NO. and Msg. (0x00000A01 - 0x00000B01)
    public static final int NAS_EXCEP_NO_EXPORTROOT_ADD_XML             = 0x00000A13;
    public static final int NAS_EXCEP_NO_DELETEEXPORTROOT_UMOUNT_ERR    = 0x00000A14;
    public static final int NAS_EXCEP_EXPORTROOT_EXIST_IN_FRIEND_TARGET = 0x00000A15;
    public static final int NAS_EXCEP_EXPORTROOT_EXIST_IN_LOCAL_TARGET  = 0x00000A16;
    //end of ExportRoot exception ()

    //--------NFS exports start-------------------
    public static final int       NAS_EXCEP_NO_NFS_GET_EXPORTLIST_FAILED    = 0x00001001,
                NAS_EXCEP_NO_NFS_CHANGE_EXPORT_INFO_FAILED            = 0x00001003,
                NAS_EXCEP_NO_NFS_GET_EXPORT_DETAIL_FAILED            = 0x00001006,
                NAS_EXCEP_NO_NFS_GET_PICKUP_LIST_FAILED                = 0x00001007,
                NAS_EXCEP_NO_NFS_EXEC_IMS_DOMAIN                    = 0x00001008,
                NAS_EXCEP_NO_NFS_EXEC_IMS_NATIVE                    = 0x00001009,
                NAS_EXCEP_NO_NFSDETAIL_INPUT_INVALID                = 0x0000100E,
                NAS_EXCEP_NO_NFS_BEAN_XML_DOMAINNAME                = 0x00001010,
                NAS_EXCEP_NO_NFS_BEAN_XML_NETWORK                    = 0x00001011,
                NAS_EXCEP_NO_NFS_BEAN_XML_SERVER                    = 0x00001012,
                NAS_EXCEP_NO_INVALID_NATIVE_INPUT                    = 0x00001013,

                NAS_EXCEP_NO_NFS_CHANGE_ORDER_FAILED                = 0x0000100A,
                NAS_EXCEP_NO_NFS_DELETE_EXPORTINFO_FAILED            = 0x0000100B,
                NAS_EXCEP_NO_NFS_ADD_EXPORTINFO_FAILED                = 0x0000100C,
                NAS_EXCEP_NO_NFS_XML_CHECK_SYNC_FAILED                = 0x0000100D,
                NAS_EXCEP_NO_NFS_NAVIGATOR_DIR_NOT_EXISTS                = 0x0000100E;
        // alert message for NFS jsp page.

/*For Mapd Common*/
    
    
    
    public static final int NAS_EXCEP_NO_SYNCAUTHDOMAIN                = 0x00002007;
    public static final int NAS_EXCEP_NO_SYNCLOCALDOMAIN            = 0x00002008;

    public static final int NAS_EXCEP_NO_SYNCEXPORTROOT                = 0x00002009;

    public static final int NAS_EXCEP_NO_AUTHDOMAIN_NULL            = 0x0000200a;
    
    public static final int NAS_EXCEP_INVALID_NETWORK            = 0x0000200b;
/*end fro mapd common*/

    //---------------Quota Start-----------------------
    
    public static final int NAS_EXCEP_NO_QUOTA_GETFSTYPE_CMD            = 0x00002100;

    public static final int NAS_EXCEP_NO_QUOTA_GETNAMEBYID_CMD            = 0x00002103;
    
    //---------------FileSystem Start-----------------------

    
    public static final int NAS_EXCEP_NO_AUTHDOMAIN_DELETE_XML_FAILED       = 0x00002202;
    public static final int NAS_EXCEP_NO_FILESYSTEM_CHECK_XML               = 0x00002206;
   
    public static final int NAS_EXCEP_NO_FILESYSTEM_UMOUNTFAILED_HAS        = 0x00002207;
    public static final int NAS_EXCEP_NO_FILESYSTEM_UMOUNTFAILED            = 0x00002208;

    public static final int NAS_EXCEP_NO_FILESYSTEM_DEL_DEVICE_XML          = 0x00002209;
    public static final int NAS_EXCEP_NO_FILESYSTEM_AUTO_CHECK              = 0x0000220A;
    public static final int NAS_EXCEP_NO_FILESYSTEM_READ_ONLY               = 0x0000220B;
    public static final int NAS_EXCEP_NO_FILESYSTEM_WRONG_TYPE              = 0x0000220C;
    public static final int NAS_EXCEP_NO_FILESYSTEM_DIRECT_UNMOUNT          = 0x0000220D;
    public static final int NAS_EXCEP_NO_FILESYSTEM_DIRECT_FSTYPE           = 0x0000220E;

    public static final int NAS_EXCEP_NO_FILESYSTEM_USED_IN_REPLICATION     = 0x0000220F;
    public static final int NAS_EXCEP_NO_FILESYSTEM_HAVE_SUBMOUNT           = 0x00002210;
    public static final int NAS_EXCEP_NO_FILESYSTEM_REUSE_FAILED            = 0x00002211;
    public static final int NAS_EXCEP_NO_FILESYSTEM_UNDO_UMOUNT_FAILED      = 0x00002212;
    public static final int NAS_EXCEP_NO_FILESYSTEM_PARENT_UNMOUNT          = 0x00002213;
    public static final int NAS_EXCEP_NO_FILESYSTEM_REPLI_UMOUNT_FAILED     = 0x00002214;
    public static final int NAS_EXCEP_NO_FILESYSTEM_WRONG_CODEPAGE_EUCJP    = 0x00002215;
    public static final int NAS_EXCEP_NO_FILESYSTEM_WRONG_CODEPAGE_SJIS     = 0x00002216;
    public static final int NAS_EXCEP_NO_FILESYSTEM_WRONG_CODEPAGE_ENGLISH  = 0x00002217;
    public static final int NAS_EXCEP_NO_FILESYSTEM_UMOUNT_FORCE_FAILED     = 0x00002218;
    public static final int NAS_EXCEP_NO_FILESYSTEM_PARENT_FSTYPE           = 0x00002219;
    public static final int NAS_EXCEP_NO_FILESYSTEM_DIR_EXIST               = 0x0000221A;
    public static final int NAS_EXCEP_NO_FILESYSTEM_PARENT_ONLYREAD         = 0x0000221B;
//utf-8 maojb 2004.1.6 
    public static final int NAS_EXCEP_NO_FILESYSTEM_WRONG_CODEPAGE_UTF8  = 0x0000221C;
    //---------------FileSystem end-----------------------

    // ++++++++++++++++  CIFS BEGIN  ++++++++++++++++
        // excep_no begin from 0x00003100 ;
    public static final int NAS_EXCEP_NO_CIFS_ADD_NETBIOS                 = 0x00003101;
    public static final int NAS_EXCEP_NO_CIFS_SET_SMB_GLOBAL_OPTION       = 0x00003102;
    public static final int NAS_EXCEP_NO_CIFS_GETSHARESLIST               = 0x00003103;
    public static final int NAS_EXCEP_NO_CIFS_ADD_DOMAIN                  = 0x00003104;
    //public static final int NAS_EXCEP_NO_CIFS_ADD_NETBIOS = 0x00003106;
    public static final int NAS_EXCEP_NO_CIFS_DEL_NETBIOS             = 0x00003105;
    public static final int NAS_EXCEP_NO_CIFS_GET_SMBSHARE             = 0x00003106;
    public static final int NAS_EXCEP_NO_CIFS_ADD_SMBSHARE             = 0x00003107;
    public static final int NAS_EXCEP_NO_CIFS_DEL_SMBSHARE             = 0x00003108;
    public static final int NAS_EXCEP_NO_CIFS_GET_SMB_GLOBAL         = 0x00003109;
    public static final int NAS_EXCEP_NO_WRONG_NATIVEDOMAIN         = 0x0000310A;
    public static final int NAS_EXCEP_NO_ADD_NETBIOS                 = 0x0000310B;
    public static final int NAS_EXCEP_NO_CIFS_LOCALDOMAIN_NULL         = 0x0000310C;
    public static final int NAS_EXCEP_NO_DEL_NETBIOS                 = 0x0000310D;
    public static final int NAS_EXCEP_NO_DEL_NATIVEREGION             = 0x0000310E;
    public static final int NAS_EXCEP_NO_ADD_LOCALDOMAIN            = 0x0000310F;
    
    public static final int NAS_EXCEP_NO_SMBSTATUS_ERROR            = 0x00003110;
    public static final int NAS_EXCEP_NO_SMBSTATUS_WARN            = 0x00003111;

    // ++++++++++++++++  CIFS END  ++++++++++++++++

    //---------------Replication Start-----------------------
    
    public static final int NAS_EXCEP_NO_FILESET_STATUS_NOT_UNUSED_CODE     = 0x00004101;
    public static final int NAS_EXCEP_NO_MOUNTPOINT_TYPE_NOT_SYNCFS_CODE    = 0x00004102;
    public static final int NAS_EXCEP_NO_MOUNTPOINT_MODE_NOT_RW_CODE        = 0x00004103;
    public static final int NAS_EXCEP_NO_FILESET_NAME_EXISTED_CODE          = 0x00004104;

    public static final int NAS_EXCEP_NO_EXPORT_ADD_FAILED_CODE             = 0x00004106;
    public static final int NAS_EXCEP_NO_BANDWIDTH_FAILED_CODE              = 0x00004107;
    public static final int NAS_EXCEP_NO_IP_FAILED_CODE                     = 0x00004108;
    public static final int NAS_EXCEP_NO_BANDWIDTH_AND_IP_FAILED_CODE       = 0x00004109;
    public static final int NAS_EXCEP_NO_IMPORT_BIND_IP_FAILED              = 0x0000410A;
    public static final int NAS_EXCEP_NO_EXPORT_RMFSET_RESTORE_FAILED       = 0x0000410B;    
    public static final int NAS_EXCEP_NO_EXPORT_FSET_FAILED                 = 0x0000410C;
    public static final int NAS_EXCEP_NO_EXPORT_CLIENT_RESTORE_FAILED       = 0x0000410D;
    public static final int NAS_EXCEP_NO_SET_SSL_FAILED                     = 0x0000410E;
    //---------------Replication end-----------------------

    //---------------Port Failover Start-------------------
    public static final int NAS_EXCEP_NO_CHANGE_ORDER_NIC_NOT_FOUND        = 0x00004201;
    public static final int NAS_EXCEP_NO_CHANGE_ORDER_POS_NOT_FOUND        = 0x00004202;
    public static final int NAS_EXCEP_NO_DELETE_GROUP_NOT_FOUND            = 0x00004203;    
    public static final int NAS_EXCEP_NO_MODIFY_GROUP_EXIST                = 0x00004205;
    public static final int NAS_EXCEP_NO_CREATE_GROUP_EXIST                = 0x00004206;
    public static final int NAS_EXCEP_NO_MODIFY_NIC_EXIST                  = 0x00004207;
    public static final int NAS_EXCEP_NO_CREATE_NIC_EXIST                  = 0x00004208;
    //---------------FCSAN-------------------
    public static final int FCSAN_EXCEP_OBJECT_IS_NULL        = 0x00004301;
    //---------------FCSAN END-------------------

    //---------------NDMP-------------------
    public static final int NDMP_EXCEP_FAILED_REGISTER      = 0x00004401;
    public static final int NDMP_EXCEP_NDMPD_DOESNOT_EXIST  = 0x00004402;
    public static final int NDMP_EXCEP_NO_NDMPD_FOR_READING = 0x00004403;
    //---------------NDMP END-------------------
     
}