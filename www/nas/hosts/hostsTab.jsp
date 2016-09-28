<!--
    Copyright (c) 2006-2007 NEC Corporation

    NEC SOURCE CODE PROPRIETARY

    Use, duplication and disclosure subject to a source code
    license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: hostsTab.jsp,v 1.2 2007/05/09 05:31:05 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<html:html lang="true">
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<body>
<div>
<h1 class="title"><bean:message key="hosts.title.h1"/></h1>
</div>
<nstab:nstab>
    <nstab:subtab url="hostsInfoAction.do?Operation=getHostsInformation"><bean:message key="hosts.tab.setInfo"/></nstab:subtab>
    <%
    if(!NSActionUtil.isNsview(request)){
    %>
    <nstab:subtab url="hostsFile.do"><bean:message key="hosts.tab.hostsFile"/></nstab:subtab>
    <%
    }
    %>
</nstab:nstab>
</body>
</html:html>
