/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.statis;

import com.nec.nsgui.action.statis.CollectionConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

public class SamplingHandler implements CollectionConst {
    private static final String cvsid =
        "@(#) $Id: SamplingHandler.java,v 1.5 2007/09/04 02:13:04 yangxj Exp $";
    private static final String SCRIPT_SYNC =
        "/opt/nec/nsadmin/bin/statis_rsync.pl";
    private static final String SCRIPT_GET_RESOURCE_NUMBER =
        "/opt/nec/bin/statis_getResourceNumber.pl";
    private static final String SCRIPT_ALL = "ALL";
    private static final String SCRIPT_GRAPHDEF = "GRAPHDEF";
    private static final String SCRIPT_OUT = "2>&1>/dev/null";
    private static final String SCRIPT_SHELL = "/bin/sh";
    private static final String SCRIPT_C = "-c";
    private static final String SCRIPT_TUNE_RRD_FILE =
        "/opt/nec/nsadmin/bin/statis_tuneRRDFile.pl";
    //TODO    
    private static final String SCRIPT_AVAILABLE_FILESIZE =
        "/bin/df /var/log|awk \'END {print $4}\'";
    //"df /var/statistics|awk \'{print $4}\'";
    private static final String SCRIPT_NEEDDISPCPU3 = "/opt/nec/nsadmin/bin/statis_displayCpu3.pl";
    public static double getAvailableSize() throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                SCRIPT_SHELL,
                SCRIPT_C,
                SCRIPT_AVAILABLE_FILESIZE };
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, true);
        return Double.parseDouble(result.getStdout()[0]);
    }
    public static void syncSampling() throws Exception {
        String[] cmds = { SCRIPT_SYNC, SCRIPT_ALL, SCRIPT_OUT };
        CmdExecBase.localExecCmd(cmds, null);
    }
    public static void syncGraphDef() throws Exception {
        String[] cmds = { SCRIPT_SYNC, SCRIPT_GRAPHDEF, SCRIPT_OUT };
        CmdExecBase.localExecCmd(cmds, null);
    }
    public static int getResourceNum(String address, String collectionItem)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                SCRIPT_GET_RESOURCE_NUMBER,
                collectionItem,
                address };
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, true);
        return Integer.parseInt(result.getStdout()[0]);
    }
    //used by volume && network , do not delete please.
    public static void tuneRRDFile(String collectionItemId, String subItem)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                SCRIPT_TUNE_RRD_FILE,
                collectionItemId,
                subItem };
        NSCmdResult result = CmdExecBase.localExecCmd(cmds, null, true);
    }

    public static String needDispCpu3() throws Exception {
    	String[] cmds =
    	{
    			CmdExecBase.CMD_SUDO,
    			SCRIPT_NEEDDISPCPU3
    	};
    	NSCmdResult result = CmdExecBase.localExecCmd(cmds,null,true);
    	return result.getStdout()[0];
    }

}