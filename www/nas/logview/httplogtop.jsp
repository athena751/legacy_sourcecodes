<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httplogtop.jsp,v 1.7 2008/05/09 05:07:32 hetao Exp $" -->


<%@ page import="java.util.ArrayList" %>
<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var hasLoaded = 0;
var sizeForHeartbeat;
function init(){
    hasLoaded = 1;
    if(document.forms[0].logFile){
        if(document.forms[0].logFile.length){
            document.forms[0].logFile[0].checked=true;
        }else{
            document.forms[0].logFile.checked=true;
        }
        initData_Button();
    }
}

function getLogName (logFileName){
    if(logFileName == "<%=SyslogActionConst.HTTP_LOG_NAME_ACCESS%>"){
        return "<bean:message key="syslog.http.td_accessLog"/>";
    }else if(logFileName == "<%=SyslogActionConst.HTTP_LOG_NAME_ERROR%>"){
        return "<bean:message key="syslog.http.td_errorLog"/>";
    }else{
        return logFileName.substring(logFileName.lastIndexOf("/")+1);
    }
}

function initData_Button(){
    //this function is called by the "dataframe"
    if(document.forms[0].logFile){
        if((window.parent.dataframe.document.forms[0])
           && (window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"])){
            var logFileInfo = getCheckedRadioValue(document.forms[0].logFile);
            var lastindex = logFileInfo.lastIndexOf("#");
            var logFileName = logFileInfo.substring(0,lastindex);
            sizeForHeartbeat = logFileInfo.substring(lastindex+1);
            window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"].value=logFileName;
            window.parent.dataframe.document.forms[0].elements["commonInfo.logName"].value=getLogName(logFileName);
            if(window.parent.bottomframe.document.forms[0]){
                window.parent.bottomframe.changeButtonStatus();
            }
        }
    }
}
function onRefresh(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="enterSyslog.do?operation=enterSyslog&logType=httpLog";
}
</script>
</head>
<body onload="init();">
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>

<form name="httpTopForm" method="post" >
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
    <input type="button" name="refreshButton" onclick="onRefresh();"
        value="<bean:message key="common.button.reload" bundle="common"/>">
<h2 class="title"><bean:message key="syslog.common.h2_logInfo"/></h2>

    <table border="1" width="68%">
        <tr>
            <th>&nbsp;</th>
            <th><bean:message key="syslog.common.th_viewLog"/></th>
            <th><bean:message key="syslog.common.th_logFile"/></th>
            <th><bean:message key="syslog.common.th_fileSize"/></th>
        </tr>
        <tr>
            <logic:equal name="accessLogEixst" value="true">
                <bean:define id="accessLogFileSize" name="accessLogFileSize" type="java.lang.String"/>
                <td><input type="radio" name="logFile" id="<%=SyslogActionConst.HTTP_LOG_NAME_ACCESS%>" 
                value="<%=SyslogActionConst.HTTP_LOG_NAME_ACCESS%>#<%=accessLogFileSize%>" 
                onclick="initData_Button();"/></td>
                <td><label for="<%=SyslogActionConst.HTTP_LOG_NAME_ACCESS%>"><bean:message key="syslog.http.td_accessLog"/></label></td>
                <td><%=SyslogActionConst.HTTP_LOG_NAME_ACCESS%></td>
                <logic:equal name="accessLogFileSizeForDisplay" value="">
		        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
		        </logic:equal>
		        <logic:notEqual name="accessLogFileSizeForDisplay" value="">
		        	<td align="right"><bean:write name="accessLogFileSizeForDisplay"/></td>
		        </logic:notEqual>
            </logic:equal>
            <logic:equal name="accessLogEixst" value="false">
                <td><input type="radio" name="nodisplaylogFile" value="" 
                        onclick="return false;" disabled /></td>
                 <td><bean:message key="syslog.http.td_accessLog"/></td>
                 <td><bean:message key="syslog.common.msg.noLogFile"/></td>
                 <td align="center"><bean:message key="syslog.common.double_hyphen"/></td>
            </logic:equal>
        </tr>
        <tr>
            <logic:equal name="errorLogEixst" value="true">
            	<bean:define id="errorLogFileSize" name="errorLogFileSize" type="java.lang.String"/>
                <td><input type="radio" name="logFile" id="<%=SyslogActionConst.HTTP_LOG_NAME_ERROR%>" 
                value="<%=SyslogActionConst.HTTP_LOG_NAME_ERROR%>#<%=errorLogFileSize%>" 
                onclick="initData_Button();"/></td>
                <td><label for="<%=SyslogActionConst.HTTP_LOG_NAME_ERROR%>"><bean:message key="syslog.http.td_errorLog"/></label></td>
                <td><%=SyslogActionConst.HTTP_LOG_NAME_ERROR%></td>
                <logic:equal name="errorLogFileSizeForDisplay" value="">
		        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
		        </logic:equal>
		        <logic:notEqual name="errorLogFileSizeForDisplay" value="">
		        	<td align="right"><bean:write name="errorLogFileSizeForDisplay"/></td>
		        </logic:notEqual>
            </logic:equal>
            <logic:equal name="errorLogEixst" value="false">
                <td><input type="radio" name="nodisplaylogFile" value="" 
                        onclick="return false;" disabled /></td>
                 <td><bean:message key="syslog.http.td_errorLog"/></td>
                 <td><bean:message key="syslog.common.msg.noLogFile"/></td>
                 <td align="center"><bean:message key="syslog.common.double_hyphen"/></td>
            </logic:equal>
        </tr>
        <logic:iterate id="logFiles" name="restHttpLogFiles">
            <bean:define id="logLabel" name="logFiles" property="logLabel" type="java.lang.String"/>
            <bean:define id="logFileName" name="logFiles" property="logFileName" type="java.lang.String"/>
            <bean:define id="fileSize" name="logFiles" property="fileSize" type="java.lang.String"/>
            <bean:define id="fileSizeForDisplay" name="logFiles" property="fileSizeForDisplay" type="java.lang.String"/>
            <tr>
                <td><input type="radio" name="logFile" id="<%=logLabel%>"
                    value="<%=logFileName%>#<%=fileSize%>" onclick="initData_Button();" ></td>
                <td><label for="<%=logLabel%>"><%=NSActionUtil.sanitize(logLabel)%></label></td>
                <td><%=NSActionUtil.sanitize(logFileName)%></td>
                <logic:equal name="fileSizeForDisplay" value="">
		        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
		        </logic:equal>
		        <logic:notEqual name="fileSizeForDisplay" value="">
		        	<td align="right"><bean:write name="fileSizeForDisplay"/></td>
		        </logic:notEqual>
            </tr>
        </logic:iterate>
    </table><br>
</form>
</body>
</html>