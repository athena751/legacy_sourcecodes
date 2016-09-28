<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectscanshareaddtop.jsp,v 1.6 2007/09/25 01:56:19 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript">
var loaded=0;
var daemonState='<bean:write name="daemonState" scope="request"/>';

function init(){
    loaded = 1;                

    if (parent.frames[1]){
        setTimeout('parent.frames[1].location="' + '<html:rewrite page="/serverProtectDisplayScanShareAddBottom.do"/>' + '"',1);
    }   
    <logic:notEmpty name="serverprotect_shareNames">
        document.forms[0].share4add.options.selectedIndex=0;
    </logic:notEmpty>   
    return true;
}

function onChangeScan(){
    if(document.forms[0].writescan.checked==false && document.forms[0].readscan.checked==false){
        alert('<bean:message key="serverprotect.alert.scantiming"/>');
        return false;
    }
    return true;
}

function setAdd(){
    if(document.forms[0].readscan.checked==true){
        document.forms[0].readCheck.value="on";
    }else{
        document.forms[0].readCheck.value="off";
    }
    if(document.forms[0].writescan.checked==true){
        document.forms[0].writeCheck.value="on";
    }else{
        document.forms[0].writeCheck.value="off";
    }
    
    setSelectedShare();
}

function setSelectedShare(){
    var shareAdd="";
    var len_select=document.forms[0].share4add.options.length;
    if(len_select>0){
        for(var i=0;i<len_select;i++){
            if(document.forms[0].share4add.options[i].selected){
                shareAdd+=document.forms[0].share4add.options[i].value+";";
            }
        }
    }
    if(shareAdd.length>0){
        shareAdd=shareAdd.substring(0,shareAdd.length - 1)
    }
    document.forms[0].selectedShare.value=shareAdd;
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.frames[1].document.forms[0].setAdd.disabled=true;
    parent.location.href="<html:rewrite page='/serverProtectDisplayScanShare.do'/>";
}

</script>
</head>
<body onload="init();setHelpAnchor('nvavs_realtimescan_5');" >

<html:form action="serverProtectScanShareAdd.do?operation=set" method="POST">

<input type="button" name="goBack" onclick="return onBack()" 
       value='<bean:message bundle="common" key="common.button.back"/>' />

<h3 class="title"><bean:message key="serverprotect.h3.scanshareadd"/></h3>

<input type="hidden" name="selectedShare"/>
<input type="hidden" name="readCheck"/>
<input type="hidden" name="writeCheck"/>

<table class="Vertical" border=1>
<tbody>
    <tr>
        <th style="vertical-align:top" width="200" >
        <bean:message key="serverprotect.th.sharename"/>
        </th>
        <td>
        <select name="share4add" multiple size="10" value="" style="width:200">
            <logic:iterate id="oneShare" name="serverprotect_shareNames" indexId="i">
                <option value="<bean:write name="oneShare"/>"><%=((String[])request.getSession().getAttribute("serverprotect_shareNamesLabel"))[i.intValue()]%></option>  
            </logic:iterate>
        </select>
        </td>
    </tr>
    <tr>
        <th align="left">
        <bean:message key="serverprotect.th.scantiming"/>
        </th>
        <td>
            <input type="checkbox" name="readscan" id="readscan" onclick="return onChangeScan()" />
            <label for="readscan">
                <bean:message key="serverprotect.th.readscan"/>
            </label>
            
            <input type="checkbox" id="writescan" name="writescan" onclick="return onChangeScan()" checked/>
            <label for="writescan">
                <bean:message key="serverprotect.th.writescan"/>
            </label>
        </td>
    </tr>
</tbody>
</table>   

</html:form>
</body>

</html>

