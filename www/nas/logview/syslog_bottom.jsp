<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: syslog_bottom.jsp,v 1.21 2008/09/24 06:01:12 penghe Exp $" -->

<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8"  buffer="128kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%> 

<%
String sessionID = request.getSession().getId();
%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var hasLoaded = 0;

function init(){
    hasLoaded = 1;
    changeButtonStatus();
    displayAlert();
}

function disableButtons(){
    document.bottomForm.button_viewAll.disabled=1;
    document.bottomForm.button_viewPart.disabled=1;
    document.bottomForm.button_download.disabled=1;
}

function enableButtons(){
    document.bottomForm.button_viewAll.disabled=0;
    document.bottomForm.button_viewPart.disabled=0;
    document.bottomForm.button_download.disabled=0;
}

function changeButtonStatus(){
    //this function is called by the "dataframe" and "topframe"
    if((window.parent.dataframe.document)
        &&(window.parent.dataframe.document.forms[0])
        && (window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"])
        && (window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"].value != "")){
        enableButtons();
    }else{
        disableButtons();
    }
}

var logviewWin;
var heartBeatWin;
var directHeartBeatWin;
var afterSearchtimes = 0;
function popupLogView() {
    if(afterSearchtimes == 1){
        return false;
    }
    
    if (logviewWin != null && !logviewWin.closed){
        logviewWin.focus();
    }else{
        logviewWin = open("/nsadmin/common/commonblank.html","winName","resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=700,height=655,top=0,left=300");
    }
    window.parent.dataframe.document.forms[0].target="winName";
    popUpHeartbeat();      
        
    window.parent.dataframe.document.forms[0].submit();
    afterSearchtimes = 1;
    window.setInterval("afterSearchtimes = 0;",3000);
    return true;
}

function closePopupWin(){
    colseLogViewWin();
    closeHearbeatWin();
}

function colseLogViewWin(){
    if (logviewWin != null && !logviewWin.closed){
        logviewWin.close();
    }
}

function closeHearbeatWin(){
    if (heartBeatWin != null && !heartBeatWin.closed){
        heartBeatWin.close();
    }
    if (directHeartBeatWin != null && !directHeartBeatWin.closed){
        directHeartBeatWin.close();
    }
}

function onViewAll(){
    if(window.parent.dataframe.document.forms[0]){
        window.parent.dataframe.document.forms[0].elements["commonInfo.searchAction"].value="<%=SyslogActionConst.SEARCCH_ACTION_DISPLAY_ALL%>";
        popupLogView();
        return true;
    }
    return false;
}

function onViewPart(){
    if(window.parent.dataframe.document.forms[0]){
        if(window.parent.dataframe.checkInputs()!=true){
            return false;
        }
        if(checkSearchWords(window.parent.dataframe.document.forms[0].elements["commonInfo.searchWords"].value)!=true){
            window.parent.dataframe.document.forms[0].elements["commonInfo.searchWords"].focus();
            return false;
        }
        
        window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value=trim(window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value);
        if(window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value==""){
            window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value=0;
        }else{
            if(checkAroundLines(window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value)!=true){
                window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].focus();
                return false;
            }else{
                window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value=parseInt(window.parent.dataframe.document.forms[0].elements["commonInfo.aroundLines"].value);
            }
        }
        window.parent.dataframe.document.forms[0].elements["commonInfo.searchAction"].value="<%=SyslogActionConst.SEARCCH_ACTION_SEARCH_RESULT_DISPLAY%>";
        popupLogView();
        return true;
    }
    return false;
}

function checkSearchWords(the_value){
    if(the_value.length >128 || the_value.match(/[^!\"#$%&()=~\^\|\[\]\@\+\-\;\:\s\*,\.\/<>?}{_-`0-9a-zA-Z\\]/)){
        alert("<bean:message key="syslog.common.alert.invalidSearchPattern"/>");
        return false;
    }
    return true;
}
function checkAroundLines(the_value){
    if(the_value.match(/[^0-9]/) || (the_value > 50) || (the_value < 0)){
        alert("<bean:message key="syslog.common.alert.invalidAboutLines"/>");
        return false;
    }
    return true;
}
 
function popUpHeartbeat(){
    var date = new Date();
    var starttime = date.getTime();
    document.forms[1].elements["startTime"].value=starttime;
    document.forms[1].elements["logFileName"].value=window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"].value;
    document.forms[1].elements["popupFor"].value="logview"; 
    document.forms[1].elements["logType"].value=window.parent.dataframe.document.forms[0].elements["commonInfo.logType"].value;
    if(window.parent.dataframe.sizeForHeartbeat){
	    document.forms[1].elements["fileSize"].value=window.parent.dataframe.sizeForHeartbeat;
	}else{
		document.forms[1].elements["fileSize"].value=window.parent.topframe.sizeForHeartbeat;
	}     
    if (heartBeatWin != null && !heartBeatWin.closed){
        heartBeatWin.focus();
    }else{
        heartBeatWin = window.open("/nsadmin/common/commonblank.html", "heartbeat",
                "resizable=no,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=410,height=250");
    }
    document.forms[1].target="heartbeat";
    document.forms[1].submit();
}

function popUpDirectHeartbeat(){    
    var date = new Date();
    var starttime = date.getTime();
    document.forms[1].elements["startTime"].value=starttime;
    document.forms[1].elements["popupFor"].value="directDownload";
    if(window.parent.dataframe.sizeForHeartbeat){
	    document.forms[1].elements["fileSize"].value=window.parent.dataframe.sizeForHeartbeat;
	}else{
		document.forms[1].elements["fileSize"].value=window.parent.topframe.sizeForHeartbeat;
	}
	if (directHeartBeatWin != null && !directHeartBeatWin.closed){
        directHeartBeatWin.focus();
    }else{
        directHeartBeatWin = window.open("/nsadmin/common/commonblank.html", "directHeartbeat",
                "resizable=no,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=410,height=210");
    }
    document.forms[1].target="directHeartbeat";
    document.forms[1].submit();
}

function onDownloadBtn(){
    popUpDirectHeartbeat();
    
    window.parent.dataframe.document.directDownloadForm.logType4directDown.value=window.parent.dataframe.document.forms[0].elements["commonInfo.logType"].value;
    window.parent.dataframe.document.directDownloadForm.logFile4directDown.value=window.parent.dataframe.document.forms[0].elements["commonInfo.logFile"].value;
    if(window.parent.dataframe.document.directDownloadForm.logType4directDown.value != "systemLog"){
        window.parent.dataframe.document.directDownloadForm.displayEncoding4directDown.value=window.parent.dataframe.document.forms[0].elements["commonInfo.displayEncoding"].value;
    }
    if(window.parent.dataframe.document.directDownloadForm.logType4directDown.value == "cifsLog"){
        window.parent.dataframe.document.directDownloadForm.cifsSearchEncoding.value=window.parent.dataframe.document.forms[0].elements["cifsSearchInfo.encoding"].value;
    }
    if(window.parent.dataframe.document.directDownloadForm.logType4directDown.value == "systemLog"){
        window.parent.dataframe.document.directDownloadForm.systemAllSearchKeywords.value=window.parent.dataframe.document.forms[0].elements["systemSearchInfo.allKeywords"].value;
    }
    window.parent.dataframe.document.directDownloadForm.target=window.parent.downloadframe.name;
    window.parent.dataframe.document.directDownloadForm.submit();
}
</script>
</head>
<body onload="init();" style="margin: 10px;" onbeforeunload="closePopupWin();">
<form method="POST"  name="bottomForm">
    <displayerror:error h1_key="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>"/>
    <input type="button" name="button_viewAll" onclick="onViewAll();"
        value="<bean:message key="syslog.button.viewAll"/>" />
    &nbsp;
    <input type="button" name="button_viewPart" onclick="onViewPart();"
        value="<bean:message key="syslog.button.viewPart"/>" />
    &nbsp;
    <input type="button" name="button_download" value="<bean:message key="syslog.logview.button_download"/>" 
         onclick="onDownloadBtn();"/>
</form>
<html:form action="heartbeat.do?operation=popupHeartbeat" method="post" >
    <input type="hidden" name="startTime" value=""/>
    <input type="hidden" name="logFileName" value=""/>
    <input type="hidden" name="popupFor" value=""/>
    <input type="hidden" name="logType" value=""/>
    <input type="hidden" name="fileSize" value=""/>
</html:form>
</body>
</html>