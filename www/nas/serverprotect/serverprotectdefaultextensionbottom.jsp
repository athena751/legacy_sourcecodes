<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectdefaultextensionbottom.jsp,v 1.1 2007/03/23 09:43:18 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>

<body>
<center>
<input type="button" 
       value='<bean:message key="common.button.close" bundle="common"/>'
       onclick="window.parent.close();" />
</center>
</body>
</html>
