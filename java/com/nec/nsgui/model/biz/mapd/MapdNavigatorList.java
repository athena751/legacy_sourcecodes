/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.mapd;

import java.util.Vector;
import java.util.Locale;
import java.util.StringTokenizer;
import java.util.Date;
import java.util.GregorianCalendar;

 
import java.text.DateFormat;
import java.io.*;

import com.nec.nsgui.model.entity.base.DirectoryInfoBean;
import com.nec.nsgui.model.biz.base.*;

public class MapdNavigatorList {
    private static final String     cvsid = "@(#) $Id: MapdNavigatorList.java,v 1.1 2004/09/06 01:42:41 maojb Exp $";
    
    private static final String SCRIPT_MAPD_LIST_DIR = "mapd_navigatorlist.pl";
    private static final String COMMAND_SUDO = "sudo";
    private static final String USER_HOME = "user.home";
    private static final String SCRIPT_DIR = "/bin/";
    
    public Vector onList(String rootDirectory , String nowDirectory , Locale locale , boolean check , int nodeNo) throws Exception{	
        String home = System.getProperty(USER_HOME);
	String [] cmd = new String[5];
	cmd[0] = COMMAND_SUDO;
	cmd[1] = home + SCRIPT_DIR + SCRIPT_MAPD_LIST_DIR;
	cmd[2] = rootDirectory;
	cmd[3] = nowDirectory;
	if (check) {
            cmd[4] = "check";
        } else {
	    cmd[4] = "uncheck";
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
	    analyseOneLine(allLines[i] , oneDirInfo , rootDirectory , nowDirectory , locale);
	    allDirectoryInfo.add(oneDirInfo);
        }	
        return allDirectoryInfo;
        
    }
	
	
    private void analyseOneLine(String line , DirectoryInfoBean oneDirInfo , String rootDirectory , String nowDirectory , Locale locale) throws Exception{
	StringTokenizer st = new StringTokenizer(line);
	//must be 11 tokens
	String theDirType = st.nextToken();  //dir type
	st.nextToken(); 					//a number
	st.nextToken();						//owner
	st.nextToken();						//group
	st.nextToken();						//size
	st.nextToken();						//week
	
	String mon = st.nextToken();
	String day = st.nextToken();
	String time = st.nextToken();
	String year = st.nextToken();
	String thePathString = st.nextToken();
		
	oneDirInfo.setDisplayedPath(thePathString);
	oneDirInfo.setWholePath(nowDirectory + "/" + thePathString);
		
	String displaySelectedPath;
	if (nowDirectory.equals(rootDirectory)) {
	    displaySelectedPath = thePathString;
	} else {
	    displaySelectedPath = nowDirectory.substring(rootDirectory.length() + 1) + "/" + thePathString;
	}
	
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
		
	if (theDirType.charAt(0) == 'd') {
	    oneDirInfo.setDirType("directory");
	} else {
	    oneDirInfo.setDirType("file");
	}
		
    }
}