<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrsinglescheduleadd.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@page import="com.nec.sydney.framework.*"%>
<html>
<head>
<title><nsgui:message key="nas_ddrschedule/schedule_add/h2"/></title>
<%@include file="../../../menu/common/meta.jsp" %>
<jsp:include page="../../../menu/common/wait.jsp"/>
<%@include file="ddrcommon.js" %>
<script language="JavaScript">
function onAddSchedule(form){
	if(isSubmitted() && checkSchedule(form)){
		setSubmitted();
		return true;
	}
	return false;
}
function displayAlert(){
     <%String alertMSG = (String)session.getAttribute("alertMessage");
    session.setAttribute("alertMessage",null);
    if(alertMSG != null){%>
        if(document.forms[0].alertFlag && document.forms[0].alertFlag.value=="enable"){
            alert("<%=alertMSG%>");
            document.forms[0].alertFlag.value="disable";
        }
    <%}%>
}
</script>
</head>
<body onload="initSchedule(document.schedule);displayAlert();">
<%String mv,rv;
mv = request.getParameter("mvName");
rv = request.getParameter("rvName");
%>
<form name=schedule onsubmit="return onAddSchedule(this)" action="ddrscheduleforward.jsp" method="post">
<h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
<h2 class="title"><nsgui:message key="nas_ddrschedule/schedule_add/h2"/>
[MV:<%=mv%> RV:<%=rv%>]
</h2>
<%@include file="ddrschedulecommon.jsp" %>
<input type=hidden name="mvName" value="<%=mv%>" />
<input type=hidden name="rvName" value="<%=rv%>" />
<input type=hidden name="operation" value="singleAdd" />
<input type=hidden name="alertFlag" value="enable" />
</form>
</body>
</html>