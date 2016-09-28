<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: NoLicense.jsp,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $" -->
<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page session="true" %>
<%@ page import="com.nec.sydney.framework.*" %>

<%@ page contentType="text/html;charset=EUC-JP"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<%
	String	pp  = (String)request.getParameter("licenseKey")+"/info";
	String	info = NSMessageDriver.getInstance().getMessage(pp);
	String	h1 = (String)request.getParameter("h1");
%>
<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<head>
<title>
</title>
<head>
</head>
<body>
<h1><%= new String(h1.getBytes("ISO8859_1"), "EUC_JP") %></h1>
<nsgui:message key="framework/nolicense"/>
<ul>
<li><%= info %>
</ul>
</body>
</html>
