<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemextendframe.jsp,v 1.5 2007/07/13 08:14:28 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%
    String topFrameHeight = "270";
    if (NSActionUtil.isProcyon(request)) {
        topFrameHeight = "330";
    }
%>
<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
</head> 
<Frameset rows="<%=topFrameHeight%>,*,60">
    <frame name="topFrame"    src="<%=request.getContextPath()%>/filesystem/extendFSTop.do">
    <frame name="middleFrame" src="<%=request.getContextPath()%>/filesystem/extendFSMiddle.do">
    <frame name="bottomFrame" scrolling="no" src="<%=request.getContextPath()%>/common/commonblank.html">
</Frameset>
</html:html>