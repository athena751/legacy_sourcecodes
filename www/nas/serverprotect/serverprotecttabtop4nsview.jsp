<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotecttabtop4nsview.jsp,v 1.4 2007/03/23 09:43:18 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
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
<h1 class="title"><bean:message key="serverprotect.common.h1"/></h1>
<p class="domain"><bean:message key="serverprotect.common.domain_computer"/>
[<bean:write name="serverprotect_domainName" />/<bean:write name="serverprotect_computerName" />]
</p>
</div>

<nstab:nstab divoptions="style=\"top:78px;\"" >
    <nstab:subtab url="serverProtectList.do">
        <bean:message key="serverprotect.tab.info"/>
    </nstab:subtab>
    <nstab:subtab url="serverProtectFile.do?operation=readVrscanFile">
        <bean:message key="serverprotect.tab.edit"/>
    </nstab:subtab>
</nstab:nstab>
</body>
</html>