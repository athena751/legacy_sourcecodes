<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rebuildingstartinstruction.jsp,v 1.2300 2003/11/24 00:55:04 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="java.lang.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<head>
<title><nsgui:message key="fcsan_componentconf/rebuildingstart/title_rsi"/></title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
</head>
<%String diskarrayname = request.getParameter("diskarrayname");
  String pdgroupnumber = request.getParameter("pdgroupnumber");
  String diskarrayid = request.getParameter("diskarrayid");
%>
<frameset rows="25%,*" > 
    <frame name="topframe" src="<%= response.encodeURL("starttop.jsp")%>?diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&diskarrayid=<%=diskarrayid%>">
    <frame name="bottomframe" src="../common/blank.htm">
</frameset>
</html>

