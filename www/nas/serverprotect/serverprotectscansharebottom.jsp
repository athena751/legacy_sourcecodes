<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: serverprotectscansharebottom.jsp,v 1.1 2007/03/23 09:43:18 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
var loaded=0;
function onShareModify(){
    if (isSubmitted()){
        return false;
    }
    if(!parent.frames[0].loaded){
        return false;
    }
       
    setSubmitted(); 
    disableButtons();   
    parent.frames[0].document.forms[0].action="../../serverprotect/serverProtectDisplayScanShareModify.do";
    parent.frames[0].document.forms[0].target = "_parent";
    parent.frames[0].document.forms[0].submit();
    return true;
}

function disableButtons(){
    document.forms[0].shareModify.disabled=1;
    document.forms[0].shareDelete.disabled=1;
    parent.frames[0].document.forms[0].shareAdd.disabled=1;
    parent.frames[0].document.forms[0].refresh.disabled=1;
}

function onShareDelete(){
    if (isSubmitted()){
        return false;
    }
    if(!parent.frames[0].loaded){
        return false;
    }
    if (confirm('<bean:message key="common.confirm" bundle="common" />' + "\r\n"
            + '<bean:message key="common.confirm.action" bundle="common" />' 
            + '<bean:message key="common.button.delete" bundle="common"/>'  + "\r\n"
            + '<bean:message key="serverprotect.th.sharename"/>:' 
            + parent.frames[0].document.forms[0].selectedShare.value)){ 
        setSubmitted();     
        disableButtons();
        parent.frames[0].document.forms[0].target = "_parent";
        parent.frames[0].document.forms[0].action="../../serverprotect/serverProtectScanShare.do?operation=delete";  
        parent.frames[0].document.forms[0].submit();
        return true; 
    }
    
    return false;
}

function  init(){
    loaded=1;
    if(parent.frames[0] && parent.frames[0].loaded==1 && parent.frames[0].enableDeleteBtn==1) {
        document.forms[0].shareDelete.disabled=false;
    }
    if(parent.frames[0] && parent.frames[0].loaded==1 && parent.frames[0].enableModBtn==1) {
        document.forms[0].shareModify.disabled=false;
    }
}
</script>
</head>

<body onload="init();">
<form>
<input type="button" name="shareModify" disabled="true" 
       onclick="onShareModify()" 
       value="<bean:message key="common.button.modify2" bundle="common"/>"/>

&nbsp;&nbsp;&nbsp;&nbsp;

<input type="button" name="shareDelete" disabled="true"         
       onclick="onShareDelete()"         
       value="<bean:message key="common.button.delete" bundle="common"/>"/>
       
</form>
</body>
</html>