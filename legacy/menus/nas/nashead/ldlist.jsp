<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldlist.jsp,v 1.1 2004/06/02 12:07:07 liq Exp $" -->

<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<%String target="";
String tmp=request.getParameter("target");
if(tmp!=null) target="?target="+tmp;%>
<Frameset rows="45%,45%,10%">
<frame name="topframe" src="ldlisttop.jsp<%=target%>">
<frame name="midframe" src="ldlistmid_empty.jsp">
<frame name="bottomframe" src="ldlistbottom_empty.html">
</Frameset>

</html>
