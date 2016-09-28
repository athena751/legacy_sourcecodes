<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: heartbeattime.jsp,v 1.5 2008/05/18 06:15:46 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
<bean:parameter id="startTime" name="startTime"/>
function pageLoad(){
    var old = new Date();
    old.setTime(<%=startTime%>);
    var oldtime = old.getHours() + " : " + old.getMinutes() + " : " + old.getSeconds();
    document.forms[0].oTime.value = " " + oldtime + " ";
    window.setInterval("fnRecycle()",1000);
    return true;
}

function formatSpendTime(i_sTime) {
    while((i_sTime + " ").length < 7) {
        i_sTime = " " + i_sTime;
    }
    return i_sTime;
}

function fnRecycle(){
    var now = new Date();
    var spendtime = parseInt((now.getTime() - <%=startTime%>) / 1000);
    document.forms[0].sTime.value = formatSpendTime(spendtime);
}
</script>
</head>
<body onload="pageLoad();">
<form>

<h1 class="title">
    <bean:message key="csvdownload.msg_downloading"/>
</h1>
<p>
<bean:message key="csvdownload.th_host"/>:
<bean:write name="host" filter="false" scope="request"/>
<logic:equal name="needexpgrp" value="yes">
	<br><bean:message key="csvdownload.th_expgroup"/>:
	<bean:write name="expgrp" filter="false" scope="request"/>
	<br><bean:message key="csvdownload.th_domain_computer"/>:
	<bean:write name="domainName" scope="request"/>/<bean:write name="cpName" scope="request"/>
</logic:equal>
<bean:parameter id="watchItemDescKey" name="watchItemDescKey" />
<br><bean:message key="csvdownload.th_infotype"/>:
<bean:message key="<%=watchItemDescKey%>" />
<h3 class="title"><bean:message key="csvdownload.heartbeat.msg_start"/>:
<input type="text" name="oTime" size="14" style='border:0' readonly>
</h3>
<h3 class="title"><bean:message key="csvdownload.heartbeat.msg_spend"/>:
<input type="text" name="sTime" value="     0" size="7" style='border:0' readonly>
<bean:message key="csvdownload.heartbeat.msg_second"/></h3>
<b><bean:message key="csvdownload.heartbeat.msg_wait"/></b>
</form>

</body>
</html>