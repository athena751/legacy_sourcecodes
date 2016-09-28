<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: userdbdomainconf.jsp,v 1.30 2008/12/18 08:14:32 wanghui Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP" buffer="32kb"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*
                                  ,com.nec.sydney.atom.admin.mapd.*
                                  ,com.nec.sydney.beans.base.*
                                  ,com.nec.nsgui.model.biz.cifs.CifsCmdHandler
                                  ,com.nec.nsgui.model.biz.domain.DomainHandler
                                  ,com.nec.nsgui.action.base.*"%>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.beans.mapd.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="infoBean" scope="page" class="com.nec.sydney.beans.mapd.UserDBDomainConfBean"/>

<%AbstractJSPBean _abstractJSPBean = infoBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<%
	boolean dispCheckBox_U = false;
    boolean dispCheckBox_W = false;
    String dispMode = request.getParameter("dispMode");
    String fromWhere = request.getParameter("fromWhere");
    DomainInfo domain4Unix = infoBean.getDomain4Unix();
    DomainInfo domain4Win = infoBean.getDomain4Win();
    String dc = infoBean.getDC4ADS();
    String dh = new String();
    if (domain4Unix!=null && domain4Unix.getDomainType().equals("")){
    	dispCheckBox_U = true;
    }
    if (domain4Win!=null && domain4Win.getDomainType().trim().equals("")){
    	dispCheckBox_W = true;
    	dh = infoBean.isDHenable();
    }
    boolean hasLDAPSam = infoBean.hasLDAPSam();
    boolean isBusy = infoBean.isBusy();
    boolean hasSPConf = infoBean.hasServerProtectConf();
    boolean hasSSConf = infoBean.hasScheduleScanConf();
    boolean haveSxfsAntiVirusShare = infoBean.hasSxfsAntiVirusShare();
    String tls_no = "";
    String tls_start = "";
    String tls_yes = "";

    String ldapMode_A = "";
    String ldapMode_S = "";
    String ldapMode_D = "";
    String ldapMode_C = "";
    String[] ludbList = infoBean.getLUDBList();
    int ludbLength = ludbList.length;

    //get ldap info
    if (domain4Unix!=null || domain4Win!=null){
        DomainInfo ldap = (domain4Win==null)?domain4Unix:domain4Win;
        String tls = ldap.getTls().trim();
        if (tls.equals("") || tls.equals("no")){
            tls_no = "checked";
        }
        tls_start = tls.equals("start_tls")?"checked":"";
        tls_yes = tls.equals("yes")?"checked":"";
        
        String ldapMode = ldap.getMech().trim();
        ldapMode_A = ldapMode.equals("Anonymous")?"selected":"";
        ldapMode_S = ldapMode.equals("SIMPLE")?"selected":"";
        ldapMode_D = ldapMode.equals("DIGEST-MD5")?"selected":"";
        ldapMode_C = ldapMode.equals("CRAM-MD5")?"selected":"";
    }
    String export = NSActionUtil.getExportGroupPath(request);
%>

<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link rel="stylesheet" href="<%=request.getContextPath()+NSActionConst.DEFAULT_CSS_FILE_NAME%>" type="text/css">

<!-- for displaying the waitting page -->
<script src="../common/general.js"></script>
<script src="/nsadmin/common/common.js"></script>

<script language="javaScript">
var lastIndex_u;
var lastIndex_w;
var popWinFile;
function onInit(){
    <%if (dispCheckBox_U && dispMode.equals("sxfs")){%>
        document.forms[0].unix.checked = true;
        document.forms[0].del_unixdomain.disabled = true;
        changeDisp();
    <%}
        if (dispCheckBox_W && dh.equals("yes")){%>
      	  lock(document.forms[0].windows);
 	<%}
 	    if (dispCheckBox_W && dh.equals("no") && dispMode.equals("sxfsfw")){%>
        document.forms[0].windows.checked = true;
        document.forms[0].del_windomain.disabled = true;
        if(document.forms[0].change_name){
            document.forms[0].change_name.disabled = true;
        }
        changeDisp();
    <%}%>
    if (document.forms[0].unix_ldapMode
        && !document.forms[0].unix_ldapMode.disabled
        && document.forms[0].unix_ldapMode.selectedIndex==0){
        lock(document.forms[0].unix_ldapAuthName);
        lock(document.forms[0]._unix_ldapAuthPassword);
        lock(document.forms[0]._unix_ldapAuthPasswordRe);                
    }

    if (document.forms[0].win_ldapMode
        && !document.forms[0].win_ldapMode.disabled
        && document.forms[0].win_ldapMode.selectedIndex==0){
        lock(document.forms[0].win_ldapAuthName);
        lock(document.forms[0]._win_ldapAuthPassword);
        lock(document.forms[0]._win_ldapAuthPasswordRe);        
    }
    if (document.forms[0].win_ldapMode && document.forms[0].win_un2dn){
        if(document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value=="Anonymous"
        ||document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value=="SIMPLE"){
            document.forms[0].win_un2dn.disabled=true;   
        }else {
            document.forms[0].win_un2dn.disabled=false;
        }
    }
    ldapChange();
    changeJoin();
    changedclist();
}


function changeJoin(){
    if (document.forms[0].joindomain && document.forms[0].isJoin 
        && document.forms[0].win_ads_user && document.forms[0]._win_ads_passwd){
        if (document.forms[0].joindomain.checked){
            document.forms[0].isJoin.value = "true";
            document.forms[0].win_ads_user.disabled = false;
            document.forms[0]._win_ads_passwd.disabled = false;
        }else{
            document.forms[0].isJoin.value = "false";
            document.forms[0].win_ads_user.disabled = true;
            document.forms[0]._win_ads_passwd.disabled = true;
        }
    }
}

function changedclist(){
    if (document.forms[0].win_dcsw && document.forms[0].win_dclist && document.forms[0].win_kdc){
        if (document.forms[0].win_dcsw[0].checked){
            document.forms[0].win_dclist.disabled = true;    
            document.forms[0].win_kdc.disabled = false;
        }else{
            document.forms[0].win_dclist.disabled = false;         
            document.forms[0].win_kdc.disabled = true;
            changeKdcVale();
        }
    }
}

function changeKdcVale(){
    document.forms[0].win_dclist.value = trim(document.forms[0].win_dclist.value);
    if (document.forms[0].win_dclist.value != ""){
        document.forms[0].win_kdc.value = document.forms[0].win_dclist.value;
    }
}

function showtab_unix(str){
	document.getElementById("unix_nis").style.display = "none";
	document.getElementById("unix_pwd").style.display = "none";
	document.getElementById("unix_ldap").style.display = "none";
	document.getElementById(str).style.display = "block";
	if (str=="unix_nis"){
	    document.forms[0].domainType_U.value = "unix_selenis";
	}else if (str=="unix_pwd"){
	    document.forms[0].domainType_U.value = "unix_selepwd";
	}else{
	    document.forms[0].domainType_U.value = "unix_seleldap";
	}
}

function showtab_win(str){
	document.getElementById("win_nis").style.display = "none";
	document.getElementById("win_pwd").style.display = "none";
	document.getElementById("win_ldap").style.display = "none";
	document.getElementById("win_dmc").style.display = "none";
	document.getElementById("win_shr").style.display = "none";
	document.getElementById("win_ads").style.display = "none";
	document.getElementById(str).style.display = "block";
	if (str=="win_ads"){
	    document.forms[0].domainType_W.value = "win_seleads";
	    document.forms[0].win_domainname.value = document.forms[0].win_domainname_ads.value;
	    document.forms[0].win_computername.value = document.forms[0].win_computername_ads.value;
	}else if(str=="win_dmc"){
	    document.forms[0].domainType_W.value = "win_seledmc";
	    document.forms[0].win_domainname.value = document.forms[0].win_domainname_dmc.value;
	    document.forms[0].win_computername.value = document.forms[0].win_computername_dmc.value;
	}else if (str=="win_shr"){
	    document.forms[0].domainType_W.value = "win_seleshr";
	    document.forms[0].win_domainname.value = document.forms[0].win_domainname_shr.value;
	    document.forms[0].win_computername.value = document.forms[0].win_computername_shr.value;
	}else if (str=="win_nis"){
	    document.forms[0].domainType_W.value = "win_selenis";
	    document.forms[0].win_domainname.value = document.forms[0].win_domainname_nis.value;
	    document.forms[0].win_computername.value = document.forms[0].win_computername_nis.value;
	}else if (str=="win_pwd"){
	    document.forms[0].domainType_W.value = "win_selepwd";
	    document.forms[0].win_domainname.value = document.forms[0].win_domainname_pwd.value;
	    document.forms[0].win_computername.value = document.forms[0].win_computername_pwd.value;
	}else {
	    document.forms[0].domainType_W.value = "win_seleldap";
	    document.forms[0].win_domainname.value = document.forms[0].win_domainname_ldap.value;
	    document.forms[0].win_computername.value = document.forms[0].win_computername_ldap.value;
	}
}

function changeDisp(){
	if (document.forms[0].unix && document.forms[0].unix.checked){
		document.getElementById("unix_domain").style.display = "block";
	}else if (document.forms[0].unix){
		document.getElementById("unix_domain").style.display = "none";
	}
	if (document.forms[0].windows && document.forms[0].windows.checked){
		document.getElementById("windows_domain").style.display = "block";
	}else if (document.forms[0].windows){
		document.getElementById("windows_domain").style.display = "none";
	}
}

function lock(name){
    name.disabled=true;
}

function unlock(name){
    name.disabled=false;
}

function changeLdapCAstatus(){
    if(document.forms[0].unix_ldapTls
       && document.forms[0].unix_ldapTls[0].checked){
        lock(document.forms[0].unix_ldapCaFileText);
        lock(document.forms[0].unix_ldapCaFileButton);
    }else if(document.forms[0].unix_ldapTls){
        unlock(document.forms[0].unix_ldapCaFileText);
        unlock(document.forms[0].unix_ldapCaFileButton);
    }
    if(document.forms[0].win_ldapTls
       && document.forms[0].win_ldapTls[0].checked){
        lock(document.forms[0].win_ldapCaFileText);
        lock(document.forms[0].win_ldapCaFileButton);
    }else if(document.forms[0].win_ldapTls){
        unlock(document.forms[0].win_ldapCaFileText);
        unlock(document.forms[0].win_ldapCaFileButton);
    }
}

function ldapChange(){
    if (document.forms[0].unix_ldapMode
        && !document.forms[0].unix_ldapMode.disabled ){
        <%if (hasLDAPSam){%>
            if(document.forms[0].unix_ldapMode.selectedIndex==0){
                document.forms[0].unix_ldapMode.selectedIndex=lastIndex_u;
                alert("<nsgui:message key="nas_mapd/alert/cannotSelectAnonymous"/>");
            }else{
                lastIndex_u=document.forms[0].unix_ldapMode.selectedIndex;
            }
        <%}%>
        var selectAuthType = document.forms[0].unix_ldapMode.options[document.forms[0].unix_ldapMode.selectedIndex].value;
        if (selectAuthType != "Anonymous"){
            unlock(document.forms[0].unix_ldapAuthName);
            unlock(document.forms[0]._unix_ldapAuthPassword);
            unlock(document.forms[0]._unix_ldapAuthPasswordRe);
        }else{
            lock(document.forms[0].unix_ldapAuthName);
            lock(document.forms[0]._unix_ldapAuthPassword);
            lock(document.forms[0]._unix_ldapAuthPasswordRe);
        }
    }
    if (document.forms[0].win_ldapMode
        && !document.forms[0].win_ldapMode.disabled ){
        <%if (hasLDAPSam){%>
            if(document.forms[0].win_ldapMode.selectedIndex==0){
                document.forms[0].win_ldapMode.selectedIndex=lastIndex_w;
                alert("<nsgui:message key="nas_mapd/alert/cannotSelectAnonymous"/>");
            }else{
                lastIndex_w=document.forms[0].win_ldapMode.selectedIndex;
            }
        <%}%>
        var selectAuthType = document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value;
        if (selectAuthType != "Anonymous"){
            unlock(document.forms[0].win_ldapAuthName);
            unlock(document.forms[0]._win_ldapAuthPassword);
            unlock(document.forms[0]._win_ldapAuthPasswordRe);
        }else{
            lock(document.forms[0].win_ldapAuthName);
            lock(document.forms[0]._win_ldapAuthPassword);
            lock(document.forms[0]._win_ldapAuthPasswordRe);
        }

    }
    if (document.forms[0].win_ldapMode && document.forms[0].win_un2dn){
        if(document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value=="Anonymous"
        ||document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value=="SIMPLE"){
            document.forms[0].win_un2dn.disabled=true;   
        }else {
            document.forms[0].win_un2dn.disabled=false;
        }
    }
}

function navigate(fstype){
    if(popWinFile==null||popWinFile.closed){
        if (fstype=="sxfs"){
            window.mpPath = document.forms[0].unix_ldapCaFileText;
            
            if (document.forms[0].unix_ldapCaFileText.value =="" || document.forms[0].unix_ldapCaFileText.value == '<%=NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select")%>') {
                document.forms[1].nowDirectory.value = document.forms[1].rootDirectory.value
            } else {
                document.forms[1].nowDirectory.value = document.forms[0].unix_ldapCaFileText.value;
            }
        }else{
            window.mpPath = document.forms[0].win_ldapCaFileText;
            if (document.forms[0].win_ldapCaFileText.value =="" || document.forms[0].win_ldapCaFileText.value == '<%=NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select")%>') {
                document.forms[1].nowDirectory.value = document.forms[1].rootDirectory.value
            } else {
                document.forms[1].nowDirectory.value = document.forms[0].win_ldapCaFileText.value;
            }
        }
        
        popWinFile = window.open("/nsadmin/common/commonblank.html","mapd_navigator", "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
        document.forms[1].submit();
    }else{
        if (fstype=="sxfs"){
            window.mpPath = document.forms[0].unix_ldapCaFileText;
        }else{
            window.mpPath = document.forms[0].win_ldapCaFileText;
        }
        popWinFile.focus();
    }
}


function toUpperDomain(obj){
    obj.value=obj.value.toUpperCase();
    document.forms[0].win_domainname.value = obj.value;
}

function toUpperComputer(obj){
    obj.value=obj.value.toUpperCase();
    document.forms[0].win_computername.value = obj.value;
}

function Set(obj,fstype){
    if (obj.disabled){
        return false;
    }
    if(isSubmitted()){
       return false;
    }
    if(fstype == 'sxfsfw'){
        <%
        int group = NSActionUtil.getCurrentNodeNo(request);
        String hasAvailableNicForCIFS = CifsCmdHandler.hasAvailableNicForCIFS(group);
        %>
        if("false" == "<%=hasAvailableNicForCIFS%>"){
            alert("<nsgui:message key="nas_cifs/alert/availableServiceNIC_null"/>");
            return false;
        }
    }
    document.forms[0].fsType.value = fstype;
    //check winodws domain
    if (fstype=="sxfsfw"){
        document.forms[0].win_domainname.value = gRTrim(document.forms[0].win_domainname.value);
        document.forms[0].win_computername.value = gRTrim(document.forms[0].win_computername.value);
        var domainName = document.forms[0].win_domainname.value;
        var computername = document.forms[0].win_computername.value;

        <%if (dispCheckBox_W){%>
            if(!checkNTDomainwithnode(domainName)){
                if(!confirm("<nsgui:message key="nas_mapd/nt/msg_info_domainwithnode"/>")){
                    return false;
                }
            }
        <%}%>
        if (!checkNTDomain(domainName)){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                    +"<nsgui:message key="nas_cifs/alert/l_d_ldname"/>");
            return false;
        }
        if (!checkName(computername)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +"<nsgui:message key="nas_cifs/alert/l_d_nb"/>");
            return false;
        }
        if(!checkHead(computername)){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                    +"<nsgui:message key="nas_common/alert/deny-"/>");
            return false;
        }

        <%  int groupNumber = NSActionUtil.getCurrentNodeNo(request);
            String[] hostName = DomainHandler.getHostName(groupNumber);
            for (int i=0 ; i<hostName.length ;i++){
                if(hostName[i] != null){%>
                    if ( computername == "<%=hostName[i]%>"){
                        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                            +"<nsgui:message key="nas_mapd/nt/msg_info_hostname"/>");
                        return false;
                    }
            <%}%>
        <%}%>

        //check DMC Domain
        if (document.forms[0].domainType_W.value=="win_seledmc"){
            document.forms[0].win_dmc_user.value = gRTrim(document.forms[0].win_dmc_user.value);
            if(checkWindowsUserName(document.forms[0].win_dmc_user.value)==false){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/nt_username"/>");
                return false;
            }
        }
        //check ADS Domain
        if (document.forms[0].domainType_W.value=="win_seleads"){
            document.forms[0].win_dns.value = trim(document.forms[0].win_dns.value);
            document.forms[0].win_kdc.value = trim(document.forms[0].win_kdc.value);
            document.forms[0].win_ads_user.value = gRTrim(document.forms[0].win_ads_user.value);
            document.forms[0].win_dclist.value = trim(document.forms[0].win_dclist.value);
            var dns = document.forms[0].win_dns.value;
            if(checkFQDN(dns)==false){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/dnsdomain"/>");
                return false;
            }            
            if(document.forms[0].win_dclist.disabled==false){
               if(document.forms[0].win_dclist.value=="" || checkKDCServer(document.forms[0].win_dclist)==false) {
                   document.forms[0].win_dclist.focus();
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/dc"/>");
                    return false;                
                }
                document.forms[0].win_kdc.value = document.forms[0].win_dclist.value;
            }
            if(document.forms[0].win_kdc.disabled==false
               && checkKDCServer(document.forms[0].win_kdc)==false) {
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/kdcserver"/>");
                return false;
            }
            if(document.forms[0].win_ads_user.disabled==false 
               && checkWindowsUserName(document.forms[0].win_ads_user.value)==false){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/nt_username"/>");
                return false;
            }
        }
    }
    //check NIS Domain
    if (fstype=="sxfsfw" && document.forms[0].domainType_W.value=="win_selenis"
        || fstype=="sxfs" && document.forms[0].domainType_U.value=="unix_selenis"){
        var nisdomain, nisserver,oldnisserver;
        if (fstype=="sxfsfw"){
            document.forms[0].win_nisdomain.value = gRTrim(document.forms[0].win_nisdomain.value);
            nisdomain = document.forms[0].win_nisdomain.value;
            document.forms[0].win_nisserver.value = gRTrim(document.forms[0].win_nisserver.value);
            //nisserver is a text object
            nisserver = document.forms[0].win_nisserver;
            oldnisserver = "<%=(domain4Win==null)?"":domain4Win.getNisserver()%>";
        } else{
            document.forms[0].unix_nisdomain.value = gRTrim(document.forms[0].unix_nisdomain.value);
            nisdomain = document.forms[0].unix_nisdomain.value;
            document.forms[0].unix_nisserver.value = gRTrim(document.forms[0].unix_nisserver.value);
            nisserver = document.forms[0].unix_nisserver;
            oldnisserver = "<%=(domain4Unix==null)?"":domain4Unix.getNisserver()%>";
        }
        if (checkNISDomain(nisdomain)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/unix_domain"/>");
                return false;
        }
        if (nisdomain=="localdomain") {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                  "<nsgui:message key="nas_mapd/alert/nis_localdomain"/>");
            return false;
        }
        if (checkNISServer(nisserver)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/unix_server"/>");
            return false;
        }
        if (nisserver.value == oldnisserver){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/unix_same_nis"/>");
            return false;
        }
    }

    //check PWD Domain
    if (fstype=="sxfsfw" && document.forms[0].domainType_W.value=="win_selepwd" && document.forms[0].win_ludbname
        || fstype=="sxfs" && document.forms[0].domainType_U.value=="unix_selepwd" && document.forms[0].unix_ludbname){
        var ludbName = "";
        if (fstype=="sxfsfw"){
            document.forms[0].win_ludbname.options[document.forms[0].win_ludbname.selectedIndex].value =
                gRTrim(document.forms[0].win_ludbname.options[document.forms[0].win_ludbname.selectedIndex].value);
            ludbName = document.forms[0].win_ludbname.options[document.forms[0].win_ludbname.selectedIndex].value;
        } else{
            document.forms[0].unix_ludbname.options[document.forms[0].unix_ludbname.selectedIndex].value =
                gRTrim(document.forms[0].unix_ludbname.options[document.forms[0].unix_ludbname.selectedIndex].value);
            ludbName = document.forms[0].unix_ludbname.options[document.forms[0].unix_ludbname.selectedIndex].value;
        }
        <%if (!infoBean.getHasLUDBList()){%>
            alert("<nsgui:message key="common/alert/failed"/>"
                + "\r\n" + "<nsgui:message key="nas_mapd/alert/noLUDB"/>");
            return false;
        <%}%>
    }
    //check LDAP Domain
    if (fstype=="sxfsfw" && document.forms[0].domainType_W.value=="win_seleldap"
        || fstype=="sxfs" && document.forms[0].domainType_U.value=="unix_seleldap"){
        var ldapserver, distinguashName, selectAuthType,ldapAuthName;
        var ldapAuthPassword, ldapAuthPasswordRe, ldapUserFilter, ldapGroupFilter;
        if (fstype=="sxfsfw"){
            document.forms[0].win_ldapServer.value = trim(document.forms[0].win_ldapServer.value);
            ldapserver = document.forms[0].win_ldapServer.value;
            document.forms[0].win_ldapId.value = trim(document.forms[0].win_ldapId.value);
            distinguashName = document.forms[0].win_ldapId.value;
            document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value =
                gRTrim(document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value);
            selectAuthType = document.forms[0].win_ldapMode.options[document.forms[0].win_ldapMode.selectedIndex].value;
            document.forms[0].win_ldapAuthName.value = gRTrim(document.forms[0].win_ldapAuthName.value);
            ldapAuthName = document.forms[0].win_ldapAuthName.value;
            ldapAuthPassword = document.forms[0]._win_ldapAuthPassword.value;
            document.forms[0].win_user_filter.value = trim(document.forms[0].win_user_filter.value);
            ldapUserFilter = document.forms[0].win_user_filter.value;
            document.forms[0].win_group_filter.value = trim(document.forms[0].win_group_filter.value);
            ldapGroupFilter = document.forms[0].win_group_filter.value;
            ldapAuthPasswordRe = document.forms[0]._win_ldapAuthPasswordRe.value;
            document.forms[0].win_ldapCaFileText.value = gRTrim(document.forms[0].win_ldapCaFileText.value);
            if (!document.forms[0].win_un2dn.disabled && document.forms[0].win_un2dn.checked){
                document.forms[0].un2dn.value = "y";
            }else{
                document.forms[0].un2dn.value = "n";
            }
        }else if (fstype=="sxfs"){
            document.forms[0].unix_ldapServer.value = trim(document.forms[0].unix_ldapServer.value);
            ldapserver = document.forms[0].unix_ldapServer.value;
            document.forms[0].unix_ldapId.value = trim(document.forms[0].unix_ldapId.value);
            distinguashName = document.forms[0].unix_ldapId.value;
            document.forms[0].unix_ldapMode.options[document.forms[0].unix_ldapMode.selectedIndex].value =
                gRTrim(document.forms[0].unix_ldapMode.options[document.forms[0].unix_ldapMode.selectedIndex].value);
            selectAuthType = document.forms[0].unix_ldapMode.options[document.forms[0].unix_ldapMode.selectedIndex].value;
            document.forms[0].unix_ldapAuthName.value = gRTrim(document.forms[0].unix_ldapAuthName.value);
            ldapAuthName = document.forms[0].unix_ldapAuthName.value;
            ldapAuthPassword =document.forms[0]._unix_ldapAuthPassword.value;
            document.forms[0].unix_user_filter.value = trim(document.forms[0].unix_user_filter.value);
            ldapUserFilter = document.forms[0].unix_user_filter.value;
            document.forms[0].unix_group_filter.value = trim(document.forms[0].unix_group_filter.value);
            ldapGroupFilter = document.forms[0].unix_group_filter.value;
            ldapAuthPasswordRe = document.forms[0]._unix_ldapAuthPasswordRe.value;
            document.forms[0].unix_ldapCaFileText.value = gRTrim(document.forms[0].unix_ldapCaFileText.value);
            if(document.forms[0].unix_ldapMode.options[document.forms[0].unix_ldapMode.selectedIndex].value=="Anonymous"
               ||document.forms[0].unix_ldapMode.options[document.forms[0].unix_ldapMode.selectedIndex].value=="SIMPLE"){
               document.forms[0].un2dn.value = "n";   
            }else{
               document.forms[0].un2dn.value = "<%=domain4Unix.getUn2dn()%>";
            }
            
        }
        if (checkLDAPServer(ldapserver)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/ldapServerInvalid"/>");
            return false;
        }
        if (checkPortNum(ldapserver)==false){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/portNumInvalid"/>");
            return false;
        }
        if (checkBaseDNName(distinguashName)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/ldapIDInvalid"/>");
            return false;
        }
        if (selectAuthType != "Anonymous"){
            if (ldapAuthName == ""){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/inputLdapAuthName"/>");
                return false;
            }
            if (ldapAuthPassword == ""){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/inputLdapPassName"/>");
                return false;
            }
            if (selectAuthType == "SIMPLE"){
                if (checkDistinguishedName(ldapAuthName)==false) {
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                          "<nsgui:message key="nas_mapd/alert/ldapAuthNameInvalid"/>");
                    return false;
                }
                if (ldapAuthPassword.length > 256){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                          "<nsgui:message key="nas_mapd/alert/ldapAuthPwdInvalid"/>");
                    return false;
                }
            }
            if (ldapAuthPassword != ldapAuthPasswordRe) {
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/passwordNotSame"/>");
                return false;
            }
        }
        if (checkCA(fstype)==false) {
            return false;
        }
        if (checkLdapFilter(ldapUserFilter)==false) {
           alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/ldapFilterInvalid"/>");
            if (fstype=="sxfsfw"){
                document.forms[0].win_user_filter.focus();
            } else{
                document.forms[0].unix_user_filter.focus();
            }
            return false;
        }
        if (checkLdapFilter(ldapGroupFilter)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/ldapFilterInvalid"/>");
            if (fstype=="sxfsfw"){
                document.forms[0].win_group_filter.focus();
            } else{
                document.forms[0].unix_group_filter.focus();
            }
            return false;
        }
    }

    var mesg = "<nsgui:message key="common/confirm" />" + "\r\n"
            + "<nsgui:message key="common/confirm/act" />"
            + "<nsgui:message key="common/button/submit"/>";
            
    if (fstype=="sxfsfw" && document.forms[0].domainType_W.value=="win_seleads"
        && document.forms[0].joindomain.checked==false){          
        <%if (dispCheckBox_W){%>
            mesg = "<nsgui:message key="nas_mapd/alert/adsjoinconfirm"/>";
        <%}%>
    }
    if (fstype=="sxfsfw" && document.forms[0].domainType_W.value=="win_seleads"){          
        <%if (!dispCheckBox_W){%>
            mesg = "<nsgui:message key="nas_mapd/alert/adsChangeConfirm"/>";
        <%}%>
    }

    if(confirm(mesg)){
        if (fstype=="sxfsfw"){
            <%if (dispCheckBox_W){%>
                document.forms[0].operation.value="add";
            <%} else{%>
                document.forms[0].operation.value="change";
            <%}%>
            document.forms[0].domaintype.value=document.forms[0].domainType_W.value;
        }else{
            <%if (dispCheckBox_U){%>
                document.forms[0].operation.value="add";
            <%} else{%>
                document.forms[0].operation.value="change";
            <%}%>
            document.forms[0].domaintype.value=document.forms[0].domainType_U.value
        }
   
        setSubmitted();
        document.forms[0].action="<%=response.encodeURL("../../common/forward.jsp?")%>";
        document.forms[0].submit();
        return true;
    }else{return false;}
}

function UnSet(obj,fstype){
    if (obj.disabled){
        return false;
    }
    if(isSubmitted()){
        return false;
    }
    document.forms[0].fsType.value = fstype;
    <%if (isBusy){%>
    if (!confirm("<nsgui:message key="nas_cifs/alert/delete_check_withclients"/>")){
        return false;
    }
    <%}%>
    var mesg = "";  
    <%if (hasSPConf && !hasSSConf){%>
        if (fstype=="sxfsfw"){
            mesg = "<nsgui:message key="nas_mapd/alert/sp_exist_confirm"/>" + "\r\n";
        }
    <%}else if (!hasSPConf && hasSSConf){%>
        if (fstype=="sxfsfw"){
            mesg = "<nsgui:message key="nas_mapd/alert/ss_exist_confirm"/>" + "\r\n";
        }
    <%}else if (hasSPConf && hasSSConf){%>
        if (fstype=="sxfsfw"){
            mesg = "<nsgui:message key="nas_mapd/alert/sp_ss_exist_confirm"/>" + "\r\n";
        }
    <%}else{}%>
    
    mesg = mesg + "<nsgui:message key="common/confirm" />" + "\r\n"    
            + "<nsgui:message key="common/confirm/act" />"
            + "<nsgui:message key="common/button/delete"/>";
    
    <%if (haveSxfsAntiVirusShare) {%>
        if (fstype=="sxfs") {
            mesg = "<nsgui:message key="nas_mapd/alert/have_sxfs_antivirus_confirm"/>" + "\r\n";
        }
    <%}%>

    if(confirm(mesg)){
        setSubmitted();
        if (fstype=="sxfsfw"){
            document.forms[0].domaintype.value=document.forms[0].domainType_W.value;
        }else{
            document.forms[0].domaintype.value=document.forms[0].domainType_U.value
        }
        document.forms[0].operation.value="del";
        document.forms[0].action="<%=response.encodeURL("../../common/forward.jsp?")%>";
        document.forms[0].submit();
        return true;
    }else{
        return false;
    }
}

function ChangeName(){
    if(isSubmitted()){
        return false;
    }
    document.forms[0].fsType.value = "sxfsfw";
    <%if (hasSPConf){%>
        var mesg = "<nsgui:message key="nas_mapd/alert/sp_exist_for_changename"/>";
        alert(mesg);
        return false;
    <%}%>
    <%if (isBusy){%>
    if (!confirm("<nsgui:message key="nas_cifs/alert/changeNetbios_check_withclients"/>")){
        return false;
    }
    <%}%>
    setSubmitted();
    window.location="<%=response.encodeURL("../cifs/changeNetbios.jsp")%>?exportrootname=<%=export%>&domainname="
                    +document.forms[0].win_domainname.value+"&selenetbios="+document.forms[0].win_computername.value;
    return ;
}

function checkName(str){
    if (str == ""){
        return false;
    }
    if (str.length>15){
        return false;
    }
    var avail=/[^A-Za-z0-9\-]/g;
    ifFind = str.search(avail);
    return (ifFind==-1);
}

function checkHead(str){
    if (str.charAt(0) == "-"){
        return false;
    }else {
        return true;
    }
}

function checkCA(fstype){
    var ca = "";
    var isAnonymous = "true";
    if (fstype=="sxfs" && !document.forms[0].unix_ldapTls[0].checked){
        ca = document.forms[0].unix_ldapCaFileText.value;
        isAnonymous = "false";
    }else if(fstype=="sxfsfw" && !document.forms[0].win_ldapTls[0].checked){
        ca = document.forms[0].win_ldapCaFileText.value;
        isAnonymous = "false";
    }
    if (isAnonymous=="false"){
        if(ca == "<nsgui:message key="nas_common/common/msg_select"/>"){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/needSelectCertificateFile"/>");
            return false;
        }else if(ca.length > 4095){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                    "<nsgui:message key="nas_mapd/alert/CAInvalid"/>");
            return false;
        }else{
            return true;
        }
    }
    return true;
}

function onBack(){
    <%if (fromWhere.equals("export")){%>
    selectModule("base.exportGroup.setup");
    <%} else if(fromWhere.equals("cifs")){%>
    selectModule("apply.fileShare.cifs");
    <%} else{%>
    selectModule("apply.userMapping.userDataBase");
    <%}%>
}
function displayWarnning(){
    <% if("cifs".equals(fromWhere)&&request.getParameter("firstTime")!=null){%>
        alert('<nsgui:message key="nas_mapd/alert/cifs_join_domain_alert"/>');
    <%}%>
}

</script>

</head>

<body onload="onInit();changeLdapCAstatus();displayAlert();displayWarnning();setHelpAnchor('export_domain')" 
      onunload="if(popWinFile!=null&&!popWinFile.closed){popWinFile.close()}">
<form name="basicForm" method="post">
<input type="hidden" name="domainType_U" value="unix_selenis">
<input type="hidden" name="domainType_W" value="win_seleads">
<!--hidden var used by bean-->
<input type="hidden" name="domaintype" value="">
<input type="hidden" name="win_domainname" value="">
<input type="hidden" name="win_computername" value="">
<input type="hidden" name="fromWhere" value="<%=fromWhere%>">
<input type="hidden" name="dispMode" value="<%=dispMode%>">
<input type="hidden" name="fsType" value="">
<input type="hidden" name="un2dn" value="n">
<input type="hidden" name="isJoin" value="">
<!--end-->
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="operation" value="">
<input type="hidden" name="beanClass" value="<%=infoBean.getClass().getName()%>">


<H1 class="title"><nsgui:message key="nas_mapd/common/h1_setup"/></H1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<%if(dispCheckBox_U && dispCheckBox_W){%>
<H2 class="title"><nsgui:message key="nas_mapd/common/h2_add"/></H2>
<%} else{%>
<H2 class="title"><nsgui:message key="nas_mapd/common/h2_change"/></H2>
<%}%>

<table border="0"><tr><td><nsgui:message key="nas_mapd/common/th_recommen"/></tr></td></table>
<H3 class="title"><nsgui:message key="nas_mapd/common/h3_unix"/></H3>
<%if (domain4Unix == null){%>
	<nsgui:message key="nas_mapd/unix/msg_info_fail"/>
<%}else{%>
<%if (dispCheckBox_U){%>
<input type="checkbox" name="unix" ID="check_u" onClick="changeDisp()">
<label for="check_u"><nsgui:message key="nas_mapd/unix/set_ud"/></label>
<br>
<div id="unix_domain" style="display:none;">
<div id="unix_nis">
	<table border="1">
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
		<td><select name="unix_selenis">
				<option value="unix_nis" selected><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
				<option value="unix_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
				<option value="unix_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
			</select>
			<input type="button" name="unix_select" value="<nsgui:message key="common/button/select"/>" onclick="showtab_unix(document.forms[0].unix_selenis.value);unix_selenis.options[0].selected = 1;">
		</td>
		</tr>

		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th><td><input name="unix_nisdomain" type="text" value="" size="48" maxLength="64"></td></tr>
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th><td><input name="unix_nisserver" type="text" value="" size="48"></td></tr>
	</table>
</div>

<div id="unix_pwd" style="display:none;">
	<table border="1">
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
		    <td><select name="unix_selepwd">
				<option value="unix_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
				<option value="unix_pwd" selected><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
				<option value="unix_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
				</select>
			<input type="button" name="unix_select" value="<nsgui:message key="common/button/select"/>" onclick="showtab_unix(document.forms[0].unix_selepwd.value);unix_selepwd.options[1].selected = 1">
			</td>
	    </tr>
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
		<td><select name="unix_ludbname">
		    <%for (int i=0; i<ludbLength;i++){%>
			<option value="<%=ludbList[i]%>" <%if(i==0) out.print(" selected");%>><%=ludbList[i]%></option>
			<%}%>
			</select>
		</td></tr>
	</table>
</div>
<div id="unix_ldap" style="display:none;">
	<table border="1">
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
    		<td><select name="unix_seleldap">
    			<option value="unix_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
    			<option value="unix_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
    			<option value="unix_ldap" selected ><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
    			</select>
    		<input type="button" name="unix_select" value="<nsgui:message key="common/button/select"/>" onclick="showtab_unix(document.forms[0].unix_seleldap.value);unix_seleldap.options[2].selected = 1">
    		</td>
		</tr>
		<tr><th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>
            <td><input type="text" name="unix_ldapServer" onfocus="if (this.disabled) this.blur();" value="<%=domain4Unix.getLdapserver()%>" size="48" maxLength="256" ></td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
            <td><input type="text" name="unix_ldapId" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Unix.getBasedn())%>" size="48" maxLength="1024" ></td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
        	<td><select name="unix_ldapMode" onChange="ldapChange();">
	            <option value="Anonymous" <%=ldapMode_A%>><nsgui:message key="nas_mapd/nt/Anonymous"/></option>
	            <option value="SIMPLE" <%=ldapMode_S%>><nsgui:message key="nas_mapd/nt/SIMPLE"/></option>
	            <option value="DIGEST-MD5" <%=ldapMode_D%>><nsgui:message key="nas_mapd/nt/DIGEST-MD5"/></option>
	            <option value="CRAM-MD5" <%=ldapMode_C%>><nsgui:message key="nas_mapd/nt/CRAM-MD5"/></option>
	            </select>
	         </td>
	    </tr>
	    <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuth"/></th>
             <td><table border="0" nowrap>
                    <tr><td><label for="unix_ldapAuthName"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></label></td>
                        <td><input type="text" name="unix_ldapAuthName" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Unix.getAuthname())%>" size="32" maxLength="1024" ID="unix_ldapAuthName"></td>
                    </tr>
                    <tr>
                        <td><label for="_unix_ldapAuthPassword"><nsgui:message key="nas_mapd/nt/ldapAuthPasswd"/></label></td>
                        <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_unix_ldapAuthPassword" value="<%=HTMLUtil.sanitize(domain4Unix.getAuthpwd())%>" size="32" maxLength="1024" ID="_unix_ldapAuthPassword"></td>
                    </tr>
                    <tr>
                        <td><label for="_unix_ldapAuthPasswordRe"><nsgui:message key="nas_mapd/nt/ldapAuthPasswdRe"/></label></td>
                        <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_unix_ldapAuthPasswordRe" value="<%=HTMLUtil.sanitize(domain4Unix.getAuthpwd())%>" size="32" maxLength="1024" ID="_unix_ldapAuthPasswordRe"></td>
                    </tr>
                 </table>
             </td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
            <td>
                <input type="radio" name="unix_ldapTls" ID="ldapTls_no_u" value="no" <%=tls_no%> onclick="changeLdapCAstatus()">
                <label for="ldapTls_no_u"><nsgui:message key="nas_mapd/nt/td_no_useTLS"/></label>
                <br>
                <input type="radio" name="unix_ldapTls" ID="ldapTls_start_tls_u" value="start_tls" <%=tls_start%> onclick="changeLdapCAstatus()">
                <label for="ldapTls_start_tls_u"><nsgui:message key="nas_mapd/nt/td_useStartTLS"/></label>
                <br>
                <input type="radio" name="unix_ldapTls" ID="ldapTls_yes_u" <%=tls_yes%> value="yes" onclick="changeLdapCAstatus()">
                <label for="ldapTls_yes_u"><nsgui:message key="nas_mapd/nt/td_useSSL_TLS"/></label>
            </td>
        </tr>         
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
        	<td><input type="text" name="unix_ldapCaFileText" onfocus="this.blur();" value="<%=domain4Unix.getCa().equals("")?
                                    NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select"):HTMLUtil.sanitize(domain4Unix.getCa())%>" readonly size="32" maxLength="4095">
                <input type="button" name="unix_ldapCaFileButton" value="<nsgui:message key="common/button/browse2"/>" onclick="if (!this.disabled){navigate('sxfs');}">
            </td>
		</tr>
		<tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
		    <td><input type="text" name="unix_user_filter" value="<%=domain4Unix.getUfilter()%>" size="48" maxLength="1023"></td>
		</tr>
		<tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
		    <td><input type="text" name="unix_group_filter" value="<%=domain4Unix.getGfilter()%>" size="48" maxLength="1023"></td>
        </tr>
        <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/th_userauth"/></th>
          <td><input type="checkbox" name="unix_un2dn" value="true" ID="un2dn_u" <%if(infoBean.getIfCheck(domain4Unix.getUn2dn())){%>checked="true"<%}%> disabled>
          <label for="un2dn_u"><nsgui:message key="nas_mapd/nt/td_un2dn"/></label></td>
        </tr>
	</table>
</div>
<br>
<div id="unix_button">
<input type = "button"  name = "add_unixdomain" value= "<nsgui:message key="nas_mapd/unix/button_set_udb"/>" onClick="Set(this, 'sxfs')">
<input type = "button"  name = "del_unixdomain" value= "<nsgui:message key="nas_mapd/unix/button_del_udb"/>" onClick="UnSet(this, 'sxfs')" disabled=true>
</div>
</div>
<%}else {%>
   <table border="1">
	<%if(domain4Unix.getDomainType().equals("nis")){%>
	    <script>
	        document.forms[0].domainType_U.value="unix_selenis";
	    </script>
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/unix/radio_nis"/></td></tr>
		<input type="hidden" name="unix_nisdomain" value="<%=domain4Unix.getNisdomain()%>">
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th><td><%=domain4Unix.getNisdomain()%></td></tr>
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th><td><input name="unix_nisserver" type="text" value="<%=domain4Unix.getNisserver()%>" size="48"></td></tr>
   <%}else if(domain4Unix.getDomainType().equals("pwd")){%>
        <script>
	        document.forms[0].domainType_U.value="unix_selepwd";
	    </script>
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/unix/radio_pwd"/></td></tr>
		<input type="hidden" name="unix_ludbname" value="<%=domain4Unix.getLudb()%>">
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th><td><%=domain4Unix.getLudb()%></td></tr>
   <%}else{%>
        <script>
	        document.forms[0].domainType_U.value="unix_seleldap";
	    </script>
		<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/nt/h3_ldap"/></option></td></tr>
		<tr><th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>
            <td><input type="text" name="unix_ldapServer" onfocus="if (this.disabled) this.blur();" value="<%=domain4Unix.getLdapserver()%>" size="48" maxLength="256" ></td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
            <td><input type="text" name="unix_ldapId" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Unix.getBasedn())%>" size="48" maxLength="1024" ></td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
        	<td><select name="unix_ldapMode" onChange="ldapChange();">
	            <option value="Anonymous" <%=ldapMode_A%>><nsgui:message key="nas_mapd/nt/Anonymous"/></option>
	            <option value="SIMPLE" <%=ldapMode_S%>><nsgui:message key="nas_mapd/nt/SIMPLE"/></option>
	            <option value="DIGEST-MD5" <%=ldapMode_D%>><nsgui:message key="nas_mapd/nt/DIGEST-MD5"/></option>
	            <option value="CRAM-MD5" <%=ldapMode_C%>><nsgui:message key="nas_mapd/nt/CRAM-MD5"/></option>
	            </select>
	         </td>
	    </tr>
         <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuth"/></th>
             <td><table border="0" nowrap>
                    <tr><td><label for="unix_ldapAuthName"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></label></td>
                        <td><input type="text" name="unix_ldapAuthName" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Unix.getAuthname())%>" size="32" maxLength="1024" ID="unix_ldapAuthName"></td>
                    </tr>
                    <tr>
                        <td><label for="_unix_ldapAuthPassword"><nsgui:message key="nas_mapd/nt/ldapAuthPasswd"/></label></td>
                        <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_unix_ldapAuthPassword" value="<%=HTMLUtil.sanitize(domain4Unix.getAuthpwd())%>" size="32" maxLength="1024" ID="_unix_ldapAuthPassword"></td>
                    </tr>
                    <tr>
                        <td><label for="_unix_ldapAuthPasswordRe"><nsgui:message key="nas_mapd/nt/ldapAuthPasswdRe"/></label></td>
                        <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_unix_ldapAuthPasswordRe" value="<%=HTMLUtil.sanitize(domain4Unix.getAuthpwd())%>" size="32" maxLength="1024" ID="_unix_ldapAuthPasswordRe"></td>
                    </tr>
                 </table>
             </td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
            <td>
                <input type="radio" name="unix_ldapTls" <%=tls_no%> ID="ldapTls_no_u" value="no"  onclick="changeLdapCAstatus()">
                <label for="ldapTls_no_u"><nsgui:message key="nas_mapd/nt/td_no_useTLS"/></label>
                <br>
                <input type="radio" name="unix_ldapTls" <%=tls_start%> ID="ldapTls_start_tls_u" value="start_tls"  onclick="changeLdapCAstatus()">
                <label for="ldapTls_start_tls_u"><nsgui:message key="nas_mapd/nt/td_useStartTLS"/></label>
                <br>
                <input type="radio" name="unix_ldapTls" <%=tls_yes%> ID="ldapTls_yes_u" value="yes"  onclick="changeLdapCAstatus()">
                <label for="ldapTls_yes_u"><nsgui:message key="nas_mapd/nt/td_useSSL_TLS"/></label>
            </td>
         </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
        	<td><input type="text" name="unix_ldapCaFileText" onfocus="this.blur();" value="<%=domain4Unix.getCa().equals("")?
                                    NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select"):HTMLUtil.sanitize(domain4Unix.getCa())%>" readonly size="32" maxLength="4095">
                <input type="button" name="unix_ldapCaFileButton" value="<nsgui:message key="common/button/browse2"/>" onclick="if (!this.disabled){navigate('sxfs');}">
            </td>
		</tr>
		<tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
		    <td><input type="text" name="unix_user_filter" value="<%=domain4Unix.getUfilter()%>" size="48" maxLength="1023"></td>
		</tr>
		<tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
		    <td><input type="text" name="unix_group_filter" value="<%=domain4Unix.getGfilter()%>" size="48" maxLength="1023"></td>
        </tr>
        <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/th_userauth"/></th>
          <td><input type="checkbox" name="unix_un2dn" value="true" ID="un2dn_u" <%if(infoBean.getIfCheck(domain4Unix.getUn2dn())){%>checked="true"<%}%> disabled>
            <label for="un2dn_u"><nsgui:message key="nas_mapd/nt/td_un2dn"/></label></td>
        </tr>
    <%}%>
	</table>
	<br>
	<%if(domain4Unix.getDomainType().equals("pwd")){%>
	<input type = "button"  name = "add_unixdomain" value= "<nsgui:message key="nas_mapd/unix/button_set_udb"/>" disabled>
	<%}else{%>
    <input type = "button"  name = "add_unixdomain" value= "<nsgui:message key="nas_mapd/unix/button_set_udb"/>" onClick="Set(this,'sxfs')">
    <%}%>
    <input type = "button"  name = "del_unixdomain" value= "<nsgui:message key="nas_mapd/unix/button_del_udb"/>" onClick="UnSet(this,'sxfs')">
<%}%>
<%}%>

<H3 class="title"><nsgui:message key="nas_mapd/common/h3_win"/></H3>
<%if (domain4Win == null){%>
	<nsgui:message key="nas_mapd/nt/msg_info_fail"/>
<%}else{%>
<%if (dispCheckBox_W){%>
<input type="checkbox" name="windows" ID="check_w" onClick="changeDisp()">
<label for="check_w"><nsgui:message key="nas_mapd/nt/set_wd"/></label>
<br>
<%if (dh.equals("yes")){%>
<br>
	<table border="0">
	    <tr>
		    <td class="ErrorInfo"><img border=0 src="/nsadmin/images/icon/png/icon_alert.png"></td>
		    <td class="ErrorInfo"><nsgui:message key="nas_mapd/nt/msg_info_directhosting"/></td>
	    </tr>
	</table>
<%}%>
<div id="windows_domain" style="display:none;">
<div id="win_ads">
<table border="1">
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
		<td><select name="win_seleads">
			<option value="win_ads" selected><nsgui:message key="nas_mapd/nt/h3_ads"/></option>
			<option value="win_shr"><nsgui:message key="nas_mapd/nt/h3_shr"/></option>
			<option value="win_dmc"><nsgui:message key="nas_mapd/nt/h3_auth"/></option>
			<option value="win_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
			<option value="win_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
			<option value="win_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
			</select>
			<input type="button" name="win_select_ads" value="<nsgui:message key="common/button/select"/>" onclick="showtab_win(document.forms[0].win_seleads.value);win_seleads.options[0].selected = 1">
		</td>
	</tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
        <td><input name="win_domainname_ads" type="text" value="" maxlength="15" onblur="toUpperDomain(this)">
            <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment_ads"/></font>]
        </td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><input name="win_computername_ads" type="text" value="" maxlength="15" onblur="toUpperComputer(this)"></td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_dnsdomain"/></th>
	    <td><input name="win_dns" type="text" size="48" value="" maxlength="255">
	    <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/ads_dns_info"/></font>]
	    </td>
	</tr>
	<tr>
	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/dc"/></th>
	    <td>
	        <table>
	            <tr>
	                <td><input type="radio" name="win_dcsw" value="auto" id="win_dcsw_auto" onClick="changedclist()" checked ></td>
	                <td><label for="win_dcsw_auto"><nsgui:message key="nas_mapd/nt/dcfromdns"/></label></td>
	            </tr>
	            <tr>
	                <td><input type="radio" name="win_dcsw" value="static" id="win_dcsw_static" onClick="changedclist()"></td>
	                <td><label for="win_dcsw_static"><nsgui:message key="nas_mapd/nt/dcspecify"/>&nbsp;<font size=-1><nsgui:message key="nas_mapd/nt/dccomment"/></font></label>                    
	                </td>
	            </tr>
	            <tr>
	                <td>&nbsp;</td>
	                <td><input name="win_dclist" type="text" size="64" value="" disabled="yes" onblur="changeKdcVale()"><br>
	                    [<font class="advice"><nsgui:message key="nas_mapd/nt/inputcomment"/></font>]
	                </td>    
	            </tr>
	            <tr>
	                <td><input type="checkbox" name="joindomain" value="on" id="joindomain" onClick="changeJoin()" checked ></td>
	                <td><label for="joindomain"><nsgui:message key="nas_mapd/nt/joindomain"/></label></td>
	            </tr>	            
	        </table>
	        <table>
	            <tr>
	                <td><nsgui:message key="nas_mapd/nt/text_ads_user"/></td>
	                <td><input name="win_ads_user" type="text" size="48" maxlength="20" value="Administrator"></td>
	            </tr>
	            <tr>
	                <td><nsgui:message key="nas_mapd/nt/text_ads_pass"/></td>
	                <td><input name="_win_ads_passwd" type="password" size="48" maxlength="127" value=""></td>
	            </tr>
	        </table>
	    </td>
    </tr>
    <tr>
        <th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_kdcserver"/></th>
        <td><input name="win_kdc" type="text" size="64" value=""><nsgui:message key="nas_mapd/nt/optional"/><br>
            [<font class="advice"><nsgui:message key="nas_mapd/nt/inputcomment"/></font>]
        </td>
    </tr>
</table>
</div>

<div id="win_dmc" style="display:none;">
<table border="1">
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
	    <td><select name="win_seledmc">
			<option value="win_ads"><nsgui:message key="nas_mapd/nt/h3_ads"/></option>
			<option value="win_shr"><nsgui:message key="nas_mapd/nt/h3_shr"/></option>
			<option value="win_dmc" selected><nsgui:message key="nas_mapd/nt/h3_auth"/></option>
			<option value="win_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
			<option value="win_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
			<option value="win_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
			</select>
			<input type="button" name="win_select_dmc" value="<nsgui:message key="common/button/select"/>" onclick="showtab_win(document.forms[0].win_seledmc.value);win_seledmc.options[2].selected = 1">
		</td>
	</tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
        <td><input name="win_domainname_dmc" type="text" value="" maxlength="15" onblur="toUpperDomain(this)">
            <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment"/></font>]
        </td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><input name="win_computername_dmc" type="text" value="" maxlength="15" onblur="toUpperComputer(this)"></td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_ads_user"/></th><td><input name="win_dmc_user" type="text" size="20" value="Administrator" maxlength="20"></td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_ads_pass"/></th><td><input name="_win_dmc_passwd" type="password" maxlength="127" value=""></td></tr>
</table>
</div>

<div id="win_shr" style="display:none;">
<table border="1">
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
	    <td><select name="win_seleshr">
			<option value="win_ads"><nsgui:message key="nas_mapd/nt/h3_ads"/></option>
			<option value="win_shr" selected><nsgui:message key="nas_mapd/nt/h3_shr"/></option>
			<option value="win_dmc"><nsgui:message key="nas_mapd/nt/h3_auth"/></option>
			<option value="win_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
			<option value="win_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
			<option value="win_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
			</select>
			<input type="button" name="win_select_shr" value="<nsgui:message key="common/button/select"/>" onclick="showtab_win(document.forms[0].win_seleshr.value);win_seleshr.options[1].selected = 1">
		</td>
	</tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
        <td><input name="win_domainname_shr" type="text" value="" maxlength="15" onblur="toUpperDomain(this)">
            <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment"/></font>]
        </td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><input name="win_computername_shr" type="text" value="" maxlength="15" onblur="toUpperComputer(this)"></td></tr>
</table>

</div>
<div id="win_nis" style="display:none;">
<table border="1">
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
	<td><select name="win_selenis">
		<option value="win_ads"><nsgui:message key="nas_mapd/nt/h3_ads"/></option>
		<option value="win_shr"><nsgui:message key="nas_mapd/nt/h3_shr"/></option>
		<option value="win_dmc"><nsgui:message key="nas_mapd/nt/h3_auth"/></option>
		<option value="win_nis" selected><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
		<option value="win_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
		<option value="win_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
		</select>
		<input type="button" name="win_select_nis" value="<nsgui:message key="common/button/select"/>" onclick="showtab_win(document.forms[0].win_selenis.value);win_selenis.options[3].selected = 1">
	    </td>
	</tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
        <td><input name="win_domainname_nis" type="text" value="" maxlength="15" onblur="toUpperDomain(this)">
            <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment"/></font>]
        </td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><input name="win_computername_nis" type="text" value="" maxlength="15" onblur="toUpperComputer(this)"></td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th><td><input name="win_nisdomain" type="text" value="" size="48" maxLength="64"></td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th><td><input name="win_nisserver" type="text" value="" size="48" ></td></tr>
</table>
</div>

<div id="win_pwd" style="display:none;">
<table border="1">
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
	    <td><select name="win_selepwd">
			<option value="win_ads"><nsgui:message key="nas_mapd/nt/h3_ads"/></option>
			<option value="win_shr"><nsgui:message key="nas_mapd/nt/h3_shr"/></option>
			<option value="win_dmc"><nsgui:message key="nas_mapd/nt/h3_auth"/></option>
			<option value="win_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
			<option value="win_pwd" selected><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
			<option value="win_ldap"><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
			</select>
			<input type="button" name="win_select_dmc" value="<nsgui:message key="common/button/select"/>" onclick="showtab_win(document.forms[0].win_selepwd.value);win_selepwd.options[4].selected = 1">
		</td>
	</tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
        <td><input name="win_domainname_pwd" type="text" value="" maxlength="15" onblur="toUpperDomain(this)">
            <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment"/></font>]
        </td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><input name="win_computername_pwd" type="text" value="" maxlength="15" onblur="toUpperComputer(this)"></td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
		<td><select name="win_ludbname">
		    <%for (int i=0; i<ludbLength; i++){%>
			<option value="<%=ludbList[i]%>" <%if(i==0) out.print(" selected");%>><%=ludbList[i]%></option>
			<%}%>
			</select>
		</td>
	</tr>
</table>
</div>

<div id="win_ldap" style="display:none;">

<table border="1">
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
	    <td><select name="win_seleldap">
		<option value="win_ads"><nsgui:message key="nas_mapd/nt/h3_ads"/></option>
		<option value="win_shr"><nsgui:message key="nas_mapd/nt/h3_shr"/></option>
		<option value="win_dmc"><nsgui:message key="nas_mapd/nt/h3_auth"/></option>
		<option value="win_nis"><nsgui:message key="nas_mapd/unix/radio_nis"/></option>
		<option value="win_pwd"><nsgui:message key="nas_mapd/unix/radio_pwd"/></option>
		<option value="win_ldap" selected><nsgui:message key="nas_mapd/nt/h3_ldap"/></option>
		</select>
		<input type="button" name="win_select_ldap" value="<nsgui:message key="common/button/select"/>" onclick="showtab_win(document.forms[0].win_seleldap.value);win_seleldap.options[5].selected = 1">
	    </td>
	</tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
        <td><input name="win_domainname_ldap" type="text" value="" maxlength="15" onblur="toUpperDomain(this)">
            <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment"/></font>]
        </td></tr>
	<tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><input name="win_computername_ldap" type="text" value="" maxlength="15" onblur="toUpperComputer(this)"></td></tr>
	<tr><th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>
        <td><input type="text" name="win_ldapServer" onfocus="if (this.disabled) this.blur();" value="<%=domain4Win.getLdapserver()%>" size="48" maxLength="256" ></td>
    </tr>
    <tr><th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
        <td><input type="text" name="win_ldapId" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Win.getBasedn())%>" size="48" maxLength="1024" ></td>
    </tr>
    <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
        <td><select name="win_ldapMode" onChange="ldapChange();">
	        <option value="Anonymous" <%=ldapMode_A%>><nsgui:message key="nas_mapd/nt/Anonymous"/></option>
	        <option value="SIMPLE" <%=ldapMode_S%>><nsgui:message key="nas_mapd/nt/SIMPLE"/></option>
	        <option value="DIGEST-MD5" <%=ldapMode_D%>><nsgui:message key="nas_mapd/nt/DIGEST-MD5"/></option>
	        <option value="CRAM-MD5" <%=ldapMode_C%>><nsgui:message key="nas_mapd/nt/CRAM-MD5"/></option>
	        </select>
	    </td>
	</tr>
    <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuth"/></th>
        <td><table border="0" nowrap>
              <tr><td><label for="win_ldapAuthName"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></label></td>
                  <td><input type="text" name="win_ldapAuthName" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Win.getAuthname())%>" size="32" maxLength="1024" ID="win_ldapAuthName"></td>
              </tr>
              <tr>
                  <td><label for="_win_ldapAuthPassword"><nsgui:message key="nas_mapd/nt/ldapAuthPasswd"/></label></td>
                  <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_win_ldapAuthPassword" value="<%=HTMLUtil.sanitize(domain4Win.getAuthpwd())%>" size="32" maxLength="1024" ID="_win_ldapAuthPassword"></td>
              </tr>
              <tr>
                  <td><label for="_win_ldapAuthPasswordRe"><nsgui:message key="nas_mapd/nt/ldapAuthPasswdRe"/></label></td>
                  <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_win_ldapAuthPasswordRe" value="<%=HTMLUtil.sanitize(domain4Win.getAuthpwd())%>" size="32" maxLength="1024" ID="_win_ldapAuthPasswordRe"></td>
               </tr>
             </table>
        </td>
    </tr>
    <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
        <td>
            <input type="radio" name="win_ldapTls" ID="ldapTls_no_w" value="no" <%=tls_no%> onclick="changeLdapCAstatus()">
            <label for="ldapTls_no_w"><nsgui:message key="nas_mapd/nt/td_no_useTLS"/></label>
            <br>
            <input type="radio" name="win_ldapTls" ID="ldapTls_start_tls_w" value="start_tls" <%=tls_start%> onclick="changeLdapCAstatus()">
            <label for="ldapTls_start_tls_w"><nsgui:message key="nas_mapd/nt/td_useStartTLS"/></label>
            <br>
            <input type="radio" name="win_ldapTls" ID="ldapTls_yes_w" value="yes" <%=tls_yes%> onclick="changeLdapCAstatus()">
            <label for="ldapTls_yes_w"><nsgui:message key="nas_mapd/nt/td_useSSL_TLS"/></label>
        </td>
    </tr>
    <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
        <td><input type="text" name="win_ldapCaFileText" onfocus="this.blur();" value="<%=domain4Win.getCa().equals("")?
                                    NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select"):HTMLUtil.sanitize(domain4Win.getCa())%>" readonly size="32" maxLength="4095">
            <input type="button" name="win_ldapCaFileButton" value="<nsgui:message key="common/button/browse2"/>" onclick="if (!this.disabled){navigate('sxfsfw');}">
        </td>
	</tr>
	<tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
		 <td><input type="text" name="win_user_filter" value="<%=domain4Win.getUfilter()%>" size="48" maxLength="1023"></td>
	</tr>
	<tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
		 <td><input type="text" name="win_group_filter" value="<%=domain4Win.getGfilter()%>" size="48" maxLength="1023"></td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="nas_mapd/nt/th_userauth"/></th>
      <td><input type="checkbox" name="win_un2dn" value="true" ID="un2dn_w" <%if(infoBean.getIfCheck(domain4Win.getUn2dn())){%>checked="true"<%}%>>
          <label for="un2dn_w"><nsgui:message key="nas_mapd/nt/td_un2dn"/></label></td>
    </tr>
</table>
</div>

<br>
<div id="windows_button">
<input type = "button"  name = "add_windomain" value= "<nsgui:message key="nas_mapd/nt/button_set_wdb"/>" onClick="Set(this,'sxfsfw')">
<input type = "button"  name = "del_windomain" value= "<nsgui:message key="nas_mapd/nt/button_del_wdb"/>" onClick="UnSet(this,'sxfsfw')" disabled>
<%if (fromWhere.equals("export")){%>
<input type = "button"  name = "change_name" value= "<nsgui:message key="nas_mapd/nt/button_chg_netbios"/>" onClick="ChangeName()" disabled>
<%}%>
</div>
</div>
<%} else{%>
<script>
    document.forms[0].win_domainname.value="<%=domain4Win.getNtdomain()%>";
    document.forms[0].win_computername.value="<%=domain4Win.getNetbios()%>";
</script>
  <table border="1">
  <%if (domain4Win.getDomainType().equals("ads")){%>
      <script>
	        document.forms[0].domainType_W.value="win_seleads";
	  </script>
  	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/nt/h3_ads"/></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th><td><%=domain4Win.getNtdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><%=domain4Win.getNetbios()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_dnsdomain"/></th>
	      <td><input name="win_dns" type="text" size="48" maxlength="255" value="<%=domain4Win.getDns()%>">
	      <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/ads_dns_info"/></font>]
	      </td>
	  </tr>	  
	  <tr>
	    <% 
	       String check_auto = "";
	       String check_static = "";
	       if (dc.equals("")){
	            check_auto = "checked";
	       }else{
	            check_static = "checked";
	       }%>
	    <th nowrap align="left"><nsgui:message key="nas_mapd/nt/dc"/></th>
	    
	      <td>
	        <table>
	            <tr>
	                <td><input type="radio" name="win_dcsw" value="auto" id="win_dcsw_auto" onClick="changedclist()" <%=check_auto%> ></td>
	                <td><label for="win_dcsw_auto"><nsgui:message key="nas_mapd/nt/dcfromdns"/></label></td>
	            </tr>
	            <tr>
	                <td><input type="radio" name="win_dcsw" value="static" id="win_dcsw_static" onClick="changedclist()" <%=check_static%> ></td>
	                <td><label for="win_dcsw_static"><nsgui:message key="nas_mapd/nt/dcspecify"/>&nbsp;<font size=-1><nsgui:message key="nas_mapd/nt/dccomment"/></font></label>	                    
	                </td>
	            </tr>
	            <tr>
	                <td>&nbsp;</td>
	                <td><input name="win_dclist" type="text" size="64" value="<%=dc%>" onblur="changeKdcVale()"><br>
	                    [<font class="advice"><nsgui:message key="nas_mapd/nt/inputcomment"/></font>]
	                </td>    
	            </tr>
	            <tr>
	                <td><input type="checkbox" name="joindomain" value="on" id="joindomain" onClick="changeJoin()"></td>
	                <td><label for="joindomain"><nsgui:message key="nas_mapd/nt/joindomain"/></label></td>
	            </tr>	            
	        </table>
	        <table>
	            <tr>
	                <td><nsgui:message key="nas_mapd/nt/text_ads_user"/></td>
	                <td><input name="win_ads_user" type="text" size="48" maxlength="20" value="Administrator"></td>
	            </tr>
	            <tr>
	                <td><nsgui:message key="nas_mapd/nt/text_ads_pass"/></td>
	                <td><input name="_win_ads_passwd" type="password" size="48" maxlength="127" value=""></td>
	            </tr>
	        </table>
	      </td>
      </tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_kdcserver"/></th>
	      <td><input name="win_kdc" type="text" size="64" value="<%=domain4Win.getKdcserver()%>"><nsgui:message key="nas_mapd/nt/optional"/><br>
	          [<font class="advice"><nsgui:message key="nas_mapd/nt/inputcomment"/></font>]
	      </td>
	  </tr>
	  
  <%} else if (domain4Win.getDomainType().equals("dmc")){%>
      <script>
	        document.forms[0].domainType_W.value="win_seledmc";
	  </script>
  	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/nt/h3_auth"/></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th><td><%=domain4Win.getNtdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><%=domain4Win.getNetbios()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_ads_user"/></th><td><input name="win_dmc_user" type="text" size="20" value="Administrator" maxlength="20"></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_ads_pass"/></th><td><input name="_win_dmc_passwd" type="password" maxlength="127" value=""></td></tr>
  <%} else if (domain4Win.getDomainType().equals("shr")){%>
      <script>
	        document.forms[0].domainType_W.value="win_seleshr";
	  </script>
  	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/nt/h3_shr"/></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th><td><%=domain4Win.getNtdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><%=domain4Win.getNetbios()%></td></tr>
  <%} else if (domain4Win.getDomainType().equals("nis")){%>
      <script>
	        document.forms[0].domainType_W.value="win_selenis";
	  </script>
	  <input type="hidden" name="win_nisdomain" value="<%=domain4Win.getNisdomain()%>">
  	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/unix/radio_nis"/></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th><td><%=domain4Win.getNtdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><%=domain4Win.getNetbios()%></td></tr>
      <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th><td><%=domain4Win.getNisdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th><td><input name="win_nisserver" type="text" value="<%=domain4Win.getNisserver()%>" size="48"></td></tr>
  <%} else if (domain4Win.getDomainType().equals("pwd")){%>
      <script>
	        document.forms[0].domainType_W.value="win_selepwd";
	  </script>
	  <input type="hidden" name="win_ludbname" value="<%=domain4Win.getLudb()%>">
  	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/unix/radio_pwd"/></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th><td><%=domain4Win.getNtdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><%=domain4Win.getNetbios()%></td></tr>
      <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th><td><%=domain4Win.getLudb()%></td></tr>
  <%} else{%>
      <script>
	        document.forms[0].domainType_W.value="win_seleldap";
	  </script>
  	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th><td><nsgui:message key="nas_mapd/nt/h3_ldap"/></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th><td><%=domain4Win.getNtdomain()%></td></tr>
	  <tr><th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th><td><%=domain4Win.getNetbios()%></td></tr>
      <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>
          <td><input type="text" name="win_ldapServer" onfocus="if (this.disabled) this.blur();" value="<%=domain4Win.getLdapserver()%>" size="48" maxLength="256" ></td>
      </tr>
      <tr><th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
          <td><input type="text" name="win_ldapId" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Win.getBasedn())%>" size="48" maxLength="1024" ></td>
      </tr>
      <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
          <td><select name="win_ldapMode" onChange="ldapChange();">
	        <option value="Anonymous" <%=ldapMode_A%>><nsgui:message key="nas_mapd/nt/Anonymous"/></option>
	        <option value="SIMPLE" <%=ldapMode_S%>><nsgui:message key="nas_mapd/nt/SIMPLE"/></option>
	        <option value="DIGEST-MD5" <%=ldapMode_D%>><nsgui:message key="nas_mapd/nt/DIGEST-MD5"/></option>
	        <option value="CRAM-MD5" <%=ldapMode_C%>><nsgui:message key="nas_mapd/nt/CRAM-MD5"/></option>
	        </select>
	      </td>
	  </tr>      
      <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuth"/></th>
          <td><table border="0" nowrap>
              <tr><td><label for="win_ldapAuthName"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></label></td>
                  <td><input type="text" name="win_ldapAuthName" onfocus="if (this.disabled) this.blur();" value="<%=HTMLUtil.sanitize(domain4Win.getAuthname())%>" size="32" maxLength="1024" ID="win_ldapAuthName"></td>
              </tr>
              <tr>
                  <td><label for="_win_ldapAuthPassword"><nsgui:message key="nas_mapd/nt/ldapAuthPasswd"/></label></td>
                  <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_win_ldapAuthPassword" value="<%=HTMLUtil.sanitize(domain4Win.getAuthpwd())%>" size="32" maxLength="1024" ID="_win_ldapAuthPassword"></td>
              </tr>
              <tr>
                  <td><label for="_win_ldapAuthPasswordRe"><nsgui:message key="nas_mapd/nt/ldapAuthPasswdRe"/></label></td>
                  <td><input type="password" onfocus="if (this.disabled) this.blur();" name="_win_ldapAuthPasswordRe" value="<%=HTMLUtil.sanitize(domain4Win.getAuthpwd())%>" size="32" maxLength="1024" ID="_win_ldapAuthPasswordRe"></td>
               </tr>
             </table>
          </td>
      </tr>
      <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
          <td>
            <input type="radio" name="win_ldapTls" ID="ldapTls_no_w" value="no" <%=tls_no%> onclick="changeLdapCAstatus()">
            <label for="ldapTls_no_w"><nsgui:message key="nas_mapd/nt/td_no_useTLS"/></label>
            <br>
            <input type="radio" name="win_ldapTls" ID="ldapTls_start_tls_w" value="start_tls" <%=tls_start%> onclick="changeLdapCAstatus()">
            <label for="ldapTls_start_tls_w"><nsgui:message key="nas_mapd/nt/td_useStartTLS"/></label>
            <br>
            <input type="radio" name="win_ldapTls" ID="ldapTls_yes_w" value="yes" <%=tls_yes%> onclick="changeLdapCAstatus()">
            <label for="ldapTls_yes_w"><nsgui:message key="nas_mapd/nt/td_useSSL_TLS"/></label>
          </td>
      </tr>
      <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
          <td><input type="text" name="win_ldapCaFileText" onfocus="this.blur();" value="<%=domain4Win.getCa().equals("")?
                                    NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select"):HTMLUtil.sanitize(domain4Win.getCa())%>" readonly size="32" maxLength="4095">
              <input type="button" name="win_ldapCaFileButton" value="<nsgui:message key="common/button/browse2"/>" onclick="if (!this.disabled){navigate('sxfsfw');}">
          </td>
	  </tr>
	  <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
		  <td><input type="text" name="win_user_filter" value="<%=domain4Win.getUfilter()%>" size="48" maxLength="1023"></td>
	  </tr>
	  <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
		  <td><input type="text" name="win_group_filter" value="<%=domain4Win.getGfilter()%>" size="48" maxLength="1023"></td>
      </tr>
      <tr>
        <th align="left"><nsgui:message key="nas_mapd/nt/th_userauth"/></th>
        <td><input type="checkbox" name="win_un2dn" value="true" ID="un2dn_w" <%if(infoBean.getIfCheck(domain4Win.getUn2dn())){%>checked="true"<%}%>>
            <label for="un2dn_w"><nsgui:message key="nas_mapd/nt/td_un2dn"/></label></td>
      </tr>
  <%}%>
  </table>
  <br>
  <%if (domain4Win.getDomainType().equals("shr") || domain4Win.getDomainType().equals("pwd")){%>
  <input type = "button" name = "add_windomain" value= "<nsgui:message key="nas_mapd/nt/button_set_wdb"/>" disabled>
  <%}else{%>
  <input type = "button" name = "add_windomain" value= "<nsgui:message key="nas_mapd/nt/button_set_wdb"/>" onClick="Set(this,'sxfsfw')">
  <%}%>
  <input type = "button" name = "del_windomain" value= "<nsgui:message key="nas_mapd/nt/button_del_wdb"/>" onClick="UnSet(this,'sxfsfw')">
  <%if (fromWhere.equals("export")){%>
  <input type = "button" name = "change_name" value= "<nsgui:message key="nas_mapd/nt/button_chg_netbios"/>" onClick="ChangeName()">
<%}
 }
}%>
</form>

<form target="mapd_navigator"  method="post"
        action="/nsadmin/mapd/MapdNavigatorList.do">
    <input type="hidden" name="operation" value="call"/>
    <input type="hidden" name="rootDirectory" value="/etc/openldap"/>
    <input type="hidden" name="nowDirectory" value=""/>
</form>
</BODY>
</HTML>