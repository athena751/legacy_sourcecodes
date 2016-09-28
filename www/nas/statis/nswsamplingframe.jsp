<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingframe.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
</head>
<Frameset rows="*,60" border="0">
    <frame name="nswsamplinglist" src="nswsampling.do?operation=initList">
    <frame name="nswsamplingbottom" src="nswsamplingbottom.do" class="TabBottomFrame">
</Frameset>
</html>