<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumeaddshow.jsp,v 1.39 2008/05/30 07:32:37 liuyq Exp $" --> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page buffer="32kb" %> 
<html:html lang="true">
<head> 
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">

function backToList(){
    if (!isSubmitted()){
        window.location = "/nsadmin/volume/volumeList.do";
        setSubmitted();
        lockMenu();
    }
}

var navigatorWin;
var heartBeatWin;
var poolWin;
var volume_winhandler;
var selectedLdPath;
var wwnn;
var usedStorage;
var writeProtectLicense = '<bean:write name="<%= VolumeActionConst.SESSION_WP_LICENSE %>" scope="session"/>';

function popupNavigator() {
    if (isSubmitted()){
       return false;
    }
    document.forms[1].rootDirectory.value = document.forms[0].exportGroup.value;
    document.forms[1].nowDirectory.value = document.forms[0].exportGroup.value + "/"
                                        + document.forms[0].mountPointShow.value;
    document.forms[1].nowDirectory.value = compactPath(document.forms[1].nowDirectory.value);
    
    var mpShowObj = document.forms[0].elements["mountPointShow"];
    if (checkMountPointName(document.forms[1].nowDirectory.value) != true){
        alert('<bean:message key="msg.add.invalidMountpoint"/>');
        mpShowObj.focus();
        return false;
    }
    
    if(navigatorWin == null || navigatorWin.closed){
        navigatorWin = window.open("/nsadmin/common/commonblank.html","volume_create_navigator", "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
        window.mpPath = document.forms[0].mountPointShow;
        document.forms[1].submit();
    }else{
        navigatorWin.focus();
    }
  }


<logic:equal name="isNashead" value="true">
function selectLun(){
    if (isSubmitted()){
       return false;
    }
	if(volume_winhandler==null || volume_winhandler.closed){
		volume_winhandler=window.open("/nsadmin/framework/moduleForward.do?h1=apply.volumn.volumn&msgKey=apply.volume.volume.forward.to.lun.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/lunSelectShow.do?src=volume","nasheadPop","toolbar=no,menubar=no,scrollbars=yes,width=500,height=520,resizable=yes");
	}else{
		volume_winhandler.focus();
	}	
}
</logic:equal>

<logic:notEqual name="isNashead" value="true">
function openSelectPool(){
    if (isSubmitted()){
        return false;
    }

    poolWin = window.open("/nsadmin/common/commonblank.html", "volume_selectPool", "width=700,height=650,resizable=yes,scrollbars=yes,status=yes");
 
    window.aid = document.forms[2].aid;
    window.raidType   = document.forms[2].raidType;
    window.poolName = document.forms[0].elements["volumeInfo.poolName"];
    window.poolNo   = document.forms[0].elements["volumeInfo.poolNo"];
    window.raidTypeDiv   = document.getElementById("raidTypeDiv");
    window.usableCapDiv = document.getElementById("usableCapDiv");

    document.forms[2].submit();
    poolWin.focus();
}
</logic:notEqual>


function onAdd(){
    if (isSubmitted()){
       return false;
    }

    var volumObj = document.forms[0].elements["volumeInfo.volumeName"];
    if (checkVolumeName(volumObj.value) != true){
        alert('<bean:message key="msg.add.invalidVolume"/>');
        volumObj.focus();
        return false;
    }
    
    <logic:equal name="isNashead" value="true">
	    var selectedLun = document.getElementById("selectedLun").innerHTML;
	    var selectedLunSize = document.getElementById("selectedLunSize").innerHTML;
	    selectedLunSize = combinateStr(selectedLunSize);
	    if ( selectedLdPath.value == ""){
	        alert('<bean:message key="msg.add.noLUN"/>');
	        return false;
	    }
	    
	    var maxSize = <%=VolumeActionConst.VOLUME_MAX_SIZE%>; //130*1024GB
	    var alertMsg = "<bean:message key="msg.exceedMaxSize"/>";
	    if (parseFloat(selectedLunSize) > maxSize){
            alert(alertMsg);
            return false;
        }

        var radio_striping = document.getElementById("striping");
        var lunArray = selectedLdPath.value.split(",");
        var radio_striping_checked = radio_striping && !radio_striping.disabled && radio_striping.checked;
        if(radio_striping_checked){
	        if (window.differentSize.value == "1"){
	            alert("<bean:message key="msg.alert.create.striping.different.size"/>");
	            return false;
	        }
        }

        document.forms[0].elements["volumeInfo.capacity"].value = selectedLunSize;
        document.forms[0].elements["volumeInfo.storage"].value = selectedLun;
    </logic:equal>
    
    <logic:notEqual name="isNashead" value="true">
        if (document.forms[0].elements["volumeInfo.poolName"].value == ""){
            alert('<bean:message key="msg.add.noSelectedPool"/>');
            return false;
        }
        
        var poolName = document.forms[0].elements["volumeInfo.poolName"].value;
        var selectedPoolNum = (poolName.split(",")).length;
        
	    var capciObj = document.forms[0].elements["volumeInfo.capacity"];
	    if (selectedPoolNum == 1) {
		    if (capciObj.value==""
		       || checkCapacity(capciObj.value) != true){
                alert('<bean:message key="msg.add.lessthan01"/>');
		        capciObj.focus();
		        return false; 
		    }
	    } else {
		    if (capciObj.value==""
	           || checkCapacity(capciObj.value, 1) != true){
	            alert('<bean:message key="msg.add.morethan1"/>');
	            capciObj.focus();
	            return false; 
	        }
        }
        
        var availCap = document.getElementById("usableCapDiv").innerHTML;
        
        var availCapUnit = availCap.substring(availCap.length-2, availCap.length);
        var availCapValue = combinateStr(availCap.substring(0, availCap.length-2));
        if (availCapUnit == "TB") {
            availCapValue = (new Number(parseFloat(availCapValue) * 1024)).toFixed(1);     
        }
        
        var volumeSize = capciObj.value;
        if (document.forms[0].elements["volumeInfo.capacityUnit"].value == "TB") {
            volumeSize = (new Number(parseFloat(capciObj.value) * 1024)).toFixed(1); 
        }
        if (parseFloat(volumeSize) < 1){
            if (selectedPoolNum == 1) {
                alert('<bean:message key="msg.add.lessthan01"/>');
            } else {
                alert('<bean:message key="msg.add.morethan1"/>');
            }
            capciObj.focus();
            return false; 
        }
	    if (parseFloat(volumeSize) > parseFloat(availCapValue)){
            alert("<bean:message key="msg.add.exceedMaxCapacity"/>");
            capciObj.focus();
            return false;
        }
        
        if (parseFloat(volumeSize) > <%=VolumeActionConst.VOLUME_MAX_SIZE%>){
            alert("<bean:message key="msg.exceedMaxSize"/>");
            capciObj.focus();
            return false;
        }
        <logic:equal name="<%=VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES%>" value="true" scope="session">
	        var bltime = document.forms[0].elements["volumeInfo.bltime"].value;
	
	        if(!isBlTimeValid(bltime, 0, 255)){
	        	alert("<bean:message key="info.bltime.invalid.alert"/>");
	        	document.forms[0].elements["volumeInfo.bltime"].focus();
	        	return false;
	        }
        </logic:equal>
        document.forms[0].elements["volumeInfo.aid"].value = document.forms[2].aid.value;
        document.forms[0].elements["volumeInfo.raidType"].value = document.getElementById("raidTypeDiv").innerHTML;
        document.forms[0].usableCap.value = document.getElementById("usableCapDiv").innerHTML;
    </logic:notEqual>
    
    var mountPointObj = document.forms[0].elements["volumeInfo.mountPoint"];
    var mpShowObj = document.forms[0].elements["mountPointShow"];
    mountPointObj.value = document.forms[0].exportGroup.value +"/"+ mpShowObj.value;
    var tmpReg = /\/+/g;
    if (checkMountPointName(mountPointObj.value) != true
        || mpShowObj.value == ""
        || mpShowObj.value.replace(tmpReg,"/") == "/"){
        alert('<bean:message key="msg.add.invalidMountpoint"/>');
        mpShowObj.focus();
        return false;
    }
    mountPointObj.value =  compactPath(mountPointObj.value);
    if (mountPointObj.value.length > 2047){
        alert('<bean:message key="msg.add.maxMPLength"/>');
        mpShowObj.focus();
        return false;
    }
    if (chkEveryLevel(mountPointObj.value) != true){
        alert('<bean:message key="msg.add.maxDirLength"/>');
        mpShowObj.focus();
        return false;
    }
    
    if(!document.forms[0].elements["wprotect"].disabled && document.forms[0].elements["wprotect"].checked) {
        if(!checkWpPeriod(document.forms[0].elements["wpdays"])) {
            alert('<bean:message key="info.alert.invalid.wp.days"/>');
            document.forms[0].elements["wpdays"].focus();
            return false;
        } else {
            document.forms[0].elements["volumeInfo.wpPeriod"].value = document.forms[0].elements["wpdays"].value;
        }
    } else {
        document.forms[0].elements["volumeInfo.wpPeriod"].value = "--";
    }
    
    // add for volume license by jiangfx, 2007.7.5
    var licenseAlert = "";
    <logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
        // get specified capacity, license capacity and total created volume capacity
        var specifiedCap;
        <logic:equal name="isNashead" value="true">
        	specifiedCap = selectedLunSize;
        </logic:equal>
        <logic:notEqual name="isNashead" value="true">
        	specifiedCap = volumeSize;
        </logic:notEqual>
        var licenseCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session"/>';
        var totalFSCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session"/>';
        
        // get cofirm message for exceed license capacity
    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
    	    && (parseFloat(specifiedCap) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
    		licenseAlert = "<bean:message key="volumeLicense.exceed.volCreate"/>" + "\r\n\r\n";
    	}
    </logic:equal>
    var confirmAlert = licenseAlert + "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.create" bundle="common"/>" + "\r\n";
    if(document.forms[0].elements["volumeInfo.wpPeriod"].value >= 1) {
        confirmAlert = "<bean:message key="info.confirm.set.writeprotected"/>" + "\r\n";
    }
    
    if (!confirm(confirmAlert + "<bean:message key="msg.longTimeWait"/>")){
        return false;
    }
    
    setSubmitted();
    document.forms[0].action="/nsadmin/volume/volumeAdd.do";
    heartBeatWin = openHeartBeatWin();
    lockMenu();
    return true;
}

function checkStatus(){
    var radio_sxfs = document.getElementById("sxfs");
    var radio_sxfsfw = document.getElementById("sxfsfw");
    if (radio_sxfs && !radio_sxfs.checked
        && radio_sxfsfw && !radio_sxfsfw.checked){
        radio_sxfs.checked = true;
    }
    
    var chkBox_rplic = document.forms[0].elements["volumeInfo.replication"];
    var radio_original = document.getElementById("original");
    var radio_replic = document.getElementById("replic");
    var slect_snapshot = document.forms[0].elements["volumeInfo.snapshot"];
    var repli_snapshot = false; /**not disable snapshot first time**/
    var dmapi_snapshot =false; /**not disable snapshot first time**/
    var capacity_snapshot =false; /**not disable snapshot first time**/
    var volumeSize;
    <logic:equal name="isNashead" value="true">
	    var selectedLunSize = document.getElementById("selectedLunSize").innerHTML;
	    volumeSize = combinateStr(selectedLunSize);
        if ( selectedLdPath.value == ""){
            volumeSize = 0;
        }
    </logic:equal>
    <logic:notEqual name="isNashead" value="true">
        var poolName = document.forms[0].elements["volumeInfo.poolName"].value;
        var selectedPoolNum = (poolName.split(",")).length;
        var capciObj = document.forms[0].elements["volumeInfo.capacity"];
        volumeSize = capciObj.value;
        if (selectedPoolNum == 1) {
	        if (capciObj.value==""
	           || checkCapacity(capciObj.value) != true){
               volumeSize = 0;
	        }
        } else {
	        if (capciObj.value==""
	            || checkCapacity(capciObj.value, 1) != true){
                volumeSize = 0;     
            }
        }
        if (document.forms[0].elements["volumeInfo.capacityUnit"].value == "TB") {
            volumeSize = (new Number(parseFloat(volumeSize) * 1024)).toFixed(1);
        }
    </logic:notEqual>

    if (parseFloat(volumeSize) > <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
        chkBox_rplic.checked = false;
        chkBox_rplic.disabled = true;
        capacity_snapshot = true;
    }else{
        <logic:equal name="hasReplicLicense" value="true" scope="request">
            chkBox_rplic.disabled = false;
        </logic:equal>
        capacity_snapshot = false;
    }

    if (chkBox_rplic && chkBox_rplic.checked){
        radio_original.disabled = false;
        radio_replic.disabled = false;
        if (!radio_replic.checked && !radio_original.checked){
	        radio_original.checked = true;
        }
        repli_snapshot = radio_replic.checked ? true : false;
    }else{
        radio_original.disabled = true;
        radio_replic.disabled = true;
        repli_snapshot = false;
    }
    
    /**enable about dmapi**/
/*  var checkbox_dmapi = document.forms[0].elements["volumeInfo.dmapi"];
    if(checkbox_dmapi && slect_snapshot){
        dmapi_snapshot = checkbox_dmapi.checked ? true : false;
    }
*/
    if(repli_snapshot || dmapi_snapshot || capacity_snapshot){
        slect_snapshot.disabled = true;
    }else{
        slect_snapshot.disabled = false;
    }
<logic:equal name="isNashead" value="true">  
    var checkbox_useGfs = document.forms[0].elements["volumeInfo.useGfs"];
    var fsType_radio = document.forms[0].elements["volumeInfo.fsType"];
    var radio_striping = document.getElementById("striping");
    var radio_notStriping = document.getElementById("notStriping");
    var lunArray = selectedLdPath.value.split(",");
    if(checkbox_useGfs){
	    if(!checkbox_useGfs.disabled && checkbox_useGfs.checked && (lunArray.length >=2)){
	        radio_striping.disabled = false;
	        radio_notStriping.disabled = false;
	    }else{
	        radio_striping.disabled = true;
	        radio_notStriping.disabled = true;
	    }
        
        // when click fstype radio
        if(fsType_radio[0].checked && (chkBox_rplic.disabled || !chkBox_rplic.checked)) {
            checkbox_useGfs.disabled=false;
        }
        if(fsType_radio[1].checked) {
            checkbox_useGfs.disabled=true;
            document.getElementById("striping").disabled=true;
            document.getElementById("notStriping").disabled=true;
        }
        
        // when click gfs checkbox
        if(!checkbox_useGfs.disabled && checkbox_useGfs.checked) {
            fsType_radio[0].checked=true;
            fsType_radio[0].disabled=true;
            fsType_radio[1].disabled=true;
            chkBox_rplic.disabled=true;
        }else{
            fsType_radio[0].disabled=false;
            fsType_radio[1].disabled=false;
            if(parseFloat(volumeSize) <= <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
                <logic:equal name="hasReplicLicense" value="true" scope="request">
                    chkBox_rplic.disabled = false;
                </logic:equal>
            }
        }
        
        // when click mvdsync checkbox
        if(!chkBox_rplic.disabled && chkBox_rplic.checked) {
            checkbox_useGfs.disabled=true;
        } else if(fsType_radio[0].checked){
            checkbox_useGfs.disabled=false;
        }
    }
</logic:equal>    
    if(writeProtectLicense == "true") {
        if(document.forms[0] && radio_sxfs.checked &&
            !document.forms[0].elements["volumeInfo.replication"].checked) {
            document.forms[0].elements["wprotect"].disabled = 0;
        } else {
            document.forms[0].elements["wprotect"].disabled = 1;
        }
        if(!document.forms[0].elements["wprotect"].disabled &&
            document.forms[0].elements["wprotect"].checked) {
            document.forms[0].elements["wpdays"].disabled = 0;
        } else {
            document.forms[0].elements["wprotect"].checked = 0;
        	document.forms[0].elements["wpdays"].disabled = 1;
        }
    } else {
        document.forms[0].elements["wprotect"].disabled = 1;
    }
}

function init() {
    var writeProtectPeriod = '<bean:write name="volumeAddForm" property="volumeInfo.wpPeriod" />';
<logic:notEqual name="isNashead" value="true">
    /* raidType is  1|5|10|50|64|68, but raidTypeDiv is 1|5|10|50|6(4+PQ)|6(8+PQ)*/
    var raidTypeVal = document.forms[0].elements["volumeInfo.raidType"].value;
	
	if (raidTypeVal != null && raidTypeVal != "") {
	    document.forms[2].raidType.value = raidTypeVal;
	    document.forms[2].aid.value = document.forms[0].elements["volumeInfo.aid"].value;
	    
	    if (raidTypeVal == "64") {
	       document.getElementById("raidTypeDiv").innerHTML = "6(4+PQ)";
        } else if (raidTypeVal == "68") {
           document.getElementById("raidTypeDiv").innerHTML = "6(8+PQ)";
        } else {
           document.getElementById("raidTypeDiv").innerHTML = raidTypeVal; 
        }
        
    }
    
    var usableCapVal = document.forms[0].usableCap.value;
    if (usableCapVal != null && usableCapVal != "") {
        document.getElementById("usableCapDiv").innerHTML = usableCapVal;
    }
</logic:notEqual>
<logic:equal name="isNashead" value="true">
    var capacity = document.forms[0].elements["volumeInfo.capacity"].value;
    if(capacity == ""){
        document.getElementById("selectedLunSize").innerHTML = "--";
    }else{
        document.getElementById("selectedLunSize").innerHTML = splitString(capacity);
    }
    
    window.selectedLdPath = document.forms[0].elements["selectedLdPath"];
    window.wwnn = document.forms[0].elements["volumeInfo.wwnn"];
    window.gfsLicense = "<bean:write name="hasGfsLicense" scope="request"/>";
    window.gfsCheckBox = document.forms[0].elements["volumeInfo.useGfs"];
    window.stripingRdo = document.getElementById("striping");
    window.notStripingRdo = document.getElementById("notStriping");
    window.differentSize = document.forms[0].elements["differentSize"];
</logic:equal>
    if(writeProtectPeriod == "--") {
    }else{
        document.forms[0].elements["wprotect"].checked = 1;
        document.forms[0].elements["wpdays"].value = writeProtectPeriod;
    }
}

</script>
</head>
<body onLoad="init();checkStatus();displayAlert();" 
 onUnload="unLockMenu();closePopupWin(navigatorWin);closePopupWin(heartBeatWin);closePopupWin(poolWin);closePopupWin(volume_winhandler);closeDetailErrorWin();">
<h1 class="title"><bean:message key="title.h1"/></h1>
<html:button property="backBtn" onclick="backToList();">
   <bean:message key="common.button.back" bundle="common"/>
</html:button>
<h2 class="title"><bean:message key="title.add.h2"/></h2>

<html:form action="volumeAddShow.do" onsubmit="return onAdd();">
<displayerror:error h1_key="title.h1"/>
<br>
<jsp:include page="volumelicensecommon.jsp" flush="true"/>
<%boolean isNashead = ((String)request.getAttribute("isNashead")).equals("true")?true:false;%>
<h3 class="title"><bean:message key="title.add.h3_base"/></h3>
    <input type="hidden" name="exportGroup" value="<bean:write name="exportGroup"/>">
	<input type="hidden" name="selfURL" value="/nsadmin/volume/volumeAddShow.do">

    <html:hidden property="differentSize"/>
    <html:hidden property="usableCap"/>
    <nested:nest property="volumeInfo">
    <nested:hidden property="aid"/>
    <nested:hidden property="raidType"/>
    <nested:hidden property="poolNo"/>
    <nested:hidden property="wpPeriod" />
    
	<nested:hidden property="machineType" value='<%=isNashead?"NASHEAD":"NV"%>'/>
	<table border="1" nowrap class="Vertical">
      <tr>
        <th><bean:message key="info.volumeName"/></th>
        <td colspan=2>
        	<nested:text property="volumeName" styleId="volumeName" 
        	             size="16" maxlength="16" />
        </td>
      </tr>
      
      <logic:equal name="isNashead" value="true">
          <tr>
            <th align="left" valign="top"><bean:message key="info.selected.lun"/></th>
            <td width="330px">
                <nested:define id="storage" property="storage" type="java.lang.String"/>
                <%String divHeight = (storage.split("<BR>").length >=3) ? "54px" : "auto";%>
                <DIV id="selectedLun" style="overflow: auto; width: auto; height: <%=divHeight%>;">
                    <nested:write property="storage" filter="false"/>   
                </DIV>
	            <nested:hidden property="storage"/>
	            <nested:hidden property="wwnn"/>
	            <html:hidden property="selectedLdPath"/>
            </td>
	        <td style="align:right; valign:top"> 
	            <html:button property="selectLunBtn" onclick="selectLun();">
	                <bean:message key="button.selectLun"/><bean:message key="button.dot"/>
	            </html:button>
	        </td>
          </tr>
          <tr>
            <th><bean:message key="info.selected.lun.size"/></th>
            <td colspan=2>
                <DIV id="selectedLunSize">--</DIV>
                <nested:hidden property="capacity"/>
            </td>
          </tr>
      </logic:equal>
      
      <logic:notEqual name="isNashead" value="true">
          
          <tr>
            <th><bean:message key="info.selectedPool"/></th>
            <td>
                <nested:text property="poolName" size="20" readonly="true"/>
            </td>
            <td align="right"> 
                <html:button property="poolSelectBtn" onclick="openSelectPool();">
                    <bean:message key="button.poolSelect"/><bean:message key="button.dot"/>
                </html:button>
            </td>
          </tr>
          
          <tr>
            <th><bean:message key="info.raidType"/></th>
            <td colspan=2>
                <DIV id="raidTypeDiv"><bean:message key="info.off"/></DIV>
            </td>
          </tr>
          
          <tr>
            <th><bean:message key="info.availCapacity"/></th>
            <td colspan="2">
                <DIV id="usableCapDiv"><bean:message key="info.off"/></DIV>
            </td>
          </tr>                      

	      <tr>
	        <th><bean:message key="info.volumeSize"/></th>
	        <td colspan="2">
	           <nested:text property="capacity" size="10" maxlength="10" styleId="capacity" 
                            style="text-align:right" onchange="checkStatus()"/>
	           <nested:define id="capacityUnit" property="capacityUnit" type="java.lang.String"/>
	           <nested:select property="capacityUnit" onchange="checkStatus()">
                   <html:option value="GB">GB</html:option>
                   <html:option value="TB">TB</html:option>
	           </nested:select>
	        </td>
	      </tr>
          <logic:equal name="<%=VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES%>" value="true" scope="session">	      
		      <tr>
	    		<th><bean:message key="info.bltime.th"/><bean:message key="info.bltime.scale"/></th>
			    <td colspan="2"><nested:text property="bltime" size="10" maxlength="3" style="text-align:right" />
	        		&nbsp;<bean:message key="info.bltime.td"/>&nbsp;&nbsp;<font class="advice"><bean:message key="info.bltime.tip"/></font></td>
			  </tr>
          </logic:equal>
      </logic:notEqual>
      <tr>
        <th><bean:message key="info.fsType"/></th>
        <td colspan=2>
            <nested:radio property="fsType" value="sxfs" styleId="sxfs" onclick="checkStatus()"/>
            <label for="sxfs"><bean:message key="info.fsType.sxfs"/></label>
            <nested:radio property="fsType" value="sxfsfw" styleId="sxfsfw" onclick="checkStatus()"/>
            <label for="sxfsfw"><bean:message key="info.fsType.sxfsfw"/></label></td>
      </tr>
      <tr>
        <th><bean:message key="info.journal"/></th>
        <td colspan=2>
            <nested:radio property="journal" value="standard" styleId="standard"/>
            <label for="standard"><bean:message key="info.journal.standard"/></label>
            <nested:radio property="journal" value="expand" styleId="expand"/>
            <label for="expand"><bean:message key="info.journal.expand"/></label></td>
      </tr>
      <tr>
        <th><bean:message key="info.mountpoint"/></th>
        <td colspan=2> 
            <bean:write name="exportGroup"/><bean:message key="info.root"/>
            <nested:hidden property="mountPoint"/>
            <html:text property="mountPointShow" size="20" maxlength="2047" />
            <html:button property="select" onclick="popupNavigator();">
               <bean:message key="common.button.browse2" bundle="common"/>
            </html:button>
        </td>
      </tr>
      <logic:equal name="isNashead" value="true">
        <logic:equal name="hasGfsLicense" value="true" scope="request">
	      <tr>
	        <th valign="top"><bean:message key="info.gfs"/></th>
	        <td colspan=2>

	           <nested:checkbox property="useGfs" styleId="useGfs" value="true" onclick="checkStatus();" />
	           <label for="useGfs"><bean:message key="info.useGfs"/></label>
	           <BR>
	           <nested:radio property="striping" styleId="striping" value="true"/>
               <label for="striping"><bean:message key="info.striping"/></label>
               &nbsp;&nbsp;
               <nested:radio property="striping" styleId="notStriping" value="false"/>
               <label for="notStriping"><bean:message key="info.not.striping"/></label>
	         </td>
	       </tr>
        </logic:equal>
      </logic:equal>
    </table>

    <h3 class="title"><bean:message key="title.add.h3_mountpoint"/></h3>
    <table border="1" class="Vertical" nowrap>      
      <tr>
        <th valign="top" rowspan="3"><bean:message key="info.option"/></th>
        <td>
            <nested:checkbox property="quota" styleId="quota"/>
            <label for="quota"><bean:message key="info.quota"/></label>
        </td>
      </tr>
      <tr>
        <td >
             <nested:checkbox property="noatime" styleId="noatime"/>
             <label for="noatime"><bean:message key="info.noatime"/>
        </td>
      </tr>
<!--      <tr>
        <td ><nested:checkbox property="dmapi" styleId="dmapi" onclick="checkStatus();"/><label for="dmapi"><bean:message key="info.dmapi"/></td>
      </tr>
-->      
      <tr>
      	<bean:define id="hasReplic" name="hasReplicLicense" type="java.lang.String"/>
        <td ><nested:checkbox property="replication" styleId="replication" 
                     onclick="checkStatus();" disabled='<%=hasReplic.equals("false")%>'/>
        <label for="replication"><bean:message key="info.replication"/></td>
      </tr>
      <tr>
        <th><bean:message key="info.replication"/></th>
        <td><nested:radio property="replicType" value="original" styleId="original" onclick="checkStatus();"/>
            <label for="original"><bean:message key="info.replication.original"/></label>
            <nested:radio property="replicType" value="replic" styleId="replic" onclick="checkStatus();"/>
            <label for="replic"><bean:message key="info.replication.replic"/></label>
        </td>
      </tr> 
      <tr> 
        <th><bean:message key="info.snapshotArea"/></th>
        <td>
          <nested:define id="snapshot" type="java.lang.String" property="snapshot"/>
          <nested:select property="snapshot">
            <option value="100" <%=snapshot.equals("100")?"selected":""%>>100%
                                (<bean:message key="info.nolimit"/>)</option>
            <option value="90" <%=snapshot.equals("90")?"selected":""%>>90%</option>
            <option value="80" <%=snapshot.equals("80")?"selected":""%>>80%</option>
            <option value="70" <%=snapshot.equals("70")?"selected":""%>>70%</option>
            <option value="60" <%=snapshot.equals("60")?"selected":""%>>60%</option>
            <option value="50" <%=snapshot.equals("50")?"selected":""%>>50%</option>
            <option value="40" <%=snapshot.equals("40")?"selected":""%>>40%</option>
            <option value="30" <%=snapshot.equals("30")?"selected":""%>>30%</option>
            <option value="20" <%=snapshot.equals("20")?"selected":""%>>20%</option>
            <option value="10" <%=snapshot.equals("10")?"selected":""%>>10%</option>
          </nested:select>
        </td>
      </tr>
      <tr>
          <th><bean:message key="info.writeprotected"/></th>
          <td>
              <input type="checkbox" name="wprotect" id="wprotect" onclick="checkStatus();" />
              <label for="wprotect"><bean:message key="info.writeprotected.set"/></label>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <input type="text" name="wpdays" size="5" maxlength="5" value="1825"  style="text-align:right" disabled />
              <bean:message key="info.writeprotected.set.days"/>
          </td>
      </tr>
    </table>
    </nested:nest>
    <br>
    <html:submit property="submitBtn"><bean:message key="common.button.submit" bundle="common"/></html:submit>
  </html:form>
  <html:form target="volume_create_navigator" 
        action="VCNavigatorList.do">
    <html:hidden property="method" value="call"/>
    <html:hidden property="rootDirectory" value=""/>
    <html:hidden property="nowDirectory" value=""/>
  </html:form>
  
  <html:form target="volume_selectPool" 
        action="volumePoolSelect.do?from=volumeCreate&flag=notFromDisk">
    <html:hidden property="aid" value=""/>
    <html:hidden property="raidType" value=""/>
  </html:form>
</body>
</html:html>