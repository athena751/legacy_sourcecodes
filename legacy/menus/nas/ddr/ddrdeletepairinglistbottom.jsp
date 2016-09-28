<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrdeletepairinglistbottom.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@page import="com.nec.sydney.framework.*"%>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
</head>
<body>
<form name="ddrdelpairingbottomForm" method="post">
<input type="button" name="closeBrowser" 
    value="<nsgui:message key="nas_ddrschedule/button/close"/>"
    onclick="parent.close();" />
</form>
</body>
</html>
