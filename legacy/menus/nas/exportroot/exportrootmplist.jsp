<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportrootmplist.jsp,v 1.2305 2005/08/22 05:38:53 wangzf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" 
    import="com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
</head>
<%
String exportGroup=request.getParameter("exportgroup");
String codePage = request.getParameter("codepage");
%>

  <Frameset rows="*,60">
    <frame name="topframe" src="exportrootmplisttop.jsp?exportgroup=<%=exportGroup%>&codepage=<%=codePage%>">
    <frame name="bottomframe" src="exportrootmplistbottom.jsp">
  </Frameset>
</html>