<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: directedit4nsview.jsp,v 1.1 2005/07/26 11:11:23 wangzf Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.nec.sydney.framework.*"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
function reloadPage(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="<html:rewrite page='/directEdit4nsview.do?operation=display'/>";
}
</script>
</head>
<body onload="setHelpAnchor('network_nfs_5');">
<html:form action="directEdit4nsview.do?operation=save" method="POST">
<input type="button" name="refresh" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="reloadPage()"/>
<br><br>
    <textarea name="fileContent" wrap="off" rows="25" style='width:100%;' readonly>
<nested:write property="fileContent"/></textarea>
</html:form>
</body>
</html>