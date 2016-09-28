<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: navigatorframe.jsp,v 1.1 2005/08/21 04:49:28 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html>
<head>
<title>
    <bean:message key="snmp.community.th_source" />
</title>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
</head>
<frameset rows="77%,*">
    <frame name="topframe" src="navigatorList.do">
    <frame name="bottomframe" src="navigatorBottom.do">
</frameset>

<body  onload="setHelpAnchor('system_snmp_6');" onUnload="top.opener.setHelp();"></body>

</html>