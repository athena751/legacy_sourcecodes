<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: directDownHeartbeat.jsp,v 1.2 2008/05/09 05:06:56 hetao Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<bean:define id="startTime" name="logview_directDown_startTime" type="java.lang.String"/>
<bean:define id="fileSize" name="logview_log_file_size" type="java.lang.String"/>
<%
    String frameNo = request.getParameter("frameNo");
%>
<%if(frameNo.equals("0")){%>
<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<title><bean:message key="<%=h1_Key%>"/></title>
</head>
<frameset rows=100,0 >
    <frame marginwidth=10 marginheight=20 name="mainFrame" frameborder="no" scrolling="auto" src="loadDirectHeartbeat_display.do">
    <frame marginwidth=0 marginheight=0 name="hideFrame" frameborder="no" scrolling="no" src="loadDirectHeartbeat_hidden.do">
</frameset>
</html>
<%}else if(frameNo.equals("1")){%>
<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="javascript">
var fileSize = '<%=fileSize%>';
var fFileSize;
var loaded = 0;
var firstTime = 1;

function refreshProgress(size){
    if(firstTime){
    	firstTime = 0;
    	return;
    }
    if(fileSize == "" || size == ""){
    	return;
    }
	var fSize = formatSizeStr(size);
	var leftSize = fileSize - size;
	if(leftSize < 0){
		leftSize = 0;
	}
	var now = new Date();
    var spendtime = parseInt((now.getTime() - <%=startTime%>) / 1000);
    if(spendtime != 0 && size != 0){
        var speed = size/spendtime;
		var leftTime = Math.round(leftSize/speed);
		document.getElementById("lTime").innerHTML = formatTimeStr(leftTime);
	}
	if(fileSize != 0){
	    var progress = size*100/fileSize;
	    if(progress > 100){
	    	progress = 100;
	    }
	    progress = parseFloat(progress).toFixed(1);
		document.getElementById("progress").innerHTML = progress + "%(" + fSize + "/" + fFileSize + ")";
	}
}

function formatSizeStr(size){
    //only support the size under 1024 GB
	var fSize = size;
	var unit = 0;
	while(fSize > 1024 && unit < 3){
		unit++;
		fSize /= 1024;
	}
	fSize = parseFloat(fSize).toFixed(1);
	switch(unit){
		case 0: fSize += "B";break;
		case 1: fSize += "KB";break;
		case 2: fSize += "MB";break;
		case 3: fSize += "GB";break;
	} 
	return fSize;
}

function formatTimeStr(time){
	var fTime = "";
	var hour = Math.floor(parseInt(time)/3600);
	var min_sec = parseInt(time)%3600;
	var min = Math.floor(min_sec/60);
	var sec = min_sec%60;
    if(hour != 0){
    	fTime += hour + " <bean:message key="nfs.perfomrLog.heartbeat.msg.timeUnit_hour"/> ";
    }
    if(min != 0){
    	fTime += min + " <bean:message key="nfs.perfomrLog.heartbeat.msg.timeUnit_minute"/> ";
    }
    fTime += sec + " <bean:message key="nfs.perfomrLog.heartbeat.msg.timeUnit_sencond"/> ";
	return fTime;
}

function pageLoad(){
    var old = new Date();
    old.setTime(<%=startTime%>);
    var oldtime = old.getHours() + " : " + old.getMinutes() + " : " + old.getSeconds();
    document.getElementById("sTime").innerHTML = " " + oldtime + " ";
    window.setInterval("fnRecycle()",1000);
    fFileSize = formatSizeStr(fileSize);
    loaded = 1;
    return true;
}

function fnRecycle(){
    var now = new Date();
    var spendtime = parseInt((now.getTime() - <%=startTime%>) / 1000);
    document.getElementById("pTime").innerHTML  = formatTimeStr(spendtime);
}

</script>
</head>
<body onload="pageLoad();">
<form>

<h3><bean:message key="nfs.perfomrLog.heartbeat.msg.startTime"/>: <label id="sTime">
<bean:message key="syslog.common.double_hyphen"/> : 
<bean:message key="syslog.common.double_hyphen"/> : 
<bean:message key="syslog.common.double_hyphen"/>
</label></h3>
<h3><bean:message key="nfs.perfomrLog.heartbeat.msg.spendTime"/>: <label id="pTime"><bean:message key="syslog.common.double_hyphen"/></label></h3>
<h3><bean:message key="nfs.perfomrLog.heartbeat.msg.progress"/>: <label id="progress"><bean:message key="syslog.common.double_hyphen"/></label></h3>
<h3><bean:message key="nfs.perfomrLog.heartbeat.msg.estimatedTime"/>: <label id="lTime"><bean:message key="syslog.common.double_hyphen"/></label></h3>
<b><bean:message key="nfs.perfomrLog.heartbeat.msg.usedTimeInfoForDownload"/></b>
</form>
</body>
</html>
<%}else if(frameNo.equals("2")){%>

<html>
<head>
<% 
	String interval = "5";
	if(!fileSize.equals("") && Long.parseLong(fileSize) < 100*1024*1024){ 
		interval = "2";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Refresh" CONTENT="<%=interval%>">
<script language="javascript">
<bean:define id="logType" name="logview_search_logType" type="java.lang.String"/>
var sizeNow = '<%=com.nec.nsgui.model.biz.syslog.SyslogCmdHandler.getTmpFileSize(request.getSession().getId(),logType)%>';
function pageLoad(){
    <logic:equal name="<%=SyslogActionConst.SESSION_NAME_DIRECTDOWNLOAD_MAKEFILE_ENDED%>"
     value="<%=SyslogActionConst.DIRECTDOWN_MAKEFILE_ENDED%>">
        top.close();
    </logic:equal>
    if(parent.mainFrame.loaded == 1){
	    parent.mainFrame.refreshProgress(sizeNow);
	}
    return true;
}
</script>
</head>
<body onload="pageLoad();">
</body>
</html>
<%}%>