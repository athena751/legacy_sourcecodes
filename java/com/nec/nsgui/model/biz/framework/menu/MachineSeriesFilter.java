/*
 *      Copyright (c) 2007 NEC Corporation
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
import com.nec.nsgui.model.entity.framework.menu.ItemBean;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;

/**
 *
 */
public class MachineSeriesFilter implements Filter, FrameworkConst {
    private static final String cvsid = "@(#) $Id: MachineSeriesFilter.java,v 1.1 2007/08/29 02:08:40 liul Exp $";
    private String machineSeries = "";
    public MachineSeriesFilter() throws Exception {
        getMachineSeries();
    }
    /**
     * calling perl scirpt and get the output in first line 
     * @throws Exception
     */
    protected void getMachineSeries() throws Exception {
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+SCIRPT_GET_MACHINE_SERIES }; 
        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds,null);
        machineSeries = (cmdResult.getStdout())[0];
    }
    
    /* (non-Javadoc)
     * @see com.nec.nsgui.model.biz.framework.menu.Filter#filter(com.nec.nsgui.model.entity.framework.menu.MenuBaseBean)
     */
    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception {
        if (nsmenu == null || !(nsmenu instanceof ItemBean)) {
            return nsmenu;
        }

        ItemBean item = (ItemBean) nsmenu ;

        String machineSeries = item.getMachineSeries();
        if (machineSeries == null || machineSeries.equals("")) {
            return item;
        }

        String[] mchSeries =item.getMachineSeries().split(MACHINE_TYPE_SEPARATOR);
        if(Arrays.asList(mchSeries).contains(this.machineSeries)){
            return nsmenu;
        }
        return null;
    }

}
