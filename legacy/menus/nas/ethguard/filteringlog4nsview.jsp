<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: filteringlog4nsview.jsp,v 1.1 2005/07/26 11:19:10 key Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean,com.nec.sydney.atom.admin.ethguard.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="ethguardbean" class="com.nec.sydney.beans.ethguard.EthguardBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = ethguardbean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<script src="../common/general.js"></script>

<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<%
    int status = ethguardbean.getStatus();
   // String connectionLimits = ethguardbean.getConnectionLimits();
%>
<script language="JavaScript">
function setAlertMessage(){
   <%   if(status != 0 && status != 3){%>
        alert("<nsgui:message key="nas_ethguard/alert/getLogStatusFailed"/>");
    <%}%>
}
function onReload(){
    if (!isSubmitted()){
        return false;
    }  
    setSubmitted();
    window.location = "filteringlog4nsview.jsp";
}
</script>
<jsp:include page="../../../menu/common/wait.jsp"></jsp:include>
</head>
<body onload="displayAlert();setAlertMessage();">
<h1 class="title"><nsgui:message key="nas_ethguard/ethguard/h1_filteringlog"/></h1>

<input type="button" name="reload" onclick="onReload()" value="<nsgui:message key="nas_ethguard/ethguard/button_reload"/>">
<h2 class="title"><nsgui:message key="nas_ethguard/ethguard/h2_log"/></h2>
<br>
<table border="0">
    <tr>
            <%if (status == 0){%>
        <td><nsgui:message key="nas_ethguard/ethguard/td_executing_message"/></td>
            <%}else if (status == 3){%>
        <td><nsgui:message key="nas_ethguard/ethguard/td_stopping_message"/></td>
            <%}else{%>
        <td><nsgui:message key="nas_ethguard/ethguard/unknown"/></td>
            <%}%>
    </tr>
</table>
</body>
</html>