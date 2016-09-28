/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.statis;

public interface CollectionConst3 {
    public static final String cvsid 
            = "@(#) $Id: CollectionConst3.java,v 1.1 2005/10/18 16:24:27 het Exp $";    
    public static final String STATIS_NSW_SAMPLING_TARGET_ID =
        "statis_nswsampling_target_id";
    public static final String STATIS_NSW_SAMPLING_COLITEM_ID =
        "statis_nswsampling_collection_item_id";
    public static final String STATIS_NFS_VIRTUAL_PATH =
        "NSW_NFS_Virtual_Export";
    public static final String STATIS_NFS_SEVER = "NSW_NFS_Server";
    public static final String STATIS_NFS_NODE = "NSW_NFS_Node";
    public static final String STATIS_NFS_VIRTUAL_PATH_TH =
        "statis.nswsampling.virtualpath.th";
    public static final String STATIS_NFS_SEVER_TH =
        "statis.nswsampling.sever.th";
    public static final String STATIS_NFS_NODE_TH =
        "statis.nswsampling.node.th";
    public static final String STATIS_VIRTUAL_PATH_RESOURCE =
        "virtual export directories";
    public static final String STATIS_SERVER_RESOURCE = "severs";
    public static final String STATIS_NODE_RESOURCE = "nodes";
    public static final String STATIS_NSW_SAMPLING_SESSION_TABLELIST_MAP =
        "statis_nswsampling_tablelist_map";
    public static final String STATIS_NSW_SAMPLING_SESSION_SELECTED_INDEXLIST =
        "statis_nswsampling_selected_indexlist";
    public static final int STATIS_NSW_SAMPLING_INFO_NUM = 3;
    public static final int KILOBYTE = 1024;  //1K
    public static final int MILLIONBYTE = 1024*1024;  //1M
    public static final int BLOCK_SIZE = 4096;
    public static final double STATIS_NSW_TOTAL_SIZE = 2.0*1024*1024*1024;   //unit(B)
    public static final String NONE = "NONE";
    public static final String BOTH = "both";
    public static final String DLINE = "--";
    public static final String DEFAULT_PERIOD = "40";
    public static final String DEFAULT_INTERVAL = "10";
    public static final String RESOURCE_KEY_COMMON_FAILED =
        "common.alert.failed";
    public static final String RESOURCE_KEY_LOWSPACE =
        "statis.nsw_sampling.lowspace";
    public static final String STATIS_NSW_SAMPLING_MODIFY_FAILED =
        "Failed to modify data.";
    public static final String PATH_OF_CHECKED_GIF =
        "/nsadmin/images/nation/check.gif";
    public static final String STATIS_NASSWITCH_NORMAL = "normal";
    public static final String STATIS_NSWSAMPLING_COLLECTION_ID = "statis_nswsampling_collection_id";
}