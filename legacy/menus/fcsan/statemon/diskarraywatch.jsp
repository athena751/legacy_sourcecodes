<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraywatch.jsp,v 1.2301 2005/09/21 04:56:42 wangli Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>

<html>
<head>
<!--title><nsgui:message key="fcsan_statemon/common/page_title"/></title-->
</head>

<frameset name="a1" rows="*,60" >
  <frameset name="a2" rows="140,*" >
   <frame name="topframe"  src="../common/blank.htm" >
    <frame name="middleframe" scrolling="auto"  src="<%= response.encodeURL("diskarraywatchmiddle.jsp")%>" > 
 </frameset>
  <frame name="bottomframe" scrolling="NO"  src="../common/blank.htm" >
</frameset>
<noframes><body>
</body></noframes>
</html>