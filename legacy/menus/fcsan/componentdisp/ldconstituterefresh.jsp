<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
        modified:xh2005
-->


<!-- "@(#) $Id: ldconstituterefresh.jsp,v 1.2301 2005/12/16 05:22:53 xingh Exp $" -->
<html>

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*,com.nec.sydney.beans.fcsan.common.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<jsp:useBean id="refreshBean" class="com.nec.sydney.beans.fcsan.componentdisp.FCSANRefreshBean" scope="page"/>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>
<% AbstractJSPBean _abstractJSPBean = refreshBean; %>
<% _abstractJSPBean.setRequest(request); %>
<%
String diskArrayID=request.getParameter("diskArrayID");
String diskname=request.getParameter("diskname");
int result=refreshBean.refresh(diskArrayID);
if(result!=0)
{
    int errorCode=refreshBean.getErrorCode();
    if(refreshBean.setSpecialErrMsg()) {%>
        <h2 class="title"><%=refreshBean.getErrMsg()%></h2>       
    <%} else {%>
<h1 class="Error"><nsgui:message key="fcsan_componentdisp/ld/p_ldconstituterefresh"/></h1>
<h2 class="Error"><%=refreshBean.getErrMsg()%></h2>
    <%}%>

<script language="javaScript">
parent.bottomframe.location="<%=response.encodeURL("ldconstitutebottom.jsp")%>?diskArrayID=<%=diskArrayID%>&diskname=<%=diskname%>"
</script>

<%}else{%>
<script language="javascript">
parent.location="<%=response.encodeURL("ldconstitute.jsp")%>?diskArrayID=<%=diskArrayID%>&diskname=<%=diskname%>"
</script>
<%}%>
</html>