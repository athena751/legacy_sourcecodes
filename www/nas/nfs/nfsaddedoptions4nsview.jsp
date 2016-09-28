<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsaddedoptions4nsview.jsp,v 1.1 2005/11/21 01:22:38 liul Exp $" -->

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.model.entity.nfs.NFSConstant"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>
<html>
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript">
function onReload(){
document.forms[0].action="addedOptions4nsview.do?operation=display4nsview";
document.forms[0].method="POST";
document.forms[0].submit();
}
function displayFailed(){
    var status='<bean:write name="<%=NFSConstant.ACCESS_STATUS%>" scope="request"/>';
    if(status != "available" && status != "deny"){
        alert("<bean:message key="addedoptions.alert.getAccessStatusFailed" />");
    }
    return true;
}
</script>
</head>
<body onload="displayFailed();setHelpAnchor('network_nfs_10');">
<form>
<input type="button" onclick="onReload()"
       value="<bean:message key="common.button.reload" bundle="common"/>"/>
<br><br>
<displayerror:error h1_key=""/>
<table border="1">
<tr>
<th><bean:message key="addedoptions.top.th_access"/></th>
<td>
<logic:equal name="<%=NFSConstant.ACCESS_STATUS%>" value="available">
    <bean:message key="addedoptions4nsview.access.available"/>
</logic:equal>
<logic:equal name="<%=NFSConstant.ACCESS_STATUS%>" value="deny">
    <bean:message key="addedoptions4nsview.access.deny"/>
</logic:equal>
<logic:equal name="<%=NFSConstant.ACCESS_STATUS%>" value="undefined">
    <bean:message key="addedoptions4nsview.access.unknown"/>
</logic:equal>
</td>
</tr>
</table>
</form>
</body>
</html>