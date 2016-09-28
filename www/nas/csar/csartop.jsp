<!--
        Copyright (c) 2008-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: csartop.jsp,v 1.3 2009/02/11 03:04:43 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.model.biz.base.ClusterUtil"%>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%> 
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var buttonEnable = 0;
var heartbeatWin;
function enableBottomButton(){
    buttonEnable = 1;
    if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
        window.parent.frames[1].enableButton();
    }
}

function init(){    
    setHelpAnchor("trouble_analysis");        
    enableBottomButton();  
    displayAlert();
    return ;    
}

function onCollectInfo(){
    if (isSubmitted()) {
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="csar.button.collect"/>')){
            return false;
    }
    setSubmitted();
    popupHeartbeat(); 
    document.forms[0].submit();       
    return true; 
}

function onDownloadPart(){
    window.parent.downloadframe.window.location="/nsadmin/nas/csar/csardownload.jsp";        
    return true; 
}

function closeHeartbeatWin(){
    if (heartbeatWin != null && !heartbeatWin.closed){
        heartbeatWin.close();
    }
}

function popupHeartbeat(){
    var date = new Date();
    var starttime = date.getTime();
    document.forms[1].elements["startTime"].value=starttime;
    if (heartbeatWin != null && !heartbeatWin.closed){
        heartbeatWin.focus();
    }else{               
        heartbeatWin = window.open("/nsadmin/common/commonblank.html", "heartbeat",
                    "resizable=no,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=500,height=250");
    }
    document.forms[1].target="heartbeat";
    document.forms[1].submit();
     
}
</script>
</head>
<body onload="init();"  onunload="closeHeartbeatWin();closeDetailErrorWin();">
<html:form action="csarSetting.do?operation=collectInfo" target="_parent">
<h1 class="title"><bean:message key="csar.title.h1"/></h1>
<div id="exception_message" style="display:inline;">
<displayerror:error h1_key="csar.title.h1"/>
</div>
<br>
<table border="0">
    <tr><td colspan="2">
        <bean:message key="csar.msg.info.warnning"/>                   
    <br><br>
    <table border="0" style="background-image:url('none');background-color:transparent;">
    <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="csar.msg.type.summary"/></td><td><bean:message key="csar.msg.info.summary"/></td></tr>
    <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="csar.msg.type.full"/></td><td><bean:message key="csar.msg.info.full" /></td></tr>
    <tr><td></td><td><bean:message key="csar.msg.info.notification"/>
    </td></tr>
    </table>
    </td></tr>
</table>
<%if(!NSActionUtil.isSingleNode(request)){%>
<h3 class="title"><bean:message key="csar.title.h3.collectnode"/></h3>
<table border="1">
    <tr>
        <td><html:radio property="nodeCollect" styleId="nodeCollect_0" value="0"/></td>
        <td><label for="nodeCollect_0"><bean:message key="csar.nodecollect.node0"/></label></td>
    </tr>
    <tr>
        <td><html:radio property="nodeCollect" styleId="nodeCollect_1" value="1"/></td>
        <td><label for="nodeCollect_1"><bean:message key="csar.nodecollect.node1"/></label></td>
    </tr>
    <tr>
        <td><html:radio property="nodeCollect" styleId="nodeCollect_both" value="both"/></td>
        <td><label for="nodeCollect_both"><bean:message key="csar.nodecollect.bothnode"/></label></td>
    </tr>
</table>
<%}%>
<h3 class="title"><bean:message key="csar.title.h3.collecttype"/></h3>
<table border="1">
    <tr>
        <td><html:radio property="infoType" styleId="infoType_summary" value="summary"/></td>
        <td><label for="infoType_summary"><bean:message key="csar.type.summary"/></label></td>
    </tr>
    <tr>
        <td><html:radio property="infoType" styleId="infoType_full" value="full"/></td>
        <td><label for="infoType_full"><bean:message key="csar.type.full"/></label></td>
    </tr>    
</table>
</html:form>

<html:form action="heartbeat.do?operation=popupHeartbeat" method="post" >
        <input type="hidden" name="startTime" value=""/>
</html:form>
</body>
</html>