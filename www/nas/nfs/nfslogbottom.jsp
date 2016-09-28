<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfslogbottom.jsp,v 1.1 2005/06/22 08:17:58 wangzf Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="javascript">
var loaded=0;
function submitTopFrame(btn) {
    if(parent.frames[0].onLogSet()){
        btn.disabled=true;
        return true;
    }
    return false;
}

function init() {
    loaded=1;
    if(parent.frames[0] && parent.frames[0].loaded==1) {
        document.forms[0].set.disabled=false;
    }
}
</script>
</head>
<body onload="init()">
<form>
<html:button property="set" disabled="true" onclick="return submitTopFrame(this)"><bean:message key="common.button.submit" bundle="common"/></html:button>
</form>
</body>
</html>