<!--
        Copyright (c) 2004-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: forwardexport.jsp,v 1.9 2006/07/06 05:32:25 liul Exp $" -->
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<html>
<head>
<script language="JavaScript" src="../common/common.js"></script>
<%@ include file="common/head.jsp" %>
</head>
<body> 
<form>
<bean:parameter id="item" name="itemNameKey"/>
<bean:define id="user" name="userinfo" scope="session"/>

<h1><bean:message name="item" bundle="menuResource/framework"/></h1>
<logic:equal name="user" value="nsadmin">
    <bean:message key="warn.expgrp.not.exist" />
    <a href="#" onclick="selectModule('base.exportGroup.setup');return false;">[<bean:message key="base.exportGroup.setup" bundle="menuResource/framework"/>]</a>
</logic:equal>
<logic:notEqual name="user" value="nsadmin">
    <bean:message key="warn.expgrp.not.exist.nsview" />
</logic:notEqual>

</form>
</body>
</html> 

