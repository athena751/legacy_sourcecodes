<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsDirAccessListBottom4nsview.jsp,v 1.1 2005/08/29 17:13:33 key Exp $" -->

<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

</script>
</head>
<body style="margin: 10px;">
<form method="POST"  name="dirAccessControlListBottomForm">
<center>  <input type="button" name="close" onclick="parent.close();"
        value="<bean:message key="common.button.close" bundle="common"/>" />
</center>
</form>
</body>
</html>