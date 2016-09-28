<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescannocomputer.jsp,v 1.2 2008/05/14 08:10:44 chenjc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script type="text/javascript">
function onReload(){

    window.location= "scheduleScanGlobalSetTop.do?operation=load"; 
    return true;
}
</script>
</head>
<body onload="setHelpAnchor('nvavs_schedulescan_3');">
<input type="button" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
<br>
<br>
<bean:message key="schedulescan.tip.nocomputer"/>
</body>
</html>