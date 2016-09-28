/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.csar;

import com.nec.nsgui.action.csar.CsarConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;

public class CsarHandler {
    private static final String cvsid = "@(#) $Id: CsarHandler.java,v 1.3 2008/04/24 01:15:34 fengmh Exp $"; 
    
    public static NSCmdResult collectOnOneNode(String nodeCollect, String infoType)throws Exception{
        String[] cmds = {CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + CsarConst.SCRIPT_CSAR_LOG_GET_ONE,
                nodeCollect, infoType};
        NSCmdResult result=null;
      
        result = CmdExecBase.execCmdForce(cmds, true);        
        return result;
        
    }
    
    public static NSCmdResult collectOnBothNode(String infoType)throws Exception{
        String[] cmds = {CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + CsarConst.SCRIPT_CSAR_LOG_GET_BOTH,
                infoType};
        NSCmdResult result=null; 
       
        result = CmdExecBase.execCmdForce(cmds, true);  
        return result;
       
    }
    
    public static String getFIPNodeNum() throws Exception{
    	String[] cmds = {CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + CsarConst.SCRIPT_CSAR_GET_FIP_NODE};
    	NSCmdResult result= CmdExecBase.execCmdForce(cmds, true);  
        return result.getStdout()[0];
    }
}