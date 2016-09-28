<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: quotastatus.jsp,v 1.1 2005/08/29 09:45:58 zhangj Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>

<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.beans.quota.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="quotaBean" scope="page" class="com.nec.sydney.beans.quota.GetQuotaStatusBean"/>

<%AbstractJSPBean _abstractJSPBean = quotaBean; %>

<%@ include file="../../../menu/common/includeheader.jsp" %>

<%String actionQuota = quotaBean.getQuotaStatus();%>

<html>
<head>
    <link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
    <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
</head>

<body>

<h2 class="title"><nsgui:message key="nas_quota/quotasettop/href_status"/></h2>

<table><tr><td>
    <% if (actionQuota.equals(NasConstants.REPQUOTA_STATUS_ON))  { %>
        <nsgui:message key="nas_quota/status/start"/>
    <%}%>
    <% if (actionQuota.equals(NasConstants.REPQUOTA_STATUS_OFF)) { %>
        <nsgui:message key="nas_quota/status/stop"/>
    <%}%>
</td></tr></table>

</body>
</html>
