<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: niclinkdownconfigbottom.jsp,v 1.1 2007/08/24 01:22:19 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-logic" prefix="logic"%>
<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="javaScript">
function onSubmit(){
    if (window.parent.frames[0].document && parent.frames[0].document.forms[0]){
        return parent.frames[0].onSet();
    }
    return false;
}
  
function enableBottomButton() {
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
	    if(window.parent.frames[0].buttonEnable == 1) {
            document.forms[0].elements["set"].disabled = false;
        }else {
            document.forms[0].elements["set"].disabled = true;
        }
    }
}
        
</script>
</head>
<body onload="enableBottomButton();">

<form><input type="button" name="set"
    value='<bean:message key="common.button.submit" bundle="common"/>'
    disabled="true" onclick="onSubmit()"></form>
</body>
</html>

