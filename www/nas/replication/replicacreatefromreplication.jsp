<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicacreatefromreplication.jsp,v 1.24 2008/10/09 09:51:45 chenb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page buffer="64kb" %> 
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<%@include file="replicationcommon.jsp" %>
<%@include file="replicacommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">
var availVolume = new Array(2);
<logic:present name="availVolume" scope="request">
<logic:iterate id="mapBean" name="availVolume" indexId="fsNum">
    availVolume[<%=fsNum%>] = new Array();
    <logic:notEmpty name="mapBean" property="value">
    <logic:iterate id="labelValueBean" name="mapBean" property="value" indexId="mpNum">
    availVolume[<%=fsNum%>][<%=mpNum%>] = new Option("<bean:write name="labelValueBean" property="label"/>","<bean:write name="labelValueBean" property="value"/>");   
    </logic:iterate>
    </logic:notEmpty >
</logic:iterate>
</logic:present>
var licenseAlert = "";
function onSet(){
    if (isSubmitted()){
        return false;
    }
    
    var hostName = document.forms[0].elements["replicaInfo.originalServer"].value;
    if ( hostName == "" ){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.oriservername.no"/>");
        document.forms[0].elements["replicaInfo.originalServer"].focus();
        return false;
    }
    if(!checkServerName(hostName)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.oriservername.invalid"/>");
        document.forms[0].elements["replicaInfo.originalServer"].focus();
        return false;
    }
    
    var filesetPreffix = document.forms[0].elements["filesetNamePrefix"].value;
    var filesetSuffix = document.forms[0].elements["filesetNameSuffix"].value;
    if(!checkFilesetName(filesetPreffix, filesetSuffix)){
       document.forms[0].elements["filesetNamePrefix"].focus();
       return false;
    }

    var fset = new String(filesetPreffix + "#" + filesetSuffix);    
    document.forms[0].elements["replicaInfo.filesetName"].value = fset;

	// check snap-keep limit    
	var useSnapKeepChkbox = document.forms[0].elements["replicaInfo.useSnapKeep"];
    if ((!useSnapKeepChkbox.disabled) && (useSnapKeepChkbox.checked)) {
		if (!checkSnapKeepLimit()) {
			return false;
		}
    }    

    var newVolume = document.getElementById("newVolume");
    if(newVolume.checked){
        if(!checkVolume()){
            return false;
        };
    }//if useExist is checked , must has mp can be used

    var cfmMsg = "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.create" bundle="common"/>";

    var format = document.forms[0].elements["format"];
    if(newVolume.checked || (!format.disabled && format.checked)){
        if (newVolume.checked) {
        	cfmMsg = licenseAlert + cfmMsg;
        }
        cfmMsg = cfmMsg + "\r\n\r\n"+"<bean:message key="msg.longTimeWait" bundle="volume/replication"/>";
    }

    if (!confirm(cfmMsg)){
        return false;
    }
    setSubmitted();
  
    if(newVolume.checked || (!format.disabled && format.checked)){
        heartBeatWin = openHeartBeatWin();
    }

    document.forms[0].action="/nsadmin/replication/replicaCreate.do?errorFromFlag=forMVDSync";
    document.forms[0].submit();
    return true;
}

function onChangeFsType(obj){
    var index = obj.selectedIndex;
    var volumeFsTypeObj = document.forms[0].elements["volumeInfo.fsType"];
    volumeFsTypeObj.value= (index == 0) ? "sxfs" : "sxfsfw";

    var selectMpObj = document.forms[0].elements["replicaInfo.mountPoint"];    
    var disableStauts = selectMpObj.disabled;
    selectMpObj.disabled = false;
    for (var i=0;i<availVolume[index].length;i++){
        selectMpObj.options[i]=availVolume[index][i];
    }
    
    selectMpObj.options.length=availVolume[index].length;

    if(selectMpObj.options.length==0){
        selectMpObj.options[0]= new Option("<bean:message key="info.noOption" bundle="volume/replication"/>","<bean:message key="info.noOption" bundle="volume/replication"/>");
        disableStauts=true;
        document.forms[0].elements["format"].disabled=true;
        document.getElementById("useExist").disabled=true;

        var obj_newVolume = document.getElementById("newVolume");
        obj_newVolume.checked=true;
        onDecideNewVolume(obj_newVolume);
    }else{
        var obj_useExist = document.getElementById("useExist");
        obj_useExist.disabled=false;
    }
    selectMpObj.disabled = disableStauts;
}

function onDecideNewVolume(obj){
    if(obj.disabled){
        return false;
    }
    var replicaMp = document.forms[0].elements["replicaInfo.mountPoint"];
    var format = document.forms[0].elements["format"];  
    if(obj.value == "newVolume" ){
        document.getElementById('volume').style.display="block";
        replicaMp.disabled=true;
        format.disabled=true;
    }else{
	    document.getElementById('volume').style.display="none";
	    replicaMp.disabled=false;
        format.disabled=false;
    }
}

var navigatorWin;
var heartBeatWin;
var poolWin;
var lunWin;

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
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + '<bean:message key="msg.add.invalidMountpoint" bundle="volume/replication"/>');
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
    if(lunWin==null || lunWin.closed){
        lunWin=window.open("/nsadmin/framework/moduleForward.do?h1=apply.replication.mvdsync&msgKey=apply.volume.volume.forward.to.lun.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/lunSelectShow.do?src=replication","nasheadPop","toolbar=no,menubar=no,scrollbars=yes,width=500,height=520,resizable=yes");
        window.wwnn = document.forms[0].elements["volumeInfo.wwnn"];
    }else{
        lunWin.focus();
    }   
}
</logic:equal>

<logic:notEqual name="isNashead" value="true">
function openSelectPool(){
    if (isSubmitted()){
        return false;
    }
    if (poolWin == null || poolWin.closed){
        poolWin = window.open("/nsadmin/common/commonblank.html", "volume_selectPool", "width=700,height=650,resizable=yes,scrollbars=yes,status=yes");
 
        window.aid = document.forms[2].aid;
        window.raidType   = document.forms[2].raidType;
        window.poolName = document.forms[0].elements["volumeInfo.poolName"];
        window.poolNo   = document.forms[0].elements["volumeInfo.poolNo"];
        window.raidTypeDiv   = document.getElementById("raidTypeDiv");
        window.usableCapDiv = document.getElementById("usableCapDiv");

        document.forms[2].submit();
    }else{
        poolWin.focus();
    }
}
</logic:notEqual>

function checkVolume(){
    var volumObj = document.forms[0].elements["volumeInfo.volumeName"];
    if (checkVolumeName(volumObj.value) != true){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + '<bean:message key="msg.add.invalidVolume" bundle="volume/replication"/>');
        volumObj.focus();
        return false;
    }
    
    <logic:equal name="isNashead" value="true">
        var selectedLun = document.getElementById("selectedLun").innerHTML;
        var selectedLunSize = document.getElementById("selectedLunSize").innerHTML;
        selectedLunSize = combinateStr(selectedLunSize);
        if ( selectedLun == "--"){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  + '<bean:message key="msg.add.noLUN" bundle="volume/replication"/>');
            return false;
        }
        if (parseFloat(selectedLunSize) > <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  + "<bean:message key="msg.exceedMVDSyncMaxSize" bundle="volume/replication"/>");
            return false;
        }
       
        document.forms[0].elements["volumeInfo.capacity"].value = selectedLunSize;
        document.forms[0].elements["volumeInfo.storage"].value = selectedLun;
    </logic:equal>    

    <logic:notEqual name="isNashead" value="true">
        if (document.forms[0].elements["volumeInfo.poolName"].value == ""){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  + '<bean:message key="msg.add.noSelectedPool" bundle="volume/replication"/>');
            return false;
        }

        var poolName = document.forms[0].elements["volumeInfo.poolName"].value;
        var selectedPoolNum = (poolName.split(",")).length;
        
        var capciObj = document.forms[0].elements["volumeInfo.capacity"];
        if (selectedPoolNum == 1) {
	        if (capciObj.value==""
	           || checkCapacity(capciObj.value) != true){
	            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                  + '<bean:message key="msg.add.lessthan01" bundle="volume/replication"/>');
	            capciObj.focus();
	            return false; 
	        }
        } else {
            if (capciObj.value==""
               || checkCapacity(capciObj.value, 1) != true){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                      + '<bean:message key="msg.add.morethan1" bundle="volume/replication"/>');
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
	            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                  + '<bean:message key="msg.add.lessthan01" bundle="volume/replication"/>');
            } else {
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                      + '<bean:message key="msg.add.morethan1" bundle="volume/replication"/>');
            }
            capciObj.focus();
            return false; 
        }
        if (parseFloat(volumeSize) > parseFloat(availCapValue)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  + "<bean:message key="msg.add.exceedMaxCapacity" bundle="volume/replication"/>");
            capciObj.focus();
            return false;
        }
        
        if (parseFloat(volumeSize) > <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  + "<bean:message key="msg.exceedMVDSyncMaxSize" bundle="volume/replication"/>");
            capciObj.focus();
            return false;
        }
        <logic:equal name="<%=VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES%>" value="true" scope="session">
	        var bltime = document.forms[0].elements["volumeInfo.bltime"].value;
	        if(!isBlTimeValid(bltime, 0, 255)){
	        	alert("<bean:message key="info.bltime.invalid.alert" bundle="volume/replication"/>");
	        	document.forms[0].elements["volumeInfo.bltime"].focus();
	        	return false;
	        }
        </logic:equal>
        document.forms[0].elements["volumeInfo.aid"].value = document.forms[2].aid.value;
        document.forms[0].elements["volumeInfo.raidType"].value = document.forms[2].raidType.value;;
        document.forms[0].usableCap.value = document.getElementById("usableCapDiv").innerHTML;
    </logic:notEqual>

    
    var mountPointObj = document.forms[0].elements["volumeInfo.mountPoint"];
    var mpShowObj = document.forms[0].elements["mountPointShow"];
    mountPointObj.value = document.forms[0].exportGroup.value +"/"+ mpShowObj.value;
    var tmpReg = /\/+/g;
    if (checkMountPointName(mountPointObj.value) != true
        || mpShowObj.value == ""
        || mpShowObj.value.replace(tmpReg,"/") == "/"){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + '<bean:message key="msg.add.invalidMountpoint" bundle="volume/replication"/>');
        mpShowObj.focus();
        return false;
    }
    mountPointObj.value =  compactPath(mountPointObj.value);
    if (mountPointObj.value.length > 2047){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + '<bean:message key="msg.add.maxMPLength" bundle="volume/replication"/>');
        mpShowObj.focus();
        return false;
    }
    if (chkEveryLevel(mountPointObj.value) != true){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + '<bean:message key="msg.add.maxDirLength" bundle="volume/replication"/>');
        mpShowObj.focus();
        return false;
    }
    
    // add for volume license by jiangfx, 2007.7.5
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
    	licenseAlert = "";
    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
    	    && (parseFloat(specifiedCap) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
    		licenseAlert = "<bean:message key="volumeLicense.exceed.volCreate" bundle="volume/replication"/>" + "\r\n\r\n";
    	}
    </logic:equal>
    
    return true;
}

function init(){
    if (document.getElementById("newVolume").checked) {
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
	        window.gfsLicense = "<bean:write name="hasGfsLicense" scope="request"/>";
	        window.selectedLdPath = document.forms[0].selectedLdPath;
	        window.differentSize = document.forms[0].differentSize;
	        
		    var capacity = document.forms[0].elements["volumeInfo.capacity"].value;
		    if (capacity != null && capacity != "") {
                document.getElementById("selectedLunSize").innerHTML = splitString(capacity);
            }
            
            document.getElementById("selectedLun").innerHTML = document.forms[0].elements["volumeInfo.storage"].value;
		</logic:equal>
    }
    
    var filesetSuffixObj = document.forms[0].elements["filesetNameSuffix"];
    onChangeFsType(filesetSuffixObj);
    var radioUseExist = document.getElementById("useExist");
    var radioNewVolume = document.getElementById("newVolume");
    var hiddenLastMp = document.forms[0].elements["lastMp"];

    onDecideNewVolume(radioUseExist.checked ? radioUseExist : radioNewVolume);

    if(radioUseExist.checked && hiddenLastMp.value != ""){
        var selectMp = document.forms[0].elements["replicaInfo.mountPoint"];
        for (var i=0;i<selectMp.options.length;i++){
	        if(selectMp.options[i].value == hiddenLastMp.value){
	          selectMp.options[i].selected= true;
	        }
        }
    }
    document.forms[0].elements["replicaInfo.originalServer"].focus();

    onChangeRepliTiming();
}

</script>
</head>

<body onLoad="init();loadSubmitPage(false);setHelpAnchor('replication_6');" 
    onUnload="closePopupWin(navigatorWin);closePopupWin(heartBeatWin);closePopupWin(poolWin);closePopupWin(lunWin);closeDetailErrorWin();unloadBtnFrame();">
 
<html:form action="replicaCreate.do">
<html:button property="goBack" onclick="return loadReplicaList()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<br><br>
<displayerror:error h1_key="replicate.h1"/>
<h3 class="title"><bean:message key="replica.add.h3"/></h3>
<h4><bean:message key="replica.add.h4.fileset"/></h4>
<%String colspan = "2"; %>
<input type="hidden" name="lastMp" value="<bean:write name="replicaCreateForm" property="replicaInfo.mountPoint"/>">
<table border="1" width="570" nowrap class="Vertical">
    <tr>
        <th><bean:message key="replication.info.oriservername"/></th>
        <td colspan="<%=colspan%>"><html:text property="replicaInfo.originalServer" maxlength="255" size="60"/></td>
    </tr>
    <tr>
        <th><bean:message key="replication.info.filesetname"/></th>
        <td colspan="<%=colspan%>"><html:hidden property="replicaInfo.filesetName"/>
            <html:text property="filesetNamePrefix" maxlength="255" size="20"/>
            <bean:message key="replication.info.filesetseparator"/>
            <html:select property="filesetNameSuffix" onchange="onChangeFsType(this)">
                <html:optionsCollection name="filesetNameSuffixVec" />
            </html:select>
        </td>
    </tr>
    <tr>
        <th valign="top" rowspan="3"><bean:message key="replication.info.mountpoint"/></th>
        <td colspan="<%=colspan%>"><html:radio property="newVolume" value="newVolume" styleId="newVolume" onclick="onDecideNewVolume(this);"/>
            <label for="newVolume"><bean:message key="replication.info.mountpoint.newvolume"/></label></td>
    </tr>
    <tr><td valign="top" rowspan="2"><html:radio property="newVolume" value="useExist" styleId="useExist"  onclick="onDecideNewVolume(this);"/>
            <label for="useExist"><bean:message key="replication.info.mountpoint.useexist"/></label></td>
        <td><bean:write name="exportGroup" scope="request"/>/
            <html:select property="replicaInfo.mountPoint">
            </html:select>
        </td>
    </tr>
    <tr><td>
        <html:checkbox property="format" styleId="format"/>
        <label for="format"><bean:message key="replication.info.format"/></label>
    </td></tr>
    <tr>
        <th><bean:message key="replication.info.interface"/></th>
        <td colspan="<%=colspan%>">
            <html:select property="replicaInfo.transInterface">
                <html:option value=""><bean:message key="replication.info.interface.nospecified"/></html:option>
                <html:optionsCollection name="interfaceVec" />
            </html:select>
        </td>
    </tr>
    <tr>
        <th valign="top"><bean:message key="replication.info.replidata"/></th>
        <td colspan="<%=colspan%>">
            <html:radio property="replicaInfo.replicationData" value="all" styleId="all" onclick="onChangeRepliTiming()"/>
            <label for="all"><bean:message key="replication.info.replidata.all"/></label><br>
            <html:radio property="replicaInfo.replicationData" value="onlysnap" styleId="onlysnap" onclick="onChangeRepliTiming()"/>
            <label for="onlysnap"><bean:message key="replication.info.replidata.onlysnap"/></label><br>
            <html:radio property="replicaInfo.replicationData" value="curdata" styleId="curdata" onclick="onChangeRepliTiming()"/>
            <label for="curdata"><bean:message key="replication.info.replidata.curdata"/></label><br>
        </td>
    </tr>
    <tr>
        <th valign="top"><bean:message key="replication.info.snapKeepMode"/></th>
        <td colspan="<%=colspan%>">
        	<html:checkbox property="replicaInfo.useSnapKeep" styleId="chkboxUseSnap" onclick="onUseSnapKeep(this)"/>
			<label for="chkboxUseSnap"><bean:message key="replication.info.usable"/></label>
			<br>&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message key="replication.info.snapKeepLimit"/>
			<html:text property="replicaInfo.snapKeepLimit" maxlength="3" size="3" style="text-align:right"/>
        </td>
    </tr>
</table> 

<div id="volume">
<h4><bean:message key="replica.add.h4.volume"/></h4>
<jsp:include page="../volume/volumelicensecommon.jsp" flush="true">
	<jsp:param name="moduleBundle" value="volume/replication"/>
</jsp:include>
<br>
<%boolean isNashead = ((String)request.getAttribute("isNashead")).equals("true")?true:false;%>
    <input type="hidden" name="exportGroup" value="<bean:write name="exportGroup"/>"/>
    <input type="hidden" name="selfURL" value="/nsadmin/replication/replicaCreateShow.do">
    
    <nested:nest property="volumeInfo">
    <nested:hidden property="fsType"/>      
    <nested:hidden property="replication" value="true"/>  
    <nested:hidden property="replicType" value="replic"/> 
    <nested:hidden property="machineType" value='<%=isNashead?"NASHEAD":"NV"%>'/>
    
    <table border="1" width="570" nowrap class="Vertical">
      <tr>
        <th><bean:message key="info.volumeName" bundle="volume/replication"/></th>
        <td colspan="2">
            <nested:text property="volumeName" styleId="volumeName" size="16" maxlength="16" />
        </td>
      </tr>
      
      <logic:equal name="isNashead" value="true">
          <html:hidden property="selectedLdPath"/>
          <html:hidden property="differentSize"/>
          <nested:hidden property="storage"/>
          <nested:hidden property="wwnn"/>
          <nested:hidden property="capacity"/>
          <tr>
            <th valign="top"><bean:message key="info.selected.lun" bundle="volume/replication"/></th>
            <td width="330px">
                <nested:define id="storage" property="storage" type="java.lang.String"/>
                <%String divHeight = (storage.split("<[BR]>").length >=3) ? "54px" : "auto";%>
                <DIV id="selectedLun" style="overflow: auto; width: auto; height: <%=divHeight%>">
                    <nested:write property="storage" filter="false"/>   
                </DIV>
            </td>
            <td style="valign:top; align:right"> 
                <html:button property="selectLunBtn" onclick="selectLun();">
                    <bean:message key="button.selectLun" bundle="volume/replication"/><bean:message key="button.dot" bundle="volume/replication"/>
                </html:button>
            </td>
          </tr>
          
          <tr>
               <th><bean:message key="info.selected.lun.size" bundle="volume/replication"/></th>
               <td colspan=2>
                   <DIV id="selectedLunSize"><bean:message key="info.off" bundle="volume/replication"/></DIV>
               </td>
          </tr>
      </logic:equal>      

      <logic:notEqual name="isNashead" value="true">
          <html:hidden property="usableCap"/>
          <nested:hidden property="aid"/>
	      <nested:hidden property="raidType"/>
	      <nested:hidden property="poolNo"/>
          
          <tr>
            <th><bean:message key="info.selectedPool" bundle="volume/replication"/></th>
            <td>
                <nested:text property="poolName" size="45" readonly="true"/>
            </td>
            <td style="align:right"> 
                <html:button property="poolSelectBtn" onclick="openSelectPool();">
                    <bean:message key="button.poolSelect" bundle="volume/replication"/><bean:message key="button.dot" bundle="volume/replication"/>
                </html:button>
            </td>
          </tr>
          
          <tr>
            <th><bean:message key="info.raidType" bundle="volume/replication"/></th>
            <td colspan=2>
                <DIV id="raidTypeDiv"><bean:message key="info.off" bundle="volume/replication"/></DIV>
            </td>
          </tr>

          <tr>
            <th><bean:message key="info.availCapacity" bundle="volume/replication"/></th>
            <td colspan=2>
                <DIV id="usableCapDiv"><bean:message key="info.off" bundle="volume/replication"/></DIV>
            </td>
          </tr>                      

          <tr>
            <th><bean:message key="info.volumeSize" bundle="volume/replication"/></th>
            <td colspan=2>
               <nested:text property="capacity" size="10" maxlength="10" styleId="capacity" 
                            style="text-align:right"/>

               <nested:select property="capacityUnit">
                   <html:option value="GB">GB</html:option>
                   <html:option value="TB">TB</html:option>
               </nested:select>
            </td>
          </tr>
          <logic:equal name="<%=VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES%>" value="true" scope="session">
	          <tr>
	    		<th><bean:message key="info.bltime.th" bundle="volume/replication"/><bean:message key="info.bltime.scale" bundle="volume/replication"/></th>
			    <td colspan=2><nested:text property="bltime" size="10" maxlength="3" style="text-align:right" />
	        		&nbsp;<bean:message key="info.bltime.td" bundle="volume/replication"/>&nbsp;&nbsp;<font class="advice"><bean:message key="info.bltime.tip" bundle="volume/replication"/></font></td>
			  </tr>
          </logic:equal>
      </logic:notEqual>
      
      <tr>
        <th><bean:message key="info.journal" bundle="volume/replication"/></th>
        <td colspan="2">
            <nested:radio property="journal" value="standard" styleId="standard"/>
            <label for="standard"><bean:message key="info.journal.standard" bundle="volume/replication"/></label>
            <nested:radio property="journal" value="expand" styleId="expand"/>
            <label for="expand"><bean:message key="info.journal.expand" bundle="volume/replication"/></label></td>
      </tr>
      <tr>
        <th><bean:message key="info.mountpoint" bundle="volume/replication"/></th>
        <td colspan="2"> 
            <bean:write name="exportGroup"/><bean:message key="info.root" bundle="volume/replication"/>
            <nested:hidden property="mountPoint"/>
            <html:text property="mountPointShow" size="20" maxlength="2047" />
            <html:button property="select" onclick="popupNavigator();">
               <bean:message key="common.button.browse2" bundle="common"/>
            </html:button>
        </td>
      </tr>
     
      <tr>
        <th valign="top" rowspan="2">
            <bean:message key="info.option" bundle="volume/replication"/>
        </th>
        <td colspan="2">
            <nested:checkbox property="quota" styleId="quota"/>
            <label for="quota"><bean:message key="info.quota" bundle="volume/replication"/></label>
        </td>
      </tr>
      <tr>
        <td colspan="2">
             <nested:checkbox property="noatime" styleId="noatime"/>
             <label for="noatime"><bean:message key="info.noatime" bundle="volume/replication"/></label>
        </td>
      </tr>
    </table>
    </nested:nest>
</div>
</html:form>   
<form name="VCNavigatorListForm" method="post" action="/nsadmin/volume/VCNavigatorList.do?from=replication" target="volume_create_navigator">
    <input type="hidden" name="method" value="call">
    <input type="hidden" name="rootDirectory" value="">
    <input type="hidden" name="nowDirectory" value="">
</form>

<form target="volume_selectPool" method="post" action="/nsadmin/volume/volumePoolSelect.do?from=replication&flag=notFromDisk">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>

</body>
</html:html>
