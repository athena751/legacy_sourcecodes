<!--
        Copyright (c) 2008-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: csarheartbeat.jsp,v 1.3 2009/02/11 03:00:00 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<bean:define id="startTime" name="csar_startTime" type="java.lang.String"/>
<%
    String frameNo = request.getParameter("frameNo");
%>
<%if(frameNo.equals("0")){%>
<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<title><bean:message key="csar.heartbeat.title"/></title>
</head>
<frameset rows=100,0 >
    <frame marginwidth=10 marginheight=20 name="mainFrame" frameborder="no" scrolling="auto" src="loadHeartbeat_display.do">
    <frame marginwidth=0 marginheight=0 name="hideFrame" frameborder="no" scrolling="no" src="loadHeartbeat_hidden.do">
</frameset>
</html>
<%}else if(frameNo.equals("1")){%>
<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="javascript">
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
<h1 class="title"><bean:message key="csar.title.h1"/></h1>
<h2 class="title"><bean:message key="csar.heartbeat.h2.collect"/></h2>
<h3 class="title"><bean:message key="csar.heartbeat.msg.startTime"/>
<input type="text" name="oTime" size="14" style='border:0' readonly>
</h3>
<h3 class="title"><bean:message key="csar.heartbeat.msg.spendTime"/>
<input type="text" name="sTime" value="     0" size="7" style='border:0' readonly>
<bean:message key="csar.heartbeat.msg.timeUnit_sencond"/></h3>
<b><bean:message key="csar.heartbeat.msg.usedTimeInfo"/></b>
</form>
</body>
</html>
<%}else if(frameNo.equals("2")){%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Refresh" CONTENT="2">
<script language="javascript">
function pageLoad(){
    <logic:equal name="csar_collect_finish" value="finished"> 
        <%com.nec.nsgui.action.base.NSActionUtil.setSessionAttribute(request,"csar_collect_finish",null);%>
        top.opener.unsetSubmitted();       
        top.close();
    </logic:equal>    
    return true;
}
</script>
</head>
<body onload="pageLoad();">
</body>
</html>
<%}%>