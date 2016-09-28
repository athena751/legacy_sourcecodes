<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: niclinkdownconfig.jsp,v 1.1 2007/08/24 01:22:03 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@include file="../../common/head.jsp"%>
</head>

<Frameset rows="*,60" border="1">
    <frame name="topframe" src="linkdownConfig.do?operation=getLinkdownInfo4Set" border="0">
	<frame name="bottomframe" src="linkdownConfigBottom.do"
		class="TabBottomFrame">
</Frameset>
</html>
