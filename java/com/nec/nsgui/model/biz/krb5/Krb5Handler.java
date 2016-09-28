/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.krb5;

import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.nfs.NFSModel;

/**
 *handler for krb5
 */
public class Krb5Handler {
    private static final String cvsid = "@(#) $Id: Krb5Handler.java,v 1.1 2006/11/06 06:50:33 liy Exp $";
    private static final String KRB5_READFILE_PL = "/home/nsadmin/bin/krb5_readFile.pl";
    private static final String KRB5_WRITEFILE_PL = "/home/nsadmin/bin/krb5_writeFile.pl";
    
    
    /**
     * get the information of krb5.conf on the specified node or local node(when one node down),
     * and get the different flag when cluster
     * @param nodeNo -- specify the machine need to execute cmds
     * @return krb5Info -- include diffFlag and the info of krb5.conf 
     * @throws Exception
     */
    public static String[] readKrb5File(int nodeNo) throws Exception {
        String[] cmds = {"sudo", KRB5_READFILE_PL};
        NSCmdResult result = execCmdEvenMaintenance(cmds, nodeNo);
        String[] krb5Info = result.getStdout();
        return krb5Info;
    }
    
    /**
     * write content into /etc/krb5.conf
     * @param nodeNo  -- specify the machine need to execute cmds
     * @param content -- the content of textarea
     * @throws Exception
     */
    public static void writeKrb5File(int nodeNo, String content) throws Exception {
        String tmpFile = NFSModel.createTempFile(nodeNo, content);
        String[] cmds = {"sudo", KRB5_WRITEFILE_PL, tmpFile};
        CmdExecBase.execCmd(cmds, nodeNo);
    }

    
    /**
     * cmds can be executed even if cluster is maitaining (one node is not active)
     * 1. forcely execute the cmds in the specified node if both machine (cluster) are active, even if the 
     *    specified node is TakeOver(two nodes are both active);
     * 2. execute cmds in local node if the specified machine is maitaining (one node is not active)
     * @param cmds   -- command string need to be executed
     * @param nodeNo -- specify the machine need to execute cmds
     * @return NSCmdResult
     * @throws Exception
     */
    public static NSCmdResult execCmdEvenMaintenance(String[] cmds, int nodeNo) throws Exception{
        String myStatus = ClusterUtil.getMyStatus();
        if(myStatus.equals("0") || myStatus.equals("1")){
            // normal or system is maitaining(cluster and two nodes are both active)
            // forcely execute the cmds in the specified node
            return CmdExecBase.execCmdForce (cmds, nodeNo, true);
        }else{
            // cluster and  system is maitaining(one node down)
            // execute cmds in local node
            return CmdExecBase.localExecCmd (cmds, null, true);
        }
     }
}