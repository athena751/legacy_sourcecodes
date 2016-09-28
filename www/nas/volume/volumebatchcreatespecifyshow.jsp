<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreatespecifyshow.jsp,v 1.2 2007/05/09 05:17:07 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<%
String contextPath = request.getContextPath();
%>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<frameset rows="*,60">
    <frame src="<%=contextPath%>/volume/volumeBatchCreateSpecifyShowForwardTop.do">
    <frame src="<%=contextPath%>/volume/volumeBatchCreateSpecifyShowForwardBottom.do">
</frameset>
</html:html>