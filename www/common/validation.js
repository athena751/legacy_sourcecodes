/*
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: validation.js,v 1.15 2005/12/28 11:49:13 jiangfx Exp $"
*/

function checkCapacity(str, flag){
    var reg=/^\d+(\.\d)?$/g;
    if (flag) {
	    if ((str == null) 
	         || (str == "") 
	         || (str.charAt(0) == '0')) {
	        return false;
	    }
       reg=/^\d+$/g;
    }
    return (str.search(reg) != -1);
}

function chkEveryLevel(str){
    var tmpArray=new Array();
    var reg=/\//g;
    tmpArray=str.split(reg);
    for(var index=0; index<tmpArray.length; index++){
        if (tmpArray[index].length>255){
            return false;
        }
    }
    return true;
}

function checkVolumeName(str) {
    if (str == "")
        return false;
    var avail = /[^A-Za-z0-9_-]/g;
    ifFind = str.search(avail);
    return(ifFind==-1);
}

function checkMountPointName(str){
    if (str == null || str == ""){
        return false;
    }
    var valid = /^[~\.\-]|[^0-9a-zA-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
    var flag=str.search(valid);
    if(flag==-1){
        return true;
    }else{
        return false;
    }  
 }

function compactPath(str){
    var regExp = /\/+/g;
    str = str.replace(regExp,"/");
    if(str.charAt(str.length-1)=="/"){
        str = str.substring(0,str.length-1);
    }
    return str;
}

function checkLength(str, maxlen) {
    str = str.replace(/[^\x00-\x7f]/g, "  ");
    return (str.length <= maxlen);
}

function checkComment(str){
    if(str == ""){
        return true;
    }
    var avail=/[\"]/g;
    var ifFind = str.search(avail);
    return (ifFind==-1);
}

function checkUsers(str){
    if(str == ""){
        return true;
    }
    var avail=/[^A-Za-z0-9 @+&_,\"-]/g;
    var ifFind = str.search(avail);
    return(ifFind==-1);
}

function checkHosts(str){
    if(str == ""){
        return true;
    }
    var ipList=new Array();
    var reg=/[\s]+/g;
    ipList=str.split(reg);
    for(var index=0; index<ipList.length; index++){
        if (ipList[index]==""){
        }else if ( ipList[index].indexOf("/")==-1 ){
            if (!checkIP(ipList[index]) ){
                return false;
            }
        }else{
            if(checkIPMask(ipList[index])){
                //ipList[index] like: 172.28.11.112/12 or 172.28.11.112/255.255.255.0
                if(ipList[index].search(/\/[\d]+\./g)==-1){
                    //ipList[index] like: 172.28.11.112/12
                    return false;
                }
            }else{
                return false;
            }
        }
    }
    return true;
}

function checkIP(str){  
    var ipModel=/^([\d]{1,3})\.([\d]{1,3})\.([\d]{1,3})\.([\d]{1,3})$/;
    var IPArray=str.match(ipModel);
    if (IPArray==null){
        return false;
    }
    for (var i=1;i<=4;i++){
        if (IPArray[i]>255){
            return false;
        }
        if (IPArray[i].length!=1 && IPArray[i].indexOf(0) == 0){
            return false;
        }
    }
    if(IPArray[1]>223){
        return false;
    }
    return true;
}

function checkIPMask(str){
    var indexEq = str.indexOf("/");
    if (indexEq < 1){
        return false;
    }
    var ip = str.substring(0,indexEq);
    var mask = str.substring(indexEq+1);
    if (!checkIP(ip)){
        return false;
    }else if(!checkAllMask(mask)) {
        return false;
    }else {
        return true;
    }
}

function checkAllMask(netmask){
    netmask = trim(netmask);
    if (netmask==""){
        return false;
    }
    var avail = /[^0-9]/g;
    ifFind = netmask.search(avail);
    if (ifFind == -1){
        if (netmask<0 || netmask>32){
            return false;
        }else if (netmask!=0 && netmask.charAt(0)=='0'){
            return false;
        }
    }else {
        switch (netmask){
        case "255.255.255.255":
        case "255.255.255.0":
        case "255.255.0.0":
        case "255.0.0.0":
        case "0.0.0.0":
        case "255.255.255.254":
        case "255.255.255.252":
        case "255.255.255.248":
        case "255.255.255.240":
        case "255.255.255.224":
        case "255.255.255.192":
        case "255.255.255.128":
        case "255.255.254.0":
        case "255.255.252.0":
        case "255.255.248.0":
        case "255.255.240.0":
        case "255.255.224.0":
        case "255.255.192.0":
        case "255.255.128.0":
        case "255.254.0.0":
        case "255.252.0.0":
        case "255.248.0.0":
        case "255.240.0.0":
        case "255.224.0.0":
        case "255.192.0.0":
        case "255.128.0.0":
        case "254.0.0.0":
        case "252.0.0.0":
        case "248.0.0.0":
        case "240.0.0.0":
        case "224.0.0.0":
        case "192.0.0.0":
        case "128.0.0.0":
            return true;
        default:
            return false;
        }
    }
    return true;
}

function checkIPMatchMask(str){
    var indexOfMask = str.indexOf("/");
    var ipString    = str.substring(0,indexOfMask);
    var maskString  = str.substring(indexOfMask+1);
    
    var maskNo = 0;
    ifFind = maskString.search(/[^0-9]/g);
    if (ifFind == -1){
        maskNo = maskString;
    }else{
        var maskArray = maskString.split('.');
        for (var index=0 ; index<maskArray.length; index++) {
            var $tmpbitnum = 0;
            while(maskArray[index] >=1){
                if( maskArray[index]%2 == 1 ){
                    $tmpbitnum ++;
                }
                maskArray[index] = maskArray[index] >> 1;
            }
            maskNo += $tmpbitnum;
        }
    }
    var ipArray = ipString.split('.');
    var binaryIp = "";
    for (var index=ipArray.length-1; index>=0; index--) {
        for(var indexB=0;indexB<8;indexB++ ){
            if( ipArray[index]%2 == 1 ){
                binaryIp = '1'+binaryIp;
            }else{
                binaryIp = '0'+binaryIp;
            }
            ipArray[index] = ipArray[index] >> 1;
        }
    }
    if( (binaryIp.search(/[^0]/) == -1)&&(maskNo==0) ){
        return false;
    }
    var tailBinaryIp = binaryIp.substring(maskNo);
    ifMatch = tailBinaryIp.search(/[^0]/);
    if(ifMatch==-1){
        return true;
    }else{
        return false;
    }
}


function checkPath4Win(str){
    var invalidChar = /[\\:,;\*\?\"<>|]/g;
    return ( str.search(invalidChar) == -1);
}

/*********** check hostname *********************/
function checkExportsTo(str){
    if( str=="" ){
        return false;
    }
    var badhead = /[^@*A-Za-z0-9_]/g;
    ifFind = (str.charAt(0)).search(badhead);
    if(ifFind!=-1){
        return false;
    }
    if(str.length > 128){
        return false;
    }
    if (str.charAt(0) == "@"){
        if(!checkFQDN(str.substring(1))){
            return false;
        }
    }
    str = str.substring(1);
    var invalid = /[^*A-Za-z0-9.\/_-]/g;
    ifFind = str.search(invalid);
    if(ifFind==-1){
        return true;
    }else{
        return false;
    }
}

function checkID(str){
    if(str==""||str=="-"||parseInt(str)=="0"){
        return false;
    }
    var avail = /[^0-9-]/g;
    ifFind = str.search(avail);
    if(ifFind==-1){
        if( str>=-32768 && str<=32767 )
            return true;
    }
    return false;
}

function checkFQDN(hostName){
     if ( hostName =="" ){
         return false;
     }
     if( hostName.charAt(0) == "-" ){
         return false;
     }
     if( hostName.charAt(0) == "." ){
         return false;
     }
     if ( hostName.length >255 ){
         return false;
     }    

     var invalid = /[^A-Za-z0-9.-]/g;
     var ifFind = hostName.search(invalid);
     return (ifFind == -1); 
}
/****************************************************/
/**
 * check the whether the string is a digit between min and max
**/
function isValidDigit(str, min, max){
    str = trim(str);
	if(str == ""){
        return false;
    }
    var avail = /[^0-9-]/g;
    if(str.search(avail) != -1){
    	return false;
    }
    if(str >= min && str <= max){
		return true;
	}
	return false;
}

function isValidExportPoint(str){
    if ( str == "" ){
        return false;
    }
    if ( str.charAt(0) != '/' ){
        return false;
    }
    if ( !checkLength(str, 1023) ){
        return false;
    }    
    var dirs = str.split('/');
    for(var i = 0; i < dirs.length; i++){
    	if(!checkLength(dirs[i] , 255)){
    	    return false;
    	}
    }
    return true; 
}

function checkNISDomain(hostName){
    if ( hostName =="" ){
         return false;
     }
     if( hostName.charAt(0) == "-" ){
         return false;
     }
     if( hostName.charAt(0) == "." ){
         return false;
     }
     if( hostName.length > 64 ){
     	return false;
     }
     var invalid = /[^A-Za-z0-9_.-]/g;
     var ifFind = hostName.search(invalid);
     return (ifFind == -1); 
}

/*	is valid	*/
function isValid(str,invalidCharSet, maxlen,minlen){
    if(str.search(invalidCharSet) != -1)
    {   
        return false;
    }
    else if(str.length > maxlen){
        return false;
    }else if(str.length < minlen){
        return false;
    }    
    return true;
}
/* g inputtrim*/
	/**
 *  function:
 *  parameter: 
 *  return: 
 *  example: 
 *  modified: by wangw, 2003/7/28
 */
function gInputTrim(name){ 
    return gRTrim(name); 
} 
/**
 *  function: rid blanks at end.
 *  parameter: the string which want triming;
 *  return: the string has been trimed.
 *  example: var trimedStr = trim(str);
 *  modified: by wangw, 2003/7/28
 */
function gRTrim(name){ 
    var whitespace = new String(" \t\n\r");
    var s = new String(name);
    var i = s.length - 1;       
    while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
         i--;
    s = s.substring(0, i+1);
    return s;
}

/* is print*/
function isPrint(str) {
    return (str.search(/[^\x20-\x7e]/) == -1);
}


function maskIsConsWithIP(netmask , IP) {
	var str1=IP;
	var str2=netmask;
	var ipModel=/^([\d]{1,3})\.([\d]{1,3})\.([\d]{1,3})\.([\d]{1,3})$/;
	var IPArray=str1.match(ipModel);
	var intMask = mask2int(netmask);
	var netmaskArray=str2.match(ipModel);
	if (IPArray[1]>191 &&  intMask < 24
        || IPArray[1] > 127 && intMask < 16
        || IPArray[1] <= 127 && intMask < 8 ){
    	return false;
	}
	return true;
}
