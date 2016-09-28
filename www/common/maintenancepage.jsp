<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: maintenancepage.jsp,v 1.2 2004/08/31 01:07:42 baiwq Exp $" -->

<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page session="true" %>
<%@ page isErrorPage="true" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%
session.setAttribute(NSActionConst.SESSION_EXCEPTION_MESSAGE, null);
%>
<html>
<head>
<%@include file="head.jsp" %>
</head>
<body >
<form>
<h1 class="Warning"><bean:message bundle="errorDisplay" key="error.h1.maintain_h1"/></h1>
<h2 class="Warning"><bean:message bundle="errorDisplay" key="errorMsg.cluster.maintenance"/></h2>
</form>
</body>
</html>