<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraypdlisttop.jsp,v 1.2301 2005/09/21 04:53:50 wangli Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body> 
<%String diskid=request.getParameter("id");%>
<form>
<h1 class="title"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
    <input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onclick='parent.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid=<%=diskid%>&diskname=<%=request.getParameter("diskname")%>";' >
    <input type=button  value="<nsgui:message key="common/button/reload"/>"  onclick='parent.middleframe.location="<%=response.encodeURL("diskarrayrefresh.jsp")%>?diskArrayID=<%=diskid%>&diskname=<%=request.getParameter("diskname")%>"' >
<h2 class="title"><nsgui:message key="fcsan_componentdisp/pd/h2"/></h2>
</form>
</body>
</html>