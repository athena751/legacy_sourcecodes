<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: samplingnstab4nsview.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="taglib-nstab"   prefix="nstab"%>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
    <SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
</head>
<body>
    <div class="h1">
        <h1 class="title"><bean:message key="statis.sampling.h1"/></h1>
    </div>
    <nstab:nstab displayonload="0">
        <nstab:subtab url="sampling4nsview.do?operation=init">
            <bean:message key="statis.sampling.nstab_1"/>
        </nstab:subtab>
        <nstab:subtab url="survey4nsview.do?operation=init">
            <bean:message key="statis.sampling.nstab_2"/>
        </nstab:subtab>
    </nstab:nstab>
</body>
</html>







