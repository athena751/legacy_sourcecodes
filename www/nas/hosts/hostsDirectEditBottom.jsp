<!-- 
    Copyright (c) 2006-2007 NEC Corporation
		
    NEC SOURCE CODE PROPRIETARY
		
    Use, duplication and disclosure subject to a source code 
    license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: hostsDirectEditBottom.jsp,v 1.6 2007/05/29 09:22:34 wanghui Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<script language="JavaScript">
function init(){
    <logic:notEqual name="hosts_disaccordFlag" value="true">
        if(window.parent.frames[0] && window.parent.frames[0].document.hostsFileSetTop){
            window.parent.frames[0].enableBottomButton();
        }		
    </logic:notEqual>
}
function onReSet(){
    if(isSubmitted()){
        return false;
    }
    return window.parent.frames[0].document.hostsFileSetTop.reset();
}
function onSet(){
    if (isSubmitted()){
        return false;
    }
    var str = window.parent.frames[0].document.hostsFileSetTop.fileContent.value;
    if((str.search(/[^\x00-\x7f]/) != -1)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                + "<bean:message key="Hosts.alert.2bytesCharacter.forbidden"/>");
        return false;
    }	
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
       '<bean:message key="common.confirm.action" bundle="common"/>'+
       '<bean:message key="common.button.submit" bundle="common"/>\r\n' +
       '<bean:message key="hosts.alert.servicesrestart.warning"/>')){
            return false;
    }
    setSubmitted();
    window.parent.frames[0].document.hostsFileSetTop.action = "hostsFileTop.do?operation=setToFile";
    window.parent.frames[0].document.hostsFileSetTop.target = "_parent";
    window.parent.frames[0].document.hostsFileSetTop.submit();               
       
}
</script>
</head>

<body onload="init()">

<form name="hostsFileSetBottom" method="POST">
<nobr>

    <input type="button" name="hostsFileSet" onclick="onSet()" disabled="true"
        value="<bean:message key="common.button.submit" bundle="common"/>" />
    	&nbsp;
    <input type="button" name="hostsFileReset" onclick="onReSet()" disabled="true"
        value="<bean:message key="common.button.reset" bundle="common"/>"/>
    
    
</nobr>
</form>
</body>
</html:html>