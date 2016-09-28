/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FTPInfo.java,v 1.2302 2008/12/23 03:24:08 gaozf Exp $";
 */
 package    com.nec.sydney.atom.admin.ftp;
 
 import     com.nec.sydney.atom.admin.ftp.FTPConstants;
 
 public class FTPInfo {

     String      ftpServiceStatus;
     boolean     useFTPService;
     String      portNumber;
     String      passivePortStartNumber;
     String      passivePortEndNumber;
     String      basMaxConnections;
     //shench 2008.12.3 start
     String      basIdentdMode;
     //end shench
     String      basAccessMode;
     String      basClientMode;
     String      basClientList;
     boolean     basUseManageLAN;
     String      authDBType;
     String      authAccessType;
     String      authUserList;
     String      authUserMappingMode;
     String      authAnonUserName;
     String      homeDirMode;
     String      homeDirName;
     boolean     useAnonFTP;
     String      anonFTPDir;
     String      anonMaxConnections;
     String      anonAccessMode;
     String      anonClientMode;
     String      anonClientList;
     String      anonUserName;
     String      anonGroupName;
  

    public FTPInfo(){
        this.ftpServiceStatus    = FTPConstants.SERVICE_STATUS_UNKNOWN;
        this.useFTPService       = false;
        this.portNumber          = FTPConstants.BAS_FTPD_DEFAULT_PORT;
        this.passivePortStartNumber   = FTPConstants.BAS_PASSIVE_DEFAULT_PORT_START;
        this.passivePortEndNumber     = FTPConstants.BAS_PASSIVE_DEFAULT_PORT_END;
        this.basMaxConnections   = "";
        //shench 2008.12.3 start 
        this.basIdentdMode       =FTPConstants.BAS_IDENTDMODE_USE;
        //end shench
        this.basAccessMode       = FTPConstants.BAS_ACCESSMODE_READWRITE;
        this.basClientMode       = FTPConstants.BAS_CLIENTMODE_ALLOW;  
        this.basClientList       = "";
        this.basUseManageLAN     = false;
        
        this.authDBType          = "";
        this.authAccessType      = FTPConstants.AUTH_ACCESSTYPE_ALLOW;
        this.authUserList        = "";
        this.authUserMappingMode = FTPConstants.AUTH_USERMAPPINGMODE_VALID;
        this.authAnonUserName    = FTPConstants.AUTH_ANONUSERNAME_NOBODY;
        
        this.homeDirMode         = FTPConstants.AUTH_HOMEDIR_MODE_AUTHDB ;
        this.homeDirName         = "";
        this.useAnonFTP          = false;
        this.anonFTPDir          = "";
        this.anonMaxConnections  = "";
        this.anonAccessMode      = FTPConstants.ANON_ACCESSMODE_READWRITE;
        this.anonClientMode      = FTPConstants.ANON_CLIENTMODE_ALLOW;
        this.anonClientList      = "";           
        this.anonUserName     = FTPConstants.ANON_USERNAME_FTP;
        this.anonGroupName    = FTPConstants.ANON_USERNAME_FTP;
        
    }
/*    
    public FTPInfo(FTPInfo other) {
        if(this != other) {
            this.ftpServiceStatus       = other.ftpServiceStatus;
            this.useFTPService          = other.useFTPService;
            this.portNumber             = other.portNumber;
            this.basMaxConnections      = other.basMaxConnections;
            this.basAccessMode          = other.basAccessMode;
            this.basClientMode          = other.basClientMode;
            this.basClientList          = other.basClientList;
            this.basUseManageLAN        = other.basUseManageLAN;
            this.authDBType             = other.authDBType;
            this.authAccessType         = other.authAccessType;
            this.authUserList           = other.authUserList;
            this.authUserMappingMode    = other.authUserMappingMode;
            this.authAnonUserName       = other.authAnonUserName;
            this.homeDirMode            = other.homeDirMode;
            this.homeDirName            = other.homeDirName;
            this.useAnonFTP             = other.useAnonFTP;
            this.anonFTPDir             = other.anonFTPDir;
            this.anonMaxConnections     = other.anonMaxConnections;
            this.anonAccessMode         = other.anonAccessMode;
            this.anonClientMode         = other.anonClientMode;
            this.anonClientList         = other.anonClientList;
        }
    }
*/
    public String getFTPServiceStatus(){
        return ftpServiceStatus;
    }
    
    public void setFTPServiceStatus(String status){
        this.ftpServiceStatus = status;
    }
    
    public boolean isUseFTPService(){
        return useFTPService;
    }

    public void setUseFTPService(boolean use){
        this.useFTPService = use;
    }
    
    public String getPortNumber(){
        return portNumber;
    }
    
    public void setPortNumber(String port){
        this.portNumber = port;
    }
    //liq 2003.9.4
    public String getPassivePortStartNumber(){
        return passivePortStartNumber;
    }
    
    public void setPassivePortStartNumber(String passiveStartPort){
        this.passivePortStartNumber=passiveStartPort;
    }
    
    public String getPassivePortEndNumber(){
        return passivePortEndNumber;
    }
    
    public void setPassivePortEndNumber(String passiveEndPort){
        this.passivePortEndNumber=passiveEndPort;
    }
     //end liq
    public String getBasMaxConnections(){
        return basMaxConnections;
    }
   
    public void setBasMaxConnections(String maxConnections){
        this.basMaxConnections = maxConnections;
    }
    //shench 2008.12.3 start
    public String getBasIdentdMode(){
    	return basIdentdMode;
    }
    public void setBasIdentdMode(String mode){
    	this.basIdentdMode=mode;
    }
    //end shench
    public String getBasAccessMode(){
        return basAccessMode;
    }
    
    public void setBasAccessMode(String mode){
        this.basAccessMode = mode;
    }
    
    public String getBasClientMode(){
        return basClientMode;
    }
    
    public void setBasClientMode(String mode){
        this.basClientMode = mode;
    }
    
    public String getBasClientList(){
        return basClientList;
    }
    
    public void setBasClientList(String clientList){
        this.basClientList = clientList;
    }
    
    public boolean getBasUseManageLAN(){
        return basUseManageLAN;
    }
    
    public void setBasUseManageLAN(boolean use){
        this.basUseManageLAN = use;
    }
    
    public String getAuthDBType(){
        return authDBType;
    }
    
    public void setAuthDBType(String type){
        this.authDBType = type;
    }
    
    public String getAuthAccessType(){
        return authAccessType;
    }
    
    public void setAuthAccessType(String type){
        this.authAccessType = type;
    }
    
    public String getAuthUserList(){
        return authUserList;
    }
    
    public void setAuthUserList(String userList){
        this.authUserList = userList;
    }
    
    public String getAuthUserMappingMode(){
        return authUserMappingMode;
    }
    
    public void setAuthUserMappingMode(String mappingMode){
        this.authUserMappingMode = mappingMode;
    }
    
    public String getAuthAnonUserName(){
        return authAnonUserName;
    }
    
    public void setAuthAnonUserName(String userName){
        this.authAnonUserName = userName;
    }
    
    public String getHomeDirMode(){
        return homeDirMode;
    }
    
    public void setHomeDirMode(String mode){
        this.homeDirMode = mode;
    }
    
    public String getHomeDirName(){
        return homeDirName;
    }
    
    public void setHomeDirName(String dirName){
        this.homeDirName = dirName;
    }
    
    public boolean isUseAnonFTP(){
        return useAnonFTP;
    }
    
    public void setUseAnonFTP(boolean use){
        this.useAnonFTP = use;
    }
    
    public String getAnonFTPDir (){
        return anonFTPDir;
    }
    
    public void setAnonFTPDir(String dir){
        this.anonFTPDir = dir;
    }
    
    public String getAnonMaxConnections(){
        return anonMaxConnections;
    }
    
    public void setAnonMaxConnections(String maxConnections){
        this.anonMaxConnections = maxConnections;
    }
    
    public String getAnonAccessMode(){
        return anonAccessMode;
    }
    
    public void setAnonAccessMode(String mode){
        this.anonAccessMode = mode;
    }
    
    public String getAnonClientMode(){
        return (this.anonClientMode);
    }

    public void setAnonClientMode(String mode){
        this.anonClientMode = mode;
    }
    
    public String getAnonClientList(){
        return (this.anonClientList);
    }
    
    public void setAnonClientList(String clientList){
        this.anonClientList = clientList;
    }

    public String getAnonUserName(){
        return anonUserName;
    }

    public void setAnonUserName(String anonUserName){
        this.anonUserName = anonUserName;
    }

    public String getAnonGroupName(){
        return anonGroupName;
    }

    public void setAnonGroupName(String anonGroupName){
        this.anonGroupName = anonGroupName;
    }

    public String toString() {

	String sep = "\\r\\n";//System.getProperty("line.separator");
	StringBuffer buffer = new StringBuffer();
	buffer.append(sep);
	buffer.append("ftpServiceStatus = ");
	buffer.append(ftpServiceStatus);
	buffer.append(sep);
	buffer.append("useFTPService = ");
	buffer.append(useFTPService);
	buffer.append(sep);
	buffer.append("portNumber = ");
	buffer.append(portNumber);
	buffer.append(sep);
	buffer.append("passivePortStartNumber = ");
	buffer.append(passivePortStartNumber);
	buffer.append(sep);
	buffer.append("passivePortEndNumber = ");
	buffer.append(passivePortEndNumber);
	buffer.append(sep);
	buffer.append("basMaxConnections = ");
	buffer.append(basMaxConnections);
	buffer.append(sep);
   //shench 2008.12.3 start
	buffer.append("basIdentdMode = ");
	buffer.append(basIdentdMode);
	buffer.append(sep);
  //end shench
	buffer.append("basAccessMode = ");
	buffer.append(basAccessMode);
	buffer.append(sep);
	buffer.append("basClientMode = ");
	buffer.append(basClientMode);
	buffer.append(sep);
	buffer.append("basClientList = ");
	buffer.append(basClientList);
	buffer.append(sep);
	buffer.append("basUseManageLAN = ");
	buffer.append(basUseManageLAN);
	buffer.append(sep);
	buffer.append("authDBType = ");
	buffer.append(authDBType);
	buffer.append(sep);
	buffer.append("authAccessType = ");
	buffer.append(authAccessType);
	buffer.append(sep);
	buffer.append("authUserList = ");
	buffer.append(authUserList);
	buffer.append(sep);
	buffer.append("authUserMappingMode = ");
	buffer.append(authUserMappingMode);
	buffer.append(sep);
	buffer.append("authAnonUserName = ");
	buffer.append(authAnonUserName);
	buffer.append(sep);
	buffer.append("homeDirMode = ");
	buffer.append(homeDirMode);
	buffer.append(sep);
	buffer.append("homeDirName = ");
	buffer.append(homeDirName);
	buffer.append(sep);
	buffer.append("useAnonFTP = ");
	buffer.append(useAnonFTP);
	buffer.append(sep);
	buffer.append("anonFTPDir = ");
	buffer.append(anonFTPDir);
	buffer.append(sep);
	buffer.append("anonMaxConnections = ");
	buffer.append(anonMaxConnections);
	buffer.append(sep);
	buffer.append("anonAccessMode = ");
	buffer.append(anonAccessMode);
	buffer.append(sep);
	buffer.append("anonClientMode = ");
	buffer.append(anonClientMode);
	buffer.append(sep);
	buffer.append("anonClientList = ");
	buffer.append(anonClientList);
	buffer.append(sep);
	
	return buffer.toString();
    }    
}
