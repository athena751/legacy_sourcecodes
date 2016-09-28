<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfsdetailinfobottom.jsp,v 1.2 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html:html lang="true">
<head>
<title><bean:message key="title"/></title>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head> 
<body>
<form method="post">
<center><html:button property="close" onclick="parent.close();"><bean:message key="common.button.close" bundle="common"/></html:button></center>
</form>
</body>
</html:html>