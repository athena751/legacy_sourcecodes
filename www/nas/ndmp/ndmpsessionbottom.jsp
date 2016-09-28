<!--
        Copyright (c) 2006-2007 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: ndmpsessionbottom.jsp,v 1.4 2007/05/09 05:52:21 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<head>
<%@include file="../../common/head.jsp" %>
<SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<script language="JavaScript">

var popUpWinName;
function init(){
    if(window.parent.frames[0] && window.parent.frames[0].document && window.parent.frames[0].document.ndmpSessionForm){
        window.parent.frames[0].init();
    }
}

function onDetail(){
	if(window.parent.frames[0] && window.parent.frames[0].document.forms[0] && window.parent.frames[0].document.forms[0].sessionID){
        popUpWinName = window.open("/nsadmin/common/commonblank.html","sessionDetail",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=480,height=540");
        window.parent.frames[0].setSessionId();
        window.parent.frames[0].document.forms[0].action = "ndmpSessionAction.do?operation=displayDetail";
        window.parent.frames[0].document.forms[0].target = "sessionDetail";
        popUpWinName.focus();
        window.parent.frames[0].document.forms[0].submit();
        return true;
    }else{
        return false;
    }
}
</script>
</head>
<html:html lang="true">
<body onload="init();" onUnload="closePopupWin(popUpWinName);">
<form name="sessionInfoBottom" method="POST">
<nobr>
    <input type="button" name="sessionDetail" onclick="onDetail()" disabled="true"
        value="<bean:message key="common.button.detail2" bundle="common"/>"/>
</nobr>
</form>
</body>
</html:html>