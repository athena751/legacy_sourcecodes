<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: mapdnavigatorsubmit.jsp,v 1.3 2007/09/12 09:46:45 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>

<script src="<%=request.getContextPath()%>/common/validation.js"></script>
<script language="JavaScript">
function submitCheck() {
    var rootDir = document.forms[0].rootDirectory.value;
    var disDir = document.forms[0].displayedDirectory.value;
    
    if (disDir == "") {
        alert("<bean:message key="msg.navigator.alert.no_file"/>");
        return false;
    }

    if (parent.frames[0].document.forms[0]) {
        if (parent.frames[0].document.forms[0].selectType.value == "directory") {
            alert("<bean:message key="msg.navigator.alert.no_file"/>");
            return false;
        }
    }
    
    var fullPath;
    if (disDir != "") {
        fullPath = rootDir + "/" + disDir;
    } else {
        fullPath = rootDir;
    }
    
    if (parent.window.opener && !parent.window.opener.closed) {
	if (parent.window.opener.document.forms[0]) {
		parent.window.opener.mpPath.value = fullPath;
	}
    }
    parent.close();
}

</script>
</head>
<body>

<form onSubmit="submitCheck();return false;">

<bean:define id="rootDir" name="rootDirectory" />
<bean:define id="nowDir" name="nowDirectory" />
<bean:define id="displayDir" name="displayDirectory" />

<input type="hidden" name="rootDirectory" value="<%=(String)rootDir%>"/>
<table>
    <tr>
        <td>
            <%=rootDir%>/
        </td>
        <td>
            <input type="text" name="displayedDirectory" value="<%=(String)displayDir%>" onFocus="this.blur()" readonly />
            <input type="submit" value='<bean:message key="common.button.select" bundle="common"/>' />
            <input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()" />
        </td>
    </tr>
</table>
</form>
</body>
</html:html>


