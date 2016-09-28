<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communicateerrorpage.jsp,v 1.2 2008/05/09 01:24:40 zhangjun Exp $" -->

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
<h2 class="Warning"><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror"/></h2>

<h3 class="Warning"><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.h3.reason"/></h3>
<table><tr><td>
	<li><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.reasonlist1"/>
	<li><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.reasonlist2"/>
	<li><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.reasonlist3"/>
</td></tr></table>

<h3 class="Warning"><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.h3.operation"/></h3>
<table><tr><td>
	<li><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.operationlist1"/>
	<li><bean:message bundle="errorDisplay" key="errorMsg.cluster.communicateerror.operationlist2"/>
</td></tr></table>

</form>
</body>
</html>