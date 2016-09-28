<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: heartbeat.jsp,v 1.2302 2007/09/12 08:34:35 chenbc Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<%
    session.setAttribute(NasSession.MP_SESSION_END_WAIT , "");
    String frameNo = request.getParameter("frameNo");

    if(frameNo.equals("0")){
        String startTime = (String)request.getParameter("starttime");
%>
<frameset rows=100,0 >
    <frame marginwidth=10 marginheight=20 name="mainFrame" frameborder="no" scrolling="auto" src=<%= response.encodeURL("heartbeat.jsp") %>?frameNo=1&starttime=<%=startTime%>>
    <frame marginwidth=0 marginheight=0 name="hideFrame" frameborder="no" scrolling="no" src=<%= response.encodeURL("heartbeat.jsp") %>?frameNo=2 >
</frameset>
<%  }else if(frameNo.equals("1")){
        String startTime = (String)request.getParameter("starttime");
%>
<html>
<head>
<title><nsgui:message key="nas_common/common/title_wait"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javascript">
function pageLoad(){
    var old = new Date();
    old.setTime(<%=startTime%>);
    var oldtime = old.getHours() + " : " + old.getMinutes() + " : " + old.getSeconds();
    //var hour = formatTime(old.getHours());
    //var minute = formatTime(old.getMinutes());
    //var second = formatTime(old.getSeconds());
    //var oldtime =  hour + " : " + minute + " : " + second;

    document.forms[0].oTime.value = " " + oldtime + " ";
    window.setInterval("fnRecycle()",1000);
    return true;
}

/*
function formatTime(i_time) {
    while((i_time + " ").length < 3) {
        i_time = "0" + i_time;
    }
    return i_time;
}
*/

function formatSpendTime(i_sTime) {
    while((i_sTime + " ").length < 7) {
        i_sTime = " " + i_sTime;
    }
    return i_sTime;
}

function fnRecycle(){
    var now = new Date();
    var spendtime = parseInt((now.getTime() - <%=startTime%>) / 1000);
    //sTime.innerHTML=" " + spendtime + " ";
    document.forms[0].sTime.value = formatSpendTime(spendtime);
}
</script>
</head>
<body onload="pageLoad()">
<form>
<h3 class="title"><nsgui:message key="nas_common/common/msg_start"/>:
<input type="text" name="oTime" size="14" style='border-width:0px;' readonly >
</h3>
<h3 class="title"><nsgui:message key="nas_common/common/msg_spend"/>:
<input type="text" name="sTime" value="     0" size="7" style='border-width:0px;' readonly >
<nsgui:message key="nas_common/common/msg_second"/></h3>
<b><nsgui:message key="nas_common/common/msg_wait"/></b>
</form>
</body>
</html>
<% }else {
    String end_wait = (String)session.getAttribute(NasSession.MP_SESSION_END_WAIT);
%>
<html>
<head>
<title><nsgui:message key="nas_common/common/title_wait"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
<meta HTTP-EQUIV="Refresh" CONTENT="5">
<script language="javascript">
function pageLoad(finish){
    if(finish == "<%=NasConstants.MKFS_FINISHED%>") {
        top.close();
        return false;
    }
    return true;
}
</script>
</head>
<body onload="pageLoad('<%=end_wait%>')">
</body>
</html>
<% } %>