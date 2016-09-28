<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldconstitutetop.jsp,v 1.2302 2005/09/21 04:53:50 wangli Exp $" -->
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*,java.util.*,com.nec.sydney.beans.fcsan.common.*" %>
<%@ page contentType="text/html;charset=EUC-JP"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 


<html>
<%
String diskArrayID=request.getParameter("diskArrayID");
String diskname=request.getParameter("diskname");
%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
function onBack()
{
    parent.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid=<%=diskArrayID%>&diskname=<%=diskname%>";
}
function refreshAll()
{
    parent.middleframe.location="<%=response.encodeURL("ldconstituterefresh.jsp")%>?diskArrayID=<%=diskArrayID%>&diskname=<%=diskname%>" 
}


</script>

<body>
<form name="ldConstTopForm">
<input type="hidden" name="ldconstitute_check" value="">

<h1 class="title"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<input type="button" name="allrefresh" value="<nsgui:message key="common/button/reload"/>" onClick="refreshAll()">
<h2 class="title"><nsgui:message key="fcsan_componentdisp/ld/h2_ldconstitutetop"/></h2>


</form>
</body>
</html>
