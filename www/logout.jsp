<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: logout.jsp,v 1.2 2007/05/09 05:23:16 liul Exp $" -->
<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<logic:present name="href">
<META HTTP-EQUIV="Refresh" CONTENT="1;URL=<bean:write name="href" scope="request"/>">
</logic:present>
<meta http-equiv="Pragma" content="no-cache"> 
<link rel="stylesheet" href="/nsadmin/skin/default/default.css" type="text/css">
<title><bean:message key="logout.title"/></title>
</head>
<logic:notPresent name="href">
<body onLoad="setTimeout('window.close()', 2000)">
</logic:notPresent>
<logic:present name="href">
<body>
</logic:present>

<h1><bean:message key="logout.h1"/></h1>
<logic:notPresent name="href">
<div align="right">
<form>
	<input type="button" value="<bean:message key="logout.bye"/>" onClick="window.close()">
</form>
</div>
</logic:notPresent>
</body>
</html:html>
