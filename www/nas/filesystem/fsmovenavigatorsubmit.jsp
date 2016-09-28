<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: fsmovenavigatorsubmit.jsp,v 1.4 2007/09/13 01:18:48 pizb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>

<script src="<%=request.getContextPath()%>/common/validation.js"></script>
<script language="JavaScript">
function submitCheck() {
    document.forms[0].displayedDirectory.value = compactPath(document.forms[0].displayedDirectory.value);
    
    if (parent.window.opener && !parent.window.opener.closed) {
        if (parent.window.opener.document.forms[0]) {
           parent.window.opener.mpPath.value = document.forms[0].displayedDirectory.value;
	    }
    }
    parent.close();
}

function initCursor() {
	document.forms[0].displayedDirectory.focus();
	try{
        var theText = document.forms[0].displayedDirectory.createTextRange();
        theText.collapse(false);
        theText.select();
    }
    catch(e){}
    finally{}
}
</script>
</head>
<body onLoad="initCursor()">

<form onSubmit="submitCheck();return false;">

<bean:define id="rootDir" name="rootDirectory"/>
<bean:define id="nowDir" name="nowDirectory"/>
<bean:define id="displayDir" name="displayDirectory"/>
<input type="hidden" name="rootDirectory" value="<%=(String)rootDir%>"/>
<table>
    <tr>
        <td>
            <%=rootDir%>/
        </td>
        <td>
            <input type="text" name="displayedDirectory" value="<%=(String)displayDir%>"/>
            <input type="submit" value='<bean:message key="common.button.select" bundle="common"/>'/>
            <input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()"/>
        </td>
    </tr>
</table>
</form>
</body>
</html:html>


