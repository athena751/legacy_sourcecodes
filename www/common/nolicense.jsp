<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nolicense.jsp,v 1.4 2007/05/09 05:17:35 liul Exp $" -->
<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<bean:parameter id="h1key" name="itemNameKey" value=" "/>
<bean:parameter id="license" name="licenseKey" value=" "/>
<logic:equal name="h1key" value=" ">
    <bean:define id="h1key" name="itemNameKey" scope="request" type="java.lang.String"/>
</logic:equal>
<logic:equal name="license" value=" ">
    <bean:define id="license" name="licenseKey" scope="request" type="java.lang.String"/>
</logic:equal>

<head>
<%@include file="/common/head.jsp" %>
<title><bean:message bundle="menuResource/framework" key="<%=h1key%>"/></title>
</head>
<body>
<h1 class="title"><bean:message bundle="menuResource/framework" key="<%=h1key%>"/></h1>
<bean:message bundle="LicenseResource/framework" key="nolicense"/>
<ul>
<%license=license+".info";%>
<li><bean:message bundle="LicenseResource/framework" key="<%=license%>"/>
</ul>
</body>
</html:html>
