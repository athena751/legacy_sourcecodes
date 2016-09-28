<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescancomputersettop.jsp,v 1.3 2008/05/24 08:09:29 chenjc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script type="text/javascript">
function init(){
    setHelpAnchor("nvavs_schedulescan_2");
    elements = document.forms[0].elements;
    initConfirm();
    <%--initAlert();--%>
    displayAlert();
    elements["computerName"].focus();
    if (window.parent.frames[1].document &&
        window.parent.frames[1].document.forms[0] &&
        !isSubmitted()) {
        window.parent.frames[1].changeButtonStatus();
    }
    return true;
}

function initConfirm(){
<logic:equal name="schedulescan_haveConnection" value="yes" scope="request">
    if(isSubmitted()){
        return false;
    }
    if(confirm("<bean:message key="schedulescan.alert.haveconnection"/>")){
       setSubmitted();
       if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
           parent.frames[1].document.forms[0].setButton.disabled=true;
       }
       document.forms[0].action="scheduleScanComputerSetTop.do?operation=set";
       document.forms[0].submit();
       return true;
    }
    return false;
</logic:equal>
<logic:equal name="toAddUser" value="yes" scope="request">
    if(isSubmitted()){
        return false;
    }
    if(confirm("<bean:message key="schedulescan.alert.toadduser"/>")){
       setSubmitted();
       window.parent.parent.location="scheduleScanAddUser.do";
       return true;
    }
    return false;
</logic:equal>
}
<%--
function initAlert(){
<logic:notEmpty name="computerAlertMessage" scope="request">
    alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
         +"<bean:write name="computerAlertMessage" filter="false"/>");
    return true;
</logic:notEmpty>
}
--%>
function onReload(){
    if (isSubmitted()){
        return false;
    }
    if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
        parent.frames[1].document.forms[0].setButton.disabled=true;
    }else{
        return false;
    }
    setSubmitted();
    document.forms[0].action = "scheduleScanComputerSetTop.do?operation=load"; 
    document.forms[0].submit();
    return true;
}

function checkComputerName(){
    toUpperComputerName(elements["computerName"]);
    var computerName=elements["computerName"].value;
    if(computerName==""){
        sAlert("noComputer");
        return false;
    }
    if(computerName.length>15){
        sAlert("tooLong");
        return false;
    }
    var reg=/[^A-Za-z0-9\-]/;
    if(reg.test(computerName)){
        sAlert("errorChar");
        return false;
    }
    if(computerName.charAt(0)== "-"){
        sAlert("firstCharError");
        return false;
    }
    <logic:iterate id="hostName" name="hostName" type="java.lang.String">
    if(computerName=="<bean:write name="hostName"/>"){
        sAlert("hostDeny");
        return false;
    }
    </logic:iterate>
    return true;
}

function sAlert(where){
    switch (where) {
        case "noComputer" :
            alert("<bean:message key="schedulescan.alert.nocomputer"/>");
            break;
        case "firstCharError" :
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                + "<bean:message key="schedulescan.alert.firstcharerrorcomputer"/>");
            break;
        case "hostDeny" :
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                + "<bean:message key="schedulescan.alert.hostcomputer"/>");
            break;
        default :
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                + "<bean:message key="schedulescan.alert.errorcharcomputer"/>");
            break;
    }
    elements["computerName"].focus();
    return true;
}

function toUpperComputerName(obj){
    obj.value=trim(obj.value.toUpperCase());
    return true;
}

function submitSet(){
    if(isSubmitted()){
        return false;
    }
    if(!checkComputerName()){
        return false;
    }
    if(!confirm("<bean:message key="common.confirm" bundle="common"/>\r\n"+
                "<bean:message key="common.confirm.action" bundle="common"/>"+
                "<bean:message key="common.button.submit" bundle="common"/>")){
        return false;
    }
    setSubmitted();
    document.forms[0].submit();
    return true;
}

</script>
</head>

<body onload="init();" onunload="closeDetailErrorWin();">

<html:form action="scheduleScanComputerSetTop.do?operation=checkConnection" method="post" onsubmit="return false;">

<input type="button" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
<br>
<displayerror:error h1_key="schedulescan.common.h1"/>
<br>

<table class="Vertical" border="1">
<tbody>
    <tr>
        <th style="vertical-align:top">
            <bean:message key="schedulescan.th.antivirus.computer"/>
        </th>
        <td>
            <html:text property="computerName" maxlength="15" onblur="toUpperComputerName(this);"/>
        </td>
    </tr>
</tbody>
</table>
</html:form>
</body>
</html>