<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: syslogmaintain.jsp,v 1.1 2004/11/22 07:47:47 baiwq Exp $" -->

<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<body>
<form>
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
<bean:message key="syslog.common.msg.cannotReferLog_ForMaintain"/>
</form>
</body>
</html>