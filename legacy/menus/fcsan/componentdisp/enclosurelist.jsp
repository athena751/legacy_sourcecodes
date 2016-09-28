<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: enclosurelist.jsp,v 1.2301 2005/09/21 04:53:50 wangli Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<html>
<%String diskArrayID= request.getParameter("diskArrayID");
String diskname = request.getParameter("diskname");%>
  <frameset rows="140,*" > 
    <frame name="topframe" scrolling="auto" src="<%=response.encodeURL("enclosuretop.jsp")%>?diskArrayID=<%=diskArrayID%>&diskname=<%=diskname%>" >
    <frame name="middleframe" src="<%=response.encodeURL("enclosuremiddle.jsp")%>?diskArrayID=<%=diskArrayID%>">
  </frameset>
<noframes></noframes>
</html>