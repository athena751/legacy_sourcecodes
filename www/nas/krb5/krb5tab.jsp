<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: krb5tab.jsp,v 1.1 2006/11/06 05:59:36 liy Exp $" -->
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
<div class="h1"><h1 class="title"><bean:message key="krb5.h1"/></h1></div>
<nstab:nstab>
  <nstab:subtab url="krb5File.do"><bean:message key="krb5.tab"/></nstab:subtab>
</nstab:nstab>
</body>
</html>