<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: gfsframe.jsp,v 1.1 2005/11/04 01:23:48 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
    <%@include file="../../common/head.jsp" %>
</head>

<frameset cols="50,50">
    <frame name="leftframe"   src="gfsEditFrame.do">
    <frame name="rightframe"  src="volumeList.do" frameborder="0">
</frameset>
</html>
