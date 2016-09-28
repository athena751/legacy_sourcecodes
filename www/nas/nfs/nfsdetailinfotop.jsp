<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsdetailinfotop.jsp,v 1.1 2005/06/22 08:13:25 wangzf Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<title><bean:message key="title"/></title>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
</head>
<body onload="setHelpAnchor('network_nfs_9');" onUnload="setHelpAnchor('network_nfs_1');">
<h1 class="title"><bean:message key="title.nfs"/></h1>
<h2 class="title"><bean:message key="h2.export.detail"/></h2>
<form method="POST">
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="th.directory"/></th>
    <td><bean:write name="nfsDetailForm" property="selectedDir"/></td>
  </tr>
</table>
</form>
</body>
</html>