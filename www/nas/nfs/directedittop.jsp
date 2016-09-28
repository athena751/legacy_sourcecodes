<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: directedittop.jsp,v 1.2 2005/10/20 00:22:32 xingh Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.nec.sydney.framework.*"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
var loaded=0;
function displayWarnning(){
    if(document.forms[0].operation.value == 'display'){
        alert('<bean:message key="alert.nfs.direct.edit"/>');
    }
}

function init() {
    loaded=1;
    if(parent.frames[1] && parent.frames[1].loaded==1) {
	    parent.frames[1].document.forms[0].set.disabled = false;
	    parent.frames[1].document.forms[0].reset.disabled = false;
    }
}

function reloadPage(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="<html:rewrite page='/directEditTop.do?operation=reload'/>";
}
</script>
</head>
<body onload="displayAlert();displayWarnning();setHelpAnchor('network_nfs_5');init();" onUnload="closeDetailErrorWin();">
<displayerror:error h1_key="title.nfs"/>
<html:form action="directEditTop.do?operation=save" method="POST">
<input type="button" name="refresh" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="reloadPage()"/>
<br><br>
    <html:hidden property="operation" />
    <textarea name="fileContent" wrap="off" rows="20" cols="60" style='width:100%;'>
<nested:write property="fileContent"/></textarea>
</html:form>
</body>
</html>