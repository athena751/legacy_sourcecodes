<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: directeditbottom.jsp,v 1.1 2005/06/22 08:11:10 wangzf Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javascript">
var loaded=0;
function onSave(){
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    parent.frames[0].document.forms[0].submit();
    document.forms[0].set.disabled = true;
    document.forms[0].reset.disabled = true;    
    return true;
}

function resetTopFrame() {
    if(parent.frames[0] && parent.frames[0].loaded==1) {
        parent.frames[0].document.forms[0].reset();
        return true;
    }
    return false;
}

function init() {
    loaded=1;
	if(parent.frames[0] && parent.frames[0].loaded==1) {
        document.forms[0].set.disabled = false;
        document.forms[0].reset.disabled = false;
	}
}
</script>
</head>
<body onload="init()">
<form>
    <html:button disabled="true" property="set" onclick="return onSave()">
        <bean:message key="common.button.submit" bundle="common"/>
    </html:button>
    <html:button disabled="true" property="reset" onclick="return resetTopFrame()">
       <bean:message key="common.button.reset" bundle="common"/>
    </html:button>
</form>
</body>
</html>