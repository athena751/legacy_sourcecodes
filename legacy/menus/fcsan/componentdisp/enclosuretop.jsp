<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: enclosuretop.jsp,v 1.2301 2005/09/21 04:53:50 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%String diskArrayID = request.getParameter("diskArrayID");
  String diskname = request.getParameter("diskname");
%>
<HTML>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="JavaScript">
function onBack()
{  parent.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid=<%=diskArrayID %>&diskname=<%=diskname%>"; 
}
function onRefresh()
{   parent.middleframe.location="<%=response.encodeURL("enclosurelistrefresh.jsp")%>?diskArrayID=<%=diskArrayID%>&diskname=<%=diskname%>"
}
</script>
</head>
	
<body>

  <form>
<h1 class="title"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">  
<input type="button" name="Button" value="<nsgui:message key="common/button/reload"/>" onClick="onRefresh()">
<h2 class="title"><nsgui:message key="fcsan_componentdisp/enclosure/h2"/></h2>
</form>
</body>
</html>

