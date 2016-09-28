<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ndmpconfig.jsp,v 1.2 2006/10/09 02:08:55 qim Exp $" -->
<html>
<head>
<%@include file="../../common/head.jsp"%>
</head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<Frameset rows="*,60" border="1">
        <frame name="topframe" src="ndmpConfig.do?operation=getNdmpConfigForSet" border="0">
	<frame name="bottomframe" src="ndmpConfigBottom.do"
		class="TabBottomFrame">
</Frameset>
</html>
