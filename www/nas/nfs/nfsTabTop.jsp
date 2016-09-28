<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfsTabTop.jsp,v 1.2 2005/11/21 02:39:59 liul Exp $" -->

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
<div class="h1"><h1 class="title"><bean:message key="title.nfs"/></h1></div>
<nstab:nstab>
  <nstab:subtab url="nfsList.do">
     <bean:message key="tab.first.export"/>
  </nstab:subtab>
  <nstab:subtab url="directEdit.do">
     <bean:message key="tab.second.exportsfile"/>
  </nstab:subtab>
  <nstab:subtab url="nfsLogEntry.do">
     <bean:message key="tab.third.log"/>
  </nstab:subtab>
  <nstab:subtab url="addedOptions.do">
     <bean:message key="tab.fourth.options"/>
  </nstab:subtab>
</nstab:nstab>
</body>
</html>