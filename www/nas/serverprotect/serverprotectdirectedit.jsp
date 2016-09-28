<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectdirectedit.jsp,v 1.1 2007/02/09 13:03:51 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<Frameset rows="*,60" border="1">
    <frame name="topFrame" src="serverProtectFile.do?operation=readVrscanFile" border="0">
    <frame name="bottomFrame" scrolling="no" src="serverProtectDirectEditBottom.do" class="TabBottomFrame">
</Frameset>
</html>