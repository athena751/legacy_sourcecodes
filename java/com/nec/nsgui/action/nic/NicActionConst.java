/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nic;

public interface NicActionConst {
    public static final String cvsid =
        "@(#) $Id: NicActionConst.java,v 1.2 2007/08/23 07:39:37 wanghb Exp $";

    public static final String  CLUSTER_FAILED_ERROR_NUMBER  = "0x18A00019";
    
    public static final String BOND_ISALIAS_BASEIF           = "0x18A00031";
    public static final String VLAN_ISALIAS_BASEIF           = "0x18A00032";
    
    public static final String BOND_ISALIAS_BASEIF_SELF      = "0x18A00033";
    public static final String BOND_ISALIAS_BASEIF_FRIEND    = "0x18A00034";
    
    public static final String VLAN_ISALIAS_BASEIF_SELF      = "0x18A00035";
    public static final String VLAN_ISALIAS_BASEIF_FRIEND    = "0x18A00036";
    public static final String IPALIAS_SET_OVER_TOTAL        = "0x18A00038";
    public static final String IPALIAS_SET_OVER_TOTAL_ALERT  = "nic.alert.message.alias.total";
}
