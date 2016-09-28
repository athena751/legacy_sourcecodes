<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrmultischeduleaddtop.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@page import="java.util.*,
        com.nec.sydney.atom.admin.base.*,
        com.nec.sydney.atom.admin.ddr.DdrInfo,
        com.nec.sydney.beans.base.*,
        com.nec.sydney.beans.ddr.*,
        com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="scheduleBean" scope="page" class="com.nec.sydney.beans.ddr.DdrScheduleAddBean"/>
<%AbstractJSPBean _abstractJSPBean = scheduleBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%Vector unSchedulePair = scheduleBean.getUnSchedulePair();%>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<script language="JavaScript">
var loaded = 0;
function selectAll(){
    if(!parent.middleframe.document.forms[0].pairCheckbox.length){
    	parent.middleframe.document.forms[0].pairCheckbox.checked=true;
    }else{
    	var len = parent.middleframe.document.forms[0].pairCheckbox.length;
    	for(var i=0; i<len; i++){
    	    parent.middleframe.document.forms[0].pairCheckbox[i].checked=true;
    	}
    }
}

function unselectAll(){
    if(!parent.middleframe.document.forms[0].pairCheckbox.length){
    	parent.middleframe.document.forms[0].pairCheckbox.checked=false;
    }else{
    	var len = parent.middleframe.document.forms[0].pairCheckbox.length;
    	for(var i=0; i<len; i++){
    	    parent.middleframe.document.forms[0].pairCheckbox[i].checked=false;
    	}
    }
}

function topFrameInit(){
    loaded = 1;
    if(parent.middleframe.loaded
            && parent.middleframe.document.forms[0].pairCheckbox){
        document.ddrBatchTopForm.select.disabled = false;
        document.ddrBatchTopForm.unselect.disabled = false;
    }else{
        document.ddrBatchTopForm.select.disabled = true;
        document.ddrBatchTopForm.unselect.disabled = true;
    }
}
</script>

</head>
<body onload="topFrameInit();">
<form name="ddrBatchTopForm" method="post">
    <h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
    <h2 class="title"><nsgui:message key="nas_ddrschedule/schedule_add/h2_multi"/></h2>
    <h3 class="title"><nsgui:message key="nas_ddrschedule/schedule_add/h3_select"/></h3>
    <input type=button name="select" 
        value="<nsgui:message key="nas_ddrschedule/schedule_add/selectall"/>" onclick="selectAll()"/>
    <input type=button name="unselect" 
        value="<nsgui:message key="nas_ddrschedule/schedule_add/unselectall"/>" onclick="unselectAll()"/>
</form>
</body>
</html>

