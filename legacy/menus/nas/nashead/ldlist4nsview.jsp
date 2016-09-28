<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldlist4nsview.jsp,v 1.2 2005/10/28 11:56:36 liuyq Exp $" -->

<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<%String target="";
String tmp=request.getParameter("target");
if(tmp!=null) target="?target="+tmp;%>
<Frameset rows="250,*,0">
<frame name="topframe" src="ldlisttop4nsview.jsp<%=target%>">
<frame name="bottomframe" src="ldlistbottom_empty.html">
<frame marginwidth=0 marginheight=0 name="hideFrame" frameborder="no" scrolling="no" src="ldlistbottom_empty.html" noResize="true">
</Frameset>
</html>
