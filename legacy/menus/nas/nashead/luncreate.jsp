<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: luncreate.jsp,v 1.2 2005/10/24 01:14:51 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%String src = request.getParameter("src");%>
<%String url = request.getParameter("nextURL");%>
<%String nextURL = "";%>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<%if (url!=null && !url.equals("")){//not from stoarge%>
    <title><nsgui:message key="nas_nashead/common/h2_initlun"/></title>
    <%nextURL = "&nextURL="+url;
}else{
    url="";%>
    <title><nsgui:message key="nas_nashead/common/h1_storage"/></title>
<%}%>
</head>
<%
String top = url.equals("")?"50%":"45%";
String mid = url.equals("")?"40%":"45%";
%>
<Frameset rows="<%=top%>,<%=mid%>,10%">
<frame name="topframe" src="ldlistmid_empty.jsp">
<frame name="midframe" src="luncreatemiddle.jsp?src=<%=src+nextURL%>">
<frame name="bottomframe" src="ldlistmid_empty.jsp">
</Frameset>

</html>
