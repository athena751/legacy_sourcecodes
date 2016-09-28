<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: syslogmaintain_2.jsp,v 1.2 2004/11/23 02:26:28 baiwq Exp $" -->

<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<body>
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>

</body>
<form>
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
<bean:message key="syslog.common.msg.cannotReferLog_ForMaintain"/>
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
	<input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()"/>
</form>
</html>