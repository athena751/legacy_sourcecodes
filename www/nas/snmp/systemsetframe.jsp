<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: systemsetframe.jsp,v 1.2 2007/09/12 11:36:51 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
    <%@include file="../../common/head.jsp" %>
</head>
<frameset rows="*,60px" border="1">
    <frame name="topframe" src="system.do?operation=display" border="0">
    <frame name="bottomframe" src="systemSetBottom.do" class="TabBottomFrame">
</frameset>
</html>