/*
 *      Copyright (c) 2004~2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework.menu;

import java.util.Arrays;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;

/**
 *
 */
public class MachineTypeFilter implements Filter, FrameworkConst {
    private static final String cvsid = "@(#) $Id: MachineTypeFilter.java,v 1.5 2008/04/17 05:54:33 zhangjun Exp $";
    private String machineType = "";
    private String isSingleNVRAM = "1";
    private Boolean isDisplayDDRMenu = false;
    public MachineTypeFilter() throws Exception {
        getMachineType();
        getSingleNVRAMMode();
        getIsDisplayDDRMenu();
    }
    /**
     * calling perl scirpt and get the output in first line 
     * @throws Exception
     */
    protected void getMachineType() throws Exception {
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+SCIRPT_GET_MACHINE_TYPE }; 
        NSCmdResult cmdResult = getCmdResult(cmds);
        machineType = (cmdResult.getStdout())[0];
    }
    /**
     * calling shell scirpt to check NV7400GS+NVRAM type 
     * @throws Exception
     */
    protected void getSingleNVRAMMode() throws Exception {
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+COMMAND_IS_SINGLE_NVRAM }; 
        NSCmdResult cmdResult = getCmdResult(cmds);
        if(cmdResult.getExitValue() == 0){
            isSingleNVRAM = (cmdResult.getStdout())[0];
        }
    }
    /**
     * calling perl scirpt and get the output in first line 
     * @throws Exception
     */
    protected void getIsDisplayDDRMenu() throws Exception {
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+COMMAND_IS_DISPLAY_DDR_MENU }; 
        NSCmdResult cmdResult = getCmdResult(cmds);
        if(cmdResult.getExitValue() == 0){
            isDisplayDDRMenu = cmdResult.getStdout()[0].equals("yes");
        }
    }
    /* (non-Javadoc)
     * @see com.nec.nsgui.model.biz.framework.menu.Filter#filter(com.nec.nsgui.model.entity.framework.menu.MenuBaseBean)
     */
    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception {
        String[] mchTypes =
            nsmenu.getMachineType().split(MACHINE_TYPE_SEPARATOR);
        if(Arrays.asList(mchTypes).contains(this.machineType)){
            if(nsmenu.getMsgKey().equals("base.system.rdrdr") &&
                this.machineType.equals(MACHINE_TYPE_NASHEADSINGLE) && 
                isSingleNVRAM.equals("1")){
                    return null;
            }
            if(nsmenu.getMsgKey().equals("apply.backup.ddr") && !isDisplayDDRMenu ){
                return null;
            }
            return nsmenu;
        }
        return null;
    }
    
    protected NSCmdResult getCmdResult(String[] cmds) throws Exception {
        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds,null);
        return cmdResult;
    }

    protected String getType(){
        return machineType;
    }
}
