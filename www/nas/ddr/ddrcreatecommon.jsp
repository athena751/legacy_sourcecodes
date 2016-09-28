<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrcreatecommon.jsp,v 1.5 2008/05/24 09:02:16 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">
var poolWin;

function reloadPage(){
	if (isSubmitted()){
	    return false;
	}
	setSubmitted();
	lockMenu();
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_ALWAYS%>" scope="request">
    window.location='/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairCreateShow.do?operation=showAlways&clearFormBeanInSession=true';
    
</logic:equal>
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_GENERATION%>" scope="request">
    window.location='/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairCreateShow.do?operation=showGeneration&clearFormBeanInSession=true';
</logic:equal>
   return true;
}
function setRvHiddenVal(rvNo){
    var rvInfo = "rv"+ rvNo + "Info";
    var rvName = rvInfo+".name";
    var rvAid  = rvInfo+".aid";
    var rvRaidType = rvInfo + ".raidType";
    var rvWwnn = rvInfo + ".wwnn";
    var rvUsableCap = rvInfo + ".usableCap";
    document.forms[0].elements[rvName].value      = document.getElementById("rv"+rvNo+"Name").innerHTML;
	document.forms[0].elements[rvAid].value       = document.forms[1].aid.value;
    document.forms[0].elements[rvRaidType].value  = document.getElementById("raidTypeDiv"+rvNo).innerHTML;
    document.forms[0].elements[rvWwnn].value      = document.forms[0].elements["mvInfo.wwnn"].value;
    if(document.getElementById("usableCapDiv"+rvNo).innerHTML!='<bean:message key="info.off"/>'){
        document.forms[0].elements[rvUsableCap].value = combinateStr(document.getElementById("usableCapDiv"+rvNo).innerHTML);
    }else{
        document.forms[0].elements[rvUsableCap].value = ""
    }
}

function selectMv(){

	var select = document.forms[0].elements["mvInfo.mvValue4Show"];
	var tmp = select.options[select.selectedIndex].value.split("#");
    var index = 0;
    var shortName      = tmp[index++];
    var size           = tmp[index++];
    var poolNameAndNo  = tmp[index++];
	var poolNo         = tmp[index++];
	var raidType       = tmp[index++];
	var wwnn           = tmp[index++];
	var aname          = tmp[index++];
	var aid            = tmp[index++];
	 
	var mvName = "NV_LVM_"+ shortName;
	//Set MV name
	document.forms[0].elements["mvInfo.name"].value     = mvName;
	//Set MV size
	document.getElementById("mvSize").innerHTML         = splitString(size);
	document.forms[0].elements["mvInfo.capacity"].value = size;
	// Set MV pool
	document.forms[0].elements["mvInfo.poolNameAndNo"].value = poolNameAndNo;
	document.getElementById("mvPoolNameAndNo").innerHTML     = poolNameAndNo;
	// Show scrolling bar when 3 more pools
	var poolDiv = document.getElementById("mvPoolNameAndNo");
    if (poolNameAndNo.split("<br>").length >=3){
        poolDiv.style.cssText='overflow: auto; width: auto; height:54px';
	}else{
	    poolDiv.style.cssText='overflow: auto; width: auto; height:auto';
	}
	document.forms[0].elements["mvInfo.poolNo"].value   = poolNo;
	// Set MV raidType
    document.getElementById("mvRaidType").innerHTML     = raidType;
    document.forms[0].elements["mvInfo.raidType"].value = raidType;
    // Set MV diskarray
    document.forms[0].elements["mvInfo.wwnn"].value     = wwnn;
    document.getElementById("mvDiskName").innerHTML     = aname;
    document.forms[0].elements["mvInfo.aname"].value    = aname;
    document.forms[0].elements["mvInfo.aid"].value      = aid; 
	changeRvName(shortName);
	clearRvInfo();	
}

function changeRvName(shortName){
    var rv0Name = "NV_RV0_"+shortName;
	document.getElementById("rv0Name").innerHTML = rv0Name;
	document.forms[0].elements["rv0Info.name"].value   = rv0Name;
//when d2dgeneration backup There are 3 rv names
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_GENERATION%>" scope="request">
    var rv1Name = "NV_RV1_"+shortName;
    var rv2Name = "NV_RV2_"+shortName;
	document.getElementById("rv1Name").innerHTML = rv1Name;
	document.forms[0].elements["rv1Info.name"].value   = rv1Name;
	document.getElementById("rv2Name").innerHTML = rv2Name;
	document.forms[0].elements["rv2Info.name"].value   = rv2Name;
</logic:equal>
}
function clearRvInfo(){
    document.forms[0].elements["rv0Info.poolName"].value  = "";
    document.forms[0].elements["rv0Info.raidType"].value  = "";
    document.forms[0].elements["rv0Info.usableCap"].value = "";
    document.getElementById("raidTypeDiv0").innerHTML  = '<bean:message key="info.off"/>';
    document.getElementById("usableCapDiv0").innerHTML = '<bean:message key="info.off"/>';
//when d2dgeneration backup clear rv1 and rv2 info
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_GENERATION%>" scope="request">
    document.forms[0].elements["rv1Info.poolName"].value  = "";
    document.forms[0].elements["rv1Info.raidType"].value  = "";
    document.forms[0].elements["rv1Info.usableCap"].value = "";
    document.getElementById("raidTypeDiv1").innerHTML  = '<bean:message key="info.off"/>';
    document.getElementById("usableCapDiv1").innerHTML = '<bean:message key="info.off"/>';
    
    document.forms[0].elements["rv2Info.poolName"].value  = "";
    document.forms[0].elements["rv2Info.raidType"].value  = "";
    document.forms[0].elements["rv2Info.usableCap"].value = "";
    document.getElementById("raidTypeDiv2").innerHTML  = '<bean:message key="info.off"/>';
    document.getElementById("usableCapDiv2").innerHTML = '<bean:message key="info.off"/>';
</logic:equal>
}
function openSelectPool(rvNumber){
    if (isSubmitted()){
        return false;
    }
    
    // get the Form object of poolSelectForm
    var poolSelectForm = document.rv0PoolSelectForm;
    if (rvNumber == 1) {
    	var poolSelectForm = document.rv1PoolSelectForm;
	} else if (rvNumber == 2) {
    	var poolSelectForm = document.rv2PoolSelectForm;
	}

    if (poolWin == null || poolWin.closed){
        poolWin = window.open("/nsadmin/common/commonblank.html", "ddr_selectPool", "width=700,height=650,resizable=yes,scrollbars=yes,status=yes");
    } else {
    	poolWin.focus();
    }
	
    // connect windows  variable to the variable of RV poolSelect
	window.aid = poolSelectForm.aid;
	window.raidType   = poolSelectForm.raidType;
	
    // get attribute of RV0|1|2
    var poolName = "rv" + rvNumber + "Info.poolName";
    var poolNo = "rv" + rvNumber + "Info.poolNo";
    var raidTypeDiv = "raidTypeDiv" + rvNumber;
    var usableCapDiv = "usableCapDiv" + rvNumber;
    
	// connect windows  variable to RV's info for display
	window.poolName = document.forms[0].elements[poolName];
	window.poolNo   = document.forms[0].elements[poolNo];
	window.raidTypeDiv   = document.getElementById(raidTypeDiv);
	window.usableCapDiv = document.getElementById(usableCapDiv);
    
    // set poolSelect's aid. RV's aid value = MV's aid  value
	poolSelectForm.aid.value = document.forms[0].elements["mvInfo.aid"].value;
    
    // set poolSelect's raidType by RV0|1|2's display
	var rvRaidType = document.getElementById(raidTypeDiv).innerHTML;
    if ((rvRaidType == "6(8+PQ)") || (rvRaidType == "--")) {
        poolSelectForm.raidType.value = "68";    
    } else if (rvRaidType == "6(4+PQ)") {
        poolSelectForm.raidType.value = "64"; 
    } else {
        poolSelectForm.raidType.value = rvRaidType; 
    }
    
    // get poolNo used by MV
	var unusablePoolNo = document.forms[0].elements["mvInfo.poolNo"].value;
 
	poolSelectForm.action="/nsadmin/volume/volumePoolSelect.do?from=ddrCreate&flag=notFromDisk&unusablePoolNo=" + unusablePoolNo;
	poolSelectForm.submit();
}

function isMvExist( selectedMvName ){
   selectedMvName = selectedMvName.replace(/^NV_LVM_/, "");
   var select = document.forms[0].elements["mvInfo.mvValue4Show"];
   for (var i = 0; i < select.options.length; i++){
       if ( selectedMvName == select.options[i].text){
           return true;
       }
   }
   return false;
}
</script>
