<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: vcnavigator.jsp,v 1.3 2007/05/09 08:19:36 xingyh Exp $" -->

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
<title><bean:message key="navigator.title" bundle="volume/filesystem"/></title>
</head>
<frameset rows="80%,*">
<frame src="<%=contextPath%>/filesystem/VCNavigatorForwardList.do">
<frame src="<%=contextPath%>/filesystem/VCNavigatorForwardSubmit.do">
</frameset>
</html:html>