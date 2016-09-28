<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrpairextendtop.jsp,v 1.4 2008/06/03 05:56:47 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<%@ include file="ddrcommon.jsp"%>
<SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="javascript">

function loadBottomFrame(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrPairExtendBtn.do"/>' + '"',1);
  	}
}

var wrongMsg = "";
var extendSizeValue = 0;
var rv0IsExist = '<bean:write name="existRv0Info" scope="request"/>';
var rv1IsExist = '<bean:write name="existRv1Info" scope="request"/>';
var rv2IsExist = '<bean:write name="existRv2Info" scope="request"/>';
var heartBeatWin;
var poolWin;
function onExtendPair(){
	if (isSubmitted()){
        return false;
    }
    // mv pool
    var poolObj = document.forms[0].elements["mvInfo.selectedPoolName"];
    if(poolObj.value == ""){
    	wrongMsg = "<bean:message key="ddr.extend.msg.nopooltoselected"/>";
    	alert(wrongMsg);
    	return false;
    }
    
    // specified extendSize
    var poolNum = (poolObj.value.split(",")).length;
    var sizeObj = document.forms[0].elements["mvInfo.extendSize"];
    if(!checkSizeValue(poolNum, sizeObj)){
    	alert(wrongMsg);
    	return false;
    }
    
    // pool capacity
    document.forms[0].elements["mvInfo.selectedPoolAvailSize"].value = document.getElementById("mvAvailCapacityDiv").innerHTML;
    var availCap = combinateStr(document.getElementById("mvAvailCapacityDiv").innerHTML);
    var availCapValue = (new Number(parseFloat(availCap))).toFixed(1);     
    var extendSize = sizeObj.value;
    if (document.forms[0].elements["mvInfo.extendUnit"].value == "TB") {
        extendSize = (new Number(parseFloat(extendSize) * 1024)).toFixed(1); 
    }
    if (parseFloat(extendSize) < 1){
        if (poolNum == 1) {
        	wrongMsg='<bean:message key="ddr.extend.msg.add.lessthan01"/>';
        } else {// will not reach here                
            wrongMsg='<bean:message key="ddr.extend.msg.add.morethan1"/>';
        }
        alert(wrongMsg);
        sizeObj.focus();
        return false; 
    }
    if (parseFloat(extendSize) > parseFloat(availCapValue)){
        alert("<bean:message key="ddr.extend.msg.extend.exceedMaxCapacity.mv"/>");
        sizeObj.focus();
        return false;
    }
    if(!checkMvMaxSize()){
    	alert(wrongMsg);
    	return false;
    }
    
    extendSizeValue = extendSize;
    if(rv0IsExist == "yes"){
    	// rv0 pool
	    if(!checkRV(0)){
	        alert(wrongMsg);
	        return false;
	    }
	}
    
    if(rv1IsExist == "yes"){
    	// rv1 pool
	    if(!checkRV(1)){
            alert(wrongMsg);
            return false;
        }
    }
    
    if(rv2IsExist == "yes"){
    	// rv2 pool
	    if(!checkRV(2)){
            alert(wrongMsg);
            return false;
        }
    }
    var licenseAlert = "";
    <logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
        // get license capacity and total created volume capacity
        var licenseCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session"/>';
        var totalFSCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session"/>';

        // get cofirm message for exceed license capacity
    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
    	    && (parseFloat(extendSize) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
    		licenseAlert = "<bean:message key="volumeLicense.exceed.volExtend" bundle="volumeResource/ddr"/>" + "\r\n\r\n";
    	}
    </logic:equal>
    if (!confirm(licenseAlert + "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="ddr.extend.action.extend"/>" + "\r\n"
            + "<bean:message key="ddr.extend.msg.longTimeWait"/>")){
        return false;
    }
    
    setSubmitted();
    heartBeatWin = openHeartBeatWin();
    lockMenu();
    document.forms[0].submit();
    return true;
}
function checkMvMaxSize(){
    var allowableSize = '<bean:write name="mvAllowableSize" scope="request"/>';
    var hasSnapshot = '<bean:write name="mvHasSnapshot" scope="request"/>';
    var sizeUnit = document.forms[0].elements["mvInfo.extendUnit"].value;
    var extendSize = document.forms[0].elements["mvInfo.extendSize"].value;
    //originalSize unit is GB
    var originalSize = document.forms[0].elements["mvInfo.capacity"].value;
    var totalSize;
    if(sizeUnit == "TB"){
    	totalSize = parseFloat(extendSize) * 1024 + parseFloat(originalSize);
    }else{
    	totalSize = parseFloat(extendSize) + parseFloat(originalSize);
    }
    if(totalSize > allowableSize){
    	if(hasSnapshot == "yes"){
    		wrongMsg="<bean:message key="msg.exceed20TB.snapshot" bundle="volumeResource/ddr"/>";
    	}else{
    		wrongMsg="<bean:message key="msg.exceedMaxSize" bundle="volumeResource/ddr"/>";
    	}
    	return false;
    }
    return true;
}
function checkSizeValue(poolNum, sizeObj){
	if (poolNum == 1) {
	    if (sizeObj.value==""
	       || checkCapacity(sizeObj.value) != true){
               wrongMsg='<bean:message key="ddr.extend.msg.add.lessthan01"/>';
	        sizeObj.focus();
	        return false; 
	    }
    } else {
	    if (sizeObj.value==""
           || checkCapacity(sizeObj.value, 1) != true){
            wrongMsg='<bean:message key="ddr.extend.msg.add.morethan1"/>';
            sizeObj.focus();
            return false; 
        }
    }
    return true;
}
function checkRV(indexNum){
    var poolValue;
    var availCap;
    if(indexNum == "0"){
        poolValue = document.forms[0].elements["rv0Info.selectedPoolName"].value;
        availCap = document.getElementById("rv0AvailCapacityDiv").innerHTML;
        document.forms[0].elements["rv0Info.selectedPoolAvailSize"].value = availCap;
    }else if(indexNum == "1"){
        poolValue = document.forms[0].elements["rv1Info.selectedPoolName"].value;
        availCap = document.getElementById("rv1AvailCapacityDiv").innerHTML;
        document.forms[0].elements["rv1Info.selectedPoolAvailSize"].value = availCap;
    }else if(indexNum == "2"){
        poolValue = document.forms[0].elements["rv2Info.selectedPoolName"].value;
        availCap = document.getElementById("rv2AvailCapacityDiv").innerHTML;
        document.forms[0].elements["rv2Info.selectedPoolAvailSize"].value = availCap;
    }
    if(poolValue == ""){
    	wrongMsg = "<bean:message key="ddr.extend.msg.nopooltoselected"/>";
    	return false;
    }
    availCap = combinateStr(availCap);
    var availCapValue = (new Number(parseFloat(availCap))).toFixed(1);
    if (parseFloat(extendSizeValue) > parseFloat(availCapValue)){
        wrongMsg = "<bean:message key="ddr.extend.msg.extend.exceedMaxCapacity.rv"/>";
        document.forms[0].elements["mvInfo.extendSize"].focus();
        return false;
    }
    return true;
}
function openSelectPool(flagNumber){
    if (isSubmitted()){
        return false;
    }
    
    var poolSelectForm = document.mvPoolSelectForm;
    var poolName = "mvInfo.selectedPoolName";
    var poolNo = "mvInfo.selectedPoolNo";
    var raidType = "mvInfo.raidType";
    var usableCapDiv = "mvAvailCapacityDiv";
    if (flagNumber == 0){
    	poolSelectForm = document.rv0PoolSelectForm;
    	poolName = "rv0Info.selectedPoolName";
    	poolNo = "rv0Info.selectedPoolNo";
    	raidType = "rv0Info.raidType";
    	usableCapDiv = "rv0AvailCapacityDiv";
    } else if (flagNumber == 1) {
    	poolSelectForm = document.rv1PoolSelectForm;
    	poolName = "rv1Info.selectedPoolName";
    	poolNo = "rv1Info.selectedPoolNo";
    	raidType = "rv1Info.raidType";
    	usableCapDiv = "rv1AvailCapacityDiv";
	} else if (flagNumber == 2) {
    	poolSelectForm = document.rv2PoolSelectForm;
    	poolName = "rv2Info.selectedPoolName";
    	poolNo = "rv2Info.selectedPoolNo";
    	raidType = "rv2Info.raidType";
    	usableCapDiv = "rv2AvailCapacityDiv";
	}

    if (poolWin == null || poolWin.closed){
        poolWin = window.open("/nsadmin/common/commonblank.html", "ddr_selectPool", "width=700,height=650,resizable=yes,scrollbars=yes,status=yes");
    } else {
    	poolWin.focus();
    }
	
	window.aid = poolSelectForm.aid;
	window.poolName = document.forms[0].elements[poolName];
	window.poolNo   = document.forms[0].elements[poolNo];
	window.usableCapDiv = document.getElementById(usableCapDiv);
    
	poolSelectForm.aid.value = document.forms[0].elements["mvInfo.aid"].value;
    
	var rvRaidType = document.forms[0].elements[raidType].value;
    if ((rvRaidType == "6(8+PQ)") || (rvRaidType == "--")) {
        poolSelectForm.raidType.value = "68";    
    } else if (rvRaidType == "6(4+PQ)") {
        poolSelectForm.raidType.value = "64"; 
    } else {
        poolSelectForm.raidType.value = rvRaidType; 
    }
    
    var unusablePoolNo = "";
    
    if(flagNumber == null){
    	// is mv
    	unusablePoolNo = getDisusePoolNo("yes");
	}else{
		// is rv
		unusablePoolNo = getDisusePoolNo("no");
	}
	
	poolSelectForm.action="/nsadmin/volume/volumePoolSelect.do?from=ddrExtend&flag=notFromDisk&unusablePoolNo=" + unusablePoolNo;
	poolSelectForm.submit();
}
function getDisusePoolNo(isMv){
	if(isMv == "yes"){
		// get all rv poolNo
		var rvDisusePoolNo = "";
		if(rv0IsExist == "yes"){
			rvDisusePoolNo = document.forms[0].elements["rv0Info.poolNo4extend"].value;
			var rv0SelectedPool = document.forms[0].elements["rv0Info.selectedPoolName"].value;
			if(rv0SelectedPool != ""){
				rvDisusePoolNo += ",";
				rvDisusePoolNo += document.forms[0].elements["rv0Info.selectedPoolNo"].value;
			}
		}
		if(rv1IsExist == "yes"){
			if(rvDisusePoolNo != ""){
				rvDisusePoolNo += ",";
			}
			rvDisusePoolNo += document.forms[0].elements["rv1Info.poolNo4extend"].value;
			var rv1SelectedPool = document.forms[0].elements["rv1Info.selectedPoolName"].value;
			if(rv1SelectedPool != ""){
				rvDisusePoolNo += ",";
				rvDisusePoolNo += document.forms[0].elements["rv1Info.selectedPoolNo"].value;
			}
		}
		if(rv2IsExist == "yes"){
			if(rvDisusePoolNo != ""){
				rvDisusePoolNo += ",";
			}
			rvDisusePoolNo += document.forms[0].elements["rv2Info.poolNo4extend"].value;
			var rv2SelectedPool = document.forms[0].elements["rv2Info.selectedPoolName"].value;
			if(rv2SelectedPool != ""){
				rvDisusePoolNo += ",";
				rvDisusePoolNo += document.forms[0].elements["rv2Info.selectedPoolNo"].value;
			}
		}
		return rvDisusePoolNo;
	}else{
		// get mv poolNo
		var mvDisusePoolNo = document.forms[0].elements["mvInfo.poolNo4extend"].value;
		var mvSelectedPool = document.forms[0].elements["mvInfo.selectedPoolName"].value;
		if(mvSelectedPool != ""){
			mvDisusePoolNo += ",";
			mvDisusePoolNo += document.forms[0].elements["mvInfo.selectedPoolNo"].value;
		}
		return mvDisusePoolNo;
	}
}
function init(){
	var mvAvailCapacity = document.forms[0].elements["mvInfo.selectedPoolAvailSize"].value;
	if (mvAvailCapacity != null && mvAvailCapacity != "") {
		document.getElementById("mvAvailCapacityDiv").innerHTML = mvAvailCapacity;
	}
	var rv0AvailCapacity = document.forms[0].elements["rv0Info.selectedPoolAvailSize"].value;
	if (rv0AvailCapacity != null && rv0AvailCapacity != "") {
		document.getElementById("rv0AvailCapacityDiv").innerHTML = rv0AvailCapacity;
	}
	var rv1AvailCapacity = document.forms[0].elements["rv1Info.selectedPoolAvailSize"].value;
	if (rv1AvailCapacity != null && rv1AvailCapacity != "") {
		document.getElementById("rv1AvailCapacityDiv").innerHTML = rv1AvailCapacity;
	}
	var rv2AvailCapacity = document.forms[0].elements["rv2Info.selectedPoolAvailSize"].value;
	if (rv2AvailCapacity != null && rv2AvailCapacity != "") {
		document.getElementById("rv2AvailCapacityDiv").innerHTML = rv2AvailCapacity;
	}
}
</script>
</head>
<body onload="init();loadBottomFrame();setHelpAnchor('disk_backup_3');" onUnload="unLockMenu();closePopupWin(heartBeatWin);closePopupWin(poolWin);closeDetailErrorWin();unloadBtnFrame();">
<html:form action="ddrPairExtend.do?operation=executePairExtend">
<html:hidden name="ddrPairListForm" property="mvInfo.name"/>
<html:hidden name="ddrPairListForm" property="mvInfo.capacity"/>
<html:hidden name="ddrPairListForm" property="mvInfo.aname"/>
<html:hidden name="ddrPairListForm" property="mvInfo.aid"/>
<html:hidden name="ddrPairListForm" property="mvInfo.mp"/>
<html:hidden name="ddrPairListForm" property="mvInfo.poolNameAndNo"/>
<html:hidden name="ddrPairListForm" property="mvInfo.poolNo4extend"/>
<html:hidden name="ddrPairListForm" property="mvInfo.selectedPoolNo"/>
<html:hidden name="ddrPairListForm" property="mvInfo.selectedPoolAvailSize"/>
<html:hidden name="ddrPairListForm" property="mvInfo.raidType"/>

<html:hidden name="ddrPairListForm" property="rv0Info.name"/>
<html:hidden name="ddrPairListForm" property="rv0Info.poolNameAndNo"/>
<html:hidden name="ddrPairListForm" property="rv0Info.poolNo4extend"/>
<html:hidden name="ddrPairListForm" property="rv0Info.selectedPoolNo"/>
<html:hidden name="ddrPairListForm" property="rv0Info.raidType"/>
<html:hidden name="ddrPairListForm" property="rv0Info.selectedPoolAvailSize"/>
<html:hidden name="ddrPairListForm" property="rv0Info.wwnn"/>

<html:hidden name="ddrPairListForm" property="rv1Info.name"/>
<html:hidden name="ddrPairListForm" property="rv1Info.poolNameAndNo"/>
<html:hidden name="ddrPairListForm" property="rv1Info.poolNo4extend"/>
<html:hidden name="ddrPairListForm" property="rv1Info.selectedPoolNo"/>
<html:hidden name="ddrPairListForm" property="rv1Info.raidType"/>
<html:hidden name="ddrPairListForm" property="rv1Info.selectedPoolAvailSize"/>
<html:hidden name="ddrPairListForm" property="rv1Info.wwnn"/>

<html:hidden name="ddrPairListForm" property="rv2Info.name"/>
<html:hidden name="ddrPairListForm" property="rv2Info.poolNameAndNo"/>
<html:hidden name="ddrPairListForm" property="rv2Info.poolNo4extend"/>
<html:hidden name="ddrPairListForm" property="rv2Info.selectedPoolNo"/>
<html:hidden name="ddrPairListForm" property="rv2Info.raidType"/>
<html:hidden name="ddrPairListForm" property="rv2Info.selectedPoolAvailSize"/>
<html:hidden name="ddrPairListForm" property="rv2Info.wwnn"/>

<input type="hidden" name="mvAllowableSize" value='<bean:write name="mvAllowableSize"/>'>
<input type="hidden" name="mvHasSnapshot" value='<bean:write name="mvHasSnapshot"/>'>

<input type="button" name="back" value="<bean:message key="common.button.back" bundle="common"/>" onclick="loadDdrPairList();">
<displayerror:error h1_key="ddr.h1"/>
<h3 class="title"><bean:message key="ddr.extend.h3"/></h3>
<jsp:include page="../volume/volumelicensecommon.jsp" flush="true">
    <jsp:param name="moduleBundle" value="volumeResource/ddr"/>
</jsp:include>
<h4 class="title"><bean:message key="pair.info.mvname"/></h4>
<table id="mvInfoTable" border="1" class="Vertical" nowrap>
	<tr>
		<th width=180px><bean:message key="ddr.title.mv"/></th>
		<td width=220px><bean:write name="ddrPairListForm" property="mvInfo.mvName4Show"/></td>
	</tr>
	<tr>
		<th><bean:message key="info.storage.capacity"/></th>
		<td><bean:write name="ddrPairListForm" property="mvInfo.capacity4Show"/></td>
	</tr>
	<tr>
		<th><bean:message key="info.diskarrayName"/></th>
		<td><bean:write name="ddrPairListForm" property="mvInfo.aname"/></td>
	</tr>
	<tr>
		<th valign="top"><bean:message key="ddr.extend.poolnameno"/></th>
		<bean:define id="mvPool" name="ddrPairListForm" property="mvInfo.poolNameAndNo" type="java.lang.String"/>
		<%String divMvHeight = (mvPool.split("<br>").length >=3) ? "54px" : "auto";%>
		<td>
			<DIV id="mvPoolNameAndNo" style="overflow: auto; width: auto; height:<%=divMvHeight%>">
            	<bean:write name="ddrPairListForm" property="mvInfo.poolNameAndNo" filter="false"/>
            </DIV>
	    </td>
	</tr>
	<tr>
		<th valign="top"><bean:message key="info.pool"/></th>
		<td><html:text property="mvInfo.selectedPoolName" size="20" readonly="true"/><br>
       		<html:button property="mvPoolSelectBtn" onclick="openSelectPool();"><bean:message key="button.poolSelect"/></html:button>
   		</td>
   	</tr>
   	<tr>
   		<th><bean:message key="info.pool.raidType"/></th>
   		<td><bean:write name="ddrPairListForm" property="mvInfo.raidType"/></td>
   	</tr>
   	<tr>
   		<th><bean:message key="info.pool.empty.capacity"/></th>
   		<td><DIV id="mvAvailCapacityDiv"><bean:message key="info.off"/></DIV></td>
   	</tr>
   	<tr>
   		<th><bean:message key="ddr.extend.extendsize"/></th>
   		<td><html:text property="mvInfo.extendSize" size="10" maxlength="10" style="text-align:right"/>
   			<html:select property="mvInfo.extendUnit">
   				<html:option value="GB">GB</html:option>
   				<html:option value="TB">TB</html:option>
   			</html:select>
		</td>
	</tr>
</table>
<h4 class="title"><bean:message key="pair.info.rvname"/></h4>
<table id="rvInfoTable" border="1" class="Vertical" nowrap>
	<tr>
		<th width=180px><bean:message key="ddr.title.rv"/></th>
		<logic:equal name="existRv0Info" value="yes">
			<td width=220px><bean:write name="ddrPairListForm" property="rv0Info.name"/></td>
		</logic:equal>
		<logic:equal name="existRv1Info" value="yes">
			<td width=220px><bean:write name="ddrPairListForm" property="rv1Info.name"/></td>
		</logic:equal>
		<logic:equal name="existRv2Info" value="yes">
			<td width=220px><bean:write name="ddrPairListForm" property="rv2Info.name"/></td>
		</logic:equal>
	</tr>
	<tr>
		<th valign="top"><bean:message key="ddr.extend.poolnameno"/></th>
		<logic:equal name="existRv0Info" value="yes">
			<bean:define id="rv0Pool" name="ddrPairListForm" property="rv0Info.poolNameAndNo" type="java.lang.String"/>
			<%String divRv0Height = (rv0Pool.split("<br>").length >=3) ? "54px" : "auto";%>
			<td>
				<DIV id="rv0PoolNameAndNo" style="overflow: auto; width: auto; height:<%=divRv0Height%>">
					<bean:write name="ddrPairListForm" property="rv0Info.poolNameAndNo" filter="false"/>
				</DIV>
			</td>
		</logic:equal>
		<logic:equal name="existRv1Info" value="yes">
			<bean:define id="rv1Pool" name="ddrPairListForm" property="rv1Info.poolNameAndNo" type="java.lang.String"/>
			<%String divRv1Height = (rv1Pool.split("<br>").length >=3) ? "54px" : "auto";%>
			<td>
			    <DIV id="rv1PoolNameAndNo" style="overflow: auto; width: auto; height:<%=divRv1Height%>">
			        <bean:write name="ddrPairListForm" property="rv1Info.poolNameAndNo" filter="false"/>
			    </DIV>
			</td>
		</logic:equal>
		<logic:equal name="existRv2Info" value="yes">
		    <bean:define id="rv2Pool" name="ddrPairListForm" property="rv2Info.poolNameAndNo" type="java.lang.String"/>
			<%String divRv2Height = (rv2Pool.split("<br>").length >=3) ? "54px" : "auto";%>
			<td>
			    <DIV id="rv2PoolNameAndNo" style="overflow: auto; width: auto; height:<%=divRv2Height%>">
			        <bean:write name="ddrPairListForm" property="rv2Info.poolNameAndNo" filter="false"/>
			    </DIV>
			</td>
		</logic:equal>
	</tr>
	<tr>
		<th valign="top"><bean:message key="info.pool"/></th>
		<logic:equal name="existRv0Info" value="yes">
			<td><html:text property="rv0Info.selectedPoolName" size="20" readonly="true"/><br>
				<html:button property="rv0PoolSelectBtn" onclick="openSelectPool(0);"><bean:message key="button.poolSelect"/></html:button>
			</td>
		</logic:equal>
		<logic:equal name="existRv1Info" value="yes">
			<td><html:text property="rv1Info.selectedPoolName" size="20" readonly="true"/><br>
				<html:button property="rv1PoolSelectBtn" onclick="openSelectPool(1);"><bean:message key="button.poolSelect"/></html:button>
			</td>
		</logic:equal>
		<logic:equal name="existRv2Info" value="yes">
			<td><html:text property="rv2Info.selectedPoolName" size="20" readonly="true"/><br>
				<html:button property="rv2PoolSelectBtn" onclick="openSelectPool(2);"><bean:message key="button.poolSelect"/></html:button>
			</td>
		</logic:equal>
	</tr>
	<tr>
		<th><bean:message key="info.pool.raidType"/></th>
		<logic:equal name="existRv0Info" value="yes">
			<td><bean:write name="ddrPairListForm" property="rv0Info.raidType"/></td>
		</logic:equal>
		<logic:equal name="existRv1Info" value="yes">
			<td><bean:write name="ddrPairListForm" property="rv1Info.raidType"/></td>
		</logic:equal>
		<logic:equal name="existRv2Info" value="yes">
			<td><bean:write name="ddrPairListForm" property="rv2Info.raidType"/></td>
		</logic:equal>
	</tr>
	<tr>
		<th><bean:message key="info.pool.empty.capacity"/></th>
		<logic:equal name="existRv0Info" value="yes">
			<td><DIV id="rv0AvailCapacityDiv"><bean:message key="info.off"/></DIV></td>
		</logic:equal>
		<logic:equal name="existRv1Info" value="yes">
			<td><DIV id="rv1AvailCapacityDiv"><bean:message key="info.off"/></DIV></td>
		</logic:equal>
		<logic:equal name="existRv2Info" value="yes">
			<td><DIV id="rv2AvailCapacityDiv"><bean:message key="info.off"/></DIV></td>
		</logic:equal>
	</tr>
</table>
</html:form>
<form name="mvPoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
<form name="rv0PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
<form name="rv1PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
<form name="rv2PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
</body>
</html>