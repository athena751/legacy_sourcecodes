<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: snmptop.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="taglib-nstab"   prefix="nstab"%>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
<head>
	<%@include file="../../common/head.jsp" %>
	<link href="../skin/default/tab.css" type="text/css" rel="stylesheet">
	<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
</head>

<body>
<div class="h1">
    <h1 class="title">
        <bean:message key="snmp.common.h1"/>
    </h1>
</div>

<nstab:nstab>
    <nstab:subtab url="snmpInfoList.do?operation=displayList">
        <bean:message key="snmp.title.information"/>
    </nstab:subtab>
    <nstab:subtab url="systemSetFrame.do">
        <bean:message key="snmp.title.system"/>
    </nstab:subtab>
    <nstab:subtab url="communityListFrame.do">
        <bean:message key="snmp.title.comunity"/>
    </nstab:subtab>
    <nstab:subtab url="userListFrame.do">
        <bean:message key="snmp.title.user"/>
    </nstab:subtab>
</nstab:nstab>

</body>
</html>