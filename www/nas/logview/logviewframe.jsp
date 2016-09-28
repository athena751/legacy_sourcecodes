<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logviewframe.jsp,v 1.1 2004/11/22 07:47:47 baiwq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<%@include file="../../common/head.jsp" %>
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<title><bean:message key="<%=h1_Key%>"/></title>
<Frameset rows="100%,0,0" border="0" framespacing="0">
    <frame name="logviewframe" src="logview.do?operation=display">
    <frame name="autoconnectframe" src="logview.do?operation=autoConnectServer" frameborder="0" scrolling="no" noresize nofocus>
    <frame name="downloadframe" src="download.do?operation=download" frameborder="0" scrolling="no" noresize nofocus>
</Frameset>


</html>