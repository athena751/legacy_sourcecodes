<!--
        Copyright (c) 2006 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ndmpsessionv2.jsp,v 1.1 2006/12/26 02:35:44 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
function onRefresh(){    
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="ndmpSessionAction.do?operation=entrySessionInfo";       
}
</script>
</head>
<body onload="setHelpAnchor('backup_ndmp_1');">
    <form  method="post">
        <input type="button" name="refreshBtn" onclick="onRefresh();" value='<bean:message key="common.button.reload" bundle="common"/>'/>
        <br><br>
        <bean:message key="ndmp.session.isVersion2"/>
    </form>
</body>
</html>
