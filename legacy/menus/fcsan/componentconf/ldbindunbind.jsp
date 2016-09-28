<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldbindunbind.jsp,v 1.2302 2005/12/16 06:45:01 wangli Exp $" -->


<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<frameset rows="*,55" > 
  <frameset rows="180,*" > 
    <frame name="topframe" src="<%=response.encodeURL("ldbindunbindtop.jsp")%>?action=PDGroup&diskarrayid=<%=request.getParameter("diskarrayid")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>&arraytype=<%=request.getParameter("arraytype")%>&PDGroups=<%=request.getParameter("PDGroups")%>&reload=<%=request.getParameter("reload")%>">
<frame name="mainframe" src="../common/blank.htm">
  </frameset>
  <frame name="bottomframe" src="<%=response.encodeURL("ldbindunbindbottom.jsp")%>">
</frameset>
</html>