<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
        modified:xh2005
-->


<!-- "@(#) $Id: diskarrayconstituterefresh.jsp,v 1.2303 2005/12/16 05:22:53 xingh Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="refreshBean" class="com.nec.sydney.beans.fcsan.componentdisp.FCSANRefreshBean" scope="page"/>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>
<% AbstractJSPBean _abstractJSPBean = refreshBean; %>
<% _abstractJSPBean.setRequest(request); %>

<% String diskArrayID=request.getParameter("diskArrayID");
   String diskname=request.getParameter("diskname");
   //refreshBean.refresh(diskArrayID);%>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javascript">
function onRefresh()
{
  window.location='<%=response.encodeURL("diskarrayconstituterefresh.jsp")%>?diskArrayID=<%=diskArrayID%>&diskname=<%=diskname%>';
}

function onBack()
{
    window.location="<%=response.encodeURL("diskarraylist.jsp")%>";
}
</script>
</head>

<body>
<%if(refreshBean.refresh(diskArrayID)!=0){
%>
<form name="constituteform">
<h1 class="title"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<input type="button" name="Button" value="<nsgui:message key="common/button/reload"/>" onclick="onRefresh()">
<h2 class="title"><nsgui:message key="fcsan_componentdisp/constitute/constitution"/></h2>
<h3 class="title"><nsgui:message key="fcsan_componentdisp/table/table_diskarrayname" />&nbsp;:&nbsp;<%=diskname%></h3>
<br>
<hr>
<%
    int errorCode=refreshBean.getErrorCode();
    if(refreshBean.setSpecialErrMsg()) {%>
        <h2 class="title"><%=refreshBean.getErrMsg()%></h2>       
    <%} else { %>
<h1 class="Error"><nsgui:message key="fcsan_componentdisp/constitute/msg_refresh_failed"/></h1>
<h2 class="Error"><%=refreshBean.getErrMsg()%></h2>
    <%}%>
    <br><br><br><br><br><br><br>
    <hr>
    <input type="button" name="constitute" value="<nsgui:message key="fcsan_common/button/button_go"/>" disabled= true>
</form>
<%}else{%>
<script language="javascript">
window.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid=<%=diskArrayID%>&diskname=<%=diskname%>"
</script>
<%}%>
</body>
</html>



