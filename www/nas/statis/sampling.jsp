<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: sampling.jsp,v 1.2 2007/09/12 11:39:26 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
</head>
    <frameset rows="*,60" border="1">
        <frame name="samplingtop" src="sampling.do?operation=init">
        <frame name="sampmodify" src="samplingbottom.do" class="TabBottomFrame">
    </frameset>
</html>