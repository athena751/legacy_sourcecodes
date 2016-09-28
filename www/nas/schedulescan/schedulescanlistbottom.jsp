<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: schedulescanlistbottom.jsp,v 1.1 2008/05/08 08:54:48 chenbc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-logic" prefix="logic"%>
<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
 function changeButtonStatus(){
         if(window.parent.frames[0].document) {
             if(window.parent.frames[0].document.forms[0]) {
                if(window.parent.frames[0].buttonEnable == 1){
                    document.forms[0].settingDelete.disabled = false;
                }
                else {
                    document.forms[0].settingDelete.disabled = true;
                }
            }
        }
 } 
 
function onDelete(){
    if (window.parent.frames[0]){
        if(window.parent.frames[0].setDelete()){
            window.parent.frames[0].onDelete();
        }
    }
}
 </script>
</head>
<body onload="changeButtonStatus();">
<form><input type="button" name="settingDelete" disabled="true" onclick="onDelete();"
	value="<bean:message key="common.button.delete" bundle="common"/>" /></form>
</body>
</html>
