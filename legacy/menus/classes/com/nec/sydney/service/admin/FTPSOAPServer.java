/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      @(#) $Id: FTPSOAPServer.java,v 1.2309 2008/12/23 05:11:39 gaozf Exp $
 */

package com.nec.sydney.service.admin;

import java.util.*;
import java.io.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.atom.admin.ftp.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;

public class FTPSOAPServer implements NasConstants,NSExceptionMsg,FTPConstants{

    private static String nodeNo = ClusterSOAPServer.getMyNumber();
    private static final String     cvsid = "@(#) $Id: FTPSOAPServer.java,v 1.2309 2008/12/23 05:11:39 gaozf Exp $";
    private static final String FTP_SCRIPT_SET_BASEINFO = "/bin/ftp_setBaseInfo.pl";
    private static final String FTP_SCRIPT_WRITTING_PROFTPDAUTH_FILE = "/bin/ftp_setproftpdauth.pl";
    private static final String FTP_SCRIPT_WRITTING_PROFTPD_FILE = "/bin/ftp_setproftpd.pl";
    private static final String FTP_SCRIPT_SET_MANAGELAN_STATUS = "/bin/ftp_setManageLAN.pl";
    private static final String FTP_SCRIPT_SET_FTP_STATUS = "/bin/ftp_setFTPConf.pl";

    private static final String FTP_SCRIPT_SET_PWD_AUTH = "/bin/ftp_setPwdInfo.pl";
    private static final String FTP_SCRIPT_SET_NIS_AUTH = "/bin/ftp_setNisInfo.pl";
    private static final String FTP_SCRIPT_SET_PDC_AUTH = "/bin/ftp_setPdcInfo.pl";
    private static final String FTP_SCRIPT_SET_LDAP_AUTH = "/bin/ftp_setLdapInfo.pl";
    private static final String FTP_SCRIPT_LDAP_SMBCONF_UPDATE = "/bin/ftp_ldapSmbConfUpdate.pl";

    private static final String FTP_SCRIPT_CLOSE_ORI_PASSIVE = "/bin/ftp_closeOriginPassive.pl";
    private static final String FTP_SCRIPT_CLOSE_PASSIVE = "/bin/ftp_closePassive.pl";
    private static final String FTP_SCRIPT_OPEN_PASSIVE = "/bin/ftp_openPassive.pl";

    private static final String FTP_SCRIPT_GET_FTP_INFO = "/bin/ftp_getbaseinfo.pl";
    //gaozf 200812 start
    private static final String FTP_SCRIPT_GET_FRIEND_FTP_SERVICE="/bin/ftp_getFriendFTPService.pl";
    //end
    private static final String FTP_SCRIPT_GET_FTP_AUTH_INFO = "/bin/ftp_getauthinfo.pl";
    private static final String FTP_SCRIPT_GET_FTP_SERVICE_STATUS = "/bin/ftp_getFTPServiceStatus.pl";
    private static final String FTP_SCRIPT_SET_CLIENTLIST_MODE = "/bin/ftp_setClientListMode.pl";

    private static final String FTP_CMD_SET_FTP = "/usr/sbin/ftp_mkcnf";


    private static final int        FAILED_TO_GET_TEMPFILE = 10;
    private static final int        FAILED_TO_RUN_IPTABLES = 20;
    private static final int        FAILED_TO_WRITE_FILE = 30;
    private static final int        FAILED_TO_STATUS_CHANGED = 40;

    private static final String FTP_PROFTPD_BASE_FILE_NAME = "/etc/group"+nodeNo+".setupinfo/ftpd/proftpd.conf." + nodeNo;
    private static final String FTP_PROFTPD_BASE_DIR_NAME = "/etc/group"+nodeNo+".setupinfo/ftpd/";
    private static final String FTP_PROFTPD_AUTH_FILE_NAME = "/etc/group"+nodeNo+".setupinfo/ftpd/proftpd_auth.conf";

    //constructor
    public void FTPSOAPServer(){}


    public SoapResponse closeOriginPassive(String groupNo) throws Exception{
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        String cmd = COMMAND_SUDO +" "+home+ FTP_SCRIPT_CLOSE_ORI_PASSIVE +" " + nodeNo +" " + groupNo;
        SOAPServerBase.execCmd(cmd, trans);
        return trans;
    }

    public SoapResponse initFTPConf(String groupNo) throws Exception{
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO,
                          home + FTP_SCRIPT_WRITTING_PROFTPD_FILE,
                          nodeNo,
                          groupNo
                        };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                rps.setErrorCode(FTP_EXCEP_WRITE_FILE_FAILED);
                rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdErrHandler);

        return trans;
    }

    public SoapResponse execFTPmkcnf(String groupNo) throws Exception{
        SoapResponse trans = new SoapResponse();
        String cmd = COMMAND_SUDO +" "+ FTP_CMD_SET_FTP +" " + groupNo;

        SOAPServerBase.execCmd(cmd, trans);

        if(!trans.isSuccessful()){
            trans.setErrorCode(FTP_EXCEP_EXEC_FTPMKCNF_FAILED);
        }
        return trans;
    }

    public SoapResponse setServiceStatus(FTPInfo ftpinfo) throws Exception{
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");

        String cmd = SUDO_COMMAND+" "+ home + FTP_SCRIPT_SET_FTP_STATUS + " " + ftpinfo.isUseFTPService();
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                if( proc.exitValue() == FAILED_TO_STATUS_CHANGED){
                    rps.setErrorCode(FTP_EXCEP_STATUS_CHANGED_FAILED);
                }else{
                    rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdErrHandler);


        return trans;

    }

    public SoapResponse setPassivePorts(FTPInfo ftpinfo,String groupNo) throws Exception{
        SoapResponse trans = new SoapResponse();
        String home = System.getProperty("user.home");

        if (ftpinfo.isUseFTPService()==true){ // if use ftpservice
            //open passsive
            String[] cmds ={ COMMAND_SUDO ,
                    home+ FTP_SCRIPT_OPEN_PASSIVE,
                    ftpinfo.getPassivePortStartNumber(),
                    ftpinfo.getPassivePortEndNumber()
                  };
            SOAPServerBase.execCmd(cmds, trans);
        }
        else{
            //close passsive
            String[] cmds = { COMMAND_SUDO,
                      home+ FTP_SCRIPT_CLOSE_PASSIVE,
                      nodeNo,
                      groupNo
                   };
            SOAPServerBase.execCmd(cmds, trans);
        }

        return trans;


    }
    /**set auth and writing file
    *@param:ftpAuthinfo
    *@return SoapResponse
    */
    public SoapResponse setAuthInfo(FTPAuthInfo ftpAuthinfo, String groupNo) throws Exception
    {
        SoapResponse trans=new SoapResponse();
        String home = System.getProperty("user.home");


        if (ftpAuthinfo.getAuthDBType().equals(AUTH_DBTYPE_PWD)){
            String[] cmds = { COMMAND_SUDO,
                              home + FTP_SCRIPT_SET_PWD_AUTH,
                              ftpAuthinfo.getLudbName(),
                              nodeNo,
                              groupNo};

            SOAPServerBase.execCmd(cmds, trans);

        }
        else if (ftpAuthinfo.getAuthDBType().equals(AUTH_DBTYPE_NIS)){
            String[] cmds = { COMMAND_SUDO,
                              home + FTP_SCRIPT_SET_NIS_AUTH,
                              ftpAuthinfo.getNisNetwork(),
                              ftpAuthinfo.getNisDomain(),
                              ftpAuthinfo.getNisServer(),
                              nodeNo,
                              groupNo};

            SOAPServerBase.execCmd(cmds, trans);
        }
        else if (ftpAuthinfo.getAuthDBType().equals(AUTH_DBTYPE_PDC)){
            String[] cmds = { COMMAND_SUDO,
                              home + FTP_SCRIPT_SET_PDC_AUTH,
                              ftpAuthinfo.getPdcDomain(),
                              ftpAuthinfo.getPdcName(),
                              ftpAuthinfo.getBdcName(),
                              nodeNo,
                              groupNo};

            SOAPServerBase.execCmd(cmds, trans);
        }
        else if (ftpAuthinfo.getAuthDBType().equals(AUTH_DBTYPE_LDAP)){
            String[] cmds = { COMMAND_SUDO,
                              home + FTP_SCRIPT_SET_LDAP_AUTH,
                              ftpAuthinfo.getLdapServer(),
                              ftpAuthinfo.getLdapBaseDN(),
                              ftpAuthinfo.getLdapMethod(),
                              ftpAuthinfo.getLdapBindName(),
                           //   ftpAuthinfo.getLdapBindPasswd(),
                              ftpAuthinfo.getLdapCertFile(),
                              ftpAuthinfo.getLdapCertDir(),
                              ftpAuthinfo.getLdapUseTls(),
                              ftpAuthinfo.getUserFilter(),
                              ftpAuthinfo.getGroupFilter(),
                              ftpAuthinfo.getUtoa(), //add by liq at 11.8
                              ftpAuthinfo.getLdapUserInput(),
                              nodeNo,
                              groupNo,
                              "FTP"};
            String[] inputs={ftpAuthinfo.getLdapBindPasswd()};
            SOAPServerBase.execCmd(cmds, trans, inputs);
            if(trans.isSuccessful()){
                String[] cmds_updateSmbConf = { COMMAND_SUDO,
                              home + FTP_SCRIPT_LDAP_SMBCONF_UPDATE,
                              ClusterSOAPServer.getEtcPath()+"nas_cifs/DEFAULT",// "/etc/group[0|1]/nas_cifs/DEFAULT"
                              ftpAuthinfo.getLdapServer(),
                              ftpAuthinfo.getLdapUseTls(),
                              ftpAuthinfo.getLdapBindName(),//ldap admin dn = "cn=Manager,dc=example,dc=com"
                              ftpAuthinfo.getLdapBaseDN(),//ldap suffix = dc=example,dc=com
                              ftpAuthinfo.getUserFilter(),
                              ftpAuthinfo.getLdapMethod(),//ldap bind = simple | sasl_dmd5 | sasl_cmd5
                              ftpAuthinfo.getLdapCertFile()};
                SOAPServerBase.execCmd(cmds_updateSmbConf, trans, inputs);
            }
        }
        try{
            SoapRpsFTPAuthInfo rps= (SoapRpsFTPAuthInfo)getAuthInfo(groupNo);
            FTPAuthInfo old_auth = rps.getInfo();

            if(! old_auth.getLdapServer().equals("")){
                String[] cmds = {home + "/bin/mapd_deliptable.pl",
                                old_auth.getLdapServer(),
                                nodeNo};

                SOAPServerBase.execCmd(cmds,new SoapResponse() );
            }
        }catch(Exception e){

        }
        return trans;

    }

    /**get ftp  base info
    *@param: none
    *@return SoapRpsFTPInfo
    */

    public SoapRpsFTPInfo getBaseInfo(String groupNo) throws Exception{
        SoapRpsFTPInfo trans=new SoapRpsFTPInfo();
        String home        = System.getProperty("user.home");
        String[] cmd        = {COMMAND_SUDO,
                               home+FTP_SCRIPT_GET_FTP_INFO,
                               nodeNo,
                               groupNo};
        
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsFTPInfo rpsFTPInfo = (SoapRpsFTPInfo)rps;
                BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));

                FTPInfo result = new FTPInfo();

                result.setUseFTPService(inputStr.readLine().equalsIgnoreCase("yes"));

                result.setPortNumber(inputStr.readLine().trim());
                result.setPassivePortStartNumber(inputStr.readLine().trim());
                result.setPassivePortEndNumber(inputStr.readLine().trim());
                result.setBasMaxConnections(inputStr.readLine().trim());
//shench 2008.12.3 start
                result.setBasIdentdMode (inputStr.readLine().trim());
//end shench
                result.setBasAccessMode(inputStr.readLine().trim());
                result.setBasClientMode (inputStr.readLine().trim());
                result.setBasClientList (inputStr.readLine().trim());
                if (inputStr.readLine().equalsIgnoreCase("false"))
                    result.setBasUseManageLAN (false);
                else
                    result.setBasUseManageLAN (true);
                result.setAuthDBType (inputStr.readLine().trim());
                result.setAuthAccessType (inputStr.readLine().trim());
//                result.setAuthUserList (inputStr.readLine().trim());
                result.setAuthUserList (inputStr.readLine());
                result.setAuthUserMappingMode (inputStr.readLine().trim());
//              result.setAuthAnonUserName (inputStr.readLine().trim());
                result.setAuthAnonUserName (inputStr.readLine());
                result.setHomeDirMode (inputStr.readLine().trim());
//xinghui ,2003-10-18                result.setHomeDirName (inputStr.readLine().trim());
                result.setHomeDirName (inputStr.readLine());
                if (inputStr.readLine().equalsIgnoreCase("false"))
                    result.setUseAnonFTP (false);
                else
                    result.setUseAnonFTP (true);
//xinghui, 2003-10-18                result.setAnonFTPDir (inputStr.readLine().trim());
                result.setAnonFTPDir (inputStr.readLine());
                result.setAnonMaxConnections (inputStr.readLine().trim());
                result.setAnonAccessMode (inputStr.readLine().trim());
                result.setAnonClientMode (inputStr.readLine().trim());
                result.setAnonClientList (inputStr.readLine().trim());
                result.setAnonUserName (inputStr.readLine());
                result.setAnonGroupName (inputStr.readLine());
                rpsFTPInfo.setFTPInfo(result);
                rpsFTPInfo.setSuccessful(true);
            }//end cmdHandle
        };//end of new CmdHandler

        CmdErrHandler errHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                rps.setSuccessful(false);

                if( proc.exitValue() == FAILED_TO_GET_TEMPFILE){
                    rps.setErrorCode(FTP_EXCEP_GET_CONFFILE_FAILED);
                }else{
                    rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };


        SOAPServerBase.execCmd(cmd,trans,cmdHandler, errHandler);
        return trans;

    }// end function "getBaseInfo()"
    
    /**get ftp friendUseFTPServices
     *@param: none
     *@return SoapRpsFTPInfo
     */

     public SoapRpsFTPInfo getFriendUseFTPServices(String groupNo) throws Exception{
         SoapRpsFTPInfo trans=new SoapRpsFTPInfo();
         String home        = System.getProperty("user.home");
         String[] cmd        = {COMMAND_SUDO,
                                home+FTP_SCRIPT_GET_FRIEND_FTP_SERVICE,
                                nodeNo,
                                groupNo};
         
         CmdHandler cmdHandler = new CmdHandler(){
             public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                 SoapRpsFTPInfo rpsFTPInfo = (SoapRpsFTPInfo)rps;
                 BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));

                 FTPInfo result = new FTPInfo();
                 result.setUseFTPService(inputStr.readLine().equalsIgnoreCase("yes"));
                 rpsFTPInfo.setFTPInfo(result);
                 rpsFTPInfo.setSuccessful(true);
             }//end cmdHandle
         };//end of new CmdHandler

         CmdErrHandler errHandler = new CmdErrHandler(){
             public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                 rps.setSuccessful(false);

                 if( proc.exitValue() == FAILED_TO_GET_TEMPFILE){
                     rps.setErrorCode(FTP_EXCEP_GET_CONFFILE_FAILED);
                 }else{
                     rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                 }
             }
         };
         SOAPServerBase.execCmd(cmd,trans,cmdHandler, errHandler);
         return trans;

     }// end function "getFriendUseFTPServices()"


    /**get ftp  auth info
    *@param: none
    *@return SoapRpsFTPAuthInfo
    */

    public SoapRpsFTPAuthInfo getAuthInfo(String groupNo) throws Exception{
        SoapRpsFTPAuthInfo trans=new SoapRpsFTPAuthInfo();

        String   home        = System.getProperty("user.home");
        String[] cmd       = {COMMAND_SUDO,
                              home+FTP_SCRIPT_GET_FTP_AUTH_INFO,
                              nodeNo,
                              groupNo} ;

        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsFTPAuthInfo rpsFTPAuthInfo = (SoapRpsFTPAuthInfo)rps;
                BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));

                FTPAuthInfo result = new FTPAuthInfo();

                result.setAuthDBType(inputStr.readLine());
                result.setLudbName(inputStr.readLine());
                result.setNisNetwork(inputStr.readLine());
                result.setNisDomain(inputStr.readLine());
                result.setNisServer(inputStr.readLine());
                result.setPdcDomain(inputStr.readLine());
                result.setPdcName(inputStr.readLine());
                result.setBdcName(inputStr.readLine());
                result.setLdapServer(inputStr.readLine());
                result.setLdapBaseDN(inputStr.readLine());
                result.setLdapMethod(inputStr.readLine());
                result.setLdapBindName(NSUtil.perl2Page(inputStr.readLine(),NasConstants.BROWSER_ENCODE));
                result.setLdapBindPasswd(NSUtil.perl2Page(inputStr.readLine(),NasConstants.BROWSER_ENCODE));
                result.setLdapUseTls(inputStr.readLine());
                result.setLdapCertFile(NSUtil.perl2Page(inputStr.readLine(),NasConstants.BROWSER_ENCODE));
                result.setLdapCertDir(NSUtil.perl2Page(inputStr.readLine(),NasConstants.BROWSER_ENCODE));
                result.setUserFilter(inputStr.readLine());
                result.setGroupFilter(inputStr.readLine());
                result.setUtoa(inputStr.readLine()); //add by liq at 11.8

	        	String line;
	        	StringBuffer buf=new StringBuffer("");

                while((line =inputStr.readLine())!=null){
                    buf.append(line);
                    buf.append("\n");
                }

                result.setLdapUserInput(NSUtil.perl2Page(buf.toString(),NasConstants.BROWSER_ENCODE));
                rpsFTPAuthInfo.setInfo(result);
                rpsFTPAuthInfo.setSuccessful(true);
            }//end cmdHandle
        };//end of new CmdHandler

        CmdErrHandler errHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                rps.setSuccessful(false);

                if( proc.exitValue() == FAILED_TO_GET_TEMPFILE){
                    rps.setErrorCode(FTP_EXCEP_GET_CONFFILE_FAILED);
                }else{
                    rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };


        SOAPServerBase.execCmd(cmd,trans,cmdHandler, errHandler);
        return trans;

    }// end function "getBaseInfo()"


    /**get ftp  service status
    *@param: none
    *@return SoapRpsString
    */
    public SoapRpsString getFTPServiceStatus() throws Exception{
        SoapRpsString trans=new SoapRpsString();
        String home        = System.getProperty("user.home");
        String cmd = SUDO_COMMAND+" "+ home + FTP_SCRIPT_GET_FTP_SERVICE_STATUS;

        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsString trans=(SoapRpsString)rps;
                trans.setSuccessful(true);
                BufferedReader inputStr = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                String line = inputStr.readLine();
                if(line != null) {
                    trans.setString(line);
                }
            }
        };
        SOAPServerBase.execCmd(cmd, trans, cmdHandler);

        return trans;
    }// end function "getFTPServiceStatus()"

    /**write usermapping mode and clients allow/deny
    *@param: FTPInfo ftpinfo,String groupNo
    *@return SoapResponse
    */
    public SoapResponse writeUserAndAuth(FTPInfo ftpinfo,String groupNo) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home = System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO,
                          home + FTP_SCRIPT_WRITTING_PROFTPDAUTH_FILE,
                          ftpinfo.getAuthUserMappingMode(),
                          ftpinfo.getAuthAnonUserName(),
                          nodeNo,
                          groupNo,
                          ftpinfo.getAuthAccessType(),
                          ftpinfo.getAuthUserList(),
                          ftpinfo.getAuthDBType()
                        };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                rps.setErrorCode(FTP_EXCEP_WRITE_FILE_FAILED);
                rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdErrHandler);

        return trans;
    }


    /**set manage lan
    *@param: FTPInfo ftpinfo,String groupNo
    *@return SoapResponse
    */
    public  SoapResponse setManageLan(FTPInfo ftpinfo,String groupNo) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home = System.getProperty("user.home");
        String[] cmd = {COMMAND_SUDO ,
                      home + FTP_SCRIPT_SET_MANAGELAN_STATUS,
                      ftpinfo.isUseFTPService()+"",
                      ftpinfo.getBasUseManageLAN()+"",
                      nodeNo,
                      groupNo
                      };

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                if( proc.exitValue() == FAILED_TO_RUN_IPTABLES){
                    rps.setErrorCode(FTP_EXCEP_RUN_IPTABLES_FAILED);
                }else{
                    rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmd, trans, cmdErrHandler);
        return trans;
    }


    /** make up the string and write base conf
    *@param: FTPInfo ftpinfo
    *@return SoapResponse
    */
    public SoapResponse writeBaseConf(FTPInfo ftpinfo,String groupNo) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home = System.getProperty("user.home");
        trans.setSuccessful(true);
        StringBuffer baseInfo = new StringBuffer();
        baseInfo.append("ftp yes^");
        baseInfo.append("Port ").append(ftpinfo.getPortNumber()).append("^");
        baseInfo.append("PassivePorts ");
        baseInfo.append(ftpinfo.getPassivePortStartNumber()).append(" ");
        baseInfo.append(ftpinfo.getPassivePortEndNumber()).append("^");
        baseInfo.append("MaxClients ");

        if (ftpinfo.getBasMaxConnections().equals("0")){
            baseInfo.append("none");
        }else{
            baseInfo.append(ftpinfo.getBasMaxConnections());
        }

        baseInfo.append( "^");
        // shench 2008.12.3 start
        baseInfo.append("IdentLookups ").append(ftpinfo.getBasIdentdMode()).append("^");
        //end shench

        if (ftpinfo.getBasAccessMode().equalsIgnoreCase("ReadOnly")) {
        	baseInfo.append( "<Limit WRITE>^DenyAll^</Limit>^");
        }

       if (ftpinfo.getBasClientMode().equalsIgnoreCase("Allow")){
           if (ftpinfo.getBasClientList().equals("")){
                baseInfo.append("<Limit LOGIN>^AllowAll^</Limit>^");
           }
           else{
                baseInfo.append("<Limit LOGIN>^Order Allow,Deny^");
                baseInfo.append("Allow from ");
                baseInfo.append(ftpinfo.getBasClientList());
                baseInfo.append("^Deny from all^</Limit>^");
           }
       }
       else{
           	if (ftpinfo.getBasClientList().equals("")){
            	baseInfo.append("<Limit LOGIN>^DenyAll^</Limit>^");
        	}
        	else{
            	baseInfo.append("<Limit LOGIN>^Order Deny,Allow^");
            	baseInfo.append("Deny from ");
             	baseInfo.append(ftpinfo.getBasClientList());
            	baseInfo.append("^Allow from all^</Limit>^");
            }
        }

        if (ftpinfo.getHomeDirMode().equalsIgnoreCase("AuthDB")){
        	baseInfo.append("DefaultChdir %h^");
        }
        else{
//        	baseInfo.append("DefaultChdir ").append(ftpinfo.getHomeDirName()).append("^");
        	baseInfo.append("DefaultChdir \"").append(ftpinfo.getHomeDirName()).append("\"^");

        }

        if (ftpinfo.isUseAnonFTP()==true){
//        	baseInfo.append("<Anonymous ").append(ftpinfo.getAnonFTPDir ()).append(">^");
// 2003-10-18 xingh, anonymous directory with spaces character
        	baseInfo.append("<Anonymous \"").append(ftpinfo.getAnonFTPDir ()).append("\">^");
        	baseInfo.append("MaxClients ");
            if (ftpinfo.getAnonMaxConnections().equals("0")){
                baseInfo.append("none");
            }
            else{
                baseInfo.append(ftpinfo.getAnonMaxConnections());
            }
            baseInfo.append( "^");
        	if (ftpinfo.getAnonAccessMode().equalsIgnoreCase("ReadWrite")) {
        	    baseInfo.append("<Limit WRITE>^AllowAll^</Limit>^");
            }
        	else if (ftpinfo.getAnonAccessMode().equalsIgnoreCase("DownloadOnly")) {
        	    baseInfo.append("<Limit WRITE>^DenyAll^</Limit>^");
            }
        	else if (ftpinfo.getAnonAccessMode().equalsIgnoreCase("UploadOnly")) {
            	baseInfo.append("<Limit STOR>^AllowAll^</Limit>^");
            	baseInfo.append("<Limit READ WRITE>^DenyAll^</Limit>^");
            }
        	if (ftpinfo.getAnonClientMode().equalsIgnoreCase("Allow")){
                if (ftpinfo.getAnonClientList().equals("")){
            	    baseInfo.append("<Limit LOGIN>^AllowAll^</Limit>^");
                }
                else{
                	baseInfo.append("<Limit LOGIN>^Order Allow,Deny^");
                    baseInfo.append("Allow from ");
                    baseInfo.append(ftpinfo.getAnonClientList());
                    baseInfo.append("^Deny from all^</Limit>^");
                }
            }
            else{
                if (ftpinfo.getAnonClientList().equals("")){
            	    baseInfo.append("<Limit LOGIN>^DenyAll^</Limit>^");
                }
                else{
                    baseInfo.append("<Limit LOGIN>^Order Deny,Allow^");
                    baseInfo.append("Deny from ");
                    baseInfo.append(ftpinfo. getAnonClientList());
                    baseInfo.append("^Allow from all^</Limit>^");
                }
            }
            
            baseInfo.append("User \"").append(ftpinfo.getAnonUserName()).append("\"^");
            baseInfo.append("UserAlias anonymous \"").append(ftpinfo.getAnonUserName()).append("\"^");
            baseInfo.append("Group \"").append(ftpinfo.getAnonGroupName()).append("\"^");
            
            baseInfo.append("</Anonymous>^");
        }

        String[] cmds = {COMMAND_SUDO,
                         home +FTP_SCRIPT_SET_BASEINFO,
                         baseInfo.toString(),
                         nodeNo,
                         groupNo
                        };
        //1.2 writing base info file
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                rps.setErrorCode(FTP_EXCEP_WRITE_FILE_FAILED);
                rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdErrHandler);
        return trans;
    }//end writeBaseConf()

    /**set manage lan
    * this function is already not useful
    *@param: FTPInfo ftpinfo
    *@return SoapResponse
    */
    public SoapResponse setClientListMode(FTPInfo ftpinfo) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home = System.getProperty("user.home");

        String[] cmds = {COMMAND_SUDO,
                       home + FTP_SCRIPT_SET_CLIENTLIST_MODE ,
                       ftpinfo.getBasClientList(),
                       ftpinfo.getPortNumber(),
                       ftpinfo.getBasClientMode()};

        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);

                if( proc.exitValue() != 0){
                    rps.setErrorCode(FTP_EXCEP_SET_CLIENTLIST_MODE_FAILED);
                }else{
                    rps.setErrorMessage(SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmds , trans, cmdErrHandler);
        return trans;
    }



    public SoapResponse setMyNode(FTPInfo ftpinfo,FTPAuthInfo authinfo,String groupNo) throws Exception{
        SoapResponse trans = new SoapResponse();
        if(ftpinfo.isUseFTPService()){

        //1. set auth info
            trans =  setAuthInfo(authinfo, groupNo);
            if (!trans.isSuccessful()){
                trans.setErrorCode(FTP_EXCEP_SET_AUTH_FAILED);
                return trans;
            }

        //2. writing file "/etc/groupN.setupinfo/ftpd/proftpd_auth.conf.N"
        //   and "/etc/pam.d/ftp-groupN"
        //   and "/etc/groupN/ftpusers"
            trans =  writeUserAndAuth(ftpinfo, groupNo);
            if (!trans.isSuccessful()){
                trans.setErrorCode(FTP_EXCEP_SET_AUTH_FAILED);
                return trans;
            }

        //3. close original passsive(never failed now)
            trans =  closeOriginPassive(groupNo);
            if (!trans.isSuccessful()){
                return trans;
            }

        //4.set base info using ftpinfo and make up the string for writting file "/etc/groupN.setupinfo/ftpd/proftpd.conf.0"
            trans =  writeBaseConf(ftpinfo,groupNo);
            if (!trans.isSuccessful()){
                trans.setErrorCode(FTP_EXCEP_SET_BASIC_FAILED);
                return trans;
            }

        }else{
        //1. don't use ftp service
            trans =  initFTPConf(groupNo);
            if (!trans.isSuccessful()){
                return trans;
            }
        }

        //5.run ftp_mkcnf groupNo command
        trans =  execFTPmkcnf(groupNo);
        if (!trans.isSuccessful()){
            return trans;
        }

        //6. change ftp service status
        //trans =  setServiceStatus(ftpinfo);
        //if (!trans.isSuccessful()){

        //  return trans;
        //}

        //7. open or close passive
        // check manage LAN use, run iptables
        trans =  setManageLan(ftpinfo,groupNo);
        if (!trans.isSuccessful()){
            return trans;
        }

        trans =  setPassivePorts(ftpinfo,groupNo);
        return trans;
    }

    public SoapResponse setFriendNode(FTPInfo ftpinfo,FTPAuthInfo authinfo,String groupNo) throws Exception{
        SoapResponse trans=new SoapResponse();

        if(ftpinfo.isUseFTPService()){

        //1. set auth info
            trans=setAuthInfo(authinfo, groupNo);
            if(!trans.isSuccessful()){
                return trans;
            }

        //2. writing file "/etc/groupN.setupinfo/ftpd/proftpd_auth.conf.N"
        //   and "/etc/pam.d/ftp-groupN"
        //   and "/etc/groupN/ftpusers"
            trans=writeUserAndAuth(ftpinfo, groupNo);
            if(!trans.isSuccessful()){
                return trans;
            }

        //3.set base info using ftpinfo and make up the string for writting file "/etc/groupN.setupinfo/ftpd/proftpd.conf.0"
            trans=writeBaseConf(ftpinfo,groupNo);
            if(!trans.isSuccessful()){
                return trans;
            }

        }else{
        // 1. if don't use ftp service
            trans=initFTPConf(groupNo);
            if(!trans.isSuccessful()){
                return trans;
            }
        }

        //4.run ftp_mkcnf groupNo command
       trans= execFTPmkcnf(groupNo);
       return trans;
    }
 // gaozf 20081203 start
    public SoapResponse setBothNode (FTPInfo ftpinfo,FTPAuthInfo authinfo,String groupNo) throws Exception{
        
        SoapResponse trans = new SoapResponse();
        
        if(ftpinfo.isUseFTPService()){
 
        //1. set auth info
            trans =  setAuthInfo(authinfo, groupNo);
            if (!trans.isSuccessful()){
                trans.setErrorCode(FTP_EXCEP_SET_AUTH_FAILED);
                return trans;
            }
            
        //2. writing file "/etc/groupN.setupinfo/ftpd/proftpd_auth.conf.N"
        //   and "/etc/pam.d/ftp-groupN"
        //   and "/etc/groupN/ftpusers"
            trans =  writeUserAndAuth(ftpinfo, groupNo);
            if (!trans.isSuccessful()){
                trans.setErrorCode(FTP_EXCEP_SET_AUTH_FAILED);
                return trans;
            }
           
        //3. close original passsive(never failed now)
            trans =  closeOriginPassive(groupNo);
            if (!trans.isSuccessful()){
                return trans;
            }

          
        //4.set base info using ftpinfo and make up the string for writting file "/etc/groupN.setupinfo/ftpd/proftpd.conf.0"
            trans =  writeBaseConf(ftpinfo,groupNo);
            if (!trans.isSuccessful()){
                trans.setErrorCode(FTP_EXCEP_SET_BASIC_FAILED);
                return trans;
            }

        }else{
         //3. don't use ftp service
            String friendGroup=String.valueOf(1-Integer.parseInt(groupNo));
            FTPInfo friendFTPInfo=new FTPInfo();
            try{
                SoapRpsFTPInfo rps= (SoapRpsFTPInfo)getFriendUseFTPServices(friendGroup);
                friendFTPInfo = rps.getFTPInfo();
            }catch(Exception e){
                friendFTPInfo.setUseFTPService(true);
            }
             
            if(!friendFTPInfo.isUseFTPService()){
            	 
                //1. close original passsive(never failed now)
                trans =  closeOriginPassive(groupNo);
                if (!trans.isSuccessful()){
                    return trans;
                }
                
                //2. open or close passive
                // check manage LAN use, run iptables
                trans =  setManageLan(ftpinfo,groupNo);
                if (!trans.isSuccessful()){
                    return trans;
                }
                 
            }
        
            trans =  initFTPConf(groupNo);
            if (!trans.isSuccessful()){
                return trans;
            }
        }
        
        //5.run ftp_mkcnf groupNo command
        trans =  execFTPmkcnf(groupNo);
        if (!trans.isSuccessful()){
            return trans;
        }
    
       
        if(ftpinfo.isUseFTPService()){
	        //6. open or close passive
	        // check manage LAN use, run iptables
	        trans =  setManageLan(ftpinfo,groupNo);
	        if (!trans.isSuccessful()){
	            return trans;
	        }
	
	        trans =  setPassivePorts(ftpinfo,groupNo);
        }
        return trans;
        
    }
 // end   

}//end class
