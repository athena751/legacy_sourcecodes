<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankspare.jsp,v 1.2303 2005/12/16 06:45:01 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%
String diskarrayid=request.getParameter("diskarrayid");
String diskarrayname=request.getParameter("diskarrayname");
String arraytype=request.getParameter("arraytype");
String pdgroupnumber=request.getParameter("pdgroupnumber");
String reload = request.getParameter("reload");
%>

<html>
<frameset rows="*,110"> 
    <frameset rows="180,*"> 
        <frame name="topframe" src="<%=response.encodeURL("ranksparetop.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&pdgroupnumber=<%=pdgroupnumber%>&reload=<%=reload%>" >
            <frameset cols="450,*">
            <frame name="middleleftframe"  src="../common/blank.htm" >
            <frame name="middlerightframe" src="../common/blank.htm" >
            </frameset>
      </frameset>
      <frame name="bottomframe" src="../common/blank.htm">
</frameset>

</html>