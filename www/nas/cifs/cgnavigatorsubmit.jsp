<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cgnavigatorsubmit.jsp,v 1.11 2007/09/12 08:33:47 chenbc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script src="<%=request.getContextPath()%>/common/validation.js"></script>
<script src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript">
function submitCheck() {
    var rootDir = document.forms[0].rootDirectory.value;
    var disDir = document.forms[0].displayedDirectory.value;
    if(document.forms[0].displayedDirectory.value != ""){
        if(!checkPath4Win(document.forms[0].displayedDirectory.value)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.logfile_invalid"/>");
            return false;
        }
    }
    document.forms[0].displayedDirectory.value = compactPath(document.forms[0].displayedDirectory.value);
    disDir = document.forms[0].displayedDirectory.value;
    disDir = getRealPath(disDir);
    if (disDir == "" || disDir == "/") {
        alert("<bean:message key="cg.msg.navigator.alert.no_dir"/>");
        return false;
    }
    
    if (parent.window.opener && !parent.window.opener.closed) {
	if (parent.window.opener.document.forms[0]) {
		parent.window.opener.mpPath.value = disDir;
	}
    }
    parent.close();
}

function initCursor() {

    initDisplayedDir();

	document.forms[0].displayedDirectory.focus();
	try{
        var theText = document.forms[0].displayedDirectory.createTextRange();
        theText.collapse(false);
        theText.select();
    }
    catch(e){}
    finally{}
}

function initDisplayedDir(){
    if(parent.frames[0] && (parent.frames[0].document.forms[0]) && (parent.frames[0].document.forms[0].nowDirectory)){
        parent.frames[0].initDisplayedDir();
    }
}
</script>
</head>
<body onLoad="initCursor();setHelpAnchor('network_cifs_6');" onunload="setHelpAnchor('network_cifs_2');">

<form onSubmit="submitCheck();return false;">

<bean:define id="rootDir" name="rootDirectory"/>
<bean:define id="displayDir" name="displayDirectory"/>

<input type="hidden" name="rootDirectory" value="<%=(String)rootDir%>"/>
<table>
    <tr>
        <td>
            <input type="text" name="displayedDirectory" size="36" value="<%=(String)displayDir%>"/>
            <input type="submit" value='<bean:message key="common.button.select" bundle="common"/>'/>
            <input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()"/>
        </td>
    </tr>
</table>
</form>
</body>
</html:html>
