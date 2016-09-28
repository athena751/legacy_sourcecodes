/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.ndmpv4;

import java.util.List;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.ndmpv4.NdmpInfoBean;

public class NdmpHandler {
    private static final String cvsid = "@(#) $Id: NdmpHandler.java,v 1.5 2006/12/26 03:13:52 wanghui Exp $"; 
    private static final String NDMP_GETALLINTERFACES = "/bin/ndmp_getAllInterfaces.pl";
    private static final String NDMP_SETNDMPINFO = "/bin/ndmp_setNDMPInfo.pl";
    private static final String NDMP_GETNDMPINFO = "/bin/ndmp_getNDMPInfo.pl";
    private static final String NDMPV2_GETNDMPINFO = "/bin/ndmp_getNDMPV2Info.pl";
    private static final String SCRIPT_NDMP_STATUS_MANAGEMENT = "/bin/ndmp_ndmpdManagement.pl";
    private static final String SCRIPT_NDMP_GET_DEVICEINFO = "/bin/ndmp_getDeviceInfo.pl"; 
    private static final String DEVICE_CMD_INTERFACE = "/opt/nec/ndmp/ndmp_device"; 
    private static final String NDMP_CONFIGFILE_PATH = "/etc/group"; 
    private static final String NDMP_CONFIGFILE_NAME = "/ndmp/ndmpd.config"; 
    private static final String SERVICE_CMD_INTERFACE = "/opt/nec/ndmp/ndmp_service";
    private static final String SCRIPT_NDMP_SESSION_GET = "/bin/ndmp_getNDMPSessionInfo.pl";
    private static final String SCRIPT_GET_SYSDATE = "/bin/cifs_getSysDate.pl";
    private static final String SCRIPT_NDMP_GET_RUNNINGVERSION = "/bin/ndmp_getRunningVersion.pl";
    private static final String SCRIPT_GET_SESSIONFILE_PATH = "/bin/ndmp_getNDMPSessionPath.pl";
    private static final String SCRIPT_HAVE_SESSION_INFO = "/bin/ndmp_haveSessionInfo.pl";
    private static final String NDMP_VERSIONFILE_NAME="/opt/nec/ndmp/ndmp_version.info";
    private static final String NDMPV2_CONFIGFILE_NAME="/etc/sysconfig/ndmpd";
    private static String home = System.getProperty("user.home");
    public static NdmpInfoBean getNdmpConfigInfo(int groupNum) throws Exception{
        String ndmp_RunningVersion = getRunningVersion(groupNum);
        NdmpInfoBean ndmpInfoBean = new NdmpInfoBean();
        String[] cmdsv4 =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + NDMP_GETNDMPINFO,
                Integer.toString(groupNum)};
        NSCmdResult cmdResultV4 = CmdExecBase.execCmdBaseTargetFile(cmdsv4, null, groupNum, 
                                true, NDMP_CONFIGFILE_PATH + Integer.toString(groupNum) + NDMP_CONFIGFILE_NAME);
        String[] cmdsv2 =
        {   CmdExecBase.CMD_SUDO,
            System.getProperty("user.home") + NDMPV2_GETNDMPINFO };
        NSCmdResult cmdResultV2 = CmdExecBase.execCmdBaseTargetFile(cmdsv2, null, groupNum, 
                                true, NDMPV2_CONFIGFILE_NAME);
        int lengthv2 = 0;
        int lengthv4 = 0;
        if(cmdResultV2.getStdout() != null) {
            lengthv2 = cmdResultV2.getStdout().length;
        }
        if(cmdResultV4.getStdout() != null) {
            lengthv4 = cmdResultV4.getStdout().length;
        }
        String[] result = new String[lengthv2 + lengthv4];
        for(int i = 0; i < lengthv2; i++){
                result[i] = cmdResultV2.getStdout()[i];
        }
        for(int i = lengthv2; i < lengthv2 + lengthv4; i++){
                result[i] = cmdResultV4.getStdout()[i - lengthv2];
        }
        NSBeanUtil.setProperties(ndmpInfoBean, result);
        ndmpInfoBean.setDefaultVersion(ndmp_RunningVersion);
        return ndmpInfoBean;
     }         
    
    public static String[] getAllInterfaces(int nodeNo) throws Exception {
        String [] cmds = 
            {    CmdExecBase.CMD_SUDO,
                 System.getProperty("user.home") + NDMP_GETALLINTERFACES};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        return cmdResult.getStdout();
    }
    
    public static void setNdmpConfig(int groupNum, NdmpInfoBean ndmpInfo) throws Exception {
        String [] cmds =
        {        CmdExecBase.CMD_SUDO, 
                 System.getProperty("user.home") + NDMP_SETNDMPINFO,
                 Integer.toString(groupNum),                 
                 ndmpInfo.getDefaultVersion(), 
                 array2str(ndmpInfo.getCtrlConnectionIP(), ","),
                 array2str(ndmpInfo.getDataConnectionIP(), ","),                 
                 ndmpInfo.getChangePassword(),                 
                 ndmpInfo.getAuthorizedDMAIP().trim().replaceAll("\\s+", ","),                 
                 ndmpInfo.getDataConnectionIPV2(),
                 ndmpInfo.getBackupSoftware()
                 };
        String [] inputs = {ndmpInfo.getPassword_()};
        CmdExecBase.execCmd(cmds, inputs, groupNum);
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
     public static String getStatus(int nodeNum)throws Exception{
        
        String[] cmds = {CmdExecBase.CMD_SUDO,home+SCRIPT_NDMP_STATUS_MANAGEMENT,"status"}; 
        NSCmdResult result = CmdExecBase.execCmdBaseTargetFile(cmds, null, nodeNum, 
                true, SERVICE_CMD_INTERFACE);
        return result.getStdout()[0];
    } 
    
    public static String changeStatus(String status,int nodeNum)throws Exception{
        
        String [] cmds = {CmdExecBase.CMD_SUDO,home+SCRIPT_NDMP_STATUS_MANAGEMENT,status};
        NSCmdResult result = CmdExecBase.execCmd(cmds,nodeNum);
        return result.getStdout()[0];
        
    }

    public static List getSessionInfo(int groupNum,String sessionFilePath)throws Exception{
        
        String []cmds = {CmdExecBase.CMD_SUDO,home+SCRIPT_NDMP_SESSION_GET,sessionFilePath};
        NSCmdResult cmdResults = CmdExecBase.execCmdBaseTargetFile(cmds, null, groupNum, 
                true, sessionFilePath);
        String results[] = cmdResults.getStdout();
        return NSBeanUtil.createBeanList(
               "com.nec.nsgui.model.entity.ndmpv4.NdmpSessionInfoBean", 
               results, 15);
    } 
    
    public static String getSessionPath(int groupNum)throws Exception{
        String []cmds = {CmdExecBase.CMD_SUDO,home+SCRIPT_GET_SESSIONFILE_PATH,Integer.toString(groupNum)};
        NSCmdResult cmdResult = CmdExecBase.execCmdBaseTargetFile(cmds, null, groupNum, 
                true, NDMP_CONFIGFILE_PATH + Integer.toString(groupNum) + NDMP_CONFIGFILE_NAME);
        return cmdResult.getStdout()[0];
    }
    
    public static List getDeviceInfo(int groupNum)throws Exception{
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_NDMP_GET_DEVICEINFO};  
        NSCmdResult cmdResult = CmdExecBase.execCmdBaseTargetFile(cmds, null, groupNum, 
                                    true, DEVICE_CMD_INTERFACE);
        String results[] = cmdResult.getStdout();        
        return  NSBeanUtil.createBeanList(
                "com.nec.nsgui.model.entity.ndmpv4.DeviceInfoBean", 
                results, 11);         
    }
    public static String[] getSysDate(int nodeNum,String path) throws Exception {
        String[] cmds =
            {    CmdExecBase.CMD_SUDO,
                 home+ SCRIPT_GET_SYSDATE};
        NSCmdResult cmdResult = CmdExecBase.execCmdBaseTargetFile(cmds, null, nodeNum, 
                true,path);
        String[] dates = cmdResult.getStdout();
        return dates;
    }
    
    public static String getRunningVersion(int nodeNum)throws Exception{
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_NDMP_GET_RUNNINGVERSION};  
        NSCmdResult cmdResult = CmdExecBase.execCmdBaseTargetFile(cmds, null, nodeNum,
                true, NDMP_VERSIONFILE_NAME);                 
        return cmdResult.getStdout()[0];         
    }
    
    public static String haveSessionInfo(int nodeNum, String sessionFilePath)throws Exception{
        String[] cmds =
            {   CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCRIPT_HAVE_SESSION_INFO,
                sessionFilePath};  
        NSCmdResult cmdResult = CmdExecBase.execCmdBaseTargetFile(cmds, null, nodeNum,
                true, sessionFilePath);                 
        return cmdResult.getStdout()[0];         
    }
}