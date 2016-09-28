<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsaddedoptionstop.jsp,v 1.2 2007/05/09 06:08:46 caows Exp $" -->

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.model.entity.nfs.NFSConstant"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>

<script language="JavaScript">
var loadsetting="false";
var loaded=0;
var status="";
var accessfunction=1;
function onReload(){
    if( isSubmitted() ){
        return false;
    }
    setSubmitted();
    parent.location = "<html:rewrite page='/addedOptions.do'/>";
    return true;
}
function setSubmit(){
    if( isSubmitted() ){
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    if(document.forms[0].access.checked == false){
        document.forms[0].accessRight.value="available";
    }
    if(document.forms[0].access.checked == true){
        document.forms[0].accessRight.value="deny";
    }     

    document.forms[0].submit();

    return true;
}
function init(){
    loaded=1;
    <logic:present name="thisResult" scope="session">
	    var thisResult='<bean:write name="thisResult" scope="session" />';
	    parent.frames[1].document.forms[0].optionset.disabled=false;
	    accessfunction=0;
	    status = thisResult;
    </logic:present>
    <logic:notPresent name="thisResult" scope="session">
    	status='<bean:write name="<%=NFSConstant.ACCESS_STATUS%>" scope="request"/>';
    </logic:notPresent>
    if(status == "available"){
        document.forms[0].access.checked = false;
    }
    if(status == "deny"){
        document.forms[0].access.checked = true;
    }
    loadsetting=document.forms[0].access.checked;
    if(status != "available" && status != "deny"){
        alert("<bean:message key="addedoptions.alert.getAccessStatusFailed"/>");
        parent.frames[1].document.forms[0].optionset.disabled=false;
        accessfunction=0;
    }
    return true;
}

function onAccessOption(){
    if(accessfunction == 0){
        return true;
    }
    if(parent.frames[1] && parent.frames[1].loaded){  
        var nowsetting=document.forms[0].access.checked;
        if (loadsetting == nowsetting){
            parent.frames[1].document.forms[0].optionset.disabled=true;   
        }
        if (loadsetting != nowsetting){
            parent.frames[1].document.forms[0].optionset.disabled=false;
        }
        return true;
    }else{ 
        return false;
    }    
}

</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('network_nfs_10');">
<html:form action="addedOptionsTop.do?operation=setAccessStatus" method="POST" >
<input type="button" onclick="onReload()"
       value="<bean:message key="common.button.reload" bundle="common"/>"/>
<br>
<displayerror:error h1_key="title.nfs"/>
<br>
<table border="1">
<tr>
<th><bean:message key="addedoptions.top.th_access"/></th>
<td>
<html:hidden property="accessRight"/>
<input type="checkbox" id="accessID" name="access" onclick="return onAccessOption();"/>
<label for="accessID">
    <bean:message key="addedoptions.top.td_function"/>
</label>
</td>
</tr>
</table>
</html:form>
</body>
</html:html>