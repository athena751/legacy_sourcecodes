<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: serverprotectscanserverbottom.jsp,v 1.1 2007/03/23 09:43:18 liul Exp $" -->

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
function onNvavsSet(){
    if(parent.frames[0].submitSet()){
        document.forms[0].nvavsSet.disabled=true;
        document.forms[0].nvavsDelete.disabled=true;
        return true;
    }
    return false;
}

function onNvavsDelete(){
    if(parent.frames[0].submitDelete()){
        document.forms[0].nvavsSet.disabled=true;
        document.forms[0].nvavsDelete.disabled=true;
        return true;
    }
    return false;
}

function  init(){
    loaded=1;
    if(parent.frames[0] && parent.frames[0].loaded==1 && parent.frames[0].enableDeleteBtn==1) {
        document.forms[0].nvavsDelete.disabled=false;
    }
    if(parent.frames[0] && parent.frames[0].loaded==1 && parent.frames[0].enableSetBtn==1) {
        document.forms[0].nvavsSet.disabled=false;
    }
}
</script>
</head>

<body onload="init();">
<form>
<input type="button" name="nvavsSet" disabled="true" 
       onclick="onNvavsSet()" 
       value='<bean:message key="common.button.submit" bundle="common"/>'/>

&nbsp;&nbsp;&nbsp;&nbsp;

<input type="button" name="nvavsDelete" disabled="true"         
       onclick="onNvavsDelete()"         
       value='<bean:message key="common.button.delete" bundle="common"/>'/>
       
</form>
</body>
</html>