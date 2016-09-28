<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreateshow.jsp,v 1.4 2007/07/13 08:14:55 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%
String contextPath = request.getContextPath();
String topFrameHeight = "260";
if (NSActionUtil.isProcyon(request)) {
   if (NSActionUtil.isNashead(request)) {
        topFrameHeight = "380";
   }
}
%>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<frameset rows="*,60">
    <frameset rows="<%=topFrameHeight%>,*">
        <frame src="<%=contextPath%>/volume/volumeBatchCreateShowForwardTop.do">
        <frame src="<%=contextPath%>/volume/volumeBatchCreateShowForwardMiddle.do">
    </frameset>
    <frame src="<%=contextPath%>/volume/volumeBatchCreateShowForwardBottom.do">
</frameset>
</html:html>