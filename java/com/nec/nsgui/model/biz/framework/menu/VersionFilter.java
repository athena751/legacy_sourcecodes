/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework.menu;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;

/**
 *
 */
public class VersionFilter implements Filter, FrameworkConst {
    private static final String cvsid =
        "@(#) $Id: VersionFilter.java,v 1.7 2004/11/12 02:29:17 het Exp $";
    private String versionType = "";
    public VersionFilter() throws Exception {
        getVersionType();
    }
    /**
     * calling perl scirpt and get the output in first line 
     * @throws Exception
     */
    protected void getVersionType() throws Exception {
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + COMMAND_GET_VERSION_TYPE,
                TOMCAT_KEY,
                VERSION_KEY };
        NSCmdResult cmdResult = getCmdResult(cmds);
        if (cmdResult.getStdout().length == 0) {
            versionType = VERSION_TYPE_ABROAD;
            return;
        }
        if ((cmdResult.getStdout())[0].equals(VERSION_TYPE_JAPAN)) {
            versionType = VERSION_TYPE_JAPAN;
        } else {
            versionType = VERSION_TYPE_ABROAD;
        }
    }

    /* (non-Javadoc)
     * @see com.nec.nsgui.model.biz.framework.menu.Filter#filter(com.nec.nsgui.model.entity.framework.menu.MenuBaseBean)
     */
    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception {
        if (versionType.equals(VERSION_TYPE_ABROAD)) {
            if (nsmenu.getMsgKey().equals(MENU_MSG_KEY_JAPAN)) {
                nsmenu.setMsgKey(MENU_MSG_KEY_ABROAD);
            }
            if (nsmenu.getMsgKey().equals(MENU_MSG_KEY_JAPAN_PASSWD)) {
                nsmenu.setMsgKey(MENU_MSG_KEY_ABROAD_PASSWD);
            }
            if (nsmenu.getMsgKey().equals(MENU_MSG_KEY_JAPAN_CON_NETWORK)) {
                nsmenu.setMsgKey(MENU_MSG_KEY_ABROAD_CON_NETWORK);
            }
            if (nsmenu.getDetailMsgKey().equals(MENU_DETAIL_MSG_KEY_JAPAN)) {
                nsmenu.setDetailMsgKey(MENU_DETAIL_MSG_KEY_ABROAD);
            }
            if (nsmenu.getDetailMsgKey().equals(MENU_DETAIL_MSG_KEY_JAPAN_PASSWD)) {
                nsmenu.setDetailMsgKey(MENU_DETAIL_MSG_KEY_ABROAD_PASSWD);
            }
            if (nsmenu.getDetailMsgKey().equals(MENU_DETAIL_MSG_KEY_JAPAN_CON_NETWORK)) {
                nsmenu.setDetailMsgKey(MENU_DETAIL_MSG_KEY_ABROAD_CON_NETWORK);
            }
        }
        return nsmenu;
    }

    protected NSCmdResult getCmdResult(String[] cmds) throws Exception {
        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null);
        return cmdResult;
    }

    protected String getType() {
        return this.versionType;
    }

    public VersionFilter(String vType) throws Exception {
        //for test    
    }
}
