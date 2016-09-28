<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrmultischeduleaddbottom.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@page import="java.util.*,
        com.nec.sydney.atom.admin.base.*,
        com.nec.sydney.framework.*"%>
<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<%@include file="ddrcommon.js" %>
<script language="JavaScript">
var loaded = 0;
function bottomFrameInit(){
    loaded = 1;
    initSchedule(document.ddrBatchBottomForm);
    if(parent.middleframe.loaded 
            && parent.middleframe.document.forms[0].pairCheckbox){
        document.ddrBatchBottomForm.addSchedule.disabled=false;
    }else{
        document.ddrBatchBottomForm.addSchedule.disabled=true;
    }
}

function checkSelect(){
    var selectedPairValue = new Array();
    var middleForm = parent.middleframe.document.forms[0];
    if(middleForm.pairCheckbox && middleForm.pairCheckbox.length){
    	var len = middleForm.pairCheckbox.length;
    	for(var i=0; i<len; i++){
            if(middleForm.pairCheckbox[i].checked == 1){
                selectedPairValue.push(middleForm.pairCheckbox[i].value); 
            }
    	}
        if(selectedPairValue.length>0){
            document.ddrBatchBottomForm.pairName.value=selectedPairValue.join(":");
            return true;
        }
    	return false;
    }else{
    	if(middleForm.pairCheckbox && middleForm.pairCheckbox.checked == 1){
    	    document.ddrBatchBottomForm.pairName.value
    	            = middleForm.pairCheckbox.value;
    	    return true;
    	}else{
    	    return false;
    	}
    }
}

function onAddSchedule(form){
    if(form.addSchedule.disabled){
    	return false;
    }
    if(checkSelect()){
        if(isSubmitted() && checkSchedule(form)){
            setSubmitted();
            return true;
        }
    }else{
    	alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + "<nsgui:message key="nas_ddrschedule/alert/no_select"/>");
    	return false;
    }
    return false;
}

function displayAlert(){
    <%String alertMSG = (String)session.getAttribute("alertMessage");
    session.setAttribute("alertMessage",null);
    if(alertMSG != null){%>
        if(document.ddrBatchBottomForm.alertFlag 
                && document.ddrBatchBottomForm.alertFlag.value=="enable"){
            alert("<%=alertMSG%>");
            document.ddrBatchBottomForm.alertFlag.value="disable";
        }
    <%}%>
}
</script>
<jsp:include page="../../../menu/common/wait.jsp"/>
</head>
<body onload="bottomFrameInit();displayAlert();">
<form name="ddrBatchBottomForm" onsubmit="return onAddSchedule(this)"
                                    action="ddrscheduleforward.jsp" method="post">
<h3 class="title"><nsgui:message key="nas_ddrschedule/schedule_add/h3_multi"/></h3>
<%@include file="ddrschedulecommon.jsp" %>
<input type=hidden name="pairName" value="" />
<input type=hidden name="operation" value="multiAdd" />
<input type=hidden name="alertFlag" value="enable" />
</form>
</body>
</html>