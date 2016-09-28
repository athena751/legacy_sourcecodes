<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ftpauthdb.jsp,v 1.2308 2005/11/22 03:19:29 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP" buffer="32kb"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*
                 ,com.nec.sydney.beans.mapdcommon.*
                 ,java.util.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="nshtml-taglib" prefix="nshtml" %>

<jsp:useBean id="bean" class="com.nec.sydney.beans.ftp.FTPAuthSetBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
	
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script src="../common/general.js"></script>
<script LANGUAGE="JavaScript">
function settofather(){
    if(window.opener&&!window.opener.closed){
        if(window.opener.ftpinfoform){
            if(document.authset.auth[0].checked){//pwd
                if(document.authset.ludb.options[document.authset.ludb.selectedIndex].value=="--------"){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_ftp/alert/invalidLUDB"/>");
                    return false;
                }
                window.opener.ftpinfoform.db.value = document.authset.auth[0].value; 
                window.opener.ftpinfoform.dbtype.value="PWD";
                window.opener.ftpinfoform.ludbname.value = document.authset.ludb.options[document.authset.ludb.selectedIndex].value;
            }
            if(document.authset.auth[1].checked){//nis
                        
                document.authset.nis_domain.value =gRTrim(document.authset.nis_domain.value);
                if (document.authset.nis_domain.value=="localdomain") {
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" 
                    + "<nsgui:message key="nas_mapd/alert/nis_localdomain"/>");
                    return false;
                }
                if (!checkNISDomain(document.authset.nis_domain.value)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_mapd/alert/unix_domain"/>");
                    return false;
                }
                
                document.authset.nis_server.value =gRTrim(document.authset.nis_server.value);
                if(!checkNISServer(document.authset.nis_server)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_mapd/alert/unix_server"/>");
                    return false;
                }
                window.opener.ftpinfoform.db.value = document.authset.auth[1].value; 
                window.opener.ftpinfoform.dbtype.value = "NIS";
                window.opener.ftpinfoform.nisdomain.value = document.authset.nis_domain.value;
                window.opener.ftpinfoform.nisserver.value = document.authset.nis_server.value;
            }
            if(document.authset.auth[2].checked){//pdc
                if(document.authset.nt_domain.options[document.authset.nt_domain.selectedIndex].value=="--------"){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_ftp/alert/invalidNtdomain"/>");
                    return false;
                }

                document.authset.pdc_name.value =gRTrim(document.authset.pdc_name.value);
                if(!checkNetBIOSName(document.authset.pdc_name.value)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_ftp/alert/invalidNetbios"/>");
                    return false;
                }
                
                document.authset.bdc_name.value =gRTrim(document.authset.bdc_name.value);
                if(!checkNetBIOSName(document.authset.bdc_name.value)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_ftp/alert/invalidNetbios"/>");
                    return false;
                }
                window.opener.ftpinfoform.db.value = document.authset.auth[2].value; 
                window.opener.ftpinfoform.dbtype.value = "PDC";
                window.opener.ftpinfoform.pdcdomain.value = document.authset.nt_domain.options[document.authset.nt_domain.selectedIndex].value;
                window.opener.ftpinfoform.pdcname.value = document.authset.pdc_name.value;  
                window.opener.ftpinfoform.bdcname.value = document.authset.bdc_name.value;  

            }
            if(document.authset.auth[3].checked){//ldap
                document.authset.ldap_server.value =trim(document.authset.ldap_server.value);
                if(!checkLDAPServer(document.authset.ldap_server.value)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_mapd/alert/ldapServerInvalid"/>");
                    return false;
                }
                //add 2003_10_07 check port
                if (checkPortNum(document.authset.ldap_server.value)==false){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" + 
                    "<nsgui:message key="nas_mapd/alert/portNumInvalid"/>");
                return false;
                }
                //end add
                document.authset.basedn.value =trim(document.authset.basedn.value);
                if(!checkBaseDNName(document.authset.basedn.value)||document.authset.basedn.value.length>1024){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_mapd/alert/ldapIDInvalid"/>");
                    document.authset.basedn.focus();
                    return false;
                }
                
                if(!(document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="anon")){
                    document.authset.ldap_authname.value =gRTrim(document.authset.ldap_authname.value);
                    if (document.authset.ldap_authname.value == ""){
                        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" 
                        + "<nsgui:message key="nas_mapd/alert/inputLdapAuthName"/>");
                        return false;
                    }
                    if(document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="simple"){
                        if(!checkDistinguishedName(document.authset.ldap_authname.value)){
                            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                            +"<nsgui:message key="nas_mapd/alert/ldapAuthNameInvalid"/>");
                            return false;
                        }
                    }
                    
                    if(document.authset.ldap_passwd.value==""){
                        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        +"<nsgui:message key="nas_mapd/alert/inputLdapPassName"/>");
                        return false;
                    }
                    
                    if(document.authset.ldap_passwd.value!=document.authset.ldap_passwdre.value){
                        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        +"<nsgui:message key="nas_mapd/alert/passwordNotSame"/>");
                        return false;
                    }
                    
                    if(document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="simple"){
                        if(document.authset.ldap_passwd.value.length>256){
                            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                            +"<nsgui:message key="nas_mapd/alert/ldapAuthPwdInvalid"/>");
                            return false;
                        }
                    }else {
                        if(document.authset.ldap_passwd.value.length>1024){
                            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                            +"<nsgui:message key="nas_ftp/alert/toolongpw2"/>");
                            return false;
                        }
                    }    
                }
                if(!checkCA()){
                    return false;
                }
                document.authset.ldapUserFilter.value = trim(document.authset.ldapUserFilter.value);
                if (checkLdapFilter (document.authset.ldapUserFilter.value)==false) {
                      alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                                "<nsgui:message key="nas_mapd/alert/ldapFilterInvalid"/>");
                    document.authset.ldapUserFilter.focus();
                    return false;
                }
                document.authset.ldapGroupFilter.value = trim(document.authset.ldapGroupFilter.value);
                if (checkLdapFilter (document.authset.ldapGroupFilter.value)==false) {
                      alert("<nsgui:message key="common/alert/failed"/>" + "\r\n" +
                                "<nsgui:message key="nas_mapd/alert/ldapFilterInvalid"/>");
                    document.authset.ldapGroupFilter.focus();
                    return false;
                }

                if(!checkuserinput(document.authset.userinput.value)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    +"<nsgui:message key="nas_ftp/alert/invaliduserinput"/>");
                    return false;
                } 
                
                window.opener.ftpinfoform.ldapserver.value = "";
                window.opener.ftpinfoform.ldapbasedn.value = "";  
                window.opener.ftpinfoform.ldapmethod.value = "";  
                window.opener.ftpinfoform.ldapuserinput.value = "";
                window.opener.ftpinfoform.ldapbindname.value = "";
                window.opener.ftpinfoform._ldapbindpasswd.value = "";
                window.opener.ftpinfoform.ldapcertfile.value = "";
                window.opener.ftpinfoform.ldapcertdir.value = ""; 
                window.opener.ftpinfoform.utoa.value = ""; 
                
                window.opener.ftpinfoform.ldapUserFilter.value = document.authset.ldapUserFilter.value;
                window.opener.ftpinfoform.ldapGroupFilter.value = document.authset.ldapGroupFilter.value;

                
                window.opener.ftpinfoform.db.value = document.authset.auth[3].value; 
                window.opener.ftpinfoform.dbtype.value = "LDAP";
                window.opener.ftpinfoform.ldapserver.value = document.authset.ldap_server.value;
                window.opener.ftpinfoform.ldapbasedn.value = document.authset.basedn.value;  
                window.opener.ftpinfoform.ldapmethod.value = getldapmethod(document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value);  
                window.opener.ftpinfoform.ldapuserinput.value = document.authset.userinput.value;
                for(var i=0;i<3;i++){
                    if(document.authset.tls[i].checked){
                        window.opener.ftpinfoform.ldapusetls.value=document.authset.tls[i].value;
                    }
                }
                
                if(!(document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="anon")){
                    window.opener.ftpinfoform.ldapbindname.value = document.authset.ldap_authname.value;
                    window.opener.ftpinfoform._ldapbindpasswd.value = document.authset.ldap_passwd.value;
                }
                    
                if(!document.authset.tls[0].checked){
                    window.opener.ftpinfoform.ldapcertfile.value = document.authset.auth_file.value;
                }
                
                if(document.authset.utoa.disabled){
                    window.opener.ftpinfoform.utoa.value = "n";
                }else{
                    if (document.authset.utoa.checked){
                        window.opener.ftpinfoform.utoa.value = "y";
                    }else{
                        window.opener.ftpinfoform.utoa.value = "n";
                    }
                }
                
                
/*                
                if(document.authset.CAtype[1].checked){
                     window.opener.ftpinfoform.ldapcertfile.value = document.authset.auth_file.value;
                }
                
                if(document.authset.CAtype[2].checked){
                    window.opener.ftpinfoform.ldapcertdir.value = document.authset.auth_dir.value;
                }
*/
            }
        }
    }
    window.close();
}

function getldapmethod(str){
    if(str=="anon"){
        return "SIMPLE";
    }
    if(str=="simple"){
        return "SIMPLE";
    }
    if(str=="digest-md5"){
        return "DIGEST-MD5";
    }
    if(str=="cram-md5"){
        return "CRAM-MD5";
    }
}

function firstload(){
    getfromfather();
    showpwd();
    shownis();
    showpdc();
    showldap();
}

//add by liq 20031105-1 change big character such as SIMPLE to small character such as simple
function changeldapmethodb2s(str,str2){
    if(str=="DIGEST-MD5"){
        return "digest-md5";
    }
    if(str=="CRAM-MD5"){
        return "cram-md5";
    }
    if(str=="SIMPLE"&&str2!=""){
        return "simple";
    }
    if(str=="SIMPLE"&&str2==""){
        return "anon"
    }
}
//end add by liq 20031105-1


//add by liq 20031105-2 get the auth windows setting from ftp.jsp hidden 
function getfromfather(){
    if(window.opener&&!window.opener.closed){
        if(window.opener.ftpinfoform){
            if(window.opener.ftpinfoform.db.value=="pwd"){
                document.authset.auth[0].checked=true;
                document.authset.auth[1].checked=false;
                document.authset.auth[2].checked=false;
                document.authset.auth[3].checked=false;
                for(var i=0;i<document.authset.ludb.options.length;i++){
                    if(window.opener.ftpinfoform.ludbname.value==document.authset.ludb.options[i].value){
                        document.authset.ludb.selectedIndex=i;
                        break;
                    }
                }
             }else if(window.opener.ftpinfoform.db.value =="nis"){
                document.authset.auth[0].checked=false;
                document.authset.auth[1].checked=true;
                document.authset.auth[2].checked=false;
                document.authset.auth[3].checked=false;

                document.authset.nis_domain.value = window.opener.ftpinfoform.nisdomain.value;
                document.authset.nis_server.value = window.opener.ftpinfoform.nisserver.value;
             }else if(window.opener.ftpinfoform.db.value =="dmc"){
                document.authset.auth[0].checked=false;
                document.authset.auth[1].checked=false;
                document.authset.auth[2].checked=true;
                document.authset.auth[3].checked=false;
                
                for(var i=0;i<document.authset.nt_domain.options.length;i++){
                    if(window.opener.ftpinfoform.pdcdomain.value == document.authset.nt_domain.options[i].value){
                        document.authset.nt_domain.selectedIndex=i;
                        break;
                    }
                }
                document.authset.pdc_name.value = window.opener.ftpinfoform.pdcname.value;  
                document.authset.bdc_name.value = window.opener.ftpinfoform.bdcname.value;  
             }else if(window.opener.ftpinfoform.db.value =="ldu"){
                document.authset.auth[0].checked=false;
                document.authset.auth[1].checked=false;
                document.authset.auth[2].checked=false;
                document.authset.auth[3].checked=true;
                
                document.authset.ldap_server.value = window.opener.ftpinfoform.ldapserver.value;
                document.authset.basedn.value = window.opener.ftpinfoform.ldapbasedn.value;  
                var ldapm=window.opener.ftpinfoform.ldapmethod.value;
                var ldapn=window.opener.ftpinfoform.ldapbindname.value;
                for(var i=0;i<document.authset.ldap_authtype.options.length;i++){
                    if(changeldapmethodb2s(ldapm,ldapn)== document.authset.ldap_authtype.options[i].value){
                        document.authset.ldap_authtype.selectedIndex=i;
                        break;
                    }
                }
                document.authset.tls[0].checked=false;
                document.authset.tls[1].checked=false;
                document.authset.tls[2].checked=false;
                for(var i=0;i<3;i++){
                    if(window.opener.ftpinfoform.ldapusetls.value==document.authset.tls[i].value){
                        document.authset.tls[i].checked=true;
                        break;
                    }
                }
                document.authset.ldapUserFilter.value = window.opener.ftpinfoform.ldapUserFilter.value;
                document.authset.ldapGroupFilter.value = window.opener.ftpinfoform.ldapGroupFilter.value;

                document.authset.ldap_authname.value = window.opener.ftpinfoform.ldapbindname.value;
                document.authset.ldap_passwd.value = window.opener.ftpinfoform._ldapbindpasswd.value;
                document.authset.ldap_passwdre.value = window.opener.ftpinfoform._ldapbindpasswd.value;
                if(window.opener.ftpinfoform.ldapcertfile.value=="" && window.opener.ftpinfoform.ldapcertdir.value==""){
                    //document.authset.CAtype[0].checked=true;
                    //document.authset.CAtype[1].checked=false;                    
                }else if(window.opener.ftpinfoform.ldapcertfile.value!=""){
                    //document.authset.CAtype[0].checked=false;
                    //document.authset.CAtype[1].checked=true; 
                    document.authset.auth_file.value = window.opener.ftpinfoform.ldapcertfile.value;
                }
                
                document.authset.utoa.checked=false;
                if (window.opener.ftpinfoform.utoa.value=="y"){
                    document.authset.utoa.checked=true;
                }
                               
                document.authset.userinput.value = window.opener.ftpinfoform.ldapuserinput.value;
             }
        }
    }
}
//end add by liq 20031105-2
function changepwd(str){
    document.authset.ludb.disabled=str;
}

function changenis(str){
    document.authset.nis_domain.disabled=str;
    document.authset.nis_server.disabled=str;
}

function changepdc(str){
    document.authset.nt_domain.disabled=str;
    document.authset.pdc_name.disabled=str;
    document.authset.bdc_name.disabled=str;
}

function changeldap(str){
    document.authset.ldap_server.disabled=str;
    document.authset.basedn.disabled=str;
    document.authset.ldap_authtype.disabled=str;
    document.authset.tls[0].disabled=str;
    document.authset.tls[1].disabled=str;
    document.authset.tls[2].disabled=str;
    document.authset.ldapUserFilter.disabled=str;
    document.authset.ldapGroupFilter.disabled=str;

    document.authset.ldap_authname.disabled=str;
    document.authset.ldap_passwd.disabled=str;
    document.authset.ldap_passwdre.disabled=str;
//    document.authset.CAtype[0].disabled=str;
//    document.authset.CAtype[1].disabled=str;
//    document.authset.CAtype[2].disabled=str;
    document.authset.auth_file.disabled=str;
    document.authset.auth_file_select.disabled=str;
//    document.authset.auth_dir.disabled=str;
//    document.authset.auth_dir_select.disabled=str;
    document.authset.utoa.disabled=str;
    document.authset.userinput.disabled=str;
}

function showpwd(){
    if(document.authset.auth[0].checked){
        changepwd(0);
        changenis(1);
        changepdc(1);
        changeldap(1);
    }else{
        changepwd(1);
    }
}

function shownis(){
    if(document.authset.auth[1].checked){
        changepwd(1);
        changenis(0);
        changepdc(1);
        changeldap(1);
    }else{
        changenis(1);
    }
}

function showpdc(){
    if(document.authset.auth[2].checked){
        changepwd(1);
        changenis(1);
        changepdc(0);
        changeldap(1);
    }else{
        changepdc(1);
    }
}

function showldap(){
    if(document.authset.auth[3].checked){
        changepwd(1);
        changenis(1);
        changepdc(1);
        changeldap(0);
        ldapChange();
        changeLdapCAstatus();
    }else{
        changeldap(1);
    }
}
var lastIndex;
function ldapChange(){
    <%if (bean.getHasLdapSam().equals("true")){%>
        if(document.authset.ldap_authtype.selectedIndex==0){
            document.authset.ldap_authtype.selectedIndex=lastIndex;
            alert("<nsgui:message key="nas_mapd/alert/cannotSelectAnonymous"/>");
        }else{
            lastIndex=document.authset.ldap_authtype.selectedIndex;
        }
    <%}%>
    if(document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="anon"){
        document.authset.ldap_authname.disabled=1;
        document.authset.ldap_passwd.disabled=1;
        document.authset.ldap_passwdre.disabled=1;
    }
    else{
        document.authset.ldap_authname.disabled=0;
        document.authset.ldap_passwd.disabled=0;
        document.authset.ldap_passwdre.disabled=0;
    }
    
    if((document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="anon")||
    (document.authset.ldap_authtype.options[document.authset.ldap_authtype.selectedIndex].value=="simple")){
        document.authset.utoa.disabled=1;    
    }else {
        document.authset.utoa.disabled=0;    
    } 
}

function showCAtype(){
    document.authset.auth_file.disabled=0;
    document.authset.auth_file_select.disabled=0;
/*    if(document.authset.CAtype[0].checked){
        document.authset.auth_file.disabled=1;
        document.authset.auth_file_select.disabled=1;
//        document.authset.auth_dir.disabled=1;
//        document.authset.auth_dir_select.disabled=1;
    }
    if(document.authset.CAtype[1].checked){
        document.authset.auth_file.disabled=0;
        document.authset.auth_file_select.disabled=0;
//        document.authset.auth_dir.disabled=1;
//        document.authset.auth_dir_select.disabled=1;
    }
    
    if(document.authset.CAtype[2].checked){
        document.authset.auth_file.disabled=1;
        document.authset.auth_file_select.disabled=1;
        document.authset.auth_dir.disabled=0;
        document.authset.auth_dir_select.disabled=0;

    }
*/
}

function checkCA(){
    /*if(document.authset.CAtype[0].checked){
        return true;
    }*/
    
    if(document.authset.tls[0].checked){
        return true;
    }
    var caName = "";
    caName = document.authset.auth_file.value;
/*    if (document.authset.CAtype[1].checked){
        caName = document.authset.auth_file.value;
        
    }else if (document.authset.CAtype[2].checked){
        caName = document.authset.auth_dir.value;

    }else{
        return true;
    }
*/    
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

var popWinFile,popWinDir;
function getCAfile(){
    if(popWinFile==null || popWinFile.closed) {
        popWinFile = window.open("<%=response.encodeURL("../filesystem/mountpointselect.jsp?frameNo=0&from=ftpd&type=file")%>","ftpcertfile",
                "toolbar=no,menubar=no,scrollbar=no,width=500,height=500,resizable=yes");
                window.pathForDisp = document.authset.auth_file;
    } else {
        popWinFile.focus();
    }

}

function getCAdir(){
    if(popWinDir==null || popWinDir.closed) {
        popWinDir = window.open("<%=response.encodeURL("../filesystem/mountpointselect.jsp?frameNo=0&from=ftpd&type=dir")%>","ftpcertdir",
                "toolbar=no,menubar=no,scrollbar=no,width=500,height=500,resizable=yes");
                window.pathForDisp = document.authset.auth_dir;
    } else {
        popWinDir.focus();
    }
}

//check japan code
function checkuserinput(str){
    if (str.length>4096){
        return false;
    }
    for(var i=0;i<str.length;i++){
        if((str.charCodeAt(i)>=0)&&(str.charCodeAt(i)<=255)){
        }else{
            return false;
        }
    }
    return true;
}

function changeLdapCAstatus(){
    if(document.authset.tls[0].checked){
        document.authset.auth_file.disabled=1;
        document.authset.auth_file_select.disabled=1;
    }else{
        document.authset.auth_file.disabled=0;
        document.authset.auth_file_select.disabled=0;
    }
}


</script>
<title><nsgui:message key="nas_ftp/common/h1"/></title>
</head>

<body onload="firstload();" onResize="resize()">
<% Map ludb= new TreeMap();
String target = (String)session.getAttribute("target");
Vector ludbVector = MapdCommonSOAPClient.getLUDBList(target);
if (ludbVector.size() > 0){
    for (int i = 0 ; i < ludbVector.size(); i++ ) {
        ludb.put((String)ludbVector.get(i),(String)ludbVector.get(i));
    }
}else{
    ludb.put("--------","--------");
}

Map ntDomain=new TreeMap();
Vector ntDomainVec = bean.getDomains();
if(ntDomainVec.size()>0){
    for (int i = 0 ; i < ntDomainVec.size(); i++ ) {
        ntDomain.put((String)ntDomainVec.get(i),(String)ntDomainVec.get(i));
    }
}else{
    ntDomain.put("--------","--------");
}


Map ldapauthtype=new LinkedHashMap();
ldapauthtype.put("anon",NSMessageDriver.getInstance().getMessage(session,"nas_ftp/auth_set/Anonymous"));
ldapauthtype.put("simple",NSMessageDriver.getInstance().getMessage(session,"nas_ftp/auth_set/SIMPLE"));

ldapauthtype.put("digest-md5",NSMessageDriver.getInstance().getMessage(session,"nas_ftp/auth_set/DIGEST-MD5"));
ldapauthtype.put("cram-md5",NSMessageDriver.getInstance().getMessage(session,"nas_ftp/auth_set/CRAM-MD5"));

%>
  
<h1 class="popup"><nsgui:message key="nas_ftp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="nas_ftp/general_settings/h2_ftp_settings"/></h2>
<h3 class="popup"><nsgui:message key="nas_ftp/ftp_info/authdb_h3"/></h3>
<nshtml:form name="authset" method="post" action="../../../menu/common/forward.jsp">

<table border="1" >
<%boolean ispwd=true;
boolean isnis=false;
boolean isdmc=false;
boolean isldu=false;
if (bean.getAuthDBType().equals("nis")){
    ispwd=false;
    isnis=true;
}else if(bean.getAuthDBType().equals("ldu")){
    ispwd=false;
    isldu=true;
}else if(bean.getAuthDBType().equals("dmc")){
    ispwd=false;
    isdmc=true;
}
String ludbOne =bean.getLudbName();
%>
    <tr>
    	<th align="left"><nshtml:radio value="pwd" name="auth" checked="<%=ispwd%>" others="id=\"a1\"" onclick="showpwd();"/>
    	    <label for="a1"><nsgui:message key="nas_ftp/auth_set/auth_pwd"/></label></th>
	    <td><nsgui:message key="nas_ftp/auth_set/pwd_ludb"/></td>
        <td><nshtml:select name="ludb" options="<%=ludb%>" selected="<%=ludbOne%>"/></td>
    </tr>
    <tr>
        <%
        String nisdomain=bean.getNisDomain();
        String nisserver=bean.getNisServer();%>
        <th rowspan="2" valign="top" align="left"><nshtml:radio value="nis" name="auth" checked="<%=isnis%>" others="id=\"a2\"" onclick="shownis();"/>
		<label for="a2"><nsgui:message key="nas_ftp/auth_set/auth_nis"/></label></th>
        <td><nsgui:message key="nas_ftp/auth_set/nis_domain"/></td>
        <td><nshtml:text name="nis_domain" size="45" maxlength="64" value="<%=nisdomain%>"/></td>
    </tr>
    <tr>
	    <td><nsgui:message key="nas_ftp/auth_set/nis_server"/></td>
        <td><nshtml:text name="nis_server"  size="45" value="<%=nisserver%>"/></td>
    </tr>
    <tr>
        <%String ntDomainOne=bean.getPdcDomain();
        String pdcName=bean.getPdcName();
        String bdcName=bean.getBdcName();%>
        <th rowspan="3" valign="top" align="left"><nshtml:radio value="dmc" name="auth" checked="<%=isdmc%>" others="id=\"a3\"" onclick="showpdc();"/>
		<label for="a3"><nsgui:message key="nas_ftp/auth_set/auth_pdc"/></label></th>
	    <td><nsgui:message key="nas_ftp/auth_set/pdc_domain"/></td>
        <td><nshtml:select name="nt_domain" options="<%=ntDomain%>" selected="<%=ntDomainOne%>"/></td>
    </tr>
    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/pdc_pdc"/></td>
        <td><nshtml:text name="pdc_name" size="45" maxlength="15" value="<%=pdcName%>"/></td>
    </tr>
    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/pdc_bdc"/></td>
        <td><nshtml:text name="bdc_name" size="45"  maxlength="15" value="<%=bdcName%>"/></td>
    </tr>
    <tr>
        <%String ldapServer=bean.getLdapServer();
        String baseDn=bean.getLdapBaseDN();
        String ldapAuthType=bean.getLdapMethod();
        
        boolean checkFirst = false;
        boolean checkSecond = false;
        boolean checkThird = false;
        if (bean.getLdapUseTls().equals("start_tls")){
            checkSecond = true;
        }else if (bean.getLdapUseTls().equals("yes")){
            checkThird = true;
        }else{
            checkFirst = true;
        }
        String ldapAuthName=bean.getLdapBindName();
        
        boolean noFileDir=true;
        boolean useFile=false;
        boolean useDir=false;
        String CAfile=bean.getLdapCertFile();
        String CAdir=bean.getLdapCertDir();
        String selectshow=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/select");
        String passwd=bean.getLdapBindPasswd();
        if(!CAfile.equals("")){
            noFileDir=false;
            useFile=true;
        }else {
            CAfile=selectshow;
        }
        
        if(!CAdir.equals("")){
            noFileDir=false;
            useDir=true;
        }else {
            CAdir=selectshow;
        }
        if(ldapAuthType.equals("SIMPLE")&&!ldapAuthName.equals("")){
            ldapAuthType="simple";
        }else if (ldapAuthType.equals("CRAM-MD5")){
            ldapAuthType="cram-md5";
        }else if(ldapAuthType.equals("DIGEST-MD5")){
            ldapAuthType="digest-md5";
        }else{
            ldapAuthType="anon";
        }
        %>
        
	    <th rowspan="11" valign="top" align="left"><nshtml:radio value="ldu" name="auth" checked="<%=isldu%>" others="id=\"a4\"" onclick="showldap();"/>
		<label for="a4"><nsgui:message key="nas_ftp/auth_set/auth_ldap"/></label></th>
      	<td><nsgui:message key="nas_ftp/auth_set/ldap_server"/></td>
	    <td><nshtml:text name="ldap_server" size="45" maxlength="256" value="<%=ldapServer%>"/></td>
    </tr>
    <tr>
      	<td><nsgui:message key="nas_ftp/auth_set/ldap_baseDN"/></td>
        <td><nshtml:text name="basedn" size="45" maxlength="1024" value="<%=HTMLUtil.sanitize(baseDn)%>"/></td>
    </tr>
    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/ldap_authtype"/></td>
        <td><nshtml:select name="ldap_authtype" options="<%=ldapauthtype%>" selected="<%=ldapAuthType%>" onchange="ldapChange();"/></td>
    </tr>
        
    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/ldap_auth"/></td>
        <td>
            <table>
                <tr>
                    <td><nsgui:message key="nas_ftp/auth_set/ldap_authname"/></td>
                    <td><nshtml:text name="ldap_authname" maxlength="1024" value="<%=HTMLUtil.sanitize(ldapAuthName)%>"  /></td>
                </tr>
                <tr>
                    <td><nsgui:message key="nas_ftp/auth_set/ldap_passwd"/></td>
                    <td><nshtml:password name="ldap_passwd" maxlength="1024" value="<%=HTMLUtil.sanitize(passwd)%>"/></td>
                </tr>
                <tr>
                    <td><nsgui:message key="nas_ftp/auth_set/ldap_passwdRe"/></td>
                    <td><nshtml:password name="ldap_passwdre" maxlength="1024" value="<%=HTMLUtil.sanitize(passwd)%>"/></td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/th_TLS"/></td>
        <td>
            <nshtml:radio name="tls" value="no" checked="<%=checkFirst%>" others="id=\"tls1\"" onclick="changeLdapCAstatus()" /><label for="tls1">
                <nsgui:message key="nas_ftp/auth_set/td_no_useTLS"/></label>
            <br><nshtml:radio name="tls" value="start_tls" checked ="<%=checkSecond%>" others="id=\"tls2\"" onclick="changeLdapCAstatus()" /><label for="tls2">
                <nsgui:message key="nas_ftp/auth_set/td_useStartTLS"/></label>
            <br><nshtml:radio name="tls" value="yes" checked ="<%=checkThird%>" others="id=\"tls3\"" onclick="changeLdapCAstatus()" /><label for="tls3">
                <nsgui:message key="nas_ftp/auth_set/td_useSSL_TLS"/></label>
        </td>
    </tr>
    
    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/ldap_CA"/></td>
        <td>
            <table>
                <tr>
                    <%String buttonshow=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/button_browse2");%>
                    <td>
                        <nshtml:text name="auth_file" readonly="true" maxlength="4095" value="<%=CAfile%>"/>
                        <nshtml:button name="auth_file_select" value="<%=buttonshow%>" onclick="getCAfile()"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td><nsgui:message key="nas_mapd/nt/th_userFilter"/></td>
        <td>
            <nshtml:text name="ldapUserFilter" size="45" maxlength="1023" value="<%=HTMLUtil.sanitize(bean.getLdapUserFilter())%>"/>
        </td>
    </tr>
    <tr>
        <td><nsgui:message key="nas_mapd/nt/th_groupFilter"/></td>
        <td>
            <nshtml:text name="ldapGroupFilter" size="45" maxlength="1023" value="<%=HTMLUtil.sanitize(bean.getLdapGroupFilter())%>"/>
        </td>
    </tr>

    <tr>
        <td><nsgui:message key="nas_ftp/auth_set/ldap_clientUA"/></td>
        <%boolean ischecked=false;
        if(bean.getUtoa().equals("y")){
            ischecked=true;
        } %>
        <td><nshtml:checkbox name="utoa" others="id=\"utoa1\"" checked="<%=ischecked%>"/>
      		<label for="utoa1"><nsgui:message key="nas_ftp/auth_set/ldap_utoa"/></label>
      	</td>
    </tr>
    
    <%String userInput=bean.getLdapUserInput();%>
    <tr><td colspan="2"><nsgui:message key="nas_ftp/auth_set/ldap_userinput"/></td></tr>
    <tr><td colspan="2"><nshtml:textarea name="userinput" value="" rows="5" cols="55"><%=HTMLUtil.sanitize(userInput)%></nshtml:textarea></td></tr>
    
    
</table>
<p>



<%String set=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/auth_set");
String close=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/close_popwin");%>
<nshtml:button value="<%=set%>" name="set" onclick="settofather();"/>
<nshtml:button value="<%=close%>" name="close" onclick="window.close();"/>
</nshtml:form>

</body>

</html>