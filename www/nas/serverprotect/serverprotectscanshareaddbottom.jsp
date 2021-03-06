<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: serverprotectscanshareaddbottom.jsp,v 1.3 2007/03/30 06:38:08 liul Exp $" -->

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

function onSetAdd(){
    if (isSubmitted()){
        return false;
    }
    parent.frames[0].setAdd();
    var share=parent.frames[0].document.forms[0].selectedShare.value;
    if(share==""){
        alert('<bean:message key="serverprotect.alert.noshareselect"/>');
        return false;
    }
    if(parent.frames[0].daemonState=="inactive"){
        alert('<bean:message key="serverprotect.alert.inactivedaemon"/>');
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    parent.frames[0].document.forms[0].goBack.disabled=true;
    parent.frames[0].document.forms[0].target = "_parent";
    parent.frames[0].document.forms[0].submit();
    
    return true;
}

function  init(){
    loaded=1;
    if(parent.frames[0] && parent.frames[0].loaded==1) {
        document.forms[0].setAdd.disabled=false;
    }
}
</script>
</head>

<body onload="init();">
<form>
<input type="button" name="setAdd" disabled="true" 
       onclick="onSetAdd()" 
       value='<bean:message key="common.button.submit" bundle="common"/>'/>

       
</form>
</body>
</html>