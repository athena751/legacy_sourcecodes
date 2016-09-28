<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ndmpsessiondetailbottom.jsp,v 1.3 2007/05/09 06:43:53 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="ndmp.session.title.sessionDetail"/></title>
</head> 
<body>
<form>
<center><html:button property="close" onclick="parent.close();"><bean:message key="common.button.close" bundle="common"/></html:button></center>
</form>
</body>
</html:html>