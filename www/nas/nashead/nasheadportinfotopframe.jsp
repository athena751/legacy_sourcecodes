<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#):$Id: nasheadportinfotopframe.jsp,v 1.4 2007/05/09 05:17:44 yangxj Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>

<script language="JavaScript">
function onBack() {
	if (isSubmitted()) {
		return false;
	}
	
	setSubmitted();
	window.parent.location="<html:rewrite page='/nasheadHbaInfoShow.do'/>";
}
</script>
</head>

<body>
<bean:define id="isNashead" value="<%=(NSActionUtil.isNashead(request))? "true":"false"%>"/>
<logic:equal name="isNashead" value="true">
	<h1 class="title"><bean:message key="gateway.title.h1.gateway" bundle="nasheadResource/volume"/></h1>
</logic:equal>
<logic:notEqual name="isNashead" value="true" >
	<h1 class="title"><bean:message key="gateway.title.h1.hba" bundle="nasheadResource/volume"/></h1>
</logic:notEqual>

<html:button property="backBtn" onclick="return onBack()"> 
	<bean:message key="common.button.back" bundle="common"/>
</html:button>
</body>
</html:html>

