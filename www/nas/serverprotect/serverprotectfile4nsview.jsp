<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: serverprotectfile4nsview.jsp,v 1.5 2007/03/23 05:00:25 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ page import="com.nec.nsgui.action.serverprotect.ServerProtectActionConst"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">


function onReload(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="serverProtectFile.do?operation=readVrscanFile";
}
</script>
</head>
<body onload="setHelpAnchor('nvavs_realtimescan_4');">
<form name="serverProtectFileSetForm" method="POST">
    <input type="button" name="reload" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
	<br>
	<br>
    <textarea name="fileContent" wrap="off" rows="30" style='width:100%;' readonly><bean:write name="directEditForm" property="fileContent"/></textarea>
</form>
</body>
</html>