<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescannosetting.jsp,v 1.2 2008/05/14 08:10:44 chenjc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script type="text/javascript">
function onReload(){
    window.location= "scheduleScanShare.do?operation=getShareInfo"; 
    return true;
}
</script>
</head>
<body onload="setHelpAnchor('nvavs_schedulescan_4');">
<input type="button" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
<br>
<br>
<bean:message key="schedulescan.share.noconfigfile"/>
</body>
</html>