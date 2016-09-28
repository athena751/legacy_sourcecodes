/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicConstant.java,v 1.7 2007/08/24 01:24:40 wanghui Exp $ 
 */

package com.nec.nsgui.model.entity.nic;

public interface NicConstant {
    public static final String cvsid =
        "@(#) $Id: NicConstant.java,v 1.7 2007/08/24 01:24:40 wanghui Exp $";

    public static final String CONFIG_FILE_NAME = "/exports";
    public static final String SUDO_COMMAND = "sudo";
    public static final String ETC_GROUP = "/etc/group";

    public static final String GET_ALLROUTES_SCRIPT = "/bin/nic_getroute.pl";
    public static final String GET_NICNAMES_SCRIPT = "/bin/nic_getnicnames.pl";
    public static final String GET_AVAILNICLIST = "/bin/nic_getAvailNicList4Vlan.pl";
    public static final String SET_ROUTE_SCRIPT = "/bin/nic_setroute.pl";
    public static final String SCRIPT_HOME = "/home/nsadmin";
    public static final String NIC_DELETE_SCRIPY = "/bin/nic_delete.pl";
    public static final String SCIRPT_LINKDOWN_IGNORELIST_GET = "/bin/nic_getignorelist.pl";

    public static final String Get_ALLNICLIST_SCRIPY = "/bin/nic_ifconfig.pl";
    
   
    public static final String SCIRPT_NIC_SET_LINKSTATUS =
        "/sbin/nv_ethtool";
    public static final String COMMON_NIC_SET_LINKSTATUS =
            "nv_ethtool";
    public static final String COMMON_NIC_SET_ROUTE =
             "nv_route";
    public static final String SCIRPT_NIC_GET_LINKSTATUS =
        "/bin/nic_getlinkstatus.pl";
    public static final String SCIRPT_NIC_SET_INTERFACESTATUS =
        "/bin/nic_setifconfig.pl";
    public static final String SCIRPT_NIC_GET_MTUANDIP =
        "/bin/nic_getmtuandip.pl";
    public static final String SCIRPT_NIC_SET_VLAN =
           "/bin/nic_setvlan.pl";
    public static final String SCIRPT_NIC_GET_AVAI_NIC_FOR_CREATING_BOND =
        "/bin/nic_getAvaiNicForCreatingBond.pl";
    public static final String SCIRPT_NIC_GET_NEW_BOND_NAME =
        "/bin/nic_getNewBondName.pl";
    public static final String SCIRPT_NIC_CREATE_BOND =
        "/bin/nic_createBond.pl";
    public static final String SCIRPT_NIC_GET_BONDINFO =
        "/bin/nic_getbondinfo.pl";
    public static final String GET_NIC_FOR_IPALIAS = "/bin/nic_getNic4IPAlias.pl";
    public static final String SET_NIC_IPALIAS = "/bin/nic_setIPAlias.pl";
    
        public static final String SCIRPT_LINKDOWN_INFO_GET=
        "/bin/nic_getlinkdowninfo.pl";    
    public static final String SCIRPT_LINKDOWN_INFO_SET=
        "/bin/nic_setlinkdowninfo.pl";    
    public static final String SCIRPT_LINKDOWN_INTERFACES_GET=
        "/bin/nic_getinterface4linkdown.pl";

}
