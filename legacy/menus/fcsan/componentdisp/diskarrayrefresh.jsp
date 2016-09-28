<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
        modified:xh2005
-->


<!-- "@(#) $Id: diskarrayrefresh.jsp,v 1.2302 2005/12/16 05:22:53 xingh Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,java.lang.*,java.util.*,com.nec.sydney.framework.*,com.nec.sydney.beans.fcsan.common.*" %>
<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<jsp:useBean id="refreshBean" class="com.nec.sydney.beans.fcsan.componentdisp.FCSANRefreshBean" scope="page"/>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>
<% AbstractJSPBean _abstractJSPBean = refreshBean; %>
<% _abstractJSPBean.setRequest(request); %>

<body>
<%
String id=request.getParameter("diskArrayID");

%>
<%if(refreshBean.refresh(id)==0){%>
<script language=javascript>
parent.middleframe.location="<%=response.encodeURL("diskarraypdlistmiddle.jsp")%>?id=<%=id%>&diskname=<%=request.getParameter("diskname")%>"
</script>
<%}else{    
    int errorCode=refreshBean.getErrorCode();
    if(refreshBean.setSpecialErrMsg()) {%>
        <h2 class="title"><%=refreshBean.getErrMsg()%></h2>       
    <%} else { 
    out.println("<h1 class=\"Error\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/pd/msg_refreshnophysical")+"</h1>");
    out.println("<h2 class=\"Error\">"+refreshBean.getErrMsg()+"</h2>");
  }
}%>
<script>
parent.bottomframe.location="<%=response.encodeURL("diskarraypdlistbottom.jsp")%>?diskarrayid=<%=id%>&diskname=<%=request.getParameter("diskname")%>";
//window.open("<%=response.encodeURL("diskarraypdlistbottom.jsp")%>?diskarrayid=<%=id%>&diskname=<%=request.getParameter("diskname")%>","bottomframe","")
</script>
</body>
</html>