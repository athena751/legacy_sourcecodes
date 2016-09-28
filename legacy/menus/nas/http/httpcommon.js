<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpcommon.js,v 1.2302 2004/04/22 04:26:00 caoyh Exp" -->

<script src="../common/general.js"></script>
<script>

var invalidVirtualHostName="<nsgui:message key="nas_http/alert/invalid_virtualhost_name"/>";
var lackIPAddrs="<nsgui:message key="nas_http/alert/none_documentip"/>";
var lackServerName="<nsgui:message key="nas_http/alert/none_servername"/>";
var lackVirtualHostName="<nsgui:message key="nas_http/alert/none_virtualhostname"/>";
var invalidIPAddrs="<nsgui:message key="nas_http/alert/invalid_ipaddr" />";
var duplicatedIPAddrs="<nsgui:message key="nas_http/alert/duplicated_ipaddr" />";
var invalidPort="<nsgui:message key="nas_http/alert/invalid_port"/>";
var invalidDocumentRoot="<nsgui:message key="nas_http/alert/none_documentroot"/>";
var invalidServerName="<nsgui:message key="nas_http/alert/invalid_server_name"/>";
var invalidServerAdmin="<nsgui:message key="nas_http/alert/invalid_email" />";
var invalidUnixUserName="<nsgui:message key="nas_http/alert/invalid_user"/>";
var invalidUnixUserID="<nsgui:message key="nas_http/alert/invalid_user_id"/>";
var invalidTransferLocation="<nsgui:message key="nas_http/alert/invalid_transferlog_location"/>";
var invalidCustomFileName="<nsgui:message key="nas_http/alert/invalid_logfile_name"/>";
var invalidCustomFormat="<nsgui:message key="nas_http/alert/invalid_format"/>";
var invalidErrorLogLocation="<nsgui:message key="nas_http/alert/invalid_errorlog_location"/>";
var invalidPattern="<nsgui:message key="nas_http/alert/invalid_pattern"/>";
var invalidUserList="<nsgui:message key="nas_http/alert/invalid_user_list"/>";
var invalidNickName="<nsgui:message key="nas_http/alert/invalid_nick_name"/>";
var invalidAccessFileName="<nsgui:message key="nas_http/alert/invalid_access_file_name"/>";
var invalidGroupName="<nsgui:message key="nas_http/alert/invalid_group"/>";
var invalidGroupID="<nsgui:message key="nas_http/alert/invalid_group_id"/>";

function checkVirtualHostName(obj) {
    if (gInputTrim(obj.value) == "") {
        alert(lackVirtualHostName);
        obj.focus();
        return false;
    }
    if(!checkFQDN(gInputTrim(obj.value))) {
        alert(invalidVirtualHostName);
        obj.focus();
        return false;
    }
    return true;
}

function checkUsedIPAddrs(obj) {
    if (document.forms[0].usedIPAddrsMode[1].checked) {
        if(obj.length==0) {
            alert(lackIPAddrs);
            document.forms[0].IPAddrs.focus();
            return false;
        } else {
            var allip = obj.options[0].value;
            for(var i=1;i<obj.length;i++) {
                allip += " "+obj.options[i].value;
            }
        }
        document.forms[0].usedIPAddrs.value=allip;
        return true;
    }
    return true;
}

function checkIPAddrs(obj) {
    var ipport=gInputTrim(obj.value);
    var invalid=false;
    var strArray=ipport.split(":");
    var avail=/[^0-9]/g;

    if(strArray.length<1||strArray.length>2) {
        invalid=true;
    } else if(!checkIP(strArray[0])) {
        invalid=true;
    } else if (strArray.length==2){ 
        var portnumber = strArray[1];
        if(portnumber.search(avail)!=-1 
        	|| isNaN(parseInt(portnumber,10)) 
        	|| (parseInt(portnumber,10)!=0 && portnumber.substring(0,1) == "0")
        	|| parseInt(portnumber,10) < 0 
                || parseInt(portnumber,10) > 65535)
            invalid=true;
    }
    if (invalid == false) {
        for(var i=0; i<document.forms[0].IPAddrs.length; i++) {
            if (ipport == document.forms[0].IPAddrs.options[i].value) {
                alert(duplicatedIPAddrs);
                return false;
            }
        }
    }
    
    if (invalid) {
        alert(invalidIPAddrs);
        obj.focus();
        return false;
    } else {
        return true;
    }
}

function checkPort(obj) {
    var invalid = false;
    var port = gInputTrim(obj.value);
    var strArray=port.split(":");
    var addr;
    var portnum;
    var avail=/[^0-9]/g;

    if(port== "" || strArray.length<1 || strArray.length>2) {
        invalid = true;
    }else if(strArray.length==1) {
        portnum = strArray[0];
    }else if(strArray.length==2) {
        addr = strArray[0];
        portnum = strArray[1];
    }
    if (portnum.search(avail)!=-1 
	|| isNaN(parseInt(portnum,10)) 
	|| (parseInt(portnum,10)!=0 && portnum.substring(0,1) == "0")
	|| parseInt(portnum,10) < 0 
        || parseInt(portnum,10) > 65535){
        invalid = true;
    }
    if (strArray.length==2 && !checkIP(addr)) {
        invalid = true;
    }
    if (invalid) {
        alert(invalidPort)
        obj.focus();
        return false
    } else {
        return true;
    }
}

//set guard after the basic checkPort
//modified by zhangjx
function checkPortUse(usedPortAry, obj, from){
    var newPort = gInputTrim(obj.value);
    var strArray = newPort.split(":");
    var onlyPort;
    if(strArray.length==1
       && from == "basic"){
    	onlyPort = strArray[0];
    }else if (strArray.length==1
       && from == "virtual"){
       return true;
    }else{
    	onlyPort = strArray[1];
    }
    if (onlyPort=="8181" || onlyPort=="8282" 
        || onlyPort=="8484" || onlyPort=="8585"){
     	alert("<nsgui:message key="nas_http/alert/invalid_port_1"/>");   
     	obj.focus();
     	return false;
    }
    if (onlyPort < 1024 && onlyPort!=80){
    	alert("<nsgui:message key="nas_http/alert/invalid_port_2"/>");   
    	obj.focus();
     	return false;
    }
    if (onlyPort != 8080){
    	for (var i=0;i<usedPortAry.length;i++){
    		if (usedPortAry[i]==onlyPort){
    			alert("<nsgui:message key="nas_http/alert/port_been_used"/>");   
    			obj.focus();
     			return false;
    		}
    	}
    }
    return true;                       
}
//end

function checkDocumentRoot(obj) {
    if(gInputTrim(obj.value)== "") {
        alert(invalidDocumentRoot);
        document.forms[0].documentbrowse.focus();
        return false; 
    }else {
        return true;
    }
}

function checkServerName(obj){
    var server=gInputTrim(obj.value);
    if (server=="") {
        alert(lackServerName);
        obj.focus();
        return false; 
    } else {
        if(!checkFQDN(server)) {
            alert(invalidServerName);
            obj.focus();
            return false;
        } else {
            return true;
        }
    }
}

function checkNickName(obj){
    var nickName = gInputTrim(obj.value);
    if(!checkFQDN(nickName)) {
        alert(invalidNickName);
        obj.focus();
        return false;
    } else {
        return true;
    }
}

function checkServerAdmin(obj) {
    var email = gInputTrim(obj.value);
    if(email == "") return true;
    var pattern = /^[_\.0-9a-z-%]+\@([0-9a-z%][0-9a-z-%]*\.)+([0-9a-z%])+$/i;
    if(!email.match(pattern)) {
        alert(invalidServerAdmin);
        obj.focus();
        return false;
    }
    return true;
}

function checkUnixUserName(obj){
    if (!checkUserGroupName(obj)){
        alert(invalidUnixUserName);
        obj.focus();
        return false;
    }
    return true;
}

function checkUserGroupName(obj) {
    var name = gInputTrim(obj.value);
    if(name == "") {
        obj.value = "";
        return true;
    } else {
        name = obj.value;
        var firstChar = name.charAt(0);
        if(firstChar == "-" || firstChar == " ") {
            return false;
        }
        var avail = /[^ a-zA-Z0-9_-]/g;
        var ifFind = name.search(avail);
        if (ifFind != -1) {
            return false;
        }
        return true;
    }
}


function checkUserGroupID(obj) {
    var id = gInputTrim(obj.value);
    if(id == "") {
        return true; 
    } else {
        if(!checkDigit(id)) {

            return false;
        }
    return true;
    }
}
function checkUnixUserID(obj) {
    if(!checkUserGroupID(obj)){
            alert(invalidUnixUserID);
            obj.focus();   
            return false;     
    }
    return true;
}
function checkUnixGroupName(obj) {
    if (!checkUserGroupName(obj)){
        alert(invalidGroupName);
        obj.focus();
        return false;
    }
    return true;
}

function checkUnixGroupID(obj){
     if(!checkUserGroupID(obj)){
            alert(invalidGroupID);
            obj.focus();   
            return false;     
    }
    return true;
}

function checkWindowsUserName(obj){
    return checkUnixUserName(obj);
}

function checkWindowsGroupName(obj){
    return checkUnixGroupName(obj);
}

function checkTransferLocation(obj) {
    if(document.forms[0].transferLogMode[1].checked && obj.value=="") {
        alert(invalidTransferLocation);
        document.forms[0].transferbrowse.focus();
        return false;
    } else {
        return true;
    }
}

function checkCustomFileName(obj) {
    if(document.forms[0].customLogAllowed.checked && obj.value=="") {
        alert(invalidCustomFileName);
        document.forms[0].logfilebrowse.focus();
        return false;
    } else {
        return true;
    }
}

function checkCustomFormat(obj) {
    if(!document.forms[0].customLogAllowed.checked)
        return true;
    var format=gInputTrim(obj.value);
    var pattern = /[^0-9a-zA-Z-=~!@#`$%^&*()_+|\[\];'\/\.,\\{}:"<>?\ ]/g;
    if(format=="" || format.search(pattern) != -1) {
        alert(invalidCustomFormat);
        obj.focus();
        return false;
    } else {
        return true;
    }
}

function checkErrorLogLocation(obj) {
    if(document.forms[0].errorLogMode[1].checked && obj.value==""){
        alert(invalidErrorLogLocation);
        document.forms[0].errorbrowse.focus();
        return false;
    } else {
        return true;
    }
}

function checkPattern(obj) {
    if(!document.forms[0].userDirAllowed.checked) {
        return true;
    }
    if (gInputTrim(obj.value)==""){
        alert(invalidPattern);
        obj.focus();
        return false;   
    }
    var valid = /^[~ \.\-]|[^ 0-9a-zA-Z*_\/\-\.~]|\/\.|\/~|\/\-/g;
    var flag = gInputTrim(obj.value).search(valid);
    if(flag!=-1) {
        alert(invalidPattern);
        obj.focus();
        return false;
    } else {
        return true;
    }
}

function checkAccessFileName(obj) {
    var filename = obj.value;
    var valid = /[^0-9a-zA-Z_\-\.]/g;
    var flag = filename.search(valid);
    if(flag!=-1){
        alert(invalidAccessFileName);
        obj.focus();
        return false;
    }else{
        return true;
    }  
}

function checkUserList(obj) {
    if(!document.forms[0].userDirAllowed.checked
            || document.forms[0].userDirMode[0].checked) {
        return true;
    }
    if (gInputTrim(obj.value)==""){
        alert(invalidUserList);
        obj.focus();
        return false;
    }
    var list=gInputTrim(obj.value);
    if (list.length>65535) {
            alert(invalidUserList);
            obj.focus();
            return false;
    }  
    
    var list=obj.value;
    var inQuot = false;
    var tempUser = "";
    var userEnd = false;
    var isQuotUser = false;
    for(var i = 0; i < list.length; i++){
        if (inQuot){
            if (list.charAt(i) == "\""){
                if (i != list.length-1 && list.charAt(i+1) != " "){
                    alert(invalidUserList);
                    obj.focus();
                    return false;
                }
                userEnd = true;
                inQuot = false;
            }else{
                userEnd = false;
                tempUser = tempUser + list.charAt(i);
            }
            isQuotUser = true;
        }else{
            if (list.charAt(i) == "\""){
                if (i != 0 && list.charAt(i-1) != " "){
                    alert(invalidUserList);
                    obj.focus();
                    return false;
                }
            userEnd = false;
            tempUser = "";
            inQuot = true;
            }else if (list.charAt(i) == " "){
                userEnd = true;
            }else{
                userEnd = false;
                tempUser = tempUser + list.charAt(i);
            }
            isQuotUser = false;
        }
        if (i == list.length -1){
            userEnd = true;
        }
        if (userEnd){
            if (isQuotUser && (trim(tempUser) == "" 
                               || tempUser.charAt(0) == " ")){
                alert(invalidUserList);
                obj.focus();
                return false;
            }
            if (trim(tempUser) != "" && !checkUser(tempUser)){
                alert(invalidUserList);
                obj.focus();
                return false;
            }
            tempUser = "";
        }
    }
    if (inQuot){
        alert(invalidUserList);
        obj.focus();
        return false;
    }
    return true;

}

function checkUser(username){
    firstChar = username.charAt(0);
    if(firstChar == "-") {
        return false ;
    }
    if (username.length>32){
        return false;
    }
    var avail = /[^a-zA-Z0-9_ -]/g;
    var ifFind = username.search(avail);
    if (ifFind != -1) {
        return false;
    }
    return true;
}
</script>           