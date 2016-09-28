<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: setcsvdownload.jsp,v 1.7 2008/05/18 06:15:59 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
	<title>
	   <bean:message key="csvdownload.h1"/>
	</title>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
var popHeartBeat;
var enableTimer;
function disableAllButton(){
    document.forms[0].download.disabled=1;
    document.forms[0].reset.disabled=1;
    document.forms[0].close.disabled=1;
}

function enableAllButton(){
	if (popHeartBeat == null || popHeartBeat.closed){
	    document.forms[0].download.disabled=0;
	    document.forms[0].reset.disabled=0;
	    document.forms[0].close.disabled=0;
	    window.clearInterval(enableTimer);
	}
}

function disableSpecific(){
    document.forms[0].elements["options.selectedResources"].disabled=1;
    document.forms[0].elements["options.allOrSelected"][0].checked=1;
}

function enableSpecific(){
    document.forms[0].elements["options.selectedResources"].disabled=0;
    document.forms[0].elements["options.allOrSelected"][1].checked=1;
}

function initial() {
    <logic:equal name="downloading" scope="request" value="true">
    disableAllButton();
    </logic:equal>           
    initialResourceList();
}

function initialResourceList(){
    <logic:equal name="downloadForm" property="options.allOrSelected" value="all" >
        disableSpecific();
    </logic:equal>
    <logic:equal name="downloadForm" property="options.allOrSelected" value="specific" >
        enableSpecific();
    </logic:equal>
}

<bean:size id="itemlistSize" name="downloadForm" property="options.itemList" />
function resetPoperties(){
    initialResourceList();
    <logic:equal name="itemlistSize" value="1" >
        document.forms[0].elements["options.itemList"].checked=1;
    </logic:equal>
    <logic:notEqual name="itemlistSize" value="1" >
        for(var i=0;i<<%=itemlistSize%>;i++){
            document.forms[0].elements["options.itemList"][i].checked=1;
        }
    </logic:notEqual>
}

function submitProcess() {
    if (document.forms[0].elements["options.allOrSelected"][1].checked) {
        if(document.forms[0].elements["options.selectedResources"].selectedIndex==-1){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                + "<bean:message key="csvdownload.alert.no_resources"/>");
            return false;
        }
    }
    var checkedFound=false;
    <logic:equal name="itemlistSize" value="1" >
        if(document.forms[0].elements["options.itemList"].checked){
            checkedFound=true;
        } 
    </logic:equal>
    <logic:notEqual name="itemlistSize" value="1" >
        for(var i=0;i<<%=itemlistSize%>;i++){
            if(document.forms[0].elements["options.itemList"][i].checked){
                checkedFound=true;
                break;
            }
        }
    </logic:notEqual>
    if(!checkedFound){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
            + "<bean:message key="csvdownload.alert.no_items"/>");
        return false;
    }
    if(confirm("<bean:message key="common.confirm"  bundle="common"/>" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common"/>" 
            + "<bean:message key="csvdownload.Download"/>")){
        disableAllButton();
        popUpHeartbeat();
        return true;
    }
    return false;
}

<bean:parameter id="downloadWinKey" name="downloadWinKey"/>
function popUpHeartbeat(){    
    var date = new Date();
    var starttime = date.getTime();
    document.forms[1].elements["startTime"].value=starttime;
    if (popHeartBeat != null && !popHeartBeat.closed){
        popHeartBeat.focus();
    }else{
        popHeartBeat = window.open("/nsadmin/common/commonblank.html","<%=downloadWinKey%>heartbeat",
                "resizable=no,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=450,height=300");
    }
    document.forms[1].target="<%=downloadWinKey%>heartbeat";
    document.forms[1].submit();
    enableTimer = window.setInterval("enableAllButton()",1000);
}

function closeHeartbeat(){
	if (popHeartBeat != null && !popHeartBeat.closed){
        popHeartBeat.close();
    }
    return true;
}

function onClose(){
    if(document.forms[0].close.disabled==1){
        return false;
    }
    window.close();
    return true;
}
</script>
</head>
<body onload="initial();" onunload="closeHeartbeat();">
<bean:define id="watchItemDescKey" name="watchItemDescKey" scope="request" type="java.lang.String"></bean:define>
<html:form method="post" action="download.do?operation=download" onsubmit="return submitProcess();">
<h1 class="title">
    <bean:message key="<%=watchItemDescKey%>" />
</h1>
<h2><bean:message key="csvdownload.h1"/></h2>
<displayerror:error h1_key="<%=watchItemDescKey%>"/><br>
<html:hidden property="downloadInfo.originalWatchItemID" />
<html:hidden property="downloadInfo.defaultResource" />
<html:hidden property="downloadInfo.periodType" />
<html:hidden property="downloadInfo.customStartTime" />
<html:hidden property="downloadInfo.customEndTime" />
<html:hidden property="downloadInfo.collectionItemId" />
<html:hidden property="downloadInfo.host" />
<html:hidden property="downloadInfo.isSurvey" />
<html:hidden property="downloadInfo.exprgroup" />
<html:hidden property="downloadInfo.cpName" />
<html:hidden property="downloadInfo.domainName" />
<input type="hidden" name="watchItemDescKey" value="<%=watchItemDescKey%>" />
<input type="hidden" name="downloadWinKey" value="<%=downloadWinKey%>" />
<table border="1" class="Vertical">
    <tr>
        <th nowrap>
            <bean:message key="csvdownload.th_host"/>
        </th>
        <td>
            <bean:write name="downloadForm" property="downloadInfo.host"/>
        </td>
    </tr>
    <logic:equal name="needDispExpgrp" value="yes">
    	<tr>
    		<th nowrap>
    			<bean:message key="csvdownload.th_expgroup"/>
    		</th>
    		<td>
    			<bean:write name="downloadForm" property="downloadInfo.exprgroup"/>
    		</td>
    	</tr>
    	<tr>
    		<th nowrap>
    			<bean:message key="csvdownload.th_domain_computer"/>
    		</th>
    		<td>
    			<bean:write name="downloadForm" property="downloadInfo.domainName"/>/<bean:write name="downloadForm" property="downloadInfo.cpName"/>
    		</td>
    	</tr>
    </logic:equal>
    <tr>
        <th nowrap>
            <bean:message key="csvdownload.th_infotype"/>
        </th>
        <td>
            <bean:message key="<%=watchItemDescKey%>"/>
        </td>
    </tr>
    
    <tr>
        <th nowrap>
            <bean:message key="csvdownload.th_period"/>
        </th>
        <logic:notPresent name="isForSurvey">
	        <td>
	            <bean:define id="periodList" name="periodList" scope="request"></bean:define>
	            <html:select property="downloadInfo.defaultPeriod" >
	            <html:optionsCollection name="periodList"/>
	            </html:select>
	        </td>
        </logic:notPresent>
        <logic:present name="isForSurvey">
            <td>
                <html:hidden property="downloadInfo.defaultPeriod"/>
                <bean:write name="displayPeriod" />
                <bean:message key="statis.sampling.days" />
            </td>
        </logic:present>
    </tr>
    <tr>
        <th nowrap>
            <bean:message key="csvdownload.th_resources"/>
        </th>
        <td>
            <html:radio property="options.allOrSelected" value="all" styleId="all" onclick="disableSpecific()">
            <label for="all">
                <bean:message key="csvdownload.radio_all"/>
            </label> 
            </html:radio>
            <br>
            <html:radio property="options.allOrSelected" value="specific" styleId="specific" onclick="enableSpecific()">
            <label for="specific">
                <bean:message key="csvdownload.radio_specific"/>
            </label>
            </html:radio>
            <br>
            <bean:define id="resourceList" name="resourceList" scope="request"></bean:define>
            <html:select property="options.selectedResources" size="16" multiple="true">
                <html:optionsCollection name="resourceList"/>
            </html:select>
        </td>
    </tr>
    <tr>
        <th nowrap>
            <bean:message key="csvdownload.th_items"/>
        </th>
        <td>
        <logic:iterate id="item" name="downloadForm" property="options.itemList" indexId="index">
			   <bean:define id="value" name="item" type="java.lang.String"/>
			   <bean:define id="index1" name="index" type="java.lang.Integer"/>
			   <logic:notEqual name="index1" value="0" ><br></logic:notEqual>
			   <html:multibox name="downloadForm" property="options.itemList" styleId="<%=value%>" value="<%=value%>">
			   </html:multibox>
			   <label for="<%=value%>">
                       <bean:write name="item"/>
                     </label>
		 </logic:iterate>
        </td>
    </tr>
    <bean:define id="originalWatchItemId" name="downloadForm" property="downloadInfo.originalWatchItemID"></bean:define>
    <% if(originalWatchItemId.equals("Disk_Used_Rate")||originalWatchItemId.equals("Inode_Used_Rate")||originalWatchItemId.equals("Disk_Used_Quantity")||originalWatchItemId.equals("Inode_Used_Quantity")){%>
    <tr>
        <th nowrap>
            <bean:message key="csvdownload.th_column"/>
        </th>
        <td>
            <html:radio property="options.displayFSType" value="device" styleId="device">
            <label for="device">
                <bean:message key="csvdownload.radio_device"/>
             </label>
            </html:radio>
            <br>
            <html:radio property="options.displayFSType" value="mountpoint"  styleId="mp">
             <label for="mp">
                <bean:message key="csvdownload.radio_mountpoint"/>
            </label>  
            </html:radio>
        </td>
    </tr>
    <%}%>
</table>
<br>
<input type="submit" name="download"
    value="<bean:message key="csvdownload.Download"/>"
    onclick="if(this.disabled==1){return false;}" />
<input type="reset" name="reset" 
    value="<bean:message key="common.button.reset" bundle="common"/>"
    onclick="if(this.disabled==1){return false;}else{resetPoperties();}" />
<input type="button" name="close" 
    value="<bean:message key="common.button.close" bundle="common"/>"
    onclick="return onClose();" />
</html:form>

<form action="popupHeartbeat.do" method="post" >
    <input type="hidden" name="startTime" value=""/>
    <input type="hidden" name="downloadWinKey" value="<%=downloadWinKey%>" />
    <input type="hidden" name="watchItemDescKey" value="<%=watchItemDescKey%>" />
</form>

</body>
</html>
