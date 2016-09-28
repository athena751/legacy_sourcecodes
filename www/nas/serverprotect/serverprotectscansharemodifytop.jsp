<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectscansharemodifytop.jsp,v 1.4 2007/03/30 08:41:06 liul Exp $" -->

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
        setTimeout('parent.frames[1].location="' + '<html:rewrite page="/serverProtectDisplayScanShareModifyBottom.do"/>' + '"',1);
    }   
    return true;
}

function onChangeScan(){
    if(document.forms[0].writescan.checked==false && document.forms[0].readscan.checked==false){
        alert('<bean:message key="serverprotect.alert.scantiming"/>');
        return false;
    }
    return true;
}

function setModify(){
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
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.frames[1].document.forms[0].setModify.disabled=true;
    parent.location.href="<html:rewrite page='/serverProtectDisplayScanShare.do'/>";
}

</script>
</head>
<body onload="init();setHelpAnchor('nvavs_realtimescan_6');" >

<html:form action="serverProtectScanShareModify.do?operation=set" method="POST">

<input type="button" name="goBack" onclick="return onBack()" 
       value='<bean:message bundle="common" key="common.button.back"/>' />

<h3 class="title"><bean:message key="serverprotect.h3.scansharemodify"/></h3>

<html:hidden property="selectedShare"/>
<html:hidden property="readCheck"/>
<html:hidden property="writeCheck"/>

<table border=1>
<tbody>
    <tr>
        <th align="left">
        <bean:message key="serverprotect.th.sharename"/>
        </th>
        <td>
        <bean:write name="ScanShareChangeForm" property="selectedShare"/>
        </td>
    </tr>
    <tr>
        <th align="left">
        <bean:message key="serverprotect.th.scantiming"/>
        </th>
        <td>
            <input type="checkbox" name="readscan" id="readscan" onclick="return onChangeScan()"
                <logic:equal name="ScanShareChangeForm" property="readCheck" value="on">
                    checked
                </logic:equal>
            />
            <label for="readscan">
                <bean:message key="serverprotect.th.readscan"/>
            </label>
            
            <input type="checkbox" id="writescan" name="writescan" onclick="return onChangeScan()"
                <logic:equal name="ScanShareChangeForm" property="writeCheck" value="on">
                    checked
                </logic:equal>
            />
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

