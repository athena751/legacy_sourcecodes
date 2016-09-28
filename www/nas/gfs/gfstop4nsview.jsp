<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: gfstop4nsview.jsp,v 1.1 2005/11/04 01:23:48 zhangj Exp $" -->

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
        <bean:message key="gfs.common.h1"/>
    </h1>
</div>

<nstab:nstab>
    <nstab:subtab url="gfsView4Nsview.do?operation=display">
        <bean:message key="gfs.title.gfsview"/>
    </nstab:subtab>
</nstab:nstab>

</body>
</html>
