<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankbind.jsp,v 1.2303 2005/09/21 04:49:10 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"%>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.beans.fcsan.common.*" %>

<%
String pdgroupnumber=request.getParameter("pdgroupnumber");
String diskarrayname=request.getParameter("diskarrayname");
String arraytype=request.getParameter("arraytype");
String diskarrayid = request.getParameter("diskarrayid");
%>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<title><nsgui:message key="fcsan_componentconf/rankbind/title_rankbind"/></title>
</head>
<frameset rows="*,40%">
    <%
    String targetUrl = "/nsadmin/menu/fcsan/componentconf/rankbindtop.jsp";
    if(session.getAttribute(FCSANConstants.SESSION_DISK_MODEL).equals("1")){
        targetUrl = "/nsadmin/menu/fcsan/componentconf/rankbindtopmirror.jsp";
    }
    String from = request.getParameter("from");
    if (from != null && from.equals("volume")){
        session.setAttribute(FCSANConstants.SESSION_RANK_BIND_FROM,"volume");
    }else{
        session.setAttribute(FCSANConstants.SESSION_RANK_BIND_FROM,"fcsan");
    }
    %>
    <frame name="topframe"  src="<%=response.encodeURL(targetUrl)%>?diskarrayid=<%=diskarrayid%>&pdgroupnumber=<%=pdgroupnumber%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>">
    <frame name="bottomframe"  src="/nsadmin/menu/fcsan/common/blank.htm">
</frameset> 

</html>