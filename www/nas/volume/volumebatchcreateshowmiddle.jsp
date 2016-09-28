<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreateshowmiddle.jsp,v 1.10 2008/05/24 12:20:03 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>

<bean:define id="lunsSize" name="volume_volumeNumber" scope="session"/>
<%
    String lvNumber = (String)session.getAttribute("volume_availLvNumber");
    if(lvNumber == null){
        lvNumber = "0";
    }
    String contextPath = request.getContextPath();
%>

<script language="JavaScript">

function checkboxBlur(obj){
    if(obj.checked){
        obj.checked = false;
    }
}

var winNavigatorHandler;
function popupNavigator(index) {
    if (document.forms[0].elements["volumes["+index+"].mountPoint"].value == "") {
        document.forms[0].nowDirectory.value = document.forms[0].rootDirectory.value ;
    } else {
         var mpShowObj = document.forms[0].elements["volumes["+index+"].mountPoint"];
         if (checkMountPointName(mpShowObj.value) != true){
            alert('<bean:message key="msg.batchcreateshow.alert.invalidmpnamenas"  arg0="\'+mpShowObj.value+\'" />');
            mpShowObj.focus();
            return false;
         }
    
        document.forms[0].nowDirectory.value = document.forms[0].rootDirectory.value + "/" 
                                        + document.forms[0].elements["volumes["+index+"].mountPoint"].value;    
    }
    document.forms[0].rootDirectory.value = compactPath(document.forms[0].rootDirectory.value);
    document.forms[0].nowDirectory.value = compactPath(document.forms[0].nowDirectory.value);
   
    if(winNavigatorHandler!=null && !winNavigatorHandler.closed){
        winNavigatorHandler.close();
    }
    
    winNavigatorHandler = window.open("/nsadmin/common/commonblank.html","volume_batchcreate_navigator", "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
    winNavigatorHandler.focus();
    window.mpPath = document.forms[0].elements["volumes["+index+"].mountPoint"];
    document.forms[0].action = "<%=contextPath%>/volume/VCNavigatorList.do?method=call";
    document.forms[0].method = "post";
    document.forms[0].target = "volume_batchcreate_navigator";
    document.forms[0].submit();    
}



function onConfirm(){
    var selectLunNum = 0;
    <logic:equal name="volume_machineType" value="nashead" scope="session">
        if (<%=(String)lunsSize%> == 1) {
            if (document.forms[0].selectOrNot.checked == false) {
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" + "<bean:message key="msg.batchcreateshow.alert.selectlun"/>");
                return false;   
            }
            
            var devicename = document.forms[0].elements["volumes0storage"].value + " " + document.forms[0].elements["volumes0lun"].value;
            if (!checkVolumeName(document.forms[0].elements["volumes[0].volumeName"] , document.forms[0].elements["volumes[0].volumeName"] , devicename)) {
                return false;
            }
            
            if (!checkMPName(document.forms[0].elements["volumes[0].mountPoint"] , document.forms[0].elements["volumes[0].mountPoint"] , devicename)) {
                return false;
            }
            selectLunNum++;
        } else {
            var devicename;
            for (var i=0;i<<%=(String)lunsSize%>;i++){
                if (document.forms[0].selectOrNot[i].checked) {
                    devicename = document.forms[0].elements["volumes"+i+"storage"].value + " " + document.forms[0].elements["volumes"+i+"lun"].value;
                    
                    if (!checkVolumeName(document.forms[0].elements["volumes["+i+"].volumeName"] , document.forms[0].elements["volumes["+i+"].volumeName"] , devicename)) {
                        return false;
                    }
            
                    if (!checkMPName(document.forms[0].elements["volumes["+i+"].mountPoint"] , document.forms[0].elements["volumes["+i+"].mountPoint"] , devicename)) {
                        return false;
                    }
                    selectLunNum++;
                }
            }
            if(selectLunNum == 0){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" + "<bean:message key="msg.batchcreateshow.alert.selectlun"/>");
                return false; 
            }
        }
        if(selectLunNum > <%=(String)lvNumber%>){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" + "<bean:message key="msg.batchcreateshow.alert.max.lun" arg0="<%=(String)lvNumber%>"/>");
            return false; 
        }
    </logic:equal>

    <logic:equal name="volume_machineType" value="nas" scope="session">
    for (var i=0;i<256;i++){
        if (document.forms[0].elements["volumes["+i+"].volumeName"]) {
            if (!checkVolumeName(document.forms[0].elements["volumes["+i+"].volumeName"] , document.forms[0].elements["volumes["+i+"].volumeName"] , "")) {
                return false;
            }
        
            if (!checkMPName(document.forms[0].elements["volumes["+i+"].mountPoint"] , document.forms[0].elements["volumes["+i+"].mountPoint"] , "")) {
                return false;
            }
        }
    }
    </logic:equal>
    
    return openWin();
}

function checkVolumeName(volumenameobj , focusobj , devicename){
    var avail = /[^A-Za-z0-9_-]/g;
    if (volumenameobj.value == "" || volumenameobj.value.search(avail) != -1) {
        if (devicename != "") {
            alert('<bean:message key="msg.batchcreateshow.alert.invalidVolumeNamenashead" arg0="\'+devicename+\'" />');
        } else {
            alert('<bean:message key="msg.batchcreateshow.alert.invalidVolumeNamenas"/>');
        }
        focusobj.focus();
        return false;
    }
    return true;
}

function checkMPName(mpnameobj , focusobj , devicename) {
    mpnameobj.value = compactPath(mpnameobj.value);
    if (mpnameobj.value == "" || mpnameobj.value == "/") {
        if (devicename != "") {
            alert('<bean:message key="msg.batchcreateshow.alert.selectmpnashead" arg0="\'+devicename+\'" />');
        } else {
            alert('<bean:message key="msg.batchcreateshow.alert.selectmpnas"/>');
        }
        focusobj.focus();
        return false;
    }
    
    
    var valid = /^[~\.\-]|[^0-9a-zA-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
    if(mpnameobj.value.search(valid)!=-1){
        if (devicename != "") {
            alert('<bean:message key="msg.batchcreateshow.alert.invalidmpnamenashead" arg0="\'+devicename+\'"   arg1="\'+mpnameobj.value+\'" />');
        } else {
            alert('<bean:message key="msg.batchcreateshow.alert.invalidmpnamenas"  arg0="\'+mpnameobj.value+\'" />');
        }   
        focusobj.focus();   
        return false; 
    }
    
    var fullPath = document.forms[0].rootDirectory.value + "/" + mpnameobj.value;
    
    if (fullPath.length > 2047){
        alert("<bean:message key="msg.add.maxMPLength"/>");
        focusobj.focus();   
        return false;                
    }
    
    if (chkEveryLevel(mpnameobj.value)){
        alert("<bean:message key="msg.add.maxDirLength"/>");
        focusobj.focus();   
        return false;               
    }
    
    return true;
}

function chkEveryLevel(str){
    var tmpArray=new Array();
    var reg=/\//g;
    tmpArray=str.split(reg);
    for (var index=0; index<tmpArray.length; index++){
        if (tmpArray[index].length>255){
            return true;
        }
    }
    return false;
}

var winConfirmHandler;
function openWin()
{
    if(winConfirmHandler!=null && !winConfirmHandler.closed){
        winConfirmHandler.close();
    }
    winConfirmHandler=window.open("/nsadmin/common/commonblank.html","batchcreateconfirm","toolbar=no,menubar=no,scrollbars=yes,width=800,height=600,resizable=yes");
    winConfirmHandler.focus();
    document.forms[0].action="<%=contextPath%>/volume/volumeBatchCreateConfirm.do?operation=confirm";
    document.forms[0].target="batchcreateconfirm";
    document.forms[0].method = "post";
    document.forms[0].submit();
    return false;
}
</script>
</head>

<body onunload="unLockMenu();closePopupWin(winConfirmHandler);closePopupWin(winNavigatorHandler);">
<form action="<%=contextPath%>/volume/volumeBatchCreateConfirm.do?operation=confirm" onSubmit="return false;">
<table width="100%" border="1">
<tr>
<logic:equal name="volume_machineType" value="nashead" scope="session">
    <th>&nbsp;</th>
    <th><bean:message key="info.storage"/></th>
    <th><bean:message key="info.lun"/></th>
</logic:equal>
<th><bean:message key="info.batchcreateshow.size"/></th>
<th><bean:message key="title.h1"/></th>
<th><bean:message key="info.mountpoint"/></th>
<th><bean:message key="info.fsType"/></th>
<th><bean:message key="info.option"/></th>
</tr>

<bean:define id="machineType" name="volume_machineType" scope="session"/>
<bean:define id="hasReplicLicense" name="volume_hasReplicLicense" scope="session"/>


<logic:iterate id="oneVolume"  name="volumeBatchCreateForm" property="volumes" indexId="i">
<logic:notEqual name="oneVolume" property="<%=machineType.equals("nas")?"poolNo":"lun"%>" value="">	
    <tr valign="top">
    <logic:equal name="volume_machineType" value="nashead" scope="session">
        <td><input type="checkbox" name="selectOrNot" value="<%=i%>"  id="select<%=i%>"></td>
        <td><label for="select<%=i%>"><bean:write name="oneVolume" property="storage"/></label></td>
        <td><bean:write name="oneVolume" property="lunDisplay"/>
            <input type="hidden" name="volumes<%=i%>storage" value='<bean:write name="oneVolume" property="storage"/>'>
            <input type="hidden" name="volumes<%=i%>lun" value='<bean:write name="oneVolume" property="lunDisplay"/>'>
            <input type="hidden" name="volumes[<%=i%>].lun" value='<bean:write name="oneVolume" property="lun"/>'>
            <input type="hidden" name="volumes[<%=i%>].ldPath" value='<bean:write name="oneVolume" property="ldPath"/>'>
        </td>
    </logic:equal>	
    	
    <td align="right">
        <bean:define id="showCap"  name="oneVolume" property="capacity" type="java.lang.String"/>
        <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap))%>
    </td>
    <td><input type="text" name="volumes[<%=i%>].volumeName" value='<bean:write name="oneVolume" property="volumeName"/>' size="10" maxlength="16"></td>		
    
    <td>
        <bean:write name="volume_exportgroup"/>/
        <input type="text" name="volumes[<%=i%>].mountPoint" value='<bean:write name="oneVolume" property="mountPoint"/>' size="10" maxlength="2047">
        <input type="button" value='<bean:message key="common.button.browse2" bundle="common"/>' onClick="popupNavigator(<%=i%>)">
    </td>
    	
    <td>
        <input type="radio" name="volumes[<%=i%>].fsType" id="fsType<%=i%>1"  value="sxfs" checked >
        <label for="fsType<%=i%>1"><bean:message key="info.fsType.sxfs"/></label>
        <br>
        <input type="radio" name="volumes[<%=i%>].fsType" id="fsType<%=i%>2" value="sxfsfw" >
        <label for="fsType<%=i%>2"><bean:message key="info.fsType.sxfsfw"/></label>
    </td>
    
    <td>
        <input type="checkbox" name="quota<%=i%>" checked id="quota<%=i%>" value="true">
        <label for="quota<%=i%>"><bean:message key="info.quota"/></label>
        <br>
        <input type="checkbox" name="noatime<%=i%>" checked id="noatime<%=i%>" value="true">
        <label for="noatime<%=i%>"><bean:message key="info.noatime"/></label>
<!--        <br>
        <input type="checkbox" name="dmapi<%=i%>" id="dmapi<%=i%>" value="true">
        <label for="dmapi<%=i%>"><bean:message key="info.dmapi"/></label>
 -->       <br>
		<input type="checkbox" name="replication<%=i%>" id="repli<%=i%>" value="true" <%=(((String)hasReplicLicense).equals("true") && (new Double(showCap).compareTo(new Double(VolumeActionConst.VOLUME_SIZE_20TB)) <= 0) )?"":"disabled"%> onclick="if (this.disabled) checkboxBlur(this)">
        <label for="repli<%=i%>"><bean:message key="info.batchcreateshow.replication"/></label>
    </td>		
    </tr>
</logic:notEqual>
</logic:iterate>
</table>

<input type="hidden" name="rootDirectory" value='<bean:write name="volume_exportgroup"/>'>
<input type="hidden" name="nowDirectory" value="">
</form>
</body>
</html:html>

