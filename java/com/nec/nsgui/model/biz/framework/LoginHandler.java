/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.framework.FrameworkConst;

/**
 *
 */
public class LoginHandler implements FrameworkConst {
    private static final String cvsid =
            "@(#) $Id: LoginHandler.java,v 1.2 2009/04/10 09:20:31 liul Exp $";
    
    public static final String CLUSTER_MAJOR_SH = "/home/nsadmin/bin/cluster_major_eth0.sh";
    public static final String PROPERTY_SH = "/home/nsadmin/bin/nsgui_property.sh";
    public static final String HOSTNAME_BIN = "/bin/hostname";
    public static final String CMD_CHECK_PRODUCT_NAME = "/home/nsadmin/bin/nsgui_chkProductName.pl";
    public static final int MAX_NSVIEW = 8;
    
    private static LoginHandler   _instance = null;
    public static LoginHandler    getInstance() {
        if (_instance == null) {
            _instance = new LoginHandler();
        }
        return _instance;
    }
    
    /**
     * @return
     * @throws Exception
     */
    public String getHostname() throws Exception{
        String[] cmds = {HOSTNAME_BIN};
        
        NSCmdResult cmdResult = getCmdResult(cmds);
        return (cmdResult.getStdout().length > 0)? cmdResult.getStdout()[0] : null;
    }
    
    /**read the given file with the given charset
     *   
     * @param fileName 
     *        file name
     * @param charsetName 
     *        The name of a supported charset 
     * @return  StringBuffer file's content  null : file not exist or file's length is 0
     */
    public StringBuffer getFileContent(String fileName , String charsetName){
        StringBuffer sb = new StringBuffer();
        File file  = new File(fileName);
        if(file.exists() && file.length()!=0){
            try{
               InputStreamReader is = new InputStreamReader(new FileInputStream(file), charsetName);
               int bt = is.read();
               while (bt != -1){
                   sb.append((char)bt);
                   bt = is.read();
               }
               is.close();
               return sb;
           }catch(IOException ex){
               //do nothing
           }
        }
        return null;    
    }
    
    /**
     * @param myAddr : url's ip
     * @return exitValue + "#" + fip : fip is manager network ip and on the fip node
     * @throws Exception
     */
    public String getUrlNodeFip(String myAddr) throws Exception{
        int boxnum = 2;
        String fip = myAddr;
        if(myAddr != null){
            boxnum = 4;
        }
        String[] adminGUICOMM = new String[boxnum];
        adminGUICOMM[0] = "sudo";
        adminGUICOMM[1] = CLUSTER_MAJOR_SH;
        if(myAddr != null){
            adminGUICOMM[2] = "-i";
            adminGUICOMM[3] = myAddr;
        }
        //admin node check
        boolean adminNode = false;
        NSCmdResult ns = getCmdResult(adminGUICOMM);
        
        if(ns.getExitValue() != 0){
            fip = ns.getStdout()[0]; // won't be null
        }
        
        return ns.getExitValue() +"#"+fip;
    }
    
    /**
     * @return
     */
    public int getNsviewMaxSession(){
        int max = MAX_NSVIEW;
        
        String[] cmds = {"sudo" ,PROPERTY_SH ,"login", "MAX_REFERENCE_CONNECTIONS"};
        try{
            NSCmdResult ns = getCmdResult(cmds);
            if(ns.getStdout().length != 0){
                int maxInFile = Integer.parseInt(ns.getStdout()[0]);
                max = (maxInFile <= 0) ? max : maxInFile;
                max = max >16 ? 16 : max;
            }
        }catch(Exception e){}
        return max;
    }
    
    /**
     * @param cmds
     * @return
     * @throws Exception
     */
    protected NSCmdResult getCmdResult(String[] cmds) throws Exception {
        NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null);
        return cmdResult;
    }
    
    public String[] checkProductName() throws Exception{
        String[] cmds = {"sudo" ,CMD_CHECK_PRODUCT_NAME};
        NSCmdResult ns = getCmdResult(cmds);
        return ns.getStdout();
    }
}
