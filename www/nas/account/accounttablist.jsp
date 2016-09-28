<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: accounttablist.jsp,v 1.2 2005/10/19 01:20:57 fengmh Exp $" -->
<html>
<head>
<%@include file="../../common/head.jsp"%>
</head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<Frameset rows="*,60" border="1">
	<frame name="topframe" src="accountTablistTop.do?operation=list" border="0">
	<frame name="bottomframe" src="accountTablistBottom.do"
		class="TabBottomFrame">
</Frameset>
</html>
