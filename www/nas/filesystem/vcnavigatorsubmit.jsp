<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: vcnavigatorsubmit.jsp,v 1.4 2007/09/13 01:21:01 pizb Exp $" -->

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
    if(document.forms[0].displayedDirectory.value != ""){
        if (checkName(document.forms[0].displayedDirectory.value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" 
                + '<bean:message key="msg.navigator.alert.invalid_name" arg0="\'+disDir+\'"  bundle="volume/filesystem"/>');
            return false;
        }
    }
    document.forms[0].displayedDirectory.value = compactPath(document.forms[0].displayedDirectory.value);
    disDir = document.forms[0].displayedDirectory.value;
    
    if (disDir == "") {
        alert("<bean:message key="msg.navigator.alert.no_dir" bundle="volume/filesystem"/>");
        return false;
    }
    
    var fullPath;
    if (disDir != "") {
        fullPath = rootDir + "/" + disDir;
    } else {
        fullPath = rootDir;
    }
    
    if (fullPath.length > 2047){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" 
             + "<bean:message key="msg.add.maxMPLength" bundle="volume/filesystem"/>");
        return false;                
    }
    
    if (chkEveryLevel(disDir)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" 
            + "<bean:message key="msg.add.maxDirLength" bundle="volume/filesystem"/>");
        
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
	document.forms[0].displayedDirectory.focus();
	
	try{
        var theText = document.forms[0].displayedDirectory.createTextRange();
        theText.collapse(false);
        theText.select();
    }
    catch(e){}
    finally{}
}

function chkEveryLevel(str){
    var tmpArray=new Array();
    var reg=/\//g;
    tmpArray=str.split(reg);
    for (var index=0; index<tmpArray.length; index++){
        if (tmpArray[index].length>255){
            return true;
        }
    }
    return false;
}

function checkName(str){
    var valid = /^[~\.\-]|[^0-9a-zA-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
    var flag=str.search(valid);
    if (flag!=-1){
        return true;
    }else{
        return false;
    }  
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


