/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.nfs;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.nfs.ClientInfoBean;
import com.nec.nsgui.model.entity.nfs.ClientOptionInfoBean;
import com.nec.nsgui.model.entity.nfs.DetailInfoBean;
import com.nec.nsgui.model.entity.nfs.EntryInfoBean;
import com.nec.nsgui.model.entity.nfs.LogInfoBean;
import com.nec.nsgui.model.entity.nfs.NFSConstant;

/**
 *model for nfs
 */
public class NFSModel implements NFSConstant {
    private static final String cvsid =
        "@(#) $Id: NFSModel.java,v 1.17 2009/04/10 01:38:39 yangxj Exp $";
    /**
     * get the configure file content in special node
     * @param group - node number
     * @return file content
     * @throws Exception
     */
    public static String getFileContent(int group) throws Exception {
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + SCRIPT_GET_CONFIG_FILE,
                ETC_GROUP + group + CONFIG_FILE_NAME };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        StringBuffer strBuf = new StringBuffer();
        if (results.length > 0) {
            strBuf.append(results[0]);
            for (int i = 1; i < results.length; i++) {
                strBuf.append("\n");
                strBuf.append(results[i]);
            }
        }
        return strBuf.toString();
    }
    /**
     * save the configure file content to file
     * @param group - node number
     * @param content - file content
     * @throws Exception
     */
    public static void saveFileContent(int group, String content)
        throws Exception {
        String tempFileName = createTempFile(group, content);
        if (tempFileName == null) {
            throw new Exception();
        }
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + SCRIPT_SAVE_CONFIG_FILE,
                Integer.toString(group),
                tempFileName,
                ETC_GROUP + group + CONFIG_FILE_NAME };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }
    public static String createTempFile(int group, String content)
        throws Exception {
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + SCRIPT_CREATE_TEMP_FILE,
                Integer.toString(group)};
        String[] inputs = { content };
        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, inputs);
        if (cmdResult.getExitValue() != 0) {
            return null;
        }
        return cmdResult.getStdout()[0];
    }

    public static List getEntryList(String exportGroup, int groupNo) throws Exception{
        return getEntryList(exportGroup,groupNo, false);    
    }
    public static List getEntryList(String exportGroup, int groupNo, boolean doWhenMaintance)
        throws Exception {
        List entryList = new Vector();
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + GET_ENTRY_SCRIPT,
                exportGroup,
                Integer.toString(groupNo)};
        NSCmdResult result = CmdExecBase.execCmd(cmds, groupNo,true,doWhenMaintance);
        String[] stdout = result.getStdout();

        for (int i = 0; i < stdout.length;) {
            EntryInfoBean eib = new EntryInfoBean();
            List clients = new Vector();
            String[] line = stdout[i].split("\\s+");
            eib.setDirectory(line[0]);
            eib.setIsNormal(line[1].equals("1"));
            int clientsCount = Integer.parseInt(line[2]);
            eib.setClientNum(clientsCount);
            for (int j = ++i; i < j + clientsCount; i++) {
                String curLine = stdout[i];
                ClientInfoBean cib = new ClientInfoBean();
                cib.setClientName(curLine.substring(0, curLine.indexOf("(")));
                String option =
                    curLine.substring(
                        curLine.indexOf("(") + 1,
                        curLine.length() - 1);
                if (option != null && !option.equals("")) {
                    cib.setOption(option);
                } else {
                    cib.setOption(" ");
                }
                clients.add(cib);
            }
            eib.setClients(clients);
            entryList.add(eib);
        }
        return entryList;
    }

    public static void deleteEntry(String directory, int groupNo)
        throws Exception {
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + DELETE_ENTRY_SCRIPT,
                directory,
                Integer.toString(groupNo)};
        CmdExecBase.execCmd(cmds, groupNo);
    }
    /**
     * 
     * @param exportGroup
     * @param directory
     * @param group
     * @return
     * @throws Exception
     */
    public static DetailInfoBean getDetailInfo(
        String exportGroup,
        String directory,
        int group)
        throws Exception {
        DetailInfoBean detailInfo = new DetailInfoBean();
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + GET_ALL_DETAIL_INFO_SCRIPT,
                exportGroup,
                directory,
                Integer.toString(group)};
        NSCmdResult result = CmdExecBase.execCmd(cmds, group);
        String[] stdout = result.getStdout();
        int i = 1;
        // skip stdout[0](# Directory Information)
        detailInfo.setNeedAuthDomain(stdout[i++].equals("true"));
        detailInfo.setIsSxfsfw(stdout[i++].equals("true"));
        detailInfo.setIsSubMountPoint(!stdout[i++].equals("false"));
        detailInfo.setSeletedNisDomain4Unix(stdout[i++]);
        detailInfo.setSeletedNisDomain4Win(stdout[i++]);
        StringBuffer clientOptions = new StringBuffer();
        for (; !stdout[i].trim().equals("# Other Information"); i++) {
            clientOptions.append(stdout[i]);
            clientOptions.append("\n");
        }
        detailInfo.setClientOptions(clientOptions.toString());
        i++;
        detailInfo.setNeedNativeDomain(stdout[i].equals("true"));
        List nisList = new ArrayList();
        for (i++; i < stdout.length; i++) {
            nisList.add(stdout[i]);
        }
        detailInfo.setNisDomainList(nisList);
        return detailInfo;
    }
    /**
     * set all clients
     * @param orgDirectory
     * @param directory
     * @param clientOptions
     * @param group
     */
    public static void setExportClients(
        String orgDirectory,
        String directory,
        String clientOptions,
        int group)
        throws Exception {
        
        String fileContent="";
        fileContent=orgDirectory+"\n"+directory+"\n"+clientOptions;
        
        String tempFileName = createTempFile(group, fileContent);
        if (tempFileName == null) {
            throw new Exception();
        }
        
        String[] cmds =
            {
                SUDO_COMMAND,
                System.getProperty("user.home") + MODIFY_EXPORT_INFO_SCRIPT,
                tempFileName,
                Integer.toString(group)};
        CmdExecBase.execCmd(cmds, group);
    }
    /**
     *get the info from accesslog and performance information files
     * @param groupNo such as [0|1]
     * @return the vector like (success,accessLogInfo,performLogInfo)
     * @throws Exception
     */
    public static Vector getLogFileInfo(int group) throws Exception {
        Vector result = new Vector();
        String[] cmds = {
                SUDO_COMMAND,
                System.getProperty("user.home") + GET_LOG_FILE_INFO_SCRIPT};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] stdout = cmdResult.getStdout();
        result.add(stdout[0]);
        LogInfoBean accessloginfo = new LogInfoBean();
        accessloginfo.setFileName(stdout[1]);
        accessloginfo.setUserAuth(stdout[2]);
        accessloginfo.setGenerationNum(stdout[3]);
        accessloginfo.setFileSize(stdout[4]);
        accessloginfo.setFileSizeUnit(stdout[5]);
        result.add(accessloginfo);
        return result;
    }
    /**
     * save accesslog and performance infos' into files
     * @param the object of accesslogInfo
     * @param the object of performlogInfo
     * @param group such as 0 or 1
     * @return none
     * @throws Exception
     */
    public static void saveOptionsToFile( LogInfoBean accesslogInfo, int group )
                                            throws Exception {
        String[] cmds = { SUDO_COMMAND,
                System.getProperty("user.home") + SAVE_LOG_INFO_SCRIPT,
                accesslogInfo.getFileName(),accesslogInfo.getUserAuth(),
                accesslogInfo.getGenerationNum(),accesslogInfo.getFileSize()+accesslogInfo.getFileSizeUnit(),
                Integer.toString(group)};
        CmdExecBase.execCmd(cmds, group);
    }
    
    /**
     * @param directory
     * @param group
     * @return
     */
    public static Vector getClientInfo(String directory, int group) throws Exception {
        Vector result = new Vector();
        String[] cmds = { SUDO_COMMAND,
                          System.getProperty("user.home") + GET_CLIENT_INFO_SCRIPT,
                          directory,
                          Integer.toString(group)};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] stdout = cmdResult.getStdout();
        for(int i=0; i<stdout.length; i++) {
            String[] options = stdout[i].split("\\s");
            ClientOptionInfoBean clientInfo = new ClientOptionInfoBean();
            clientInfo.setClient(options[0]);
            clientInfo.setNisDomain(options[1]);
            clientInfo.setAccessMode(options[2]);
            clientInfo.setUsermapping(options[3]);
            clientInfo.setRootSquash(options[4]);
            clientInfo.setAnnonuid(options[5]);
            clientInfo.setAnnongid(options[6]);
            clientInfo.setSubtree(options[7].equals("1"));
            clientInfo.setHide(options[8].equals("1"));
            clientInfo.setSecure(options[9].equals("1"));
            clientInfo.setSecureLock(options[10].equals("1"));
            clientInfo.setAccesslog(options[11].equals("1"));
            clientInfo.setCreate(options[12]);
            clientInfo.setRemove(options[13]);
            clientInfo.setWrite(options[14]);
            clientInfo.setRead(options[15]);
            clientInfo.setUnstablewrite(options[16].equals("1"));
            result.add(clientInfo);
        }
        return result;
    }
    
    public static String getAccessStatus(int nodeNo) throws Exception {
		String[] cmds = {SUDO_COMMAND,
				System.getProperty("user.home") + NSGUI_GET_VALUE_SCRIPT,
				ACCESS_STATUS_CONF_FILE, ACCESS_STATUS_KEY};
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, null, nodeNo, false);
		if (cmdResult.getExitValue() == 0) {
			String[] stdout = cmdResult.getStdout();
			String result = stdout[0].trim();
			if (result.equals("0")) {
				return "available";
			} else if (result.equals("1")) {
				return "deny";
			} else {
				return "undefined";
			}
		} else {
			return "undefined";
		}
	}
	
	public static void setAccessStatus(int nodeNo,String para)
			throws Exception {
		String[] cmds = {SUDO_COMMAND,
				System.getProperty("user.home") + SET_ACCESS_STATUS_SCRIPT,
				para};
		CmdExecBase.execCmd(cmds,nodeNo);
	}
}
