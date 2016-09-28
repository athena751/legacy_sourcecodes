<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: forward.jsp,v 1.2 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head> 
<body onload='parent.location.href="<html:rewrite page='/nfsList.do'/>";'>
</body>
</html:html>