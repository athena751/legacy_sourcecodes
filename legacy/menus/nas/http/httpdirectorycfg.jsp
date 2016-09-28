<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpdirectorycfg.jsp,v 1.2304 2007/09/13 01:51:54 zhangjx Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.*,
                 com.nec.sydney.framework.*,
                 com.nec.sydney.beans.http.*,
                 com.nec.sydney.atom.admin.base.*,
                 com.nec.sydney.atom.admin.http.* " %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="nshtml-taglib" prefix="nshtml" %>
<jsp:useBean id="DirectoryCfg" class="com.nec.sydney.beans.http.HTTPDirectoryCfgBean" scope="page"/>
<jsp:setProperty name="DirectoryCfg" property="*" />
<%
    String oldNickName = DirectoryCfg.getOldNickName() ;
    if (DirectoryCfg.getIsVirtualAdd() != null && DirectoryCfg.getIsVirtualAdd().equals("yes")){
        oldNickName = "#";
    }
%>
<%AbstractJSPBean _abstractJSPBean = DirectoryCfg; %>
<%@include file="../../common/includeheader.jsp" %>

<html>
<%  HTTPDirectoryInfo theDirInfo= DirectoryCfg.getDirectoryInfo() ;
    String fromWhichPage = DirectoryCfg.getWhichPage() ;
    String oldDirectory = DirectoryCfg.getOldDirectory() ;
    String oldDirectoryList = DirectoryCfg.getOldDirectoryList();
%>
<head>
<%@include file="../../common/meta.jsp" %>
<jsp:include page="../../common/wait.jsp"/>
<title><nsgui:message key="nas_http/directory/title"/></title>
<script language="JavaScript" src="../common/general.js">
</script>
<script language="JavaScript">
    var oldDirList ;

    function openerExist() {
        if (window.opener && !window.opener.closed
                && window.opener.document.forms[0].whichpage
                && (window.opener.document.forms[0].whichpage.value=="<%=fromWhichPage%>")
                && window.opener.document.forms[0].oldNickName
                && (window.opener.document.forms[0].oldNickName.value=="<%=oldNickName%>")
                && window.opener.document.forms[0].directory) {
            oldDirList = window.opener.document.forms[0].directory ;
            return true ;
        } else {
            return false ;
        }

    }

    function setAccess() {
        var theAccessMode = "<%=theDirInfo.getDirectoryAccessMode()%>" ;
        if (theAccessMode=="<%=HTTPConstants.ALL_ALLOW%>") {
            document.forms[0].accessMode[0].checked = true ;
            document.forms[0].allowList.disabled = true;
            document.forms[0].denyList.disabled = true;
        } else {
            if (theAccessMode=="<%=HTTPConstants.ORDER_ALLOW_DENY%>") {
                document.forms[0].accessMode[1].checked = true ;
            } else if(theAccessMode=="<%=HTTPConstants.ORDER_DENY_ALLOW%>") {
                document.forms[0].accessMode[2].checked = true ;
            }
            document.forms[0].allowList.disabled = false;
            document.forms[0].denyList.disabled = false;
        }
    }

    function checkOperation() {
        if (document.forms[0].operation.value=="") {
            return false ;
        } else {
            return true ;
        }
    }
    var win;
    function openDirectory(txt) {
        if (win&&!win.closed){
            win.focus();
        }else{
            win = window.open("<%=response.encodeURL("httpnavigator.jsp")%>?act=nfs",txt.name,"width=400,height=400,toolbar=no,menubar=no,scrollbars=yes");
            win.path = txt ;
        }
    }

    function onAccessMode (radio) {
        if (radio.value=="<%=HTTPConstants.ALL_ALLOW%>") {
            document.forms[0].allowList.disabled=true;
            document.forms[0].denyList.disabled=true;
        } else {
            document.forms[0].allowList.disabled=false;
            document.forms[0].denyList.disabled=false;
        }
    }
    
    function checkCIDR(s){
        var info = s.split("/");
        var ip = info[0];
        var mask = info[1];
        if(checkIP(ip) && mask > 0 && mask <= 32){
            return true;
        }
        return false;
    }
    
    function setDirectory()	{
        if (isSubmitted()) {
            if (!openerExist()) {
                alert("<nsgui:message key="nas_http/alert/opener_changed"/>") ;
                window.close() ;
                return false ;
            }
            if ("<%=oldDirectory%>"!="") {
                var oldExist = false ;
                for (var i=0; i<oldDirList.length; i++) {
                    if ("<%=oldDirectory%>"==oldDirList.options[i].value) {
                        oldExist = true ;
                        break ;
                    }
                }
                if (!oldExist) {
                    alert("<nsgui:message key="nas_http/alert/not_found_old_directory"/>") ;
                    window.close() ;
                    return false ;
                }
            }
            var newDirectory = document.forms[0].newDirectory.value ;
            if (newDirectory=="") {
                alert("<nsgui:message key="nas_http/alert/input_directory"/>") ;
                document.forms[0].browseDir.focus() ;
                return false ;
            } else if (("<%=oldDirectory%>"=="") || (newDirectory!="<%=oldDirectory%>")) {
                for (var i=0; i<oldDirList.length; i++) {
                    if (newDirectory==oldDirList.options[i].value) {
                        alert("<nsgui:message key="nas_http/alert/get_directory_exist"/>" + "\n"
                                + "<nsgui:message key="nas_http/alert/input_other_directory"/>") ;
                        document.forms[0].browseDir.focus() ;
                        return false ;
                    }
                }
            }
            if (document.forms[0].allowList.disabled==false
                && document.forms[0].denyList.disabled==false
                && gInputTrim(document.forms[0].allowList.value)==""
                && gInputTrim(document.forms[0].denyList.value)==""){
                document.forms[0].allowList.focus() ;
                alert("<nsgui:message key="nas_http/alert/none_allow_or_deny_list"/>");
                return false;
            }
            if ((document.forms[0].allowList.disabled==false)) {
             	  document.forms[0].allowList.value = trimMultiSpace(document.forms[0].allowList.value);
                var theAllowList = document.forms[0].allowList.value ;
                if (theAllowList != ""){
                    var strArray = theAllowList.split(/[\s]+/g);
                    var fqdn;
                    for(var i=0;i<strArray.length;i++) {
                        fqdn = strArray[i];
                        if(!checkFQDN(fqdn) && !checkCIDR(fqdn)) {
                            alert("<nsgui:message key="nas_http/alert/invalid_allow_list"/>") ;
                            document.forms[0].allowList.focus() ;
                            return false ;
                         }
                    }
                }
            }
            if ((document.forms[0].denyList.disabled==false)){
                document.forms[0].denyList.value = trimMultiSpace(document.forms[0].denyList.value);
                var theDenyList = document.forms[0].denyList.value ;
                if (theDenyList != ""){
                    var strArray = theDenyList.split(/[\s]+/g);
                    var fqdn;
                    for(var i=0;i<strArray.length;i++) {
                        fqdn=strArray[i];
                        if(!checkFQDN(fqdn) && !checkCIDR(fqdn)) {
                            alert("<nsgui:message key="nas_http/alert/invalid_deny_list"/>") ;
                            document.forms[0].denyList.focus() ;
                            return false;
                        }
                    }
                }
            }
            document.forms[0].operation.value="SubmitDir";
            document.forms[0].submit();
            setSubmitted();
            return true ;
        }
    }

		function trimMultiSpace(str){
		  str = trim(str);
			if (str==""){
				return "";
			}
			var strArray = str.split(/[\s]+/g);
			var formatStr = "";
			for (var i=0;i<strArray.length;i++){
				formatStr += strArray[i]+" ";
			}
			return gInputTrim(formatStr);
		}

    function delDirectory()	{
        if (isSubmitted()) {
            if (!openerExist()) {
                alert("<nsgui:message key="nas_http/alert/opener_changed"/>") ;
                window.close() ;
            } else {
                var oldExist = false ;
                for (var i=0; i<oldDirList.length; i++) {
                    if ("<%=oldDirectory%>"==oldDirList.options[i].value) {
                        oldExist = true ;
                        break ;
                    }
                }
                if (oldExist) {
                    document.forms[0].operation.value="DelDir";
                    document.forms[0].submit();
                    setSubmitted();
                } else {
                    alert("<nsgui:message key="nas_http/alert/not_found_old_directory"/>") ;
                    window.close() ;
                }
            }
        }
    }
</script>
</head>

<body onLoad="setAccess()">
<h1><nsgui:message key="nas_http/common/h1"/></h1>
<h2><nsgui:message key="nas_http/directory/h2"/></h2>

<% String forwardJsp = response.encodeURL("../../../menu/common/forward.jsp"); %>
<nshtml:form name="formDirectory" method="post" onsubmit="checkOperation()" action="<%=forwardJsp%>" >
<input type="hidden" name="operation" value="">
<input type="hidden" name="beanClass" value="<%=DirectoryCfg.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="oldDirectory" value="<%=oldDirectory%>">
<input type="hidden" name="whichpage" value="<%=fromWhichPage%>">
<input type="hidden" name="oldNickName" value="<%=oldNickName%>">
<input type="hidden" name="act" value="getall">

<table border="1">
<tr>
    <th align="left"><nsgui:message key="nas_http/directory/th_directory"/></th>
    <td><nshtml:text name="newDirectory" readonly="true" value="<%=oldDirectory%>" others="size=43" />
        <input type="button" name="browseDir" value="<nsgui:message key="nas_http/button/browse"/>"
                onClick="openDirectory(document.forms[0].newDirectory)">
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/directory/th_access"/></th>
    <td><input id="accessMode0" type="radio" name="accessMode" value="<%=HTTPConstants.ALL_ALLOW%>" onClick="onAccessMode(this)" checked />
                <label for="accessMode0"><nsgui:message key="nas_http/directory/th_allow_from_all"/></label><br>
        <input id="accessModel1" type="radio" name="accessMode" value="<%=HTTPConstants.ORDER_ALLOW_DENY%>" onClick="onAccessMode(this)" />
                <label for="accessModel1"><nsgui:message key="nas_http/directory/th_order_allow_deny"/></label><br>
        <input id="accessModel2" type="radio" name="accessMode" value="<%=HTTPConstants.ORDER_DENY_ALLOW%>" onClick="onAccessMode(this)" />
                <label for="accessModel2"><nsgui:message key="nas_http/directory/th_order_deny_allow"/></label><br>
        <br>
        <%  String allowList = theDirInfo.getDirectoryAccessAllowList() ;
            String denyList = theDirInfo.getDirectoryAccessDenyList() ; %>
        &nbsp;<nsgui:message key="nas_http/directory/th_allow_list"/>
                <nshtml:text  name="allowList" value="<%=allowList%>" disabled="true" onfocus="this.select()" others="size=40" /><br>
        &nbsp;<nsgui:message key="nas_http/directory/th_deny_list"/>
                <nshtml:text  name="denyList" value="<%=denyList%>" disabled="true" onfocus="this.select()" others="size=40" />
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/directory/th_option"/></th>
    <td><%  String theOption = theDirInfo.getDirectoryOptions() ;
            if (theOption.equals("")) {
                out.print("&nbsp;") ;
            } else {
                out.print(theOption) ;
            } %>
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/directory/th_htaccess_definiation"/></th>
    <td><%  String theHtaccess = theDirInfo.getAllowOverwriteOptions() ;
            if (theHtaccess.equals("")) {
                out.print("&nbsp;") ;
            } else {
                out.print(theHtaccess) ;
            } %>
    </td>
</tr>
</table>
<br>

<input type="button" name="btnSetDirectory"
       value="<nsgui:message key="common/button/submit"/>" onclick="return setDirectory()">
<% if (!oldDirectory.equals("")) { %>
<input type="button" name="btnDelDirectory"
       value="<nsgui:message key="common/button/delete"/>" onclick="return delDirectory()">
<% } %>
<input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onclick="window.close()">
</nshtml:form>
</body>
</html>