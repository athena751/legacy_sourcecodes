<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: csnavigatorsubmit.jsp,v 1.21 2008/03/10 05:17:41 chenbc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
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
                    + "<bean:message key="cifs.alert.path_invalidChar"/>");
            return false;
        }
    }
    document.forms[0].displayedDirectory.value = compactPath(document.forms[0].displayedDirectory.value);
    disDir = document.forms[0].displayedDirectory.value;
    disDir = deleteMutipleSlash(disDir);
    disDir = disDir.replace(/(^[\/]*)/g,"");
    disDir = disDir.replace(/^[\.]([\.])?$/g,"");
    document.forms[0].displayedDirectory.value = disDir;
    if (disDir == "") {
        alert("<bean:message key="cifs.navigator.alert.directory_empty"/>");
        return false;
    }
    
    if (parent.window.opener && !parent.window.opener.closed) {
	if (parent.window.opener.document.forms[0]) {
		parent.window.opener.mpPath.value = disDir;
		parent.window.opener.mpPath.focus();
		parent.window.opener.mpPath.onblur();
	}
    }
    parent.close();
}
var helpAnchor;
var topHelpAnchorObject;
function initCursor() {
	document.forms[0].displayedDirectory.focus();
	try{
        var theText = document.forms[0].displayedDirectory.createTextRange();
        theText.collapse(false);
        theText.select();
    }
    catch(e){}
    finally{}
    
	helpAnchor = parent.opener.document.forms[0].helpLocation.value;
	setHelpAnchor(parent.opener.document.forms[0].helpLocation_navigator.value);
	
	var topWin = self;
    if(self.top.opener && self.parent.opener.top){
        topWin = self.parent.opener.top;
    }
    if(topWin.MENU && topWin.MENU.curForm){
        topHelpAnchorObject = topWin.MENU.curForm.helpAnchor
    }
}

function deleteDirectory(){
    var path = null;
    var rootPath = null;
    if(document.forms[0] && document.forms[0].displayedDirectory){
        path = document.forms[0].displayedDirectory.value;
        rootPath = document.forms[0].rootDirectory.value;
    }
    if(path != null && path != ""){
        if(!checkPath4Win(path)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.path_invalidChar"/>");
            return false;
        }
    }
    path = deleteMutipleSlash(path);
    path = path.replace(/(^[\/]*)/g,"");
    path = path.replace(/^[\.]([\.])?$/g,"");
    document.forms[0].displayedDirectory.value = path;
    
    var dirs = path.split(/\/+/);
    if (path == "") {
        alert("<bean:message key="cifs.navigator.alert.directory_empty"/>");
        return false;
    }
    
    if(parent && parent.frames[0]){
        var checkNVResv = parent.frames[0].checkNVResv;
        for(var i = 0; i < dirs.length; ++i){
            var curDir = dirs[i].replace(/\s+$/, "");
            if(!checkNVResv(curDir)){
                alert('<bean:message key="cifs.error.dirDeleteFailed.generalInfo"/>' + "\r\n" +
                      '<bean:message key="cifs.error.underNVResv.detailInfo"/>');
                return false;
            }
        }
        parent.frames[0].onDelete(rootPath + '/'+ path);
    }
}
function setBackHelpAnchor(){
    if(topHelpAnchorObject){
        topHelpAnchorObject.value = "/help.html#" + helpAnchor;
    }
}

</script>
</head>
<body onLoad="initCursor();"  onunload="setBackHelpAnchor();" >

<form onSubmit="submitCheck();return false;">

<bean:define id="rootDir" name="rootDirectory" type="java.lang.String"/>
<bean:define id="nowDir" name="nowDirectory"/>
<bean:define id="displayDir" name="displayDirectory"/>

<input type="hidden" name="rootDirectory" value="<%=(String)rootDir%>"/>
<table>
    <tr>
        <td>
            <%=NSActionUtil.sanitize((String)rootDir)%>/
        </td>
        <td>
            <input type="text" name="displayedDirectory" value="<%=(String)displayDir%>"/>
            <input type="submit" value='<bean:message key="common.button.select" bundle="common"/>' id="selectDir"/>
            <input type="button" value='<bean:message key="common.button.delete" bundle="common"/>' onclick='deleteDirectory()' id="deleteDir"/>
            <input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()"/>
        </td>
    </tr>
</table>
</form>
</body>
</html:html>
