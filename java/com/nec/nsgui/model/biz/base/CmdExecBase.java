/*      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation. 
 */
package com.nec.nsgui.model.biz.base;
import java.io.BufferedReader;
import java.util.Vector;
import java.io.BufferedWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
public class CmdExecBase {
    private static final String cvsid =
        "@(#) $Id: CmdExecBase.java,v 1.16 2006/10/09 02:38:07 qim Exp $";
    private static final String SCRIPT_RSH_LOCAL =
        "/home/nsadmin/bin/cluster_local4rsh.pl";
    private static final String SCRIPT_CHECK_CLUSTER_STATUS =
        "/home/nsadmin/bin/cluster_checkStatus.pl";
    private static final String SCIRPT_IS_IN_SHARE_PARTITION
        = "/bin/log_isInSharePartition.pl";
    public static final String ERROR_CODE_FAILED_CONNECT_OTHER_NODE
        = "0x1000000A";
    public static final String CMD_SUDO = "sudo";

    public static final String YES = "yes";
    public static final String NO = "no";

    public static NSCmdResult execCmd(String[] cmds) throws Exception {
        return execCmd(cmds, null, true, YES);
    }
    public static NSCmdResult execCmd(String[] cmds, String[] inputs)
        throws Exception {
        return execCmd(cmds, inputs, true, YES);
    }
    public static NSCmdResult execCmd(String[] cmds, boolean errHandle)
        throws Exception {
        return execCmd(cmds, null, errHandle, YES);
    }

    public static NSCmdResult execCmd(
        String[] cmds,
        String[] inputs,
        boolean errHandle)
        throws Exception {
        return execCmd(cmds, inputs, errHandle, YES);
    }

    public static NSCmdResult execCmd(
        String[] cmds,
        String[] inputs,
        boolean errHandle,
        String checkClusterStatus)
        throws Exception {
        if (checkClusterStatus.equals(YES)) {
            //check the cluster status, if status is not normal, throw NSException;
            checkClusterStatus();
        }
        //get command output;
        NSCmdResult ret = localExecCmd(cmds, inputs);
        if (errHandle) {
            defaultErrHandle(ret); //if exit value is not 0, throw NSException;
        }
        return ret;
    }
    public static NSCmdResult execCmd(String[] cmds, int nodeNo)
        throws Exception {
        return execCmd(cmds, null, nodeNo, true, YES);
    }

    public static NSCmdResult execCmd(
        String[] cmds,
        int nodeNo,
        boolean errHandle)
        throws Exception {
        return execCmd(cmds, null, nodeNo, errHandle, YES);
    }

    public static NSCmdResult execCmd(
        String[] cmds,
        String[] inputs,
        int nodeNo)
        throws Exception {
        return execCmd(cmds, inputs, nodeNo, true, YES);
    }
    public static NSCmdResult execCmd(
        String[] cmds,
        String[] inputs,
        int nodeNo,
        boolean errHandle)
        throws Exception {
        return execCmd(cmds, inputs, nodeNo, errHandle, YES);
    }

    public static NSCmdResult execCmd(
        String[] cmds,
        int nodeNo,
        boolean errHandle,
        boolean doWhenMaintance)
        throws Exception {
        return execCmd(cmds, null, nodeNo, errHandle, doWhenMaintance);
    }
    public static NSCmdResult execCmd(
        String[] cmds,
        String[] inputs,
        int nodeNo,
        boolean errHandle,
        boolean doWhenMaintance)
        throws Exception {
        if (!doWhenMaintance) {
            return execCmd(cmds, inputs, nodeNo, errHandle);
        }
        String[] checkCmds = { CMD_SUDO, SCRIPT_CHECK_CLUSTER_STATUS };
        NSCmdResult checkRet = localExecCmd(checkCmds, null);
        int status = checkRet.getExitValue();
        NSCmdResult ret = null;
        if (status == 0) { // normal status, execute the command normally!
            ret = execCmd(cmds, inputs, nodeNo, errHandle, NO);
        } else if (status == 1) {
            // all two share filesystem has mount on local node,
            // so execute the command on local system.
            ret = execCmd(cmds, inputs, errHandle, NO);
        } else if (status == 2) {
            //all two share filesystem has mount on the other node,
            // so execute the command on other node.
            ret =
                rshExecCmd(
                    cmds,
                    inputs,
                    ClusterUtil.getInstance().getMyFriendIP());
            if (errHandle) {
                //if exit value is not 0, throw NSException;
                defaultErrHandle(ret);
            }
        } else {
            // the cluster status is error.
            defaultErrHandle(checkRet);
        }
        return ret;
    }

    public static NSCmdResult execCmd(
        String[] cmds,
        String[] inputs,
        int nodeNo,
        boolean errHandle,
        String checkClusterStatus)
        throws Exception {
        int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
        if (myNodeNo == nodeNo || myNodeNo == -1) {
            return execCmd(cmds, inputs, errHandle, checkClusterStatus);
        } else {
            //check the cluster status, if status is not normal, 
            //throw NSException;
            if (checkClusterStatus.equals(YES)) {
                checkClusterStatus();
            }
            NSCmdResult ret =
                rshExecCmd(
                    cmds,
                    inputs,
                    ClusterUtil.getInstance().getMyFriendIP());
            if (errHandle) {
                //if exit value is not 0, throw NSException;
                defaultErrHandle(ret);
            }
            return ret;
        }
    }

    public static NSCmdResult rshExecCmd(
        String[] cmds,
        String[] inputs,
        String targetIP)
        throws Exception {
        // if command will be excuted in other node, use the rsh script to excute!
        // because the rsh script need know whether there are parameters must be 
        // passed by stream, a parameter is append!
        // the rsh script's excuting format is as following:
        //      /home/nsadmin/bin/cluster_local4rsh.pl  {command array} 
        //          {the parameter's number to be passed by stream}
        String[] newCmds;
        int len = cmds.length;
        newCmds = new String[len + 3];
        newCmds[0] = SCRIPT_RSH_LOCAL;
        for (int i = 0; i < len; i++) {
            newCmds[i + 1] = cmds[i];
        }
        // append the parameter to indicate whether there are parameter must be 
        // passed by stream, a parameter is append!
        if (inputs == null || inputs.length == 0) {
            newCmds[len + 1] = "0";
        } else {
            newCmds[len + 1] = Integer.toString(inputs.length);
        }
        newCmds[len + 2] = targetIP;
        return localExecCmd(newCmds, inputs);
    }

    
    /*
     * parameters:  
     *      cmds     : command array to be excuted.
     *      inputs   : the command's parameters to be passed by stream. 
     * return : the command excute result object.
     */
    public static NSCmdResult localExecCmd(String[] cmds, String[] inputs)
        throws Exception {
        //write log info to trace.
        StringBuffer logStr = new StringBuffer("Execute command : ");
        for (int i = 0; i < cmds.length; i++) {
            logStr = logStr.append(cmds[i]).append(" ");
        }
        NSReporter.getInstance().report(
            NSReporter.INFO,
            logStr.toString().trim());
        NSCmdResult result = new NSCmdResult();
        //create the runtime object
        Runtime run = Runtime.getRuntime();
        //execute the linux command
        NSProcess proc = new NSProcess(run.exec(cmds));

        //while command 'cmds' executing , it may need some 'input' to continue.
        //this is useful when passwd needs to be tranfered to command line;
        if (inputs != null && inputs.length != 0) {
            OutputStreamWriter osw =
                new OutputStreamWriter(proc.getOutputStream());
            BufferedWriter bw = new BufferedWriter(osw);
            for (int i = 0; i < inputs.length; i++) {
                bw.write(inputs[i]);
                bw.newLine();
            }
            bw.flush();
            bw.close();
        }
        //modified by changhs , for J2SDK1.4.2's bug at 2005-08-23.
        //call the NSProcess's waitfor to read all the STDOUT and STDERR before;
        proc.waitFor();
        
        // get the STDOUT and STDERR of the command !
        String[] stdout = getCmdMsg(proc.getInputStream());
        String[] stderr = getCmdMsg(proc.getErrorStream());
        
        result.setExitValue(proc.exitValue());
        result.setStderr(stderr);
        result.setStdout(stdout);
        result.setCmds(cmds);
        return result;
    }


/*
     * parameters:  
     *      cmds     : command array to be excuted.
     *      inputs   : the command's parameters to be passed by stream. 
     * return : the command excute result object.
     */
    public static NSCmdResult localExecCmd(String[] cmds, String[] inputs, boolean errHandle)
        throws Exception {
        NSCmdResult NSResult = localExecCmd(cmds,inputs);
        if (errHandle) {
                //if exit value is not 0, throw NSException;
                defaultErrHandle(NSResult);
        }
        return NSResult;
    }


    /*
     * Add by zhangjun
     */
    public static NSException errHandle( NSCmdResult result,boolean throwExcep)throws Exception{
        if (result.getExitValue() == 0) {
            return null;
        }
        NSException e = getException(result);
        if( throwExcep ){
            throw e;
        }
        return e;
    }
    /*
     * modify by zhangjun
     */
    private static void defaultErrHandle(NSCmdResult result) throws Exception {
        if (result.getExitValue() == 0) {
            return;
        }
        NSException e = getException(result);
        throw e;
    }
    /*
     * Add by zhangjun
     * Modified by dengyp 
     */
    private static NSException getException(NSCmdResult result)
        throws Exception {
        NSException e =
            new NSException(
                Class.forName("com.nec.nsgui.model.biz.base.CmdExecBase")); 
        StringBuffer errorStr = new StringBuffer();
        String[] errors = result.getStderr();

        String errorCode = "";
        String detailErrorCode = "";
        if (errors.length > 0) {
            String prefix = "Error occured. (error_code=";
            String command_code_prefix = "command_code=";
            String suffix = ")";
            String errStr = errors[errors.length - 1];
            if (errStr.startsWith(prefix) && errStr.endsWith(suffix)) {
                String tmp[] =
                    errStr.substring(
                        prefix.length(),
                        errStr.length() - 1).split(
                        ",");
                if (tmp.length == 2
                    && tmp[1].startsWith(command_code_prefix)) {
                    errorCode = tmp[0];
                    detailErrorCode =
                        tmp[1].substring(
                            command_code_prefix.length(),
                            tmp[1].length());
                } else {
                    errorCode =
                        errStr.substring(prefix.length(), errStr.length() - 1);
                }
            }
        }
        int len = errors.length;
        for (int i = 0; i < len; i++) {
            errorStr.append(errors[i]).append("\n");
        }

        // set the property of the NSException.
        e.setDetail(errorStr);
        if (errorCode != null && !errorCode.equals("")) {
            e.setErrorCode(errorCode);
        }
        if (detailErrorCode != null && !detailErrorCode.equals("")) {            
           e.setCommandErrorCode(detailErrorCode);
        }
        e.setCmds(result.getCmds());
        e.setReportLevel(NSReporter.ERROR);

        NSReporter.getInstance().report(e);
        return e;
    }

    private static String[] getCmdMsg(InputStream stream) throws Exception {
        BufferedReader inputStr =
            new BufferedReader(new InputStreamReader(stream));
        String line = inputStr.readLine();
        StringBuffer outString = new StringBuffer();
        String[] result = {
        };
        Vector vec = new Vector();
        while (line != null) {
            vec.add(line);
            line = inputStr.readLine();
        }
        if (vec.size() > 0) {
            result =(String[])vec.toArray(result);
        }
        return result;
    }
    public static void checkClusterStatus() throws Exception {
        if (!ClusterUtil.getInstance().isCluster()) {
            return;
        }
        String[] checkCmds = { CMD_SUDO, SCRIPT_CHECK_CLUSTER_STATUS };
        NSCmdResult ret = localExecCmd(checkCmds, null);
        defaultErrHandle(ret);
        return;
    }
    
    public static NSCmdResult execCmdForce(
        String[] cmds,
        int nodeNo,
        boolean errHandle)
        throws Exception {
        return execCmdForce(cmds,null,nodeNo,errHandle);
    }
    
    public static NSCmdResult execCmdForce(
            String[] cmds,
            String[] inputs,
            int nodeNo,
            boolean errHandle)
            throws Exception {
            int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
            NSCmdResult ret = null;
            if (myNodeNo == nodeNo || myNodeNo == -1) {
                ret = localExecCmd(cmds, inputs);
            } else {
                ret =
                    rshExecCmd(
                        cmds,
                        inputs,
                        ClusterUtil.getInstance().getMyFriendIP());
            }
            try {
                defaultErrHandle(ret);
            } catch (NSException e) {
                if (e.getErrorCode() != null
                    && e.getErrorCode().equals("0x10000003")) {
                    // target node not active
                    // deal it as the maintaince status.
                    e.setErrorCode("0x10000006");
                    throw e;
                } else {
                    if (errHandle) { //if exit value is not 0, throw NSException;
                        throw e;
                    } else {
                        return ret;
                    }
                }
            }
            return ret;
        }

    public static NSCmdResult execCmdForce(String[] cmds, boolean errHandle)
        throws Exception {
        NSCmdResult ret = localExecCmd(cmds, null);
        if (errHandle) { //if exit value is not 0, throw NSException;
            defaultErrHandle(ret);
        }
        return ret;
    }
    
    public static NSCmdResult execCmdInServiceNode (
        String[] cmds, String[] inputs, int nodeNo,  boolean errHandle)
         throws Exception{
        
        String[] checkCmds = { CMD_SUDO, SCRIPT_CHECK_CLUSTER_STATUS };
        NSCmdResult result = localExecCmd(checkCmds, null);
        int exitValue = result.getExitValue();
        if(exitValue == 0){
            return execCmd(cmds, inputs, nodeNo, errHandle);
        }else if(exitValue == 1){
            return localExecCmd(cmds, inputs);
        }else if(exitValue == 2){
            return rshExecCmd (cmds, inputs, ClusterUtil.getInstance().getMyFriendIP());
        }else{
            defaultErrHandle(result);
            return null;
        }
        
    }
    
    //excute command on local.
    public static NSCmdResult execCmdInMaintain(String[] cmds, boolean errHandle)
        throws Exception{
        int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
        //execute command on local node.
        return execCmdInMaintain(cmds, myNodeNo, errHandle);
    }
    
    /* Excute the command on the specified node by groupNo.
     * if groupNo == local number, excute it on local
     * if groupNo != local number, excute it on other node by rsh
     * if exception is throwed because of error 0x10000006, execute the cmd on the local
     */
    public static NSCmdResult execCmdInMaintain(String[] cmds, int groupNo, boolean errHandle)
        throws Exception{
        NSCmdResult ret;
        try{
            //execute cmd according to groupNo.
            return execCmd(cmds, groupNo, errHandle, true);
        }catch (NSException ex) {
            if (ex.getErrorCode() != null && ex.getErrorCode().equals("0x10000003")) {
                return execCmdForce(cmds, errHandle);//execute local command.
            }else{
                throw ex;
            }
        }
    }
    /**
     * check whether the target file or command is in the share Partition     
     * @param nodeNo :
     * @param targetFile
     * @return "true" :if the file is behind those directories
     *         "false":else
     * @throws Exception
     */

    public static String isInSharePartition(int nodeNo, String targetFile)throws Exception {
        String[] cmds ={CmdExecBase.CMD_SUDO,
                    System.getProperty("user.home") + SCIRPT_IS_IN_SHARE_PARTITION,
                    targetFile};
        NSCmdResult cmdResult = CmdExecBase.execCmdInServiceNode(cmds, null, nodeNo, true);
        return cmdResult.getStdout()[0];
    }
    /**
     * if the target file or command is in the share partition,
     * the command will be executed on proper node,
     * for example, 
     *   when the cluster is normal or single node, the command will be executed on specified node
     *   when the cluster is takeover status, the command will be executed on service node
     *   when another node of the cluster is shutdown, the command will be executed on local 
     *     
     * if the target file or command isn't in the share partition,
     * the command will be executed according to cluster status,
     * for example, 
     *   when the cluster is normal or single node, the command will be executed on specified node
     *   when the cluster is takeover status, the command will be forced to execute on specified node
     *   when another node of the cluster is shutdown, the command expected to execute on active node 
     *                                                 will be executed on local 
     *                                             and the command expected to execute on shutdown node 
     *                                                 will throw NSException, with "0x1000000A" errorcode  
     * @param cmds      : the command to execute 
     * @param inputs    : parameter passed to command
     * @param nodeNo    : on which node the command executed
     * @param errHandle : whether to handle the exception
     * @param targetFile: the path of the target file or command related to the "cmds"
     * @return          : the resulte of command executed
     * @throws Exception
     */
    public static NSCmdResult execCmdBaseTargetFile (String[] cmds, String[] inputs, 
            int nodeNo, boolean errHandle, String targetFile) throws Exception{
        
        String myStatus = ClusterUtil.getMyStatus();
        if(myStatus.equals("0")){
            //sigle node or normal cluster
            return CmdExecBase.execCmd(cmds, inputs, nodeNo, errHandle);
        }else if(myStatus.equals("1")){
            //the status of machine is TakeOver
            if(isInSharePartition(nodeNo, targetFile).equals("true")){
                //need exec in the node on which share partition is working
                return CmdExecBase.execCmdInServiceNode (cmds, inputs, nodeNo, errHandle);
            }else{
                return CmdExecBase.execCmdForce (cmds, nodeNo, errHandle);
            }
        }else{
            //the status of machine maitaining (one node is not active)
            if(isInSharePartition(nodeNo, targetFile).equals("true")){
                //need exec in the node on which share partition is working
                return CmdExecBase.localExecCmd (cmds, inputs,true);
            }else{
                int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
                if(myNodeNo == nodeNo || myNodeNo == -1){
                    //need exec in local node
                    return CmdExecBase.localExecCmd (cmds, inputs,true);
                }else{
                    //need exec in remote node
                    NSException e = new NSException(Class.forName("com.nec.nsgui.model.biz.base.CmdExecBase"));
                    e.setErrorCode(ERROR_CODE_FAILED_CONNECT_OTHER_NODE);
                    e.setDetail("The target node(other node) is not active.");
                    throw e;
                }
            }
        }
    }
}
