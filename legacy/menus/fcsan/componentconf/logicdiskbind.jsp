<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logicdiskbind.jsp,v 1.2301 2005/12/16 06:45:01 wangli Exp $" -->

<html>
<head>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<title><nsgui:message key="fcsan_componentconf/logicdiskbind/ldbind_title" /></title>
</head>
<frameset rows="*,150" > 
  <frameset rows="150,*" > 
    <frame name="topframe" src="<%=response.encodeURL("logicdiskbindtop.jsp")%>?pdnum=<%=request.getParameter("pdnum")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>" >
<frame name="mainframe" src="<%=response.encodeURL("logicdiskbindmiddle.jsp")%>?pdnum=<%=request.getParameter("pdnum")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>">
  </frameset>
  <frame name="bottomframe"  src="../common/blank.htm">
</frameset>
</html>