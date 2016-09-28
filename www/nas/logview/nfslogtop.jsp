<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfslogtop.jsp,v 1.14 2008/09/23 09:56:42 penghe Exp $" -->

<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<bean:define id="accessLogFile" name="accessLogFile" type="java.lang.String"/>

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

function initData_Button(){
    //the function is also called by dataframe
    if(document.forms[0].logFile){
        if((window.parent.dataframe.document)
           &&(window.parent.dataframe.document.forms[0])
           && (window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"])){
            
            var checkedLogFile = getCheckedRadioValue(document.forms[0].logFile);
            var lastIndex = checkedLogFile.lastIndexOf("#");
            sizeForHeartbeat = checkedLogFile.substring(lastIndex+1);
            checkedLogFile = checkedLogFile.substring(0,lastIndex);
            var logName;
            if((checkedLogFile.charAt(0) == '0') && (checkedLogFile.charAt(1) == 'x')){
                //is the access log
                var firstSeparatorIndex = checkedLogFile.indexOf(",");
                document.forms[0].logFile_hex.value = checkedLogFile.substring(0, firstSeparatorIndex);
                checkedLogFile = checkedLogFile.substring(firstSeparatorIndex+1);
                logName = "accessLog";
            }
            window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"].value=checkedLogFile;
            
            if(logName == "accessLog"){
                window.parent.dataframe.document.forms[0].elements["commonInfo.logName"].value="<bean:message key="syslog.nfs.td_accessLog"/>";
            }
            
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
    parent.location="enterSyslog.do?operation=enterSyslog&logType=nfsLog";
}
</script>
</head>
<body onload="init();"> 
<form name="nfsTopForm" method="post" >
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
    <input type="button" name="refreshButton" onclick="onRefresh();"
        value="<bean:message key="common.button.reload" bundle="common"/>">
<h2 class="title"><bean:message key="syslog.common.h2_logInfo"/></h2>

<input type="hidden" name="logFile_hex" value="" />
<table border="1" width="77%">
    <tr>
        <th>&nbsp;</th>
        <th><bean:message key="syslog.common.th_viewLog"/></th>
        <th><bean:message key="syslog.common.th_logFile"/></th>
        <th><bean:message key="syslog.common.th_fileSize"/></th>
    </tr>
    <tr>
    <logic:equal name="isAccessExist" value="true">
        <bean:define id="accessFileSize" name="accessFileSize" type="java.lang.String"/>
        <td><input type="radio" name="logFile" id="<%=SyslogActionConst.NFS_ACCESS_LOG_FILE_NAME%>" 
        value="<%=NSActionUtil.ascii2hStr(accessLogFile)+","+NSActionUtil.sanitize(accessLogFile, false)+"#"+accessFileSize%>" 
        onclick="initData_Button();"/></td>
        <td><label for="<%= SyslogActionConst.NFS_ACCESS_LOG_FILE_NAME%>">
        	<logic:equal name="needDisplayTime" value="true">
        		<bean:message key="syslog.nfs.td_accessLog"/> <bean:message key="syslog.nfs.td_performLog_current"/>
        	</logic:equal>
        	<logic:equal name="needDisplayTime" value="false">
        		<bean:message key="syslog.nfs.td_accessLog"/>
        	</logic:equal>
        	</label></td>
        <td><%=NSActionUtil.sanitize(accessLogFile)%></td>
        <logic:equal name="accessFileSizeForDisplay" value="">
        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
        </logic:equal>
        <logic:notEqual name="accessFileSizeForDisplay" value="">
        	<td align="right"><bean:write name="accessFileSizeForDisplay"/></td>
        </logic:notEqual>
    </logic:equal>
    <logic:equal name="isAccessExist" value="false">
         <td><input type="radio" name="nodisplaylogFile" value="" 
                onclick="return false;" disabled /></td>
         <td>
	         <logic:equal name="needDisplayTime" value="true">
	         	<bean:message key="syslog.nfs.td_accessLog"/> <bean:message key="syslog.nfs.td_performLog_current"/>
	         </logic:equal>
	         <logic:equal name="needDisplayTime" value="false">
	         	<bean:message key="syslog.nfs.td_accessLog"/>
	         </logic:equal>
         </td>
         <logic:empty name="accessLogFile">
            <td><bean:message key="syslog.nfs.no_accessLog"/></td>
         </logic:empty>
         <logic:notEmpty name="accessLogFile">
            <td><bean:message key="syslog.common.msg.noLogFile"/></td>
         </logic:notEmpty>    
         <td align="center"><bean:message key="syslog.common.double_hyphen"/></td> 
     </logic:equal>
    </tr>
    <logic:iterate id="accessFile_RotateInfo" name="accessFile_RotateList">
        <bean:define id="fileName" name="accessFile_RotateInfo" property="fileName" type="java.lang.String"/>
        <bean:define id="dateString" name="accessFile_RotateInfo" property="dateString" type="java.lang.String"/>
        <bean:define id="timeString" name="accessFile_RotateInfo" property="timeString" type="java.lang.String"/>
        <bean:define id="fileSizeForDisplay" name="accessFile_RotateInfo" property="fileSizeForDisplay" type="java.lang.String"/>
        <bean:define id="fileSize" name="accessFile_RotateInfo" property="fileSize" type="java.lang.String"/>
        <tr>
        <td><input type="radio" name="logFile" id="<%=SyslogActionConst.NFS_ACCESS_LOG_FILE_NAME+NSActionUtil.sanitize(fileName)%>" 
        value="<%=NSActionUtil.ascii2hStr(fileName)+","+NSActionUtil.sanitize(fileName, false)+"#"+fileSize%>" 
        onclick="initData_Button();"/></td>
        <td><label for="<%= SyslogActionConst.NFS_ACCESS_LOG_FILE_NAME+NSActionUtil.sanitize(fileName)%>">
            <bean:message key="syslog.nfs.td_accessLog"/>
            <bean:message key="syslog.nfs.td_performLog_timeInfo"
              arg0="<%=dateString%>" arg1="<%=timeString.substring(0, timeString.indexOf(":", 4)) + timeString.substring(timeString.indexOf(":", 4) + 3)%>"/>
            </label>
        </td>
        <td><%=NSActionUtil.sanitize(fileName)%></td>
        <logic:equal name="fileSizeForDisplay" value="">
        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
        </logic:equal>
        <logic:notEqual name="fileSizeForDisplay" value="">
        	<td align="right"><bean:write name="fileSizeForDisplay"/></td>
        </logic:notEqual>        
        </tr>
    </logic:iterate>
</table>
</form>
</body>
</html>