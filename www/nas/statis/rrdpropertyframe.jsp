<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdpropertyframe.jsp,v 1.3 2007/09/13 10:20:48 yangxj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
</head>
<frameset rows="*,60" border="1">
    <frame name="topframe" src="rrdproperty.do?operation=display" border="0">
    <frame name="bottomframe" src="rrdpropertyBottom.do"   class="TabBottomFrame">
</frameset>
</html>