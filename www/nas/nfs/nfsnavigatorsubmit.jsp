<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsnavigatorsubmit.jsp,v 1.3 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<html:base/>
<script src="<%=request.getContextPath()%>/common/validation.js"></script>
<script language="JavaScript" src="nfscommon.js"></script>
<script language="JavaScript">
var loaded=0;

function init() {
    loaded=1;
}

function submitCheck() {
    var rootDir = document.forms[0].rootDirectory.value;
    var disDir = document.forms[0].displayedDirectory.value;
    document.forms[0].displayedDirectory.value = compactPath(document.forms[0].displayedDirectory.value);
    disDir = document.forms[0].displayedDirectory.value;
    
    if (disDir == "") {
        alert("<bean:message key="msg.navigator.alert.no_dir"/>");
        return false;
    }
    
    var fullPath;
    if (disDir != "") {
        fullPath = rootDir + "/" + disDir;
    } else {
        fullPath = rootDir;
    }
    
    if (fullPath.length > 1023){
        alert("<bean:message key="common.alert.failed" bundle="common"/>"  + "\r\n" 
             + "<bean:message key="msg.navigator.alert.over_max"/>");
        return false;                
    }
   
    if (parent.window.opener && !parent.window.opener.closed) {
	if (parent.window.opener.document.forms[0]) {
            parent.window.opener.document.forms[0].selectedDir.value = disDir;

            parent.window.opener.needAuthDomain = (document.forms[0].hasDomain.value==0);
            parent.window.opener.isSxfsfw = (document.forms[0].fsType.value == "sxfsfw");
            parent.window.opener.isSubMountPoint = (document.forms[0].isSubMount.value==1);
	
            resetStatus(parent.window.opener);
	}
    }
    parent.close();
}
</script>
</head>
<body onload="init()">

<form onSubmit="submitCheck();return false;">

<bean:define id="rootDir" name="nfs_rootDirectory"/>
<bean:define id="nowDir" name="nfs_nowDirectory"/>
<bean:define id="displayDir" name="nfs_displayDirectory"/>
<bean:define id="fsType" name="nfs_fsType"/>
<bean:define id="isSubMount" name="nfs_isSubMount"/>
<bean:define id="hasDomain" name="nfs_hasDomain"/>

<input type="hidden" name="rootDirectory" value="<%=(String)rootDir%>"/>
<input type="hidden" name="fsType" value="<%=(String)fsType%>"/>
<input type="hidden" name="isSubMount" value="<%=(String)isSubMount%>"/>
<input type="hidden" name="hasDomain" value="<%=(String)hasDomain%>"/>
<table>
    <tr>
        <td>
            <%=rootDir%>/
        </td>
        <td>
            <input type="text" readonly name="displayedDirectory" value="<%=(String)displayDir%>" onfocus="this.blur()" />
            <input type="submit" value='<bean:message key="common.button.select" bundle="common"/>'/>
            <input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onclick="parent.close();"/>
        </td>
    </tr>
</table>
</form>
</body>
</html:html>
