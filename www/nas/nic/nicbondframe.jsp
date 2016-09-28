<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicbondframe.jsp,v 1.2 2005/10/24 04:39:19 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="struts-html" prefix="html"%>
<html>
<head>
<%@include file="../../common/head.jsp"%>
<html:base />
</head>
<frameset rows="*,60" border="1">
	<frame name="nicbondtopframe" src="<%=request.getContextPath()%>/nic/bondShowTop.do" border="0" >
	<frame name="nicbondbottomframe" src="<%=request.getContextPath()%>/common/commonblank.html"
		class="TabBottomFrame">
</frameset>
</html>
