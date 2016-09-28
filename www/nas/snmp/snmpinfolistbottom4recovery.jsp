<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snmpinfolistbottom4recovery.jsp,v 1.2 2005/08/21 06:28:30 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
<title><bean:message key="snmp.common.h1"/></title>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
var loaded = 0;
function init() {
    loaded = 1;
    if(parent.frames[0].stateFlag) {
            document.forms[0].recoveryApply0.disabled=false;
            document.forms[0].recoveryApply1.disabled=false;
    }
}

function onRecoveryApply(nodeNumber) {
    if (isSubmitted()){
        return false;
    }
    if(nodeNumber==0){
        if(!confirm('<bean:message key="common.confirm"         bundle="common"/>\r\n'+
                    '<bean:message key="common.confirm.action"  bundle="common"/>'+
                    '<bean:message key="common.button.recovery.node0" bundle="common"/>')){
            return false;
        } 
    }else {
       if(!confirm('<bean:message key="common.confirm"         bundle="common"/>\r\n'+
                    '<bean:message key="common.confirm.action"  bundle="common"/>'+
                    '<bean:message key="common.button.recovery.node1" bundle="common"/>')){
            return false;
        } 
    }
    setSubmitted(); 
    document.forms[0].action="snmpInfoList.do?operation=apply&nodeNo="+nodeNumber;
    document.forms[0].submit();
    return true;
}
</script>
</head> 

<body onload="init()">
    <form method="post" target="_parent">
        <html:button property="recoveryApply0" disabled="true" onclick="return onRecoveryApply('0')"><bean:message key="common.button.recovery.node0" bundle="common"/></html:button>&nbsp;&nbsp;
        <html:button property="recoveryApply1" disabled="true" onclick="return onRecoveryApply('1')"><bean:message key="common.button.recovery.node1" bundle="common"/></html:button>
    </form>
</body>
</html>