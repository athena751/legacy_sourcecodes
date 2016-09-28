/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.rdr_dr;

import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.CmdExecBase;

public class Rdr_drHandler {
    private static final String cvsid = "@(#) $Id: Rdr_drHandler.java,v 1.2 2005/10/24 01:47:03 jiangfx Exp $" ;
    
    private static String RDR_DR_GET_BATTERY_MODE_PL    = "/home/nsadmin/bin/rdr_dr_getBatteryMode.pl";
    private static String RDR_DR_CHANGE_BATTERY_MODE_PL = "/home/nsadmin/bin/rdr_dr_changeBatteryMode.pl";
    
    /**
     * get battery's current mode
     * @param  nodeNo -- int, specify on which node to execute cmd
     * @return currentMode -- String, value is on|off
     * @throws Exception
     */
    public String getCurrentMode(int nodeNo) throws Exception {
        String[] cmd_getCurrentMode = {"sudo", RDR_DR_GET_BATTERY_MODE_PL};
        NSCmdResult result = getCmdResult(cmd_getCurrentMode, nodeNo, 1);
        String[] modeInfo = result.getStdout();
        String currentMode = modeInfo[0].trim(); 
        return currentMode;     
    }
    
    /**
     * change battery's mode 
     * @param nextMode -- String, value is on|off
     *        nodeNo   -- int, specify on which node to execute cmd
     * @throws Exception
     */
    public void changMode(String nextMode, int nodeNo) throws Exception {
        String[] cmd_changeMode = {"sudo", RDR_DR_CHANGE_BATTERY_MODE_PL, nextMode};   
        CmdExecBase.execCmd(cmd_changeMode, nodeNo);
    }

    /**
     * call CmdExecBase.execCmd to get cmd's result 
     * @param cmds -- String[], command string
     *        nodeNo   -- int, specify on which node to execute cmd
     * @throws Exception
     */
    protected NSCmdResult getCmdResult(String[] cmds, int nodeNo, int count) throws Exception {
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        return cmdResult;
    }
}