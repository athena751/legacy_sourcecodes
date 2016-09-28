<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrpairinglistbottom.jsp,v 1.2 2008/05/27 07:13:45 liy Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@page import="com.nec.sydney.framework.*"%>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<script language="javaScript">
var loaded = 0;
function bottomFrameInit(){
    loaded = 1;
    if(parent.frames[0].loaded){
    	if(parent.frames[0].document.forms[0] && 
    			parent.frames[0].document.forms[0].ddrSign){
        	document.ddrListbottomForm.openScheduleList.disabled=0;
        }else{        
        	document.ddrListbottomForm.openScheduleList.disabled=1;
        }
    }
}
function onSchedule(){
    if(!parent.frames[0].loaded || document.ddrListbottomForm.openScheduleList.disabled){
        return false;
    }
    if(isSubmitted()){
        setSubmitted();
        var radioName = parent.frames[0].document.forms[0].pairingRadio;
        var selectedMvAndRv = new Array();
        if(!radioName.length){
             if(radioName.checked == 1){
                selectedMvAndRv = radioName.value.split(":");
             }
        }else{
            for (var i=0 ; i<radioName.length; i++) {
                if (radioName[i].checked == 1) { 
                    selectedMvAndRv = radioName[i].value.split(":");
                    break; 
                }
            }
        }
        parent.location="<%=response.encodeURL("ddrschedulelist.jsp")%>?mvName="
                            +selectedMvAndRv[0]+"&rvName="+selectedMvAndRv[1];
        return true;
    }
    return false;
}
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body onload="bottomFrameInit();">
<form name="ddrListbottomForm" method="post">
<input type="button" name="openScheduleList" 
    value="<nsgui:message key="nas_ddrschedule/pairinglist/button_schList"/>"
    onclick="return onSchedule();" onfocus="if(this.disabled) this.blur();" disabled/>
</form>
</body>
</html>
