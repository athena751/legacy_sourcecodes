<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraypdlist.jsp,v 1.2301 2005/09/21 04:53:50 wangli Exp $" -->

<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<% String diskArrayID=request.getParameter("diskArrayID");
   String diskname = request.getParameter("diskname");%>
<frameset rows="*,60">
  <frameset rows="140,*">
   <frame name="topframe"  src="<%=response.encodeURL("diskarraypdlisttop.jsp")%>?id=<%=diskArrayID%>&diskname=<%=diskname%>" >
    <frame name="middleframe"   src="<%=response.encodeURL("diskarraypdlistmiddle.jsp")%>?id=<%=diskArrayID%>&diskname=<%=diskname%>"> 
 </frameset>
  <frame name="bottomframe" src="../common/blank.htm">
</frameset>
</html>