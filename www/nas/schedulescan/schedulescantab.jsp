<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: schedulescantab.jsp,v 1.1 2008/05/08 08:54:48 chenbc Exp $" -->
<%@ page language="java" contentType="text/html; charset=UTF-8" buffer="32kb" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
</head>
<body>
<div class="h1">
<h1 class="title"><bean:message key="schedulescan.common.h1"/></h1>
</div>

<nstab:nstab>
    <nstab:subtab url="scheduleScanList.do">
        <bean:message key="schedulescan.tab.info"/>
    </nstab:subtab>
    <nstab:subtab url="scheduleScanComputerSet.do">
        <bean:message key="schedulescan.tab.computer"/>
    </nstab:subtab>
    <nstab:subtab url="scheduleScanGlobalSet.do">
        <bean:message key="schedulescan.tab.scanserver"/>
    </nstab:subtab>
    <nstab:subtab url="scheduleScanShareSet.do">
        <bean:message key="schedulescan.tab.shareset"/>
    </nstab:subtab>
</nstab:nstab>
</body>
</html>