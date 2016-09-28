<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicdetailbottom.jsp,v 1.2 2005/10/24 04:40:02 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
</head>
<body>
<center>
<html:button property="close" onclick="window.parent.close()">
    <bean:message key="common.button.close" bundle="common"/>
</html:button>
</center>
</body>
<html>
