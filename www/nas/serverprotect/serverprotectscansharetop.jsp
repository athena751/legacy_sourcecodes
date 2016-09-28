<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectscansharetop.jsp,v 1.3 2007/03/27 06:02:37 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript">
var loaded=0;
var enableModBtn=0;
var enableDeleteBtn=0;

function reloadSetPage(){
    if( isSubmitted() ){
        return false;
    }
    setSubmitted();
    parent.frames[1].disableButtons();
    parent.location = "<html:rewrite page='/serverProtectDisplayScanShare.do'/>";
    return true;
}

function init(){

    loaded = 1;                

    <logic:empty name="scanShareList" scope="request">
        enableDeleteBtn=0;
        enableModBtn=0;
    </logic:empty>
    <logic:notEmpty name="scanShareList" scope="request">
        enableDeleteBtn=1;
        enableModBtn=1;
    </logic:notEmpty>
    
    if(document.forms[0].selectRadio != null && document.forms[0].selectRadio != undefined){
        if(document.forms[0].selectRadio[0] != null){
            for(var i = 0 ; i < document.forms[0].selectRadio.length; i++){
                if(document.forms[0].selectRadio[i].checked == true){
                    document.forms[0].selectRadio[i].click(); 
                    break;
                }
            }
        }else{
            document.forms[0].selectRadio.click(); 
        }
    } 
    
    if (parent.frames[1]){
        setTimeout('parent.frames[1].location="' + '<html:rewrite page="/serverProtectDisplayScanShareBottom.do"/>' + '"',1);
    } 
    
    return true;
}

function onSelect(selectedShare,readCheck,writeCheck) {
    document.forms[0].selectedShare.value = selectedShare;
    document.forms[0].readCheck.value = readCheck;
    document.forms[0].writeCheck.value = writeCheck;
}

function onShareAdd(){
    if (isSubmitted()){
        return false;
    }
    if(!parent.frames[0].loaded){
        return false;
    }       
    setSubmitted();
    parent.frames[1].disableButtons();
    parent.frames[0].document.forms[0].action="../../serverprotect/serverProtectScanShareAdd.do?operation=entry";
    parent.frames[0].document.forms[0].target = "_parent";
    parent.frames[0].document.forms[0].submit();
    return true;
}

</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('nvavs_realtimescan_3');" >

<html:form action="serverProtectScanShare.do?operation=delete" method="POST">

<input type="button" name="refresh" 
    value="<bean:message key='common.button.reload' bundle='common'/>" 
    onclick="return reloadSetPage()"/>
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" name="shareAdd" value='<bean:message key="common.button.add2" bundle="common"/>' onclick="onShareAdd()"/>
<br>

<displayerror:error h1_key="serverprotect.common.h1"/>
<br>

<logic:empty name="scanShareList" scope="request">
<table border="0">
    <tr>
        <td>
        <bean:message key="serverprotect.tip.notopshare"/>
        </td>
    </tr>
</table>
</logic:empty>

<logic:notEmpty name="scanShareList" scope="request">

<input type="hidden" name="selectedShare"/>
<input type="hidden" name="readCheck"/>
<input type="hidden" name="writeCheck"/>

<bean:define id="scanShareList" name="scanShareList" scope="request"/>
<nssorttab:table  tablemodel="<%=new ListSTModel((ArrayList)scanShareList)%>" 
                      id="scanlist"
                      table="border=1" 
                      titleTrNum="2"
                      sortonload="shareName:ascend" >
                      
            <nssorttab:column name="selectRadio" 
                              th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender" 
                              td="com.nec.nsgui.action.serverprotect.ServerProtectTRadioRender">
            </nssorttab:column>
			<nssorttab:column name="shareName"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
				<bean:message key="serverprotect.scantarget.sharename.th" />
			</nssorttab:column>
			<nssorttab:column name="readCheck"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
				sortable="no">
				<bean:message key="serverprotect.scantarget.readcheck.th" />
			</nssorttab:column>
			<nssorttab:column name="writeCheck"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
				sortable="no">
				<bean:message key="serverprotect.scantarget.writecheck.th" />
			</nssorttab:column>
			<nssorttab:column name="sharePath"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
				<bean:message key="serverprotect.scantarget.sharedirectory.th" />
			</nssorttab:column>
            
        </nssorttab:table>

</logic:notEmpty>

</html:form>
</body>

</html>

