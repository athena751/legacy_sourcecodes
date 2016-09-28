/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


package com.nec.sydney.service.admin;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.net.soap.*;

public class CmdHandlerBase implements CmdHandler,CmdErrHandler,NSExceptionMsg{

   private static final String     cvsid = "@(#) $Id: CmdHandlerBase.java,v 1.2300 2003/11/24 00:54:58 nsadmin Exp $";

    // when using cmdExitCodes=new int[][]={{command exit code, error code }}
    private int[][] cmdExitCodes;  
    private int defaultErrorCode;
    private static final int[][] array={{0,0}};
	
    public CmdHandlerBase(int[][] cmdExitCodes,int defaultErrorCode){
		this.cmdExitCodes=cmdExitCodes;
		this.defaultErrorCode=defaultErrorCode;
    }
							
    public CmdHandlerBase(){
        this(array,NAS_EXCEP_NO_CMD_FAILED);
    }
    
    public CmdHandlerBase(int defaultErrorCode){
        this(array,defaultErrorCode);  
    }
	
    public CmdHandlerBase(int[][] cmdExitCodes){
       this(cmdExitCodes,NAS_EXCEP_NO_CMD_FAILED);
    }

    public void setErrorCode(int errCode){
        defaultErrorCode=errCode;
        this.cmdExitCodes=array;
    }
	
    public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
        trans.setSuccessful(true);
    }

    public void errHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
       
        int exitCode=proc.exitValue();
        trans.setSuccessful(false);
        if (exitCode!=0)
        {
            trans.setErrorCode(getExceptionCode(exitCode));
            setCmdErrorMessage(trans,proc,cmds);
        }
    }
     
    private int getExceptionCode(int exitcode)throws Exception{
        for(int i=0;i<cmdExitCodes.length; i++){
            if (exitcode==cmdExitCodes[i][0]){
                return cmdExitCodes[i][1];
            }
        }
        return defaultErrorCode;
    }

    public static void setCmdErrorMessage(SoapResponse trans,Process proc,String[] cmds)throws Exception{
        StringBuffer cmdBuffer = new StringBuffer(100);

        for (int i = 0; i < cmds.length; i++){
            cmdBuffer.append(cmds[i]).append(" ");
        }

        trans.setErrorMessage("Exec command failed! Command = "+ cmdBuffer.toString()+"\n"+SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
        NSReporter.getInstance().report(NSReporter.ERROR,trans.getErrorMessage());

    }

}
