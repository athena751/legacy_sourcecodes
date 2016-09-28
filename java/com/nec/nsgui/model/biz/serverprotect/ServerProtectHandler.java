/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.serverprotect;

import java.util.List;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.biz.nfs.NFSModel;

import com.nec.nsgui.action.serverprotect.ServerProtectActionConst;
import com.nec.nsgui.model.entity.serverprotect.ServerProtectGlobalOptionBean;
import com.nec.nsgui.model.entity.serverprotect.ServerProtectScanServerBean;
import com.nec.nsgui.model.entity.serverprotect.ServerProtectScanTargetBean;

public class ServerProtectHandler implements ServerProtectActionConst{
    private static final String cvsid = "@(#) $Id: ServerProtectHandler.java,v 1.5 2007/03/30 07:44:28 wanghui Exp $";

    /**
     * 
     * @param nodeNumber
     * @return a array of all available service interfaces
     * @throws Exception
     */
    public static String[] getServiceInterfaces(int nodeNumber) throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_SERVICE_INTERFACES};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber);
        return cmdResult.getStdout();
    }
    
    /**
     * Check whether there is config file now
     * @param nodeNumber
     * @param computerName
     * @return "yes" if exists, otherwise, "no"
     * @throws Exception
     */
    public static String haveConfigFile(int nodeNumber, String computerName, boolean doWhenMaintain)
            throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_HAVE_CONFIG_FILE,
                Integer.toString(nodeNumber),
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber, true, doWhenMaintain);
        return cmdResult.getStdout()[0];
    }
    
    /**
     * 
     * @param nodeNumber
     * @param computerName
     * @return a ServerProtectGlobalOptionBean object contains global option information 
     *         which is in '[export]' section.
     * @throws Exception
     */
    public static ServerProtectGlobalOptionBean getGlobalOptionBean(int nodeNumber, 
            String computerName, boolean doWhenMaintain)
            throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_GLOBAL_OPTION_INFO,
                Integer.toString(nodeNumber),
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber, true, doWhenMaintain);
        ServerProtectGlobalOptionBean globalOptionBean = new ServerProtectGlobalOptionBean();
        NSBeanUtil.setProperties(globalOptionBean, cmdResult.getStdout());
        return globalOptionBean;
    }
    
    /**
     * 
     * @param nodeNumber
     * @param domainName
     * @param computerName
     * @param type :"backup","realtimescan"
     * @return An array of ludb users of specified type
     * @throws Exception
     */
    public static String[] getLudbUsers(int nodeNumber, String domainName, String computerName, String type)
            throws Exception {
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_LUDB_USERS, 
                Integer.toString(nodeNumber),
                domainName, computerName, type};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber);
        return cmdResult.getStdout();
    }
    
    /**
     * 
     * @param nodeNumber
     * @param computerName
     * @return a list of scan servers
     * @throws Exception
     */
    public static List getScanServerList(int nodeNumber, String computerName)
            throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_SCAN_SERVER_INFO,
                Integer.toString(nodeNumber),
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber);
        String className = ServerProtectScanServerBean.class.getName();
        return NSBeanUtil.createBeanList(className,
               cmdResult.getStdout(), 3);
    }
    
    /**
     * Update the '[export]' and '[server]' sections in config file, 
     * and if 'scanUserChange' or 'scanServerChange' is 'yes', it is need to change cifs file.
     * @param nodeNumber
     * @param exportName
     * @param computerName
     * @param fileExtension
     * @param ludbUser
     * @param scanServerInfo
     * @param scanUserChange
     * @param scanServerChange
     * @throws Exception
     */
    public static void setScanServer(int nodeNumber, String exportName, 
            String domainName, String computerName, String fileExtension, 
            String ludbUser, String scanServerInfo, String scanUserChange, 
            String scanServerChange) throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SET_SCAN_SERVER_INFO,
                Integer.toString(nodeNumber),
                exportName,  domainName, computerName, 
                fileExtension, ludbUser, scanServerInfo,
                scanUserChange, scanServerChange};
        CmdExecBase.execCmd(cmds, nodeNumber);
    }
    
    /**
     * Delete the config file
     * @param nodeNumber
     * @param computerName
     * @throws Exception
     */
    public static void deleteConfigFile(int nodeNumber, String computerName)
            throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_DEL_CONFIG_FILE,
                Integer.toString(nodeNumber),
                computerName};
        CmdExecBase.execCmd(cmds, nodeNumber);
    }
    
    /**
     * Delete specified '[share]' section in config file
     * @param nodeNumber
     * @param computerName
     * @param shareName
     * @throws Exception
     */
    public static void deleteScanShare(int nodeNumber, String computerName, String shareName)
            throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_DEL_SCAN_SHARE,
                Integer.toString(nodeNumber),
                computerName, shareName};
        CmdExecBase.execCmd(cmds, nodeNumber);
    }
    
    /**
     * 
     * @param nodeNumber
     * @param domainName
     * @param computerName
     * @return An array of share names about ads domian in sxfsfw except japanese names
     * @throws Exception
     */
    public static String[] getScanShare4Add(int nodeNumber, String domainName, String computerName)
            throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_SCAN_SHARE_FOR_ADD,
                Integer.toString(nodeNumber),
                domainName, computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber);
        return cmdResult.getStdout();
    }
    
    /**
     * Add specified shares info into config file
     * @param nodeNumber
     * @param shareInfo
     * @throws Exception
     */
    public static void addScanShare(int nodeNumber, String shareInfo)
            throws Exception{
        String tempFile = NFSModel.createTempFile(nodeNumber, shareInfo);
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_ADD_SCAN_SHARE,                
                tempFile};
        try {
            CmdExecBase.execCmd(cmds, nodeNumber);
        }catch (Exception e) {
            String[] cmd_rm = {CmdExecBase.CMD_SUDO,
                    System.getProperty("user.home") + DELETE_TEMP_FILE,
                    tempFile};
            CmdExecBase.execCmdForce(cmd_rm, nodeNumber, true);
            throw e;
        }
    }
    
    /**
     * modify specified '[share]' section in config file
     * @param nodeNumber
     * @param computerName
     * @param shareName
     * @param readCheck
     * @param writeCheck
     * @throws Exception
     */
    public static void modifyScanShare(int nodeNumber, String computerName, String shareName,
            String readCheck, String writeCheck)throws Exception{
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_MODIFY_SCAN_SHARE,
                Integer.toString(nodeNumber),
                computerName, shareName,
                readCheck, writeCheck};
        CmdExecBase.execCmd(cmds, nodeNumber);
    }
    
    
    /**
	 * get the information of serverprotect's configure file
	 * 
	 * @param groupNumber --
	 *            specify the machine need to execute cmds
	 * @param domainName --
	 *            the name of domain
	 * @param computerName --
	 *            the name of computer
	 * @return vrscanInfo -- the info of the serverprotect's configure file
	 * @throws Exception
	 * add by liy
	 */
	public static String[] readVrscanFile(int groupNumber, String domainName,
			String computerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_READ_CONFIG_FILE,
				Integer.toString(groupNumber), domainName, computerName };
		NSCmdResult result = CmdExecBase.execCmd(cmds, groupNumber, true, true);
		String[] configInfo = result.getStdout();
		return configInfo;
	}

	/**
	 * write content into configure file
	 * 
	 * @param groupNumber --
	 *            specify the machine need to execute cmds
	 * @param domainName --
	 *            the name of domain
	 * @param computerName --
	 *            the name of computer
	 * @param content --
	 *            the content of textarea
	 * @throws Exception
	 * add by liy
	 */
	public static void writeVrscanFile(int groupNumber, String domainName,
			String computerName, String content) throws Exception {
		String tempFile = NFSModel.createTempFile(groupNumber, content);
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_WRITE_CONFIG_FILE,
				Integer.toString(groupNumber), domainName, computerName,
				tempFile };
		try {
            CmdExecBase.execCmd(cmds, groupNumber);
        }catch (Exception e) {
            String[] cmd_rm = {CmdExecBase.CMD_SUDO,
                    System.getProperty("user.home") + DELETE_TEMP_FILE,
                    tempFile};
            CmdExecBase.execCmdForce(cmd_rm, groupNumber, true);
            throw e;
        }
		
	}

	/**
	 * delete configure file
	 * 
	 * @param groupNumber --
	 *            specify the machine need to execute cmds
	 * @param computerName --
	 *            the name of computer
	 * @throws Exception
	 * add by liy
	 */
	public static void deleteVrscanFile(int groupNumber, String computerName)
			throws Exception {

		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_DEL_CONFIG_FILE,
				Integer.toString(groupNumber), computerName };
		CmdExecBase.execCmd(cmds, groupNumber);
	}
	/**
	 * 
	 * @param nodeNo -
	 *            the current node number
	 * @param computerName -
	 *            computer name
	 * @return - Scan Server Info
	 * @throws Exception
	 *             add by wanghb
	 */
	public static List getScanServer4List(int nodeNumber, String computerName)
			throws Exception {
		String[] cmds = {
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home")
						+ GET_SCAN_SERVER_FOR_LIST_SCRIPT,
				Integer.toString(nodeNumber), computerName };
		NSCmdResult cmdResult = CmdExecBase.execCmdInMaintain(cmds, nodeNumber,
				true);
		String[] results = cmdResult.getStdout();
		return NSBeanUtil.createBeanList(CLASS_SCAN_SERVER_BEAN, results, 3);
	}

	/**
	 * 
	 * @param nodeNo -
	 *            the current node number
	 * @param computerName -
	 *            computer name
	 * @return - Scan Target Info
	 * @throws Exception
	 *             add by wanghb
	 */

	public static List getScanShareList(int nodeNumber, String computerName,
			boolean doWhenMaintain) throws Exception {
		String[] cmds = {
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home")
						+ GET_SCAN_TARGET_FOR_LIST_SCRIPT,
				Integer.toString(nodeNumber), computerName };
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber, true,
				doWhenMaintain);
		return NSBeanUtil.createBeanList(CLASS_SCAN_TARGET_BEAN, cmdResult
				.getStdout(), 4);
	}

	/**
	 * Check whether the CIFS has set virus scan mode in Global.
	 * 
	 * @param nodeNumber
	 * @param domainName
	 * @param computerName
	 * @return "yes" if CIFS has set, otherwise, "no"
	 * @throws Exception
	 *             add by wanghb
	 */
	public static String haveSetCifsGlobal(int nodeNumber, String domainName,
			String computerName) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_VIRUS_SCAN_MODE,
				Integer.toString(nodeNumber), domainName, computerName };
		NSCmdResult cmdResult = CmdExecBase.execCmdInMaintain(cmds, nodeNumber,
				true);
		return cmdResult.getStdout()[0];
	}
	
	/**
     * get specified computer's state of daemon
     * @param nodeNumber
     * @param computerName    
     * @throws Exception
     */
    public static String getDaemonState(int nodeNumber, String computerName)
            throws Exception {
        String[] cmds = {CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + GET_DAEMON_STATE,
                Integer.toString(nodeNumber), computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNumber);
        return cmdResult.getStdout()[0];
    }

}
