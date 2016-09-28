<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescancomputerset.jsp,v 1.1 2008/05/08 08:54:48 chenbc Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<Frameset rows="*,60" border="1">
    <frame name="scheduleScanComputerSetTop" src="scheduleScanComputerSetTop.do?operation=load" frameborder="0">
    <frame name="scheduleScanComputerSetBottom" scrolling="no" src="scheduleScanComputerSetBottom.do" class="TabBottomFrame">
</Frameset>
</html>