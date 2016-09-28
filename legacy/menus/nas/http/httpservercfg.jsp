<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpservercfg.jsp,v 1.2303 2005/05/24 02:35:09 liq Exp" -->

<%@ page contentType="text/html;charset=EUC-JP" buffer="32kb"%>
<%@page import="java.util.*,
        com.nec.sydney.atom.admin.base.*,
        com.nec.sydney.beans.base.*,
        com.nec.sydney.beans.http.*,
        com.nec.sydney.atom.admin.http.*,
        com.nec.sydney.framework.*"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%@ taglib prefix="nshtml" uri="nshtml-taglib" %>

<jsp:useBean id="serverBean" scope="page" class="com.nec.sydney.beans.http.HTTPServerCfgBean"/>
<jsp:setProperty name="serverBean" property="*"/>
<%AbstractJSPBean _abstractJSPBean = serverBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%!
    HTTPServerInfo serverInfo;
    String checked0, checked1, checked2, button0, button1, text0, text1, disabled0, disabled1, browsebutton;
    boolean dis0, dis1;
%>

<%
    serverInfo = serverBean.getServerInfo();
    browsebutton = NSMessageDriver.getInstance().getMessage(session,"nas_http/button/browse");
%>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<jsp:include page="../../../menu/common/wait.jsp"/>
<%@include file="httpcommon.js" %>

<script language="JavaScript">
//modified by zhangjx
var usedPort = "<%=serverInfo.getUsedPort()%>";
var usedPortAry = usedPort.split(" ");
//end
function userDirDisable(obj) {
    if(obj.checked) {
        document.forms[0].userDirPattern.disabled = false;
        document.forms[0].userDirMode[0].disabled = false;
        document.forms[0].userDirMode[1].disabled = false;
        document.forms[0].userDirMode[2].disabled = false;
        if (document.forms[0].userDirMode[0].checked) {
            document.forms[0].userDirUserList.disabled = true;
        } else {
            document.forms[0].userDirUserList.disabled = false;
        }
    } else {
        document.forms[0].userDirPattern.disabled = true;
        document.forms[0].userDirMode[0].disabled = true;
        document.forms[0].userDirMode[1].disabled = true;
        document.forms[0].userDirMode[2].disabled = true;
        document.forms[0].userDirUserList.disabled = true;
    }
}

function usedIPDisable(obj) {
    if(obj.value=="<%=HTTPConstants.USEDIPADDRSMODE_CUSTOM%>") {
        document.forms[0].IPAddrs.disabled = false;
        document.forms[0].IPAddrsInput.disabled = false;
        document.forms[0].ipadd.disabled = false;
        if (document.forms[0].IPAddrs.length != 0) {
            document.forms[0].ipdelete.disabled = false;
        } else {
            document.forms[0].ipdelete.disabled = true;
        }
    } else {
        document.forms[0].IPAddrs.disabled = true;
        document.forms[0].IPAddrsInput.disabled = true;
        document.forms[0].ipdelete.disabled = true;
        document.forms[0].ipadd.disabled = true;
    }
}
/*
function customLogDisabled(obj) {
	if (obj.checked) {
		document.forms[0].customLogFileName.disabled = false;
		document.forms[0].customLogFormat.disabled = false;
		document.forms[0].logfilebrowse.disabled = false;
	} else {
		document.forms[0].customLogFileName.disabled = true;
		document.forms[0].customLogFormat.disabled = true;
		document.forms[0].logfilebrowse.disabled = true;
	}
}
*/

function errorLogDisabled(obj) {
	/*if (obj.value == "<%= HTTPConstants.ERRORLOGMODE_CUSTOM%>") {
		document.forms[0].errorLogLocation.disabled = false;
		document.forms[0].errorbrowse.disabled = false;
	} else {
		document.forms[0].errorLogLocation.disabled = true;
		document.forms[0].errorbrowse.disabled = true;
	}*/
}
var documentRootWin;
var transLogWin;
var transCustomWin;
var errorLogWin;
function browse(txt, a) {
    document.forms[0].operation.value="";
    if(txt.name=="documentRoot"){
        if (documentRootWin&&!documentRootWin.closed&&documentRootWin.name == txt.name){
        documentRootWin.focus();
        }else{
           documentRootWin=window.open("<%=response.encodeURL("httpnavigator.jsp")%>?act="+a,txt.name,"width=400,height=400,toolbar=no,menubar=no,scrollbars=yes");
           documentRootWin.path = txt;
        }
    }else if (txt.name=="transferLogLocation"){
        if (transLogWin&&!transLogWin.closed&&transLogWin.name == txt.name){
            transLogWin.focus();
        }else{
           transLogWin=window.open("<%=response.encodeURL("httpnavigator.jsp")%>?act="+a,txt.name,"width=400,height=400,toolbar=no,menubar=no,scrollbars=yes");
           transLogWin.path = txt;
        }
    }else if (txt.name=="customLogFileName"){
        if (transCustomWin&&!transCustomWin.closed&&transCustomWin.name == txt.name){
            transCustomWin.focus();
        }else{
           transCustomWin=window.open("<%=response.encodeURL("httpnavigator.jsp")%>?act="+a,txt.name,"width=400,height=400,toolbar=no,menubar=no,scrollbars=yes");
           transCustomWin.path = txt;
        }
    }else if (txt.name=="errorLogLocation"){
        if (errorLogWin&&!transCustomWin.closed&&transCustomWin.name == txt.name){
            errorLogWin.focus();
        }else{
           errorLogWin=window.open("<%=response.encodeURL("httpnavigator.jsp")%>?act="+a,txt.name,"width=400,height=400,toolbar=no,menubar=no,scrollbars=yes");
           errorLogWin.path = txt;
        }
    }

}

function onDirList(type) {
    if (type == "editDir" && (document.forms[0].directory.length == 0 ) ) {
        return false;
    }
    if (type == "editDir" && document.forms[0].directory.length != 0) {
        if (document.forms[0].directory.selectedIndex == -1) {
            alert("<nsgui:message key="nas_http/alert/select_directory"/>") ;
            document.forms[0].directory.focus() ;
            return false;
        } else if(document.forms[0].directory.options[document.forms[0].directory.selectedIndex].value == "") {
            return false;
        }
    }
    if (document.forms[0].directory.length != 0) {
        document.forms[0].currentDirectory.value = document.forms[0].directory.options[0].value;
    }
    for (var i = 1; i < document.forms[0].directory.length; i++) {
        document.forms[0].currentDirectory.value += " " + document.forms[0].directory.options[i].value;
    }
    document.forms[0].action = "<%=response.encodeURL("httpdirectorycfg.jsp")%>";
    document.forms[0].operation.value = type;
    win=window.open("/nsadmin/common/commonblank.html","directorywin","width=600,height=550,toolbar=no,menubar=no,scrollbars=yes");
    document.forms[0].action="<%=response.encodeURL("httpdirectorycfg.jsp")%>?";
    document.forms[0].target="directorywin";
    document.forms[0].submit();
    win.focus();

}

function addip() {
    if (!checkIPAddrs(document.forms[0].IPAddrsInput)
         || !checkPortUse(usedPortAry, document.forms[0].IPAddrsInput, "virtual")) {
        return;
    }
    var select = document.forms[0].IPAddrs;
    var tex=gInputTrim(document.forms[0].IPAddrsInput.value);
    var val=gInputTrim(document.forms[0].IPAddrsInput.value);
    select.options[select.length] = new Option(tex, val, false, true);
    select.options[select.length-1].selected=true;
    document.forms[0].IPAddrsInput.value = "";
    SortD(select);
    document.forms[0].ipdelete.disabled=false;
}

function deleteip() {
    var select = document.forms[0].IPAddrs;
    for(var i=0; i<select.length; i++) {
        if(select.options[i].selected && select.options[i].value != "") {
            select.options[i].value="";
            select.options[i].text="";
        }
    }
    BumpUp(select);
    if (document.forms[0].IPAddrs.length == 0) {
        document.forms[0].ipdelete.disabled=true;
    }
}

function BumpUp(box) {
    for(var i=0; i<box.length; i++) {
        if(box.options[i].value == "") {
            for(var j=i; j<box.length-1; j++) {
                box.options[j].value = box.options[j+1].value
                box.options[j].text = box.options[j+1].text
            }
            var ln = i
            break
        }
    }
    if(ln < box.length) {
        box.length -= 1;
        BumpUp(box);
    }
}

function SortD(box) {
    var temp_opts = new Array()
    var tempt = new Object();
    var tempv = new Object();
    var tempvalue = "";
    for(var i=0; i<box.length; i++) {
        temp_opts[i] = box.options[i]
        if (box.options[i].selected == true) {
            tempvalue = box.options[i].value;
        }
    }


    for(var x=0; x<temp_opts.length-1; x++) {
        for(var y=(x+1); y<temp_opts.length; y++) {
            if(temp_opts[x].text > temp_opts[y].text) {
                tempt = temp_opts[x].text;
                tempv = temp_opts[x].value;
                temp_opts[x].text = temp_opts[y].text;
                temp_opts[x].value = temp_opts[y].value;
                temp_opts[y].text = tempt;
                temp_opts[y].value =tempv;
            }
        }
    }

    for(var i=0; i<box.length; i++) {
        box.options[i].value = temp_opts[i].value
        box.options[i].text = temp_opts[i].text
        if (box.options[i].value == tempvalue) {
            box.options[i].selected=true;
        }
    }
}

function setoperation() {
        if (!isSubmitted()){
            return false;
        }
<c:choose>
    <c:when test="${serverBean.operation eq 'MainServerEdit'}">
        if (!checkServerName(document.forms[0].serverName)) {
            return false;
        }
    </c:when>
    <c:otherwise>
        if (!checkVirtualHostName(document.forms[0].serverName)
                || !checkUsedIPAddrs(document.forms[0].IPAddrs)
                || !checkNickName(document.forms[0].nickName)) {
            return false;
        }
    </c:otherwise>
</c:choose>
    if (checkDocumentRoot(document.forms[0].documentRoot)
            && checkServerAdmin(document.forms[0].serverAdmin)
            && checkUnixUserName(document.forms[0].unixUserName)
            && checkUnixUserID(document.forms[0].unixUserID)
            && checkUnixGroupName(document.forms[0].unixGroupName)
            && checkUnixGroupID(document.forms[0].unixGroupID)
            && checkWindowsGroupName(document.forms[0].windowsGroupName)
//            && checkTransferLocation(document.forms[0].transferLogLocation)
//            && checkCustomFileName(document.forms[0].customLogFileName)
//            && checkCustomFormat(document.forms[0].customLogFormat)
//            && checkErrorLogLocation(document.forms[0].errorLogLocation)
            && checkAccessFileName(document.forms[0].accessFileName)
            && checkPattern(document.forms[0].userDirPattern)
            && checkWindowsUserName(document.forms[0].windowsUserName)
            && checkUserList(document.forms[0].userDirUserList)) {
        setSubmitted();
        return true;
    }
    return false;
}

function onDelete() {
    if (!isSubmitted()){
        return false;
    }
    document.forms[0].operation.value = "virtualHostDelete";
    document.forms[0].action="<%= response.encodeURL("../../../menu/common/forward.jsp")%>";
    document.forms[0].target="";
    setSubmitted();
    document.forms[0].submit();

}

function onSub() {
<c:choose>
    <c:when test="${serverBean.operation eq 'MainServerEdit'}">
    document.forms[0].operation.value = "mainServerSet";
    </c:when>
    <c:otherwise>
    document.forms[0].operation.value = "virtualHostSet";
    </c:otherwise>
</c:choose>
    document.forms[0].action="<%= response.encodeURL("../../../menu/common/forward.jsp")%>";
    //document.forms[0].submit();
    document.forms[0].target="";
}

function init(){
  if (document.forms[0].operation.value!="mainServerEdit"){
  	if( "<%=serverInfo.getUsedIPAddrsMode()%>"=="<%=HTTPConstants.USEDIPADDSMODE_ALL%>"){
  		usedIPDisable(document.forms[0].usedIPAddrsMode[0])
  	}else {
  		usedIPDisable(document.forms[0].usedIPAddrsMode[1])
  	}
  }
  userDirDisable(document.forms[0].userDirAllowed)
  
}

</script>

</head>
<%String forwardJsp = response.encodeURL("../../../menu/common/forward.jsp");%>
<body onload="displayAlert(); init()">
<nshtml:form name="serverform" method="post" action="<%=forwardJsp%>" onsubmit="onSub();return setoperation();">

<c:choose>
    <c:when test="${serverBean.operation eq 'MainServerEdit'}">
        <input type="hidden" name="operation" value="mainServerEdit">
        <input type="hidden" name="whichpage" value="<%= HTTPConstants.PAGE_MAINEDIT%>">
    </c:when>
    <c:when test="${serverBean.operation eq 'VirtualHostEdit'}">
        <input type="hidden" name="operation" value="virtualHostEdit">
        <input type="hidden" name="whichpage" value="<%= HTTPConstants.PAGE_VIRTUALEDIT%>">
    </c:when>
    <c:when test="${serverBean.operation eq 'VirtualHostAdd'}">
        <input type="hidden" name="operation" value="virtualHostAdd">
        <input type="hidden" name="isVirtualAdd" value="yes">
        <input type="hidden" name="whichpage" value="<%= HTTPConstants.PAGE_VIRTUALADD%>">
    </c:when>
</c:choose>


<input type="hidden" name="beanClass" value="<%= serverBean.getClass().getName() %>">
<input type="hidden" name="oldNickName" value="<c:out value="${serverBean.nickName}"/>">
<input type="hidden" name="alertFlag" value="enable" />
<input type="hidden" name="act" value="" />
<input type="hidden" name="infoLocation" value="tmp">
<input type="hidden" name="currentDirectory" value=""/>

<h1 class="title"><nsgui:message key="nas_http/common/h1"/></h1>
<c:choose>
    <c:when test="${serverBean.operation eq 'MainServerEdit'}">
        <h2 class="title"><nsgui:message key="nas_http/server/h2_main"/></h2>
    </c:when>
    <c:otherwise>
        <h2 class="title"><nsgui:message key="nas_http/server/h2_virtual"/></h2>
    </c:otherwise>
</c:choose>

<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onclick="window.location='<%= response.encodeURL("httpinfo.jsp?infoLocation=tmp") %>'">
<br><br>

<table border="1">
<c:choose>
    <c:when test="${serverBean.operation ne 'MainServerEdit'}">
    <tr>
        <th align="left">
            <nsgui:message key="nas_http/server/th_virtual_host_name"/>
        </th>
        <td>
            <input type="text" name="serverName" value="<%= serverInfo.getServerName() %>" maxlength="200" size="50">
        </td>
    </tr>
    <tr>
        <th align="left">
            <nsgui:message key="nas_http/server/th_nick_name"/>
        </th>
        <td>
            <input type="text" name="nickName" value="<%= serverInfo.getNickName().equals("#")?"":serverInfo.getNickName() %>" maxlength="255" size="50">
        </td>
    </tr>
    <tr>
        <%
            checked0 = serverInfo.getVirtualHostType().equals(HTTPConstants.VIRTUALHOSTMOD_IP_BASED)?"checked":"";
            checked1 = serverInfo.getVirtualHostType().equals(HTTPConstants.VIRTUALHOSTMOD_NAME_BASED)?"checked":"";
        %>
        <th align="left">
            <nsgui:message key="nas_http/server/th_classfication"/>
        </th>
        <td>
            <input id="virtualHostType0" type="radio" name="virtualHostType" value="<%=HTTPConstants.VIRTUALHOSTMOD_IP_BASED%>" <%=checked0%>>
            <label for="virtualHostType0"><nsgui:message key="nas_http/server/th_ip_base"/></label>
            &nbsp;&nbsp;
            <input id="virtualHostType1" type="radio" name="virtualHostType" value="<%=HTTPConstants.VIRTUALHOSTMOD_NAME_BASED%>" <%=checked1%>>
            <label for="virtualHostType1"><nsgui:message key="nas_http/server/th_name_base"/></label>
        </td>
    </tr>
    <tr>
        <%
            checked0 = serverInfo.getUsedIPAddrsMode().equals(HTTPConstants.USEDIPADDSMODE_ALL)?"checked":"";
            checked1 = serverInfo.getUsedIPAddrsMode().equals(HTTPConstants.USEDIPADDRSMODE_CUSTOM)?"checked":"";
            disabled0 = serverInfo.getUsedIPAddrsMode().equals(HTTPConstants.USEDIPADDSMODE_ALL)?"true":"false";
            disabled1 = serverInfo.getUsedIPAddrsMode().equals(HTTPConstants.USEDIPADDSMODE_ALL)?"disabled":"";
            dis0 = serverInfo.getUsedIPAddrsMode().equals(HTTPConstants.USEDIPADDSMODE_ALL)?true:false;
            dis1 = dis0 || serverInfo.getUsedIPAddrs().trim().equals("")?true:false;
        %>
        <th align="left">
            <nsgui:message key="nas_http/server/th_ip_address"/>
        </th>
        <td>
        <table>
        <tr>
            <td colspan="2">
                <table><tr><td>
                    <input id="usedIPAddrsMode0" type="radio" name="usedIPAddrsMode" value="<%=HTTPConstants.USEDIPADDSMODE_ALL%>" <%=checked0%> onclick="usedIPDisable(this)">
                </td><td>
                    <label for="usedIPAddrsMode0"><nsgui:message key="nas_http/server/th_all"/></label>
                </td></tr></table>
            </td>
            <td colspan="2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td rowspan=2>
                <table><tr><td>
                    <input id="usedIPAddrsMode1" type="radio" name="usedIPAddrsMode" value="<%=HTTPConstants.USEDIPADDRSMODE_CUSTOM%>" <%=checked1%> onclick="usedIPDisable(this)">
                </td><td>
                    <label for="usedIPAddrsMode1"><nsgui:message key="nas_http/server/th_custom_multiple"/></label>
                </td></tr></table>
            </td>
            <%
                button0 = "<<"+NSMessageDriver.getInstance().getMessage(session,"common/button/add");
                button1 = NSMessageDriver.getInstance().getMessage(session,"common/button/delete")+">>";
            %>
            <td rowspan=2>
                    <%
                        String ips = serverInfo.getUsedIPAddrs();
                        String[] ipa = ips.split(" ");
                        LinkedHashMap options = new LinkedHashMap();
                        if (ips.trim().equals("")) {
                            ipa = new String[0];
                        }
                        for(int i=0; i < ipa.length; i++) {
                            options.put(ipa[i], ipa[i]);
                        }
                        options.put("000.000.000.000:00000", "000.000.000.000:00000");
                    %>
                <nshtml:select name="IPAddrs" others="size=4 style='width:155'" disabled="<%= dis0 %>" options="<%= options %>" />
                <script>
                    document.forms[0].IPAddrs.length = document.forms[0].IPAddrs.length - 1;
                </script>
            </td>
            <td>
                <nshtml:button name="ipadd" value="<%= button0 %>" onclick="addip()" disabled="<%= dis0 %>"/><br>
            </td>
            <td>
                <nshtml:text name="IPAddrsInput" value="" disabled="<%= dis0 %>" others="maxLength=21"/>
            </td>
        </tr>
        <tr>
            <td>
                <nshtml:button name="ipdelete" value="<%= button1 %>" onclick="deleteip()" disabled="<%= dis1 %>"/>
            </td>
            <td>
            &nbsp;
            </td>
        </tr>
        </table>
    </tr>
    <input type="hidden" name="usedIPAddrs" value="">
    </c:when>
</c:choose>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_document_root"/>
    </th>
    <td>
    <%
        text0 = serverInfo.getDocumentRoot();
        button0 = NSMessageDriver.getInstance().getMessage(session,"nas_http/button/browse");
    %>
        <nshtml:text name="documentRoot" readonly="true" value = "<%= text0 %>" size="50"/>
        <input type="button" name="documentbrowse" value="<%= button0 %>" onclick="browse(document.forms[0].documentRoot, 'nfs');">
    </td>
</tr>

<c:choose>
    <c:when test="${serverBean.operation eq 'MainServerEdit'}">
        <tr>
            <th align="left">
                <nsgui:message key="nas_http/server/th_sever_name"/>
            </th>
            <td>
                <input type="text" name="serverName" value="<%=serverInfo.getServerName()%>" maxlength="200" size="50"/>
            </td>
        </tr>
    </c:when>
</c:choose>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_server_admin"/>
    </th>
    <td>
        <input type="text" name="serverAdmin" value="<%=serverInfo.getServerAdmin()%>" maxlength="255" size="50"/>
    </td>
</tr>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_user_group"/>
    </th>
    <td>
    	<table>
    	<tr>
    		<td>
		        <nsgui:message key="nas_http/server/th_unix_user_name"/>
			</td>
			<td>
		        <input type="text" name="unixUserName" value="<%=serverInfo.getUnixUserName()%>" maxlength="32"/><br>
			</td>
		</tr>
		<tr>
			<td>
		        <nsgui:message key="nas_http/server/th_unix_user_id"/>
			</td>
			<td>
        		<input type="text" name="unixUserID" value="<%=serverInfo.getUnixUserID()%>" maxlength="5"/><br>
    		</td>
    	</tr>
    	<tr>
    		<td>
		        <nsgui:message key="nas_http/server/th_unix_group_name"/>
			</td>
			<td>
		        <input type="text" name="unixGroupName" value="<%=serverInfo.getUnixGroupName()%>" maxlength="32"/><br>
			</td>
		</tr>
		<tr>
			<td>
		        <nsgui:message key="nas_http/server/th_unix_group_id"/>
			</td>
			<td>
		        <input type="text" name="unixGroupID" value="<%=serverInfo.getUnixGroupID()%>" maxlength="5"/><br>
			</td>
		</tr>
		<tr>
			<td>
		        <nsgui:message key="nas_http/server/th_windows_user_name"/>
			</td>
			<td>
		        <input type="text" name="windowsUserName" value="<%=serverInfo.getWindowsUserName()%>" maxlength="32"/><br>
			</td>
		</tr>
		<tr>
			<td>
		        <nsgui:message key="nas_http/server/th_windows_group_name"/>
			</td>
			<td>
		        <input type="text" name="windowsGroupName" value="<%=serverInfo.getWindowsGroupName()%>" maxlength="32"/><br>
			</td>
		</tr>
		</table>
    </td>
</tr>


<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_errorlog_location"/>
    </th>
    <td>
        <%
            checked0 = serverInfo.getErrorLogMode().equals(HTTPConstants.ERRORLOGMODE_STANDARD)?"checked":"";
            checked1 = serverInfo.getErrorLogMode().equals(HTTPConstants.ERRORLOGMODE_CUSTOM)?"checked":"";
            checked2 = serverInfo.getErrorLogMode().equals(HTTPConstants.ERRORLOGMODE_SYSLOG)?"checked":"";
            dis0 = serverInfo.getErrorLogMode().equals(HTTPConstants.ERRORLOGMODE_CUSTOM)?false:true;
            text0 = serverInfo.getErrorLogLocation();
        %>
        <input id="errorLogMode0" type="radio" name="errorLogMode" value="<%= HTTPConstants.ERRORLOGMODE_STANDARD %>" <%= checked0 %> onclick="errorLogDisabled(this);">
        <label for="errorLogMode0"><nsgui:message key="nas_http/server/th_standard"/></label>
        <br>

        <input id="errorLogMode2" type="radio" name="errorLogMode" value="<%= HTTPConstants.ERRORLOGMODE_SYSLOG %>" <%= checked2 %> onclick="errorLogDisabled(this);">
        <label for="errorLogMode2"><nsgui:message key="nas_http/server/th_syslog"/></label>
    </td>
</tr>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_errorlog_level"/>
    </th>
    <td>
        <select name="errorLogLevel">
            <option value="emerg" <%= serverInfo.getErrorLogLevel().equals("emerg")?"selected":"" %>>Emerg</option>
            <option value="alert" <%= serverInfo.getErrorLogLevel().equals("alert")?"selected":"" %>>Alert</option>
            <option value="crit" <%= serverInfo.getErrorLogLevel().equals("crit")?"selected":"" %>>Crit</option>
            <option value="error" <%= serverInfo.getErrorLogLevel().equals("error")?"selected":"" %>>Error</option>
            <option value="warn" <%= serverInfo.getErrorLogLevel().equals("warn")?"selected":"" %>>Warn</option>
            <option value="notice" <%= serverInfo.getErrorLogLevel().equals("notice")?"selected":"" %>>Notice</option>
            <option value="info" <%= serverInfo.getErrorLogLevel().equals("info")?"selected":"" %>>Info</option>
            <option value="debug" <%= serverInfo.getErrorLogLevel().equals("debug")?"selected":"" %>>Debug</option>
        </select>
    </td>
</tr>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_access_file_name"/>
    </th>
    <td>
        <input type="text" name="accessFileName" maxlength="255" size="50" value="<%= serverInfo.getAccessFileName() %>">
    </td>
</tr>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_userdir_directory"/>
    </th>
    <td>
        <%
            boolean ch0 = serverInfo.getUserDirMode().equals(HTTPConstants.DIR_ENABLE)?true:false;
            boolean ch1 = serverInfo.getUserDirMode().equals(HTTPConstants.DIR_ENABLE_ONLY)?true:false;
            boolean ch2 = serverInfo.getUserDirMode().equals(HTTPConstants.DIR_DISABLE_ONLY)?true:false;
            dis0 = serverInfo.getUserDirAllowed()?false:true;
            dis1 = serverInfo.getUserDirAllowed()&&!serverInfo.getUserDirMode().equals(HTTPConstants.DIR_ENABLE)?false:true;
            text0 = serverInfo.getUserDirPattern();
            text1 = serverInfo.getUserDirUserList();
        %>
        <table>
            <tr>
                <td colspan="2">
                    <input id="userDirAllowed0" type="checkbox" name="userDirAllowed" value="true" onclick="userDirDisable(this)" <%= serverInfo.getUserDirAllowed()?"checked":"" %>>
                    <label for="userDirAllowed0"><nsgui:message key="nas_http/server/th_tranlate_uer_directory"/></label>
                </td>
            </tr>
            <tr>
                <td>
                    <nsgui:message key="nas_http/server/th_pattern"/>
                </td>
                <td>
                    <nshtml:text name="userDirPattern" value="<%= text0 %>" disabled="<%= dis0%>" maxlength="2047" size="50"/>
                </td>
            </tr>
            <tr>
                <td rowspan="3">
                    <nsgui:message key="nas_http/server/th_custom"/>
                </td>
                <td>
                    <nshtml:radio name="userDirMode" value="<%= HTTPConstants.DIR_ENABLE%>" disabled="<%= dis0 %>" checked="<%= ch0%>" onclick="document.forms[0].userDirUserList.disabled = true;" others="id=\"userDirMode0\""/>
                    <label for="userDirMode0"><nsgui:message key="nas_http/server/th_no_limit"/></label>
                </td>
            </tr>
            <tr>
                <td>
                    <nshtml:radio name="userDirMode" value="<%= HTTPConstants.DIR_ENABLE_ONLY%>" disabled="<%= dis0 %>" checked="<%= ch1%>" onclick="document.forms[0].userDirUserList.disabled = false;" others="id=\"userDirMode1\""/>
                    <label for="userDirMode1"><nsgui:message key="nas_http/server/th_user_list_translate"/></label>
                </td>
            </tr>
            <tr>
                <td>
                    <nshtml:radio name="userDirMode" value="<%= HTTPConstants.DIR_DISABLE_ONLY%>" disabled="<%= dis0 %>" checked="<%= ch2%>" onclick="document.forms[0].userDirUserList.disabled = false;" others="id=\"userDirMode2\""/>
                    <label for="userDirMode2"><nsgui:message key="nas_http/server/th_user_list_deny"/></label>
                </td>
            </tr>
            <tr>
                <td>
                    <nsgui:message key="nas_http/server/th_user_lit"/>
                </td>
                <td>
                    <nshtml:text name="userDirUserList" value="<%=HTMLUtil.sanitize(text1) %>" disabled="<%= dis1 %>" maxlength="65535" size="50"/>
                </td>
            </tr>
         </table>
    </td>
</tr>

<tr>
    <th align="left">
        <nsgui:message key="nas_http/server/th_directrory_setting"/>
    </th>
    <td>
        <table>
            <tr>
                <td rowspan="2">
                    <select name="directory" size="5" style="width:300">
                        <%Iterator it = serverBean.getDirectoryIterator();
                          String directory = "";
                          while (it.hasNext()){
                                directory = (String)it.next();
                                out.println("<option value=\""+directory+"\">"+NSUtil.space2nbsp(directory)+"</option>");
                          }

                        %>
                        <option>1234567890123456789012345678901234567890~!@#$</option>
                    </select>
                    <script language="JavaScript">
                        document.forms[0].directory.length = document.forms[0].directory.length - 1;
                    </script>
                </td>
                <td>
                    <input type="button" name="add" value="<nsgui:message key="common/button/add"/>..." onclick="onDirList('addDir')">
                </td>
            </tr>
            <tr>
                <td>
                    <%
                        text0 = NSMessageDriver.getInstance().getMessage(session,"nas_http/server/th_edit") + "...";
                        dis0 = serverBean.getDirectoryIterator().hasNext()?false:true;
                    %>
                    <nshtml:button name="edit" value="<%= text0 %>" onclick="onDirList('editDir')" disabled="<%= dis0 %>"/>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>

<br>

<input type="submit" name="submit1" value="<nsgui:message key="common/button/submit"/>">
<c:if test="${serverBean.operation ne 'MainServerEdit' and serverBean.operation ne 'VirtualHostAdd'}">
    <input type="button" name="delete" value="<nsgui:message key="common/button/delete"/>" onclick="onDelete()">
</c:if>

</nshtml:form>
</html>
