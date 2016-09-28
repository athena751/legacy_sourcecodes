<!--
        Copyright (c) 2008-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsdetailtop.jsp,v 1.6 2009/04/23 01:53:11 yangxj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.model.entity.nfs.NFSConstant" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript" src="nfscommon.js"></script>
<script language="JavaScript">
var enableSetBtn = 0; 

var rw               = "rw";                                  
var no_subtree_check = "no_subtree_check";       
var all_squash       = "all_squash";          
var no_root_squash   = "no_root_squash";   
var nohide           = "nohide";                  
var anonuid          = "anonuid";               
var anongid          = "anongid";                
var map              = "map";            
var accesslog        = "accesslog"; 
var nisdomain        = "nisdomain";  
var insecure         = "insecure";     
var anon             = "anon"; 
var unstable_write   = "unstable_write";

var navigatorWin;
var accesslogprocWin;
var otherParams      = new Array();

var needAuthDomain       = <bean:write name="nfsDetailForm" property="detailInfo.needAuthDomain"/>;
var needNativeDomain     = <bean:write name="nfsDetailForm" property="detailInfo.needNativeDomain"/>;
var isSxfsfw             = <bean:write name="nfsDetailForm" property="detailInfo.isSxfsfw"/>;
var isSubMountPoint      = <bean:write name="nfsDetailForm" property="detailInfo.isSubMountPoint"/>;
var seletedNisDomain     = '<bean:write name="nfsDetailForm" property="detailInfo.seletedNisDomain4Unix"/>';
var seletedNisDomain4Win = '<bean:write name="nfsDetailForm" property="detailInfo.seletedNisDomain4Win"/>';
var expgrp               = '<%=NSActionUtil.getExportGroupPath(request)%>';
var directory            = '<bean:write name="nfsDetailForm" property="selectedDir" />';

//add for accesslogproc
var NFS_DETAIL_LICENSE;
var allprocedures = new Array("SETATTR", "CREATE", "MKDIR", "SYMLINK",
                              "MKNOD", "LINK", "REMOVE", "RMDIR", 
                              "RENAME", "WRITE", "READ");
var selectedProc;
var isValidProc = true;

function getArray(){
    return new Array(11);
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location.href="<html:rewrite page='/nfsList.do'/>";
}

function createShareItem(){
    var params = new Array();
    if(document.forms[0].client.value.charAt(0) == "@"){
        var nisOptions = document.forms[0].elements["detailInfo.seletedNisDomain"].options;
        params.push(nisdomain + "=" + nisOptions[nisOptions.selectedIndex].value);
    }
    if(document.forms[0].um[2].checked == true){
        params.push(map);
        params.push(anon);
    }
    if(document.forms[0].um[1].checked == true){
        params.push(map);
    }
    if(document.forms[0].access[0].checked == true){
        params.push(rw);
    }
    if(document.forms[0].trans[1].checked == true){
        params.push(all_squash);
    }
    if(document.forms[0].trans[2].checked == true){
        params.push(no_root_squash);
    }
    if(document.forms[0].uid.value != "-2"){
        params.push(anonuid+"="+document.forms[0].uid.value);
    }
    if(document.forms[0].gid.value != "-2"){
        params.push(anongid+"="+document.forms[0].gid.value);
    }
    if(document.forms[0].subtree.checked == false){
        params.push(no_subtree_check);
    }
    if(document.forms[0].hide.checked == false){
        params.push(nohide);
    }
    if(document.forms[0].port.checked == false){
        params.push(insecure);
    }
    if(document.forms[0].accesslog.checked == true){
        params.push(accesslog);
  
        if(!isEmpty(selectedProc)) {
            var accesslogproc = new Array();
                for(var i=0; i<selectedProc.length; i++) {
                if(selectedProc[i]!=null) {
                    accesslogproc.push(selectedProc[i]);
                }
            }
            params.push("accesslogproc=\"" + accesslogproc.join(",") + "\"");
        }
    } else {
        selectedProc = null;
    }
    <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
    if(document.forms[0].unstablewrite.checked == true){
        params.push(unstable_write);
    }
    </logic:equal>
    
    if(selectedProc == null) {
        isValidProc = true;
    }

    otherParams = delAccesslogProc(otherParams);
    params = params.concat(otherParams);
    return document.forms[0].client.value + "(" + params.join(",") + ")";
}

function isEmpty(array) {
    var procNotEmpty;
    if(array!=null) {
        for(var i=0; i<array.length; i++) {
            procNotEmpty = procNotEmpty || array[i];
        }
    }
    return (procNotEmpty == null);  
}

function delAccesslogProc(array) {
    var tempArray = new Array();
    for(var i=0; i<array.length; i++) {
        if(!array[i].match(/\baccesslogproc\b/)){
            tempArray.push(array[i]);
        }
    }
    return tempArray;
}

function init() {
    resetNisDomain(window);
    initOptions();
    resetMountAndMapStatus(window);
    document.forms[0].accesslog.onclick();
}

function initOptions(){
    if(directory != '' && directory.length > expgrp.length+1){
        document.forms[0].selectedDir.value = directory.substring(expgrp.length+1);
    }
    var clients = document.forms[0].elements["detailInfo.clientOptions"].value.split('\n'); 
    var options = document.forms[0].shareList.options;
    for(var i = 0; i < clients.length; i++){
        var client = trim(clients[i]);
        if(client == ""){
            continue;
        }
        options.length++;
        options[options.length-1].value = client;
        options[options.length-1].text = client;
    }
    if(options.length != 0){
        document.forms[0].deleteItem.disabled = false;
        document.forms[0].addItem.disabled = false;
        if(parent.frames[1] && parent.frames[1].loaded == 1) {
            enableSetBtn=1;
            parent.frames[1].document.forms[0].set.disabled = false;
        }
        selectOneItem(0,true);
    }
}

function checkDomain(){
    if(needAuthDomain){
        if(isSxfsfw){
            alert('<bean:message key="alert.need.windows.auth.domain"/>');
        }else{
            alert('<bean:message key="alert.need.unix.auth.domain"/>');
        }
        document.forms[0].addItem.disabled = true;
        return false;
    }
    if(needNativeDomain){
        alert('<bean:message key="alert.need.native.domain"/>');
        document.forms[0].addItem.disabled = true;
        return false;
    }
    return true;
}

function checkNisDomain(){
    if(document.forms[0].elements["detailInfo.seletedNisDomain"].options[0].selected == true
        && document.forms[0].elements["detailInfo.seletedNisDomain"].disabled ==false){
        alert('<bean:message key="alert.need.nis.domain"/>');
        return false;
    }
    return true;
}

function onChangeClient(){
    if(document.forms[0].client.value.charAt(0) == "@"){
        document.forms[0].elements["detailInfo.seletedNisDomain"].disabled = false;
    }else{
        document.forms[0].elements["detailInfo.seletedNisDomain"].disabled = true;
    }
    if(document.forms[0].client.value != "" && 
        ((!needAuthDomain && !needNativeDomain)|| document.forms[0].um[1].checked == false)){
        document.forms[0].addItem.disabled = false;
    }else{
        document.forms[0].addItem.disabled = true;
    }
}

function selectOneItem(index,refresh){
    var options = document.forms[0].shareList.options;
    options[index].selected = true;
    if(index == options.length-1){
        document.forms[0].downItem.disabled = true;
    }else{
        document.forms[0].downItem.disabled = false;
    }
    if(index == 0){
        document.forms[0].upItem.disabled = true;
    }else{
        document.forms[0].upItem.disabled = false;
    }
    if(refresh){
        refreshOptions();
        onChangeClient();
    }
}

function onDeleteItem(){
    var options = document.forms[0].shareList.options;
    var index = options.selectedIndex;
    var lastIndex = index;
    for(; index < options.length-1; index++){
        options[index].value = options[index+1].value;
        options[index].text = options[index+1].text;
    }
    options.length--;
    if(options.length == 0){
        document.forms[0].deleteItem.disabled = true;
        if(parent.frames[1] && parent.frames[1].loaded == 1) {
            enableSetBtn=0;
            parent.frames[1].document.forms[0].set.disabled = true;
        }
        otherParams = new Array();
        isValidProc=true;
        return;
    }
    if(lastIndex == options.length && lastIndex != 0){
        selectOneItem(lastIndex-1,true);
    }else{
        selectOneItem(lastIndex,true);
    }
}

function onUpItem(){
    var options = document.forms[0].shareList.options;
    var index = options.selectedIndex;
    if(options[index].value == ""){
        return;
    }
    if(index > 0){
        if(options[index-1].value == ""){
            return;
        }
        reverseItem(options[index],options[index-1]);
        selectOneItem(index-1,false)
    }
}

function onDownItem(){
    var options = document.forms[0].shareList.options;
    var index = options.selectedIndex;
    if(options[index].value == ""){
        return;
    }
    if(index < options.length-1){
        if(options[index+1].value == ""){
                return;
        }
        reverseItem(options[index],options[index+1]);
        selectOneItem(index+1,false);
    }
}

function trim(str){
    if(str == null || str == undefined){
        return str;
    }
    str = str.replace(/^\s*/,"");
    return str.replace(/\s*$/,"");
}

function resetAllParams(){
    document.forms[0].elements["detailInfo.seletedNisDomain"].options[0].selected = true;
    document.forms[0].um[0].checked = true;
    document.forms[0].access[1].checked = true;
    document.forms[0].trans[0].checked = true;
    document.forms[0].subtree.checked = true;
    document.forms[0].hide.checked = true;
    document.forms[0].port.checked = true;
    document.forms[0].accesslog.checked = false;
    document.forms[0].uid.value = "-2";
    document.forms[0].gid.value = "-2";
    <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
    document.forms[0].unstablewrite.checked = false;
    </logic:equal>
    otherParams = new Array();
    selectedProc = null;
    isValidProc=true;
}

function onChangeItem(){
    selectOneItem(document.forms[0].shareList.options.selectedIndex,true);
}

function extractAccesslogProc(str) {
    var re=/\baccesslogproc\=\"([^\"]*)\"[,\)]/;
    if(!str.match(/\baccesslogproc\b/)) {
        isValidProc=true;
        return str;
    }
    if(str.match(re)) {
        var accesslogproc=RegExp.$1;
        selectedProc = new Array(11);
        if(trim(accesslogproc)!=""){
            tempArray = accesslogproc.split(",");
            OUTer:
            for(var i=0;i<tempArray.length; i++) {
                for(var j=0;j<allprocedures.length; j++) {
                    if(tempArray[i] == allprocedures[j]) {
                        selectedProc[j] = allprocedures[j];
                        continue OUTer; 
                    }
                }
                isValidProc=false;
                break;
            }
        }
    } else {
        isValidProc=false;
    }
    if(!isValidProc) {
        selectedProc=null;
    }
    str=str.replace(/\baccesslogproc\s*\=\s*\"[^\"]*\"\s*[,]+/g, "");
    str=str.replace(/\baccesslogproc\s*\=\s*\"[^\"]*\"\s*[\)]+/g, ")");
    str=str.replace(/\,+/g, ",");
    str=str.replace(/^,*/, "");
    str=str.replace(/,*$/, "");
    return str;
}
 
function refreshOptions(){
    resetAllParams();
    var options = document.forms[0].shareList.options;
    var index = options.selectedIndex;
    var text = options[index].value;
    text=extractAccesslogProc(text);
    document.forms[0].client.value = trim(text.substring(0,text.indexOf("(")));
    var params = text.substring(text.indexOf("(")+1,text.length-1).split(",");
    var hasMap = false;
    var hasAnon = false;
    while(params.length){
        var param = params.pop();
        param = trim(param);
        var keyAndValue = param.split("=");
        var key = trim(keyAndValue[0]);
        var value = trim(keyAndValue[1]);
        if(key == nisdomain){
            var nisOptions = document.forms[0].elements["detailInfo.seletedNisDomain"].options;
            var j = 0;
            for(; j < nisOptions.length; j++){
                if(nisOptions[j].value == value){
                    nisOptions[j].selected = true;
                    break;
                }
            }
            if(j == nisOptions.length){
                resetNisDomain(window);
            }
        }else if(param == map){
            document.forms[0].um[1].checked = true;
            hasMap = true;
        }else if(param == anon){
            hasAnon = true;
        }else if(param == rw){
            document.forms[0].access[0].checked = true;
        }else if(param == all_squash){
            document.forms[0].trans[1].checked = true;
        }else if(param == no_root_squash){
            document.forms[0].trans[2].checked = true;
        }else if(key == anonuid){
            document.forms[0].uid.value = value;
        }else if(key == anongid){
            document.forms[0].gid.value = value;
        }else if(param == no_subtree_check){
            document.forms[0].subtree.checked = false;
        }else if(param == nohide){
            document.forms[0].hide.checked = false;
        }else if(param == insecure){
            document.forms[0].port.checked = false;
        }else if(param == accesslog){
            var procNotEmpty;
            if(selectedProc!=null) {
                for(var i=0; i<selectedProc.length; i++) {
                    procNotEmpty = procNotEmpty || selectedProc[i];
                }
            }
            if(selectedProc==null || procNotEmpty) {
                document.forms[0].accesslog.checked = true;
            }
        <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
        }else if(param == unstable_write){
            document.forms[0].unstablewrite.checked = true;
        </logic:equal>
        }else if(param != null && param != ""){
            otherParams.unshift(param);
        }
    }
    if(hasMap && hasAnon){
        document.forms[0].um[2].checked = true;
    }
    document.forms[0].accesslog.onclick();
}

function onAddItem(){
    if(!checkExportsTo(document.forms[0].client.value)){
        alert('<bean:message key="alert.invalid.client.value"/>');
        document.forms[0].client.focus();
        return false;
    }
    if(!checkNisDomain()){
        return false;
    }
    var options = document.forms[0].shareList.options;
    if(!checkID(document.forms[0].uid.value)){
        alert('<bean:message key="alert.invalid.gid.or.uid"/>');
        document.forms[0].uid.focus();
        return false;
    }
    if(!checkID(document.forms[0].gid.value)){
        alert('<bean:message key="alert.invalid.gid.or.uid"/>');
        document.forms[0].gid.focus();
        return false;
    }
    if(options.length == 0){
        document.forms[0].deleteItem.disabled = false;
        if(parent.frames[1] && parent.frames[1].loaded==1) {
            enableSetBtn=1;
            parent.frames[1].document.forms[0].set.disabled = false;
        }
    }
    options.length++;
    var textAndValue = createShareItem();
    options[options.length-1].value = textAndValue;
    options[options.length-1].text = textAndValue;
    selectOneItem(options.length-1,false);
}

function reverseItem(item1,item2){
    var value = item1.value;
    var text = item1.text;
    item1.value = item2.value;
    item1.text = item2.text;
    item2.value = value;
    item2.text = text;
}

function submitAll(){
    if (isSubmitted()){
        return false;
    }
    if(document.forms[0].selectedDir.value == ""){
        alert('<bean:message key="alert.no.directory.value"/>');
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    var clientOptions = "";
    var options = document.forms[0].shareList.options;
    for(var i = 0; i < options.length; i++){
        clientOptions += options[i].value+"\n";
    }
    document.forms[0].elements["detailInfo.clientOptions"].value = clientOptions;
    document.forms[0].elements["detailInfo.needAuthDomain"].value = needAuthDomain;
    document.forms[0].elements["detailInfo.needNativeDomain"].value = needNativeDomain;
    document.forms[0].elements["detailInfo.isSxfsfw"].value = isSxfsfw;
    document.forms[0].elements["detailInfo.isSubMountPoint"].value = isSubMountPoint;
    document.forms[0].elements["detailInfo.seletedNisDomain4Unix"].value = seletedNisDomain;
    document.forms[0].elements["detailInfo.seletedNisDomain4Win"].value = seletedNisDomain4Win;
    document.forms[0].submit();
    return true;
}

function popupNavigator() {
    if (isSubmitted()){
       return false;
    }
    document.forms[1].rootDirectory.value = expgrp;
    if(trim(document.forms[0].selectedDir.value) != ""){
        document.forms[1].nowDirectory.value = expgrp + '/' + document.forms[0].selectedDir.value;
    }else{
        document.forms[1].nowDirectory.value = document.forms[1].rootDirectory.value;
    }
    document.forms[1].fsType.value = isSxfsfw?'sxfsfw':'sxfs';
    document.forms[1].isSubMount.value = isSubMountPoint?'1':'0';
    document.forms[1].hasDomain.value = needAuthDomain?'0':'1';
    
    if(navigatorWin == null || navigatorWin.closed){
        navigatorWin = window.open("/nsadmin/common/commonblank.html","nfs_show_navigator", "resizable=yes,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=460,height=400");
        document.forms[1].submit();
    }else{
        navigatorWin.focus();
    }
    return true;
}

function closePopupWin(win){
    if (win != null && !win.closed){
        if(win.window.frames[0]){
            if(win.window.frames[0].document.body.onunload){
                win.window.frames[0].document.body.onunload="";
            }else{
                win.window.frames[0].onunload="";
            }
        }else{
            if(win.document.body.onunload){
                win.document.body.onunload="";
            }else{
                win.onunload="";
            }
        }
        win.close();
    }
}

function setHelp(){
    <logic:equal name="nfsDetailForm" property="opType" value="add">
        NFS_DETAIL_LICENSE = "network_nfs_2";
        setHelpAnchor('network_nfs_2');
    </logic:equal>
    <logic:equal name="nfsDetailForm" property="opType" value="modify">
        NFS_DETAIL_LICENSE = "network_nfs_3";
        setHelpAnchor('network_nfs_3');
    </logic:equal>    
}

function onAccesslog(accesslog) {
    if(accesslog.checked == true) {
        document.forms[0].accesslogproc.disabled = false;
    } else {
        document.forms[0].accesslogproc.disabled = true;
    }
}

function onAccesslogproc() {
    if(isValidProc==false) {
        alert('<bean:message key="alert.invalid.accesslogproc"/>');
    } else {
        accesslogprocWin = window.open("<html:rewrite page='/NfsAccesslogproc.do'/>","nfs_proc_navigator", "resizable=yes,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=460,height=400");
        accesslogprocWin.focus();
    }
}

</script>
</head>
<body onload="displayAlert();init();setHelp();" onUnload="closeDetailErrorWin();closePopupWin(navigatorWin);closePopupWin(accesslogprocWin);">
<input type="button" onclick="return onBack()" value="<bean:message bundle="common" key="common.button.back"/>" />
<logic:equal name="nfsDetailForm" property="opType" value="add">
    <h3 class="title"><bean:message key="h2.add.export"/></h3>
</logic:equal>
<logic:equal name="nfsDetailForm" property="opType" value="modify">
    <h3 class="title"><bean:message key="h2.modify.export"/></h3>
</logic:equal>
<displayerror:error h1_key="title.nfs"/>
<html:form action="nfsDetailTop.do?operation=commit" method="POST">
    <html:hidden property="opType" />
    <nested:hidden property="detailInfo.clientOptions" />
    <html:hidden property="orgSelectedDir" />
    <nested:hidden  property="detailInfo.needAuthDomain"/>
    <nested:hidden  property="detailInfo.needNativeDomain"/>
    <nested:hidden  property="detailInfo.isSxfsfw"/>
    <nested:hidden  property="detailInfo.isSubMountPoint"/>
    <nested:hidden  property="detailInfo.seletedNisDomain4Unix"/>
    <nested:hidden  property="detailInfo.seletedNisDomain4Win"/> 
<table border=1>
  <tbody>
  <tr>
    <th><bean:message key="th.directory"/></th>
    <td><%=NSActionUtil.getExportGroupPath(request)%>/<input type="text" name="selectedDir" readonly="true" size="40"/> 
        <html:button property="browse" onclick="return popupNavigator();"><bean:message key="common.button.browse2" bundle="common"/></html:button>
    </td>
  </tr>
  </tbody>
</table>
<br/>
<table>
  <tbody>
  <tr>
    <td>
      <table border=1>
        <tbody>
        <tr>
          <th align="left"><bean:message key="th.connectable.client"/></th>
          <td>
            <input type="text" size="64" value="" name="client" onchange="onChangeClient()" 
            maxlength="128" onKeyUp="onChangeClient()" onBlur="onChangeClient()"/><br/>
            <bean:message key="th.nis.domain"/><nested:select property="detailInfo.seletedNisDomain" disabled="true">
                <option value="" selected>-----</option> 
                <nested:options property="detailInfo.nisDomainList"/>
            </nested:select>             
            <br/>[<font class="advice"><bean:message key="th.nis.domain.tip"/></font>]
          </td>
        </tr>
        <tr>
          <th align="left"><bean:message key="th.access.mode"/></th>
          <td>
            <input type="radio" id="rw"  checked name="access" /><label for="rw"><bean:message key="radio.read.write"/></label>
            <input type="radio" id="ro"  name="access" /><label for="ro"><bean:message key="radio.read.only"/></label>
          </td>
        </tr>
        <tr>
          <th align="left"><bean:message key="th.user.mapping"/></th>
          <td>
            <input type="radio" id="no_map" checked name="um" onclick="onChangeClient()" /><label for="no_map"><bean:message key="radio.no.map"/></label>
            <input type="radio" id="map" name="um" onclick="checkDomain();"/><label for="map"><bean:message key="radio.map"/></label>
            <input type="radio" id="anon" name="um"  onclick="onChangeClient()"/><label for="anon"><bean:message key="radio.anonymous"/></label>
          </td>
        </tr>
        <tr>
          <th align="left"><bean:message key="th.squashed.users"/></th>
          <td>
            <input type="radio" id="root_only" checked name="trans"><label for="root_only"><bean:message key="radio.root.only"/></label> 
            <br/>
            <input type="radio" id="all" name="trans"><label for="all"><bean:message key="radio.all" /></label> 
            <br/>
            <input type="radio" id="none" name="trans"><label for="none"><bean:message key="radio.none" /></label>  
          </td>
        </tr>
        <tr>
          <th align="left"><bean:message key="th.anonymous.id"/></th>
          <td>
            <bean:message key="text.uid"/>
            <input size="7" value="-2" name="uid" maxlength="6" />
            <bean:message key="text.gid"/>
            <input size="7" value="-2" name="gid" maxlength="6" />
          </td>
        </tr>
        <tr>
          <th align="left"><bean:message key="th.other.options"/></th>
          <td>
            <input type="checkbox" checked name="subtree" id="subtree"/> 
            <label for="subtree"><bean:message key="checkbox.subtree.check"/></label>
            <br/>
            <input type="checkbox" checked name="hide" id="hide" /> 
            <label for="hide"><bean:message key="checkbox.hide"/></label>
            <br/>
            <input type="checkbox" checked name="port" id="port" /> 
            <label for="port"><bean:message key="checkbox.secure"/></label>
            <br/>
            <input type="checkbox" name="accesslog" id="accesslog" onclick="onAccesslog(this)"/>
            <label for="accesslog"><bean:message key="checkbox.accesslog"/></label>
            <html:button property="accesslogproc" onclick="onAccesslogproc()" disabled="true"><bean:message key="button.accesslogproc"/></html:button>
            <br/>
            <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
            <input type="checkbox" name="unstablewrite" id="unstablewrite"/>
            <label for="unstablewrite"><bean:message key="checkbox.unstablewrite"/></label>
            <br/>
            </logic:equal>
          </td>
        </tr>
      </tbody>
    </table>
      <p><html:button property="addItem" onclick="onAddItem()" disabled="true"><bean:message key="button.add"/></html:button>
      <p><bean:message key="th.clients.list.tip"/>
      <br>
      <table>
      <tbody>
        <tr>
          <td>
            <select name="shareList" size=5 onchange="onChangeItem()"></select>
          </td>
        </tr>
      </tbody>
      </table>
      <html:button property="deleteItem" onclick="onDeleteItem()" disabled="true"><bean:message key="common.button.delete" bundle="common"/></html:button>
       &nbsp;&nbsp;&nbsp;&nbsp;
      <html:button property="upItem" onclick="onUpItem()" disabled="true"><bean:message key="button.up"/></html:button>
      <html:button property="downItem" onclick="onDownItem()" disabled="true"><bean:message key="button.down"/></html:button>    
</html:form>
<html:form target="nfs_show_navigator" 
        action="NfsNavigatorList.do">
    <html:hidden property="operation" value="call"/>
    <html:hidden property="rootDirectory" value=""></html:hidden> 
    <html:hidden property="nowDirectory" value=""></html:hidden>  
    <html:hidden property="fsType" value=""></html:hidden>  
    <html:hidden property="isSubMount" value=""></html:hidden>  
    <html:hidden property="hasDomain" value=""></html:hidden>  
</html:form>
</body>
</html>