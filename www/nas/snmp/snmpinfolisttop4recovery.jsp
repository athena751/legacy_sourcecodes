<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snmpinfolisttop4recovery.jsp,v 1.3 2005/10/25 08:53:46 cuihw Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,com.nec.nsgui.action.base.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<html>
<head>
<title><bean:message key="snmp.common.h1"/></title>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
var stateFlag=0;
function init() {
    <logic:notPresent name="SESSION_SNMP_RECOVERYCONVERTFAILED" scope="session">
        stateFlag=1; 
        if(parent.frames[1].loaded){
            parent.frames[1].document.forms[0].recoveryApply0.disabled=false;
            parent.frames[1].document.forms[0].recoveryApply1.disabled=false;                      
        } 
    </logic:notPresent> 
}
function onRefresh() {
	if(isSubmitted()){
	    return false;
	}
	setSubmitted();
	window.parent.location="<html:rewrite page='/snmpInfoList.do?operation=displayList'/>";
	return true;
}
</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('system_snmp_1');" onUnload="closeDetailErrorWin()"> 
    <displayerror:error h1_key="snmp.common.h1"/>
<form method="post">
    <html:button property="refreshInfo" onclick="return onRefresh();">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
</form>
	<%@include file="snmpcommoninfolist4recovery.jsp" %>
</body>
</html>