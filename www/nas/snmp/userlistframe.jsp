<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: userlistframe.jsp,v 1.2 2007/09/12 11:37:24 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
</head> 
<Frameset rows="*,60px" border="1">
	<frame name="userListTop" src="user.do?operation=displayList" border="0">
	<frame name="userListBottom" src="userListBottom.do"  class="TabBottomFrame">
</Frameset>
</html>