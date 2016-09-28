<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: filteringlog.jsp,v 1.3 2005/09/19 09:09:43 wanghb Exp $" -->

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
    int status = ethguardbean.getStatus();
// String connectionLimits = ethguardbean.getConnectionLimits();
%>
<script language="JavaScript">
var loaded = 0;
function setOperation(op){
    document.forms[0].operation.value = op;
}

function setAlertMessage(){
   <%   if(status != 0 && status != 3){%>
        alert("<nsgui:message key="nas_ethguard/alert/getLogStatusFailed"/>");
    <%}%>
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
    }else if(document.forms[0].operation.value == "start"){
        confirmInfo = "<nsgui:message key="common/confirm" />" + "\r\n"
            + "<nsgui:message key="common/confirm/act" />" 
            + "<nsgui:message key="nas_ethguard/ethguard/start"/>";
    }else if(document.forms[0].operation.value == "stop"){
        confirmInfo = "<nsgui:message key="common/confirm" />" + "\r\n"
            + "<nsgui:message key="common/confirm/act" />" 
            + "<nsgui:message key="nas_ethguard/ethguard/stop"/>";
    }
    
    if(!confirm(confirmInfo)){
        return false;
    }
    setSubmitted();
    return true;
}

function checkState(){
    if (document.forms[0]&&document.forms[0].start&&document.forms[0].stop){
        <%if(status==0){%>
            document.forms[0].start.disabled=true;
        <%}else if (status==3){%>
            document.forms[0].stop.disabled=true; 
        <%}%>
    }
}
function onReload(){
    if (!isSubmitted()){
        return false;
    }  
    setSubmitted();
    window.location = "filteringlog.jsp";
}
</script>
<jsp:include page="../../../menu/common/wait.jsp"></jsp:include>
</head>
<body onload="checkState();displayAlert();setAlertMessage();loaded=1">
<nshtml:form name="ethguardform" onsubmit="return onSubmit()" action="../../common/forward.jsp">
<input type="hidden" name="operation">
<input type="hidden" name="beanClass" value="<%=ethguardbean.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">
<h1 class="title"><nsgui:message key="nas_ethguard/ethguard/h1_filteringlog"/></h1>
<input type="button" name="reload" onclick="onReload()" value="<nsgui:message key="nas_ethguard/ethguard/button_reload"/>">
<h2 class="title"><nsgui:message key="nas_ethguard/ethguard/h2_log"/></h2>
<nsgui:message key="nas_ethguard/ethguard/filteringlog_message"/>
<h3 class="title"><nsgui:message key="nas_ethguard/ethguard/h3_status"/></h3>
<table border = "1">
    <tr>
        <th><nsgui:message key="nas_ethguard/ethguard/logstatus"/></th>
            <%if (status == 0){%>
        <td><nsgui:message key="nas_ethguard/ethguard/executing"/></td>
            <%}else if (status == 3){//exit 3%>
        <td><nsgui:message key="nas_ethguard/ethguard/stopping"/></td>
            <%}else{%>
        <td><nsgui:message key="nas_ethguard/ethguard/unknown"/></td>
            <%}%>
    </tr>
</table>
<h3 class="title"><nsgui:message key="nas_ethguard/ethguard/h3_setting"/></h3>
<%
    String start=NSMessageDriver.getInstance().getMessage(session,"nas_ethguard/ethguard/start");
    String stop=NSMessageDriver.getInstance().getMessage(session,"nas_ethguard/ethguard/stop");
%>
<nshtml:submit name="start" value="<%=start%>" disabled="false" onclick="setOperation('start')"/>
&nbsp;
<nshtml:submit name="stop" value="<%=stop%>" disabled="false" onclick="setOperation('stop')"/>
</nshtml:form>
</body>
</html>