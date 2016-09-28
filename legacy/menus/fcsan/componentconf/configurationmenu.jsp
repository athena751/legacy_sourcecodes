<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: configurationmenu.jsp,v 1.2301 2005/09/21 04:49:10 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<frameset rows="*,60"  >
  <frameset rows="140,*"  >
   <frame name="topframe"  src="../common/blank.htm" >
    <frame name="mainframe" src="<%=response.encodeURL("configurationmenumiddle.jsp")%>" > 
 </frameset>
  <frame name="bottomframe" src="../common/blank.htm">
</frameset> 
</html>