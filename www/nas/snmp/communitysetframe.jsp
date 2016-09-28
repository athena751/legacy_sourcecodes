<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communitysetframe.jsp,v 1.2 2007/09/12 11:34:11 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
</head>
<frameset rows="*,60px" border="1">
    <frame name="topframe" src="community.do?operation=displaySet" border="0">
    <frame name="bottomframe" src="communitySetBottom.do" class="TabBottomFrame">
</frameset>
</html>