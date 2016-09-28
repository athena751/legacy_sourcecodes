/*
 *      Copyright (c) 2001-2006 NEC Corporation
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
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.service.admin.*;


public class DirQuotaSOAPServer implements NSExceptionMsg,NasConstants{

    private static final String     cvsid =
        "@(#) $Id: DirQuotaSOAPServer.java,v 1.2303 2006/02/20 00:36:34 zhangjun Exp $";

    private static final String    SCRIPT_ADD="dirquota_add.pl";
    private static final String    SCRIPT_ALLOW="dirquota_allow.pl";
    private static final String    SCRIPT_LIST="dirquota_list.pl";
    private static final String    SCRIPT_GET_DATASET_LIST_ALL="dirquota_getdatasetlist.pl";
    private static final String    SCRIPT_DELDATASET="dirquota_deldataset.pl";
        
    public SoapResponse addDataset(String path, String filesystem) throws Exception{

        SoapResponse trans=new SoapResponse();
        String home  =  System.getProperty("user.home");
        String[] cmds = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_ADD,path,filesystem};
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
           public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(true);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1] +"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
           }
        };
        SOAPServerBase.execCmd(cmds,trans,cmdErrHandler);
        return trans;
    }

    public SoapRpsBoolean getAllowAdd(String path) throws Exception{

        SoapRpsBoolean trans=new SoapRpsBoolean();
        String home  =  System.getProperty("user.home");

        String[] cmd={SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_ALLOW,path};

        CmdHandler cmdHandler = new CmdHandler(){
           public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsBoolean info=(SoapRpsBoolean)rps;
                InputStreamReader read=new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf=new BufferedReader(read);
                String allow=readbuf.readLine();
                info.setSuccessful(true);
                if(allow.equals("true")){
                    info.setBoolean(true);
                }else{
                    info.setBoolean(false);
                }
            }
        };

        SOAPServerBase.execCmd(cmd,trans,cmdHandler);
        return trans;
    }

    public SoapRpsVector getDirList(String path) throws Exception{
        SoapRpsVector infoList=new SoapRpsVector();
        String home  =  System.getProperty("user.home");
        //String cmd=SUDO_COMMAND+" "+home+SCRIPT_DIR+SCRIPT_LIST+ " "+path;
        String[] cmd={SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_LIST,path};
        
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsVector infoList=(SoapRpsVector)rps;
                InputStreamReader read=new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf=new BufferedReader(read);
                Vector v=new Vector();                
                String line = readbuf.readLine();

                while(line!=null){
                    v.add(line);
                    line=readbuf.readLine();
                }

                infoList.setVector(v);
            }
        };

        SOAPServerBase.execCmd(cmd,infoList,cmdHandler);
        return infoList;
    }    
    public SoapResponse deleteDataset(String hexDataset)
    {
        SoapResponse transObject = new SoapResponse ();
        
        String home = System.getProperty("user.home");
        //String cmd = COMMAND_SUDO+" "+home+ SCRIPT_DIR+SCRIPT_DELDATASET+" "+hexDataset;
        String[] cmd ={COMMAND_SUDO,home + SCRIPT_DIR+SCRIPT_DELDATASET,hexDataset};
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(true);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1] +"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };
        
        SOAPServerBase.execCmd(cmd,transObject,cmdErrHandler);
        return transObject;
    }
}

