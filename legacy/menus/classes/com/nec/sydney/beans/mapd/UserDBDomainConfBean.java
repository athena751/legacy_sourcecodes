/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.mapd;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;

import java.util.*;

public class UserDBDomainConfBean extends TemplateBean{
    private static final String     cvsid = "@(#) $Id: UserDBDomainConfBean.java,v 1.16 2008/12/18 08:18:56 wanghui Exp $";

    private static final String     CMD_SUDO = "sudo";
    private static final String     CMD_GET_DOMAIN_INFO = "/bin/userdb_getdomaininfo.pl";
    private static final String     CMD_CHECK_NETBIOS = "/bin/cifs_checkNetbios.pl";
    private static final String     CMD_GET_ALLEXP_INFO = "/bin/api_getAllExportRootInfo.pl";
    private static final String     CMD_GET_NATIVEDOMAIN = "/bin/api_getNativeDomain.pl";
    private static final String     CMD_CHECK_NISDOMAIN = "/bin/api_getNisDomainServer.pl";
    private static final String     CMD_CHECK_SMBSTATUS = "/bin/userdb_check_smbstatus.pl";

    private static final String     CMD_ADD_NISDOMAIN = "/bin/userdb_addnisdomain.pl";
    private static final String     CMD_DEL_NISDOMAIN = "/bin/userdb_delnisdomain.pl";
    private static final String     CMD_CHANGE_NISDOMAIN = "/bin/userdb_changenisdomain.pl";

    private static final String     CMD_ADD_LDAPDOMAIN = "/bin/userdb_addldapdomain.pl";
    private static final String     CMD_DEL_LDAPDOMAIN = "/bin/userdb_deleteldapdomain.pl";
    private static final String     CMD_CHANGE_LDAPDOMAIN = "/bin/userdb_changeldapdomain.pl";

    private static final String     CMD_ADD_ADSDOMAIN = "/bin/userdb_addadsdomain.pl";
    private static final String     CMD_DEL_ADSDOMAIN = "/bin/userdb_deleteadsdomain.pl";
    private static final String     CMD_CHANGE_ADSDOMAIN = "/bin/userdb_changeadsdomain.pl";

    private static final String     CMD_ADD_PWDDOMAIN = "/bin/userdb_addpwddomain.pl";
    private static final String     CMD_DEL_PWDDOMAIN = "/bin/userdb_delpwddomain.pl";

    private static final String     CMD_ADD_DMCDOMAIN = "/bin/userdb_adddmcdomain.pl";
    private static final String     CMD_DEL_DMCDOMAIN = "/bin/userdb_deldmcdomain.pl";
    private static final String     CMD_CHANGE_DMCDOMAIN = "/bin/userdb_changedmcdomain.pl";

    private static final String     CMD_ADD_SHRDOMAIN = "/bin/userdb_addshrdomain.pl";
    private static final String     CMD_DEL_SHRDOMAIN = "/bin/userdb_delshrdomain.pl";

    private static final String     CMD_GET_LUDBLIST = "/bin/mapd_getludblist.pl";
    private static final String     CMD_HAS_LDAPSAM = "/bin/userdb_hasldapsam.pl";
    private static final String		CMD_GET_ADS_DC = "/bin/userdb_getDCforADSdomain.pl";
    private static final String     CMD_CHECK_DIRECTHOSTING = "/bin/userdb_checkdirecthosting.pl";

    private static final String     CMD_DEL_SPCONF = "/bin/userdb_deleteserverprotectconf.pl";
    private static final String     CMD_EXIST_SPCONF = "/bin/serverprotect_haveSettingFile.pl";
    
    private static final String     CMD_EXIST_SSCONF = "/bin/exportgroup_hasScheduleScanInfo.pl";
    private static final String     CMD_DEL_SSCONF = "/bin/exportgroup_delScheduleScanConf.pl";
    private static final String     CMD_HAVEANTIVIRUSSHARE = "/bin/cifs_haveAntiVirusShare.pl";

    private DomainInfo info4Unix = null; //Unix Domain Information
    private DomainInfo info4Win = null;  //Windows Domain Information
    private boolean hasLUDBList = true;
    private boolean errHandle = false;//when command failed, don't throw exception
    private boolean isCluster;
    private String export;
    private String home = System.getProperty("user.home");;
    //which page to back
    private String fromWhere;
    //which area is display when loading the page
    private String dispMode;
    //fstype and domain type. eg:"unix_selenis"
    private String domainType;
    private String fsType;
    private int groupNo;
    private int friendGrpNo;

    /**
      *get Unix Domain's and Windows Domain's informaintion.
      *fill the info4Unix and info4Win
     **/
    public void onDisplay() throws Exception{
        String[] cmds;

        fromWhere = request.getParameter("fromWhere");
        dispMode = request.getParameter("dispMode");
        isCluster = ClusterUtil.getInstance().isCluster();
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        export = getExportRoot();
        if (export==null || export.equals("")){
            return;
        }
        //get Unix domain's information
        cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_GET_DOMAIN_INFO,
                      export,
                      "sxfs",
                      (new Integer(groupNo)).toString()};
        NSCmdResult ret = CmdExecBase.execCmd(cmds,groupNo,errHandle);
        if (ret.getExitValue() != 0) {
            return;
        }
        info4Unix = fillDomainInfo(ret.getStdout());

        //get Windows domain's information
        cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_GET_DOMAIN_INFO,
                      export,
                      "sxfsfw",
                      (new Integer(groupNo)).toString()};
        ret = CmdExecBase.execCmd(cmds,groupNo,errHandle);
        if (ret.getExitValue() != 0) {
            return;
        }
        info4Win = fillDomainInfo(ret.getStdout());   

    }
    
    /**
     *get domain controler.
     *success: return dc
   **/
//  get dc(modified by zhangjx for [nsgui-necas-sv4:15074] on 2006/3/17)  
    public String getDC4ADS() throws Exception {
    	export = getExportRoot();
    	groupNo = NSActionUtil.getCurrentNodeNo(request);
    	String[] cmds = new String[] {
    				CMD_SUDO,
					home + CMD_GET_ADS_DC,
					(new Integer(groupNo)).toString(),
					"domain",
					export};
    	
    	NSCmdResult ret = CmdExecBase.execCmd(cmds,groupNo,errHandle);
    	if (ret.getExitValue() != 0) {
    		return "";
    	}
    	return (ret.getStdout()[0]).trim();
    }

    /**
      *add the specified domain.
      *success: redirect to userdbdomainconf.jsp.
      *falied: set alert message and then redirect to userdbdomainconf.jsp
    **/
    public void onAdd() throws Exception{
        domainType = request.getParameter("domaintype");
        export = getExportRoot();
        fromWhere = request.getParameter("fromWhere");
        dispMode = request.getParameter("dispMode");
        isCluster = ClusterUtil.getInstance().isCluster();
        fsType = request.getParameter("fsType");
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        friendGrpNo = 1-groupNo;
        boolean isSuccess;

		if (fsType.equals("sxfsfw")){
			if(isDHenable().equals("yes")){
            //check direct hosting
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
				if (fromWhere.equals("export")) {
					super.response
							.sendRedirect(super.response
									.encodeRedirectURL("../nas/mapd/userdbdomainconf.jsp?fromWhere="
											+ fromWhere
											+ "&exportGroup="
											+ export
											+ "&dispMode=" + dispMode));
				} else {
					super.response
							.sendRedirect(super.response
									.encodeRedirectURL("../nas/mapd/userdbdomainconf.jsp?fromWhere="
											+ fromWhere + "&dispMode=" + dispMode));
				}
				return;
			}
		}
        //get fsType and domain type.
        //eg:"unix_selenis" =>domainType = "nis"
        domainType = domainType.substring(domainType.indexOf("sele")+4,domainType.length());
        //check computer name, domain type and client DB type
        if (fsType.equals("sxfsfw")&&!checkDomain4Win(export,domainType,groupNo,friendGrpNo)){
            if (fromWhere.equals("export")){
                super.response.sendRedirect(super.response.encodeRedirectURL(
                            "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&exportGroup="+export+"&dispMode="+dispMode));
            } else{
                super.response.sendRedirect(super.response.encodeRedirectURL(
                            "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&dispMode="+dispMode));
            }
            return;
        }
        if (domainType.equals("nis")){
            isSuccess = addNISDomain(fsType,export,groupNo,friendGrpNo,isCluster);
        } else if (domainType.equals("ldap")){
            isSuccess = addLDAPDomain(fsType,export,groupNo,friendGrpNo,isCluster);
        } else if (domainType.equals("pwd")){
            isSuccess = addPWDDomain(fsType,export,groupNo,friendGrpNo,isCluster);
        } else if (domainType.equals("dmc")){
            isSuccess = addDMCDomain(export,groupNo,friendGrpNo,isCluster);
        } else if (domainType.equals("ads")){
            isSuccess = addADSDomain(export,groupNo,friendGrpNo,isCluster);
        } else{
            isSuccess = addSHRDomain(export,groupNo,friendGrpNo,isCluster);
        }
        if (isSuccess){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"\\r\\n");
        }
        if (fromWhere.equals("export")){
            super.response.sendRedirect(super.response.encodeRedirectURL(
                          "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&exportGroup="+export+"&dispMode="+dispMode));
        } else{
            super.response.sendRedirect(super.response.encodeRedirectURL(
                          "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&dispMode="+dispMode));
        }
        return;
    }

    public void onChange() throws Exception{
        domainType = request.getParameter("domaintype");
        export = getExportRoot();
        fromWhere = request.getParameter("fromWhere");
        dispMode = request.getParameter("dispMode");
        isCluster = ClusterUtil.getInstance().isCluster();
        fsType = request.getParameter("fsType");
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        friendGrpNo = 1-groupNo;
        boolean isSuccess;
        //get fsType and domain type.
        //eg:"unix_selenis" =>domainType = "nis"
        domainType = domainType.substring(domainType.indexOf("sele")+4,domainType.length());
        if (domainType.equals("nis")){
            isSuccess = changeNISDomain(fsType,groupNo,friendGrpNo,isCluster);
        } else if (domainType.equals("ldap")){
            isSuccess = changeLDAPDomain(fsType,groupNo,friendGrpNo,isCluster);
        } else if (domainType.equals("dmc")){
            isSuccess = changeDMCDomain(groupNo);
        } else{
            isSuccess = changeADSDomain(export,groupNo,friendGrpNo,isCluster);
        }
        if (isSuccess){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"\\r\\n");
        }
        if (fromWhere.equals("export")){
            super.response.sendRedirect(super.response.encodeRedirectURL(
                          "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&exportGroup="+export+"&dispMode="+dispMode));
        } else{
            super.response.sendRedirect(super.response.encodeRedirectURL(
                          "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&dispMode="+dispMode));
        }
        return;

    }

    public void onDel() throws Exception{
        domainType = request.getParameter("domaintype");
        export = getExportRoot();
        fromWhere = request.getParameter("fromWhere");
        dispMode = request.getParameter("dispMode");
        isCluster = ClusterUtil.getInstance().isCluster();
        fsType = request.getParameter("fsType");
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        friendGrpNo = 1-groupNo;
        boolean isSuccess;
        domainType = domainType.substring(domainType.indexOf("sele")+4,domainType.length());
        String[] cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_GET_DOMAIN_INFO,
                      export,
                      fsType,
                      (new Integer(groupNo)).toString()};
        NSCmdResult ret = CmdExecBase.execCmd(cmds,groupNo,errHandle);
        if (ret.getExitValue() != 0) {
            super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_domain"));
            return;
        }
        info4Unix = fillDomainInfo(ret.getStdout());


        if (domainType.equals("nis")){
            isSuccess = delNISDomain(fsType,export,groupNo,friendGrpNo,isCluster,info4Unix);
        } else if (domainType.equals("ldap")){
            isSuccess = delLDAPDomain(fsType,export,groupNo,friendGrpNo,isCluster,info4Unix);
        } else if (domainType.equals("pwd")){
            isSuccess = delPWDDomain(fsType,export,groupNo,friendGrpNo,isCluster,info4Unix);
        } else if (domainType.equals("dmc")){
            isSuccess = delDMCDomain(export,groupNo,info4Unix);
        } else if (domainType.equals("ads")){
            isSuccess = delServerProtectConf(groupNo);
            if (isSuccess){
            	isSuccess = delScheduleScanConf();
            	if(isSuccess){
                    isSuccess = delADSDomain(export,groupNo,info4Unix);
            	}
            }
        } else{
            isSuccess = delSHRDomain(export,groupNo,info4Unix);
        }
        if (isSuccess){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"\\r\\n");
        }
        if (fromWhere.equals("export")){
            super.response.sendRedirect(super.response.encodeRedirectURL(
                          "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&exportGroup="+export+"&dispMode="+dispMode));
        } else{
            super.response.sendRedirect(super.response.encodeRedirectURL(
                          "../nas/mapd/userdbdomainconf.jsp?fromWhere="+fromWhere+"&dispMode="+dispMode));
        }
        return;

    }

    /**
      *Function
      *  check whether the filesystem in the specified domain is
      *  connecting whit CIFS Client
      *Parameter
      *
      *Return
      *  true:  doesn't has CIFS connection
      *  false: has CIFS connection
     **/
    public boolean isBusy() throws Exception{
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        //String domainName = request.getParameter("win_domainname");
        //String netBios = request.getParameter("win_computername");
        //if (domainName==null || netBios==null){
        //    return false;
       // }
        String[] cmds;
        String[] stdOut;

        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_CHECK_SMBSTATUS,
                        new Integer(groupNo).toString(),
                        info4Win.getNtdomain(),
                        info4Win.getNetbios()};
         NSCmdResult ret = CmdExecBase.execCmd(cmds,groupNo,errHandle);
         stdOut = ret.getStdout();
         if (ret.getExitValue()!=0){
              return true;
         }
         return false;

    }

    public String[] getLUDBList() throws Exception{
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = new String[] {CMD_SUDO,home + CMD_GET_LUDBLIST};
        NSCmdResult ret = CmdExecBase.execCmd(cmds,groupNo,errHandle);
        String[] stdOut = ret.getStdout();
        if (ret.getExitValue()!=0 || stdOut.length==0){
            hasLUDBList = false;
            return new String[]{NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/noLudb")};
        }
        return stdOut;
    }

    public DomainInfo getDomain4Unix(){
        return info4Unix;
    }

    public DomainInfo getDomain4Win(){
        return info4Win;
    }
    
    public boolean getHasLUDBList(){
        return hasLUDBList;   
    }

    public boolean hasLDAPSam() throws Exception{
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        friendGrpNo = 1-groupNo;
        isCluster = ClusterUtil.getInstance().isCluster();
        String[] cmds = new String[] {CMD_SUDO,home+CMD_HAS_LDAPSAM,(new Integer(groupNo)).toString()};
        NSCmdResult ret = CmdExecBase.execCmd(cmds,groupNo,true);
        String[] stdOut = ret.getStdout();
        if (stdOut.length>0&&stdOut[0].trim().equals("true")){
            return true;
        } else if (isCluster){
            cmds = new String[] {CMD_SUDO,home+CMD_HAS_LDAPSAM,(new Integer(friendGrpNo)).toString()};
            ret = CmdExecBase.execCmd(cmds,friendGrpNo,true);
            if (stdOut.length>0&&stdOut[0].trim().equals("true")){
               return true;
            }
        }
        return false;
    }
    
    public boolean getIfCheck(String un2dn){
        if(un2dn != null && un2dn.equals("y")){
            return true;   
        } else{
            return false;
        } 
    }

/******private function*******/

    /**
      *fill the specified DomainInfo use the command StdOut
      *success: fill the specified DomainInfo
      *failed:  the specified DomainInfo is null
     **/
    public DomainInfo fillDomainInfo(String[] stdOut) throws Exception{
        if (stdOut.length < 20){
            return null;
        }
        DomainInfo domainInfo = new DomainInfo();
        domainInfo.setDomainType(stdOut[0].trim());
        domainInfo.setRegion(stdOut[1].trim());
        domainInfo.setNetbios(stdOut[2].trim());
        domainInfo.setNtdomain(stdOut[3].trim());
        domainInfo.setNisdomain(stdOut[4].trim());
        domainInfo.setNisserver(stdOut[5].trim());
        domainInfo.setLudb(stdOut[6].trim());
        domainInfo.setLdapserver(stdOut[7].trim());
        domainInfo.setBasedn(stdOut[8].trim());
        domainInfo.setMech(stdOut[9].trim());
        domainInfo.setTls(stdOut[10].trim());
        domainInfo.setAuthname(NSUtil.perl2Page(stdOut[11].trim(),NasConstants.BROWSER_ENCODE));
        domainInfo.setAuthpwd(NSUtil.perl2Page(stdOut[12].trim(),NasConstants.BROWSER_ENCODE));
        domainInfo.setCa(NSUtil.perl2Page(stdOut[13].trim(),NasConstants.BROWSER_ENCODE));
        domainInfo.setUfilter(stdOut[14].trim());
        domainInfo.setGfilter(stdOut[15].trim());
        domainInfo.setDns(stdOut[16].trim());
        domainInfo.setKdcserver(stdOut[17].trim());
        domainInfo.setUsername(stdOut[18].trim());
        domainInfo.setPasswd(stdOut[19].trim());
        domainInfo.setUn2dn(stdOut[20].trim());
        return domainInfo;
    }

    /**
      *Function
      *  get export from session.
      *Return
      *  return export root name. eg:"/export/zhangjx"
     **/
    private String getExportRoot(){
        return NSActionUtil.getExportGroupPath(request);
    }

    /**
      *Fuction
      *  step1:check if there has same netbios in both node
      *  step2:if domain type isn't user mode,
      *        check if there has the same domain use different domainType
      *  step3:check if there has the same domain use different client DB
      *Parameter
      *  export:       export root (eg:/export/zhangjx)
      *  domainType:   (nis,pwd, ldap,ads,dmc,shr)
      *  groupNo:      0 or 1
      *  friendGrpNo:  0, 1 or
      *               -1(under the single mode)
      *Return
      *  false: one of those three is existing.
      *  true:  all of thhose three are not existing.
     **/
    private boolean checkDomain4Win(String export,String domainType,int groupNo,int friendGrpNo) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String etcPath = "/etc/group"+groupNo+"/";
        String fri_etcPath = isCluster?"/etc/group"+friendGrpNo+"/":null;
        String globle = "DEFAULT";
        String[] cmds;
        String[] stdOut;

        /***step1***/
        cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_CHECK_NETBIOS,
                      etcPath,
                      globle,
                      netBios};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        stdOut = ret.getStdout();
        if (ret.getExitValue()!=0 || stdOut[0].trim().equals("exist")){
            if (stdOut[0].trim().equals("exist")){
                super.setMsg(
                    NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                    +NSMessageDriver.getInstance().getMessage(session,"nas_cifs/alert/nb_existed"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else if (fri_etcPath!=null){
            cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_CHECK_NETBIOS,
                      fri_etcPath,
                      globle,
                      netBios};
            ret = execCmd(cmds,null,friendGrpNo,false);
            stdOut = ret.getStdout();
            if (ret.getExitValue()!=0 || stdOut[0].trim().equals("exist")){
                if (stdOut[0].trim().equals("exist")){
                super.setMsg(
                    NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                    +NSMessageDriver.getInstance().getMessage(session,"nas_cifs/alert/nb_existed"));
                } else{
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
                }
                return false;
            }
        }

        /***step2***/
        //get all export root information
        if (domainType.equals("dmc") || domainType.equals("ads") || domainType.equals("shr")){
            String compStr = "";
            if (domainType.equals("dmc")){
                compStr = "domain";
            } else if(domainType.equals("ads")){
                compStr = "ads";
            } else{
                compStr = "share";
            }
            cmds = new String[] {
                          CMD_SUDO,
                          home + CMD_GET_ALLEXP_INFO,
                          etcPath};
            ret = execCmd(cmds,null,groupNo,false);
            if (ret.getExitValue()==0){
                stdOut = ret.getStdout();
                StringTokenizer st;
                for(int i=0;i<stdOut.length;i++){
                    if (stdOut[i].startsWith("localdomain ")){
                        st = new StringTokenizer(stdOut[i]);
                        st.nextToken();
                        if (st.nextToken().trim().equals(domainName)){
                            st = new StringTokenizer(stdOut[i+2]);
                            if (st.countTokens()==2){
                                st.nextToken();
                                String sType = st.nextToken().trim();
                                if ((sType.equals("domain")
                                    ||sType.equals("ads")
                                    ||sType.equals("share")) && !sType.equals(compStr)){ 
                                    super.setMsg(
                                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/diff_domtype"));
                                    return false;
                                }
                            }
                        }
                    }
                }
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
                return false;
            }
        }

        /***step3***/
        String ntDomain;
        if (domainType.equals("nis") || domainType.equals("pwd") || domainType.equals("ldap")){
            ntDomain = domainName + "+" + netBios;
            domainType = domainType.equals("ldap")?"ldu":domainType;
        } else{
            ntDomain = domainName;
        }
        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_GET_NATIVEDOMAIN,
                        etcPath,
                        ntDomain,
                        "win"};
        ret = execCmd(cmds,null,groupNo,false);
        if (ret.getExitValue()==0){
            stdOut = ret.getStdout();
            if (stdOut.length==0){
                return true;   
            }
            if (!stdOut[1].trim().startsWith(domainType)){
                super.setMsg(
                  NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                  +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/diff_native"));
                return false;
            }
        } else{
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            return false;
        }
        return true;
    }

    /**
      *Function
      *  step1: check whether the specified nisdomain is used by other nisserver on both node.
      *         if it is, then return false;
      *  step2: execute userdb_addnisdomain.pl
      *Parameter
      *  fstype:       sxfs or sxfsfw
      *  export:       eg:"/export/zhangjx"
      *  groupNo:      0 or 1
      *  friendGrpNo:  1 or 0
      *  isCluster:    true or false
      *Return:
      *  false:   the specified nisdomain is used by other nisserver
      *           or failed to add
      *  true:    successed to add
     **/
    private boolean addNISDomain(String fsType,String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        boolean is4Win = fsType.equals("sxfs")?false:true;
        String domainName = is4Win?request.getParameter("win_domainname"):"";
        String netBios = is4Win?request.getParameter("win_computername"):"";
        String nisDomain = is4Win?request.getParameter("win_nisdomain"):request.getParameter("unix_nisdomain");
        String nisServer = is4Win?request.getParameter("win_nisserver"):request.getParameter("unix_nisserver");
        String[] cmds;
        String[] stdOut;
        int exitValue;

        /***step1***/
        cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_CHECK_NISDOMAIN,
                      nisDomain};

        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        if (ret.getExitValue()==0){
            stdOut = ret.getStdout();
            if (!stdOut[0].trim().equals("") &&!stdOut[0].trim().equals(nisServer)){
                super.setMsg(
                  NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                  +NSMessageDriver.getInstance().getMessage(session,"exception/mapd/authdomain_same"));
                return false;
            }
        } else{
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            return false;
        }
        if (isCluster){
            cmds = new String[] {
                      CMD_SUDO,
                      home + CMD_CHECK_NISDOMAIN,
                      nisDomain};
            ret = execCmd(cmds,null,friendGrpNo,false);
            if (ret.getExitValue()==0){
                stdOut = ret.getStdout();
                if (!stdOut[0].trim().equals("") &&!stdOut[0].trim().equals(nisServer)){
                    super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"exception/mapd/authdomain_same"));
                    return false;
                }
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
                return false;
            }
        }

        /***step2***/
        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_ADD_NISDOMAIN,
                    fsType,
                    export,
                    (new Integer(groupNo)).toString(),
                    nisDomain,
                    nisServer,
                    domainName,
                    netBios,
                    "false"};

        ret = execCmd(cmds,null,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_ADD_NISDOMAIN,
                        fsType,
                        export,
                        (new Integer(friendGrpNo)).toString(),
                        nisDomain,
                        nisServer,
                        domainName,
                        netBios,
                        "true"};
            ret = execCmd(cmds,null,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
            } else if (exitValue==6){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/nis_server_failed"));
            } else if (exitValue==8){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/msg_no_interface"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  add LDAP Domain
      *Parameter
      *  fstype:       sxfs or sxfsfw
      *  export:       eg:"/export/zhangjx"
      *  groupNo:      0 or 1
      *  friendGrpNo:  1 or 0
      *  isCluster:    true or false
      *Return:
      *  false:   failed to add
      *  true:    successed to add
     **/
    private boolean addLDAPDomain(String fsType,String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        boolean is4Win = fsType.equals("sxfs")?false:true;
        String domainName = is4Win?request.getParameter("win_domainname"):"";
        String netBios = is4Win?request.getParameter("win_computername"):"";
        String ldapServer = is4Win?request.getParameter("win_ldapServer"):request.getParameter("unix_ldapServer");
        String baseDN = is4Win?request.getParameter("win_ldapId"):request.getParameter("unix_ldapId");
        String authType = is4Win?request.getParameter("win_ldapMode"):request.getParameter("unix_ldapMode");
        String tls = is4Win?request.getParameter("win_ldapTls"):request.getParameter("unix_ldapTls");
        String authName = is4Win?request.getParameter("win_ldapAuthName"):request.getParameter("unix_ldapAuthName");
        authName = (authName==null)?"":authName;
        String CA = is4Win?request.getParameter("win_ldapCaFileText"):request.getParameter("unix_ldapCaFileText");
        CA = (CA==null)?"":CA;
        String userFilter = is4Win?request.getParameter("win_user_filter"):request.getParameter("unix_user_filter");
        String grpFilter = is4Win?request.getParameter("win_group_filter"):request.getParameter("unix_group_filter");
        String pwd = is4Win?request.getParameter("_win_ldapAuthPassword"):request.getParameter("_unix_ldapAuthPassword");
        String un2dnFlag = request.getParameter("un2dn");
        if (un2dnFlag==null){
               un2dnFlag = "n";
        }
        pwd = (pwd==null)?"":pwd;
        String[] cmds;
        String[] input;
        int exitValue;

        cmds = new String[] {
                     CMD_SUDO,
                     home + CMD_ADD_LDAPDOMAIN,
                     "false",
                     export,
                     fsType,
                     (new Integer(groupNo)).toString(),
                     domainName,
                     netBios,
                     ldapServer,
                     baseDN,
                     authType,
                     tls,
                     authName,
                     CA,
                     userFilter,
                     grpFilter,
                     un2dnFlag};
         input = new String[] {pwd};
         NSCmdResult ret = execCmd(cmds,input,groupNo,false);
         exitValue = ret.getExitValue();
         if (exitValue==0 && isCluster){
             cmds = new String[] {
                         CMD_SUDO,
                         home + CMD_ADD_LDAPDOMAIN,
                         "true",
                         export,
                         fsType,
                         (new Integer(friendGrpNo)).toString(),
                         domainName,
                         netBios,
                         ldapServer,
                         baseDN,
                         authType,
                         tls,
                         authName,
                         CA,
                         userFilter,
                         grpFilter,
                         un2dnFlag};
             input = new String[] {pwd};
             ret = execCmd(cmds,input,friendGrpNo,true);
             if (ret.getExitValue()!=0){
                return false;   
            }
         }
         if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
            } else if (exitValue==6){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ldapAddFail"));
            } else if (exitValue==8){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/msg_no_interface"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  add PWD Domain
      *Parameter
      *  fstype:       sxfs or sxfsfw
      *  export:       eg:"/export/zhangjx"
      *  groupNo:      0 or 1
      *  friendGrpNo:  1 or 0
      *  isCluster:    true or false
      *Return:
      *  false:   failed to add
      *  true:    successed to add
     **/
    private boolean addPWDDomain(String fsType,String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        boolean is4Win = fsType.equals("sxfs")?false:true;
        String domainName = is4Win?request.getParameter("win_domainname"):"";
        String netBios = is4Win?request.getParameter("win_computername"):"";
        String ludbName = is4Win?request.getParameter("win_ludbname"):request.getParameter("unix_ludbname");
        String cmds[];
        int exitValue;

        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_ADD_PWDDOMAIN,
                    "false",
                    (new Integer(groupNo)).toString(),
                    export,
                    fsType,
                    ludbName,
                    domainName,
                    netBios};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_ADD_PWDDOMAIN,
                        "true",
                        (new Integer(friendGrpNo)).toString(),
                        export,
                        fsType,
                        ludbName,
                        domainName,
                        netBios};
            ret = execCmd(cmds,null,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
            } else if (exitValue==8){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/msg_no_interface"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  add DMC Domain
      *Parameter
      *  export:       eg:"/export/zhangjx"
      *  groupNo:      0 or 1
      *  friendGrpNo:  1 or 0
      *  isCluster:    true or false
      *Return:
      *  false:   failed to add
      *  true:    successed to add
     **/
    private boolean addDMCDomain(String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String user = request.getParameter("win_dmc_user");
        String pwd = request.getParameter("_win_dmc_passwd");
        String[] cmds;
        String[] input;
        int exitValue;

        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_ADD_DMCDOMAIN,
                    "false",
                    (new Integer(groupNo)).toString(),
                    export,
                    user,
                    domainName,
                    netBios};
        input = new String[] {pwd};
        NSCmdResult ret = execCmd(cmds,input,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
             cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_ADD_DMCDOMAIN,
                        "true",
                        (new Integer(friendGrpNo)).toString(),
                        export,
                        user,
                        domainName,
                        netBios};
            ret = execCmd(cmds,input,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
            } else if (exitValue==7){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/dmc_passwd_failed"));
            } else if (exitValue==8){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/msg_no_interface"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  add ADS Domain
      *Parameter
      *  export:       eg:"/export/zhangjx"
      *  groupNo:      0 or 1
      *  friendGrpNo:  1 or 0
      *  isCluster:    true or false
      *Return:
      *  false:   failed to add
      *  true:    successed to add
     **/
    private boolean addADSDomain(String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String dnsServer = request.getParameter("win_dns");
        String kdc = request.getParameter("win_kdc");
        String user = request.getParameter("win_ads_user");
        String pwd = request.getParameter("_win_ads_passwd");
        String dc = request.getParameter("win_dclist");
        String isJoin = request.getParameter("isJoin");
        if (isJoin.equals("false")){
        	pwd = "";
        	user = "";
        }
        if (dc == null || dc.trim().equals("")){
        	dc = "";
        }
        if (kdc == null){
        	kdc = dc;
        }
        String[] cmds;
        String[] input;
        int exitValue;

        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_ADD_ADSDOMAIN,
                        "false",
                        export,
                        (new Integer(groupNo)).toString(),
                        domainName,
                        netBios,
                        dnsServer,
                        kdc,
                        user,
						dc,
						isJoin};
        input = new String[] {pwd};
        NSCmdResult ret = execCmd(cmds,input,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                            CMD_SUDO,
                            home + CMD_ADD_ADSDOMAIN,
                            "true",
                            export,
                            (new Integer(friendGrpNo)).toString(),
                            domainName,
                            netBios,
                            dnsServer,
                            kdc,
                            user,
							dc,
							isJoin};
            ret = execCmd(cmds,input,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
            } else if (exitValue==7){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ads_passwd_failed"));
            } else if (exitValue==8){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/msg_no_interface"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  add SHR Domain
      *Parameter
      *  export:       eg:"/export/zhangjx"
      *  groupNo:      0 or 1
      *  friendGrpNo:  1 or 0
      *  isCluster:    true or false
      *Return:
      *  false:   failed to add
      *  true:    successed to add
     **/
    private boolean addSHRDomain(String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String[] cmds;
        int exitValue;

        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_ADD_SHRDOMAIN,
                        "false",
                        export,
                        (new Integer(groupNo)).toString(),
                        domainName,
                        netBios};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                            CMD_SUDO,
                            home + CMD_ADD_SHRDOMAIN,
                            "true",
                            export,
                            (new Integer(friendGrpNo)).toString(),
                            domainName,
                            netBios};
            ret = execCmd(cmds,null,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_add_domain"));
            } else if (exitValue==8){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/msg_no_interface"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  change NIS Server
      *Parameter
      *  fstype:         sxfs or sxfsfw
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to change
      *  false:  failed to change
     **/
    private boolean changeNISDomain(String fsType,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        boolean is4Win = fsType.equals("sxfs")?false:true;
        String nisDomain = is4Win?request.getParameter("win_nisdomain"):request.getParameter("unix_nisdomain");
        String nisServer = is4Win?request.getParameter("win_nisserver"):request.getParameter("unix_nisserver");
        String[] cmds;
        int exitValue;

        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_CHANGE_NISDOMAIN,
                        nisDomain,
                        nisServer};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                            CMD_SUDO,
                            home + CMD_CHANGE_NISDOMAIN,
                            nisDomain,
                            nisServer};
            ret = execCmd(cmds,null,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_change_domain"));
            } else if (exitValue==6){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/nis_server_failed"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  change LDAP
      *Parameter
      *  fstype:         sxfs or sxfsfw
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *Return
      *  true:   successed to change
      *  false:  failed to change
     **/
    private boolean changeLDAPDomain(String fsType,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        boolean is4Win = fsType.equals("sxfs")?false:true;
        String ldapServer = is4Win?request.getParameter("win_ldapServer"):request.getParameter("unix_ldapServer");
        String baseDN = is4Win?request.getParameter("win_ldapId"):request.getParameter("unix_ldapId");
        String authType = is4Win?request.getParameter("win_ldapMode"):request.getParameter("unix_ldapMode");
        String tls = is4Win?request.getParameter("win_ldapTls"):request.getParameter("unix_ldapTls");
        String authName = is4Win?request.getParameter("win_ldapAuthName"):request.getParameter("unix_ldapAuthName");
        authName = (authName==null)?"":authName;
        String CA = is4Win?request.getParameter("win_ldapCaFileText"):request.getParameter("unix_ldapCaFileText");
        CA = (CA==null)?"":CA;
        String userFilter = is4Win?request.getParameter("win_user_filter"):request.getParameter("unix_user_filter");
        String grpFilter = is4Win?request.getParameter("win_group_filter"):request.getParameter("unix_group_filter");
        String pwd = is4Win?request.getParameter("_win_ldapAuthPassword"):request.getParameter("_unix_ldapAuthPassword");
        String un2dnFlag = request.getParameter("un2dn");
        if (un2dnFlag==null){
               un2dnFlag = "n";
        }
        pwd = (pwd==null)?"":pwd;
        String[] cmds;
        String[] input;
        int exitValue;
        cmds = new String[] {
                     CMD_SUDO,
                     home + CMD_CHANGE_LDAPDOMAIN,
                     (new Integer(groupNo)).toString(),
                     ldapServer,
                     baseDN,
                     authType,
                     tls,
                     authName,
                     CA,
                     userFilter,
                     grpFilter,
                     un2dnFlag};
         input = new String[] {pwd};
         NSCmdResult ret = execCmd(cmds,input,groupNo,false);
         exitValue = ret.getExitValue();
         if (exitValue==0 && isCluster){
             cmds = new String[] {
                         CMD_SUDO,
                         home + CMD_CHANGE_LDAPDOMAIN,
                         (new Integer(friendGrpNo)).toString(),
                         ldapServer,
                         baseDN,
                         authType,
                         tls,
                         authName,
                         CA,
                         userFilter,
                         grpFilter,
                         un2dnFlag};
             ret = execCmd(cmds,input,friendGrpNo,true);
             if (ret.getExitValue()!=0){
                return false;   
            }
         }
         if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_change_domain"));
            } else if (exitValue==6){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ldapAddFail"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  change DMC domain
      *Parameter
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to change
      *  false:  failed to change
     **/
    private boolean changeDMCDomain(int groupNo) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String user = request.getParameter("win_dmc_user");
        String pwd = request.getParameter("_win_dmc_passwd");
        String[] cmds;
        String[] input;
        int exitValue;
        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_CHANGE_DMCDOMAIN,
                    (new Integer(groupNo)).toString(),
                    user,
                    domainName,
                    netBios};
        input = new String[] {pwd};
        NSCmdResult ret = execCmd(cmds,input,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_change_domain"));
            } else if (exitValue==7){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/dmc_passwd_failed"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  change ADS domain
      *Parameter
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to change
      *  false:  failed to change
     **/
    private boolean changeADSDomain(String export,int groupNo,int friendGrpNo,boolean isCluster) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String dnsServer = request.getParameter("win_dns");
        String kdc = request.getParameter("win_kdc");
        String user = request.getParameter("win_ads_user");
        String pwd = request.getParameter("_win_ads_passwd");
        String dc = request.getParameter("win_dclist");
        String isJoin = request.getParameter("isJoin");
        if (isJoin.equals("false")){
        	user = "";
        	pwd = "";
        }
        if (dc==null || dc.trim().equals("")){
        	dc = "";
        }
        if (kdc==null){
        	kdc = dc;
        }
        String[] cmds;
        String[] input;
        int exitValue;

        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_CHANGE_ADSDOMAIN,
                        "false",
                        export,
                        (new Integer(groupNo)).toString(),
                        domainName,
                        netBios,
                        dnsServer,
                        kdc,
                        user,
						dc,
						isJoin};
        input = new String[] {pwd};
        NSCmdResult ret = execCmd(cmds,input,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                            CMD_SUDO,
                            home + CMD_CHANGE_ADSDOMAIN,
                            "true",
                            export,
                            (new Integer(friendGrpNo)).toString(),
                            domainName,
                            netBios,
                            dnsServer,
                            kdc,
                            user,
							dc,
							isJoin};
            ret = execCmd(cmds,input,friendGrpNo,true);
            if (ret.getExitValue()!=0){
                return false;   
            }
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_change_domain"));
            } else if (exitValue==7){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ads_passwd_failed"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  delete NIS domain
      *Parameter
      *  fstype:         sxfs or sxfsfw
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/
    private boolean delNISDomain(String fsType,String export,int groupNo,int friendGrpNo,boolean isCluster,DomainInfo domain) throws Exception{
        String domainName = domain.getNtdomain();
        String netBios = domain.getNetbios();
        String nisDomain = domain.getNisdomain();
        String nisServer = domain.getNisserver();
        String[] cmds;
        int exitValue;

        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_DEL_NISDOMAIN,
                    fsType,
                    export,
                    (new Integer(groupNo)).toString(),
                    nisDomain,
                    nisServer,
                    domainName,
                    netBios,
                    "false"};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_DEL_NISDOMAIN,
                        fsType,
                        export,
                        (new Integer(friendGrpNo)).toString(),
                        nisDomain,
                        nisServer,
                        domainName,
                        netBios,
                        "true"};
            execCmd(cmds,null,friendGrpNo,false);
        }
        if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_domain"));
            } else if (exitValue==6){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/nis_server_failed"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  delete LDAP domain
      *Parameter
      *  fstype:         sxfs or sxfsfw
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/
    private boolean delLDAPDomain(String fsType,String export,int groupNo,int friendGrpNo,boolean isCluster,DomainInfo domain) throws Exception{
        String domainName = domain.getNtdomain();
        String netBios = domain.getNetbios();
        String ldapServer = domain.getLdapserver();
        String[] cmds;
        int exitValue;

        cmds = new String[] {
                     CMD_SUDO,
                     home + CMD_DEL_LDAPDOMAIN,
                     "false",
                     export,
                     fsType,
                     (new Integer(groupNo)).toString(),
                     domainName,
                     netBios,
                     ldapServer};
         NSCmdResult ret = execCmd(cmds,null,groupNo,false);
         exitValue = ret.getExitValue();
         if (exitValue==0 && isCluster){
             cmds = new String[] {
                         CMD_SUDO,
                         home + CMD_DEL_LDAPDOMAIN,
                         "true",
                         export,
                         fsType,
                         (new Integer(friendGrpNo)).toString(),
                         domainName,
                         netBios,
                         ldapServer};
             execCmd(cmds,null,friendGrpNo,false);
             
         }
         if (exitValue!=0){
            if (exitValue==1){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_domain"));
            } else if (exitValue==6){
                super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/ldapAddFail"));
            } else{
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            }
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  delete PWD domain
      *Parameter
      *  fstype:         sxfs or sxfsfw
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/
    private boolean delPWDDomain(String fsType,String export,int groupNo,int friendGrpNo,boolean isCluster,DomainInfo domain) throws Exception{
        String domainName = domain.getNtdomain();
        String netBios = domain.getNetbios();
        String ludbName = domain.getLudb();
        String cmds[];
        int exitValue;

        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_DEL_PWDDOMAIN,
                    "false",
                    (new Integer(groupNo)).toString(),
                    export,
                    ludbName,
                    fsType,
                    domainName,
                    netBios};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        exitValue = ret.getExitValue();
        if (exitValue==0 && isCluster){
            cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_DEL_PWDDOMAIN,
                        "true",
                        (new Integer(friendGrpNo)).toString(),
                        export,
                        ludbName,
                        fsType,
                        domainName,
                        netBios};
            execCmd(cmds,null,friendGrpNo,false);
            
        }
        if (exitValue!=0){
            super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_domain"));
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  delete DMC domain
      *Parameter
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/
    private boolean delDMCDomain(String export,int groupNo,DomainInfo domain) throws Exception{
        String domainName = domain.getNtdomain();
        String netBios = domain.getNetbios();
        String[] cmds;
        cmds = new String[] {
                    CMD_SUDO,
                    home + CMD_DEL_DMCDOMAIN,
                    (new Integer(groupNo)).toString(),
                    export,
                    domainName,
                    netBios};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        if (ret.getExitValue()!=0){
            super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_change_domain"));
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  delete ADS domain
      *Parameter
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/
    private boolean delADSDomain(String export,int groupNo,DomainInfo domain) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String[] cmds;

        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_DEL_ADSDOMAIN,
                        export,
                        (new Integer(groupNo)).toString(),
                        domainName,
                        netBios};

        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        if (ret.getExitValue()!=0){
            super.setMsg(
                  NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                  +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_domain"));
            return false;
        } else{
            return true;
        }
    }

    /**
      *Function
      *  delete SHR domain
      *Parameter
      *  export:         eg:"/export/zhangjx"
      *  groupNo:        0 or 1
      *  friendGroupNo:  1 or 0
      *  isCluster:      true or false
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/
    private boolean delSHRDomain(String export,int groupNo,DomainInfo domain) throws Exception{
        String domainName = request.getParameter("win_domainname");
        String netBios = request.getParameter("win_computername");
        String[] cmds;
        cmds = new String[] {
                        CMD_SUDO,
                        home + CMD_DEL_SHRDOMAIN,
                        (new Integer(groupNo)).toString(),
                        export,
                        domainName,
                        netBios};
        NSCmdResult ret = execCmd(cmds,null,groupNo,false);
        if (ret.getExitValue()!=0){
            super.setMsg(
                      NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                      +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_domain"));
            return false;
        } else{
            return true;
        }
    }

    private NSCmdResult execCmd(String[] cmds, String[] input, int groupNo, boolean setFriErr) throws Exception{
        NSCmdResult ret = new NSCmdResult();
        if (input==null){
            ret = CmdExecBase.execCmd(cmds,groupNo,false);
        } else{
            ret = CmdExecBase.execCmd(cmds,input,groupNo,false);
        }
        int exitValue = ret.getExitValue();
        if (exitValue != 0){
            if (setFriErr){
                 super.setMsg(NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/friendfailed"));  
            } else if (exitValue!=6 && exitValue!=7 && exitValue!=8){
                String[] errMsg = ret.getStderr();
                StringBuffer sb = new StringBuffer();
                for (int i=0;i<errMsg.length;i++){
                    sb.append(errMsg[i]);
                    sb.append("\r\n");
                }
                throw new Exception(sb.toString());
            }
        }
        return ret;
    }
    public String isDHenable() throws Exception {
	    groupNo = NSActionUtil.getCurrentNodeNo(request);
		String[] cmds = new String[] { CMD_SUDO, home + CMD_CHECK_DIRECTHOSTING , new Integer(groupNo).toString()};
		NSCmdResult cmdResult = CmdExecBase.execCmd(cmds , groupNo , true);
		String[] stdout = cmdResult.getStdout();
	    return stdout[0];
	}
	
	/**
      *Function
      *  delete Server Protect configuration file
      *Parameter
      *  groupNo:        0 or 1
      *Return
      *  true:   successed to delete
      *  false:  failed to delete
     **/	
    private boolean delServerProtectConf(int groupNo) throws Exception{
        String netBios = request.getParameter("win_computername");
        String[] cmds = new String[] {CMD_SUDO,
                         home + CMD_DEL_SPCONF,
                         netBios, Integer.toString(groupNo)};     
        NSCmdResult ret = CmdExecBase.execCmd(cmds, groupNo, false);
        if (ret.getExitValue()!=0){
            super.setMsg(
            	 NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                 +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_sp"));    
            return false;
        } else{
            return true;
        }
    }	
    
    /**
      *Function
      *  check whether this domain has Server Protect configuration file
      *Parameter
      *  null
      *Return
      *  true:   has the file
      *  false:  does not have the file    
     **/
    public boolean hasServerProtectConf() throws Exception{
        String netBios = info4Win.getNetbios();
        if(netBios == null || netBios.equals("")) {
            return false;
        }
        String dType = info4Win.getDomainType();
        if(!dType.equals("ads")) {
            return false;
        }
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = new String[] {CMD_SUDO,
                        home + CMD_EXIST_SPCONF,
                        Integer.toString(groupNo), netBios};
        NSCmdResult ret = CmdExecBase.execCmd(cmds, groupNo);
        if(ret.getStdout()[0].equals("yes")) {
            return true;
        } else {
            return false;
        }        
    }
    
    /**
     *Function----check whether this domain has schedule scan configuration info
     *Parameter---null
     *Return
     *    true----has schedule scan configuration info
     *    false---does not schedule scan configuration info
    **/
    public boolean hasScheduleScanConf() throws Exception{
        String dType = info4Win.getDomainType();
        if(!dType.equals("ads")){
            return false;
        }
        String expgrpPath = getExportRoot();
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        
        String[] cmds = {CMD_SUDO,
                home + CMD_EXIST_SSCONF,
                Integer.toString(groupNo), expgrpPath};
        NSCmdResult ret = CmdExecBase.execCmd(cmds, groupNo);
        return ret.getStdout()[0].equals("yes");
    }
    
    /**
     *Function----delete the schedule scan configuration info
     *Parameter---null
     *Return
     *    true----successed to delete
     *    false---failed to delete
    **/
    public boolean delScheduleScanConf() throws Exception{
        String expgrpPath = getExportRoot();
        groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = {CMD_SUDO,
                            home + CMD_DEL_SSCONF,
                            Integer.toString(groupNo), expgrpPath};
        NSCmdResult ret = CmdExecBase.execCmd(cmds, groupNo, false);
        if (ret.getExitValue()!=0){
            super.setMsg(
                NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"\\r\\n"
                +NSMessageDriver.getInstance().getMessage(session,"nas_mapd/alert/failed_del_ss"));
            return false;
        }
        return true;
    }
    
     /**
     * Function----check if has the sxfs anti-virus share or not.
     * Parameter---null
     * @return
     *     true----have sxfs anti-virus share.
     *     false---no sxfs anti-virus share.
     * @throws Exception
     */
    public boolean hasSxfsAntiVirusShare() throws Exception {
        int groupNumber = NSActionUtil.getCurrentNodeNo(request);
        String domainName = info4Win.getNtdomain();
        String netBios = info4Win.getNetbios();
        if(domainName == null || domainName.equals("") || netBios == null || netBios.equals("")) {
        	return false;
        }
        String[] cmds = {CMD_SUDO,
        		             home + CMD_HAVEANTIVIRUSSHARE,
        		             Integer.toString(groupNumber), domainName, netBios, "sxfs"
        };
        NSCmdResult ret = CmdExecBase.execCmd(cmds, groupNumber);
        if(ret.getStdout().length > 0 && ret.getStdout()[0].equalsIgnoreCase("yes")) {
        	return true;
        } else {
        	return false;
        }
    }
    
}