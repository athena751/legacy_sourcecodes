<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logicaldisklist.jsp,v 1.2300 2003/11/24 00:55:03 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<html>
<head><title><nsgui:message key="fcsan_componentdisp/pddetail/h3_detail"/></title></head>
<frameset rows="*,55">
   <frame name="topframe" scrolling="YES"  src="<%=response.encodeURL("../componentdisp/ldconstitutemiddle.jsp")%>?diskArrayID=<%=request.getParameter("diskarrayid")%>&diskname=<%=request.getParameter("diskarrayname")%>&typeValue=All&PDGroup=<%=request.getParameter("pdnum")%>"> 
   <frame name="bottomframe" src="<%=response.encodeURL("logicaldisklistbottom.jsp")%>"> 
</frameset>
</html>