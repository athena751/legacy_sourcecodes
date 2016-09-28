/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.StringTokenizer;
import java.util.Vector;

import com.nec.nsgui.model.biz.base.NSProcess;
import com.nec.sydney.atom.admin.base.NSExceptionMsg;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.atom.admin.base.SoapRpsString;
import com.nec.sydney.atom.admin.base.SoapRpsVector;
import com.nec.sydney.atom.admin.quota.QuotaInfo;
import com.nec.sydney.framework.NSException;
import com.nec.sydney.framework.NSReporter;
import com.nec.sydney.net.soap.SoapResponse;

public class QuotaSOAPServer implements NasConstants,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: QuotaSOAPServer.java,v 1.2309 2006/12/08 02:51:49 zhangjun Exp $";

    private static final String     NAS_EXCEP_MSG_QUOTA_GETNAMEBYID_CMD = "get name failed!";
    private static final String     USER    = "-u";
    private static final String     GROUP   = "-g";
    private static final String     DIR     = "-d";
    
    public QuotaSOAPServer() {}

    public SoapResponse setQuota(String filesystem, QuotaInfo quotaInfo, String flagUser, boolean isDirQuota){
        SoapResponse transObject = new SoapResponse ();
        String idnumber = quotaInfo.getID();
        String blocksoft = quotaInfo.getBlockSoftLimit();
        String blockhard = quotaInfo.getBlockHardLimit();
        String filesoft = quotaInfo.getFileSoftLimit();
        String filehard = quotaInfo.getFileHardLimit();

        String[] cmds = new String[10];
        String home = System.getProperty("user.home");
        
        cmds[0] = COMMAND_SUDO;   
        cmds[1] = home + SCRIPT_DIR + SCRIPT_SETQUOTA;
        cmds[2] = COMMAND_SETREPORT;
              
        if (flagUser.equals("true")){
            cmds[3] = USER;
        } else if (flagUser.equals("false")){
            cmds[3] = GROUP;
        } else if (flagUser.equals("dir")){
            cmds[3] = DIR;
            idnumber = "";
        } else {
            transObject.setSuccessful(false);
            transObject.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            transObject.setErrorMessage("Invalid flagUsed="+flagUser);
            return transObject; 
        }
        
        cmds[4] = idnumber;
        cmds[5] = blocksoft;
        cmds[6] = blockhard;
        cmds[7] = filesoft;
        cmds[8] = filehard;
        cmds[9] = filesystem;
        
        SOAPServerBase.execCmd(cmds,transObject);
        return transObject;
    }    

    public SoapResponse startQuota(String filesystem, boolean isDirQuota){
        SoapResponse transObject = new SoapResponse ();
        String home = System.getProperty("user.home");
        String command = isDirQuota?COMMAND_OPTION_DIRQUOTA:COMMAND_OPTION_QUOTA;
        String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_CHANGEQUOTA,COMMAND_ON,command,COMMAND_OPTION_ENFORCE,filesystem};
        SOAPServerBase.execCmd(cmd,transObject);
        return transObject;
    }
    
    public SoapResponse stopQuota(String filesystem, boolean isDirQuota){
        SoapResponse transObject = new SoapResponse ();
        String home = System.getProperty("user.home");
        String command = isDirQuota?COMMAND_OPTION_DIRQUOTA:COMMAND_OPTION_QUOTA;
        String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_CHANGEQUOTA,COMMAND_OFF,command,COMMAND_OPTION_ENFORCE,filesystem};
        SOAPServerBase.execCmd(cmd,transObject);
        return transObject;
    }
    
    public SoapResponse setGraceTime(String userblock, String userfile, String groupblock, String groupfile, String dirblock, String dirfile,String filesystem, boolean isDirQuota){
        SoapResponse transObject = new SoapResponse();
        String home = System.getProperty("user.home");
        String[] cmdUser    = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_SETQUOTA_GRACETIME,COMMAND_SETREPORT,COMMAND_SETGRACETIME_USER,userblock,userfile,filesystem};
        String[] cmdGroup   = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_SETQUOTA_GRACETIME,COMMAND_SETREPORT,COMMAND_SETGRACETIME_GROUP,groupblock,groupfile,filesystem};
        String[] cmdDir     = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_SETQUOTA_GRACETIME,COMMAND_SETREPORT,COMMAND_SETGRACETIME_DIR,dirblock,dirfile,filesystem};
        
        SOAPServerBase.execCmd(cmdUser,transObject);
        if( transObject.isSuccessful() ){
             SOAPServerBase.execCmd(cmdGroup,transObject);
        }
        if(isDirQuota && transObject.isSuccessful()){
             SOAPServerBase.execCmd(cmdDir,transObject);      
        }
        return transObject;        
    }

    class GetReportCmdHandler implements CmdHandler{
        private String type,filesystem,commandid;    
        public GetReportCmdHandler(String filesystem,String commandid,String type){
            this.filesystem = filesystem;
            this.commandid = commandid;
            this.type = type;
        }

        public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
            SoapRpsVector transRpsVec = (SoapRpsVector) trans;
            transRpsVec.setSuccessful(true);
            
            Vector reports = new Vector();
            BufferedReader readbuf = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = readbuf.readLine();
            //StringBuffer sb = new StringBuffer(1024*1024*2);
            StringBuffer sb = new StringBuffer();
            sb.append(line).append("\n");
            while(line!=null){
              
                sb.append(line).append("\n");
                line = readbuf.readLine();   
            }     
            reports.add(sb.toString());
            transRpsVec.setVector(reports);
        }        

    } //end of GetReportCmdHandler

    public SoapRpsString getOneReport(String filesystem, String commandid, String $ID){
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString tranStr = (SoapRpsString)trans;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String limitInfo = buf.readLine();
                tranStr.setString(limitInfo);
                tranStr.setSuccessful(true); 
            }            
         };
         
         SoapRpsString transObject = new SoapRpsString();
         String option;
         
         if(commandid.equals("user")){
             option = COMMAND_GET_OPTION_USER;  
         }else  if(commandid.equals("group")){
             option = COMMAND_GET_OPTION_GROUP;
         } else if(commandid.equals("dir")){
             option = COMMAND_GET_OPTION_DIR;
         }else{
             transObject.setSuccessful(false);
             transObject.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
             transObject.setErrorMessage("Invalid commandid="+commandid);
             return transObject;    
         }
         
         String home = System.getProperty("user.home");
         String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_GETONEREPORT,COMMAND_GETREPORT,option,filesystem,$ID};
         SOAPServerBase.execCmd(cmd,transObject,cmdHandler);
         return transObject;
    }
    
    public SoapRpsVector getReport(String filesystem, String commandid, String type,
                                   String fsType, String limit, String displayControl,boolean isDirQuota){
        SoapRpsVector transObject = new SoapRpsVector();
        String option;
        String trans_switch;
                
        if(commandid.equals("user")){
        	option = COMMAND_GET_OPTION_USER;  
            trans_switch = fsType.equals(NasConstants.FILETYPE_NT)?"p-":"u-"; 
        }else  if(commandid.equals("group")){
        	option = COMMAND_GET_OPTION_GROUP;
            trans_switch = fsType.equals(NasConstants.FILETYPE_NT)?"p-":"g-";
        } else if(commandid.equals("dir")){
        	option = COMMAND_GET_OPTION_DIR;
            trans_switch = fsType.equals(NasConstants.FILETYPE_NT)?"p-":"u-";
        }else{
            transObject.setSuccessful(false);
            transObject.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
               transObject.setErrorMessage("Invalid commandid="+commandid);
            return transObject;    
        }
        
        GetReportCmdHandler cmdHandler = new GetReportCmdHandler(filesystem,commandid,type);
        String home = System.getProperty("user.home");
        String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_GETREPORT,COMMAND_GETREPORT,option,filesystem,type,trans_switch,limit,displayControl};
        SOAPServerBase.execCmd(cmd,transObject,cmdHandler);
        return transObject;
    }
    
    public SoapRpsString getQuotaStatus(String filesystem){
        return getQuotaStatus(filesystem, false);
    }
    public SoapRpsString getQuotaStatus(String filesystem, boolean isDirQuota) {
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString transStr = (SoapRpsString) trans;
                transStr.setSuccessful(true);
                   BufferedReader readbuf = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                   
                 String line = readbuf.readLine();
                while(line!=null){
                    if ((line.trim()).startsWith(REP_STATUS_START))
                        break;
                    line = readbuf.readLine();    
                }//end of while    
                
                line = readbuf.readLine();
                StringTokenizer tokens = new StringTokenizer(line,":");
                if (tokens.countTokens() != 3)/*command output error*/
                {
                    transStr.setSuccessful(false);
                    transStr.setErrorMessage("command output is error: "+line);
                    NSReporter.getInstance().report(NSReporter.ERROR,transStr.getErrorMessage());
                    return;                
                }
                
                tokens.nextToken();
                tokens.nextToken();
                transStr.setString(tokens.nextToken().trim());
                if ( !(transStr.getString().equals(REPQUOTA_STATUS_ON) ) &&
                     !(transStr.getString().equals(REPQUOTA_STATUS_OFF)) )
                {
                    transStr.setSuccessful(false);
                    transStr.setErrorMessage("command output is error: "+line);
                    NSReporter.getInstance().report(NSReporter.ERROR,transStr.getErrorMessage());
                    return;
                }

                transStr.setSuccessful(true);
            } //end of cmdHandle            
        };
        
        SoapRpsString transObject = new SoapRpsString();
        String home = System.getProperty("user.home");
        
        if (isDirQuota){
            String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_GETREPORT,COMMAND_GETREPORT,COMMAND_GET_OPTION_USER_DIR,filesystem};
            SOAPServerBase.execCmd(cmd,transObject,cmdHandler);
        } else{
            String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIR+SCRIPT_GETREPORT,COMMAND_GETREPORT,COMMAND_GET_OPTION_USER,filesystem};
            SOAPServerBase.execCmd(cmd,transObject,cmdHandler);
        }
        return transObject;
    }

    public SoapRpsString getFsType(String path)
    {
        SoapRpsString trans = new SoapRpsString();
        String home = System.getProperty("user.home");
        String cmd = COMMAND_SUDO + " "  + home + SCRIPT_DIR + SCRIPT_GET_FS_TYPE
            + " " +path;
             
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString tranStr = (SoapRpsString)trans;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String fsType = buf.readLine();
                tranStr.setString(fsType);
                tranStr.setSuccessful(true); 
            }            
        };
        
        SOAPServerBase.execCmd(cmd,trans,cmdHandler);
        return trans;
    }//end of getFsType

    public SoapRpsString getIDFromName(String name,String path,String flag)
    {//flag: "user"--UID "group"--GID
        
        SoapRpsString trans = new SoapRpsString();
        String idSwitch="";
        int resultNo =0;

        SoapRpsString fsType=getFsType(path);
        if (!fsType.isSuccessful())    {
            return fsType;//"fsType" contains error reason
        }

        if (flag.equals(FS_UID_FLAG)){
            idSwitch="-u";
        }else if (flag.equals(FS_GID_FLAG)){
            idSwitch="-g";
        }else{
            trans.setSuccessful(false);    
            trans.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            trans.setErrorMessage("Invalid flag="+flag);
            return trans;
        }
        
        String home = System.getProperty("user.home");
        String[] cmd = {COMMAND_SUDO,
                        home + SCRIPT_DIR + SCRIPT_GET_ID_BY_NAME,
                        idSwitch,
                        name.trim(),
                        path,
                        fsType.getString()
                        };
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
            
                SoapRpsString transStr = (SoapRpsString)trans;            
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String line = buf.readLine();
            //2002/5/8 lhy del    String id = line;
                String id="";//2002/5/8 lhy add
                int err = -1;
                
                /*modified by hujing 7/2/2002*/
                while (line != null){
                    if (line.startsWith(IMS_CTL_ERR_START)){
                        break;
                    }
                    if(line.startsWith("result:")){
                    	StringTokenizer token = new StringTokenizer(line);
                    	token.nextToken();
                    	id=token.nextToken();
                    	id.trim();
                        err = 0;
                        break;
                    }
                    line=buf.readLine();
                }// end of while
            //add end:2002/5/8 lhy add
            /*modify end. hujing 7/2/2002*/   
                if (err != 0){
                    transStr.setString(line);
                }else{
                    transStr.setString(id);
                }
                
                transStr.setSuccessful(true); 
            }//end of cmdHandle
        }; //end of new CmdHandler

        SOAPServerBase.execCmd(cmd,trans,cmdHandler);
        return trans;            

    }//end of getIdFromName

    private String getNameFromID(String Id,String path,String flag) throws Exception
    {//flag: "user"--UID "group"--GID
        
        String idSwitch="";
        int resultNo =0;

        SoapRpsString fsType=getFsType(path);
        if (!fsType.isSuccessful())
        {
            NSException ex = new NSException(this.getClass(), "getFsType failed!");
            ex.setDetail(fsType.getErrorMessage());
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_QUOTA_GETFSTYPE_CMD);
            NSReporter.getInstance().report(ex);
            throw ex;
        }

        if (flag.trim().equalsIgnoreCase("user")){
            idSwitch="-u";
        }else if (flag.trim().equalsIgnoreCase("group")){
            idSwitch="-g";
        }else{
            NSException ex = new NSException(this.getClass(), "Invlid flag");
            ex.setDetail("Invlid flag="+flag);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_INVALID_PARAMETER);
            NSReporter.getInstance().report(ex);
            throw ex;
        }

        String home = System.getProperty("user.home");
        String cmd = COMMAND_SUDO + " "  + home + SCRIPT_DIR + SCRIPT_GET_NAME_BY_ID
            + " " +idSwitch+" "+Id+" "+path+" "+fsType.getString();
        Runtime    run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(cmd));
        proc.waitFor();
        resultNo=proc.exitValue();
        if ( resultNo!= 0){
            BufferedReader buf=new BufferedReader(new InputStreamReader(proc.getErrorStream()));
            StringBuffer errMsg =new StringBuffer(NAS_EXCEP_MSG_QUOTA_GETNAMEBYID_CMD);
            String line=buf.readLine();
            while (line!=null){
                errMsg.append("<br>").append(line);
                line=buf.readLine();
            }
            NSException ex = new NSException(this.getClass(), NAS_EXCEP_MSG_QUOTA_GETNAMEBYID_CMD);
            ex.setDetail(errMsg.toString());
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_QUOTA_GETNAMEBYID_CMD);
            NSReporter.getInstance().report(ex);
            throw ex;                
        }
        
        InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
        BufferedReader buf = new BufferedReader(bufReader);
        String line = buf.readLine();
        //2002/4/27 lhy del String name = line;
        String name="";//2002/4/27 lhy add
        int err = -1;
        while (line != null){
            if (line.startsWith(IMS_CTL_ERR_START)){
                break;
            }//add begin:2002/4/27 lhy add
            
            /*modified by hujing 7/2/2002*/            
            StringTokenizer token=new StringTokenizer(line,":",false);
            if ( token.countTokens() > 1 ){
                token.nextToken();
                line = token.nextToken();
                
                token = new StringTokenizer(line,"(",false);
                if ( token.countTokens() > 1 ) {
                    name = token.nextToken();
                    name.trim();
                    err = 0;
                    break;
                }
            }
            //add end:2002/4/27 lhy add
            line = buf.readLine();
        }   //end while
        /*modify end. hujing 7/2/2002*/
        
        if (name==null)
        {
            NSException ex = new NSException(this.getClass(), NAS_EXCEP_MSG_QUOTA_GETNAMEBYID_CMD);
            ex.setDetail(NAS_EXCEP_MSG_QUOTA_GETNAMEBYID_CMD);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_QUOTA_GETNAMEBYID_CMD);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        
        if (err != 0)
        {
            NSException ex = new NSException(this.getClass(), NAS_EXCEP_MSG_QUOTA_GETNAMEBYID_CMD);
            ex.setDetail(line.toString());
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_QUOTA_GETNAMEBYID_CMD);
            NSReporter.getInstance().report(ex);
            throw ex;
        }
        return name;
    }//end of getNameFromId

    public SoapRpsVector getGraceTime(String filesystem, boolean DirQuota){
        SoapRpsVector trans = new SoapRpsVector();
        final boolean isDirQuota = DirQuota; 
        String home = System.getProperty("user.home");
        String dirFlag = isDirQuota?"isDir":"notDir";
        String[] cmd = {SUDO_COMMAND,home+SCRIPT_GETQUOTA_GRACETIME,filesystem,dirFlag};
        
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsVector trans=(SoapRpsVector)rps;
                trans.setSuccessful(true);
                Vector graceTime = new Vector();
                BufferedReader inputStr    = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                String line            = inputStr.readLine();
                 NSReporter.getInstance().report(NSReporter.DEBUG, "quota line=" + line);
                int i = 0;
                int count = isDirQuota?6:4;
                while(line != null && i<count)
                {
                    NSReporter.getInstance().report(NSReporter.DEBUG, "while quota line=" + line);
                    graceTime.add(line.trim());
                    line = inputStr.readLine();     
                    i++;
                }
                trans.setVector( graceTime );
            }
        };
        SOAPServerBase.execCmd( cmd, trans, cmdHandler );
        return trans;        
    }    
    
    public SoapRpsVector getDataMap(String filesystem){
        SoapRpsVector trans = new SoapRpsVector();
        String home = System.getProperty("user.home");
        String[] cmd = {SUDO_COMMAND,home+SCRIPT_DIRQUOTA_GETDATASET,filesystem};
        
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsVector trans = (SoapRpsVector)rps;
                trans.setSuccessful(true);
                Vector dataVec = new Vector();
                BufferedReader inputStr    = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                if (line !=null && line.startsWith("ID")){
                    line = inputStr.readLine();   
                }
                while (line !=null){
                    dataVec.add(line);
                    line = inputStr.readLine();
                }
                trans.setVector(dataVec);
             }
        };
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);
        return trans;    
    }
}
