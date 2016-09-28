<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemaddshow.jsp,v 1.17 2008/02/29 12:14:01 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.filesystem.FilesystemConst"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">

<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">

var navigatorWin;
var heartBeatWin;
var writeProtectLicense = '<bean:write name="<%= FilesystemConst.SESSION_WP_LICENSE %>" scope="session"/>';
var volSize = 0;
function init(){
    var writeProtectPeriod = '<bean:write name="filesystemAddForm" property="fsInfo.wpPeriod" />';
<logic:empty name="<%=FilesystemConst.SESSION_FREE_LV_VEC%>" scope="request">
	document.forms[0].set.disabled = true;
</logic:empty>
    if(writeProtectPeriod == "--") {
    }else{
        document.forms[0].elements["wprotect"].checked = 1;
        document.forms[0].elements["wpdays"].value = writeProtectPeriod;
    }
clickFormat(document.forms[0].elements["fsInfo.format"]);
clickAccessMode();
clickFstype();
clickGfs();
<logic:notEmpty name="<%=FilesystemConst.SESSION_FREE_LV_VEC%>" scope="request">
	chgVolume();
</logic:notEmpty>
}

function chgVolume() {
	var checkbox_mvdsync = document.forms[0].elements["fsInfo.repli"];
	var selBoxVol = document.forms[0].elements["fsInfo.lvPath"];
	var tmp = selBoxVol.options[selBoxVol.selectedIndex].value.split("#");
    var vgPairFlag = tmp[2];
    volSize = tmp[1];
    var checkbox_useGfs = document.forms[0].elements["fsInfo.useGfs"];
    
	<logic:equal name="hasReplicLicense" value="true" scope="request">
		if ((vgPairFlag == "0") 
		     || (checkbox_useGfs && checkbox_useGfs.checked) 
		     || parseFloat(volSize) > <%=VolumeActionConst.VOLUME_SIZE_20TB%>) { 
			checkbox_mvdsync.checked=false;
			checkbox_mvdsync.disabled=true;
		} else {
			checkbox_mvdsync.disabled=false;
		}
    </logic:equal>

    if(parseFloat(volSize) > <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
        document.forms[0].elements["fsInfo.snapshotArea"].disabled = true;
    }else{
        document.forms[0].elements["fsInfo.snapshotArea"].disabled = false;
    }
    clickFormat(document.forms[0].elements["fsInfo.format"]);
    clickAccessMode();
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    lockMenu();
    setSubmitted();
    window.location.href="<html:rewrite page='/filesystemListAndDel.do?operation=display'/>";
}

function clickFormat(obj){
	if (obj.checked){
		document.forms[0].elements["fsInfo.accessMode"][0].checked = true;
		document.forms[0].elements["fsInfo.accessMode"][0].disabled = true;
		document.forms[0].elements["fsInfo.accessMode"][1].disabled = true;	
		if(parseFloat(volSize) <= <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
		    document.forms[0].elements["fsInfo.snapshotArea"].disabled = false;	
		}
	}else{
		document.forms[0].elements["fsInfo.accessMode"][0].disabled = false;
		document.forms[0].elements["fsInfo.accessMode"][1].disabled = false;
	}
	clickMvd();
	changeRecoveryStatus();
	
}

function changeRecoveryStatus(){
	if (!document.forms[0].elements["fsInfo.accessMode"][1].disabled
	    && document.forms[0].elements["fsInfo.accessMode"][1].checked
	    && !document.forms[0].elements["fsInfo.repli"].checked){
		document.forms[0].elements["fsInfo.norecovery"].disabled = false;
	}else{
	    document.forms[0].elements["fsInfo.norecovery"].checked = false;
		document.forms[0].elements["fsInfo.norecovery"].disabled = true;
	}
}

function clickAccessMode(){
	if (document.forms[0].elements["fsInfo.accessMode"][0].disabled){
		return;
	}
	if (document.forms[0].elements["fsInfo.accessMode"][1].checked){
        document.forms[0].elements["fsInfo.snapshotArea"].disabled = true;
		document.forms[0].elements["fsInfo.replicationType"][1].checked=true;
	}else{
	    if(parseFloat(volSize) <= <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
		    document.forms[0].elements["fsInfo.snapshotArea"].disabled = false;
		}
		document.forms[0].elements["fsInfo.replicationType"][0].checked=true;
	}	
	changeRecoveryStatus();
}

function clickRepType(){
	if (document.forms[0].elements["fsInfo.replicationType"][0].disabled){
		return;
	}
		
	if (document.forms[0].elements["fsInfo.replicationType"][0].checked){
		document.forms[0].elements["fsInfo.accessMode"][0].checked = true;
		if(parseFloat(volSize) <= <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
		    document.forms[0].elements["fsInfo.snapshotArea"].disabled = false;
		}
	}else{
		document.forms[0].elements["fsInfo.accessMode"][1].checked = true;
		document.forms[0].elements["fsInfo.snapshotArea"].disabled = true;
	}
}

function clickMvd(){
    var checkbox_useGfs = document.forms[0].elements["fsInfo.useGfs"];
    var radio_fstype = document.forms[0].elements["fsInfo.fsType"];
	if (!document.forms[0].elements["fsInfo.repli"].disabled
	    && document.forms[0].elements["fsInfo.repli"].checked){
	    document.forms[0].elements["fsInfo.accessMode"][0].disabled = true;
		document.forms[0].elements["fsInfo.accessMode"][1].disabled = true;
		document.forms[0].elements["fsInfo.replicationType"][0].disabled = false;
		document.forms[0].elements["fsInfo.replicationType"][1].disabled = false;
        if(checkbox_useGfs) {
        	checkbox_useGfs.disabled=true;
        }
	}else{
	    if (!document.forms[0].elements["fsInfo.format"].checked){
	    	document.forms[0].elements["fsInfo.accessMode"][0].disabled = false;
			document.forms[0].elements["fsInfo.accessMode"][1].disabled = false;
	    } else {
	        document.forms[0].elements["fsInfo.accessMode"][0].checked=true;
	        if(parseFloat(volSize) <= <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
	            document.forms[0].elements["fsInfo.snapshotArea"].disabled = false;
	        }
	    }
		document.forms[0].elements["fsInfo.replicationType"][0].disabled = true;
		document.forms[0].elements["fsInfo.replicationType"][1].disabled = true;
        if(checkbox_useGfs) {
        	if(!radio_fstype[0].disabled && radio_fstype[0].checked) {
        		checkbox_useGfs.disabled=false;
        	}
        }
	}
	checkWriteProtect();
	clickRepType();
	changeRecoveryStatus();
}

function clickFstype() {
    checkWriteProtect();
    var checkbox_useGfs = document.forms[0].elements["fsInfo.useGfs"];
	if(checkbox_useGfs){
        var radio_fstype = document.forms[0].elements["fsInfo.fsType"];
        var checkbox_mvdsync = document.forms[0].elements["fsInfo.repli"];
    	if(radio_fstype[1].checked) {
    		checkbox_useGfs.disabled=true;
    	}else if(!checkbox_mvdsync.checked) {
    		checkbox_useGfs.disabled=false;
    	}
    }
}

function clickGfs() {
	var checkbox_useGfs = document.forms[0].elements["fsInfo.useGfs"];
	if(checkbox_useGfs && !checkbox_useGfs.disabled) {
		var radio_fstype = document.forms[0].elements["fsInfo.fsType"];
		var checkbox_mvdsync = document.forms[0].elements["fsInfo.repli"];
		if(checkbox_useGfs.checked){
			radio_fstype[0].disabled=true;
			radio_fstype[1].disabled=true;
			checkbox_mvdsync.disabled=true;
		}else{
			radio_fstype[0].disabled=false;
			radio_fstype[1].disabled=false;
			<logic:equal name="hasReplicLicense" value="true" scope="request">
				var selBoxVol = document.forms[0].elements["fsInfo.lvPath"];
				var tmp = selBoxVol.options[selBoxVol.selectedIndex].value.split("#");
			    if (tmp[2] != "0" && parseFloat(volSize) <= <%=VolumeActionConst.VOLUME_SIZE_20TB%>) {			
					checkbox_mvdsync.disabled=false;
				}
			</logic:equal>
		}
	}
}

function clickWPSet() {
    if(!document.forms[0].elements["wprotect"].disabled &&
        document.forms[0].elements["wprotect"].checked) {
        document.forms[0].elements["wpdays"].disabled = 0;
    } else {
        document.forms[0].elements["wprotect"].checked = 0;
    	document.forms[0].elements["wpdays"].disabled = 1;
    }
}

function checkWriteProtect() {
    var radio_sxfs = document.getElementById("fsTypeID1");
    var radio_sxfsfw = document.getElementById("fsTypeID2");
    if(writeProtectLicense == "true") {
        if(document.forms[0] && radio_sxfs.checked &&
            !document.forms[0].elements["fsInfo.repli"].checked &&
            document.forms[0].elements["fsInfo.format"].checked) {
            document.forms[0].elements["wprotect"].disabled = 0;
        } else {
            document.forms[0].elements["wprotect"].disabled = 1;
            document.forms[0].elements["wpdays"].disabled = 1;
        }
    } else {
        document.forms[0].elements["wprotect"].disabled = 1;
    }
    clickWPSet();
}

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
        alert('<bean:message key="msg.add.invalidMountpoint" bundle="volume/filesystem"/>');
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

function onSet(){
	if (isSubmitted()){
       return false;
    }
    var lvPathObj = document.forms[0].elements["fsInfo.lvPath"];
    var volName = lvPathObj.options[lvPathObj.selectedIndex].value.split("#")[0];
    if (checkVolumeName(volName) != true){
        alert('<bean:message key="msg.add.invalidVolume" bundle="volume/filesystem"/>');
        lvPathObj.focus();
        return false;
    }
    var mountPointObj = document.forms[0].elements["fsInfo.mountPoint"];
    var mpShowObj = document.forms[0].elements["mountPointShow"];
    mountPointObj.value = "<%=NSActionUtil.getExportGroupPath(request)%>" +"/"+ mpShowObj.value;
    var tmpReg = /\/+/g;
    if (checkMountPointName(mountPointObj.value) != true
        || mpShowObj.value == ""
        || mpShowObj.value.replace(tmpReg,"/") == "/"){
        alert('<bean:message key="msg.add.invalidMountpoint" bundle="volume/filesystem"/>');
        mpShowObj.focus();
        return false;
    }
    mountPointObj.value =  compactPath(mountPointObj.value);
    if (mountPointObj.value.length > 2047){
        alert('<bean:message key="msg.add.maxMPLength" bundle="volume/filesystem"/>');
        mpShowObj.focus();
        return false;
    }
    if (chkEveryLevel(mountPointObj.value) != true){
        alert('<bean:message key="msg.add.maxDirLength" bundle="volume/filesystem"/>');
        mpShowObj.focus();
        return false;
    }
    
    if(!document.forms[0].elements["wprotect"].disabled && document.forms[0].elements["wprotect"].checked) {
        if(!checkWpPeriod(document.forms[0].elements["wpdays"])) {
            alert('<bean:message key="info.alert.invalid.wp.days" bundle="volume/filesystem"/>');
            document.forms[0].elements["wpdays"].focus();
            return false;
        } else {
            document.forms[0].elements["fsInfo.wpPeriod"].value = document.forms[0].elements["wpdays"].value;
        }
    } else {
        document.forms[0].elements["fsInfo.wpPeriod"].value = "--";
    }
    
    
    // add for volume license by jiangfx, 2007.7.5
    var licenseAlert = "";
    <logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
        // get LV size, license capacity and total created volume capacity
		var lvSize     = lvPathObj.options[lvPathObj.selectedIndex].value.split("#")[1];
        var licenseCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session"/>';
        var totalFSCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session"/>';
        
        // get cofirm message for exceed license capacity
    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
    	    && (parseFloat(lvSize) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
    		licenseAlert = "<bean:message key="volumeLicense.exceed.fsCreate"/>" + "\r\n\r\n";
    	}
    </logic:equal>
    
    var confirmAlert = licenseAlert + "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.create" bundle="common"/>" + "\r\n";
    if(document.forms[0].elements["fsInfo.wpPeriod"].value >= 1) {
        confirmAlert = "<bean:message key="info.confirm.set.writeprotected" bundle="volume/filesystem"/>" + "\r\n";
    }
    
    if (!confirm(confirmAlert + "<bean:message key="msg.longTimeWait" bundle="volume/filesystem"/>")){
        return false;
    }
    setSubmitted();
    heartBeatWin = openHeartBeatWin();
    lockMenu();
    return true;
    
}
</script>
</head>
<body onload="init();displayAlert()" onUnload="unLockMenu();closePopupWin(navigatorWin);closePopupWin(heartBeatWin);closeDetailErrorWin();">
<html:form action="addFS.do?operation=addFS" onsubmit="return onSet();">
<h1 class="title"><bean:message key="h1.filesystem"/></h1>
<html:button property="back" onclick="onBack()">
	<bean:message key="common.button.back" bundle="common"/>
</html:button>
<h2 class="title"><bean:message key="h2.filesystem.add"/></h2>
<displayerror:error h1_key="h1.filesystem"/>
<br>
<jsp:include page="../volume/volumelicensecommon.jsp" flush="true">
    <jsp:param name="moduleBundle" value="volume/filesystem"/>
</jsp:include>
<h3 class="title"><bean:message key="h3.filesystem.basic.set"/></h3>
<nested:nest property="fsInfo">
<nested:hidden property="wpPeriod"/>
<table border="1">
    <tr>
      <th align="left" nowrap><bean:message key="create.th.lv.name"/></th>    
      <td>
    	<logic:empty name="<%=FilesystemConst.SESSION_FREE_LV_VEC%>" scope="request">
    	 	<nested:select property="lvPath">
		  	        <option value="<bean:message key="info.noOption" bundle="volume/filesystem"/>">
		  	            <bean:message key="info.noOption" bundle="volume/filesystem"/>
		  	        </option>
		  	</nested:select>
		</logic:empty>
		<logic:notEmpty name="<%=FilesystemConst.SESSION_FREE_LV_VEC%>" scope="request">
    	 	<nested:select property="lvPath" onchange="chgVolume()">
    	 		<logic:iterate id="freeLv" name="<%=FilesystemConst.SESSION_FREE_LV_VEC%>" scope="request">
    	 		     <bean:define id="lvName" name="freeLv" property="lvPath" type="java.lang.String"/>
                     <bean:define id="lvSize" name="freeLv" property="lvSize" type="java.lang.String"/>
                     <bean:define id="vgPairFlag" name="freeLv" property="vgPairFlag" type="java.lang.String"/>
		  	        	<html:option value="<%=lvName + "#" + lvSize + "#" + vgPairFlag%>">
		  	            	<bean:write name="freeLv" property="value4Show"/>
		  	        	</html:option>
		  		</logic:iterate>
		  	</nested:select>
		</logic:notEmpty>
	    <nested:checkbox property="format" styleId="formatID" onclick="clickFormat(this);"/>
	    <label for="formatID"><bean:message key="create.msg.format"/></label>
      </td>
    </tr>
    
    <tr>
      <th align="left" nowrap><bean:message key="info.fsType" bundle="volume/filesystem"/></th>
      <td nowrap>
      		  <nested:radio property="fsType" styleId="fsTypeID1" value="sxfs" onclick="clickFstype();"/>
      		  <label for="fsTypeID1">
      		  <bean:message key="info.fsType.sxfs" bundle="volume/filesystem"/>&nbsp;&nbsp;</label>
              <nested:radio property="fsType" styleId="fsTypeID2" value="sxfsfw" onclick="clickFstype();"/>
      		  <label for="fsTypeID2">
      		  <bean:message key="info.fsType.sxfsfw" bundle="volume/filesystem"/></label>
      </td>
    </tr>

    <tr>
      <th align="left" nowrap><bean:message key="info.journal" bundle="volume/filesystem"/></th>
      <td nowrap>
              <nested:radio property="journalType" styleId="journalID1" value="standard"/>
      		  <label for="journalID1">
      		  <bean:message key="info.journal.standard" bundle="volume/filesystem"/>&nbsp;&nbsp;</label>
              <nested:radio property="journalType" styleId="journalID2" value="expand"/>
      		  <label for="journalID2">
      		  <bean:message key="info.journal.expand" bundle="volume/filesystem"/></label>
      </td>
    </tr>
    
    <tr>
      <th align="left" nowrap><bean:message key="info.mountpoint" bundle="volume/filesystem"/></th>
      <bean:define id="exportGroup" value="<%=NSActionUtil.getExportGroupPath(request)%>"/>
      <td nowrap><bean:write name="exportGroup"/>/
        <nested:hidden property="mountPoint"/>
        <html:text property="mountPointShow" size="20" maxlength="2047"/>
        <html:button property="select" onclick="popupNavigator();">
        <bean:message key="common.button.browse2" bundle="common"/>
        </html:button>
        <html:hidden property="exportGroup" value="<%=NSActionUtil.getExportGroupPath(request)%>"/>
      </td>
    </tr>
    
    <logic:equal name="isNashead" value="true" scope="request">
	    <logic:equal name="hasGfsLicense" value="true" scope="request">
	       <tr>
	         <th align="left"><bean:message key="info.gfs" bundle="volume/filesystem"/></th>
	         <td>
	            <nested:checkbox property="useGfs" styleId="useGfsId" value="true" onclick="clickGfs()"/>
	            <label for="useGfsId"><bean:message key="info.useGfs" bundle="volume/filesystem"/></label>                             
	         </td>
	       </tr> 
	    </logic:equal>
    </logic:equal>  
  </table>

<h3 class="title"><bean:message key="h3.filesystem.mount.set"/></h3>
<table  border="1">
  <tr>
    <th align="left" nowrap><bean:message key="info.access" bundle="volume/filesystem"/></th>
    <td nowrap>
              <nested:radio property="accessMode" styleId="modeID1" value="rw" onclick="clickAccessMode()"/>
      		  <label for="modeID1">
      		  <bean:message key="info.access.rw" bundle="volume/filesystem"/>&nbsp;&nbsp;</label>
              <nested:radio property="accessMode" styleId="modeID2" value="ro" onclick="clickAccessMode()"/>
      		  <label for="modeID2">
      		  <bean:message key="info.access.ro" bundle="volume/filesystem"/></label>
    </td>
  </tr>

  <tr>
     <th align="left" valign="top" nowrap rowspan="4"><bean:message key="info.option" bundle="volume/filesystem"/></th>
     <td>
        <nested:checkbox property="quota" styleId="quotaID"/>
	    <label for="quotaID">
	    <bean:message key="info.quota" bundle="volume/filesystem"/></label>
	 </td>
  </tr>
  <tr>
     <td>
     	<nested:checkbox property="updateAccessTime" styleId="timeID"/>
	    <label for="timeID">
	    <bean:message key="info.noatime" bundle="volume/filesystem"/></label>
	 </td>
  </tr>
  <tr>
     <td>
     	<nested:checkbox property="norecovery" styleId="recoveryID" disabled="true"/>
	    <label for="recoveryID">
	    <bean:message key="info.norecovery" bundle="volume/filesystem"/></label>
     </td>
  </tr>
  <tr>
     <td>
        <bean:define id="hasReplic" name="hasReplicLicense" type="java.lang.String"/>
        <nested:checkbox property="repli" styleId="repliID" onclick="clickMvd()" disabled='<%=hasReplic.equals("false")%>'/>
	    <label for="repliID">
	    <bean:message key="info.replication" bundle="volume/filesystem"/></label>
     </td>
  </tr>
  <tr>
    <th align="left" nowrap><bean:message key="info.replication" bundle="volume/filesystem"/></th>
    <td nowrap>
        	  <nested:radio property="replicationType" styleId="rtID1" value="original" disabled="true" onclick="clickRepType()"/>
              <label for="rtID1">
      		  <bean:message key="info.replication.original" bundle="volume/filesystem"/>&nbsp;&nbsp;</label>
              <nested:radio property="replicationType" styleId="rtID2" value="replic" disabled="true" onclick="clickRepType()"/>
      		  <label for="rtID2">
      		  <bean:message key="info.replication.replic" bundle="volume/filesystem"/></label>
    </td>
  </tr>
  <tr>
    <th align="left" nowrap><bean:message key="info.snapshotArea" bundle="volume/filesystem"/></th>
    <td>
      <nested:select property="snapshotArea">
          <html:option value="100">100%(<bean:message key="info.nolimit" bundle="volume/filesystem"/>)</html:option>
          <html:option value="90">90%</html:option>
          <html:option value="80">80%</html:option>
          <html:option value="70">70%</html:option>
          <html:option value="60">60%</html:option>
          <html:option value="50">50%</html:option>
          <html:option value="40">40%</html:option>
          <html:option value="30">30%</html:option>
          <html:option value="20">20%</html:option>
          <html:option value="10">10%</html:option>
      </nested:select>
    </td>
  </tr>
  <tr>
      <th align="left" nowrap><bean:message key="info.writeprotected" bundle="volume/filesystem"/></th>
      <td>
          <input type="checkbox" name="wprotect" id="wprotect" onclick="clickWPSet();" />
          <label for="wprotect"><bean:message key="info.writeprotected.set" bundle="volume/filesystem"/></label>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <input type="text" name="wpdays" size="5" maxlength="5" value="1825"  style="text-align:right" disabled />
          <bean:message key="info.writeprotected.set.days" bundle="volume/filesystem"/>
      </td>
  </tr>
</table>
  </nested:nest>
<br>
<html:submit property="set">
    <bean:message key="common.button.submit" bundle="common"/>
</html:submit>
</html:form>
<html:form target="volume_create_navigator" action="VCNavigatorList.do">
  <html:hidden property="method" value="call"/>
  <html:hidden property="rootDirectory" value=""/>
  <html:hidden property="nowDirectory" value=""/>
</html:form>
</body>
</html:html>