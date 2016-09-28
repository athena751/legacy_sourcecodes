
/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *        cvsid = "@(#) $Id: FTPSetBean.java,v 1.2306 2008/12/23 03:45:39 gaozf Exp $";
 */

package    com.nec.sydney.beans.ftp;
import     com.nec.sydney.framework.*;
import     com.nec.sydney.atom.admin.ftp.*;
import     com.nec.sydney.beans.base.*;
import     com.nec.sydney.net.soap.*;

public class FTPSetBean extends TemplateBean implements FTPConstants {
    private FTPInfo info = new FTPInfo();
    private FTPAuthInfo authinfo = new FTPAuthInfo();

    private boolean ftpConfFileExist=true;

    public String getGroupNo(){
        String groupNo= (String)session.getAttribute("group");
        if(groupNo==null){
            groupNo="0";
        }
        return groupNo;
    }


    public void onDisplay() throws Exception{
        try{
            info = (FTPInfo)FTPSOAPClient.getBaseInfo(super.target, this.getGroupNo());
            authinfo = (FTPAuthInfo)FTPSOAPClient.getAuthInfo(super.target,this.getGroupNo());

        }catch(NSException e){
            if(e.getErrorCode() == FTP_EXCEP_GET_CONFFILE_FAILED){
                ftpConfFileExist = false;
                
                String friendTarget = Soap4Cluster.whoIsMyFriend(super.target);
                if(friendTarget!=null&&!friendTarget.equals("")){
                    FTPInfo infoFriend = new FTPInfo();
                    try{
                        infoFriend = (FTPInfo)FTPSOAPClient.getBaseInfo(friendTarget, String.valueOf(1-Integer.parseInt(getGroupNo())));
                        info.setPassivePortStartNumber(infoFriend.getPassivePortStartNumber());
                        info.setPassivePortEndNumber(infoFriend.getPassivePortEndNumber());
                    }catch(NSException ex) {
                    }
                }
                return;
            }else{
                throw e;
            }
        }
    }

    public void onSet() throws Exception{
        String groupNo = getGroupNo();
        GatherFTPInfoFromRequest();
        GatherAuthDBInfoFromRequest();
        String friendTarget = Soap4Cluster.whoIsMyFriend(super.target);
        try{
            //gaozf 20081203
            if(friendTarget!=null&&!friendTarget.equals("")){
            	FTPSOAPClient.setBothNode(super.target,info,authinfo,groupNo);
            }else{
                FTPSOAPClient.setMyNode(super.target,info,authinfo,groupNo);
            }
            //end
        }catch(NSException e){
            int error_code = e.getErrorCode();
            switch(error_code){
                case FTP_EXCEP_SET_AUTH_FAILED:
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session,"nas_ftp/alert/auth_failed"));
                    break;
                case FTP_EXCEP_SET_BASIC_FAILED:
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session,"nas_ftp/alert/basic_failed"));
                    break;
                case FTP_EXCEP_STATUS_CHANGED_FAILED:
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session,"nas_ftp/alert/reflection_failed"));
                    break;
                default:
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
                    break;
            }

            String redirectURL=super.response.encodeRedirectURL("../nas/ftp/ftpset.jsp");
            super.setRedirectUrl(redirectURL);

            return;

        }


        if(friendTarget!=null&&!friendTarget.equals("")){

            try{
            	 //gaozf 20081203
                FTPSOAPClient.setBothNode(friendTarget,info,authinfo,groupNo);
                //end
            }catch(NSException e){
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"nas_ftp/alert/friend_failed"));

            }
        }
        
        super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
       
        String redirectURL = super.response.encodeRedirectURL("../nas/ftp/ftpinfo.jsp");
        super.setRedirectUrl(redirectURL);
        return;

    }

    public void onDebug() throws Exception{
        GatherFTPInfoFromRequest();
        GatherAuthDBInfoFromRequest();
        super.setMsg("FTPInfo:" + info + "\\r\\n" + "FTPAuthInfo:" + authinfo);
        String redirectURL=super.response.encodeRedirectURL("../nas/ftp/ftpset.jsp");
        super.response.sendRedirect(redirectURL);
        return;

    }
    //shench 2008-12-15 start
    public String changeUserIdentdString(String str,String defaultIdentd) {
    	String strTemp=defaultIdentd;
    	if(null==str){
    		return strTemp;
    	}else{
	    	String 	temp=str.trim().toLowerCase();
	    	if("0".equals(temp)||"no".equals(temp)||"off".equals(temp)){
	    		strTemp="off";
			}else {
				strTemp="on";
			}
    	}
    	return strTemp;
    }
    //end shench
    private void GetBasicSettings(FTPInfo info){

        /**--------------------------------------------------
          *From here are codes to get Basic Settings of FTP
          *-------------------------------------------------*/

        String port= request.getParameter("port");
        //get the port number used by ftpd
        if(port.equals("default")){
            info.setPortNumber(BAS_FTPD_DEFAULT_PORT);
        }else if(port.equals("change")){
            info.setPortNumber(request.getParameter("portnumber"));
        }



        //liq add 20039.4 get the passiveport number used by ftpd
        String passiveport= request.getParameter("passiveport");
        if(passiveport.equals("default")){
            info.setPassivePortStartNumber(BAS_PASSIVE_DEFAULT_PORT_START);
            info.setPassivePortEndNumber(BAS_PASSIVE_DEFAULT_PORT_END);
        }else if(passiveport.equals("change")){
            info.setPassivePortStartNumber(request.getParameter("passiveportstartnumber"));
            info.setPassivePortEndNumber(request.getParameter("passiveportendnumber"));
        }
        //end liq

        //get the max connections that can access ftp server at the same time
        String maxConnects=request.getParameter("basemaxconnect");
        if(maxConnects==null||maxConnects.equals("")){
            info.setBasMaxConnections("0");
        }else{
            info.setBasMaxConnections(maxConnects);
        }
        
        //baseidentdmode
        //shench 2008.12.3 start
        info.setBasIdentdMode(changeUserIdentdString(request.getParameter("baseidentdmode"),FTPConstants.BAS_IDENTDMODE_USE));
        //end shench
        
        //baseaccessmode
        info.setBasAccessMode(request.getParameter("baseaccessmode"));
         //baseclientmode
        info.setBasClientMode(request.getParameter("baseclientmode"));
         //baseclientlist
        String basClientList = request.getParameter("baseclientlist");
        if(basClientList != null){
            info.setBasClientList(basClientList);
        }
        //uselan
        String uselan=request.getParameter("uselan");
        info.setBasUseManageLAN(uselan.equals("true"));

    }
    private void GetAuthSettings(FTPInfo info){
         /**--------------------------------------------------
          *From here are codes to get Auth DB Settings of FTP
          *-------------------------------------------------*/
        //AuthDBType
        String authDBType = request.getParameter("dbtype");
        if(authDBType != null){
            if(authDBType.equals("PDC")){
                info.setAuthDBType("dmc");
            }else if(authDBType.equals("NIS")){
                info.setAuthDBType("nis");
            }else if(authDBType.equals("PWD")){
                info.setAuthDBType("pwd");
            }else if(authDBType.equals("LDAP")){
                info.setAuthDBType("ldu");
            }else{//error dbtype

            }
        }
        //AuthAccessType
        info.setAuthAccessType(request.getParameter("authaccesstype"));

        //Auth User List
        String userlist = request.getParameter("userlist");

        if(userlist != null) {
            info.setAuthUserList(userlist);
        }
        //usermapping mode
        info.setAuthUserMappingMode(request.getParameter("usermapping"));

        //anonuser name
        String anonuser = request.getParameter("anonuser");
        if(anonuser != null) info.setAuthAnonUserName(anonuser);
        //homedirectory mode: AuthDB or FSSpecify
        info.setHomeDirMode(request.getParameter("homedirectory"));

        //fsdir + userinputarea
        String dirPrefix = request.getParameter("fsdir"); // /export/ftp/ftphome
        String dirSuffix = request.getParameter("userinputarea"); // %u/mydir
        if(dirPrefix != null){
            if(dirSuffix != null && !dirSuffix.equals("")){
                if(!dirPrefix.endsWith("/")){
                    dirPrefix = dirPrefix + "/";
                }
                dirPrefix = dirPrefix + dirSuffix; // export/ftp/ftphome/%u/mydir
            }
            info.setHomeDirName(dirPrefix);
        }
    }

    private void GetAnonymousFTPSettings(FTPInfo info){
         /**--------------------------------------------------
          *From here are codes to get Anonymous Settings of FTP
          *-------------------------------------------------*/
        String anonuse = request.getParameter("anonuse");
        if(anonuse == null || anonuse.equals("")){
            info.setUseAnonFTP(false);
        }else{
            info.setUseAnonFTP(true);
            //anondir
            info.setAnonFTPDir(request.getParameter("anondir"));
            //anonmaxconnect
            String maxConnections = request.getParameter("anonmaxconnect");
            if(maxConnections == null || maxConnections.equals("")){
                info.setAnonMaxConnections("0");
            }else{
                info.setAnonMaxConnections(maxConnections);
            }

            //anonaccessmode
            info.setAnonAccessMode(request.getParameter("anonaccessmode"));
            //anonclientmode
            info.setAnonClientMode(request.getParameter("anonclientmode"));


            //anonclientlist
            String clientlist = request.getParameter("anonclientlist");
            if(clientlist != null) {
                info.setAnonClientList(clientlist);
            }

            //anonuser user name
            String anonusername = request.getParameter("anonusername");
            if(anonusername != null) info.setAnonUserName(anonusername);
            //anonuser group name
            String anongroupname = request.getParameter("anongroupname");
            if(anongroupname != null) info.setAnonGroupName(anongroupname);

        }

    }

    private void GatherFTPInfoFromRequest(){
        String useftp="";
        useftp = request.getParameter("useftp"); //checkbox useftp

        if(useftp == null || useftp.equals("")){
            info.setUseFTPService(false);
        }else{
            info.setUseFTPService(true);
            GetBasicSettings(info);
            GetAuthSettings(info);
            GetAnonymousFTPSettings(info);

        }
    }

    private void GatherAuthDBInfoFromRequest(){
        String authDBType = request.getParameter("db");

        if((authDBType != null) && (!authDBType.equals(""))){
             authinfo.setAuthDBType(authDBType);

            if(authDBType.equals(AUTH_DBTYPE_NIS)){
                authinfo.setNisNetwork(request.getParameter("nisnetwork"));
                authinfo.setNisDomain(request.getParameter("nisdomain"));
                authinfo.setNisServer(request.getParameter("nisserver"));

            }else if(authDBType.equals(AUTH_DBTYPE_PWD)){
                authinfo.setLudbName(request.getParameter("ludbname"));
            }else if(authDBType.equals(AUTH_DBTYPE_LDAP)){
                authinfo.setLdapServer(request.getParameter("ldapserver"));
                authinfo.setLdapBaseDN(request.getParameter("ldapbasedn"));
                authinfo.setLdapMethod(request.getParameter("ldapmethod"));
                authinfo.setLdapBindName(request.getParameter("ldapbindname"));
                authinfo.setLdapBindPasswd(request.getParameter("_ldapbindpasswd"));
                authinfo.setLdapUseTls(request.getParameter("ldapusetls"));
                authinfo.setLdapCertFile(request.getParameter("ldapcertfile"));
                authinfo.setLdapCertDir(request.getParameter("ldapcertdir"));
                authinfo.setLdapUserInput(request.getParameter("ldapuserinput"));
                authinfo.setUserFilter(request.getParameter("ldapUserFilter"));
                authinfo.setGroupFilter(request.getParameter("ldapGroupFilter"));
                authinfo.setUtoa(request.getParameter("utoa"));
            }else if(authDBType.equals(AUTH_DBTYPE_PDC)){
                authinfo.setPdcDomain(request.getParameter("pdcdomain"));
                authinfo.setPdcName(request.getParameter("pdcname"));
                authinfo.setBdcName(request.getParameter("bdcname"));
            }

        }

    }

    public boolean isFtpConfFileExist(){
        return ftpConfFileExist;
    }

    public String getFTPServiceStatus() throws Exception{
        return FTPSOAPClient.getFTPServiceStatus(super.target);
    }
//  gaozf 20081201 start
    public boolean isFriendUseFTPServices() throws Exception{
    	
        String friendTarget = Soap4Cluster.whoIsMyFriend(super.target);
    	if(friendTarget!=null&&!friendTarget.equals("")){
            String groupNo=this.getGroupNo();
            String friendGroupNo=String.valueOf(1-Integer.parseInt(groupNo));
            FTPInfo friendFtpInfo=new FTPInfo();
            
            try{
                friendFtpInfo=(FTPInfo)FTPSOAPClient.getFriendUseFTPServices(super.target, friendGroupNo);
            }catch(NSException e){
            	return false;
            }
            return  friendFtpInfo.isUseFTPService();
        }
        return false;
    }
//end   
    
    public boolean isUseFTPService(){
        return info.isUseFTPService();
    }
    public String getPortNumber(){
        return info.getPortNumber();
    }

    //liq add 20039.4
    public String getPassivePortStartNumber(){
        return info.getPassivePortStartNumber();
    }
    public String getPassivePortEndNumber(){
        return info.getPassivePortEndNumber();
    }
    //end liq

    public String getBasMaxConnections(){
        return info.getBasMaxConnections();
    }
    
    //shench 2008.12.3 start
    public String getBasIdentdMode(){
    	return changeUserIdentdString(info.getBasIdentdMode(),FTPConstants.BAS_IDENTDMODE_USE);
    }
    //end shench
    public String getBasAccessMode(){
        return info.getBasAccessMode();
    }
    public String getBasClientMode(){
        return info.getBasClientMode();
    }
    public String getBasClientList(){
        return info.getBasClientList();
    }

    public String getDottedBasClientList(){
        String clientlist = info.getBasClientList();
        if(clientlist == null || clientlist.equals("")){
            return "";
        }
        String listarray[] = clientlist.split(",");
        if(listarray.length <=4) return clientlist;

        return listarray[0] + "," +
               listarray[1] + "," +
               listarray[2] + "," +
               listarray[3] + " ...";

    }

    public boolean isBasUseManageLAN(){
        return info.getBasUseManageLAN();
    }

    public String getAuthAccessType(){
        return info.getAuthAccessType();
    }


    public String getAuthUserList(){
        return info.getAuthUserList();
    }

    public String getDottedAuthUserList(){
        String userlist = info.getAuthUserList();
        if(userlist == null || userlist.equals("")){
            return "";
        }
        String listarray[] = userlist.split(",");
        if(listarray.length <=4) return userlist;

        return listarray[0] + "," +
               listarray[1] + "," +
               listarray[2] + "," +
               listarray[3] + " ...";

    }

    public String getAuthUserMappingMode(){
        return info.getAuthUserMappingMode();
    }



    public String getAuthAnonUserName(){
        return info.getAuthAnonUserName();
    }


    public String getHomeDirMode(){
        return info.getHomeDirMode();
    }

    public String getHomeDirName(){
        return info.getHomeDirName();
    }

    public String getHomeDirPrefix(){
        String homeDir = info.getHomeDirName();
        String homeDirPrefix = "";
        if (homeDir == null ) return "";
        if (homeDir.equals("%h")) return "";

        int position = homeDir.indexOf('%');
        switch(position){
        case 0:
            //homeDirSuffix = homeDir;
            break;
        case -1:
            homeDirPrefix = homeDir;
            break;
        default:
            homeDirPrefix = homeDir.substring(0, position-1);//get rid of the char '/' in dir like /export/ftp/ftphome/%u/abc
            //homeDirSuffix = homeDir.substring(position, homeDir.length());
            break;
        }
        return homeDirPrefix;
    }

    public String getHomeDirSuffix(){
        String homeDir = info.getHomeDirName();
        String homeDirSuffix = "";

        if (homeDir == null) return "";
        if (homeDir.equals("%h")) return "";

        int position = homeDir.indexOf('%');
        switch(position){
        case 0:
            homeDirSuffix = homeDir;
            break;
        case -1:
            //homeDirPrefix = homeDir;
            break;
        default:
            //homeDirPrefix = homeDir.substring(0, position-1);
            homeDirSuffix = homeDir.substring(position);
            break;
        }
        return homeDirSuffix;
    }

    public boolean isUseAnonFTP(){
        return info.isUseAnonFTP();
    }

    public String getAnonFTPDir() {
        return info.getAnonFTPDir();
    }

    public String getAnonMaxConnections(){
        return info.getAnonMaxConnections();
    }

    public String getAnonAccessMode(){
        return info.getAnonAccessMode();
    }

    public String getAnonClientMode(){
        return info.getAnonClientMode();
    }


    public String getAnonClientList(){
        return info.getAnonClientList();
    }
    public String getDottedAnonClientList(){

        String clientlist = info.getAnonClientList();
        if(clientlist == null || clientlist.equals("")){
            return "";
        }
        String [] listarray = clientlist.split(",");
        if(listarray.length <=4) return clientlist;
        return listarray[0] + "," +
               listarray[1] + "," +
               listarray[2] + "," +
               listarray[3] + " ...";
    }

    public String getAnonUserName(){
        return info.getAnonUserName();
    }

    public String getAnonGroupName(){
        return info.getAnonGroupName();
    }

    public String getAuthDBType() {
        return (authinfo.getAuthDBType());
    }

    public String getNisNetwork() {
        return (authinfo.getNisNetwork());
    }

    public String getNisDomain() {
        return (authinfo.getNisDomain());
    }

    public String getNisServer() {
        return (authinfo.getNisServer());
    }

    public String getLudbName() {
        return (authinfo.getLudbName());
    }

    public String getPdcDomain() {
        return (authinfo.getPdcDomain());
    }

    public String getPdcName() {
        return (authinfo.getPdcName());
    }

    public String getBdcName() {
        return (authinfo.getBdcName());
    }

    public String getLdapServer() {
        return (authinfo.getLdapServer());
    }

    public String getLdapBaseDN() {
        return (authinfo.getLdapBaseDN());
    }

    public String getLdapMethod() {
        return (authinfo.getLdapMethod());
    }

    public String getLdapBindName() {
        return (authinfo.getLdapBindName());
    }

    public String getLdapBindPasswd() {
        return (authinfo.getLdapBindPasswd());
    }

    public String getLdapUseTls() {
        return (authinfo.getLdapUseTls());
    }

    public String getLdapCertFile() {
        return (authinfo.getLdapCertFile());
    }

    public String getLdapCertDir() {
        return (authinfo.getLdapCertDir());
    }

    public String getLdapUserFilter() {
        return (authinfo.getUserFilter());
    }
    
    public String getLdapGroupFilter() {
        return (authinfo.getGroupFilter());
    }
    
    public String getUtoa() {
        return (authinfo.getUtoa());
    }



}