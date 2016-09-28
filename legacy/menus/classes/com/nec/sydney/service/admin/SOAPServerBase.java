/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;


import java.util.*;
import java.io.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import com.nec.nsgui.model.biz.base.NSProcess;

public class SOAPServerBase implements NasConstants,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: SOAPServerBase.java,v 1.2302 2004/07/19 08:10:39 baiwq Exp $";

    public static void execCmd(String cmd, SoapResponse trans){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmd ,trans,handler,handler);
    }

    public static void execCmd(String cmd, String input,SoapResponse trans){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmd ,input,trans,handler,handler);
    }

    public static void execCmd(String cmd, SoapResponse trans,CmdHandler cmdHandler){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmd ,trans,cmdHandler,handler);
    }

    public static void execCmd(String cmd, SoapResponse trans,CmdErrHandler errHandler){
        CmdHandlerBase  handler = new CmdHandlerBase();
        execCmd( cmd ,trans,handler,errHandler);
    }

    public static void execCmd(String[] cmds, SoapResponse trans){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmds ,trans,handler,handler);
    }

    public static void execCmd(String[] cmds, SoapResponse trans,CmdHandler cmdHandler){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmds ,trans,cmdHandler,handler);
    }

    public static void execCmd(String[] cmds, SoapResponse trans,CmdErrHandler errHandler){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmds ,trans,handler,errHandler);
    }

    public static void execCmd(String cmd,SoapResponse trans,CmdHandler cmdHandler,CmdErrHandler errHandler){
        execCmd(cmd,null,trans,cmdHandler,errHandler);
    }

    public static void execCmd(String cmd,String input,SoapResponse trans,CmdHandler cmdHandler,CmdErrHandler errHandler){
      try{
        StringTokenizer token = new StringTokenizer (cmd);
        int tokenCnt = token.countTokens();
        String[] cmds = new String[tokenCnt];
        int i = 0;
        while (token.hasMoreTokens()){
            cmds[i] = token.nextToken();
            i++;
        }
        
        execCmd(cmds,input,trans,cmdHandler,errHandler);
      }catch(Exception e){
              trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage("Exec Cmd failed:" + cmd  + "\n" + e.toString()+SOAPServerBase.stack2string(e));        
            NSReporter.getInstance().report(NSReporter.ERROR,trans.getErrorMessage());
      }
    
    }

    public static void execCmd(String[] cmds,SoapResponse trans,CmdHandler cmdHandler,CmdErrHandler errHandler)
    {
        execCmd(cmds,null,trans,cmdHandler,errHandler);
    }

    public static void execCmd(String[] cmds,String input,SoapResponse trans,CmdHandler cmdHandler,CmdErrHandler errHandler){

        try{
            //create the runtime object
            Runtime run=Runtime.getRuntime();
            //execute the linux command
            NSProcess proc = new NSProcess(run.exec(cmds));
            //wait for the process object has terminated

            //while command 'cmds' executing , it may need some 'input' to continue.
			if (input != null) {
				OutputStreamWriter osw =new OutputStreamWriter(proc.getOutputStream());
				BufferedWriter bw = new BufferedWriter(osw);
				bw.write(input);
				bw.flush();
				bw.close();
			}

            proc.waitFor();
            if ( proc.exitValue() == 0){
                cmdHandler.cmdHandle(trans,proc,cmds);
            }else{
                errHandler.errHandle(trans,proc,cmds);
            }
        
        }catch(Exception e){
        
            StringBuffer cmdBuffer = new StringBuffer(100);
            for (int i = 0; i < cmds.length; i++){
                cmdBuffer.append(cmds[i]).append(" ");
            }
                
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage("Exec Cmd failed:" + cmdBuffer.toString()  + "\n"+e.toString()+SOAPServerBase.stack2string(e));        
            NSReporter.getInstance().report(NSReporter.ERROR,trans.getErrorMessage());
        }        

    }



    public static void execCmd(String[] cmds,SoapResponse trans,CmdHandler cmdHandler,CmdErrHandler errHandler,String[] inputs){

        try{
            //create the runtime object
            Runtime run=Runtime.getRuntime();
            //execute the linux command
            NSProcess proc = new NSProcess(run.exec(cmds));
            //wait for the process object has terminated

            //while command 'cmds' executing , it may need some 'input' to continue.
	    if (inputs != null && inputs.length != 0) {
		OutputStreamWriter osw =new OutputStreamWriter(proc.getOutputStream());
		BufferedWriter bw = new BufferedWriter(osw);
		for(int i = 0 ;i < inputs.length; i++){
		    bw.write(inputs[i]);
		    bw.newLine();
		}
		bw.flush();
		bw.close();
	    }

            proc.waitFor();
            if ( proc.exitValue() == 0){
                cmdHandler.cmdHandle(trans,proc,cmds);
            }else{
                errHandler.errHandle(trans,proc,cmds);
            }
        
        }catch(Exception e){
        
            StringBuffer cmdBuffer = new StringBuffer(100);
            for (int i = 0; i < cmds.length; i++){
                cmdBuffer.append(cmds[i]).append(" ");
            }
                
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage("Exec Cmd failed:" + cmdBuffer.toString()  + "\n"+e.toString()+SOAPServerBase.stack2string(e));        
            NSReporter.getInstance().report(NSReporter.ERROR,trans.getErrorMessage());
        }        

    }
    public static void execCmd(String[] cmds, SoapResponse trans,CmdHandler cmdHandler,String[] inputs){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmds , trans,cmdHandler,handler,inputs);
    }

    public static void execCmd(String[] cmds, SoapResponse trans,CmdErrHandler errHandler,String[] inputs){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmds, trans, handler, errHandler, inputs);
    }    
    public static void execCmd(String[] cmds, SoapResponse trans, String[]inputs){
        CmdHandlerBase handler = new CmdHandlerBase();
        execCmd( cmds ,trans,handler,handler,inputs);
    }

    public static String getCmdErrMsg(InputStream in)throws Exception
    {
        BufferedReader inputStr= new BufferedReader(new InputStreamReader(in));
        String line=inputStr.readLine();
        StringBuffer outputString = new StringBuffer();
        while(line!=null)
        {
            outputString.append(line);
            line=inputStr.readLine();
        }
        return outputString.toString();
    }

    public static String stack2string(Exception e)
    {
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            return "<br>"+sw.toString();
        }
          catch(Exception e2) {
            return "bad stack2string";
        }
    }
}