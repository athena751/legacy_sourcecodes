<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsDirAccessListBottom.jsp,v 1.1 2005/05/26 01:23:42 baiwq Exp $" -->

<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onModify(){
    if(window.parent.dirAccess_topframe.document.forms[0].directory){
        return window.parent.dirAccess_topframe.onModifyDirAccessControl();
    }
    return false;
}

function onDelete(){
    if(window.parent.dirAccess_topframe.document.forms[0].directory){
        return window.parent.dirAccess_topframe.onDeleteDirAccessControl();
    }
    return false;
}

function changeButtonStatus(){
    if(window.parent.dirAccess_topframe.document.forms[0] && window.parent.dirAccess_topframe.document.forms[0].directory){
        disableButtons(false);
    }else{
        disableButtons(true);
    }
}

function disableButtons(statusValue){
    document.forms[0].button_modify.disabled=statusValue;
    document.forms[0].button_delete.disabled=statusValue;
}

</script>
</head>
<body onload="changeButtonStatus();" style="margin: 10px;">
<form method="POST"  name="dirAccessControlListBottomForm">
    <input type="button" name="button_modify" onclick="onModify()"
        value="<bean:message key="common.button.modify2" bundle="common"/>" />
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="button" name="button_delete" onclick="onDelete()"
        value="<bean:message key="common.button.delete" bundle="common"/>" />

</form>
</body>
</html>