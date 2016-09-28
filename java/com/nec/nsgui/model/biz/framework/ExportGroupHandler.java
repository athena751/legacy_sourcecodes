/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework;

import java.util.TreeMap;

import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.framework.FrameworkConst;

/**
 * 
 */
public class ExportGroupHandler implements FrameworkConst {
    private static final String cvsid = "@(#) $Id: ExportGroupHandler.java,v 1.4 2008/05/09 01:19:57 zhangjun Exp $";

    public static TreeMap getExportGroupMap(int nodeNo) throws Exception {
        String[] cmds = { SUDO_COMMAND,
                System.getProperty("user.home") + SCIRPT_GET_EXPORT_GROUP,
                ETC_GROUP_PATH + nodeNo + "/" };

        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null);
        String[] result = cmdResult.getStdout();
        if ((result.length == 0) && ClusterUtil.getInstance().isCluster()) {
            cmdResult = CmdExecBase.rshExecCmd(cmds, null, ClusterUtil
                    .getInstance().getMyFriendIP());
            result = cmdResult.getStdout();
        }

        TreeMap expgrps = new TreeMap();
        for (int i = 0; i < result.length; i += 2) {
            String expgrp = result[i];
            String encoding = result[i + 1];
            if (encoding.compareToIgnoreCase(ENCODING_UTF8) == 0) {
                encoding = ENCODING_UTF_8;
            }
            expgrps.put(expgrp.substring(PREFIX_EXPORT_GROUP.length()),
                    encoding);
        }
        return expgrps;
    }
}
