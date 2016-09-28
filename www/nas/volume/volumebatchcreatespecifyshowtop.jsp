<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreatespecifyshowtop.jsp,v 1.12 2008/02/29 14:42:02 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<%
String contextPath = request.getContextPath();
%>
<script language="JavaScript">
var loaded=0;
var navigatorWin;
var poolSizeArray = [<bean:write name="poolSize" scope="session"/>];
var maxLdNum = <bean:write name="availLdCount4BatchCreate" scope="session"/>;
var maxLdSize = 2046;
var MAXVOLSIZE = <%=VolumeActionConst.VOLUME_MAX_SIZE%>;
var VOLSIZE20TB = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;

//get total size of all pool
function getTotalSize(){
    var pools = poolSizeArray.slice(0);
    var totalSize = 0;
    for (var i=0;i<pools.length;i++){
        totalSize += pools[i];
    }
    return totalSize;
}

//get average size of all pool
function getAverage(volNum){
    return Math.floor(getTotalSize()/volNum);
}

//get the max volNum that user can input
function getMaxNum(){
    return Math.min(maxLdNum, getTotalSize(), <bean:write name="lvNo" scope="session"/>);
}

//get the max size that user can input
function getMaxSize(){
    var pools = poolSizeArray.slice(0);
    var minSize = getTotalSize();
    var avaliLdNum = maxLdNum;
    var totalSize = 0;
    for(var i=0; i<pools.length; i++){
        var onePoolLvNum = Math.ceil(pools[i] / maxLdSize);
        if(avaliLdNum >= onePoolLvNum){
            avaliLdNum -= onePoolLvNum;
            totalSize += pools[i];
        }else{
            totalSize += avaliLdNum * maxLdSize;
            break;
        }
    }
    return Math.min(getTotalSize(), maxLdNum * maxLdSize, totalSize, MAXVOLSIZE);
}

//get the max Size that can be created when user specified volume number
function getSizeByNum(volNum){
    var max = Math.min(getAverage(volNum), getMaxSize());
    while(true){
        if(getNumBySize(max) < volNum){
            max--;
        }else{
            break;
        }
    }
    return max;
}

//get the max volume number that can be created when user specified volume size
function getNumBySize(size){
    var pools = poolSizeArray.slice(0);
    var volNum = 0;
    var availOsLdNum = maxLdNum;
    var remainNeed = 0;
    for(var i=0; i<pools.length; i++){
        if(availOsLdNum <=0){
            break;
        }
        if(remainNeed > 0){
            if(pools[i] >=remainNeed){
                pools[i] -= remainNeed;
                availOsLdNum = availOsLdNum - Math.ceil(remainNeed / maxLdSize);
                if(availOsLdNum < 0){
                    break;
                }
                remainNeed = 0;
                volNum++;
            }else{
                remainNeed -= pools[i];
                availOsLdNum = availOsLdNum - Math.ceil(pools[i] / maxLdSize);;
                continue;
            }
        }
        var oneVolLdNum = Math.ceil(size / maxLdSize);
        if(availOsLdNum >= oneVolLdNum){
            var poolVolNum = Math.floor(pools[i] / size);
            var poolLdNum =  poolVolNum *  oneVolLdNum;
            if(availOsLdNum >= poolLdNum){
                volNum += poolVolNum;
                availOsLdNum -= poolLdNum;
                var remain = pools[i] - poolVolNum * size;
                availOsLdNum =  availOsLdNum - Math.ceil(remain / maxLdSize);
                remainNeed = size - remain;
            }else{
                volNum += Math.floor(availOsLdNum / oneVolLdNum);
                break;
            }
        }else{
            break;
        }
    }
    return Math.min(volNum, getMaxNum());
}

function changeRepl(){
    var capciObj = document.forms[0].capacity;
    var volumeSize = parseInt(capciObj.value);
    if (capciObj.value==""
        || checkCapacity(capciObj.value, 1) != true){
        volumeSize = 0;
    }
    if(document.forms[0].unit.value == "tb") {
        volumeSize = volumeSize*1024;
    }
    if (volumeSize > VOLSIZE20TB){
        document.forms[0].replication.checked = false;
        document.forms[0].replication.disabled = true;
    }else{
        <logic:equal name="volume_hasReplicLicense" value="true" scope="session">
            document.forms[0].replication.disabled = false;
        </logic:equal>
    }
}

function chgAssign() {
   // set initial value of the Voume Number and Volume Size
    if(document.forms[0].assign[0].checked 
      ||document.forms[0].assign[1].checked){
        
        // get max Volume Size in the selected pools
        var maxVolSize = getMaxSize();
        
        if (parseInt(maxVolSize) == MAXVOLSIZE) {
            document.forms[0].capacity.value     = 130;
            document.forms[0].unit.selectedIndex = 1;
            document.forms[0].volNum.value       = getNumBySize(maxVolSize);
        } else {
            document.forms[0].capacity.value     = maxVolSize;
            document.forms[0].unit.selectedIndex = 0;
            document.forms[0].volNum.value       = 1;
        }
    }
    
    if(document.forms[0].assign[0].checked) {
        document.forms[0].volNum.disabled=false;
        document.forms[0].capacity.disabled=true;
        document.forms[0].unit.disabled=true;
    } else if(document.forms[0].assign[1].checked) {
        document.forms[0].volNum.disabled=true;
        document.forms[0].capacity.disabled=false;
        document.forms[0].unit.disabled=false;
    } else {
        document.forms[0].volNum.disabled=false;
        document.forms[0].capacity.disabled=false;
        document.forms[0].unit.disabled=false;    
    }
    changeRepl();
}

function chgNumber(num) {
    num = trim(num);
    document.forms[0].volNum.value = num;
    
    // check if the Volume Number is interger
    if(checkNumber(num) != true || parseInt(num) < 1) {
        alert('<bean:message key="msg.volume.number"/>');
        return false;
    }
    

    // get max Volume Number in the selected pools
    var maxVolNum = getMaxNum();
    
    // check if the Volume Number is valid
    if(parseInt(num) > maxVolNum) {
        alert('<bean:message key="warning.select.maxnum" arg0="\'+ maxVolNum +\'" /> ');
        return false;
    }
        
    if(document.forms[0].assign[0].checked) {
        var volSize = getSizeByNum(num);
        if(parseInt(volSize) == MAXVOLSIZE){
            document.forms[0].capacity.value     = 130;
            document.forms[0].unit.selectedIndex = 1;
        }else{
            document.forms[0].capacity.value     = volSize;
            document.forms[0].unit.selectedIndex = 0;
        }
    }
    changeRepl();
    return true;    
}

function chgSize(size) {
    size = trim(size);
    document.forms[0].capacity.value = size;
    
    if(size==""
       || checkCapacity(size, 1) != true) {
        alert('<bean:message key="msg.add.lessthan00"/>');
        return false;
    }


    var thisSize = parseInt(size);
    if(document.forms[0].unit.value=="tb") {
        thisSize = parseInt(size)*1024;
    }

    if(thisSize < 1) {
        alert('<bean:message key="msg.add.lessthan00"/>');
        return false;
    }

    if(thisSize > MAXVOLSIZE) {
        alert("<bean:message key="msg.exceedMaxSize"/>");
        return false;    
    }
                
    // get max Volume Size in the selected pools
    var maxVolSize = getMaxSize();
    if(thisSize > parseInt(maxVolSize)) {
        alert('<bean:message key="warning.select.maxsize" arg0="\'+ parseInt(maxVolSize) + 'GB' +\'" /> ');
        return false;
    }
    
    if(document.forms[0].assign[1].checked) {
        document.forms[0].volNum.value = getNumBySize(thisSize);
    }
    changeRepl();
    return true;
}

function onConfirm(){
    // 1. check Volume Number and Volume Size
    document.forms[0].volNumValue.value = document.forms[0].volNum.value;
    document.forms[0].capacityValue.value = document.forms[0].capacity.value;
    document.forms[0].unitValue.value = document.forms[0].unit.options[document.forms[0].unit.selectedIndex].value;

    if (chgNumber(document.forms[0].volNumValue.value) == false) {
        document.forms[0].volNum.focus();
        return false;
    }
    if (chgSize(document.forms[0].capacityValue.value) == false) {
        document.forms[0].capacity.focus();
        return false;
    }

    var volumeSize = parseInt(document.forms[0].capacityValue.value);
    if(document.forms[0].unitValue.value == "tb") {
        volumeSize = volumeSize*1024;
    }
            
    var sumCapacity = parseInt(document.forms[0].volNumValue.value) * volumeSize;
    var availNum  = getNumBySize(volumeSize);
    if(document.forms[0].assign[2].checked) {
        if (sumCapacity > parseInt(document.forms[0].totalCapacity.value)) {
            alert('<bean:message key="msg.volume.totalCapacity.over" arg0="\'+ document.forms[0].totalCapacity.value + 'GB' +\'"/>'
                  + "\r\n" + '<bean:message key="msg.volNum.tooLarger" arg0="\'+ availNum +\'" />');
            document.forms[0].volNum.focus();
            return false;
        }
        
        if (parseInt(document.forms[0].volNumValue.value) > availNum) {
            alert('<bean:message key="msg.volNum.tooLarger" arg0="\'+ availNum +\'" /> ');
            document.forms[0].volNum.focus();
            return false;  
        }
    }
    
    // 2. check Basic Volume Name
    var volumObj = document.forms[0].volBase;
    var mountPointObj =  document.forms[0].mpBase;
    mountPointObj.value = compactPath(mountPointObj.value);
     
    if (!checkVolumeName(volumObj.value)) {
        alert('<bean:message key="msg.add.invalidVolume"/>');
        volumObj.focus();
        return false;
    }
    
    // 3. check Basic Mount Point
    var tmpReg = /\/+/g;
    if (checkMountPointName(mountPointObj.value) != true
        || mountPointObj.value == ""
        || mountPointObj.value.replace(tmpReg,"/") == "/"){
        alert('<bean:message key="msg.add.invalidMountpoint"/>');
        mountPointObj.focus();
        return false;
    }

    var mpPath = document.forms[0].exportGroup.value + "/" + mountPointObj.value;
    if (mpPath.length > 2043){
        alert('<bean:message key="msg.add.maxMPLength"/>');
        mountPointObj.focus();
        return false;
    }
    
    if (chkEveryLevel(mountPointObj.value) != true){
        alert('<bean:message key="msg.add.maxDirLength"/>');
        mpShowObj.focus();
        return false;
    }
    
    return openWin();
}


function init() {
    loaded=1;
    chgAssign();
}

function popupNavigator() {
    if (isSubmitted()){
       return false;
    }
    document.forms[1].rootDirectory.value = document.forms[0].exportGroup.value;
    document.forms[1].nowDirectory.value = document.forms[0].exportGroup.value + "/"
                                        + document.forms[0].mpBase.value;
    document.forms[1].nowDirectory.value = compactPath(document.forms[1].nowDirectory.value);
    
    var mpShowObj = document.forms[0].mpBase;
    if (checkMountPointName(document.forms[1].nowDirectory.value) != true) {
        alert('<bean:message key="msg.add.invalidMountpoint"/>');
        mpShowObj.focus();
        return false;
    }
    
    if(navigatorWin == null || navigatorWin.closed){
        navigatorWin = window.open("/nsadmin/common/commonblank.html","volume_create_navigator", "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
        window.mpPath = document.forms[0].mpBase;
        document.forms[1].submit();
    }else{
        navigatorWin.focus();
    }
  }

function chkEveryLevel(str){
    var tmpArray=new Array();
    var reg=/\//g;
    tmpArray=str.split(reg);
    
    if(tmpArray.length>0 && tmpArray[tmpArray.length - 1].length > 251) {
        return false;
    }
    
    for(var index=0; index<tmpArray.length-1; index++){
        if (tmpArray[index].length>255){
            return false;
        }
    }
    return true;
}

var winConfirmHandler;
function openWin() {
    if(winConfirmHandler!=null && !winConfirmHandler.closed){
        winConfirmHandler.close();
    }
    winConfirmHandler=window.open("/nsadmin/common/commonblank.html","batchcreateconfirm","toolbar=no,menubar=no,scrollbars=yes,width=800,height=600,resizable=yes");
    document.forms[0].submit();
    return false;
}

function checkNumber(str) {
    if ((str == null) 
         || (str == "") 
         || (str.charAt(0) == '0')) {
        return false;
    }
    var reg=/^\d+$/g;
    return (str.search(reg) != -1);
}

</script>
</head>
<bean:define id="capacity" name="totalCapacity" scope="session"/>
<bean:define id="baseName" name="baseName" scope="session"/>
<bean:define id="hasReplicLicense" name="volume_hasReplicLicense" scope="session"/>
<bean:define id="lvNo" name="lvNo" scope="session"/>

<body onload="init()" onunload="closePopupWin(winConfirmHandler);closePopupWin(navigatorWin);">
<h1><bean:message key="title.h1"/></h1>
<form action="volumeBatchCreateConfirm.do?operation=specifyConfirm" target="batchcreateconfirm" method="post" onsubmit="return false;">
<input type="button" name="back" 
       value="<bean:message key="common.button.back" bundle="common"/>"
       onclick="parent.location='volumeBatchDispatch.do?operation=display'"/>
<input type="hidden" name="lvNo" value="<%=lvNo%>">
<h2><bean:message key="title.batchcreateshow.h2"/></h2>
<jsp:include page="volumelicensecommon.jsp" flush="true"/>
<br>
<table>
  <tr>
    <td>
        <input type="radio" name="assign" value="num" id="assignID0" checked onclick="chgAssign()">
        <label for="assignID0"><bean:message key="raido.volume.num"/></label>
    </td>
  </tr>
  <tr>
    <td>
        <input type="radio" name="assign" value="size" id="assignID1" onclick="chgAssign()">
        <label for="assignID1"><bean:message key="radio.volume.size"/></label>
    </td>
  </tr>
  <tr>
    <td>
        <input type="radio" name="assign" value="numAndSize" id="assignID2" onclick="chgAssign()">
        <label for="assignID2"><bean:message key="radio.volume.numAndSize"/></label><br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <bean:message key="text.volume.num"/><bean:message key="msg.batch.colon"/>
        <input type="text" name="volNum" size="3" value="1" onchange="chgNumber(this.value)">
        <input type="hidden" name="volNumValue" value="1">
        <bean:message key="text.volume.size"/><bean:message key="msg.batch.colon"/>
        <input type="text" name="capacity" value="<%=capacity%>" style="text-align:right" size="10" disabled onchange="chgSize(this.value)">
        <input type="hidden" name="totalCapacity" value="<%=capacity%>">
        <input type="hidden" name="capacityValue" value="<%=capacity%>">
        <input type="hidden" name="unitValue" value="gb">
        <select name="unit" disabled onchange="chgSize(document.forms[0].capacity.value)">
          <option value="gb" selected ><bean:message key="select.volume.size.unit.gb"/></option>
          <option value="tb"><bean:message key="select.volume.size.unit.tb"/></option>
        </select>
    </td>
  </tr>
</table>
<br>
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="text.volume.baseName"/></th>
    <td><input type="text" name="volBase" value="<%=baseName%>" size="10" maxlength="12"></td>
  </tr>
  <tr>
    <th><bean:message key="info.fsType"/></th>
    <td><input type="radio" name="fsType" value="sxfs" id="fsTypeID0" checked >
        <label for="fsTypeID0"><bean:message key="info.fsType.sxfs"/></label>
        <input type="radio" name="fsType" value="sxfsfw" id="fsTypeID1">
        <label for="fsTypeID1"><bean:message key="info.fsType.sxfsfw"/></label>
    </td>
  </tr>    
  <tr>
    <th><bean:message key="text.volume.baseMP"/></th>
    <td><bean:write name="volume_exportgroup"/>/
        <input type="text" name="mpBase" value="<%=baseName%>" size="10" maxlength="2047">
        <input type="button" value='<bean:message key="common.button.browse2" bundle="common"/>' onClick="popupNavigator()">
        <input type="hidden" name="exportGroup" value='<bean:write name="volume_exportgroup"/>'>
    </td>
  </tr>
  <tr valign="top">
    <th><bean:message key="info.option"/></th>
    <td><input type="checkbox" name="quota" value="on" id="quotaID" checked >
        <label for="quotaID"><bean:message key="info.quota"/></label><br>
        <input type="checkbox" name="atime" value="on" id="atimeID" checked >
        <label for="atimeID"><bean:message key="info.noatime"/></label><br>
        <input type="checkbox" name="replication" value="on" <%=((String)hasReplicLicense).equals("true")?"":"disabled"%> id="repliID">
        <label for="repliID"><bean:message key="info.batchcreateshow.replication"/></label>
    </td>
  </tr>    
</table>
</form>
  
<html:form target="volume_create_navigator" action="VCNavigatorList.do">
    <html:hidden property="method" value="call"/>
    <html:hidden property="rootDirectory" value=""/>
    <html:hidden property="nowDirectory" value=""/>
</html:form>
</body>
</html:html>

