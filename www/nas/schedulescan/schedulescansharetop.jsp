<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: schedulescansharetop.jsp,v 1.2 2008/05/14 08:11:06 chenjc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%> 
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var buttonEnable = 0;

function init(){    
    setHelpAnchor("nvavs_schedulescan_4");    
    <logic:notEmpty name="schedulescan_shareUnused">  
        var unusedShareObj=document.forms[0].elements["unusedScanShare"];
        sortOptions(unusedShareObj);
        unusedShareObj.selectedIndex=0;
    </logic:notEmpty>
    decideButtonStatus();
    initConfirm();
    displayAlert();
    enableBottomButton();
    return ;    
}

function initConfirm(){
<logic:equal name="schedulescan_haveConnection" value="yes" scope="request">
    if(isSubmitted()){
        return false;
    }
    if(confirm("<bean:message key="schedulescan.alert.haveconnection"/>")){
       setSubmitted();
       if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
           parent.frames[1].document.forms[0].set.disabled=true;
       }
       document.forms[0].action="scheduleScanShare.do?operation=setShareInfo";
       document.forms[0].submit();
       return true;
    }
    return false;
</logic:equal>
}

function onReload(){
    if (isSubmitted()){
        return false;
    }
    if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
        parent.frames[1].document.forms[0].set.disabled=true;
    }else{
        return false;
    }
    setSubmitted();
    document.forms[0].action = "scheduleScanShare.do?operation=getShareInfo";
    document.forms[0].submit();
    return true;
}

function enableBottomButton(){
    <logic:notEmpty name="schedulescan_shareUnused" scope="request">        
        buttonEnable = 1;       
    </logic:notEmpty>
    <logic:notEmpty name="schedulescan_shareUsed" scope="request">
        buttonEnable = 1;
    </logic:notEmpty>    
    if(window.parent.frames[1].document && 
       window.parent.frames[1].document.forms[0] &&
       !isSubmitted()) {
        window.parent.frames[1].enableButton();
    }
}

function decideButtonStatus(){
    var addButton = document.forms[0].elements["add"];
    var delButton = document.forms[0].elements["del"];
    var addallButton = document.forms[0].elements["addall"];
    var delallButton = document.forms[0].elements["delall"];
    if (document.forms[0].elements["unusedScanShare"].length  > 0){
        addButton.disabled = false;
        addallButton.disabled = false;
    }else{
        addButton.disabled = true;
        addallButton.disabled = true;
    }
    if (document.forms[0].elements["usedScanShare"].length  > 0){
        delButton.disabled = false;
        delallButton.disabled = false;
    }else{
        delButton.disabled = true;
        delallButton.disabled = true;
    }
}

function sortOptions(selectObj){
    var valueArr = new Array(); 
    var textHash = new Object();
    var selectedHash = new Object();
    var oOptions=selectObj.options;

    for (var i = 0; i < oOptions.length; i++){
        valueArr[i] = oOptions[i].value; 
        textHash[valueArr[i]] = oOptions[i].text;
        if(oOptions[i].selected){
            selectedHash[valueArr[i]]=0;
        }
    }
    valueArr.sort();
    var parent = selectObj.parentNode;
    var cloneSelect = selectObj.cloneNode(true);
    parent.replaceChild(cloneSelect, selectObj);
    selectObj.selectedIndex=-1;
    for (var i = 0; i < valueArr.length; i++){
        //re-building the select's all options costs more time than modifying their text and value
        oOptions[i].text = textHash[valueArr[i]];
        oOptions[i].value = valueArr[i];
        if(valueArr[i] in selectedHash){
            oOptions[i].selected=true;
        }
    }
    parent.replaceChild(selectObj, cloneSelect);;
    return true;
}

function moveSelectedOptions(fromObj, toObj){
    toObj.selectedIndex=-1;
    var selectedIndexTag=-1;
    //begin moving from the end option
    for(var i=fromObj.options.length-1;i>=0;i--){
        if (fromObj.options[i].selected) {
            toObj.appendChild(fromObj.options[i]); //move the option from fromObj to toObj
            selectedIndexTag=i;
        }
    }
    fromObj.selectedIndex=Math.min(selectedIndexTag,fromObj.length-1);
    decideButtonStatus();
}

function moveAllOptions(fromObj, toObj){
    toObj.selectedIndex=-1;
    for(var i=fromObj.options.length-1;i>=0;i--){
        var oOption=fromObj.options[i];
        toObj.appendChild(oOption);
        oOption.selected=true;
    }
    decideButtonStatus();
}

function onAdd(){
    var unusedShareObj=document.forms[0].elements["unusedScanShare"];
    var usedShareObj=document.forms[0].elements["usedScanShare"];
    moveSelectedOptions(unusedShareObj, usedShareObj);          
    return;
}

function onDel(){
    var unusedShareObj=document.forms[0].elements["unusedScanShare"];
    var usedShareObj=document.forms[0].elements["usedScanShare"];
    moveSelectedOptions(usedShareObj, unusedShareObj);
    //calling sortOptions() immediately  can not work normally in IE
    sortOptions(unusedShareObj);
    return;
}

function onAddAll(){
    var unusedShareObj=document.forms[0].elements["unusedScanShare"];
    var usedShareObj=document.forms[0].elements["usedScanShare"];
    var oOptions=unusedShareObj.options;
    /**This way costs more time to move all options
    for(var i=0; i<unusedShareObj.length; i++){
        oOptions[i].selected=true;
    }
    moveSelectedOptions(unusedShareObj, usedShareObj); 
    */
    moveAllOptions(unusedShareObj, usedShareObj);
}

function onDelAll(){
    var unusedShareObj=document.forms[0].elements["unusedScanShare"];
    var usedShareObj=document.forms[0].elements["usedScanShare"];
    var oOptions=usedShareObj.options;
    moveAllOptions(usedShareObj, unusedShareObj);
    sortOptions(unusedShareObj);
}

function setShareInfo(){
    var usedShareObj=document.forms[0].elements["usedScanShare"];
    var unUsedShareObj=document.forms[0].elements["unusedScanShare"];
    if(usedShareObj.length > 0){
        var share=usedShareObj.options[0].value;
        for(var i=1; i<usedShareObj.length; i++){
            share=share+","+ usedShareObj.options[i].value;
        }
        document.forms[0].usedScanShareSet.value=share;
    }else{
        document.forms[0].usedScanShareSet.value="";
    }
    if(unUsedShareObj.length > 0){
        var share=unUsedShareObj.options[0].value;
        for(var i=1; i<unUsedShareObj.length; i++){
            share=share+","+ unUsedShareObj.options[i].value;
        }
        document.forms[0].unusedScanShareSet.value=share;
    }else{
        document.forms[0].unusedScanShareSet.value="";
    }
}

function onSetShareInfo(){ 
    if (isSubmitted()) {
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.submit" bundle="common"/>')){
            return false;
    }   
    setSubmitted();
    setShareInfo();
    document.forms[0].submit();       
    return true; 
}

</script>
</head>
<body onload="init();" onunload="closeDetailErrorWin();">
<html:form action="scheduleScanShare.do?operation=checkConnection">

<input type="button" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="onReload()"/>
<br>
<displayerror:error h1_key="schedulescan.common.h1"/>

<logic:empty name="schedulescan_shareUnused" scope="request">
    <logic:empty name="schedulescan_shareUsed" scope="request">
        <br>
        <bean:message key="schedulescan.share.noshare"/>
        <br>
    </logic:empty>
</logic:empty>
<br>

<html:hidden property="unusedScanShareSet"/>
<html:hidden property="usedScanShareSet"/>

<table class="Vertical" border=0>
<tr>
    <td><font size="2"><bean:message key="schedulescan.share.select.unused"/></font></td>
    <td>&nbsp;</td>
    <td><font size="2"><bean:message key="schedulescan.share.select.used"/></font></td>
</tr>
<tr>
    <td align="center">
        <select size="8" style="width:160px; " multiple name="unusedScanShare">
        <logic:notEmpty name="schedulescan_shareUnused">
            <logic:iterate id="unusedShare" name="schedulescan_shareUnused">               
                <option value="<bean:write name="unusedShare"/>">                    
                    <%=NSActionUtil.htmlSanitize(unusedShare.toString())%>
                </option>
            </logic:iterate>
        </logic:notEmpty>
        </select>
    </td>
    <td align="center">
        <input type="button" name="add" onclick="return onAdd()" 
               value="<bean:message key="schedulescan.share.button.add"/>"/>
        <br><br>
        <input type="button" name="del" onclick="return onDel()" 
               value="<bean:message key="schedulescan.share.button.del"/>"/>
    </td>
    <td align="center">
        <select size="8" style="width:160px; " multiple name="usedScanShare">
        <logic:notEmpty name="schedulescan_shareUsed">
            <logic:iterate id="usedShare" name="schedulescan_shareUsed">               
                <option value="<bean:write name="usedShare"/>">                    
                    <%=NSActionUtil.htmlSanitize(usedShare.toString())%>
                </option>
            </logic:iterate>
        </logic:notEmpty>
        </select>        
    </td>
</tr>
<tr>
    <td align="center">
        <input type="button" name="addall" onclick="return onAddAll()" 
               value="<bean:message key="schedulescan.share.button.addall"/>"/>
    </td>
    <td>&nbsp;</td>
    <td align="center">
        <input type="button" name="delall" onclick="return onDelAll()" 
               value="<bean:message key="schedulescan.share.button.delall"/>"/>
    </td>
</tr>
</table>
</html:form>
</body>
</html>