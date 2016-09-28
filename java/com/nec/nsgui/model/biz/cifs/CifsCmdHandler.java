/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.cifs;

import java.util.List;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.model.entity.cifs.CifsConstant;
import com.nec.nsgui.model.entity.cifs.CifsGlobalInfoBean;
import com.nec.nsgui.model.entity.cifs.CifsShareAccessLogBean;
import com.nec.nsgui.model.entity.cifs.DirAccessControlInfoBean;
import com.nec.nsgui.model.entity.cifs.ShareOptionBean;
import com.nec.nsgui.model.entity.cifs.CifsOtherOptionsBean;

/**
 *model for CIFS
 */
public class CifsCmdHandler implements CifsConstant {

    private static final String cvsid = "@(#) $Id: CifsCmdHandler.java,v 1.18 2009/03/30 05:00:30 chenbc Exp $";
    public static final String SCIRPT_READ_SMB_CONFIG_FILE
        = "/bin/cifs_readSmbConf.pl";
    public static final String SCIRPT_READ_DIR_ACCESS_CONFIG_FILE
        = "/bin/cifs_readDirAccessConf.pl";
    public static final String SCIRPT_SAVE_DIR_ACCESS_CONFIG_FILE
        = "/bin/cifs_saveDirAccessConf.pl";
    public static final String SCIRPT_GET_SHARE_LIST_INFO_FILE
        = "/bin/cifs_getShareListInfo.pl";
    public static final String SCIRPT_SAVE_SMB_CONFIG_FILE
        = "/bin/cifs_saveSmbConf.pl";
    public static final String SCIRPT_GET_COMPUTER_INFO_FILE
        = "/bin/cifs_getComputerInfo.pl";
    public static final String SCIRPT_GET_SHARE_OPTION_FILE
        = "/bin/cifs_getShareOption.pl";
    public static final String SCIRPT_SET_SHARE_OPTION_FILE
        = "/bin/cifs_setShareOption.pl";
    public static final String SCIRPT_IS_WORKING_SHARE_FILE   
        = "/bin/cifs_isWorkingShare.pl";
    public static final String SCIRPT_HAS_AVAILABLE_NIC_FOR_CIFS   
        = "/bin/cifs_hasAvailableNicForCIFS.pl";
    public static final String SCIRPT_HAS_SET_ACCESS_LOG_FILE
        = "/bin/cifs_hasSetAccessLog.pl";
    public static final String SCIRPT_CAN_ADD_SHARE_FILE
        = "/bin/cifs_canAddShare.pl";
    public static final String SCIRPT_DELETE_SHARE_FILE         
        = "/bin/cifs_deleteShare.pl";
    public static final String SCRIPT_SET_SHARE_ACCESS_LOG =
        "/bin/cifs_setShareAccessLog.pl";
    public static final String SCRIPT_GET_SHARE_ACCESS_LOG =
        "/bin/cifs_getShareAccessLog.pl";
    public static final String SCRIPT_SET_GLOBAL_INFO =
        "/bin/cifs_setGlobalInfo.pl";
    public static final String SCRIPT_GET_GLOBAL_INFO =
        "/bin/cifs_getGlobalInfo.pl";
    public static final String SCRIPT_GET_INTERFACE_FROM_SMB =
        "/bin/cifs_getInterfaceFromSmb.pl";
    public static final String SCRIPT_NEED_SNAP_SCHEDULE_CONFIRM =
        "/bin/cifs_needSnapshotConfirm.pl";
    public static final String SCRIPT_GET_DIR_ACCESS_CONTROL_LIST =
        "/bin/cifs_getDirAccessListInfo.pl";
    public static final String SCRIPT_DELETE_DIR_ACCESS_CONTROL =
        "/bin/cifs_deleteDirAccessControl.pl";
    public static final String SCRIPT_SET_DIR_ACCESS_CONTROL =
        "/bin/cifs_setDirAccessControl.pl";
    public static final String SCIRPT_HAS_SHARE_EXIST =
        "/bin/cifs_doesShareExist.pl";
    public static final String SCRIPT_DC_GETACCESSSTATUS =
        "/bin/cifs_getDCConnectionStatus.pl";
    public static final String SCRIPT_DC_RECONNECT =
        "/bin/cifs_DCReconnect.pl";
    public static final String SCRIPT_DC_GETDCLOGFILEPATH =
        "/bin/cifs_getDCLogFilePath.pl";
    public static final String SCRIPT_GET_PASSWDSERVER =
        "/bin/cifs_getPasswdServer.pl";
    public static final String SCRIPT_GET_SYSDATE =
    	"/bin/cifs_getSysDate.pl";
    public static final String SCRIPT_DEL_ONEFILE =
    	"/bin/cifs_deleteOneFile.pl";
    public static final String SCRIPT_GET_DIRECTHOSTING =
        "/bin/cifs_getDirectHosting.pl";
    public static final String SCRIPT_SET_DIRECTHOSTING =
        "/bin/cifs_setDirectHosting.pl";
    public static final String SCRIPT_GET_DIRECTMP = 
        "/bin/cifs_getDirectMP.pl";
    public static final String SCRIPT_GET_REALTIMESCANUSERANDSERVER = 
        "/bin/cifs_getRealtimeScanUserAndServer.pl";
    public static final String SCRIPT_GET_PRIVILEGEUSER = 
        "/bin/serverprotect_getLudbUsers.pl";
    public static final String SCRIPT_GET_VIRUS_SCAN_MODE =
        "/bin/serverprotect_getVirusScanMode.pl";
    public static final String SCRIPT_HAS_SETANTIVIRUSSCAN = 
        "/bin/cifs_hasSetAntiVirusScan.pl";
    public static final String SCRIPT_HAS_CHECK_SCHEDULESCAN_CONNECTION =
        "/bin/cifs_hasScheduleScanConnection.pl";
    public static final String SCRIPT_GET_SCHEDULESCANUSERANDSERVER =
        "/bin/cifs_getScheduleScanUserAndServer.pl";
    
    /**
     * get the configure file content of smb.conf.%L or the access conf file
     * @param group - group number
     * @param domainName - domain Name
     * @param computerName - computer Name
     * @return file content
     * @throws Exception
     */
    public static String getFileContent(int group, String domainName, String computerName,
      String targetFileType) throws Exception {
        String perlScriptName = SCIRPT_READ_SMB_CONFIG_FILE;
        if(targetFileType.equals("dirAccessConf")){
            perlScriptName = SCIRPT_READ_DIR_ACCESS_CONFIG_FILE;
        }
        String[] cmds ={ CmdExecBase.CMD_SUDO, 
        System.getProperty("user.home") + perlScriptName,
        Integer.toString(group),
        domainName,
        computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        StringBuffer strBuf = new StringBuffer();
        if(results.length > 0){
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
     * @param group - group number
     * @param content - file content
     * @param domainName - domain Name
     * @param computerName - computer Name
     * @throws Exception
     */
    public static void saveFileContent(int group, String content, String domainName,
      String computerName, String targetFileType) throws Exception {
        String tempFile = NFSModel.createTempFile(group, content);
        String perlScriptName = SCIRPT_SAVE_SMB_CONFIG_FILE;
        if(targetFileType.equals("dirAccessConf")){
            perlScriptName = SCIRPT_SAVE_DIR_ACCESS_CONFIG_FILE;
        }
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + perlScriptName,
                Integer.toString(group),
                domainName,
                computerName,
                tempFile };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }

    public static String[] getComputerInfo(int group, String exportGroup) throws Exception {
        return getComputerInfo(group, exportGroup, false);
    }

    public static String[] getComputerInfo(int group, String exportGroup, boolean doWhenMaintance)
         throws Exception {

        String[] cmds ={ CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCIRPT_GET_COMPUTER_INFO_FILE,
                 Integer.toString(group),
                 exportGroup};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
        return cmdResult.getStdout();
    }

    public static String[] needConfirmToSnapSchedule(int group, String dir)throws Exception {

        String[] cmds ={ CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_NEED_SNAP_SCHEDULE_CONFIRM,
                 Integer.toString(group),
                 dir};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        return cmdResult.getStdout();
    }
    
    /**
     * get the configure file content of smb.conf.%L
     * @param group - group number
     * @param domainName - domain Name
     * @param computerName - computer Name
     * @return the list of [ShareInfoBean] object
     * @throws Exception
     * */
    public static List getShareList(int group, String domainName, String computerName, String shareType)
        throws Exception {

        return getShareList(group, domainName, computerName, shareType, false);
    }

    public static List getShareList(int group, String domainName, String computerName, String shareType, boolean doWhenMaintance)
        throws Exception {
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_GET_SHARE_LIST_INFO_FILE,
                Integer.toString(group),
                domainName,
                computerName,
                shareType};
            NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
            String[] results = cmdResult.getStdout();
            
            return NSBeanUtil.createBeanList(
                    "com.nec.nsgui.model.entity.cifs.ShareInfoBean", 
                    results, 8);
    }
    
    public static List getSpecialShareList(int group, String domainName, String computerName, String shareType)
    throws Exception {
        return getSpecialShareList(group, domainName, computerName, shareType, false);
    }
    
    public static List getSpecialShareList(int group, String domainName, String computerName, String shareType, boolean doWhenMaintance)
    throws Exception {
    String[] cmds =
        {   CmdExecBase.CMD_SUDO,
            System.getProperty("user.home") + SCIRPT_GET_SHARE_LIST_INFO_FILE,
            Integer.toString(group),
            domainName,
            computerName,
            shareType};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
        String[] results = cmdResult.getStdout();
        
        return NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.cifs.ShareInfoBean", 
                results, 7);
}

    public static List getDirAccessControlList(int group, String domainName, String computerName, String shareName)
        throws Exception {

        return getDirAccessControlList(group, domainName, computerName, shareName, false);
    }

    public static List getDirAccessControlList(int group, String domainName, 
        String computerName, String shareName, boolean doWhenMaintance)throws Exception {
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_DIR_ACCESS_CONTROL_LIST,
                Integer.toString(group),
                domainName,
                computerName,
                shareName };
            NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group, true, doWhenMaintance);
            String[] results = cmdResult.getStdout();
            
            return NSBeanUtil.createBeanList(
                    "com.nec.nsgui.model.entity.cifs.DirAccessControlInfoBean", 
                    results, 3);
    }

    public static ShareOptionBean getShareInfo(int group, String domainName,
     String computerName, String shareName) throws Exception{
        //get the info for modify a share's option
         ShareOptionBean shareOptionBean = new ShareOptionBean();
         String[] cmds =
             {   CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCIRPT_GET_SHARE_OPTION_FILE,
                 Integer.toString(group),
                 domainName,
                 computerName,
                 shareName };
         NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
         NSBeanUtil.setProperties(shareOptionBean, cmdResult.getStdout());
         return shareOptionBean;
     }

    public static String isWorkingShare(int group, String domainName,
            String computerName, String shareName) throws Exception{

        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_IS_WORKING_SHARE_FILE,
                Integer.toString(group),
                domainName,
                computerName,
                shareName };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        return results[0];
    }
 
    public static String hasAvailableNicForCIFS(int group) throws Exception{

        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_HAS_AVAILABLE_NIC_FOR_CIFS};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        return results[0];
    }    
 
    public static String getInterfacesFromSmb(int group, String domainName,
            String computerName) throws Exception{

        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_INTERFACE_FROM_SMB,
                Integer.toString(group),
                domainName,
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        return results[0];
    }
    
    public static String hasSetAccessLog(int group, String domainName,
            String computerName) throws Exception{

        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_HAS_SET_ACCESS_LOG_FILE,
                Integer.toString(group),
                domainName,
                computerName };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        return results[0];
    }

    public static String canAddShare(int group, String exportGroup) throws Exception {
        return canAddShare(group, exportGroup, "");
    }

    public static String canAddShare(int group, String exportGroup, String shareType) throws Exception {
        String[] cmds ={ CmdExecBase.CMD_SUDO,
             System.getProperty("user.home") + SCIRPT_CAN_ADD_SHARE_FILE,
             Integer.toString(group),
             exportGroup,
             shareType};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] results = cmdResult.getStdout();
        return results[0];
    }
 
    public static void deleteShare(int group, String domainName, 
        String computerName, String shareName) throws Exception {

        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_DELETE_SHARE_FILE,
                Integer.toString(group),
                domainName,
                computerName,
                shareName };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }

    public static void deleteDirAccessControl(int group, String domainName, 
        String computerName, String shareName, String directory) throws Exception {

        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_DELETE_DIR_ACCESS_CONTROL,
                Integer.toString(group),
                domainName,
                computerName,
                shareName,
                directory };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }

    public static void setDirAccessControl(int group, String domainName, String computerName,
        String operationType, String shareName, DirAccessControlInfoBean dirAccessInfo)throws Exception {
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SET_DIR_ACCESS_CONTROL,
                Integer.toString(group), domainName, computerName, operationType, shareName, 
                dirAccessInfo.getDirectory(), dirAccessInfo.getAllowHost(), dirAccessInfo.getDenyHost() };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }

    public static void setShareOption(int group, String domainName,
        String computerName, ShareOptionBean shareInfo)throws Exception {
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_SET_SHARE_OPTION_FILE,
                Integer.toString(group), domainName, computerName, shareInfo.getSettingOperation(),
                shareInfo.getShareName(), shareInfo.getConnection(),
                shareInfo.getDirectory(), shareInfo.getComment(), shareInfo.getReadOnly(),
                shareInfo.getWriteList(), shareInfo.getSettingPassword(), shareInfo.getValidUser_Group(),
                shareInfo.getInvalidUser_Group(), shareInfo.getHostsAllow(),shareInfo.getHostsDeny(),
                shareInfo.getServerProtect(), shareInfo.getUserName(), shareInfo.getPasswordChanged(),
                shareInfo.getShadowCopy(), shareInfo.getDirAccessControlAvailable(), shareInfo.getSharePurpose(),
                shareInfo.getAntiVirusForShare(), shareInfo.getBrowseable(), shareInfo.getPseudoABE()};
        String[] inputs = {shareInfo.getPassword_()};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, inputs, group);
    }

    public static void setShareAccessLog(
        int group,
        String domainName,
        String computerName,
        String shareName,
        CifsShareAccessLogBean info)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SET_SHARE_ACCESS_LOG,
                Integer.toString(group),
                domainName,
                computerName,
                shareName,
                info.getAlogEnable(),
                array2str(
                    info.getSuccessLoggingItems(),
                    CifsShareAccessLogBean.SPLITER),
                array2str(
                    info.getErrorLoggingItems(),
                    CifsShareAccessLogBean.SPLITER)};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }

    public static CifsShareAccessLogBean getShareAccessLog(
        int group,
        String domainName,
        String computerName,
        String shareName)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_SHARE_ACCESS_LOG,
                Integer.toString(group),
                domainName,
                computerName,
                shareName };
                
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        CifsShareAccessLogBean bean = new CifsShareAccessLogBean();
        NSBeanUtil.setProperties(bean, cmdResult.getStdout());
        return bean;
    }

    public static void setGlobalInfo(
        int group,
        String domainName,
        String computerName,
        CifsGlobalInfoBean info)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_SET_GLOBAL_INFO,
                Integer.toString(group),
                domainName,
                computerName,
                info.getEncryptPasswords(),
                array2str(info.getInterfaces(), " "),
                info.getServerString(),
                info.getDeadtime(),
                info.getValidUsers(),
                info.getInvalidUsers(),
                info.getHostsAllow(),
                info.getHostsDeny(),
                info.getAlogFile(),
                info.getCanReadLog(),
                array2str(
                    info.getSuccessLoggingItems(),
                    CifsGlobalInfoBean.SPLITER),
                array2str(
                    info.getErrorLoggingItems(),
                    CifsGlobalInfoBean.SPLITER),
                info.getDirAccessControlAvailable(),
                info.getAntiVirusForGlobal()};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
    }

    public static CifsGlobalInfoBean getGlobalInfo(
        int group,
        String domainName,
        String computerName)
        throws Exception {
        String[] cmds =
            {
                CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_GLOBAL_INFO,
                Integer.toString(group),
                domainName,
                computerName };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        CifsGlobalInfoBean bean = new CifsGlobalInfoBean();
        NSBeanUtil.setProperties(bean, cmdResult.getStdout(), " ");
        return bean;
    }

    private static String array2str(String[] array, String connector) {
        if (array == null || array.length == 0) {
            return "";
        }
        StringBuffer sb = new StringBuffer("");
        for (int i = 0; i < array.length; i++) {
            sb.append(array[i]);
            sb.append(connector);
        }
        sb.deleteCharAt(sb.length() - 1);
        return sb.toString();
    }   
    
    public static String getShareExist(int group, String domainName,
              String computerName,String shareName) throws Exception{

          String[] cmds =
              {   CmdExecBase.CMD_SUDO,
                  System.getProperty("user.home") + SCIRPT_HAS_SHARE_EXIST,
                  Integer.toString(group),
                  domainName,
                  computerName,
                  shareName};
          NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
          String[] results = cmdResult.getStdout();
          return results[0];
      }
    
    public static List getDCAccessStatus(int nodeNo, String domainName) throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_DC_GETACCESSSTATUS,
                 domainName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] stdout = cmdResult.getStdout();
        return NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.cifs.DCConnectionStatusBean", 
                stdout, 4);
    }

    public static void dcReConnect(int nodeNo)
            throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_DC_RECONNECT};
        CmdExecBase.execCmd(cmds, nodeNo);
    }
    
    public static String getDCLogFilePath(int nodeNo, String domainName) throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_DC_GETDCLOGFILEPATH,
                 domainName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] stdout = cmdResult.getStdout();
        return stdout[0];
    }
    
    public static String getPasswdServer(int nodeNo, String domainName, String computerName) throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_GET_PASSWDSERVER,
                 Integer.toString(nodeNo),
                 domainName,
                 computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] stdout = cmdResult.getStdout();
        return stdout[0];
    }
    
    public static void deleteDCLogTmpFile(int nodeNo, String tmpFileName) throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_DEL_ONEFILE,
                 tmpFileName};
        try {
            CmdExecBase.execCmd(cmds, nodeNo);
        } catch (Exception ex) {
        }
    }
    
    public static String[] getSysDate(int nodeNo, boolean bForce) throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_GET_SYSDATE};
        NSCmdResult cmdResult = (bForce == true)? 
             CmdExecBase.execCmdForce(cmds, nodeNo, true) : CmdExecBase.execCmd(cmds, nodeNo);
        String[] dates = cmdResult.getStdout();
        return dates;
    }
    
    public static String[] getDirectHosting(int nodeNo, String domainName, String computerName) throws Exception {
        String[] cmds =
        {      CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_DIRECTHOSTING,
                Integer.toString(nodeNo),
                domainName,
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        return cmdResult.getStdout();
    }
    
    public static String setDirectHosting(int nodeNo, String domainName, String computerName, 
            CifsOtherOptionsBean otherOptions) throws Exception {
        String[] cmds =
        {      CmdExecBase.CMD_SUDO,
               System.getProperty("user.home") + SCRIPT_SET_DIRECTHOSTING,
               Integer.toString(nodeNo),
               domainName,
               computerName,
               otherOptions.getDirectHosting()};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        String[] stdout = cmdResult.getStdout();
        return stdout[0];
    }
    
    public static String hasSetAntiVirusScan(int group, String domainName, String computerName,
            String shareName) throws Exception {
        String[] cmds = 
        {        CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + SCRIPT_HAS_SETANTIVIRUSSCAN,
                 Integer.toString(group),
                 domainName,
                 computerName,
                 shareName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] stdout = cmdResult.getStdout();
        return stdout[0];
    }
    
    public static String[] getDirectMP(int group, String exportGroup, String fstype) throws Exception {
        String[] cmds =
        {       CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_DIRECTMP,
                Integer.toString(group),
                exportGroup,
                fstype};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        return cmdResult.getStdout();
    }
    
    public static String[] getRealtimeScanUserAndServer(int group, String domainName, String computerName) throws Exception {
        String[] cmds =
        {       CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_REALTIMESCANUSERANDSERVER,
                Integer.toString(group),
                domainName,
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        return cmdResult.getStdout();
    }
    
    public static String[] getPrivilegeUser(int group, String domainName, String computerName, String userType)
    throws Exception {
        String[] cmds =
        {       CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_PRIVILEGEUSER,
                Integer.toString(group),
                domainName,
                computerName,
                userType};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] users = cmdResult.getStdout();
        if(users != null && users.length > 0) {
            for (int i = 0; i < users.length; i ++) {
                users[i] = domainName + "+" + users[i];
            }
        }
        return users;
    }
    
    public static String getVirusScanMode(int group, String domainName, String computerName)
    throws Exception {
        String[] cmds =
        {       CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_VIRUS_SCAN_MODE,
                Integer.toString(group),
                domainName,
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] stdout = cmdResult.getStdout();
        return stdout[0];
    }
    
    public static String checkScheduleScanConnection(int group, String domainName, String computerName, String shareName)
    throws Exception {
        String[] cmds =
        {       CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_HAS_CHECK_SCHEDULESCAN_CONNECTION,
                Integer.toString(group),
                domainName,
                computerName,
                shareName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] stdout = cmdResult.getStdout();
        return stdout[0];
    }
    
    public static String[] getScheduleScanUserAndServer(int group, String domainName, String computerName)
    throws Exception {
        String[] cmds =
        {       CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_GET_SCHEDULESCANUSERANDSERVER,
                Integer.toString(group),
                domainName,
                computerName};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, group);
        String[] stdout = cmdResult.getStdout();
        return stdout;
    }
}
