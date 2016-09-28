<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ftplogtop.jsp,v 1.7 2008/05/09 05:07:05 hetao Exp $" -->

<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>

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
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
var hasLoaded = 0; 
var sizeForHeartbeat;
function init(){
    hasLoaded = 1;
    document.forms[0].elements["commonInfo.logName"].value="<bean:message key="<%=h1_Key%>"/>";
    if(window.parent.bottomframe.document.forms[0]){
        window.parent.bottomframe.changeButtonStatus();
    }
}

function checkInputs(){
    //this function is called by the "bottomframe"
    if(document.forms[0].elements["commonInfo.searchWords"].value==""){
        alert("<bean:message key="syslog.common.alert.needInputSearchPattern"/>");
        document.forms[0].elements["commonInfo.searchWords"].focus();
        return false;
    }
    return true;
}
function onRefresh(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="enterSyslog.do?operation=enterSyslog&logType=ftpLog";
}
</script>
</head>
<body onload="init();">

<html:form action="syslog.do?operation=beginSearch" method="post" >
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
    <html:button property="refreshBtn" onclick="onRefresh();">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
<h2 class="title"><bean:message key="syslog.common.h2_logInfo"/></h2>

<bean:define id="ftpLogFiles" name="ftpLogFiles" type="java.lang.String[]"/>
<%if(ftpLogFiles.length>0){%>
    <table border="1" width="68%">
        <tr>
            <th width="50%"><bean:message key="syslog.common.th_logFile"/></th>
            <th><bean:message key="syslog.common.th_fileSize"/></th>
        </tr>
        <tr>
            <td><%=ftpLogFiles[0]%></td>
            <logic:equal name="fileSizeForDisplay" value="">
	        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
	        </logic:equal>
	        <logic:notEqual name="fileSizeForDisplay" value="">
	        	<td align="right"><bean:write name="fileSizeForDisplay"/></td>
	        </logic:notEqual>
        </tr>
    </table>
    <input type="hidden" name="commonInfo.logFile" value="<%=ftpLogFiles[0]%>">
    <script language="JavaScript">
    	sizeForHeartbeat = '<bean:write name="fileSize"/>';	
    </script>
<%}else{%>
    <bean:message key="syslog.common.msg.noLogToDisplay"/>
    <input type="hidden" name="commonInfo.logFile" value="">
<%}%>
    
<h2 class="title"><bean:message key="syslog.common.h2_viewSet"/></h2>
<nested:nest property="commonInfo">
<nested:hidden property="logType"/>
<nested:hidden property="searchAction"/>
<nested:hidden property="logName"/>
<table border="1" class="Vertical" width="68%">
<tr>
    <th width="40%"><bean:message key="syslog.common.th_viewLines"/></th>
    <td colspan="2">
        <nested:select property="viewLines">
            <html:optionsCollection name="maxLinesSet" />
        </nested:select>
    </td>
</tr>
<tr>
    <th><bean:message key="syslog.common.th_viewOrder"/></th>
    <td>
      <nested:radio property="viewOrder" styleId="view_form_new" value="new"/>
      <label for="view_form_new"><bean:message key="syslog.common.td_newOrder"/></label>
        &nbsp;&nbsp;&nbsp;
      <nested:radio property="viewOrder" styleId="view_form_old" value="old"/>
      <label for="view_form_old"><bean:message key="syslog.common.td_oldOrder"/></label>
    </td>
</tr>
<tr>
    <th><bean:message key="syslog.common.th_viewEncoding"/></th>
    <td colspan="2">
        <nested:select property="displayEncoding">
            <html:optionsCollection name="displayEncodingSet" />
        </nested:select>
    </td>
    
</tr>
</table>
<h2 class="title"><bean:message key="syslog.common.h2_searchOptionSet"/></h2>
<h3 class="title"><bean:message key="syslog.common.h3_searchOption"/></h3>
  <table border="1" class="Vertical" width="68%">
  <tr>
    <td width="40%"><bean:message key="syslog.common.th_searchWords"/></td>
    <td>
        <nested:text property="searchWords" size="53" maxlength="128"/>
    </td>
  </tr>
  <tr>
    <td colspan="2">
        <nested:radio property="containWords" styleId="containWords" value="yes"/>
        <label for="containWords"><bean:message key="syslog.common.radio_containWords"/></label>&nbsp;
        <nested:radio property="containWords" styleId="containNoWords" value="no"/>
        <label for="containNoWords"><bean:message key="syslog.common.radio_containNoWords"/></label>
    </td>
  </tr>
  <tr>
    <td colspan="2">
        <nested:checkbox property="caseSensitive" styleId="caseSensitive" value="yes"/>
        <label for="caseSensitive"><bean:message key="syslog.common.checkbox_caseSensitive"/></label>
    </td>
  </tr>
  <tr>
    <td><bean:message key="syslog.common.th_aroundLines"/></td>
    <td>
        <nested:text property="aroundLines" size="53" maxlength="2"/>
    </td>
  </tr>
 </table>
</nested:nest>
</html:form>
<form name="directDownloadForm" action="syslog.do?operation=directDownload" method="post">
    <input type="hidden" name="isPerformance4directDown" value=""/>
    <input type="hidden" name="logFile4directDown" value=""/>
    <input type="hidden" name="displayEncoding4directDown" value=""/>
    <input type="hidden" name="logType4directDown" value=""/>
    <input type="hidden" name="cifsSearchEncoding" value=""/>
</form>
</body>
</html>