/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.cifs;

import java.util.Vector;
import java.util.Locale;
import java.util.StringTokenizer;
import java.util.Date;
import java.util.GregorianCalendar;

 
import java.text.DateFormat;
import java.io.*;

import com.nec.nsgui.model.entity.base.DirectoryInfoBean;
import com.nec.nsgui.model.biz.base.*;

public class CIFSNavigatorList {
    private static final String     cvsid = "@(#) $Id: CIFSNavigatorList.java,v 1.13 2008/05/15 00:52:40 chenbc Exp $";
    
    private static final String SCRIPT_LIST_GLOBAL_DIR = "cifs_globalnavigatorlist.pl";
    private static final String SCRIPT_LIST_SHARE_DIR = "cifs_sharenavigatorlist.pl";
    private static final String COMMAND_SUDO = "sudo";
    private static final String USER_HOME = "user.home";
    private static final String SCRIPT_DIR = "/bin/";
    
    private static final String SCRIPT_CAN_MAKE_DIR = "cifs_canModifyDirectory.pl";
    private static final String SCRIPT_MAKE_DIR = "cifs_makeDirectory.pl";
    private static final String SCRIPT_DELETE_DIR = "cifs_delDirectory.pl";
    private static final String SCRIPT_CHECK_MP_TYPE = "cifs_checkMPType.pl";
    private static final String SCRIPT_HAVE_PARENT_ACL = "cifs_haveParentACL.pl";
    
    public Vector onListGlobal(String rootDirectory , String nowDirectory , Locale locale , boolean check , int nodeNo) throws Exception{   
        String home = System.getProperty(USER_HOME);
        String [] cmd = new String[6];
        cmd[0] = COMMAND_SUDO;
        cmd[1] = home + SCRIPT_DIR + SCRIPT_LIST_GLOBAL_DIR;
        cmd[2] = rootDirectory;
        cmd[3] = nowDirectory;
        if (check) {
            cmd[4] = "check";
        } else {
            cmd[4] = "uncheck";
        }
        cmd[5] = Integer.toString(nodeNo);
        
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmd , nodeNo);
        
        String[] allLines = cmdResult.getStdout();
        Vector allDirectoryInfo = new Vector();
            
        int start;
        if (check) {
            nowDirectory = allLines[0];
            allDirectoryInfo.add(allLines[0]);
            start = 1;
        } else {
            start = 0;
        }
        for (int i = start ; i < allLines.length ; i++ ) {
            DirectoryInfoBean oneDirInfo = new DirectoryInfoBean();
            analyseOneLine(allLines[i] , oneDirInfo , rootDirectory , nowDirectory , locale , "global");
            allDirectoryInfo.add(oneDirInfo);
        }
        return allDirectoryInfo;
        
    }
    
    public Vector onListShare(String rootDirectory , String nowDirectory , Locale locale , boolean check , int nodeNo, String notListfsType) throws Exception{    
        String home = System.getProperty(USER_HOME);
        String [] cmd = new String[7];
        cmd[0] = COMMAND_SUDO;
        cmd[1] = home + SCRIPT_DIR + SCRIPT_LIST_SHARE_DIR;
        cmd[2] = rootDirectory;
        cmd[3] = nowDirectory;
        if (check) {
            cmd[4] = "check";
        } else {
            cmd[4] = "uncheck";
        }
        cmd[5] = Integer.toString(nodeNo);
        if(notListfsType != null) {
            cmd[6] = notListfsType;
        } else {
            cmd[6] = "";
        }
        
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmd , nodeNo);
        
        String[] allLines = cmdResult.getStdout();
        Vector allDirectoryInfo = new Vector();
            
        int start;
        if (check) {
            nowDirectory = allLines[0];
            allDirectoryInfo.add(allLines[0]);
            start = 1;
        } else {
            start = 0;
        }
        for (int i = start ; i < allLines.length ; i++ ) {
            DirectoryInfoBean oneDirInfo = new DirectoryInfoBean();
            analyseOneLine(allLines[i] , oneDirInfo , rootDirectory , nowDirectory , locale , "share");
            allDirectoryInfo.add(oneDirInfo);
        }   
        return allDirectoryInfo;
    }
    
    
    private void analyseOneLine(String line , DirectoryInfoBean oneDirInfo , String rootDirectory , String nowDirectory , Locale locale , String whichFrom) throws Exception{
        String [] resultLine = line.split("\\s" , 12);
        String mountStatus = resultLine[0];
        String theDirType = resultLine[1];
        String mon = resultLine[7];
        String day = resultLine[8];
        String time = resultLine[9];
        String year = resultLine[10];
        
        String thePathString = resultLine[11];
            
        oneDirInfo.setMountStatus(mountStatus);
        
        String displaySelectedPath ;
        if (whichFrom.equals("global")) {
            if (nowDirectory.equals("/")) {
                displaySelectedPath = nowDirectory + thePathString;
            } else {
                displaySelectedPath = nowDirectory + "/" + thePathString;
            }
            if (theDirType.charAt(0) == 'd') {
                oneDirInfo.setDirType("directory");
            } else {
                oneDirInfo.setDirType("file");
            }
        } else {
        /*  String[] result = thePathString.split(":");
            if(result != null && result.length >= 2){
                thePathString = result[0];
                oneDirInfo.setDirType(result[1]);
            }else{
                oneDirInfo.setDirType("");
            } */
            if (nowDirectory.equals(rootDirectory)) {
                displaySelectedPath = thePathString;
            } else {
                displaySelectedPath = nowDirectory.substring(rootDirectory.length() + 1) + "/" + thePathString;
            }
        }
        
        if (nowDirectory.equals("/")) {
            oneDirInfo.setWholePath(nowDirectory + thePathString);
        } else {
            oneDirInfo.setWholePath(nowDirectory + "/" + thePathString);
        }
        
        oneDirInfo.setDisplayedPath(thePathString);
        oneDirInfo.setDisplaySelectedPath(displaySelectedPath);
        
        String [] timeArray = time.split(":");
        String hour = timeArray[0];
        String minute = timeArray[1];
        String second = timeArray[2];
         
        GregorianCalendar gc = new GregorianCalendar(Integer.parseInt(year) , NSModelUtil.getMonthInt(mon) 
                                    , Integer.parseInt(day) , Integer.parseInt(hour) 
                                    , Integer.parseInt(minute) , Integer.parseInt(second));
        Date theDate = gc.getTime();
            
            
        DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM , locale);
            
        String theDateString = df.format(theDate);  
        df = DateFormat.getTimeInstance(DateFormat.MEDIUM , locale);
        String theTimeString = df.format(theDate);
            
        oneDirInfo.setDateString(theDateString);
        oneDirInfo.setTimeString(theTimeString); 
    }
    
    public String canModifyDirectory(int groupNumber, String domainName, String computerName, String directoryName) throws Exception{
        String[] cmd = {
                COMMAND_SUDO,
                System.getProperty(USER_HOME) + SCRIPT_DIR + SCRIPT_CAN_MAKE_DIR,
                Integer.toString(groupNumber),
                domainName,
                computerName,
                directoryName
        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmd , groupNumber);
        String[] result = cmdResult.getStdout();
        if(result != null && result.length > 0){
            return result[0];
        }else{
            return "";
        }
    }
    public String getMPType(int groupNumber, String domainName, String computerName, String directoryName) throws Exception{
        String[] cmd = {
                COMMAND_SUDO,
                System.getProperty(USER_HOME) + SCRIPT_DIR + SCRIPT_CHECK_MP_TYPE,
                Integer.toString(groupNumber),
                domainName,
                computerName,
                directoryName
        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmd , groupNumber);
        String[] result = cmdResult.getStdout();
        if(result != null && result.length > 0){
            return result[0];
        }else{
            return "";
        }
    }
    public void makeDirectory(int groupNumber, String domainName, String computerName, String directoryName, String nfcDirLength)throws Exception{
        String[] cmd = {
                COMMAND_SUDO,
                System.getProperty(USER_HOME) + SCRIPT_DIR + SCRIPT_MAKE_DIR,
                Integer.toString(groupNumber),
                domainName,
                computerName,
                directoryName,
                nfcDirLength  // added for 0805 cifs limit
        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmd , groupNumber);
        String[] result = cmdResult.getStdout();
        if(result != null && result.length > 0){
            NSException exception = new NSException();
            exception.setErrorCode(result[0]);
            throw exception;
        }
    }
    public void deleteDirectory(int groupNumber, String domainName, String computerName, String directoryName)throws Exception{
        String[] cmd = {
                COMMAND_SUDO,
                System.getProperty(USER_HOME) + SCRIPT_DIR + SCRIPT_DELETE_DIR,
                Integer.toString(groupNumber),
                domainName,
                computerName,
                directoryName
        };
        CmdExecBase.execCmd(cmd , groupNumber);
    }
    public String haveParentACL(int groupNumber, String domainName, String computerName, String directoryName) throws Exception{
        String[] cmd = {
                COMMAND_SUDO,
                System.getProperty(USER_HOME) + SCRIPT_DIR + SCRIPT_HAVE_PARENT_ACL,
                Integer.toString(groupNumber),
                domainName,
                computerName,
                directoryName
        };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmd , groupNumber);
        String[] result = cmdResult.getStdout();
        if(result != null && result.length > 0){
            return result[0];
        }else{
            return "";
        }
    }
}