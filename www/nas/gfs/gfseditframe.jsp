<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: gfseditframe.jsp,v 1.3 2007/09/12 11:32:52 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
    <%@include file="../../common/head.jsp" %>
</head>
<frameset rows="*,60" border="1">
    <frame name="topframe" src="gfsEdit.do?operation=displayTop" border="0">
    <frame name="bottomframe" src="/nsadmin/common/commonblank.html" scrolling="no"  border="0" class="TabBottomFrame">
</frameset>
</html>