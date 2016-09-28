<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfslognavigatorsubmit.jsp,v 1.7 2007/09/13 11:26:31 hetao Exp $" -->
<%@ page import="com.nec.nsgui.model.entity.nfs.NFSConstant"%>
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
    document.forms[0].displayedDirectory.focus();
    try{
        var theText = document.forms[0].displayedDirectory.createTextRange();
        theText.collapse(false);
        theText.select();
    }
    catch(e){}
    finally{}
}

function submitCheck() {
    var disDir = document.forms[0].displayedDirectory.value;
    document.forms[0].displayedDirectory.value = compactPath(document.forms[0].displayedDirectory.value);
    disDir = document.forms[0].displayedDirectory.value;
    
    if(!isValidDirectory(disDir)){
        if(document.forms[0].pagetype.value=="<%=NFSConstant.NFS_ACCESSLOG_WIN%>"){
            alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
                    '<bean:message key="nfslog.invalid.accesslog.dir.start"/>' +
                    '<%=NFSConstant.NFS_VALID_FILE_NAME_CHAR%>' +
                    '<bean:message key="nfslog.invalid.accesslog.dir.end"/>');
        }else{
            alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
                    '<bean:message key="nfslog.invalid.perform.dir.start"/>' +
                    '<%=NFSConstant.NFS_VALID_FILE_NAME_CHAR%>' +
                    '<bean:message key="nfslog.invalid.perform.dir.end"/>');
            }
        return false;                
    }
    if (disDir.length > 254){
        alert("<bean:message key="common.alert.failed" bundle="common"/>"  + "\r\n" 
             + "<bean:message key="msg.lognavigator.alert.over_max"/>");
        return false;                
    }
   
    if (parent.window.opener && !parent.window.opener.closed) {
        if (parent.window.opener.document.forms[0]) {
            if(document.forms[0].pagetype.value=="<%=NFSConstant.NFS_ACCESSLOG_WIN%>"){
                parent.window.opener.document.forms[0].accessFullFileName.value
                        =document.forms[0].displayedDirectory.value;
            }else{
                parent.window.opener.document.forms[0].performFullFileName.value
                        =document.forms[0].displayedDirectory.value;
            }
        }
    }
    parent.close();
}

function isValidDirectory(str){
    if(str == ""){
        return false;
    }
    if(str.charAt(0) != '/'){
        return false;
    }
    var avail=/[^A-Za-z0-9\!\#\$\%\&\'\(\)\+\-\.\/\=\@\^\_\`\~]/g;
    var ifFind = str.search(avail);
    if(ifFind !=-1){
        return false;
    }
    return true;
}
</script>
</head>
<body onload="init()">

<form onSubmit="submitCheck();return false;">
<bean:define id="displayDir" name="nfslog_nowDirectory"/>
<input type="hidden" name="pagetype" value="<bean:write name='nfslog_type'/>"/>
<table>
    <tr>
        <td>
            <input type="text" name="displayedDirectory" value="<%=(String)displayDir%>" size="36" />
            <input type="submit" value='<bean:message key="common.button.select" bundle="common"/>'/>
            <input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onclick="parent.close();"/>
        </td>
    </tr>
</table>
</form>
</body>
</html:html>
