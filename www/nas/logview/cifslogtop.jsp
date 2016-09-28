<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifslogtop.jsp,v 1.14 2008/05/19 09:48:46 hetao Exp $" -->


<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
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
    if(document.forms[0].computerInfo){
        if(document.forms[0].computerInfo.length){
            document.forms[0].computerInfo[0].checked=true;
        }else{
            document.forms[0].computerInfo.checked=true;
        }
        initData_Button();
    }
}

function initData_Button(){
    //this function is called by the "dataframe"
    if(document.forms[0].computerInfo){
        if((window.parent.dataframe.document.forms[0])
           && (window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"])){
            var radioValue = getCheckedRadioValue(document.forms[0].computerInfo);
            var lastIndex = radioValue.lastIndexOf("#");
            sizeForHeartbeat = radioValue.substring(lastIndex+1);
            radioValue = radioValue.substring(0,lastIndex);
            var firstSeparatorIndex = radioValue.indexOf(",");
            var secondSeparatorIndex = radioValue.indexOf(",", firstSeparatorIndex+1);
            var thirdSeparatorIndex = radioValue.indexOf(",", secondSeparatorIndex+1);
            var computerName = radioValue.substring(0, firstSeparatorIndex);
            var the_encoding = radioValue.substring(firstSeparatorIndex+1, secondSeparatorIndex);
            var logFile_hex  = radioValue.substring(secondSeparatorIndex+1, thirdSeparatorIndex);
            var logFileName  = radioValue.substring(thirdSeparatorIndex+1);
            
            document.forms[0].logFile_hex.value=logFile_hex;
            window.parent.dataframe.document.forms[0].elements["commonInfo.logName"].value="<bean:message key="syslog.cifs.td_accessLog"/>"+"("+computerName+")";
            window.parent.dataframe.document.forms[0].elements["cifsSearchInfo.encoding"].value=the_encoding;
            window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"].value=logFileName;
            selectEncoding(the_encoding);
            
            if(window.parent.bottomframe.document.forms[0]){
                window.parent.bottomframe.changeButtonStatus();
            }
        }
    }
}

function selectEncoding(encoding){
    if(encoding == ""){
        encoding = "<%=NSActionConst.ENCODING_EUC_JP%>";
    }
    window.parent.dataframe.document.forms[0].elements["commonInfo.displayEncoding"].value=encoding;
}
function onRefresh(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="enterSyslog.do?operation=enterSyslog&logType=cifsLog";
}
</script>
</head>
<body onload="init();">
<form name="cifsTopForm" method="post" >
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
    <input type="button" name="refreshButton" onclick="onRefresh();"
        value="<bean:message key="common.button.reload" bundle="common"/>">
<h2 class="title"><bean:message key="syslog.common.h2_logInfo"/></h2>

<logic:notEmpty name="displayInvalidList" scope="request">
    <h3 class="title"><bean:message key="syslog.common.h3.availableLogList"/></h3>
</logic:notEmpty>

<logic:notEmpty name="displayValidList" scope="request">
<input type="hidden" name="logFile_hex" value="" />
    <table border="1" width="68%">
        <tr>
            <th>&nbsp;</th>
            <th><bean:message key="syslog.common.th_viewLog"/></th>
            <th><bean:message key="syslog.common.th_logFile"/></th>
            <th><bean:message key="syslog.common.th_fileSize"/></th>
        </tr>
        <logic:iterate id="computerInfo" name="displayValidList">
            <bean:define id="computerName" name="computerInfo" property="computerName"/>
            <logic:equal name="computerInfo" property="fileExist" value="true">
                <bean:define id="logFile" name="computerInfo" property="accessLogFile" type="java.lang.String"/>
                <bean:define id="encoding" name="computerInfo" property="encoding"/>
                <bean:define id="needDisplayTime" name="computerInfo" property="needDisplayTime"/>
                <bean:define id="fileSizeForDisplay" name="computerInfo" property="fileSizeForDisplay"/>
                <bean:define id="fileSize" name="computerInfo" property="fileSize"/>
                <tr>
                    <td><input type="radio" name="computerInfo" id="<%=computerName%>"
                        value="<%=computerName+","+encoding+","+NSActionUtil.ascii2hStr(logFile)+","+logFile+"#"+fileSize%>" onclick="initData_Button();"></td>
                    <td><label for="<%=computerName%>">
                    <logic:equal name="needDisplayTime" value="true">
                    	<bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>) <bean:message key="syslog.nfs.td_performLog_current"/>
                    </logic:equal>
                    <logic:equal name="needDisplayTime" value="false">
                    	<bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>)
                    </logic:equal>
                    </label></td>
                    <td><%=NSActionUtil.sanitize(logFile)%></td>
                    <logic:equal name="fileSizeForDisplay" value="">
			        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
			        </logic:equal>
			        <logic:notEqual name="fileSizeForDisplay" value="">
			        	<td align="right"><bean:write name="fileSizeForDisplay"/></td>
			        </logic:notEqual>
                <tr>
                <logic:iterate id="rotateInfo" name="computerInfo" property="rotateLogFiles">
			        <bean:define id="fileName" name="rotateInfo" property="fileName" type="java.lang.String"/>
			        <bean:define id="dateString" name="rotateInfo" property="dateString" type="java.lang.String"/>
			        <bean:define id="timeString" name="rotateInfo" property="timeString" type="java.lang.String"/>
			        <bean:define id="fileSizeForDisplay" name="rotateInfo" property="fileSizeForDisplay"/>
			        <bean:define id="fileSize" name="rotateInfo" property="fileSize"/>
			        <tr>
			        <td><input type="radio" name="computerInfo" id="<%=NSActionUtil.sanitize(fileName)%>" 
			        	value="<%=computerName+","+encoding+","+NSActionUtil.ascii2hStr(fileName)+","+fileName+"#"+fileSize%>" onclick="initData_Button();"/></td>
			        <td><label for="<%=NSActionUtil.sanitize(fileName)%>">
			            <bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>)
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
            </logic:equal>
            <logic:equal name="computerInfo" property="fileExist" value="false">
                <bean:define id="encoding" name="computerInfo" property="encoding"/>
            	<bean:define id="needDisplayTime" name="computerInfo" property="needDisplayTime"/>
                <tr>
                    <td><input type="radio" name="noUserfulInfo" value="" onclick="return false;" disabled ></td>
                    <td>
                    <logic:equal name="needDisplayTime" value="true">
                    	<bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>) <bean:message key="syslog.nfs.td_performLog_current"/>
                    </logic:equal>
                    <logic:equal name="needDisplayTime" value="false">
                    	<bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>)
                    </logic:equal>
                    </td>
                    <td><bean:message key="syslog.common.msg.noLogFile"/></td>
                    <td align="center"><bean:message key="syslog.common.double_hyphen"/></td>
                <tr>
                <logic:iterate id="rotateInfo" name="computerInfo" property="rotateLogFiles">
			        <bean:define id="fileName" name="rotateInfo" property="fileName" type="java.lang.String"/>
			        <bean:define id="dateString" name="rotateInfo" property="dateString" type="java.lang.String"/>
			        <bean:define id="timeString" name="rotateInfo" property="timeString" type="java.lang.String"/>
			        <bean:define id="fileSizeForDisplay" name="rotateInfo" property="fileSizeForDisplay"/>
			        <bean:define id="fileSize" name="rotateInfo" property="fileSize"/>
			        <tr>
			        <td><input type="radio" name="computerInfo" id="<%=NSActionUtil.sanitize(fileName)%>" 
			        	value="<%=computerName+","+encoding+","+NSActionUtil.ascii2hStr(fileName)+","+fileName+"#"+fileSize%>" onclick="initData_Button();"/></td>
			        <td><label for="<%=NSActionUtil.sanitize(fileName)%>">
			            <bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>)
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
            </logic:equal>
            
        </logic:iterate>
    </table>
</logic:notEmpty>
<logic:empty name="displayValidList" scope="request">
    <bean:message key="syslog.common.msg.noLogToDisplay"/>
</logic:empty>
<logic:notEmpty name="displayInvalidList" scope="request">
    <h3 class="title"><bean:message key="syslog.common.h3.unavailableLogList"/></h3>
    <ul>
        <li><bean:message key="syslog.common.msg.cannotReferLog_ForMaintain2"/>
    </ul> 
    <table border="1" width="68%">
        <tr>
            <th><bean:message key="syslog.common.th_viewLog"/></th>
            <th><bean:message key="syslog.common.th_logFile"/></th>
            <th><bean:message key="syslog.common.th_fileSize"/></th>
        </tr>
        <logic:iterate id="computerInfo" name="displayInvalidList">
            <bean:define id="computerName" name="computerInfo" property="computerName"/>
            <bean:define id="logFile" name="computerInfo" property="accessLogFile" type="java.lang.String"/>
            <bean:define id="fileSizeForDisplay" name="computerInfo" property="fileSizeForDisplay"/>
            <tr>
                <td><bean:message key="syslog.cifs.td_accessLog"/>(<%=computerName%>)</td>
                <td><%=NSActionUtil.sanitize(logFile)%></td>
                <logic:equal name="fileSizeForDisplay" value="">
		        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
		        </logic:equal>
		        <logic:notEqual name="fileSizeForDisplay" value="">
		        	<td align="right"><bean:write name="fileSizeForDisplay"/></td>
		        </logic:notEqual>
		     </tr>
        </logic:iterate>
    </table>
</logic:notEmpty>
</form>
</body>
</html>