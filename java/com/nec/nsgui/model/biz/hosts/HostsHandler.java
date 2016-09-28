/*
 *      Copyright (c) 2006-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.hosts;

import java.util.Vector;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.nfs.NFSModel;
import com.nec.nsgui.action.hosts.HostsActionConst;
import com.nec.nsgui.model.biz.base.NSException;

/**
 *model for Hosts
 */
public class HostsHandler implements HostsActionConst {

    private static final String cvsid = "@(#) $Id: HostsHandler.java,v 1.3 2007/05/29 09:20:23 wanghui Exp $";

    private static final String SCRIPT_HOSTS_FILE_GET = 
        "/bin/hosts_readFile.pl";
    private static final String SCRIPT_HOSTS_FILE_SAVE =
        "/bin/hosts_saveFile.pl";
    private static final String SCRIPT_RESTART_SERVICES = 
        "/opt/nec/nsadmin/bin/cachereset_script.sh";
    private static String home = System.getProperty("user.home");
    /**
     * 
     * @param nodeNo - the current node number
     * @return   - the string of the command result
     * @throws Exception 
     */
    public static String readHostsFile(int nodeNum)throws Exception{
        String []cmds = {CmdExecBase.CMD_SUDO,home+SCRIPT_HOSTS_FILE_GET};
        NSCmdResult result = CmdExecBase.execCmd(cmds,nodeNum);
        String[] results = result.getStdout();
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
     * 
     * @param nodeNom - the current node number
     *        content - the content of textarea
     * @return   - the command result
     * @throws Exception 
     */
    public static String saveHostsFile(int nodeNum,String content)throws Exception{
        String tempFile = NFSModel.createTempFile(nodeNum, content);
        String[] cmds =
        {   CmdExecBase.CMD_SUDO,
            System.getProperty("user.home") + SCRIPT_HOSTS_FILE_SAVE,
            tempFile };
        NSCmdResult result = CmdExecBase.execCmd(cmds,nodeNum);
        return result.getStdout()[0];
    }
    
 /**
  * 
  * @param nodeNo - the current node number
  * @return   - the command result
  * @throws Exception 
  */
 
 public static Vector getHostsInformation(int nodeNo) throws Exception {
     String[] cmds =
               { SUDO_COMMAND, SCRIPT_HOME + GET_HOSTS_SETTING_INFO_SCRIPT };     
     Vector infoVec = new Vector();
     NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
     String[] results = cmdResult.getStdout();
     for (int i = 0; i < results.length; i++) {
         infoVec.addElement(results[i]);      
     }
     return infoVec;
 }
 
 /**
  * 
  * @param applyNodeNo - the node number to execute.
  * @throws Exception
  */
 public static void apply(int applyNodeNo) throws Exception {      
     String[] cmds =
               { SUDO_COMMAND, SCRIPT_HOME + GET_HOSTS_SYNCHRONIZE_SCRIPT };
     NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, applyNodeNo);    
     
  }
  
 /**
  * restart services of specified node
  * @param execOnFriend  : whether to restart services of partner node
  * @param currentNodeNo : when execOnFriend is true, 
  *                        it means the current node user specified;
  *                        whe execOnFriend is false,
  *                        it means the node of which the services to restart
  * @throws Exception    :ERRCODE_SERVICERESTART_CURRENTNODE_ERROR
  *                       restart services of current node error;
  *                       ERRCODE_SERVICERESTART_PARTNERNODE_ERROR
  *                       restart services of partner node error.
  */
 public static void restartServices(boolean execOnFriend, int currentNodeNo) throws Exception{
     String[] cmds =
                 { SUDO_COMMAND, SCRIPT_RESTART_SERVICES };
     try {
         CmdExecBase.execCmd(cmds, currentNodeNo);
     } catch(NSException e){
         e.setErrorCode(ERRCODE_SERVICERESTART_CURRENTNODE_ERROR);
         throw e;
     }
     if (execOnFriend) {
         try {
             CmdExecBase.execCmd(cmds, 1-currentNodeNo);
         } catch(NSException e){
             e.setErrorCode(ERRCODE_SERVICERESTART_PARTNERNODE_ERROR);
             throw e;
         }
     } 
 }
 
} 