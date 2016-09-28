<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: heartbeatframe.jsp,v 1.3 2008/05/18 06:15:37 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="csvdownload.heartbeat.title_wait"/></title>
</head>
<bean:parameter id="downloadWinKey" name="downloadWinKey" />
<bean:parameter id="startTime" name="startTime" />
<bean:parameter id="watchItemDescKey" name="watchItemDescKey" />

<frameset rows=100,0 >
    <frame marginwidth=10 marginheight=20 name="mainFrame" frameborder="no" scrolling="auto" src="download.do?operation=displaytime&startTime=<%=startTime%>&downloadWinKey=<%=downloadWinKey%>&watchItemDescKey=<%=watchItemDescKey%>" >
    <frame marginwidth=0 marginheight=0 name="hideFrame" frameborder="no" scrolling="no" src="heartbeatfinish.do?downloadWinKey=<%=downloadWinKey%>">
</frameset>
</html>
