<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportRoot4nsview.jsp,v 1.1 2005/08/22 05:39:17 wangzf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" 
    import="com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
</head>
<%
String target=request.getParameter("target");
target = (target==null)? "" : "?target="+target;
%>

    <Frameset rows="*,60">
    <frame name="topframe" src="exportRootTop4nsview.jsp<%=target%>">
    <frame name="bottomframe" src="exportRootBottom4nsview.jsp">
    </Frameset>
</html>