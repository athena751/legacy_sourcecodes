<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: mapdnative.jsp,v 1.2323 2008/05/08 10:29:09 fengmh Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page buffer="32kb" %>
<%@page import="java.util.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.beans.mapd.*,java.lang.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.sydney.atom.admin.base.api.*" %>
<%@ page import="com.nec.sydney.beans.mapdcommon.*" %>
<%@ page import="com.nec.sydney.atom.admin.mapd.*" %>
<%@ page import="com.nec.nsgui.action.base.*" %>
<%@ page import="com.nec.nsgui.model.biz.domain.DomainHandler"%>
<%@ page import="com.nec.nsgui.model.biz.usermapping.UsermappingHandler"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="nativeAddBean" scope="page" class="com.nec.sydney.beans.mapdnative.NativeAddBean"/>

<%AbstractJSPBean _abstractJSPBean = nativeAddBean;%>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%@include file="../../../menu/common/meta.jsp" %>
<%@page language="java"%>

<%
    String addType = request.getParameter("addType");
    if (addType == null || addType.equals("")){
        addType = "unix";
    }
     
    String displayType = request.getParameter("commonType");
    if (displayType == null){
        displayType = "";
    }    
    AuthInfo authInfo = null;
    String hasLdapSam = "";
    if (displayType.equals(NativeDomain.NATIVE_LDAPUW) 
        || displayType.equals(NativeDomain.NATIVE_LDAPU)){
        authInfo = nativeAddBean.getLDAPInfo();
        hasLdapSam = nativeAddBean.getHasLdapSam();
    }
%>
<html>
<head>

<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">

<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" />


<script src="../common/general.js"></script>

<script language="JavaScript">

function Back(){
    if (!document.mapdnativeform.back.disabled){
        window.location="<%=response.encodeURL("nativelist.jsp")%>";
    }
}

function Set(){
    if(!isSubmitted()){
        return false;
    }
    if (document.mapdnativeform.addNative.disabled){
        return false;
    }
    
    <%if (addType.equals("win")) {%>
        if(!checkNTDomainwithnode(document.mapdnativeform.winDomain.value)){
            if(!confirm("<nsgui:message key="nas_mapd/nt/msg_info_domainwithnode"/>")){
                return false;
            }
        }
        if(!checkNTDomain(document.mapdnativeform.winDomain.value)){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                    +"<nsgui:message key="nas_cifs/alert/l_d_ldname"/>");
            document.mapdnativeform.winDomain.focus();
            return false;
        }
        <%if (displayType.equals(NativeDomain.NATIVE_LDAPUW)
                || displayType.equals(NativeDomain.NATIVE_NISW)
                || displayType.equals(NativeDomain.NATIVE_PWDW)) {%>
            if(!checkNetBIOSName(document.mapdnativeform.netbiosName.value)){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        + "<nsgui:message key="nas_native/alert/invalidNetbios"/>");
                document.mapdnativeform.netbiosName.focus();
                return false;
            }
            
            <%  int groupNumber = NSActionUtil.getCurrentNodeNo(request);
                String[] hostName = DomainHandler.getHostName(groupNumber);
                for (int i=0 ; i<hostName.length ;i++){
                    if(hostName[i] != null){%>
                        if ( document.mapdnativeform.netbiosName.value == "<%=hostName[i]%>"){
                            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                                +"<nsgui:message key="nas_mapd/nt/msg_info_hostname"/>");
                            return false;
                        }
                <%}%>
            <%}%>

            <% String[] domAndComOfSchedulescan = UsermappingHandler.getAllDomAndComOfSchedulescan(groupNumber);
               if(domAndComOfSchedulescan != null && domAndComOfSchedulescan.length != 0) {
                   for(int i = 0; i < domAndComOfSchedulescan.length; i ++) {
                       String[] domAndCom = domAndComOfSchedulescan[i].split("\\+");
                       if(domAndCom.length < 2) {
                	       continue;
                       }
                       String domainName = domAndCom[0];
                       String computerName = domAndCom[1];%>
                       if(document.mapdnativeform.netbiosName.value == "<%=computerName%>") {
                           <%if(!displayType.equals(NativeDomain.NATIVE_PWDW)) {%>
                               alert("<nsgui:message key="nas_native/alert/msg_ScheduleScan_domainTypeError"/>");
                               return false;
                           <%}%>
                           if(document.mapdnativeform.winDomain.value != "<%=domainName%>") {
                               alert("<nsgui:message key="nas_native/alert/msg_ScheduleScan_domainError"/>");
                               return false;
                           }
                       }
                 <%}%>
             <%}%>
        <%}%>
    <%}else{%>
        if (document.mapdnativeform.network.value != "" 
            && checkNativeNetwork(document.mapdnativeform.network.value) == false){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        +"<nsgui:message key="nas_native/alert/invalidNetwork"/>");
            document.mapdnativeform.network.focus();
            return false;
        }
    <%}%>
    
    var selectType = "<%=displayType%>";
    if (selectType == ""){
        <%if (addType.equals("win")) {%>
            selectType = "<%=NativeDomain.NATIVE_ADS%>";
        <%}else{%>
            selectType ="<%=NativeDomain.NATIVE_NIS%>";
        <%}%>
    }
    document.mapdnativeform.commonType.value = selectType;
    
    if(selectType == "<%=NativeDomain.NATIVE_DMC%>"){
        if(checkWindowsUserName(document.mapdnativeform.dmcUsername.value)==false)
        {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/nt_username"/>");
            document.mapdnativeform.dmcUsername.focus();
            return false;
        }
    }
   
    if(selectType == "<%=NativeDomain.NATIVE_ADS%>"){
		document.mapdnativeform.dnsDomain.value =
			trim(document.mapdnativeform.dnsDomain.value);
        if(checkFQDN(document.mapdnativeform.dnsDomain.value)==false)
        {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/dnsdomain"/>");
            return false;
        }
		document.mapdnativeform.kdcServer.value =
			trim(document.mapdnativeform.kdcServer.value);
		if(checkKDCServer(document.mapdnativeform.kdcServer)==false)
        {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/kdcserver"/>");
            return false;
        }
        if(checkWindowsUserName(document.mapdnativeform.adsUsername.value)==false)
        {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/nt_username"/>");
            return false;
        }
    }

    if (selectType == "<%=NativeDomain.NATIVE_PWDW%>"
        || selectType == "<%=NativeDomain.NATIVE_PWD%>"){
        var ludbName = 
            document.mapdnativeform.pwdLudb.options[document.mapdnativeform.pwdLudb.selectedIndex].value;
        if (ludbName == "<nsgui:message key="nas_mapd/nt/noLudb"/>") {
            alert("<nsgui:message key="common/alert/failed"/>" 
                + "\r\n" + "<nsgui:message key="nas_mapd/alert/noLUDB"/>");
            return false;
        }
    }
    
    if (selectType == "<%=NativeDomain.NATIVE_NISW%>"
        || selectType == "<%=NativeDomain.NATIVE_NIS%>"){
        if (checkNISDomain(document.mapdnativeform.nisDomain.value)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                "<nsgui:message key="nas_mapd/alert/unix_domain"/>");
            document.mapdnativeform.nisDomain.focus();
            return false;
        }
        if (document.mapdnativeform.nisDomain.value=="localdomain") {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                "<nsgui:message key="nas_mapd/alert/nis_localdomain"/>");
            return false;
        }

        if (checkNISServer(document.mapdnativeform.nisServer)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                "<nsgui:message key="nas_mapd/alert/unix_server"/>");
            document.mapdnativeform.nisServer.focus();
            return false;
        }
    }
    
    if (selectType == "<%=NativeDomain.NATIVE_LDAPUW%>"
        || selectType == "<%=NativeDomain.NATIVE_LDAPU%>" ){
        document.mapdnativeform.ldapServer.value = trim(document.mapdnativeform.ldapServer.value);
        if (checkLDAPServer(document.mapdnativeform.ldapServer.value)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                "<nsgui:message key="nas_mapd/alert/ldapServerInvalid"/>");
            document.mapdnativeform.ldapServer.focus();
            return false;
        }
        if (checkPortNum(document.mapdnativeform.ldapServer.value)==false){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                "<nsgui:message key="nas_mapd/alert/portNumInvalid"/>");
            return false;
        
        }
        document.mapdnativeform.ldapId.value = trim(document.mapdnativeform.ldapId.value);
        if (checkBaseDNName(document.mapdnativeform.ldapId.value)==false) {
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                "<nsgui:message key="nas_mapd/alert/ldapIDInvalid"/>");
            document.mapdnativeform.ldapId.focus();
            return false;
        }
        
        var selectAuthType = document.mapdnativeform.ldapMode.options[document.mapdnativeform.ldapMode.selectedIndex].value;
        if (selectAuthType != "<%=NativeLDAPDomain.TYPE_ANON%>"){
            if (document.mapdnativeform.ldapAuthName.value == ""){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                        "<nsgui:message key="nas_mapd/alert/inputLdapAuthName"/>");
                return false;
            }

            if (document.mapdnativeform._ldapAuthPassword.value == ""){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                        "<nsgui:message key="nas_mapd/alert/inputLdapPassName"/>");
                return false;
            }

            if (selectAuthType == "<%=NativeLDAPDomain.TYPE_SIMPLE%>"){
                if (checkDistinguishedName(document.mapdnativeform.ldapAuthName.value)==false) {
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                        "<nsgui:message key="nas_mapd/alert/ldapAuthNameInvalid"/>");
                    return false;
                }
                if (document.mapdnativeform._ldapAuthPassword.value.length > 256){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                          "<nsgui:message key="nas_mapd/alert/ldapAuthPwdInvalid"/>");
                    return false;
                }
            }
            if (document.mapdnativeform._ldapAuthPassword.value != document.mapdnativeform._ldapAuthPasswordRe.value) {
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                    "<nsgui:message key="nas_mapd/alert/passwordNotSame"/>");
                return false;
            }
        }
        
        if (checkCA()==false) {
            return false;
        }
        document.mapdnativeform.ldapUserFilter.value = trim(document.mapdnativeform.ldapUserFilter.value);
        if (checkLdapFilter (document.mapdnativeform.ldapUserFilter.value)==false) {
             alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/ldapFilterInvalid"/>");
             document.mapdnativeform.ldapUserFilter.focus();
            return false;
        }
        document.mapdnativeform.ldapGroupFilter.value = trim(document.mapdnativeform.ldapGroupFilter.value);
        if (checkLdapFilter (document.mapdnativeform.ldapGroupFilter.value)==false) {
             alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                        "<nsgui:message key="nas_mapd/alert/ldapFilterInvalid"/>");
             document.mapdnativeform.ldapGroupFilter.focus();
            return false;
        }
    }
    
    mesg = "<nsgui:message key="common/confirm" />" + "\r\n"
            + "<nsgui:message key="common/confirm/act" />"
            + "<nsgui:message key="common/button/submit"/>";

    if(isSubmitted()&&(confirm(mesg))){
        document.mapdnativeform.commonType.value = selectType;
        setSubmitted();
        document.mapdnativeform.nasAction.value = "Set";
        document.mapdnativeform.action="<%= response.encodeURL("nativeaddforward.jsp")%>";
        return true;
    }else
        return false;
}

function checkCA(){
    if (!document.mapdnativeform.ldapCa){
        return true;
    }
    if(document.mapdnativeform.ldapTls[0].checked){
         document.mapdnativeform.ldapCa.value = "no";
         return true;
    }else{
        document.mapdnativeform.ldapCa.value = "file";
    }
    
    var caName = "";
    caName = document.mapdnativeform.ldapCaFileText.value;
    /*if (document.mapdnativeform.ldapCa[1].checked){
        caName = document.mapdnativeform.ldapCaFileText.value;
    } 
    else if (document.mapdnativeform.ldapCa[2].checked){
        caName = document.mapdnativeform.ldapCaDirText.value;
    }
    else{
        return true;
    }*/
    if(caName == "<nsgui:message key="nas_common/common/msg_select"/>"){
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/needSelectCertificateFile"/>");
        return false;
    }else if(caName.length > 4095){
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                "<nsgui:message key="nas_mapd/alert/CAInvalid"/>");
        return false;
    }else{
        return true;
    }
}


function onInit(){
    <%if (displayType.equals(NativeDomain.NATIVE_LDAPUW)
          || displayType.equals(NativeDomain.NATIVE_LDAPU)){%>
          ldapChange();
    <%}%> 
}

function lock(name){
    name.disabled=true;
}

function unlock(name){
    name.disabled=false;
}

function typeChange(){
    if(isSubmitted()){
        setSubmitted();
        document.mapdnativeform.commonType.value=
            document.mapdnativeform.nativeTypeSelectBox.options[document.mapdnativeform.nativeTypeSelectBox.selectedIndex].value;
        document.mapdnativeform.addNative.disabled = true;
        document.mapdnativeform.back.disabled = true;
        <%if (displayType.equals(NativeDomain.NATIVE_LDAPUW)
              || displayType.equals(NativeDomain.NATIVE_LDAPU)){%>
              lock(document.mapdnativeform.ldapCaFileButton);
              //lock(document.mapdnativeform.ldapCaDirButton);
        <%}%>
        document.mapdnativeform.action = "<%=response.encodeRedirectURL("mapdnative.jsp")%>";
        document.mapdnativeform.submit();
    }
}
var lastIndex;
function ldapChange(){
    if (document.mapdnativeform 
        && document.mapdnativeform.ldapMode
        && !document.mapdnativeform.ldapMode.disabled ){
        <%if (hasLdapSam.equals("true")){%>
            if(document.mapdnativeform.ldapMode.selectedIndex==0){
                document.mapdnativeform.ldapMode.selectedIndex=lastIndex;
                alert("<nsgui:message key="nas_mapd/alert/cannotSelectAnonymous"/>");
            }else{
                lastIndex=document.mapdnativeform.ldapMode.selectedIndex;
            }
        <%}%>
        var selectAuthType = document.mapdnativeform.ldapMode.options[document.mapdnativeform.ldapMode.selectedIndex].value;
        if (selectAuthType != "<%=NativeLDAPDomain.TYPE_ANON%>"){
            unlock(document.mapdnativeform.ldapAuthName);
            unlock(document.mapdnativeform._ldapAuthPassword);
            unlock(document.mapdnativeform._ldapAuthPasswordRe);
        }else{
            lock(document.mapdnativeform.ldapAuthName);
            lock(document.mapdnativeform._ldapAuthPassword);
            lock(document.mapdnativeform._ldapAuthPasswordRe);
        }
    }
    
    /*if (document.mapdnativeform 
        && document.mapdnativeform.ldapCa 
        && !document.mapdnativeform.ldapCa.disabled){
        if (document.mapdnativeform.ldapCa[1].checked){
            unlock(document.mapdnativeform.ldapCaFileText);
            unlock(document.mapdnativeform.ldapCaFileButton);
        }else{
            lock(document.mapdnativeform.ldapCaFileText);
            lock(document.mapdnativeform.ldapCaFileButton);
        }
        
        if (document.mapdnativeform.ldapCa[2].checked){
            unlock(document.mapdnativeform.ldapCaDirText);
            unlock(document.mapdnativeform.ldapCaDirButton);
        }else{
            lock(document.mapdnativeform.ldapCaDirText);
            lock(document.mapdnativeform.ldapCaDirButton);
        }
    }*/
}

var popWinFile,popWinDir;

function navigate(name){    

    if(name=="selectFile"){
        if(popWinFile==null||popWinFile.closed){
            popWinFile = window.open(
             "<%=response.encodeURL("../filesystem/mountpointselect.jsp?frameNo=0&from=mapdnative&type=file")%>","authFileNavi",
                "toolbar=no,menubar=no,scrollbar=no,width=500,height=500,resizable=yes");
            window.pathForDisp = document.mapdnativeform.ldapCaFileText;
        }else{
            popWinFile.focus();
        }
    }/*else if(name=="selectDir"){
         if(popWinDir==null||popWinDir.closed){
            if(popWinDir==null||popWinDir.closed){
                popWinDir = window.open("<%=response.encodeURL("../filesystem/mountpointselect.jsp?frameNo=0&from=mapdnative&type=dir")%>","authDirNavi",
                "toolbar=no,menubar=no,scrollbar=no,width=500,height=500,resizable=yes");
               window.pathForDisp = document.mapdnativeform.ldapCaDirText;
            }else{
              popWinDir.focus();
            }
         }
   }*/
}

function toUpper(obj){
    obj.value = obj.value.toUpperCase();
}

function changeLdapCAstatus(){
<%if (displayType.equals(NativeDomain.NATIVE_LDAPUW) || displayType.equals(NativeDomain.NATIVE_LDAPU)){%>
    
    if(document.mapdnativeform.ldapTls[0].checked){
        lock(document.mapdnativeform.ldapCaFileText);
        lock(document.mapdnativeform.ldapCaFileButton);
    }else{
        unlock(document.mapdnativeform.ldapCaFileText);
        unlock(document.mapdnativeform.ldapCaFileButton);
    }
<%}%>
}

</script>

</head>

<BODY onload="displayAlert();onInit();changeLdapCAstatus();">

<h1><nsgui:message key="nas_native/common/h1"/></h1>


<form name="mapdnativeform" method="post" action="" onSubmit="if(this.action == '') return false;">
    <input type="hidden" name="alertFlag" value="enable">
    <input type="hidden" name="addType" value="<%=addType%>">
    <input type="hidden" name="commonType" value="">
    <input type="hidden" name="nasAction" value="">
     
    <%if (displayType.equals(NativeDomain.NATIVE_LDAPUW)
            || displayType.equals(NativeDomain.NATIVE_LDAPU)){%>
        <input type="hidden" name="path" value="">
    <%}%>
    
    <INPUT TYPE="button" NAME="back"
        value="<nsgui:message key="common/button/back"/>"  onClick="Back()"/>
  
<h2><nsgui:message key="nas_native/common/h2_add"/></h2>

    <br>
    <table border="1" >
    <tr>
        <th align="left">
            <nsgui:message key="nas_mapd/nt/th_domainType"/>           
        </th>    
        <td>
            <select name="nativeTypeSelectBox" >
                <% if (addType.equals("win")){%>
                    <option value="<%=NativeDomain.NATIVE_ADS%>" <%=displayType.equals(NativeDomain.NATIVE_ADS)?"selected":""%>>
                        <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_ADS)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_SHR%>" <%=displayType.equals(NativeDomain.NATIVE_SHR)?"selected":""%>>
                        <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_SHR)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_DMC%>" <%=displayType.equals(NativeDomain.NATIVE_DMC)?"selected":""%>>
                        <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_DMC)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_NISW%>" <%=displayType.equals(NativeDomain.NATIVE_NISW)?"selected":""%>>
                            <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_NISW)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_PWDW%>" <%=displayType.equals(NativeDomain.NATIVE_PWDW)?"selected":""%>>
                            <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_PWDW)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_LDAPUW%>" <%=displayType.equals(NativeDomain.NATIVE_LDAPUW)?"selected":""%>>
                            <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_LDAPUW)%>
                    </option>
                <%}else{%>
                    <option value="<%=NativeDomain.NATIVE_NIS%>" <%=displayType.equals(NativeDomain.NATIVE_NIS)?"selected":""%>>
                        <%=NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/" + AuthDomain.AUTH_NIS)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_PWD%>" <%=displayType.equals(NativeDomain.NATIVE_PWD)?"selected":""%>>
                        <%=NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/" + AuthDomain.AUTH_PWD)%>
                    </option>
                    <option value="<%=NativeDomain.NATIVE_LDAPU%>" <%=displayType.equals(NativeDomain.NATIVE_LDAPU)?"selected":""%>>
                        <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + AuthDomain.AUTH_LDAPU)%>
                    </option>
                <%}%>
            </select>
            <input type="button" name="select" value="<nsgui:message key="common/button/select"/>" onclick="typeChange();">
        </td>
    </tr>
    <%if (addType.equals("win")) {%>
        <tr>
            <th  align="left"><nsgui:message key="nas_native/common/th_ntDomain"/></th>
            <td><input type="text" name="winDomain" maxlength="15" value=""
                onfocus="if(this.disabled) this.blur();" onchange="toUpper(this);"/>
                <br>[<font class="advice"><nsgui:message key="nas_mapd/nt/domain_inputcomment"/></font>]
            </td>
        </tr>
        <%if (displayType.equals(NativeDomain.NATIVE_LDAPUW)
                || displayType.equals(NativeDomain.NATIVE_NISW)
                || displayType.equals(NativeDomain.NATIVE_PWDW)) {%>
            <tr>
                <th  align="left"><nsgui:message key="nas_native/nativeSxfsfw/th_computername"/></th>
                <td><input type="text" name="netbiosName" maxlength="15" value=""
                    onfocus="if(this.disabled) this.blur();" onchange="toUpper(this);"/>
                </td>   
            </tr>
        <%}%>
    <%}else{%>
        <th  align="left"><nsgui:message key="nas_native/nativeSxfs/th_subnet"/></th>
        <td><input type="text" name="network" value="" onfocus="if(this.disabled) this.blur();"
                size="48" maxlength="32"/>
        </td>
    <%}%>
    <%if ((displayType.equals("") && addType.equals("win"))
        || displayType.equals(NativeDomain.NATIVE_ADS)){
    %>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/text_dnsdomain"/></th>
            <td><input type="text" name="dnsDomain" size="48" maxlength="255" value="" />
				<br>[<font class="advice"><nsgui:message key="nas_mapd/nt/ads_dns_info"/></font>]
		    </td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/text_kdcserver"/></th>
            <td><input type="text" name="kdcServer" size="48"
				value="" /><nsgui:message key="nas_mapd/nt/optional"/></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/unix/text_username"/></th>
            <td><input type="text" name="adsUsername" size="48" onfocus="if (this.disabled) this.blur();"
            value='Administrator' maxlength="20" ></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/unix/text_pass"/></th>
            <td><input type="password" name="_adsPassword" size="48" maxlength="127"
                onfocus="if (this.disabled) this.blur(); " value=''></td>
        </tr>
        
        
    <%}%>

    <%if (displayType.equals(NativeDomain.NATIVE_DMC)){
    %>
      <tr>
            <th align="left"><nsgui:message key="nas_mapd/unix/text_username"/></th>
            <td><input type="text" name="dmcUsername" size="32" maxlength="20" 
				value="Administrator" /></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/unix/text_pass"/></th>
            <td><input type="password" name="_dmcPassword" size="32" maxlength="127" 
				value="" /></td>
        </tr>  
    <%}%>
    
    <%if (displayType.equals(NativeDomain.NATIVE_NISW)
            || displayType.equals(NativeDomain.NATIVE_NIS)
            || (displayType.equals("") && addType.equals("unix"))
        ){
    %>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th>
            <td>
                <input type="text" name="nisDomain" onfocus="if (this.disabled) this.blur();" 
                    value="" size="48" maxLength="64" >
            </td>
        </tr> 
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th>
            <td>
                <input type="text" name="nisServer" value="" size="48" >
            </td>
        </tr>        
    <%}%>
    
    <%if (displayType.equals(NativeDomain.NATIVE_PWDW)
          || displayType.equals(NativeDomain.NATIVE_PWD)){
    %>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
            <td>
                <select name="pwdLudb" onchange="ldapChange();">
                    <%
                    String target = (String)session.getAttribute("target");
                    Vector ludbVector = MapdCommonSOAPClient.getLUDBList(target);
                         if (ludbVector.size() > 0){
                            for (int i = 0 ; i < ludbVector.size(); i++ ) {%>
                                <option value="<%=(String)ludbVector.get(i)%>"><%=(String)ludbVector.get(i)%></option>
                            <%}%>
                         <%}else{%>
                            <option value="<nsgui:message key="nas_mapd/nt/noLudb"/>">
                                <nsgui:message key="nas_mapd/nt/noLudb"/>
                            </option>
                         <%}%>
                </select>
            </td>
        </tr> 
     <%}%>
    
     <%if (displayType.equals(NativeDomain.NATIVE_LDAPUW)
            || displayType.equals(NativeDomain.NATIVE_LDAPU)){ %>
        <tr>  
            <th align="left"><nsgui:message key="nas_mapd/nt/ldapServerName"/></th>
            <td>
                <input type="text" name="ldapServer" onfocus="if (this.disabled) this.blur();" 
                    value="<%=authInfo != null ? authInfo.getServerName():""%>" size="48" maxLength="256" >
            </td>
        </tr>
        
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
            <td>
                <input type="text" name="ldapId" onfocus="if (this.disabled) this.blur();" 
                    value="<%=authInfo != null ? HTMLUtil.sanitize(authInfo.getDistinguishedName()):""%>"
                    size="48" maxLength="1024" >
            </td>
        </tr>  
          
        <tr>      
            <th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
            <td>
                <select name="ldapMode" onChange="ldapChange();">
                    <%String authType4LDAP = (authInfo != null ? authInfo.getAuthenticateType() : "");%>
                     <option <%=authType4LDAP.equals(NativeLDAPDomain.TYPE_ANON) ? "selected":""%>
                        value="<%=NativeLDAPDomain.TYPE_ANON%>">
                        <%=NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/" + NativeLDAPDomain.TYPE_ANON)%>
                     </option>
                     <option <%=authType4LDAP.equals(NativeLDAPDomain.TYPE_SIMPLE) ? "selected":""%>
                        value="<%=NativeLDAPDomain.TYPE_SIMPLE%>">
                        <%=NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/" + NativeLDAPDomain.TYPE_SIMPLE)%>
                     </option>
                     <option <%=authType4LDAP.equals(NativeLDAPDomain.TYPE_MD5) ? "selected":""%>
                        value="<%=NativeLDAPDomain.TYPE_MD5%>">
                        <%=NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/" + NativeLDAPDomain.TYPE_MD5)%>
                     </option>
                     <option <%=authType4LDAP.equals(NativeLDAPDomain.TYPE_CRAM) ? "selected":""%>
                        value="<%=NativeLDAPDomain.TYPE_CRAM%>">
                        <%=NSMessageDriver.getInstance().getMessage(session,"nas_mapd/nt/" + NativeLDAPDomain.TYPE_CRAM)%>
                     </option>
                </select>
            </td>     
         </tr>  
         <tr>  
            <th align="left"><nsgui:message key="nas_mapd/nt/ldapAuth"/></th>
            <td>
                <table border="0" nowrap>
                    <tr>
                        <td><label for="ldapAuthName"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></label></td>
                        <td>
                            <input type="text" name="ldapAuthName" onfocus="if (this.disabled) this.blur();" 
                                value="<%=authInfo != null? HTMLUtil.sanitize(authInfo.getAuthenticateID()):""%>"
                                disabled size="32" maxLength="1024" ID="ldapAuthName">
                        </td>
                    </tr>
                    <tr>
                        <td><label for="_ldapAuthPassword"><nsgui:message key="nas_mapd/nt/ldapAuthPasswd"/></label></td>
                        <td>
                            <input type="password" name="_ldapAuthPassword" onfocus="if (this.disabled) this.blur();" 
                                value="<%=authInfo != null ? HTMLUtil.sanitize(authInfo.getAuthenticatePasswd()):""%>"
                                disabled size="32" maxLength="1024" ID="_ldapAuthPassword">
                        </td>
                    </tr>
                    <tr>
                        <td><label for="_ldapAuthPasswordRe"><nsgui:message key="nas_mapd/nt/ldapAuthPasswdRe"/></label></td>
                        <td>
                            <input type="password" name="_ldapAuthPasswordRe" onfocus="if (this.disabled) this.blur();" 
                                value="<%=authInfo != null ? HTMLUtil.sanitize(authInfo.getAuthenticatePasswd()):""%>"
                                disabled size="32" maxLength="1024" ID="_ldapAuthPasswordRe">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>    
            <th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
            <td>
                <%
                String checkFirst = "";
                String checkSecond = "";
                String checkThird = "";
                if (authInfo != null && authInfo.getTLS().equals("start_tls")){
                    checkSecond = "checked";
                }else if (authInfo != null && authInfo.getTLS().equals("yes")){
                    checkThird = "checked";
                }else{
                    checkFirst = "checked";
                }
                %>
                <input type="radio" name="ldapTls" ID="ldapTls_no" value="no" 
                    <%=checkFirst%> onclick="changeLdapCAstatus()">
                    <label for="ldapTls_no"><nsgui:message key="nas_mapd/nt/td_no_useTLS"/></label>
                <br><input type="radio" name="ldapTls" ID="ldapTls_start_tls" value="start_tls"
                    <%=checkSecond%> onclick="changeLdapCAstatus()">
                    <label for="ldapTls_start_tls"><nsgui:message key="nas_mapd/nt/td_useStartTLS"/></label>
                <br><input type="radio" name="ldapTls" ID="ldapTls_yes" value="yes"
                    <%=checkThird%> onclick="changeLdapCAstatus()">
                    <label for="ldapTls_yes"><nsgui:message key="nas_mapd/nt/td_useSSL_TLS"/></label>
            </td>   
         </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
            <td>
                <%
                String selectIndex = "1";
                if ( authInfo != null){
                   if (authInfo.getCAType().equals("file")){
                        selectIndex = "2";
                   }
                   if (authInfo.getCAType().equals("dir")){
                        selectIndex = "3";
                   }
                }%>
                <table border=0 nowrap>
                    <!--<tr><td>
                        <input type="radio" name="ldapCa" ID="ldapCaNo" value="no" 
                            onclick="if (!this.disabled){ldapChange();}" <%=(!selectIndex.equals("2"))?"checked":""%>>
                                <label for="ldapCaNo"><nsgui:message key="nas_mapd/nt/ldapCANo"/></label>
                    </td></tr>
                    <tr><td>
                        <input type="radio" name="ldapCa" ID="ldapCaFile" value="file" 
                            onclick="if (!this.disabled){ldapChange();}"
                            <%=selectIndex.equals("2")?"checked":""%>>
                                <label for="ldapCaFile"><nsgui:message key="nas_mapd/nt/ldapCAFile"/></label>
                    </td></tr>-->
                    <tr><td>
                        <input type="hidden" name="ldapCa" value="no" ><!--add this hidden because comment the old radio type-->
                        <input type="text" name="ldapCaFileText" onfocus="this.blur();" 
                                value="<%=selectIndex.equals("2")?
                                    authInfo.getCA():NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select")%>" 
                                readonly size="32" maxLength="4095" disabled >
                        <input type="button" name="ldapCaFileButton" value="<nsgui:message key="common/button/browse2"/>" 
                                disabled onclick="if (!this.disabled){navigate('selectFile');}" >
                    </td></tr>
                    <!--tr><td>
                        <input type="radio" name="ldapCa" ID="ldapCaDir" value="dir" 
                            onclick="if (!this.disabled){ldapChange();}" 
                            <%=selectIndex.equals("3")?"checked":""%>>
                                <label for="ldapCaDir"><nsgui:message key="nas_mapd/nt/ldapCADir"/></label>
                    </td></tr>
                    <tr><td>
                        &nbsp;&nbsp;&nbsp;
                        <input type="text" name="ldapCaDirText" onfocus="this.blur();" 
                                value="<%=selectIndex.equals("3")?
                                    authInfo.getCA():NSMessageDriver.getInstance().getMessage(session,"nas_common/common/msg_select")%>" 
                                readonly size="32" maxLength="4095" disabled >
                        <input type="button" name="ldapCaDirButton" value="<nsgui:message key="common/button/browse2"/>" 
                                disabled onclick="if (!this.disabled){navigate('selectDir');}">
                    </td></tr-->
                 </table>
            </td>      
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
            <td>
                <input type="text" name="ldapUserFilter" size="48" maxlength="1023"
                 value="<%=authInfo != null ? HTMLUtil.sanitize(authInfo.getUserFilter()):""%>" >
            </td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
            <td>
                <input type="text" name="ldapGroupFilter" size="48" maxlength="1023"
                 value="<%=authInfo != null ? HTMLUtil.sanitize(authInfo.getGroupFilter()):""%>" >
            </td>
        </tr>     
        <tr>
            <th align="left"><nsgui:message key="nas_ftp/auth_set/ldap_clientUA"/></th>
            <td>
                <input type="checkbox" name="utoa4diaplay" disabled <%=authInfo == null 
                                   || authInfo.getUtoa().equals("n")?"":"checked"%> />
                <nsgui:message key="nas_ftp/auth_set/ldap_utoa"/>
                <input type="hidden" name="utoa" value="<%=authInfo == null?"n":authInfo.getUtoa()%>" />
            </td>
        </tr>   
    <%}%>
    </table>

    <br>
    <INPUT TYPE="submit" NAME="addNative" value="<nsgui:message key="common/button/submit"/>" 
            onClick="return Set();"/>

</form>
</BODY>
</HTML>

