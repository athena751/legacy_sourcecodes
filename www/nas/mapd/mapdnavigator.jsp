<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: mapdnavigator.jsp,v 1.2 2007/05/09 06:45:16 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<%
String contextPath = request.getContextPath();
%>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="navigator.title"/></title>
</head>
<frameset rows="80%,*">
<frame src="<%=contextPath%>/mapd/MapdNavigatorForwardList.do">
<frame src="<%=contextPath%>/mapd/MapdNavigatorForwardSubmit.do">
</frameset>
</html:html>