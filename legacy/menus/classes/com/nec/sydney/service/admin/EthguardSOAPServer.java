    /*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;

import java.io.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.atom.admin.ethguard.*;
import com.nec.nsgui.model.biz.base.NSProcess;

public class EthguardSOAPServer implements EthguardConstants,NasConstants,NSExceptionMsg{

    private static final String     cvsid = "@(#) $Id: EthguardSOAPServer.java,v 1.2304 2007/04/25 02:38:41 chenbc Exp $";
    private static final String     CMD_START_LOG = "sudo /etc/rc.d/init.d/ethguard start_log";
    private static final String     CMD_STOP_LOG = "sudo /etc/rc.d/init.d/ethguard stop_log";
    private static final String     LOG_START = "start";
    private static final String     SCRIPT_SET_AVAILABLE = "/bin/ethguard_setAvailable.pl";
    private static final String     SCRIPT_SET_DENY = "/bin/ethguard_setDeny.pl";
    private static final String     SCRIPT_GET_INFO = "/bin/ethguard_getInfo.pl";
    private static final String     SCRIPT_GET_ADMIN_IP = "/bin/ethguard_getAdminIP.pl";
    private static final String     SCRIPT_GET_MY_FRIEND = "/bin/getMyFriend.sh"; //added by chenbc, 2007-04-25

    public SoapResponse setAvailable() throws Exception{
        SoapResponse trans = new SoapResponse();
        String cmds[]      = new String[2];
        cmds[0]            = SUDO_COMMAND;
        cmds[1]            = System.getProperty("user.home") + SCRIPT_SET_AVAILABLE;
        SOAPServerBase.execCmd(cmds,trans);
        return trans;
    }
    
    public SoapResponse setDeny() throws Exception{
        SoapResponse trans  = new SoapResponse();
        String cmds[]       = new String[2];
        cmds[0]             = SUDO_COMMAND;
        cmds[1]             = System.getProperty("user.home") + SCRIPT_SET_DENY;
        SOAPServerBase.execCmd(cmds,trans);
        return trans;
    }
    
    public EthguardInfo getEthguardInfo() throws Exception{
        EthguardInfo trans = new EthguardInfo();
        String cmds[]       = new String[2];
        cmds[0]             = SUDO_COMMAND;
        cmds[1]             = System.getProperty("user.home") + SCRIPT_GET_INFO;
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                EthguardInfo info = (EthguardInfo)rps;
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf = new BufferedReader(read);
                info.setLoggingStatus(readbuf.readLine().trim());
                info.setConnectionLimits(readbuf.readLine().trim());
                info.setSuccessful(true);                               
            }
        };
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }


    public SoapRpsInteger setLogStatus(String operation) throws Exception{
        
        SoapRpsInteger trans = new SoapRpsInteger();
        String cmd ="";
       try{ 
            
            //judge which command is be executed.
            if (operation.equals(LOG_START)){
                cmd = CMD_START_LOG;
            }else{
                cmd = CMD_STOP_LOG;
            }
            //execute the command
            Runtime run=Runtime.getRuntime();
            NSProcess proc = new NSProcess(run.exec(cmd));
            proc.waitFor();
            trans.setInt(proc.exitValue());
            trans.setSuccessful(true);
            return trans;

          }catch (Exception e){
            trans.setSuccessful(false);
            trans.setErrorCode(NAS_EXCEP_NO_JAVA_EXCEPTION_FAILED);
            trans.setErrorMessage("Exec Cmd failed:" + cmd + "\n"+e.toString()+SOAPServerBase.stack2string(e));        
            NSReporter.getInstance().report(NSReporter.ERROR,trans.getErrorMessage());
            return trans;
          }
          
    }

    public SoapRpsString getAdminIp(String isCluster)throws Exception{
        
        SoapRpsString transObject = new SoapRpsString();
        // get IP from ifcfg-eth0 and ifcfg-eth0.z
        String cmds[]       = new String[3];
        cmds[0]             = SUDO_COMMAND;
        cmds[1]             = System.getProperty("user.home") + SCRIPT_GET_ADMIN_IP;
        cmds[2]             = isCluster;
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString transStr = (SoapRpsString)trans;
                BufferedReader buf = 
                    new BufferedReader(new InputStreamReader(
                                                    proc.getInputStream())
                                      );
                String result = buf.readLine();
                transStr.setString(result);
                transStr.setSuccessful(true);
            }//end cmdHandle
        };//end of new CmdHandler

        SOAPServerBase.execCmd(cmds,transObject,cmdHandler);                        
        return transObject;
    }
    
    //below, copied from nic, for soap-clean update, updated by chenbc on 2007-04-25
    public SoapRpsString getIpSanFriend(String target) throws Exception{
        SoapRpsString transObject=new SoapRpsString();
        String home = System.getProperty("user.home");
        String cmd[] = {SUDO_COMMAND,
                        home + SCRIPT_GET_MY_FRIEND,
                        target
                        };

        return getOneLineString(cmd,transObject);
    }

    private SoapRpsString getOneLineString(String[] cmd, SoapRpsString transObject) throws Exception{
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString transStr = (SoapRpsString)trans;
                BufferedReader buf = 
                    new BufferedReader(new InputStreamReader(
                                                    proc.getInputStream())
                                      );
                String result = buf.readLine();
                transStr.setString(result);
                transStr.setSuccessful(true);
            }
        };
        
        SOAPServerBase.execCmd(cmd,transObject,cmdHandler);                        
        return transObject;
    }
}