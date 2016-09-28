<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraydetailinfo.jsp,v 1.2300 2003/11/24 00:55:04 nsadmin Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<html>
<head>
<title><nsgui:message key="fcsan_componentdisp/diskarray_detail/page_title"/></title>
</head>
<%String diskArrayID=request.getParameter("diskid");
  String arraytype = request.getParameter("arraytype");%>
<frameset rows="*,55" > 
<frame name="topframe" scrolling="YES" src="<%=response.encodeURL("diskarraydetailinfotop.jsp")%>?diskArrayID=<%=diskArrayID%>&arraytype=<%=arraytype%>" >
<frame name="bottomframe" src="<%=response.encodeURL("diskarraydetailinfobottom.jsp")%>">
</frameset>
</html>