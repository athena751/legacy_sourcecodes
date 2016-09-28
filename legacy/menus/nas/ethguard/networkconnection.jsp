<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: networkconnection.jsp,v 1.4 2005/09/19 09:09:37 wanghb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean,com.nec.sydney.atom.admin.ethguard.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="nshtml-taglib" prefix="nshtml"%>
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
var loaded = 0;
function setOperation(op){
    <%if(ethguardbean.getDisplayConnection()){%>
       document.forms[0].operation.value = op;
    <%}else{%>
        document.forms[0].operation.value = "";
    <%}%>
}

function setAlertMessage(){
    <%if(ethguardbean.getDisplayConnection()){
         if(connectionLimits.equals(EthguardConstants.CONNECTION_ERROR)){%>
            alert("<nsgui:message key="nas_ethguard/alert/getConStatusFailed"/>");
        <%}
    }%>
}

function onSubmit(){
    var confirmInfo;
    if(loaded==0){
        return false;
    }
    if(!isSubmitted()){
        return false;
    }
    if(document.forms[0].operation.value == ""){
        return false;
    }else if(document.forms[0].operation.value == "setAvailable"){
        confirmInfo = "<nsgui:message key="common/confirm" />" + "\r\n"
            + "<nsgui:message key="common/confirm/act" />" 
            + "<nsgui:message key="nas_ethguard/ethguard/button_conAvailable"/>";
    }else if(document.forms[0].operation.value == "setDeny"){
        confirmInfo = "<nsgui:message key="common/confirm" />" + "\r\n"
            + "<nsgui:message key="common/confirm/act" />" 
            + "<nsgui:message key="nas_ethguard/ethguard/button_conDeny"/>";
    }
    if(!confirm(confirmInfo)){
        return false;
    }
    setSubmitted();
    return true;
}

function checkState(){
    <%if(ethguardbean.getDisplayConnection()){%>
        if (document.forms[0]&&document.forms[0].available&&document.forms[0].deny){
            <%if(connectionLimits.equals(EthguardConstants.CONNECTION_AVAILABLE)){%>
                document.forms[0].available.disabled=true;
            <%}else if(connectionLimits.equals(EthguardConstants.CONNECTION_DENY)){%>
                document.forms[0].deny.disabled=true; 
            <%}%>
        }
     <%}else{ %>
        document.forms[0].deny.disabled=true;
        document.forms[0].available.disabled=true;
     <%}%> 
}
function onReload(){
    if (!isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location = "networkconnection.jsp";
}
</script>
<jsp:include page="../../../menu/common/wait.jsp"></jsp:include>
</head>
<body onload="checkState();displayAlert();setAlertMessage();loaded=1">
<nshtml:form name="ethguardform" onsubmit="return onSubmit()" action="../../common/forward.jsp">
<input type="hidden" name="operation">
<input type="hidden" name="beanClass" value="<%=ethguardbean.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">
<h1 class="title"><nsgui:message key="nas_ethguard/ethguard/h1_networkconnection"/></h1>
<input type="button" name="reload" onclick="onReload()" value="<nsgui:message key="nas_ethguard/ethguard/button_reload"/>">
<!-- modified by hujing, according to mail 03089, both service LAN and Manage LAN display the page-->
<h2 class="title">
    <%if(ethguardbean.getVersionType().equals(EthguardConstants.VERSION_TYPE_JAPAN)){%>
        <nsgui:message key="nas_ethguard/ethguard/h2_connectionJapan"/>        
        </h2>
				<nsgui:message key="nas_ethguard/ethguard/networkconnection_message_japan"/>           
    <%}else{%>    
        <nsgui:message key="nas_ethguard/ethguard/h2_connectionAbroad"/>    
        </h2>
				<nsgui:message key="nas_ethguard/ethguard/networkconnection_message_abroad"/> 
    <%}%>

<h3 class="title"><nsgui:message key="nas_ethguard/ethguard/h3_conPropriety"/></h3>
<table border = "1">
    <tr>
        <th><nsgui:message key="nas_ethguard/ethguard/th_connection"/></th>
        <td><%if(connectionLimits.equals(EthguardConstants.CONNECTION_AVAILABLE)){%>  
                <nsgui:message key="nas_ethguard/ethguard/td_available"/>
            <%}else if(connectionLimits.equals(EthguardConstants.CONNECTION_DENY)){%>
                <nsgui:message key="nas_ethguard/ethguard/td_deny"/>
            <%}else{%>
                <nsgui:message key="nas_ethguard/ethguard/td_unknown"/>
            <%}%>
        </td>
    </tr>
</table>
<h3 class="title"><nsgui:message key="nas_ethguard/ethguard/h3_conProprietySet"/></h3>
<%
    String available=NSMessageDriver.getInstance().getMessage(session,"nas_ethguard/ethguard/button_conAvailable");
    String deny=NSMessageDriver.getInstance().getMessage(session,"nas_ethguard/ethguard/button_conDeny");
%>


    <nshtml:submit name="available" value="<%=available%>" disabled="false" onclick="setOperation('setAvailable')"/>
    &nbsp;
    <nshtml:submit name="deny" value="<%=deny%>" disabled="false" onclick="setOperation('setDeny')"/>
</nshtml:form>
</body>
</html>