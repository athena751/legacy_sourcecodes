<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescanglobalsettop.jsp,v 1.2 2008/05/14 08:08:14 chenjc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
var interfaces_bak;
var users_bak;
var scanServer_bak;
var setBtnStatus=1;
var elements;

function init(){
    setHelpAnchor("nvavs_schedulescan_3");
    elements = document.forms[0].elements;
    scanServer_bak = elements["globalBean.scanServer"].value;
    initHasSetInterfaces();
    initHasSetUsers();
    initAllInterfaces();
    initAllUsers();
    initConfirm();
    displayAlert();
    if (window.parent.frames[1].document &&
        window.parent.frames[1].document.forms[0] &&
        !isSubmitted()) {
        window.parent.frames[1].changeButtonStatus();
    }
    return true;
}

function initHasSetInterfaces(){
    var interfaceStr = elements["globalBean.selectedInterfaces"].value;
    interfaces_bak = interfaceStr;
    if (/^\s*$/.test(interfaceStr)) {
        return true;
    }
    interfaceStr = interfaceStr.replace(/\s+/g, "<br>");
    document.getElementById("hasSetInterfaces").innerHTML = interfaceStr;
    return true;
}

function initHasSetUsers(){
    var userStr = elements["globalBean.selectedUsers"].value;
    users_bak = userStr;
    if (userStr == "") {
        elements["deleteUserButton"].disabled = true;
        return true;
    }
    var userArray = userStr.split(/:/);
    var oOption;
    for (var i = 0; i < userArray.length; i++) {
        if (userArray[i] == "") {
            continue;
        }
        oOption = new Option();
        elements["hasSetUsers"].options.add(oOption);
        //oOption.text = userArray[i];
        oOption.value = userArray[i];
        //oOption.appendChild(document.createTextNode(userArray[i]));
        oOption.innerHTML =htmlSanitize(userArray[i]);
    }
    //elements["hasSetUsers"].options.selectedIndex = 0;
    return true;
}

function htmlSanitize(str){
   str=str.replace(/&/g,"&amp;");
   str=str.replace(/</g,"&lt;");
   str=str.replace(/>/g,"&gt;");
   str=str.replace(/"/g, "&quot;");
   str=str.replace(/'/g, "&#39;");
   str=str.replace(/\s/g,"&nbsp;");
   return str;
}

function initAllInterfaces(){
    <logic:empty name="allInterfaces">
        setBtnStatus=0;
        elements["allInterfaces"].selectedIndex = 0;
        return true;
    </logic:empty>
    var interfaceStr = elements["globalBean.selectedInterfaces"].value;
    if (trim(interfaceStr) == "") {
        elements["allInterfaces"].selectedIndex = 0;
        return true;
    }
    var interfaceArray = interfaceStr.split(/\s+/);
    var oOptions=elements["allInterfaces"].options;
    var hash=new Object();
    for(var i=0;i<interfaceArray.length;i++){
        hash[interfaceArray[i]]=0;
    }
    for(var i=0;i<oOptions.length;i++){
        if(oOptions[i].value in hash){
            oOptions[i].selected=true;
        }
        /**
        for(var j=0;j<interfaceArray.length;j++){
            if(oOptions[i].value==interfaceArray[j]){
                oOptions[i].selected=true;
                break;
            }
        }
        **/
    }
    return true;
}

function initAllUsers(){
    <logic:empty name="allUsers" scope="request">
        setBtnStatus=0;
        elements["allUsers"].selectedIndex = 0;
        //elements["addUserButton"].disabled = true;
        return true;
    </logic:empty>
    elements["allUsers"].selectedIndex = 0;
    elements["addUserButton"].disabled = false;
    
    return true;
}

function initConfirm(){
<logic:equal name="schedulescan_haveConnection" value="yes" scope="request">
    if(isSubmitted()){
        return false;
    }
    if(confirm("<bean:message key="schedulescan.alert.haveconnection"/>")){
       setSubmitted();
       if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
           parent.frames[1].document.forms[0].setButton.disabled=true;
       }
       document.forms[0].action="scheduleScanGlobalSetTop.do?operation=set";
       document.forms[0].submit();
    }
    return true;
</logic:equal>
}

function onReload(){
    if (isSubmitted()){
        return false;
    }
    if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
        parent.frames[1].document.forms[0].setButton.disabled=true;
    }else{
        return false;
    }
    setSubmitted();
    document.forms[0].action = "scheduleScanGlobalSetTop.do?operation=load"; 
    document.forms[0].submit();
    return true;
}

function onAddUser(){
    var oOption;
    var allOptions=elements["allUsers"].options;
    var selectedOptions=elements["hasSetUsers"].options;
    var initSelectedLength=selectedOptions.length;
    var selectedLength=initSelectedLength;
    for(var i=0;i<allOptions.length;i++){
        if(allOptions[i].selected){
            if(allOptions[i].value.search(/[a-z]/)!=-1){
                alert("<bean:message key="schedulescan.alert.errorscanuser"/>");
                return false;
            }
            var isExist=false;
            for(var j=0;j<selectedOptions.length;j++){
                if(allOptions[i].value==selectedOptions[j].value){
                    isExist=true;
                    break;
                }
            }
            if(!isExist){
                selectedLength++;
            }
        }
    }
    if(selectedLength>10){
        alert("<bean:message key="schedulescan.alert.maxscanuser"/>");
        return false;
    }
    for(var i=0;i<allOptions.length;i++){
        if(allOptions[i].selected){
            var isExist=false;
            for(var j=0;j<selectedOptions.length;j++){
                if(allOptions[i].value==selectedOptions[j].value){
                    isExist=true;
                    selectedOptions[j].selected=true;
                    break;
                }
            }
            if(!isExist){
                oOption=new Option();
                selectedOptions.add(oOption);
                oOption.value=allOptions[i].value;
                oOption.text=allOptions[i].text;
                //oOption.innerHTML=allOptions[i].innerHTML;
                oOption.selected=true;
            }
        }
    }
    changeDeleteBtn();
    return true;
}

function onDeleteUser(){
    var selectedOptions=elements["hasSetUsers"].options;
    var index=elements["hasSetUsers"].selectedIndex;    
    elements["hasSetUsers"].remove(index);
    if(index==selectedOptions.length){
        elements["hasSetUsers"].selectedIndex=index-1;
    }else{
        elements["hasSetUsers"].selectedIndex=index;
    }
    changeDeleteBtn();
    return true;
}

function changeDeleteBtn(){
    if(elements["hasSetUsers"].options.length==0||elements["hasSetUsers"].selectedIndex==-1){
        elements["deleteUserButton"].disabled = true;
        return true;
    }
    elements["deleteUserButton"].disabled = false;
    return true;
}

function checkInputs(){
    if(!checkScanServer()){
       alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
           + "<bean:message key="schedulescan.alert.scanserver"/>");
       elements["globalBean.scanServer"].focus();
       return false;
    }
    if(!checkInterfaces()){
       elements["allInterfaces"].focus();
       return false;
    }
    if(!checkUsers()){
       alert("<bean:message key="schedulescan.alert.noscanuser"/>");
       elements["hasSetUsers"].focus();
       return false;
    }
    return true;
}

function checkScanServer(){
    var scanServer=trim(elements["globalBean.scanServer"].value);
    if(scanServer==""){
        return false;
    }
    if(!checkHosts(scanServer)){
        return false;
    }
    var hostArray=scanServer.split(/\s+/);
    hostArray=deleteRepeat(hostArray);
    if(hostArray.length>32){
        return false;
    }
    //elements["globalBean.scanServer"].value=hostArray.join(" ");
    return true;
}

function checkInterfaces(){
    var oOptions=elements["allInterfaces"].options;
    var tmpArray=new Array();
    for(var i=0;i<oOptions.length;i++){
        if(oOptions[i].selected){
            tmpArray.push(oOptions[i].value);
        }
    }
    if(tmpArray.length==0){
        alert("<bean:message key="schedulescan.alert.nointerface"/>");
        return false;
    }
    var tmpStr=tmpArray.join(" ");
    if(tmpStr.length>200){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
            + "<bean:message key="schedulescan.alert.maxinterface"/>");
        return false;
    }
    //elements["globalBean.selectedInterfaces"].value=tmpStr;
    return true;
}

function checkUsers(){
    if(elements["hasSetUsers"].options.length==0){
       return false;
    }
    return true;
}

function checkChange(){
    var interfaceArray_bak=interfaces_bak.split(/\s+/);
    var interfacesArray=elements["globalBean.selectedInterfaces"].value.split(/\s+/);
    if(interfaceArray_bak.length!=interfacesArray.length){
        return true;
    }
    var usersArray_bak=users_bak.split(/:/);
    var usersArray=elements["globalBean.selectedUsers"].value.split(/:/);
    if(usersArray_bak.length!=usersArray.length){
        return true;
    }
    var serverArray_bak=scanServer_bak.split(/\s+/);
    var serverArray=elements["globalBean.scanServer"].value.split(/\s+/);
    serverArray_bak=deleteRepeat(serverArray_bak);
    serverArray=deleteRepeat(serverArray);
    if(serverArray_bak.length!=serverArray.length){
        return true;
    }
    interfaceArray_bak.sort();
    interfacesArray.sort();
    for(var i=0;i<interfacesArray.length;i++){
        if(interfacesArray[i]!=interfaceArray_bak[i]){
            return true;
        }
    }
    usersArray_bak.sort();
    usersArray.sort();
    for(var i=0;i<usersArray.length;i++){
        if(usersArray[i]!=usersArray_bak[i]){
            return true;
        }
    }
    serverArray_bak.sort();
    serverArray.sort();
    for(var i=0;i<serverArray.length;i++){
        if(serverArray[i]!=serverArray_bak[i]){
            return true;
        }
    }
    return false;
}

function deleteRepeat(array){
    var hash=new Object();
    var tmpArray=new Array();
    for(var i=0;i<array.length;i++){
        if(!( array[i] in hash)){
            hash[array[i]]=0;
            tmpArray.push(array[i]);
        }
    }
    return tmpArray;
}

function setSelectedInterfaces(){
    var oOptions=elements["allInterfaces"].options;
    var interfaceArray=new Array();
    for(var i=0;i<oOptions.length;i++){
        if(oOptions[i].selected){
            interfaceArray.push(oOptions[i].value);
        }
    }
    elements["globalBean.selectedInterfaces"].value=interfaceArray.join(" ");
    return true;
}

function setSelectedUsers(){
    var oOptions=elements["hasSetUsers"].options;
    var userArray=new Array();
    for(var i=0;i<oOptions.length;i++){
        userArray.push(oOptions[i].value);
    }
    elements["globalBean.selectedUsers"].value=userArray.join(":");
    return true;
}

function setScanServer(){
    var scanServer=trim(elements["globalBean.scanServer"].value);
    var hostArray=scanServer.split(/\s+/);
    hostArray=deleteRepeat(hostArray);
    elements["globalBean.scanServer"].value=hostArray.join(" ");
    return true;
}

function setShouldRestart(){
    if(checkChange()){
        elements["shouldRestart"].value="yes";
    }else{
        elements["shouldRestart"].value="no";
    }
    return true;
}

function submitSet(){
    if(isSubmitted()){
        return false;
    }
    if(!checkInputs()){
        return false;
    }
    if(!confirm("<bean:message key="common.confirm" bundle="common"/>\r\n"+
        "<bean:message key="common.confirm.action" bundle="common"/>"+
        "<bean:message key="common.button.submit" bundle="common"/>")){
        return false;
    }
    setSubmitted();
    setSelectedInterfaces();
    setSelectedUsers();
    setScanServer();
    setShouldRestart();
    document.forms[0].submit();
    return true;
}
</script>
</head>

<body onload="init();" onunload="closeDetailErrorWin();">

<html:form action="scheduleScanGlobalSetTop.do?operation=checkConnection" method="post" onsubmit="return false;">

<input type="button" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
<br>
<displayerror:error h1_key="schedulescan.common.h1"/>
<br>

<html:hidden property="shouldRestart"/>

<table class="Vertical" border="1">
<tbody>
    <tr>
        <th valign="top">
            <bean:message key="schedulescan.th.scanserver.withip"/>
        </th>
        <td>
        <nested:nest property="globalBean">
            <nested:hidden property="selectedInterfaces"/>
            <nested:hidden property="selectedUsers"/>
            <nested:text property="scanServer" size="60" maxlength="511"/>
        </nested:nest>
        <br>
            <font class="advice">
            <bean:message key="schedulescan.tip.scanserver"/>
            </font>
        </td>
    </tr>
    <tr>
        <th valign="middle">
            <bean:message key="schedulescan.th.interface"/>
        </th>
        <td>
        <table border="0">
        <tbody>
            <tr>
                <td valign="top">
                    <logic:empty name="allInterfaces">
                    <select name="allInterfaces" multiple size="4">
                        <option style="background-color:#C0C0C0">
                            <bean:message key="schedulescan.select.nointerface"/>
                        </option>
                    </select>
                    </logic:empty>
                    <logic:notEmpty name="allInterfaces">
                    <bean:define id="allInterfacesLabel" name="allInterfacesLabel" type="java.lang.String[]"/>
                    <select name="allInterfaces" multiple size="4">
                        <logic:iterate id="nicItem" name="allInterfaces" indexId="i">
                        <option value="<bean:write name="nicItem"/>"><%=allInterfacesLabel[i.intValue()]%></option>
                        </logic:iterate>
                    </select>
                    </logic:notEmpty>
                </td>
                <td valign="top">
                    <bean:message key="schedulescan.current.interface"/>
                </td>
                <td valign="top" align="left" id="hasSetInterfaces">
                    <bean:message key="schedulescan.current.nointerface"/>
                </td>
            </tr>
        </tbody>
        </table>
        </td>
    </tr>
    <tr>
        <th valign="top" rowspan="2">
            <bean:message key="schedulescan.th.scanuser"/>
        </th>
        <td>
            <logic:empty name="allUsers">
            <select name="allUsers" style="width:250px;" multiple size="4">
                <option style="background-color:#C0C0C0">
                    <bean:message key="schedulescan.select.noscanuser"/>
                </option>
            </select>       
            </logic:empty>
            <logic:notEmpty name="allUsers">
            <select name="allUsers" style="width:250px;" multiple size="4">
                <logic:iterate id="userItem" name="allUsers" type="java.lang.String">
                    <option value="<bean:write name="userItem"/>"><%=NSActionUtil.sanitize(userItem)%></option>
                </logic:iterate>
            </select>    
            </logic:notEmpty>
        </td>
    </tr>
    <tr>
        <td colspan="2">
        <p>
        <input type="button" name="addUserButton" 
               value="<bean:message key="schedulescan.button.adduser"/>" 
               onclick="onAddUser();" disabled="true"/>
        <br>
        <table>
        <tbody>
            <tr><td style="font-size:4pt">&nbsp;</td></tr>
            <tr>
                <td>
                    <select name="hasSetUsers" size="4" style="width:200px;" onchange="changeDeleteBtn();">
                    </select>
                </td>
            </tr>
        </tbody>    
        </table>
        <input type="button" name="deleteUserButton"
               value="<bean:message key="common.button.delete" bundle="common"/>" 
               onclick="onDeleteUser();" disabled="true"/>
        </td>
    </tr>
</tbody>
</table>
</html:form>
</body>
</html>