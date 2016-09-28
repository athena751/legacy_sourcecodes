<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: schedulescansharebottom.jsp,v 1.1 2008/05/08 08:54:48 chenbc Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javaScript">
function enableButton() {
    if(window.parent.frames[0].document &&
       window.parent.frames[0].document.forms[0]) {
        if(window.parent.frames[0].buttonEnable == 1) {
		    document.forms[0].set.disabled = false;
		}else {
            document.forms[0].set.disabled = true;
        }
    }
}

function onSubmit(){
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
        if(window.parent.frames[0].onSetShareInfo()){
            document.forms[0].set.disabled = true;
        }
    }
}
</script>
</head>
<body onload="enableButton();">
<form>
<input type="button" name="set"
	value='<bean:message key="common.button.submit" bundle="common"/>'
	disabled="true" onclick="onSubmit()">
</form>
</body>
</html>
