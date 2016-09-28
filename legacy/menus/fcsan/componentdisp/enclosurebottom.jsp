<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: enclosurebottom.jsp,v 1.2300 2003/11/24 00:55:05 nsadmin Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%  String diskArrayID = request.getParameter("diskArrayID");
    String diskname = request.getParameter("diskname");
%>
<HTML>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="JavaScript">
function onBack()
{  parent.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid=<%=diskArrayID %>&diskname=<%=diskname%>"; 
}
</script>
</head>

<body>
<form>
  <input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
     
  </form>
  </body>
</html>

