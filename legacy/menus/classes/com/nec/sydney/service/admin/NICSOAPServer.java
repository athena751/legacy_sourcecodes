/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.

 *  Revision History
 *  Nas-Defect-354 2002/07/29 Duan Append the process for MTU
 */

package com.nec.sydney.service.admin;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.net.soap.*;
import java.io.*;

public class NICSOAPServer implements NasConstants,NSExceptionMsg{


    private static final String     cvsid = "@(#) $Id: NICSOAPServer.java,v 1.2303 2005/09/06 06:37:32 fengmh Exp $";

    private static final String     SCRIPT_GET_MY_FRIEND            = "getMyFriend.sh";

    public SoapRpsString getIpSanFriend(String target) throws Exception{
        SoapRpsString transObject=new SoapRpsString();
        String home = System.getProperty("user.home");
        String cmd[] = {SUDO_COMMAND,
                        home + SCRIPT_DIR + SCRIPT_GET_MY_FRIEND,
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
}// End Of the class SOAPServer;