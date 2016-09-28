/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.statis;

import java.util.*;

import com.nec.nsgui.action.statis.CollectionConst3;
import com.nec.nsgui.model.entity.statis.*;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

public class NswSamplingHandler implements CollectionConst3 {
    private static final String cvsid =
        "@(#) $Id: NswSamplingHandler.java,v 1.1 2005/10/18 16:34:22 het Exp $";
    private static final String SCRIPT_SYNC = "/bin/statis_rsync.pl";
    private static final String SCRIPT_ALL = "ALL";
    private static final String SCRIPT_OUT = "2>&1>/dev/null";
    private static final String SHELL_SCRIPT_GET_USED_SIZE_PERCENTAGE = "/bin/statis_getUsedSizePercentage.sh"; 
    private static final String SCRIPT_GET_EXPORTPOINT_LIST = "/bin/statis_getNasSwitchInfo.pl";

    public static List getVirtualPathList() throws Exception {
        String home = System.getProperty("user.home");        
        String cmds[] =
            {
                CmdExecBase.CMD_SUDO,
                home + SCRIPT_GET_EXPORTPOINT_LIST,
                STATIS_NFS_VIRTUAL_PATH };
        NSCmdResult result = CmdExecBase.execCmdInMaintain(cmds,true);
        String[] stdout = result.getStdout();
        List vpList = new ArrayList();
        for (int i = 0; i < stdout.length; i++) {
            VirtualPathInfoBean vpInfoBean = new VirtualPathInfoBean();
            //
            String[] st = stdout[i].trim().split("\t");
            vpInfoBean.setId(st[0]);
            vpInfoBean.setSeverName(st[2]);
            vpInfoBean.setExportPath(st[3]);
            vpList.add(vpInfoBean);
        }
        return vpList;
    }

    public static List getSeverList() throws Exception {
        String home = System.getProperty("user.home");
        String cmds[] =
            {
                CmdExecBase.CMD_SUDO,
                home + SCRIPT_GET_EXPORTPOINT_LIST,
                STATIS_NFS_SEVER };
        NSCmdResult result = CmdExecBase.execCmdInMaintain(cmds,true);
        String[] stdout = result.getStdout();
        List serverList = new ArrayList();       
        for (int i = 0; i < stdout.length; i++) {
            //
            NswSamplingInfoBeanBase nsBase = new NswSamplingInfoBeanBase();
            String[] st = stdout[i].trim().split("\t");
            nsBase.setId(st[0]);
            serverList.add(nsBase);
        }     
        return serverList;
    }

    public static Map getModeMap(String para) throws Exception {
        String home = System.getProperty("user.home");
        String cmds[] =
            { CmdExecBase.CMD_SUDO, home + SCRIPT_GET_EXPORTPOINT_LIST, para };
        NSCmdResult result = CmdExecBase.execCmdInMaintain(cmds,true);
        String[] stdout = result.getStdout();
        Map modeMap = new HashMap();
        for (int i = 0; i < stdout.length; i++) {
            String id = "";
            String mode = "";
            String[] st = stdout[i].trim().split("\t");
            modeMap.put(st[0],st[1]);
        }
        return modeMap;
    }
    
    public static double getUsedSizePercentage() throws Exception{
        String home = System.getProperty("user.home");
        String[] cmds = {
            home + SHELL_SCRIPT_GET_USED_SIZE_PERCENTAGE
        };       
        NSCmdResult result = CmdExecBase.execCmdInMaintain(cmds,true);
        return Double.parseDouble(result.getStdout()[0]);
    }
    
    public static void syncSampling() throws Exception {
        String home = System.getProperty("user.home");
        String[] cmds = { home + SCRIPT_SYNC, SCRIPT_ALL, SCRIPT_OUT };
        NSCmdResult result = CmdExecBase.execCmdInMaintain(cmds,true);
    }
}