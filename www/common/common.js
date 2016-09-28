/*
#
#       Copyright (c) 2001-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: common.js,v 1.39 2009/02/11 03:06:42 wanghui Exp $"
*/

/************* double submit check ***************/
var common_submitRecord = false;

function setSubmitted(){
    common_submitRecord = true; 
}

function unsetSubmitted(){
    common_submitRecord = false;
}

function isSubmitted(){
    return common_submitRecord;
}
/*************************************************/

function isIE(){
    if (navigator.appName.indexOf("Netscape") != -1){
        return false;
    }
    return true;
}
/********************set Help url*****************************/

function setHelpAnchor(help){
    var parentWin = top;
    while(!parentWin.MENU 
        && parentWin.opener
        && !parentWin.opener.closed){
        parentWin = parentWin.opener.top;
    }
    if(!parentWin.MENU || !parentWin.MENU.curForm){
        return;
    }
    var myForm = parentWin.MENU.curForm;
    myForm.helpAnchor.value = "/help.html#"+help;
}

function lockMenu(){
    var winTop;
    if(top.TITLE){
        winTop = top;
    } else {
        winTop = opener.top;
    }
    
    if ( winTop.TITLE.menuLock == 1 ) {
        return;
    }
    
	winTop.TITLE.menuLock = 1;
	if(!winTop.CONTROLL.document
        ||!winTop.CONTROLL.document.forms[0]){
        return;
    }
	winTop.TITLE.exportGroup = winTop.CONTROLL.document.forms[0].exportGroup.disabled;
	winTop.CONTROLL.document.forms[0].exportGroup.disabled = true;
	if(winTop.CONTROLL.document.forms[0].changeNode){
		winTop.TITLE.changeNode = winTop.CONTROLL.document.forms[0].changeNode.disabled;
		winTop.CONTROLL.document.forms[0].changeNode.disabled = true;
	}
}

function unLockMenu(){
    var winTop;
    if(top.TITLE){
        winTop = top;
    } else {
        winTop = opener.top;
    }
    
    if ( winTop.TITLE.menuLock == 0 ) {
        return;
    }
    
	winTop.TITLE.menuLock = 0;
	if(!winTop.CONTROLL.document
        ||!winTop.CONTROLL.document.forms[0]){
        return;
    }
	winTop.CONTROLL.document.forms[0].exportGroup.disabled = winTop.TITLE.exportGroup;
	if(winTop.CONTROLL.document.forms[0].changeNode){
		winTop.CONTROLL.document.forms[0].changeNode.disabled = winTop.TITLE.changeNode;
	}
}
function isMenuLocked(){
	return top.TITLE.menuLock;
}

/*
set the target value, and submit the form to specified ACTION window
*/
function selectModule(formName){
    if(isMenuLocked()){
    	return;
    }
	if(!top.MENU.document 
		|| !top.MENU.document.forms[formName]){
		return;
	}
    var myForm = top.MENU.document.forms[formName];
    if(myForm.hasLicense.value == "false"){
        return;
    }
    if(!top.CONTROLL.document
        ||!top.CONTROLL.document.forms[0]){
        return;
    }
    
    //get the values from CONTROLL window
    var target = top.CONTROLL.document.forms[0].elements["nodeInfo.target"].value;
    var adminTarget = top.CONTROLL.document.forms[0].elements["nodeInfo.adminTarget"].value;
    var group = top.CONTROLL.document.forms[0].elements["nodeInfo.group"].value;
    //when target is null and the selected item is relationship to target.
    //then return.
    if(target == "" && myForm.target.value ==""){
    	return;
    }
    top.MENU.curForm = myForm;
    setControlStatus();
    top.TITLE.exportGroup = top.CONTROLL.document.forms[0].exportGroup.disabled;
    if(top.CONTROLL.document.forms[0].changeNode){
		top.TITLE.changeNode = top.CONTROLL.document.forms[0].changeNode.disabled;
	}
    //when target is localhost, it means that 
    //the selected item is independence from target
    var machineType = top.CONTROLL.document.forms[0].machineType.value;
    //when machine is OneNodeSirius and It is on node1 and the selected
    //item is only active on node0.
    //jump back to node0
    if(machineType == "OneNodeSirius"
      && myForm.changeNode.value == "disable"
      && group == "1"){
    	 top.CONTROLL.document.forms[0].operation.value = "changeNode";
    	 top.CONTROLL.document.forms[0].submit();
    	 return;
    }

    //when target is localhost, it means that 
    //the selected item is independence from target
    if (myForm.target.value!="localhost"){
    	//when machine type is not single, judge the target type
    	//is administrate target or not, set the relevant value
    	//into target
	    if(machineType.toLowerCase() != "single" && machineType.toLowerCase() != "nasheadsingle"){
	        if(myForm.targetType.value == "adminTarget"){
	            myForm.target.value=adminTarget;
	        }else{
	            myForm.target.value=target;
	        }
	    }else{//when machine type is single.
	        myForm.target.value=target;
	    }
    }
    if(myForm.group){
	    myForm.group.value= group;
	}
    //target is "" means the node is not registed.
    var actionUrl = myForm.action;
    //action is end of "#", means the select Item is a new module that
    //not yet is realized.
    if(actionUrl.charAt(actionUrl.length-1) == "#"){
        return;
    }
    
    //if the selected Item is relationship with exportroot
    //and the exportroot is null, then forward to creating exportroot page.
	var exportroot = top.CONTROLL.document.forms[0].exportGroup.options[top.CONTROLL.document.forms[0].exportGroup.selectedIndex].value;
	if(exportroot == "" && myForm.selectExpgrp.value.toLowerCase() != "disable"){
		top.ACTION.location="/nsadmin/framework/forwardExport.do?itemNameKey="+myForm.itemNameKey.value;
		return;
	}
	var forwardForm = top.MENU.document.forwardForm;
	if(myForm.h1 != null){
		forwardForm.h1.value = myForm.h1.value;
	}else{
		forwardForm.h1.value = "";
	}
	if(myForm.h2 != null){
		forwardForm.h2.value = myForm.h2.value;
	}else{
		forwardForm.h2.value = "";
	}
	if(myForm.bundle != null){
		forwardForm.bundle.value = myForm.bundle.value;
	}else{
		forwardForm.bundle.value = "";
	}
	if(myForm.msgKey != null){
		forwardForm.msgKey.value = myForm.msgKey.value;
	}else{
		forwardForm.msgKey.value = "";
	}
	if(myForm.selectExpgrp != null){
		forwardForm.selectExpgrp.value = myForm.selectExpgrp.value;
	}else{
		forwardForm.selectExpgrp.value = "";
	}
	forwardForm.submit();
    //myForm.submit();
}

function setNodeButtonStatus(flag){
    if(top.CONTROLL.document 
        &&top.CONTROLL.document.forms[0]
        &&top.CONTROLL.document.forms[0].changeNode){
        top.CONTROLL.document.forms[0].changeNode.disabled = (flag=="disable");
    }
}
function setControlStatus(){
    if(!top.MENU.document){
		return;
	}
    if(!top.CONTROLL.document
        ||!top.CONTROLL.document.forms[0]){
        return;
    }
    var exportrootSelectbox = top.CONTROLL.document.forms[0].exportGroup;
    if(top.CONTROLL.document.forms[0].elements["nodeInfo.target"].value == ""){
        exportrootSelectbox.disabled = true;
        setNodeButtonStatus("disable");
        return;
    }

    var myForm = top.MENU.curForm;
    if(myForm == null){
        var name = top.MENU.curCategory;
        setNodeButtonStatus("enable");
        if(name == null || name == ""){
            name = "cateDiv0";
        }
        if(name=="cateDiv0"){
            exportrootSelectbox.disabled = true;
        }
        if(name=="cateDiv1"){
            exportrootSelectbox.disabled = false;
        }
        if(name=="cateDiv2"){
            exportrootSelectbox.disabled = true;
        }
    }else{
        if(myForm.changeNode.value.toLowerCase() == "disable"){
            setNodeButtonStatus("disable");
        }else {
            setNodeButtonStatus("enable"); 
        }
        if(myForm.selectExpgrp.value.toLowerCase() == "disable"){
            exportrootSelectbox.disabled = true;
        }else{
            exportrootSelectbox.disabled = false;
        }
    }

}

function showIt(name){
    if (document.getElementById){ 
    // Type 1: IE5,6; NN6; Mozilla
        if (name){
            document.getElementById(name).style.display='inline';
        }
        return true; 
    }
}

function hideIt(name){
    if (document.getElementById){ 
        // Type 1: IE5,6; NN6; Mozilla
        if (name){
            document.getElementById(name).style.display='none';
        }
        return true; 
    } 
}

function refreshControllerFrame(exportGroup){  
    top.CONTROLL.document.forms[0].operation.value = "refresh";
    top.CONTROLL.document.forms[0].exportGroup.disabled = false;
    var length = top.CONTROLL.document.forms[0].exportGroup.length;
    top.CONTROLL.document.forms[0].exportGroup.length = length + 1;
    top.CONTROLL.document.forms[0].exportGroup.options[length].value= exportGroup;
    top.CONTROLL.document.forms[0].exportGroup.options[length].text= exportGroup;
    top.CONTROLL.document.forms[0].exportGroup.value = exportGroup;
    top.CONTROLL.document.forms[0].submit();
}

function openHeartBeatWin(){
    var date = new Date();
    var starttime = date.getTime();
    var tmpWin = window.open("/nsadmin/menu/common/heartbeat.jsp?frameNo=0&starttime="+starttime,
                "heartbeat",
                "resizable=no,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=400,height=150");
    return tmpWin;
}

function closePopupWin(win){
    if (win != null && !win.closed){
        win.close();
    }
}

function trim(name){ 
    var pos1, pos2; 
    pos1 = 0; 
    pos2 = name.length - 1; 
    if ( name.length > 0 ) 
    { 
        for(; pos1<name.length; pos1++) 
        { 
            if ( name.charAt(pos1) != " " && name.charAt(pos1) != "\t" 
                    && name.charAt(pos1) != "\r") {
                break;  
            }
        }
        if (pos1 == name.length){
            return "";
        }
        for( ; pos2>=0 ; pos2--) 
        { 
            if ( name.charAt(pos2) != " " && name.charAt(pos2) != "\t"
                    && name.charAt(pos2) != "\r") {
                break;  
            }
        }
        return name.substring(pos1, pos2+1) ;
    } 
    return ""; 

} 

function getCheckedRadioValue(radioObject){
    if(radioObject.length){
        for(var i = 0; i < radioObject.length; i++){
            if(radioObject[i].checked){
                return radioObject[i].value;
            }
        }
        return "";
    }else{
        if(radioObject.checked){
            return radioObject.value;
        }else{
            return "";
        }
    }
}

function getRealPath(str){
    return deleteMutipleSlash(trim(str));
}

function getRealVirtualPath(str){
    str = deleteMutipleSlash(leftTrim(str));
    if(str != null && str != "" && str != '/' && str.charAt(str.length-1) == '/'){
        str = str.substring(0,str.length-1);
    }
    return str;
}
//added for the modification of exportpoint of nasswitch 
function leftTrim(str){
    return str.replace(/^\s+/,"");
}

function deleteMutipleSlash(str){
    if(str == "" || str.search(/\//g) == -1){
        return str;
    }
    var sArray = str.split(/\//);
    var rArray = new Array();
    var rStr = '';
    for(var i = 0; i < sArray.length; i++){
        if(sArray[i] == '..'){
            if(rArray.length != 0){
                rArray.pop();
            }
        }else if(sArray[i] == '.' || sArray[i] == ''){
            //do nothing
        }else{
            rArray.push(sArray[i]);
        }
    }   
    rStr = rArray.join('/');
    if(str.charAt(str.length-1) == '/'){
        rStr = rStr + '/';
    }
    if(str.charAt(0) == '/' && rStr != '/'){
        rStr = '/' + rStr;
    }
    return rStr;
}

function mask2int(mask){
    if(mask=="") return -1; 
    if(mask.match(/\.\./) || mask.substr(mask.length-1,1)=="." 
           || mask.substr(0,1)=="." ){
        return -1;
    }
    var num = mask.split(".");
    var i = 0;
    if(num.length != 4){
        return -1;
    }
    for (var j=0; j<num.length; j++){
        if (isNaN(num[j]) || num[j] < 0 || num[j] > 255){
            return -1;
        }
        var tmp = Math.round(Math.log(256 - num[j])/Math.log(2));
        if (Math.pow(2,tmp) != (256 - num[j])){
            return -1;
        }
        if(tmp > 0){
            for(var k = j+1; k < num.length; k++){
                if (num[k] > 0) {
                    return -1;
                }
            }
        }
        i += 8 - tmp;
    }
    return i;
 }
 
function int2mask(i){
    if (isNaN(i)){
        return "";
    }
    if (i < 0 || i > 32){
        return "";
    }
    var mask="";
    for (var j = 0; j < 4; j++){  
        var tmp = i > 8 ? 8:i;      
        if (tmp >= 0){
            mask = mask + "." + (256 - Math.pow(2, 8 - tmp));
        }else{
            mask = mask + ".0";
        }
        i = i- 8;
    }
    return mask.substr(1,mask.length);
 }
 
 function getMaskFromIP(str){
    var arr = new Array();
    arr = str.split(".");
    if(arr.length != 4){
        return "";
    }
    if(arr[0] > 223 ){
        return "";
    }else if(arr[0] > 191 ){
        return "255.255.255.0";
    }else if(arr[0] > 127){
        return "255.255.0.0";
    }else{
        return "255.0.0.0";
    }
}

 function getNetwork(network,netmask){
    var networkArray = network.split(".");
    var netmaskArray = netmask.split(".");
    if(networkArray.length != 4 || netmaskArray.length !=4 ){
        return "";
    }
    for (var i=0; i<4; i++){
        networkArray[i] = networkArray[i] & netmaskArray[i];
    }
    return networkArray.join(".");
 }