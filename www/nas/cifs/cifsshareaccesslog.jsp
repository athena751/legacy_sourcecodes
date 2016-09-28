<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsshareaccesslog.jsp,v 1.7 2005/06/23 01:45:53 key Exp $" -->
<%@include file="../../common/head.jsp" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>
<% String name = (String)request.getParameter("shareName");
	session.setAttribute("shareName",name);
%>
<html>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<Frameset rows="*,60" border="1" >
<frame name="topframe" src="setAccessLog.do?operation=display" border="0" >
<frame name="bottomframe" src="loadAccessLogBottom.do" class="TabBottomFrame">
</Frameset>

</html>
