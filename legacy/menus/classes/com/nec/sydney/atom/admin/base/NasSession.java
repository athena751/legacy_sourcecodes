/*
 *      Copyright (c) 2001 NEC Corporation
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
 *        cvsid = "@(#) $Id: NasSession.java,v 1.2302 2004/05/14 01:08:50 zhangjx Exp $";
 */

package  com.nec.sydney.atom.admin.base;


public interface NasSession {

    public static String SESSION_NFS_EXPORTROOT = "nfs_exportroot";
    public static String SESSION_NFS_PICKUP = "nfs_pickup";
    public static String SESSION_NFS_PICKUP_TEXT = "nfs_pickup_text";
    public static String SESSION_NFS_HEX_PICKUP = "nfs_hexpickup";

    public static String SESSION_CIFS_SECURITY = "cifs_security";
    public static String SESSION_CIFS_EXPORTROOTNAME = "cifs_exportrootname";
    public static String SESSION_CIFS_LOCALDOMAIN = "cifs_localdomain";
    public static String SESSION_CIFS_NETBIOS = "cifs_netbios";
    public static String SESSION_CIFS_PICKUP = "cifs_pickup";
    public static String SESSION_CIFS_PICKUP_NETBIOS = "cifs_pickup_netbios";

    public static final String SESSION_REPLI_FSET_NAME = "repli_fset_name";
    public static final String MAC_SESSION_PORT_GROUP = "mac_port_group";
    public static final String SESSION_NFS_VERSION = "nfs_version";
    public static final String SESSION_NODE_NAME = "node_name";
    public static final String SESSION_QUOTA_FSTYPE = "quota_fstype";
    public static final String SESSION_DIRQUOTA_AUTH = "dirquota_auth";
    public static final String SESSION_HEX_DIRQUOTA_DATASET = "dirquota_hex_dataset";
    public static final String SESSION_DIRQUOTA_DATASET = "dirquota_dataset";
    public static final String MP_SESSION_END_WAIT = "finished";

}
