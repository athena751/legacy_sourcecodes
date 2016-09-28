/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.service.admin;

import java.util.*;
import java.io.*;
import com.nec.sydney.service.admin.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.http.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import com.nec.nsgui.model.biz.base.NSProcess;
/**
    Revision History

*/

public class HTTPSOAPServer implements HTTPConstants,CommonConst,NSExceptionMsg,NasConstants
{


    private static final String   cvsid = "@(#) $Id: HTTPSOAPServer.java,v 1.2302 2004/07/19 08:10:39 baiwq Exp";

    private static final String   GET_SERVICE_STATUS
                                     = "/usr/sbin/nec_httpd_config status";

    private static final String   GET_DYNAMIC_SCRIPT
                                     = "/bin/http_getDynamicScript.pl";

    private static final String   SET_SERVER_INFO
                                     = "/bin/http_setServerInfo.pl";

    private static final String   SET_DIRECTORY_INFO
                                     = "/bin/http_setDirectoryInfo.pl";

    private static final String   READ_FILE
                                     = "/bin/http_readFile.sh";

    private static final String   SET_PORTS
                                     = "/bin/http_setPorts.pl";

    private static final String   COPY_TO_ETC
                                     = "/bin/http_copy2etc.pl";

    private static final String   COPY_TO_TMP
                                     = "/bin/http_copy2tmp.pl";
    private static final String   SCRIPT_RECOVERY_CONF
                                     = "/bin/http_recoveryConf.pl";

    private static final String   SCRIPT_COPY_CONF_TO_BAK
                                     = "/bin/http_copyBak2Conf.pl";

    private static final String   SCRIPT_CREATE_BAK_FILES
                                     = "/bin/http_createBak.pl";


    private static final String   WIRTE_HTTP_CONF
                                     = "/usr/sbin/nec_httpd_config config";

    private static final String   START_SERVICE
                                     = "enable";

    private static final String   STOP_SERVICE
                                     = "disable";

    private static final String   RESTART_SERVICE
                                     = "restart";

    private static final String   COMMAND_NEC_HTTPD_CONFIG
                                     = "/usr/sbin/nec_httpd_config";

    private static final String   FILE_TEMP_HTTPD_CONF
                                     = "/tmp/httpd.conf";

    private static final String   FILE_TEMP_MAIN0_CONF
                                     = "/tmp/main0.conf";

    private static final String   FILE_TEMP_MAIN1_CONF
                                     = "/tmp/main1.conf";

    private static final String   FILE_TEMP_VIRTUAL0_CONF
                                     = "/tmp/virtual0.conf";

    private static final String   FILE_TEMP_VIRTUAL1_CONF
                                     = "/tmp/virtual1.conf";

    private static final String SCRIPT_HTTP_GET_DIR
                                     = "http_GetDir.pl";
	
	private static final String COMMAND_GET_USED_PORT
									 = "/bin/http_getusedport.pl";

    private static int ERROR_DIR_NOT_EXISTS = 21;

    String home = System.getProperty("user.home");


    public void HTTPSOAPServer(){}

    /**get information of http configuration information
     * @param none
     * @return HTTPInfo list contains http information
    */
    public HTTPInfo getHTTPInfo(String node, String infoLocation)throws Exception {
        HTTPInfo infoContainer = new HTTPInfo();
        HTTPBasicInfo basicInfo;
        HTTPServerInfo mainServer;
        Vector virtualHost = new Vector();
        String myNumber = ClusterSOAPServer.getMyNumber();

        if (infoLocation.equals("etc")) {
            CmdErrHandler cmdErrHandler = new CmdErrHandler(){
                public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                    trans.setSuccessful(false);
                    trans.setErrorCode(proc.exitValue());
                    trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            };
            String[] cmds;
            cmds = new String[4];
            cmds[0] = SUDO_COMMAND;
            cmds[1] = home + COPY_TO_TMP;// rm main*.conf.bak and virtual*.conf.bak
            cmds[2] = myNumber;
            cmds[3] = node;
            SOAPServerBase.execCmd(cmds, infoContainer, cmdErrHandler);
            if (!infoContainer.isSuccessful()){
                return infoContainer;
            }
        } else {
            //mv *.conf.bak  *.conf
            String[] cmds = {SUDO_COMMAND,
                             home+SCRIPT_RECOVERY_CONF};
            SoapResponse rps = new SoapResponse();
            SOAPServerBase.execCmd(cmds, rps);
        }

/*        if (!myNumber.equals(node)) {
            return new HTTPInfo();
        }
*/
        basicInfo = getBasicInfo(node);
        if (basicInfo.isSuccessful()){
            mainServer = getServerInfo(node, "mainServer", "");
            if (mainServer.isSuccessful()){
                TreeMap directoryMap = (TreeMap)mainServer.getDirectoryMap();
                Iterator directoryKeys = (directoryMap.keySet()).iterator();
                while (directoryKeys.hasNext()){
                    String currentKey = (String)directoryKeys.next();
                    HTTPDirectoryInfo directoryInfo = (HTTPDirectoryInfo)getDirectoryInfo(node, "",
                                                                 (String)currentKey);
                    if (directoryInfo.isSuccessful()){
                        directoryMap.put(currentKey, directoryInfo);
                    } else{
                        infoContainer.setSuccessful(false);
                        infoContainer.setErrorCode(directoryInfo.getErrorCode());
                        infoContainer.setErrorMessage(directoryInfo.getErrorMessage());
                        return infoContainer;
                    }
                }
                mainServer.setDirectoryMap(directoryMap);
                Vector nickNames = new Vector();
                String fileName = node.equals("0")?FILE_TEMP_VIRTUAL0_CONF:FILE_TEMP_VIRTUAL1_CONF;
                File middleFile = new File(fileName);

                Runtime run = Runtime.getRuntime();
                NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
                proc.waitFor();
                if (proc.exitValue() == 0){
                    InputStreamReader read = new InputStreamReader(proc.getInputStream());
                    BufferedReader buf = new BufferedReader(read);
                    if (buf !=null){
                        String line = buf.readLine();
                        while (line != null) {
                            if (line.trim().startsWith(VIRTUAL_HOST_BEGIN)){
                                StringTokenizer st = new StringTokenizer(line);
                                if (st.countTokens() == 2){
                                    st.nextToken();
                                    String tempName = new String(st.nextToken());
                                    tempName = tempName.substring(0,tempName.length()-1);
                                    nickNames.add(tempName);
                                }
                            }
                            line = buf.readLine();
                        }
                    }
                }
                /*copy a blank file as virtural bak*/
                if (nickNames.size() == 0){
                    String[] cmds = {SUDO_COMMAND,
                             home+SCRIPT_CREATE_BAK_FILES,
                             fileName};
                    SoapResponse trans = new SoapResponse();
                    SOAPServerBase.execCmd(cmds, trans);
                }
                /**/
                for (int i=0; i<nickNames.size(); i++){
                    HTTPServerInfo virtualHostInfo = getServerInfo(node, "virtualHost", (String)nickNames.get(i));
                    virtualHost.add(virtualHostInfo);
                }
            } else{
                infoContainer.setSuccessful(false);
                infoContainer.setErrorCode(mainServer.getErrorCode());
                infoContainer.setErrorMessage(mainServer.getErrorMessage());
                return infoContainer;
            }
        } else{
            infoContainer.setSuccessful(false);
            infoContainer.setErrorCode(basicInfo.getErrorCode());
            infoContainer.setErrorMessage(basicInfo.getErrorMessage());
            return infoContainer;
        }

        infoContainer.setBasicInfo(basicInfo);
        infoContainer.setMainServer(mainServer);
        infoContainer.setVirtualHosts(virtualHost);
        return infoContainer;
    }

    public HTTPBasicInfo getBasicInfo(String node) throws Exception {
        HTTPBasicInfo basicInfo = new HTTPBasicInfo();

        //basicInfo.setServiceStatus(getServiceStatus());
        String fileName = FILE_TEMP_HTTPD_CONF;
        File middleFile = new File(fileName);

        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if ( proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
                String line = buf.readLine();
                while (line != null && !line.trim().startsWith(BASIC_CONFIG_BEGIN)){
                     line = buf.readLine();
                }
                line = buf.readLine();
                StringBuffer sb=new StringBuffer("");
                while (line != null){
                    if (line.trim().startsWith(BASIC_CONFIG_END )){
                        break;
                    }
                    if (line.trim().startsWith(LISTEN)){
                        StringTokenizer st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            sb.append(st.nextToken());
                            sb.append(" ");
                        }
                    }
                    if (line.trim().equals(HTTP + " yes")) {
                        basicInfo.setServiceStatus(true);
                    }
                    if (line.trim().equals(HTTP + " no")) {
                        basicInfo.setServiceStatus(false);
                    }
                    line = buf.readLine();
                }
                if (!(sb.toString().trim()).equals("")){
                   basicInfo.setPorts(sb.toString().trim());
                }
                if (getServiceStatus()){
                    basicInfo.setHttpdStatus(true);
                } else{
                    basicInfo.setHttpdStatus(false);
                }
            }
        }

		//get the port which is useing by tcp
		//modified by zhangjx
		run = Runtime.getRuntime();
        proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + COMMAND_GET_USED_PORT ));
        proc.waitFor();
        if ( proc.exitValue() == 0){
			InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
				String usedPort = buf.readLine();
				if (usedPort != null){
					basicInfo.setUsedPort(usedPort.trim());
				}
            }
        }
		//end of getting port which is useing by tcp
		
        getSelectableFunctions(basicInfo);
        if (basicInfo.isSuccessful()) {
            getDefaultOptions(basicInfo);
        }
        return basicInfo;
    }

    public HTTPServerInfo getServerInfo(String node, String serverType, String virtualNickName) throws Exception {
        HTTPServerInfo serverInfo = new HTTPServerInfo();
        boolean isVirtualServer = serverType.equals("virtualHost")?true:false;
        Map directoryMap = new TreeMap();

        String fileName;
        if (node.equals("0") && isVirtualServer){
            fileName = FILE_TEMP_VIRTUAL0_CONF;
        } else if (!node.equals("0") && isVirtualServer){
            fileName = FILE_TEMP_VIRTUAL1_CONF;
        } else if (node.equals("0") && !isVirtualServer){
            fileName = FILE_TEMP_MAIN0_CONF;
        } else{
            fileName = FILE_TEMP_MAIN1_CONF;
        }
        File middleFile = new File(fileName);
        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if (proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
                String tag_begin = serverType.equals("mainServer")?MAIN_SERVER_BEGIN:VIRTUAL_HOST_BEGIN + virtualNickName + ">";
                String tag_end = serverType.equals("mainServer")?MAIN_SERVER_END:VIRTUAL_HOST_END;
                String line = buf.readLine();
                StringTokenizer st;
                while (line != null && !line.trim().equals(tag_begin)){
                    line = buf.readLine();
                }
                if (line != null && isVirtualServer){
                    st = new StringTokenizer(line);
                    if (st.countTokens() == 2){
                        st.nextToken();
                        String tempName = st.nextToken();
                        tempName = tempName.substring(0,tempName.length()-1);
                        serverInfo.setNickName(tempName);
                        }
                }
                line = buf.readLine();

                while (line != null) {
                    if (line.trim().startsWith(tag_end)){
                        break;
                    }
                    if (isVirtualServer && line.trim().startsWith(NAME_VIRTUAL_HOST)){
                        serverInfo.setVirtualHostType(VIRTUALHOSTMOD_NAME_BASED);
                        line = buf.readLine();
                        continue;
                    }
                    if (isVirtualServer && line.trim().startsWith(HOST_BEGIN)){
                        st = new StringTokenizer(line.substring(0,line.length()-1));
                        if (st.countTokens() == 2) {
                            st.nextToken();
                            String tempIP = st.nextToken();
                            if (!tempIP.equals("*")) {
                                serverInfo.setUsedIPAddrsMode(USEDIPADDRSMODE_CUSTOM);
                                serverInfo.setUsedIPAddrs(tempIP);
                            }
                        } else if (st.countTokens() >= 3){
                            st.nextToken();
                            StringBuffer sb = new StringBuffer("");
                            while (st.hasMoreTokens()){
                                sb.append(st.nextToken());
                                sb.append(" ");
                            }
                            serverInfo.setUsedIPAddrsMode(USEDIPADDRSMODE_CUSTOM);
                            serverInfo.setUsedIPAddrs(sb.toString().trim());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(DOCUMENTROOT)){
                        serverInfo.setDocumentRoot(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(SERVERNAME)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setServerName(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(SERVERADMIN)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setServerAdmin(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USER_UNIX_NAME)){
                        serverInfo.setUnixUserName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USER_UNIX_ID)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setUnixUserID(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(GROUP_UNIX_NAME)){
                        serverInfo.setUnixGroupName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(GROUP_UNIX_ID)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setUnixGroupID(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USER_WINDOWS_NAME)){
                        serverInfo.setWindowsUserName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(GROUP_WINDOWS_NAME)){
                        serverInfo.setWindowsGroupName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(TRANSFERLOG)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            String tempTranLog = st.nextToken();
                            if (tempTranLog.equals(TRANSFERLOGMODE_STANDARD)){
                                serverInfo.setTransferLogMode(tempTranLog);
                            } else{
                                serverInfo.setTransferLogMode(TRANSFERLOGMODE_CUSTOM);
                                serverInfo.setTransferLogLocation(tempTranLog);
                            }
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(CUSTOMLOG)){
                        serverInfo.setCustomLogAllowed(true);
                        st = new StringTokenizer(line);
                        if (st.countTokens() > 2){
                            st.nextToken();
                            serverInfo.setCustomLogFileName(st.nextToken());
                            st.nextToken("\"");
                            serverInfo.setCustomLogFormat(st.nextToken("\""));
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(ERRORLOG)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            String tempErrorLog = st.nextToken();
                            if (tempErrorLog.equals(ERRORLOGMODE_STANDARD) ||
                                tempErrorLog.equals(ERRORLOGMODE_SYSLOG)){
                                serverInfo.setErrorLogMode(tempErrorLog);
                            } else{
                                serverInfo.setErrorLogMode(ERRORLOGMODE_CUSTOM);
                                serverInfo.setErrorLogLocation(tempErrorLog);
                            }
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(LOGLEVEL)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setErrorLogLevel(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(ACCESSFILENAME)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setAccessFileName(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USERDIR)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2) {
                            st.nextToken();
                            String tempDirAllowed = st.nextToken();
                            if (tempDirAllowed.equals(DIR_DISABLE)) {
                                line = buf.readLine();
                                if (line != null && line.trim().startsWith(USERDIR)) {
                                     serverInfo.setUserDirAllowed(true);
                                     serverInfo.setUserDirMode(DIR_ENABLE_ONLY);  
                                     serverInfo.setUserDirUserList(getTheContent(getTheContent(line, false), false));
                                     line = buf.readLine();
                                     serverInfo.setUserDirPattern(getTheContent(line, true));
                                     line = buf.readLine();
                                } else {
                                    serverInfo.setUserDirAllowed(false);
                                }
                            } else {
                                serverInfo.setUserDirAllowed(true);
                                serverInfo.setUserDirMode(DIR_ENABLE);
                                serverInfo.setUserDirPattern(getTheContent(line, true));
                                line = buf.readLine();
                            }
                            
                        } else if (st.countTokens() >= 3) {
                            serverInfo.setUserDirAllowed(true);
                            st.nextToken();
                            String tempDirAllowed = st.nextToken();
                            if (!tempDirAllowed.equals(DIR_DISABLE)&& !tempDirAllowed.equals(DIR_ENABLE)){
                                serverInfo.setUserDirMode(DIR_ENABLE);
                                serverInfo.setUserDirPattern(getTheContent(line, true));
                            } else {
                                if (tempDirAllowed.equals(DIR_DISABLE)) {
                                    serverInfo.setUserDirMode(DIR_DISABLE_ONLY);
                                } else if (tempDirAllowed.equals(DIR_ENABLE)){
                                    serverInfo.setUserDirMode(DIR_ENABLE_ONLY);
                                }
                                
                                serverInfo.setUserDirUserList(getTheContent(getTheContent(line, false), false));
                                line = buf.readLine();
                                if (line.trim().startsWith(USERDIR)){                      
                                   serverInfo.setUserDirPattern(getTheContent(line, true));
                                }
                            }
                            line = buf.readLine();
                        }
                        continue;
                    }
                    if (line.trim().startsWith(DIRECTORY_BEGIN)){
                        String tempDir = this.getTheContent(line.trim(), false);
                        if (tempDir.trim().startsWith("\"")){
                            directoryMap.put(tempDir.substring(1, tempDir.length()-2), "");
                        } else {
                            directoryMap.put(tempDir.substring(0, tempDir.length()-1), "");
                        }
                        line = buf.readLine();
                        continue;
                    }
                    line = buf.readLine();
                }
            }

        }
        serverInfo.setDirectoryMap(directoryMap);
		
		//get the port which is useing by tcp
		//modified by zhangjx
		run = Runtime.getRuntime();
        proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + COMMAND_GET_USED_PORT ));
        proc.waitFor();
        if ( proc.exitValue() == 0){
			InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
				String usedPort = buf.readLine();
				if (usedPort != null){
					serverInfo.setUsedPort(usedPort.trim());
				}
            }
        }
		//end of getting port which is useing by tcp

        {
            String[] cmds = {SUDO_COMMAND,
                             home+SCRIPT_CREATE_BAK_FILES,
                             fileName};
            SoapResponse trans = new SoapResponse();
            SOAPServerBase.execCmd(cmds, trans);

        }
        return serverInfo;
    }

    public HTTPDirectoryInfo getDirectoryInfo4View(String node, String nickName, String directory) throws Exception{
        HTTPDirectoryInfo directoryInfo = new HTTPDirectoryInfo();
        boolean isVirtualHost = nickName.equals("")?false:true;
        boolean isNew = directory.equals("")?true:false;

        directoryInfo.setDirectory(directory);
        directory = "\""+directory+"\"";
        if (isNew){
            getDirectoryOptions(nickName, "", directoryInfo, isVirtualHost);
            if (directoryInfo.isSuccessful()){
                getAllowOptions(nickName, "", directoryInfo, isVirtualHost);
            }
            return directoryInfo;
        }
        String fileName;
        if (node.equals("0") && isVirtualHost){
            fileName = "/etc/group0.setupinfo/httpd/interim/virtual0.conf";
        } else if (!node.equals("0") && isVirtualHost){
            fileName = "/etc/group1.setupinfo/httpd/interim/virtual1.conf";
        } else if (node.equals("0") && !isVirtualHost){
            fileName = "/etc/group0.setupinfo/httpd/interim/main0.conf";
        } else{
            fileName = "/etc/group1.setupinfo/httpd/interim/main1.conf";
        }

        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if (proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf != null){
                String line = buf.readLine();
                if (!isVirtualHost) {
                    while (line != null && !line.trim().startsWith(MAIN_SERVER_BEGIN)){
                        line = buf.readLine();
                    }
                    line = buf.readLine();
                    while (line != null && !line.trim().startsWith(DIRECTORY_BEGIN+directory+">")) {
                        line = buf.readLine();
                    }
                } else{
                    while (line != null && !line.trim().startsWith(VIRTUAL_HOST_BEGIN+nickName+">")){
                        line = buf.readLine();
                    }
                    line = buf.readLine();
                    while (line != null && !line.trim().startsWith(DIRECTORY_BEGIN+directory+">")){
                        line = buf.readLine();
                    }
                }

                line = buf.readLine();
                while (line != null) {
                    if (line.trim().startsWith(DIRECTORY_END)){
                        break;
                    }

                    if (line.trim().equals(ORDER_ALLOW_DENY)){
                        line = buf.readLine();
                        if (line.trim().equals(ALL_ALLOW)){
                            directoryInfo.setDirectoryAccessMode(ALL_ALLOW);
                        } else{
                            directoryInfo.setDirectoryAccessMode(ORDER_ALLOW_DENY);
                            if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }
                            line = buf.readLine();
                            if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }
                        }
                    } else if (line.trim().equals(ORDER_DENY_ALLOW)){
                        directoryInfo.setDirectoryAccessMode(ORDER_DENY_ALLOW);
                        line = buf.readLine();
                        if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }
                            line = buf.readLine();
                            if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }

                    }
                    line = buf.readLine();
                }
            }
        }

        getDirectoryOptions(nickName, directory, directoryInfo, isVirtualHost);
        if (directoryInfo.isSuccessful()){
            getAllowOptions(nickName, directory, directoryInfo, isVirtualHost);
        }
        return directoryInfo;

    }


    public HTTPDirectoryInfo getDirectoryInfo(String node, String nickName, String directory) throws Exception{
        HTTPDirectoryInfo directoryInfo = new HTTPDirectoryInfo();
        boolean isVirtualHost = nickName.equals("")?false:true;
        boolean isNew = directory.equals("")?true:false;

        directoryInfo.setDirectory(directory);
        directory = "\""+directory+"\"";
        if (isNew){
            getDirectoryOptions(nickName, "", directoryInfo, isVirtualHost);
            if (directoryInfo.isSuccessful()){
                getAllowOptions(nickName, "", directoryInfo, isVirtualHost);
            }
            return directoryInfo;
        }
        String fileName;
        if (node.equals("0") && isVirtualHost){
            fileName = FILE_TEMP_VIRTUAL0_CONF;
        } else if (!node.equals("0") && isVirtualHost){
            fileName = FILE_TEMP_VIRTUAL1_CONF;
        } else if (node.equals("0") && !isVirtualHost){
            fileName = FILE_TEMP_MAIN0_CONF;
        } else{
            fileName = FILE_TEMP_MAIN1_CONF;
        }

        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if (proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf != null){
                String line = buf.readLine();
                if (!isVirtualHost) {
                    while (line != null && !line.trim().startsWith(MAIN_SERVER_BEGIN)){
                        line = buf.readLine();
                    }
                    line = buf.readLine();
                    while (line != null && !line.trim().startsWith(DIRECTORY_BEGIN+directory+">")) {
                        line = buf.readLine();
                    }
                } else{
                    while (line != null && !line.trim().startsWith(VIRTUAL_HOST_BEGIN+nickName+">")){
                        line = buf.readLine();
                    }
                    line = buf.readLine();
                    while (line != null && !line.trim().startsWith(DIRECTORY_BEGIN+directory+">")){
                        line = buf.readLine();
                    }
                }

                line = buf.readLine();
                while (line != null) {
                    if (line.trim().startsWith(DIRECTORY_END)){
                        break;
                    }

                    if (line.trim().equals(ORDER_ALLOW_DENY)){
                        line = buf.readLine();
                        if (line.trim().equals(ALL_ALLOW)){
                            directoryInfo.setDirectoryAccessMode(ALL_ALLOW);
                        } else{
                            directoryInfo.setDirectoryAccessMode(ORDER_ALLOW_DENY);
                            if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }
                            line = buf.readLine();
                            if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }
                        }
                    } else if (line.trim().equals(ORDER_DENY_ALLOW)){
                        directoryInfo.setDirectoryAccessMode(ORDER_DENY_ALLOW);
                        line = buf.readLine();
                        if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }
                            line = buf.readLine();
                            if (line.trim().startsWith(ALLOW_FROM)){
                                directoryInfo.setDirectoryAccessAllowList(getAccessList(line));
                            } else if (line.trim().startsWith(DENY_FROM)){
                                directoryInfo.setDirectoryAccessDenyList(getAccessList(line));
                            }

                    }
                    line = buf.readLine();
                }
            }
        }

        getDirectoryOptions(nickName, directory, directoryInfo, isVirtualHost);
        if (directoryInfo.isSuccessful()){
            getAllowOptions(nickName, directory, directoryInfo, isVirtualHost);
        }
        return directoryInfo;

    }

    public SoapResponse setBasicInfo(String node, HTTPBasicInfo basicInfo) throws Exception{
        SoapResponse trans  = new SoapResponse();

        String fnode = ClusterSOAPServer.getMyNumber();
/*        String cmds_ports[] = new String[4];
        cmds_ports[0] = SUDO_COMMAND;
        cmds_ports[1] = home + SET_PORTS;
        cmds_ports[2] = fnode;
        cmds_ports[3] = basicInfo.getPorts();

*/
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

/*        SOAPServerBase.execCmd(cmds_ports,trans,cmdErrHandler);
        if (!trans.isSuccessful()){
             return trans;
        }
*/
        Vector cmdsVec = new Vector();
        cmdsVec.add(SUDO_COMMAND);
        cmdsVec.add(home + SET_SERVER_INFO);
        cmdsVec.add("");
        cmdsVec.add(fnode);
        cmdsVec.add("BasicConfig");
        StringTokenizer st = new StringTokenizer(basicInfo.getPorts());
        String item;
        while (st.hasMoreTokens()){
            item = new String(LISTEN+st.nextToken());
            cmdsVec.add(item);
        }
        if (basicInfo.getServiceStatus()) {
            cmdsVec.add("http yes");
        } else {
            cmdsVec.add("http no");
        }
        Map dynamicInfo = (Hashtable)basicInfo.getDynamicInfo();
        Iterator keys = dynamicInfo.keySet().iterator();
        while (keys.hasNext()) {
            String currentKey = (String)keys.next();
            item = new String(currentKey + " " + dynamicInfo.get(currentKey));
            cmdsVec.add(item);
        }
        String[] cmds = (String[])cmdsVec.toArray(new String[0]);
/*        String fileName = fnode.equals("0")?FILE_HTTPD_0:FILE_HTTPD_1;
        trans = Transaction.checkout(fileName );
        if (!trans.isSuccessful()){
            return trans;
        } else{*/
        SOAPServerBase.execCmd(getSubStrArray(cmds, 0, 1), trans, cmdErrHandler, getSubStrArray(cmds, 2, cmds.length-1));
/*            if (!trans.isSuccessful()){
                Transaction.rollback(fileName );
                return trans;
            } else{
                trans = Transaction.checkin(fileName );
                if (!trans.isSuccessful()){
                    return trans;
                }
            }
        }
        trans = doConfig(node); */
        return trans;
    }


    public SoapResponse setServerInfo(String node, String serverType, String nickName,
                                      HTTPServerInfo serverInfo) throws Exception{
        SoapResponse trans = new SoapResponse();
        String fnode = ClusterSOAPServer.getMyNumber();

        boolean isVirtualHost = serverType.equals("virtualHost")?true:false;
        /*
        if (!isVirtualHost) {
            SoapRpsString rpsString= this.getNickName(serverInfo.getServerName());
            if (!rpsString.isSuccessful()) {
                return rpsString;
            }
            serverInfo.setServerName(rpsString.getString());
        }
        */
        boolean isMain2Virtual = node.equals(fnode)?false:true;
        if (isVirtualHost && serverInfo.getNickName().trim().equals("")){
               String cmds[] = new String[6];
               cmds[0] = SUDO_COMMAND;
               cmds[1] = home + SET_SERVER_INFO;
               cmds[2] = fnode;
               cmds[3] = node;
               cmds[4] = "VirtualHostConfig";
               cmds[5] = nickName;

               SOAPServerBase.execCmd(getSubStrArray(cmds, 0, 1), trans, getSubStrArray(cmds, 2, cmds.length-1));
               {String [] cmds3 = {SUDO_COMMAND,
                              home+SCRIPT_COPY_CONF_TO_BAK,
                              nickName};
                SOAPServerBase.execCmd(cmds3,trans);
               }
               return trans;
        }
        Vector cmdsVec = new Vector();
        cmdsVec.add(SUDO_COMMAND);
        cmdsVec.add(home + SET_SERVER_INFO);
        cmdsVec.add(fnode);
        cmdsVec.add(node);
        if (isVirtualHost){
            cmdsVec.add("VirtualHostConfig");
            cmdsVec.add(nickName);

            String ipaddress = serverInfo.getUsedIPAddrsMode().trim()
                    .equals(USEDIPADDSMODE_ALL)?"*":serverInfo.getUsedIPAddrs().trim();
            cmdsVec.add(serverInfo.getNickName());
            if (serverInfo.getVirtualHostType().equals(VIRTUALHOSTMOD_NAME_BASED)){
                String[] IPs = ipaddress.split("\\s+");
                for (int i=0;i<IPs.length;i++){
                    cmdsVec.add(NAME_VIRTUAL_HOST + IPs[i]);
                }
            }

            cmdsVec.add(HOST_BEGIN + ipaddress + ">");
        } else{
            cmdsVec.add("MainServerConfig");
            if (isMain2Virtual){
               cmdsVec.add(this.getOldMainServerName(node));
               cmdsVec.add(serverInfo.getServerName());
               cmdsVec.add(NAME_VIRTUAL_HOST + "*");
               cmdsVec.add(HOST_BEGIN + "*" + ">");
            }
        }
        addKV(cmdsVec, SERVERNAME, serverInfo.getServerName());
        cmdsVec.add(DOCUMENTROOT + "\"" + serverInfo.getDocumentRoot() + "\"");
        addKV(cmdsVec, SERVERADMIN, serverInfo.getServerAdmin());
        addKV(cmdsVec, USER_UNIX_NAME, "\""+serverInfo.getUnixUserName()+"\"");
        addKV(cmdsVec, USER_UNIX_ID, serverInfo.getUnixUserID());
        addKV(cmdsVec, GROUP_UNIX_NAME, "\""+serverInfo.getUnixGroupName()+"\"");
        addKV(cmdsVec, GROUP_UNIX_ID, serverInfo.getUnixGroupID());
        addKV(cmdsVec, USER_WINDOWS_NAME, "\""+serverInfo.getWindowsUserName()+"\"");
        addKV(cmdsVec, GROUP_WINDOWS_NAME, "\""+serverInfo.getWindowsGroupName()+"\"");

        if (serverInfo.getTransferLogMode().equals(TRANSFERLOGMODE_STANDARD)){
            cmdsVec.add(TRANSFERLOG + TRANSFERLOGMODE_STANDARD);
        } else{
            cmdsVec.add(TRANSFERLOG + serverInfo.getTransferLogLocation());
        }
        /*
        if (serverInfo.getCustomLogAllowed()){
            cmdsVec.add(CUSTOMLOG+serverInfo.getCustomLogFileName() + " \"" + serverInfo.getCustomLogFormat() + "\"");
        }
        */
        if (serverInfo.getErrorLogMode().equals(ERRORLOGMODE_CUSTOM)){
            cmdsVec.add(ERRORLOG+serverInfo.getErrorLogLocation());
        } else{
            cmdsVec.add(ERRORLOG+serverInfo.getErrorLogMode());
        }
        cmdsVec.add(LOGLEVEL + serverInfo.getErrorLogLevel());
        if (serverInfo.getAccessFileName().trim().equals("")){
            cmdsVec.add(ACCESSFILENAME + ".htaccess");
        } else {
            cmdsVec.add(ACCESSFILENAME + serverInfo.getAccessFileName());

        }
        if (!serverInfo.getUserDirAllowed()){
            cmdsVec.add(USERDIR+DIR_DISABLE);
        } else{
           if(serverInfo.getUserDirMode().equals(DIR_DISABLE_ONLY)){
                cmdsVec.add(USERDIR+DIR_DISABLE+ " "+serverInfo.getUserDirUserList());
           } else if(serverInfo.getUserDirMode().equals(DIR_ENABLE_ONLY)){
                cmdsVec.add(USERDIR+DIR_DISABLE);
                cmdsVec.add(USERDIR+DIR_ENABLE+ " "+serverInfo.getUserDirUserList());
           }
           cmdsVec.add(USERDIR+"\""+serverInfo.getUserDirPattern()+"\"");
        }

        String[] cmds = (String[])cmdsVec.toArray(new String[0]);
        String whichFile = isVirtualHost?"virtual":"main";
        /*String fileName = "/etc/group" + fnode + ".setupinfo/httpd/interim/"
                + whichFile + node + ".conf";
        */
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

        SOAPServerBase.execCmd(getSubStrArray(cmds, 0, 1), trans, cmdErrHandler, getSubStrArray(cmds, 2, cmds.length-1));
        if (!trans.isSuccessful()){
            return trans;
        } else{
            Map directoryMap = serverInfo.getDirectoryMap();
            if (isVirtualHost){
                trans = setDirectoryInfo(node, serverType, directoryMap, serverInfo.getNickName());
            } else{
                if (!fnode.equals(node)){
                    trans = setDirectoryInfo(node, serverType, directoryMap, serverInfo.getServerName());
                } else{
                    trans = setDirectoryInfo(node, serverType, directoryMap, "");
                }
            }
            {String [] cmds2 = {SUDO_COMMAND,
                              home+SCRIPT_COPY_CONF_TO_BAK,
                              nickName};
              SOAPServerBase.execCmd(cmds2,trans);
            }
            return trans;
        }

    }

    public SoapResponse doConfig(String node) throws Exception{
        SoapResponse trans = new SoapResponse();
        String fnode = ClusterSOAPServer.getMyNumber();

        String cmds_ports[] = new String[4];
        cmds_ports[0] = SUDO_COMMAND;
        cmds_ports[1] = home + SET_PORTS;
        cmds_ports[2] = fnode;


        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };
        HTTPBasicInfo basicInfo = getBasicInfo(node);
        boolean newStatus = basicInfo.getServiceStatus();
        //boolean oldStatus = getServiceStatus();
        if (newStatus) {
            cmds_ports[3] = basicInfo.getPorts();
            SOAPServerBase.execCmd(getSubStrArray(cmds_ports, 0, 1), trans, cmdErrHandler, getSubStrArray(cmds_ports, 2, cmds_ports.length-1));
            if (!trans.isSuccessful()){
                 return trans;
            }
//        } else if (!newStatus && oldStatus) {
        } else {
            cmds_ports[3] = "";
            SOAPServerBase.execCmd(getSubStrArray(cmds_ports, 0, 1), trans, cmdErrHandler, getSubStrArray(cmds_ports, 2, cmds_ports.length-1));
            if (!trans.isSuccessful()){
                 return trans;
            }
        }

/*
        StringBuffer cmds = new StringBuffer();
        cmds.append(SUDO_COMMAND);
        cmds.append(" ");
        cmds.append(home + COPY_TO_ETC);
        cmds.append(" ");
        cmds.append(fnode);
        cmds.append(" ");
        cmds.append(node);
*/
        String[] cmds = {SUDO_COMMAND,
                         home + COPY_TO_ETC,
                         fnode,
                         node};


        cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };
// copy temporary files to /etc
        String[] files = new String[5];
        files[0] = "/etc/group" + fnode + ".setupinfo/httpd/interim/httpd.conf";
        files[1] = "/etc/group" + fnode + ".setupinfo/httpd/interim/main0.conf";
        files[2] = "/etc/group" + fnode + ".setupinfo/httpd/interim/main1.conf";
        files[3] = "/etc/group" + fnode + ".setupinfo/httpd/interim/virtual0.conf";
        files[4] = "/etc/group" + fnode + ".setupinfo/httpd/interim/virtual1.conf";

        trans = Transaction.checkout(files[0]);
        if (trans.isSuccessful()) {
            trans = Transaction.checkout(files[1]);
            if (trans.isSuccessful()) {
                trans = Transaction.checkout(files[2]);
                if (trans.isSuccessful()) {
                    trans = Transaction.checkout(files[3]);
                    if (trans.isSuccessful()) {
                        trans = Transaction.checkout(files[4]);
                    }
                }
            }
        }
        if (!trans.isSuccessful()) {
            Transaction.rollback(files[0]);
            Transaction.rollback(files[1]);
            Transaction.rollback(files[2]);
            Transaction.rollback(files[3]);
            Transaction.rollback(files[4]);
            return trans;
        }

        SOAPServerBase.execCmd(cmds,trans, cmdErrHandler);
        if (!trans.isSuccessful()){
            Transaction.rollback(files[0]);
            Transaction.rollback(files[1]);
            Transaction.rollback(files[2]);
            Transaction.rollback(files[3]);
            Transaction.rollback(files[4]);
            return trans;
        }
        trans = Transaction.checkin(files[0]);
        if (trans.isSuccessful()) {
            trans = Transaction.checkin(files[1]);
            if (trans.isSuccessful()) {
                trans = Transaction.checkin(files[2]);
                if (trans.isSuccessful()) {
                    trans = Transaction.checkin(files[3]);
                    if(trans.isSuccessful()) {
                        trans = Transaction.checkin(files[4]);
                    }
                }
            }
        }
        if (!trans.isSuccessful()){
            Transaction.rollback(files[0]);
            Transaction.rollback(files[1]);
            Transaction.rollback(files[2]);
            Transaction.rollback(files[3]);
            Transaction.rollback(files[4]);
            return trans;
        }

/*
        cmds = new StringBuffer();
        cmds.append(SUDO_COMMAND);
        cmds.append(" ");
        cmds.append(WIRTE_HTTP_CONF);
        cmds.append(" ");
        cmds.append(fnode);
        cmds.append(" ");
        if (fnode.equals("0")){
            cmds.append(FILE_HTTPD_0);
            cmds.append(" ");
            cmds.append(FILE_MAIN0_0);
            cmds.append(" ");
            cmds.append(FILE_VIRTUAL0_0);
            cmds.append(" ");
            cmds.append(FILE_VIRTUAL0_1);
            cmds.append(" ");
            cmds.append(FILE_MAIN0_1);
        } else {
            cmds.append(FILE_HTTPD_1);
            cmds.append(" ");
            cmds.append(FILE_MAIN1_1);
            cmds.append(" ");
            cmds.append(FILE_VIRTUAL1_1);
            cmds.append(" ");
            cmds.append(FILE_VIRTUAL1_0);
            cmds.append(" ");
            cmds.append(FILE_MAIN1_0);
        }
*/
        Vector vCmd = new Vector();
        vCmd.add(SUDO_COMMAND);

        vCmd.add(COMMAND_NEC_HTTPD_CONFIG);
        vCmd.add("config");

        vCmd.add(fnode);

        if (fnode.equals("0")){
            vCmd.add(FILE_HTTPD_0);

            vCmd.add(FILE_MAIN0_0);

            vCmd.add(FILE_VIRTUAL0_0);

            vCmd.add(FILE_VIRTUAL0_1);

            vCmd.add(FILE_MAIN0_1);
        } else {
            vCmd.add(FILE_HTTPD_1);

            vCmd.add(FILE_MAIN1_1);

            vCmd.add(FILE_VIRTUAL1_1);

            vCmd.add(FILE_VIRTUAL1_0);

            vCmd.add(FILE_MAIN1_0);
        }
        cmds = new String[vCmd.size()];
        vCmd.toArray(cmds);


        cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };
        SOAPServerBase.execCmd(cmds ,trans, cmdErrHandler);
        if (!trans.isSuccessful() || !newStatus){
            return trans;
        } else{
            trans = setService();
        }
        return trans;
    }

    public SoapResponse setDirectoryInfo(String node, String serverType,
                                     Vector directoryVec, String nickName) throws Exception{
        return setDirectoryInfo(node, serverType, (Map)directoryVec.get(0), nickName);
    }

    public HTTPInfo getHTTPInfo(String node, String infoLocation, String isNsview)throws Exception {
        HTTPInfo infoContainer = new HTTPInfo();
        HTTPBasicInfo basicInfo;
        HTTPServerInfo mainServer;
        Vector virtualHost = new Vector();

        basicInfo = getBasicInfo4Viewer(node);
        if (basicInfo.isSuccessful()){
            mainServer = getServerInfo4Viewer(node, "mainServer", "");
            if (mainServer.isSuccessful()){
                TreeMap directoryMap = (TreeMap)mainServer.getDirectoryMap();
                Iterator directoryKeys = (directoryMap.keySet()).iterator();
                while (directoryKeys.hasNext()){
                    String currentKey = (String)directoryKeys.next();
                    HTTPDirectoryInfo directoryInfo = (HTTPDirectoryInfo)getDirectoryInfo4View(node, "",
                                                                 (String)currentKey);
                    if (directoryInfo.isSuccessful()){
                        directoryMap.put(currentKey, directoryInfo);
                    } else{
                        infoContainer.setSuccessful(false);
                        infoContainer.setErrorCode(directoryInfo.getErrorCode());
                        infoContainer.setErrorMessage(directoryInfo.getErrorMessage());
                        return infoContainer;
                    }
                }
                mainServer.setDirectoryMap(directoryMap);
                Vector nickNames = new Vector();
                String fileName = node.equals("0")?"/etc/group0.setupinfo/httpd/interim/virtual0.conf"
                                                   :"/etc/group1.setupinfo/httpd/interim/virtual1.conf";

                Runtime run = Runtime.getRuntime();
                NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
                proc.waitFor();
                if (proc.exitValue() == 0){
                    InputStreamReader read = new InputStreamReader(proc.getInputStream());
                    BufferedReader buf = new BufferedReader(read);
                    if (buf !=null){
                        String line = buf.readLine();
                        while (line != null) {
                            if (line.trim().startsWith(VIRTUAL_HOST_BEGIN)){
                                StringTokenizer st = new StringTokenizer(line);
                                if (st.countTokens() == 2){
                                    st.nextToken();
                                    String tempName = new String(st.nextToken());
                                    tempName = tempName.substring(0,tempName.length()-1);
                                    nickNames.add(tempName);
                                }
                            }
                            line = buf.readLine();
                        }
                    }
                }
                
                for (int i=0; i<nickNames.size(); i++){
                    HTTPServerInfo virtualHostInfo = getServerInfo4Viewer(node, "virtualHost", (String)nickNames.get(i));
                    virtualHost.add(virtualHostInfo);
                }
            } else{
                infoContainer.setSuccessful(false);
                infoContainer.setErrorCode(mainServer.getErrorCode());
                infoContainer.setErrorMessage(mainServer.getErrorMessage());
                return infoContainer;
            }
        } else{
            infoContainer.setSuccessful(false);
            infoContainer.setErrorCode(basicInfo.getErrorCode());
            infoContainer.setErrorMessage(basicInfo.getErrorMessage());
            return infoContainer;
        }

        infoContainer.setBasicInfo(basicInfo);
        infoContainer.setMainServer(mainServer);
        infoContainer.setVirtualHosts(virtualHost);
        return infoContainer;
    }


    public HTTPBasicInfo getBasicInfo4Viewer(String node) throws Exception {
        HTTPBasicInfo basicInfo = new HTTPBasicInfo();

        //basicInfo.setServiceStatus(getServiceStatus());
        String fileName = "/etc/group"+node+".setupinfo/httpd/interim/httpd.conf";

        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if ( proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
                String line = buf.readLine();
                while (line != null && !line.trim().startsWith(BASIC_CONFIG_BEGIN)){
                     line = buf.readLine();
                }
                line = buf.readLine();
                StringBuffer sb=new StringBuffer("");
                while (line != null){
                    if (line.trim().startsWith(BASIC_CONFIG_END )){
                        break;
                    }
                    if (line.trim().startsWith(LISTEN)){
                        StringTokenizer st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            sb.append(st.nextToken());
                            sb.append(" ");
                        }
                    }
                    if (line.trim().equals(HTTP + " yes")) {
                        basicInfo.setServiceStatus(true);
                    }
                    if (line.trim().equals(HTTP + " no")) {
                        basicInfo.setServiceStatus(false);
                    }
                    line = buf.readLine();
                }
                if (!(sb.toString().trim()).equals("")){
                   basicInfo.setPorts(sb.toString().trim());
                }
                if (getServiceStatus()){
                    basicInfo.setHttpdStatus(true);
                } else{
                    basicInfo.setHttpdStatus(false);
                }
            }
        }

        getSelectableFunctions(basicInfo);
        if (basicInfo.isSuccessful()) {
            getDefaultOptions(basicInfo);
        }
        return basicInfo;
    }

    public HTTPServerInfo getServerInfo4Viewer(String node, String serverType, String virtualNickName) throws Exception {
        HTTPServerInfo serverInfo = new HTTPServerInfo();
        boolean isVirtualServer = serverType.equals("virtualHost")?true:false;
        Map directoryMap = new TreeMap();

        String fileName;
        if (node.equals("0") && isVirtualServer){
            fileName = "/etc/group0.setupinfo/httpd/interim/virtual0.conf";
        } else if (!node.equals("0") && isVirtualServer){
            fileName = "/etc/group1.setupinfo/httpd/interim/virtual1.conf";
        } else if (node.equals("0") && !isVirtualServer){
            fileName = "/etc/group0.setupinfo/httpd/interim/main0.conf";
        } else{
            fileName = "/etc/group1.setupinfo/httpd/interim/main1.conf";
        }
        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if (proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
                String tag_begin = serverType.equals("mainServer")?MAIN_SERVER_BEGIN:VIRTUAL_HOST_BEGIN + virtualNickName + ">";
                String tag_end = serverType.equals("mainServer")?MAIN_SERVER_END:VIRTUAL_HOST_END;
                String line = buf.readLine();
                StringTokenizer st;
                while (line != null && !line.trim().equals(tag_begin)){
                    line = buf.readLine();
                }
                if (line != null && isVirtualServer){
                    st = new StringTokenizer(line);
                    if (st.countTokens() == 2){
                        st.nextToken();
                        String tempName = st.nextToken();
                        tempName = tempName.substring(0,tempName.length()-1);
                        serverInfo.setNickName(tempName);
                        }
                }
                line = buf.readLine();

                while (line != null) {
                    if (line.trim().startsWith(tag_end)){
                        break;
                    }
                    if (isVirtualServer && line.trim().startsWith(NAME_VIRTUAL_HOST)){
                        serverInfo.setVirtualHostType(VIRTUALHOSTMOD_NAME_BASED);
                        line = buf.readLine();
                        continue;
                    }
                    if (isVirtualServer && line.trim().startsWith(HOST_BEGIN)){
                        st = new StringTokenizer(line.substring(0,line.length()-1));
                        if (st.countTokens() == 2) {
                            st.nextToken();
                            String tempIP = st.nextToken();
                            if (!tempIP.equals("*")) {
                                serverInfo.setUsedIPAddrsMode(USEDIPADDRSMODE_CUSTOM);
                                serverInfo.setUsedIPAddrs(tempIP);
                            }
                        } else if (st.countTokens() >= 3){
                            st.nextToken();
                            StringBuffer sb = new StringBuffer("");
                            while (st.hasMoreTokens()){
                                sb.append(st.nextToken());
                                sb.append(" ");
                            }
                            serverInfo.setUsedIPAddrsMode(USEDIPADDRSMODE_CUSTOM);
                            serverInfo.setUsedIPAddrs(sb.toString().trim());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(DOCUMENTROOT)){
                        serverInfo.setDocumentRoot(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(SERVERNAME)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setServerName(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(SERVERADMIN)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setServerAdmin(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USER_UNIX_NAME)){
                        serverInfo.setUnixUserName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USER_UNIX_ID)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setUnixUserID(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(GROUP_UNIX_NAME)){
                        serverInfo.setUnixGroupName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(GROUP_UNIX_ID)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setUnixGroupID(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USER_WINDOWS_NAME)){
                        serverInfo.setWindowsUserName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(GROUP_WINDOWS_NAME)){
                        serverInfo.setWindowsGroupName(getTheContent(line, true));
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(TRANSFERLOG)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            String tempTranLog = st.nextToken();
                            if (tempTranLog.equals(TRANSFERLOGMODE_STANDARD)){
                                serverInfo.setTransferLogMode(tempTranLog);
                            } else{
                                serverInfo.setTransferLogMode(TRANSFERLOGMODE_CUSTOM);
                                serverInfo.setTransferLogLocation(tempTranLog);
                            }
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(CUSTOMLOG)){
                        serverInfo.setCustomLogAllowed(true);
                        st = new StringTokenizer(line);
                        if (st.countTokens() > 2){
                            st.nextToken();
                            serverInfo.setCustomLogFileName(st.nextToken());
                            st.nextToken("\"");
                            serverInfo.setCustomLogFormat(st.nextToken("\""));
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(ERRORLOG)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            String tempErrorLog = st.nextToken();
                            if (tempErrorLog.equals(ERRORLOGMODE_STANDARD) ||
                                tempErrorLog.equals(ERRORLOGMODE_SYSLOG)){
                                serverInfo.setErrorLogMode(tempErrorLog);
                            } else{
                                serverInfo.setErrorLogMode(ERRORLOGMODE_CUSTOM);
                                serverInfo.setErrorLogLocation(tempErrorLog);
                            }
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(LOGLEVEL)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setErrorLogLevel(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(ACCESSFILENAME)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2){
                            st.nextToken();
                            serverInfo.setAccessFileName(st.nextToken());
                        }
                        line = buf.readLine();
                        continue;
                    }
                    if (line.trim().startsWith(USERDIR)){
                        st = new StringTokenizer(line);
                        if (st.countTokens() == 2) {
                            st.nextToken();
                            String tempDirAllowed = st.nextToken();
                            if (tempDirAllowed.equals(DIR_DISABLE)) {
                                line = buf.readLine();
                                if (line != null && line.trim().startsWith(USERDIR)) {
                                     serverInfo.setUserDirAllowed(true);
                                     serverInfo.setUserDirMode(DIR_ENABLE_ONLY);  
                                     serverInfo.setUserDirUserList(getTheContent(getTheContent(line, false), false));
                                     line = buf.readLine();
                                     serverInfo.setUserDirPattern(getTheContent(line, true));
                                     line = buf.readLine();
                                } else {
                                    serverInfo.setUserDirAllowed(false);
                                }
                            } else {
                                serverInfo.setUserDirAllowed(true);
                                serverInfo.setUserDirMode(DIR_ENABLE);
                                serverInfo.setUserDirPattern(getTheContent(line, true));
                                line = buf.readLine();
                            }
                            
                        } else if (st.countTokens() >= 3) {
                            serverInfo.setUserDirAllowed(true);
                            st.nextToken();
                            String tempDirAllowed = st.nextToken();
                            if (!tempDirAllowed.equals(DIR_DISABLE)&& !tempDirAllowed.equals(DIR_ENABLE)){
                                serverInfo.setUserDirMode(DIR_ENABLE);
                                serverInfo.setUserDirPattern(getTheContent(line, true));
                            } else {
                                if (tempDirAllowed.equals(DIR_DISABLE)) {
                                    serverInfo.setUserDirMode(DIR_DISABLE_ONLY);
                                } else if (tempDirAllowed.equals(DIR_ENABLE)){
                                    serverInfo.setUserDirMode(DIR_ENABLE_ONLY);
                                }
                                
                                serverInfo.setUserDirUserList(getTheContent(getTheContent(line, false), false));
                                line = buf.readLine();
                                if (line.trim().startsWith(USERDIR)){                      
                                   serverInfo.setUserDirPattern(getTheContent(line, true));
                                }
                            }
                            line = buf.readLine();
                        }
                        continue;
                    }
                    if (line.trim().startsWith(DIRECTORY_BEGIN)){
                        String tempDir = this.getTheContent(line.trim(), false);
                        if (tempDir.trim().startsWith("\"")){
                            directoryMap.put(tempDir.substring(1, tempDir.length()-2), "");
                        } else {
                            directoryMap.put(tempDir.substring(0, tempDir.length()-1), "");
                        }
                        line = buf.readLine();
                        continue;
                    }
                    line = buf.readLine();
                }
            }

        }
        serverInfo.setDirectoryMap(directoryMap);
        return serverInfo;
    }

    
    
    
    private SoapResponse setDirectoryInfo(String node, String serverType,
                                     Map directoryMap, String nickName) throws Exception{
        SoapResponse trans = new SoapResponse();

        String fnode = ClusterSOAPServer.getMyNumber();
        String[] cmds;
        boolean isVirtualHost = serverType.equals("virtualHost")?true:false;

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

        Iterator dirKeys = directoryMap.keySet().iterator();
        while (dirKeys.hasNext()){
            String directory = (String)dirKeys.next();
            HTTPDirectoryInfo directoryInfo = (HTTPDirectoryInfo)directoryMap.get(directory);
            directoryInfo.setDirectory("\""+directoryInfo.getDirectory()+"\"");
            directory = "\"" + directory + "\"";
            if(directoryInfo.getDirectory().equals("\""+HTTPConstants.NO_DIRECTORY+"\"")){
                cmds = new String[8];
                cmds[0] = SUDO_COMMAND;
                cmds[1] = home + SET_DIRECTORY_INFO;
                cmds[2] = fnode;
                cmds[3] = node;
                if (isVirtualHost){
                    cmds[4] = "VirtualHostConfig";
                    cmds[5] = nickName;
                    cmds[6] = "DELETE";
                    cmds[7] = directory.trim();
                } else{
                    if (!node.equals(fnode)) {
                        cmds[4] = "MainServerConfig";
                        cmds[5] = nickName;
                        cmds[6] = "DELETE";
                        cmds[7] = directory.trim();
                    } else {
                        cmds[4] = "MainServerConfig";
                        cmds[5] = "DELETE";
                        cmds[6] = directory.trim();
                        cmds[7] = "";
                    }
                }
            } else{
                Vector cmdsVec = new Vector();
                //HTTPDirectoryInfo directoryInfo = (HTTPDirectoryInfo)directoryMap.get(directory);
                cmdsVec.add(SUDO_COMMAND);
                cmdsVec.add(home + SET_DIRECTORY_INFO);
                cmdsVec.add(fnode);
                cmdsVec.add(node);
                if (isVirtualHost){
                    cmdsVec.add("VirtualHostConfig");
                    cmdsVec.add(nickName);
                } else {
                    cmdsVec.add("MainServerConfig");
                    if (!fnode.equals(node)){
                        cmdsVec.add(nickName);
                    }
                }
                if (directoryInfo.getDirectory().equals("\"\"")){
                    cmdsVec.add("ADD");
                    cmdsVec.add("");
                } else{
                    cmdsVec.add("MODIFY");
                    cmdsVec.add(directoryInfo.getDirectory());
                }
                cmdsVec.add(directory);
                if (directoryInfo.getDirectoryAccessMode().equals(ALL_ALLOW)){
                    cmdsVec.add(ORDER_ALLOW_DENY);
                    cmdsVec.add(ALL_ALLOW);
                } else{
                    if (directoryInfo.getDirectoryAccessMode().equals(ORDER_ALLOW_DENY)){
                        cmdsVec.add(ORDER_ALLOW_DENY);
                    } else{
                        cmdsVec.add(ORDER_DENY_ALLOW);
                    }
                    String allowList = directoryInfo.getDirectoryAccessAllowList().trim();
                    if (!allowList.equals("")){
                        cmdsVec.add(ALLOW_FROM+allowList);
                    }
                    String denyList = directoryInfo.getDirectoryAccessDenyList().trim();
                    if (!denyList.equals("")){
                        cmdsVec.add(DENY_FROM+denyList);
                    }
               }
               Map dynamicInfo = directoryInfo.getDynamicInfo();
               Iterator keyList = dynamicInfo.keySet().iterator();
               while (keyList.hasNext()){
                    String tempKey = (String)keyList.next();
                    cmdsVec.add(tempKey+" "+dynamicInfo.get(tempKey));
               }
               cmds = (String[])cmdsVec.toArray(new String[0]);
            }

            SOAPServerBase.execCmd(getSubStrArray(cmds, 0, 1), trans, cmdErrHandler, getSubStrArray(cmds, 2, cmds.length-1));
            if (!trans.isSuccessful()){
                return trans;
            }
        }
        trans.setSuccessful(true);
        return trans;
    }

    private void getSelectableFunctions(HTTPBasicInfo basicInfo) {

        String cmds[] = new String[5];
        cmds[0] = SUDO_COMMAND;
        cmds[1] = home + GET_DYNAMIC_SCRIPT;
        cmds[2] = ClusterSOAPServer.getMyNumber();
        cmds[3] = "BasicConfig";
        cmds[4] = "selectable_functions";


        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(read);
                String line;
                StringBuffer xmlStringbuf = new StringBuffer();
                line = buf.readLine();
                while (line != null){
                    xmlStringbuf.append(line);
                    xmlStringbuf.append("\n");
                    line = buf.readLine();
                }
               ((HTTPBasicInfo)rps).setSelectableFunctions(xmlStringbuf.toString());
            }
        };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

        SOAPServerBase.execCmd(cmds, basicInfo, cmdHandler, cmdErrHandler);

    }

    private void getDefaultOptions(HTTPBasicInfo basicInfo) {

        String cmds[] = new String[5];
        cmds[0] = SUDO_COMMAND;
        cmds[1] = home + GET_DYNAMIC_SCRIPT;
        cmds[2] = ClusterSOAPServer.getMyNumber();
        cmds[3] = "BasicConfig";
        cmds[4] = "default_options_exports";

        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(read);
                String line;
                StringBuffer xmlStringbuf = new StringBuffer();
                line = buf.readLine();
                while (line != null){
                    xmlStringbuf.append(line);
                    xmlStringbuf.append("\n");
                    line = buf.readLine();
                }
               ((HTTPBasicInfo)rps).setDefaultOptions(xmlStringbuf.toString());
            }
        };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

        SOAPServerBase.execCmd(cmds, basicInfo, cmdHandler, cmdErrHandler);

    }


    private void getDirectoryOptions(String nickName, String directory,
                                        HTTPDirectoryInfo directoryInfo, boolean isVirtualHost) {
       /*
        StringBuffer cmdsbuf = new StringBuffer();
        cmdsbuf.append(SUDO_COMMAND);
        cmdsbuf.append(" ");
        cmdsbuf.append(home + GET_DYNAMIC_SCRIPT);
        cmdsbuf.append(" ");
        cmdsbuf.append(ClusterSOAPServer.getMyNumber());
        cmdsbuf.append(" ");
        if (isVirtualHost){
            cmdsbuf.append("VirtualHostConfig");
            cmdsbuf.append(" ");
            cmdsbuf.append("directory_options");
            cmdsbuf.append(" ");
            cmdsbuf.append(nickName);
            cmdsbuf.append(" ");
            cmdsbuf.append(directory);
        } else{
            cmdsbuf.append("MainServerConfig");
            cmdsbuf.append(" ");
            cmdsbuf.append("directory_options");
            cmdsbuf.append(" ");
            cmdsbuf.append(directory);
        }
        String cmds = cmdsbuf.toString();
        */
        /*2003-10-21 add by xinghui ,caoyh*/
        Vector vCmd = new Vector();
        vCmd.add(SUDO_COMMAND);
        vCmd.add(home + GET_DYNAMIC_SCRIPT);
        vCmd.add(ClusterSOAPServer.getMyNumber());
        if (isVirtualHost){
            vCmd.add("VirtualHostConfig");
            vCmd.add("directory_options");
            vCmd.add(nickName);
            vCmd.add(directory);
        }else{
            vCmd.add("MainServerConfig");
            vCmd.add("directory_options");
            vCmd.add(directory);
        }
        String [] cmds = new String[vCmd.size()];
        vCmd.toArray(cmds);

        /*end */
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(read);
                String line;
                StringBuffer xmlStringbuf = new StringBuffer();
                line = buf.readLine();
                while (line != null){
                    xmlStringbuf.append(line);
                    xmlStringbuf.append("\n");
                    line = buf.readLine();
                }
               ((HTTPDirectoryInfo)rps).setDirectoryOptions(xmlStringbuf.toString());
            }
        };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

        SOAPServerBase.execCmd(cmds, directoryInfo, cmdHandler, cmdErrHandler);
    }

    private void getAllowOptions(String nickName, String directory,
                                      HTTPDirectoryInfo directoryInfo, boolean isVirtualHost) {
/*
        StringBuffer cmdsbuf = new StringBuffer();
        cmdsbuf.append(SUDO_COMMAND);
        cmdsbuf.append(" ");
        cmdsbuf.append(home + GET_DYNAMIC_SCRIPT);
        cmdsbuf.append(" ");
        cmdsbuf.append(ClusterSOAPServer.getMyNumber());
        cmdsbuf.append(" ");
        if (isVirtualHost){
            cmdsbuf.append("VirtualHostConfig");
            cmdsbuf.append(" ");
            cmdsbuf.append("allow_override_options");
            cmdsbuf.append(" ");
            cmdsbuf.append(nickName);
            cmdsbuf.append(" ");
            cmdsbuf.append(directory);
        } else{
            cmdsbuf.append("MainServerConfig");
            cmdsbuf.append(" ");
            cmdsbuf.append("allow_override_options");
            cmdsbuf.append(" ");
            cmdsbuf.append(directory);
        }
        String cmds = cmdsbuf.toString();
*/
/*add begin*/
        Vector vCmd = new Vector();
        vCmd.add(SUDO_COMMAND);
        vCmd.add(home + GET_DYNAMIC_SCRIPT);
        vCmd.add(ClusterSOAPServer.getMyNumber());

        if (isVirtualHost){
            vCmd.add("VirtualHostConfig");
            vCmd.add("allow_override_options");
            vCmd.add(nickName);
            vCmd.add(directory);
        } else {

            vCmd.add("MainServerConfig");
            vCmd.add("allow_override_options");
            vCmd.add(directory);
        }
        String [] cmds = new String[vCmd.size()];
        vCmd.toArray(cmds);
/*add end*/
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(read);
                String line;
                StringBuffer xmlStringbuf = new StringBuffer();
                line = buf.readLine();
                while (line != null){
                    xmlStringbuf.append(line);
                    xmlStringbuf.append("\n");
                    line = buf.readLine();
                }
               ((HTTPDirectoryInfo)rps).setAllowOverwriteOptions(xmlStringbuf.toString());
            }
        };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
                trans.setSuccessful(false);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
        };

        SOAPServerBase.execCmd(cmds, (SoapResponse)directoryInfo, cmdHandler, cmdErrHandler);
    }

    /**
     * Get the current service's status
     * @param none
     * @Returns true if the status is on; false if the status is off.
     */
    private boolean getServiceStatus() throws Exception{

        SoapResponse trans  = new SoapResponse();
        String cmds = SUDO_COMMAND + " " + GET_SERVICE_STATUS;

        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                rps.setSuccessful(true);
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        if(trans.isSuccessful())
            return true;
        else
            return false;

    }

    private SoapResponse setService() throws Exception{

        SoapResponse trans  = new SoapResponse();

        String[] cmds = {SUDO_COMMAND,
                        COMMAND_NEC_HTTPD_CONFIG,
                        RESTART_SERVICE};

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception{
            trans.setSuccessful(false);
            trans.setErrorCode(proc.exitValue());
            trans.setErrorMessage(
                            "Exec command failed! Command = "+ cmds[1]+"\n"
                            +SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }
        };

        SOAPServerBase.execCmd(cmds , trans, cmdErrHandler);
        return trans;
    }


    private String getAccessList(String listString) throws Exception{
        StringBuffer sb = new StringBuffer("");
        StringTokenizer st = new StringTokenizer(listString);
        st.nextToken();
        st.nextToken();
        while (st.hasMoreTokens()){
            sb.append(st.nextToken());
            sb.append(" ");
       }
       return sb.toString().trim();
    }

    private void addKV(Vector vec, String key, String value) {
        String str = value;
        if (str != null && !(str.replaceAll("\"","").trim()).equals("")) {
            vec.add(key + value);
        }
    }

    private SoapRpsString getNickName(String serverName) throws Exception {
        SoapRpsString trans  = new SoapRpsString();
        if (serverName!=null && !serverName.equals("")) {
               trans.setSuccessful(true);
               trans.setString(serverName);
               return trans;
        }
        String [] cmds = {SUDO_COMMAND,"/bin/hostname","-f"};
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                SoapRpsString trans = (SoapRpsString)rps;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result = buf.readLine().trim();
                trans.setString(result);
                trans.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }

    private String getOldMainServerName(String node) throws Exception {
        String fileName = "/tmp/main"+node+".conf";
        Runtime run = Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(SUDO_COMMAND + " " + home + READ_FILE + " " + fileName));
        proc.waitFor();
        if (proc.exitValue() == 0){
            InputStreamReader read = new InputStreamReader(proc.getInputStream());
            BufferedReader buf = new BufferedReader(read);
            if (buf !=null){
                String line = buf.readLine();
                while (line != null) {
                    StringTokenizer st = new StringTokenizer(line);
                    String k = "";
                    if (st.hasMoreTokens()){
                        k = st.nextToken();
                    }
                    if (k.equals(SERVERNAME.trim())){
                        return st.nextToken().trim();
                    }
                    line = buf.readLine();
                }
            }
        }
        return "";
    }

    private String getTheContent(String line, boolean delQuot) throws Exception {
        int start = line.indexOf(" ")+1;
        int end = line.length();
        String s = line.substring(start,end);
        if (delQuot){
            if (s.trim().startsWith("\"")) {
                s = s.substring(1,s.length()-1);
            }
        }
        return s;
    }

    public SoapRpsVector getDir(String path, String flag) throws Exception{
        SoapRpsVector trans = new SoapRpsVector();

        String home  =  System.getProperty("user.home");
/*
        String cmds = SUDO_COMMAND+ " " +home+SCRIPT_DIR+SCRIPT_HTTP_GET_DIR+ " " +ClusterSOAPServer.getEtcPath()+
            " "+ ClusterSOAPServer.getImsPath() +" "+path+" "+ flag;
*/
        String[] cmds = {SUDO_COMMAND,
                         home+SCRIPT_DIR+SCRIPT_HTTP_GET_DIR,
                         ClusterSOAPServer.getEtcPath(),
                         ClusterSOAPServer.getImsPath(),
                         path,
                         flag};

        CmdHandler cmdHandler = new CmdHandler(){
           public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                Vector subDir = new Vector();
                SoapRpsVector trans=(SoapRpsVector)rps;
                    InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                    BufferedReader buf = new BufferedReader(bufReader);
                    String result=buf.readLine();
                    for(;result!=null;){
                        subDir.add(result);
                        result = buf.readLine();
                    }
                    trans.setVector(subDir);
                    return;
            }
        };

        CmdErrHandler errHandler = new CmdErrHandler(){
           public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsVector ret=(SoapRpsVector)rps;
                ret.setSuccessful(false);
                if(proc.exitValue()==ERROR_DIR_NOT_EXISTS){
                    ret.setErrorCode(NAS_EXCEP_NO_NFS_NAVIGATOR_DIR_NOT_EXISTS);
                }else {
                    ret.setErrorCode(NAS_EXCEP_NO_CMD_FAILED);
                }
                CmdHandlerBase.setCmdErrorMessage(ret, proc, cmds);
            }
        };

        SOAPServerBase.execCmd(cmds,trans,cmdHandler,errHandler);
        return trans;
    }
    private String[] getSubStrArray(String[] vec, int fromIndex, int toIndex) {
        Vector newVec = new Vector();
        for(int i=fromIndex; i<=toIndex; i++){
            newVec.add(vec[i]);
        }
        return (String[])newVec.toArray(new String[0]);
    }
}