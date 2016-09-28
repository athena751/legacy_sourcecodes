<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: networkconnection4nsview.jsp,v 1.1 2005/07/26 11:17:11 key Exp $" -->
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
    //int status = ethguardbean.getStatus();
    String connectionLimits = ethguardbean.getConnectionLimits();
%>

<script language="JavaScript">
function setAlertMessage(){
    <%if(ethguardbean.getDisplayConnection()){
         if(connectionLimits.equals(EthguardConstants.CONNECTION_ERROR)){%>
            alert("<nsgui:message key="nas_ethguard/alert/getConStatusFailed"/>");
        <%}
    }%>
}

function onReload(){
    if (!isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location = "networkconnection4nsview.jsp";
}
</script>
<jsp:include page="../../../menu/common/wait.jsp"></jsp:include>
</head>

<body  onload="displayAlert();setAlertMessage();">
<h1 class="title"><nsgui:message key="nas_ethguard/ethguard/h1_networkconnection"/></h1>

<input type="button" name="reload" onclick="onReload()" value="<nsgui:message key="nas_ethguard/ethguard/button_reload"/>">
<h2 class="title">
    <%if(ethguardbean.getVersionType().equals(EthguardConstants.VERSION_TYPE_JAPAN)){%>
        <nsgui:message key="nas_ethguard/ethguard/h2_connectionJapan"/>        
        </h2>
    <%}else{%>    
        <nsgui:message key="nas_ethguard/ethguard/h2_connectionAbroad"/>    
        </h2>
    <%}%>
<br>
<table border="0">
    <tr>
        <td>
            <%if(ethguardbean.getVersionType().equals(EthguardConstants.VERSION_TYPE_JAPAN)){%>
                <%if(connectionLimits.equals(EthguardConstants.CONNECTION_AVAILABLE)){%>  
                    <nsgui:message key="nas_ethguard/ethguard/td_available_message_japan"/>
                <%}else if(connectionLimits.equals(EthguardConstants.CONNECTION_DENY)){%>
                    <nsgui:message key="nas_ethguard/ethguard/td_deny_message_japan"/>
                <%}else{%>
                    <nsgui:message key="nas_ethguard/ethguard/td_unknown"/>
                <%}%>
            <%}else{%>
                <%if(connectionLimits.equals(EthguardConstants.CONNECTION_AVAILABLE)){%>  
                    <nsgui:message key="nas_ethguard/ethguard/td_available_message_abroad"/>
                <%}else if(connectionLimits.equals(EthguardConstants.CONNECTION_DENY)){%>
                    <nsgui:message key="nas_ethguard/ethguard/td_deny_message_abroad"/>
                <%}else{%>
                    <nsgui:message key="nas_ethguard/ethguard/td_unknown"/>
                <%}%>
            <%}%>
        </td>
    </tr>
</table>
</body>
</html>
