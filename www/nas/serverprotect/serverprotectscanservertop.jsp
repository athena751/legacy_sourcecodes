<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectscanservertop.jsp,v 1.7 2008/12/18 07:30:40 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript">
var loaded=0;
var enableSetBtn=1;
var enableDeleteBtn=0;
var popUpWinName;
var config_file='<bean:write name="hasConfigFile"/>';
var server_bak="";
var user_bak="";

function reloadSetPage(){
    if( isSubmitted() ){
        return false;
    }
    setSubmitted();
    parent.location = "<html:rewrite page='/serverProtectDisplayScanServer.do'/>";
    return true;
}

function init(){
    loaded = 1;
    if(config_file=="yes"){
        if(document.forms[0].elements["globalOption.extension"].value==""){
            document.forms[0].extension[0].checked=true;
            onBackToDefault();
            onChangeExtension(0);
        }else{
            document.forms[0].extension[1].checked=true;
            initExtensions(); 
            onChangeExtension(1);     
        }
    }else{
        document.forms[0].extension[0].checked=true;
        onBackToDefault();
        onChangeExtension(0);
    }
    
    initScanServer();
    initScanUser();
    
    if(document.forms[0].interfaces.value==""){
        enableSetBtn=0; 
        document.forms[0].addServer.disabled = true;
    }

    if(config_file=="yes"){
        enableDeleteBtn=1;
    }else{
        enableDeleteBtn=0;
    }
    
    if (parent.frames[1]){
        setTimeout('parent.frames[1].location="' + '<html:rewrite page="/serverProtectDisplayScanServerBottom.do"/>' + '"',1);
    }
    return true;
}

function initScanServer(){
    <logic:empty name="nic">
        document.forms[0].addServer.disabled=true;
        enableSetBtn=0;
    </logic:empty>
    var allserver=document.forms[0].scanServer.value;
    server_bak=allserver;
    if(allserver==""){
        return true;
    }
    var servers = allserver.split(';');
    var options = document.forms[0].scanServerList.options;
    for(var i = 0; i < servers.length; i++){
        var server = trim(servers[i]);
        if(server == ""){
            continue;
        }
        options.length++;
        options[options.length-1].value = server;
        options[options.length-1].text = server;
    }
    return true;    
}

function initScanUser(){
    <logic:empty name="ludbUsers">
        document.forms[0].addUser.disabled=true;
    </logic:empty>
    <logic:notEmpty name="ludbUsers">
        var options = document.forms[0].scanUserList.options;
        options.selectedIndex=0;
    </logic:notEmpty>

    user_bak = document.forms[0].elements["globalOption.ludbUser"].value;
    var setusers = document.forms[0].elements["globalOption.ludbUser"].value.split(':');
    setusers=delRepeateMumber(setusers);
    var div_setUsers=document.getElementById("div_setUsers").innerHTML;
    var option_index=div_setUsers.lastIndexOf('<');
    var tmpSetUsers="";
    for(var i = 0; i < setusers.length; i++){
        if(trim(setusers[i])==""){
            continue;
        }
        tmpSetUsers += '<option value="'+setusers[i]+'">'+setusers[i].replace(/\s/g,"&nbsp;")+'</option>';
    }
    div_setUsers=div_setUsers.substring(0,option_index)+tmpSetUsers+'</select>';
    document.getElementById("div_setUsers").innerHTML=div_setUsers;
}

function initExtensions(){
    getExtension("globalOption.extension");
}

function getExtension(exts){
    var extensions = document.forms[0].elements[exts].value.split(','); 
    var options = document.forms[0].extensionList.options;
    options.length=0;
    var hasIn=0;
    for(var i = 0; i < extensions.length; i++){
        
        var extension = trim(extensions[i]);
        if(extension==""){
            continue;
        }
        extension=extension.replace(/^\./,"");
        hasIn=0;
        for(var j=0;j<options.length;j++){
            if(extension==options[j].value){
                hasIn=1;
                break;
            }
        }
        if(hasIn==1){
            continue;
        }

        options.length++;
        if(extension==""){
            options[options.length-1].value = "";
            options[options.length-1].text = '<bean:message key="serverprotect.extension.none"/>';
        }else{
            options[options.length-1].value = extension;
            options[options.length-1].text = extension;
        }
    }
    document.forms[0].deleteExtension.disabled=true;
    if(options.length == 0){
        document.forms[0].clearExtension.disabled=true;
    }else{
        document.forms[0].clearExtension.disabled=false;
    }
    sortExtension(-1);
    return true;    
}

function sortExtension(index){
    var extension = document.forms[0].extensionList;
    var ln = extension.options.length;
    
    var arr = new Array(); 
    for (var i = 0; i < ln; i++){
        arr[i] = extension.options[i].value; 
    }
    var selectedExtension=arr[index];
    arr.sort();

    extension.options.length=0;    

    var div_extension=document.getElementById("div_extension").innerHTML;
    var option_index=div_extension.lastIndexOf('<');
    var tmp_extension="";
    for (i = 0; i < arr.length; i++){
       tmp_extension +='<option value="'+arr[i]+'">'+arr[i].replace(/\s/g,"&nbsp;")+'</option>';
    }
    div_extension=div_extension.substring(0,option_index)+tmp_extension+'</select>'
    document.getElementById("div_extension").innerHTML=div_extension;
    extension = document.forms[0].extensionList;

    if(extension.options[0].value==""){
        extension.options[0].text='<bean:message key="serverprotect.extension.none"/>';
    }
    for (i = 0; i < arr.length; i++){
        if(extension.options[i].value==selectedExtension){
            extension.selectedIndex=i;
            break;
        }
    }
    return true;
}

function onChangeExtension(localStatus){
    if(localStatus==0){
        document.forms[0].addExtension.disabled=true;
        document.forms[0].backToDefault.disabled=true;
        document.forms[0].clearExtension.disabled=true;
        document.forms[0].newExtension.disabled=true;
        document.forms[0].extensionList.disabled=true;
        document.forms[0].deleteExtension.disabled=true;
    }
    if(localStatus==1){
        document.forms[0].addExtension.disabled=false;
        document.forms[0].backToDefault.disabled=false;
        document.forms[0].newExtension.disabled=false;
        document.forms[0].extensionList.disabled=false;
        if(document.forms[0].extensionList.selectedIndex!=-1){
            document.forms[0].deleteExtension.disabled=false;
        }
        if(document.forms[0].extensionList.options.length != 0){
            document.forms[0].clearExtension.disabled=false;
        }
    }
    return true;
}

function onChangeExtensionList(){
    document.forms[0].deleteExtension.disabled=false;
    return true;
}

function onAddExtension(){
    var newextension=document.forms[0].newExtension.value.toUpperCase();
    newextension=newextension.replace(/(\s*$)/, "");
    document.forms[0].newExtension.value=newextension;  
       
    if(newextension.search(/[^\x20-\x7e]/) != -1 || 
       newextension.search(/[,."*\/:<>?\\|]/) != -1 ){
        alert('<bean:message key="serverprotect.alert.newextension"/>');
        document.forms[0].newExtension.focus();
        return false;
    }

    var extensions = document.forms[0].extensionList.options;
    if(extensions.length == 0){
        document.forms[0].deleteExtension.disabled = false;
        document.forms[0].clearExtension.disabled = false;
    }
    
    for(var i=0;i<extensions.length;i++){
        if(newextension==extensions[i].value){
            document.forms[0].extensionList.selectedIndex=-1;
            document.forms[0].extensionList.selectedIndex=i;
            document.forms[0].deleteExtension.disabled=false;
            return true;
        }
    }
    
    if(extensions.length >= 1000){
        alert('<bean:message key="serverprotect.alert.newextension"/>');
        document.forms[0].newExtension.focus();
        return false;
    }
    extensions.length++;
    if(newextension==""){
        extensions[extensions.length-1].value = "";
        extensions[extensions.length-1].text = '<bean:message key="serverprotect.extension.none"/>';
    }else{
        extensions[extensions.length-1].value = newextension;
        extensions[extensions.length-1].text = newextension;
    }
    
    document.forms[0].deleteExtension.disabled=false;
    document.forms[0].extensionList.selectedIndex=-1;
    sortExtension(extensions.length-1);
    return true;
}

function onBackToDefault(){
    getExtension("globalOption.defaultExtension");
}

function delOption(oSel){
    if (oSel.selectedIndex>=0) {
        oSel.remove(oSel.selectedIndex);
        delOption(oSel);
    }
}

function onDeleteExtension(){
    var options = document.forms[0].extensionList.options;
    var lastIndex = options.selectedIndex;
    
    delOption(document.forms[0].extensionList);

    if(options.length == 0){
        document.forms[0].deleteExtension.disabled=true;
        document.forms[0].clearExtension.disabled=true;
        return true;
    }
    if(lastIndex == options.length){
        document.forms[0].extensionList.selectedIndex=lastIndex-1;
        return true;
    }else{
        document.forms[0].extensionList.selectedIndex=lastIndex;
        return true;
    }
}

function onDeleteAllExtension(){
    var options = document.forms[0].extensionList.options;
    options.length=0;
    document.forms[0].deleteExtension.disabled=true;
    document.forms[0].clearExtension.disabled=true;
    return true;
}

function checkHost(){
    var hosts=trim(document.forms[0].host.value);

    var hostArray=hosts.split(/\s+/);
    for(var i=0;i<hostArray.length;i++){
        if(!(checkIP(hostArray[i]))){
            return false;
        }
    }
    return true;    
}

function onAddServer(){
    if(trim(document.forms[0].host.value)==""){
        alert('<bean:message key="serverprotect.alert.noserver"/>');
        document.forms[0].host.focus();
        return false;
    }
    if(!checkHost()){
        alert('<bean:message key="serverprotect.alert.host"/>');
        document.forms[0].host.focus();
        return false;
    }

    var options=document.forms[0].scanServerList.options;

    var savedlength=options.length;
    var addserver="";
    var hosts=trim(document.forms[0].host.value);
    var hostArray=hosts.split(/\s+/);
    hostArray=delRepeateMumber(hostArray);
    var addarray=new Array(hostArray.length);
    for(var i=0;i<hostArray.length;i++){
        addarray[i]=-1;
        for(var j=0;j<options.length;j++){
            var tmpArray=options[j].value.split(/\s+/);
            if(hostArray[i]==tmpArray[0]){
                addarray[i]=j;
                break;
            }
        }
        if(addarray[i]==-1){
            options.length++;
        }

        if((options.length!=savedlength)&&(options.length>32)){
            document.forms[0].scanServerList.options.length=savedlength; 
            alert('<bean:message key="serverprotect.alert.host"/>');
            document.forms[0].host.focus();
            return false;
        }     
    }
    
    document.forms[0].scanServerList.options.length=savedlength; 
    for(var i=0;i<hostArray.length;i++){
        if(addarray[i]!=-1){
            addserver=hostArray[i]+" "+"<=>"+" "+document.forms[0].interfaces.value;
            options[addarray[i]].value = addserver;
            options[addarray[i]].text = addserver;
            document.forms[0].scanServerList.selectedIndex=addarray[i];
        }else{
            options.length++;
            addserver=hostArray[i]+" "+"<=>"+" "+document.forms[0].interfaces.value;
            options[options.length-1].value = addserver;
            options[options.length-1].text = addserver;
            document.forms[0].scanServerList.selectedIndex=options.length-1;
        }      
    }

    onChangeServerItem();  
    return true;
}

function onChangeServerItem(){
    var index=document.forms[0].scanServerList.options.selectedIndex;
    if(index==-1){
        return false;
    }
    document.forms[0].deleteServer.disabled = false;

    refreshOptions(index);
} 

function refreshOptions(index){
    var nowline = document.forms[0].scanServerList.options[index].value;
    var tmpArray=nowline.split(/\s+/);
    document.forms[0].host.value=tmpArray[0];
    var selectnic=tmpArray[2];
    var options=document.forms[0].interfaces.options;
    var flag=0;
    for(var i=0;i<options.length;i++){
        if(selectnic==options[i].value){
            document.forms[0].interfaces.options.selectedIndex=i;
            flag=1;
            break;
        }
    }
    return true;
}

function onDeleteServer(){
    var options = document.forms[0].scanServerList.options;
    var index = options.selectedIndex;
    var lastIndex = index;
    for(; index < options.length-1; index++){
        options[index].value = options[index+1].value;
        options[index].text = options[index+1].text;
    }
    options.length--;
    if(options.length == 0){
        document.forms[0].deleteServer.disabled=true;
        document.forms[0].host.value="";
        document.forms[0].interfaces.selectedIndex=0;
        return true;
    }
    if(lastIndex == options.length){
        document.forms[0].scanServerList.selectedIndex=lastIndex-1;
    }else{
        document.forms[0].scanServerList.selectedIndex=lastIndex;
    }
    
    onChangeServerItem();
    return true;
}

function onAddUser(){
    var options=document.forms[0].scanUserSetList.options;

    var savedlength=options.length;
    var savedIndex=document.forms[0].scanUserSetList.selectedIndex;
    
    var all_length = document.forms[0].scanUserList.options.length;
    var target;
    var target_text;
    for(i=0; i<all_length; i++){
        if(document.forms[0].scanUserList.options[i].selected){
            if(document.forms[0].scanUserList.options[i].value.search(/[a-z]/)!=-1){
                alert("<bean:message key="serverprotect.alert.errorscanuser"/>");
                return false;
            }
        }
    }
    for(i=0; i<all_length; i++){
        if(document.forms[0].scanUserList.options[i].selected){
            target = document.forms[0].scanUserList.options[i].value;
            target_text=document.forms[0].scanUserList.options[i].text;
            var isexist = false;
            for(j=0; j<document.forms[0].scanUserSetList.options.length; j++){
                if(target==document.forms[0].scanUserSetList.options[j].value){
                    isexist = true;
                    document.forms[0].scanUserSetList.options[j].selected=true;
                }
            }
            if(!isexist){
                options.length++;
                options[options.length-1].value = target;
                options[options.length-1].text = target_text;
                document.forms[0].scanUserSetList.selectedIndex=options.length-1;
            }
        }
    }
	
    if((options.length!=savedlength) && (options.length>10)){
        options.length=savedlength;
        document.forms[0].scanUserSetList.selectedIndex=savedIndex;
        alert('<bean:message key="serverprotect.alert.maxscanuser"/>');
        return false;
    }

    onChangeUserItem();  
    return true;
}

function onChangeUserItem(){
    var index=document.forms[0].scanUserSetList.options.selectedIndex;
    if(index==-1){
        return false;
    }
    document.forms[0].deleteUser.disabled = false;
    return true;
}

function onDeleteUser(){
    var options = document.forms[0].scanUserSetList.options;
    var index = options.selectedIndex;
    var lastIndex = index;
    for(; index < options.length-1; index++){
        options[index].value = options[index+1].value;
        options[index].text = options[index+1].text;
    }
    options.length--;
    if(options.length == 0){
        document.forms[0].deleteUser.disabled=true;
        return true;
    }
    if(lastIndex == options.length){
        document.forms[0].scanUserSetList.selectedIndex=lastIndex-1;
    }else{
        document.forms[0].scanUserSetList.selectedIndex=lastIndex;
    }

    return true;
}


function setExtension(){
    if(document.forms[0].extension[0].checked ==true){
        document.forms[0].elements["globalOption.extension"].value="";
    }
    if(document.forms[0].extension[1].checked ==true){
        var options = document.forms[0].extensionList.options;
        var extensions="";
        for(var i = 0; i < options.length; i++){
            var extension = options[i].value;
            extension="."+extension;
            if(i==0){
                extensions=extension;
            }else{
                extensions=extensions+","+extension;
            }
        }
        document.forms[0].elements["globalOption.extension"].value=extensions;
    }
    return true;
}

function setScanServer(){
    var options=document.forms[0].scanServerList.options;
    var allserver="";
    for(var i=0;i<options.length;i++){
        allserver=allserver+options[i].value+";";
    }
    allserver=allserver.substr(0,allserver.length-1);
    document.forms[0].scanServer.value=allserver;
    return true;
}

function setScanUser(){
    var options=document.forms[0].scanUserSetList.options;
    var allusers="";
    if(options.length > 0){
        for(var i=0;i<options.length;i++){
            allusers=allusers+options[i].value+":";
        }
        allusers=allusers.substr(0,allusers.length-1);
    }
    document.forms[0].elements["globalOption.ludbUser"].value=allusers;
    return true;
}

function checkChange(){
    var servers_before = server_bak.split(';');
    var servers_now=document.forms[0].scanServer.value.split(';');
    if(servers_now.length != servers_before.length){
        document.forms[0].scanServerChange.value="yes";
    }else{
        servers_before.sort();
        servers_now.sort();
        document.forms[0].scanServerChange.value="no";
        var arr_before;
        var arr_now;
        for(var i=0;i<servers_now.length;i++){
            arr_before=trim(servers_before[i]).split(/\s+/);
            arr_now=trim(servers_now[i]).split(/\s+/);
            if(arr_before[0] != arr_now[0]){
                document.forms[0].scanServerChange.value="yes";
                break;
            }
        }
    }
    
    var users_before=user_bak.split(':');
    var users_now=document.forms[0].elements["globalOption.ludbUser"].value.split(':');
    if(users_now.length != users_before.length){
        document.forms[0].scanUserChange.value="yes";
    }else{
        if(users_now.length == 0){
   	        document.forms[0].scanUserChange.value="no";
        }else{
            users_before.sort();
            users_now.sort();
            document.forms[0].scanUserChange.value="no";
            for(var i=0;i<users_now.length;i++){
                if(users_before[i] != users_now[i]){
                    document.forms[0].scanUserChange.value="yes";
                    break;
                }
            }
        }
    }    
    return true;
}

function submitSet(){
    if (isSubmitted()){
        return false;
    }
       
    if(document.forms[0].scanServerList.options.length==0){
        alert('<bean:message key="serverprotect.alert.noserver"/>');
        document.forms[0].host.focus();
        return false;
    }
       
    if(document.forms[0].extension[1].checked ==true){
        if(document.forms[0].extensionList.options.length==0){
            alert('<bean:message key="serverprotect.alert.noextension"/>');
            document.forms[0].newExtension.focus();
            return false;
        }
    }    
       
    if(document.forms[0].scanUserSetList.options.length==0){
        if(!confirm('<bean:message key="serverprotect.confirm.nosetscanuser"/>\r\n'+
            '<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.submit" bundle="common"/>')){
            return false;
        }
    }else{    
        if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.submit" bundle="common"/>')){
            return false;
        }
    }
    
    setSubmitted();
    setExtension();
    setScanServer(); 
    setScanUser();   
    checkChange();
       
    document.forms[0].action="/nsadmin/serverprotect/serverProtectScanServer.do?operation=set";
    document.forms[0].target = "_parent";
    document.forms[0].submit();
    return true;   
}

function submitDelete(){
    if (isSubmitted()){
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.delete" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    document.forms[0].action="/nsadmin/serverprotect/serverProtectScanServer.do?operation=delete";
    document.forms[0].target = "_parent";
    document.forms[0].submit();
    return true;
}

function onExtensionList(){
    if (popUpWinName == null || popUpWinName.closed){
        popUpWinName = window.open("<html:rewrite page='/serverProtectExtensionList.do'/>","default_extension",
            "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=500,height=450");
        popUpWinName.focus();
    }else{
        popUpWinName.focus();
    }
    return true;
}

function closePopupWin(win){
    if (win != null && !win.closed){
        win.close();
    }
}

function delRepeateMumber(tmpArray){
    for(var i=0;i<tmpArray.length;i++){
        for(var j=i+1;j<tmpArray.length;){
              if(tmpArray[j]==tmpArray[i]){
                  tmpArray.splice(j,1);
              }
              else{
                  j++;
              }
        }
    }
    return tmpArray;
}

</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('nvavs_realtimescan_2');" onUnload="closePopupWin(popUpWinName);">

<html:form action="serverProtectScanServer.do?operation=set" method="POST">

<input type="button" name="refresh" 
    value="<bean:message key='common.button.reload' bundle='common'/>" 
    onclick="return reloadSetPage()"/>

<displayerror:error h1_key="serverprotect.common.h1"/>

<h3 class="title"><bean:message key="serverprotect.h3.scanserver"/></h3>

<html:hidden property="scanServer"/>

<table class="Vertical" border="1">
<tbody>
    <tr>
        <th style="vertical-align: top">
        <bean:message key="serverprotect.th.host"/>
        </th>
        <td>
        <input type="text" size="60" value="" name="host" maxlength="511">
        <br>    
        <font class="advice"> 
        <bean:message key="serverprotect.tip.host"/>
        </font> 
        </td>
    </tr>
    <tr>       
        <th style="vertical-align: top">
            <bean:message key="serverprotect.th.interface"/>
        </th>
        <td>
        <table border="0">
        <tr>
            <td style="vertical-align: top">
            <logic:empty name="nic">
                <select name="interfaces">
                    <option style="background-color:#C0C0C0">
                        <bean:message key="serverprotect.select.nointerface"/>
                    </option>
                </select>       
            </logic:empty>
            <logic:notEmpty name="nic">
                <select name="interfaces">
                    <logic:iterate id="nicItem" name="nic" indexId="i">
                        <option value="<bean:write name="nicItem"/>"><%=((String[])request.getAttribute("nicLabel"))[i.intValue()]%></option>                
                    </logic:iterate>
                </select>
            </logic:notEmpty>
            </td>
        </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td colspan="3">
        <p>
        <input type="button" name="addServer" 
               value="<bean:message key="serverprotect.button.addserver"/>" 
               onclick="onAddServer()"/>
        <br>
        <table>
        <tbody>
        <tr><td style="font-size:4pt">&nbsp;</td></tr>
        <tr>
            <th style="font-size:9pt">
            <bean:message key="serverprotect.tip.server"/>
            </th>
        </tr>
        <tr>
            <td>
            <select name="scanServerList" size="5" style="width:250px;" onchange="onChangeServerItem()">
            </select>
            </td>
        </tr>
        </tbody>	
        </table>
        <input type="button" name="deleteServer" 
               value="<bean:message key="common.button.delete" bundle="common"/>" 
               disabled="true" onclick="onDeleteServer()"/>
        </td>
    </tr>
</tbody>
</table>

<input type="hidden" name="scanServerChange"/>
<input type="hidden" name="scanUserChange"/>

<h3 class="title"><bean:message key="serverprotect.h3.scanuser"/></h3>

<nested:hidden  property="globalOption.ludbUser"/>

<table class="Vertical" border="1">
<tbody>
    <tr>
        <th style="vertical-align: top">
        <bean:message key="serverprotect.th.scanuser"/>
        </th>
        <td>
        <logic:empty name="ludbUsers">
            <select name="scanUserList" size="4" style="width:250px;" multiple="true">
                <option style="background-color:#C0C0C0">
                    <bean:message key="serverprotect.select.noscanuser"/>
                </option>
            </select>       
        </logic:empty>
        <logic:notEmpty name="ludbUsers">
            <select name="scanUserList" size="4" style="width:250px;" multiple="true" >
                <logic:iterate id="userItem" name="ludbUsers" indexId="i">
                    <bean:define id="userItem" name="userItem" type="java.lang.String"/>
                    <option value="<%=userItem%>"><%=NSActionUtil.htmlSanitize((String)userItem)%></option>
                </logic:iterate>   
            </select>    
        </logic:notEmpty>
        </td>
    </tr>
    <tr>
        <td colspan="2">
        <p>
        <input type="button" name="addUser" 
               value="<bean:message key="serverprotect.button.addserver"/>" 
               onclick="onAddUser()"/>
        <br>
        <table>
        <tbody>
        <tr><td style="font-size:4pt">&nbsp;</td></tr>
        <tr>
            <td>
            <div id="div_setUsers" style="width:250px;">
            <select name="scanUserSetList" size="4" style="width:250px;" onchange="onChangeUserItem()">
            </select>
            </div>
            </td>
        </tr>
        </tbody>	
        </table>
        <input type="button" name="deleteUser" 
               value="<bean:message key="common.button.delete" bundle="common"/>" 
               disabled="true" onclick="onDeleteUser()"/>
        </td>
    </tr>
</tbody>
</table>



<h3 class="title"><bean:message key="serverprotect.h3.extension"/></h3>

<nested:hidden  property="globalOption.extension"/>
<nested:hidden  property="globalOption.defaultExtension"/>

<table border="1" class="Vertical">
<tbody>
    <tr>
        <th rowspan="3" style="vertical-align: top">
        <bean:message key="serverprotect.th.extension"/>
        </th>
        <td>
        <input type="radio" name="extension" value="" id="all" onclick="onChangeExtension(0)"/>
            <label for="all">              
            <bean:message key="serverprotect.radio.allextension" />
            </label>              
        <br>
        <input type="radio" name="extension" value="" id="specify" onclick="onChangeExtension(1)"/>
            <label for="specify">
            <bean:message key="serverprotect.radio.specifyextension" />
            </label>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="illuminateDefault" 
               value="<bean:message key="serverprotect.button.defaultlist"/>"
               onclick="onExtensionList()"/>  
        </td>
    </tr>
    <tr>
        <td>
        <table>
            <tr>
                <td rowspan="2">
                <div id="div_extension" style="width:120">
                <select name="extensionList" size="7" style="width:120" multiple="true" onchange='onChangeExtensionList()'>
                </select>
                </div>
                </td>
                <td style="vertical-align:top">
                <input type="button" name="addExtension" disabled="true" 
                       value="<bean:message key="serverprotect.button.addextension" />"
                       onclick="onAddExtension()"/>
                <input type="text" name="newExtension"                     
                       size="10" maxlength="3"/>
                <br>
                <font style="font-size:4pt"><br></font>
                <input type="button" name="backToDefault" 
                       value="<bean:message key="serverprotect.button.defaultextension"/>"
                       disabled="true" onclick="onBackToDefault()"/>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: bottom">
                <input type="button" name="deleteExtension" 
                       value="<bean:message key="common.button.delete" bundle="common"/>"
                       disabled="true" onclick="onDeleteExtension()"/>
                <input type="button" name="clearExtension" 
                       value="<bean:message key="serverprotect.button.alldelete"/>" 
                       disabled="true" onclick="onDeleteAllExtension()"/>
                </td>
            </tr>
        </table>    
        </td>
    </tr>
</tbody>
</table>

</html:form>
</body>

</html>

