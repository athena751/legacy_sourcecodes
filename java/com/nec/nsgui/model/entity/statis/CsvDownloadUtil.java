/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

import com.nec.nsgui.action.statis.StatisActionConst;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.statis.CollectionItemDef;
import com.nec.nsgui.model.biz.statis.WatchItemDef;
/**
 *
 */
public class CsvDownloadUtil implements StatisConst {
    /**
     *
     */

    private static final String cvsid =
        "@(#) $Id: CsvDownloadUtil.java,v 1.4 2007/03/07 06:31:46 yangxj Exp $";

    public static String changeWatchItem2Infotype(String paramWatchItemID)
        throws Exception {
        if (paramWatchItemID.equals(WatchItemDef.CPU_States)) {
            return StatisActionConst.INFOTYPE_CPU;
        } else if (paramWatchItemID.equals(WatchItemDef.Network_Traffic)) {
            return StatisActionConst.INFOTYPE_NETTRAFFIC;
        } else if (paramWatchItemID.equals(WatchItemDef.Network_Packets)) {
            return StatisActionConst.INFOTYPE_NETPACKETS;
        } else if (
            paramWatchItemID.equals(WatchItemDef.Network_Error_Packets)) {
            return StatisActionConst.INFOTYPE_NETERRORS;
        } else if (paramWatchItemID.equals(WatchItemDef.Disk_Used_Rate)) {
            return StatisActionConst.INFOTYPE_VOLUME;
        } else if (paramWatchItemID.equals(WatchItemDef.Inode_Used_Rate)) {
            return StatisActionConst.INFOTYPE_INODE;
        } else if (paramWatchItemID.equals(WatchItemDef.Disk_Used_Quantity)) {
            return StatisActionConst.INFOTYPE_VOLUME_QUANTITY;
        } else if (paramWatchItemID.equals(WatchItemDef.Inode_Used_Quantity)) {
            return StatisActionConst.INFOTYPE_INODE_QUANTITY;
        } else if (paramWatchItemID.equals(WatchItemDef.NAS_LV_IO)) {
            return StatisActionConst.INFOTYPE_DISKIO;
        } else if (paramWatchItemID.equals(WatchItemDef.iSCSI_Session)) {
            return StatisActionConst.INFOTYPE_ISCSISESSION;
        } else if (paramWatchItemID.equals(WatchItemDef.iSCSI_Login)) {
            return StatisActionConst.INFOTYPE_ISCSILOGIN;
        } else if (paramWatchItemID.equals(WatchItemDef.iSCSI_Logout)) {
            return StatisActionConst.INFOTYPE_ISCSILOGOUT;
        } else if (paramWatchItemID.equals(WatchItemDef.Nvavs_Request)) {
        	return StatisActionConst.INFOTYPE_NVAVS_REQUEST;
        } else if (paramWatchItemID.equals(WatchItemDef.Nvavs_TAT)) {
        	return StatisActionConst.INFOTYPE_NVAVS_TAT;
        } else {
            CsvDownloadUtil.makeNSException(
                CsvDownloadUtil.class,
                StatisConst.ERROR_MSG_NO_RESOURCES,
                null,
                NSReporter.FATAL);
        }
        return null;

    }

    public static String changeCollectionItem2Infotype(String collectionItemId)
        throws Exception {
        if (collectionItemId
            .equals(StatisActionConst.NSW_NFS_Virtual_Export)) {
            return StatisActionConst.INFOTYPE_NFS_Virtual_Export;
        } else if (collectionItemId.equals(StatisActionConst.NSW_NFS_Server)) {
            return StatisActionConst.INFOTYPE_NFS_Server;
        } else if (collectionItemId.equals(StatisActionConst.NSW_NFS_Node)) {
            return StatisActionConst.INFOTYPE_NFS_Node;
        } else {
            CsvDownloadUtil.makeNSException(
                CsvDownloadUtil.class,
                StatisConst.ERROR_MSG_NO_RESOURCES,
                null,
                NSReporter.FATAL);
        }
        return null;

    }

    public static void makeNSException(
        Class classname,
        String errorStr,
        String[] cmd,
        int level)
        throws Exception {
        NSException e = new NSException(classname);
        e.setDetail(errorStr);

        e.setCmds(cmd);
        e.setReportLevel(level);
        NSReporter.getInstance().report(e);
        throw e;

    }

}
