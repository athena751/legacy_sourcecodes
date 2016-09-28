/**
 *
 *       Copyright (c) 2001-2007 NEC Corporation
 *
 *       NEC SOURCE CODE PROPRIETARY
 *
 *       Use, duplication and disclosure subject to a source code
 *       license agreement with NEC Corporation.
 *       "@(#) $Id: general.js,v 1.2314 2007/08/23 04:15:01 liul Exp $"
 */

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
/**
 *  function: rid blanks at begin and end.
 *  parameter: the string which want triming;
 *  return: the string has been trimed.
 *  example: var trimedStr = trim(str);
 *  modified: by liuyun, 2002/6/24
 */
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
/*
 *  if NetsCape4.76 surport '$' as string end, can use the line like this:
 *      return name.replace(/(^\s*)|(\s*$)/g, "");
 *  to do this function.
 */
} 

/**
 *  function: rid blanks in the line.
 *  parameter: the string which want triming;
 *  return: the string has been trimed.
 *  example: var trimedStr = trimall(str);
 *  modified: by liuyun, 2002/6/24
 */
function trimall(str){
    return str.replace(/(\s*)/g,"");
}

/**
 *  function: check if user ID is valid.
 *  parameter: 
 *  return: 
 *  example: 
 */
function checkUID(str){
  //str=trim(str);  
  if(str==""||str=="-"||parseInt(str)=="0"){
     return false;
  }
  var avail = /[^0-9]/g;
  var find;
  for(var ii=0;ii<str.length;ii++)
  {
    find=str.charAt(ii).search(avail);    
    if(find!=-1)
    {
      if(ii==0&&str.charAt(ii)=="-")
      {        
      }
      else
      {
        return false;
      }
    }
    else
    {
    }
  }
  return true;
}

/**
 *  Function: check if one of the user name is "root";
 *  Parameter: the string need checking.
 *  return: if string has root, return false; else return true;
 *  example: if str = "aa root bb", checkRoot(str) == false;
 *  modified: by liuyun, 2002/6/24
 */
function checkRoot(str){
    var strArray = str.split(" ");
    for (var i = 0; i < strArray.length; i++) {
        if (strArray[i] == "root") {
            return false;
        }
    }
    strArray = str.split(",");
    for (var i = 0; i < strArray.length; i++) {
        if (strArray[i] == "root") {
            return false;
        }
    }
    return true;
}

/**
 *  Function: check if the string is a valid user name;
 *  Parameter: the string need checking.
 *  return: if string is a valid user name, return true; else return false;
 *  example: if str = "nsadmin", checkUserName(str) == true;
 *  modified: by liuyun, 2002/6/24
 */
function checkUserName(str){
    //str = trim(str);
    if(str==""){
        return false;
    }
    var firstChar = str.charAt(0);
    var num = /[0-9\-]/;
    var ifFind = firstChar.search(num);
    if ( ifFind == 0){
        return false;
    }
    // the valid characters of the user name.
    var avail = /[^a-zA-Z0-9_-]/g;
    ifFind = str.search(avail);
    return(ifFind==-1);
}

/**
 *  Function: check if the string is several valid user name;
 *  Parameter: the string need checking.
 *  return: if string is valid user names, return true; else return false;
 *  example: if str = "@nsadmins", checkUsers(str) == true;
 *  modified: by liuyun, 2002/6/24
 */
function checkUsers(str){
  //str = trim(str);

    // the valid characters of the user name. 
    // and " " used to split several users, 
    // and "@" used to refer a group.
    var avail=/[^A-Za-z0-9 @+&_,\"-]/g;
    var ifFind = str.search(avail);
    return(ifFind==-1);
}

/**
 *  Function: check if the string is several valid host name;
 *  Parameter: the string need checking.
 *  return: if string is valid host names, return true; else return false;
 *  example: if str = "violet" or "192.168.1.115" or "192.168.1.117/255.255.0.0",
 *          checkHosts(str) == true;
 *  modified: by liuyun, 2002/6/24
 */
function checkHosts(str){
    var ipList=new Array();
    var reg=/[\s]+/g;
    ipList=str.split(reg);
    for(var index=0; index<ipList.length; index++){
        if (ipList[index]==""){
        }else if ( ipList[index].indexOf("/")==-1 ){
            if (!checkIP(ipList[index]) ){
                return false;
            }
        }else if (!checkIPMask(ipList[index])){
            return false;
        }
    }
    return true;
}

function checkDomain(str){
    //str = trim(str);
    var avail=/[^A-Za-z0-9_\-]/g; 
    var reg = ".";
    var aa = new Array();    
    aa = str.split(reg);
    
    if ( (str.length>0)&&( str.charAt(0) == "-" )){
         return false;
     }
  
    for(var i=0;i<aa.length;i++){      
        if( (aa[i]=="") || (aa[i].search(avail)!=-1) ){
            return false;
        }
    }
    return true;
}

function checkDigit(str)
{
    if (str == "")
        return false;
    var avail = /[^0-9]/g;
    var ifFind = str.search(avail);
    return(ifFind==-1);
}

/**
 *Add by xinghui, lican on 2002/11/20
 */
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

// checkNISName() is similar as checkFQDN() except it doesn't check hostName.length
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
     
     var invalid = /[^A-Za-z0-9_.-]/g;
     var ifFind = hostName.search(invalid);
     return (ifFind == -1); 
}

function checkNTDomain(hostName){
     if ( hostName =="" ){
         return false;
     }
     if( hostName.charAt(0) == "-" ){
         return false;
     } 
     if( hostName.charAt(0) == "." ){
         return false;
     }  
     if ( hostName.length >15 ){
         return false;
     }    

     var invalid = /[^A-Za-z0-9_\-\.]/g;
     var ifFind = hostName.search(invalid);
     return (ifFind == -1);
}

function checkNTDomainwithnode(hostName){
     var invalid = /\./g;
     if(hostName.search(invalid)!=-1){
         return false;
     }
     return true;
}

//------------------------------------------------------
function checkServer(str){
    return checkDomain(str);
}

function checkFSetClient(value){
    if(value==""){
      return false;
    }
    var invalidCharSet  = /[^A-Za-z0-9.@*\/\s_-]/g;
    if(value.search(invalidCharSet)!=-1){
        return false;
    }
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
    if(IPArray[1]>224){
        return false;
    }
    return true;
}

function showIt(name){
    if (document.getElementById){ 
    // Type 1: IE5,6; NN6; Mozilla
        if (name){
            document.getElementById(name).style.visibility='visible';
        }
        return true; 
    }

    if(document.layers){
    //Type 2: NN4
        if (name){
            document.layers[name].visibility='show';
        }
        return true;
    }
}

function hideIt(name){
    if (document.getElementById){ 
        // Type 1: IE5,6; NN6; Mozilla
        if (name){
            document.getElementById(name).style.visibility='hidden';
        }
        return true; 
    } 
    if (document.layers){
        //Type 2: NN4
        if (name){
            document.layers[name].visibility='hide'; 
        }
        return true; 
    }
}

function portFailoverGetTR(a,b,noneIP,noneMask){
    var resultString = "";
    var reg = /,/g
    var aa = new Array();
    var bb = new Array();
    aa = a.split(reg);
    bb = b.split(reg);
    for(var i=0;i<aa.length;i++){
        var tmpIP = aa[i];
        var tmpMask = bb[i];
        if(aa[i]=="-"){
            tmpIP = noneIP;
        }
        if(bb[i]=="-"){
            tmpMask = noneMask;
        }
        resultString = resultString+"<tr><td>"+tmpIP+"</td><td>"+tmpMask+"</td></tr>";
    }
    return resultString;
}

function URLEncoder(value)
{
    value=String(value);
    var result="";
    var ch;
    var avail = /[^A-Za-z0-9*-._]/g;
    for( var i=0;i<value.length;i++ ){
        ch=value.charAt(i);
        if (ch==' '){                                                                 
              result+='+';
        }else if( ch.search(avail)==-1 ){
              result+=ch;
        }else{
              if(ch=='@'){
                result+="%40";
              }else{
                result+=escape(ch);
              }            
        }
    }
    //alert(escape(value)+"\n"+result);    
    return result;    
}

function browserInfo(){
  var operation,browser,version;

  /*if (navigator.appVersion.indexOf("Windows") != -1)
          operation="W";*/
  if (navigator.appVersion.indexOf("Linux") != -1){
          operation="L";  
  }else{
          operation="W";
  }

  if (navigator.appName.indexOf("Microsoft") != -1)
          browser="IE";
  if (navigator.appName.indexOf("Netscape") != -1)
          browser="NS";  

  version = parseInt(navigator.appVersion) > 4 ? "6" : "4" ;
  
  if(browser=="IE"){
    return browser;
  }
  else{
    return operation + browser + version;
  }
  /*
  four types:
  "IE"
  "WNS6"
  "WNS4"
  "LNS4"
  */
}

/** when the window be resized in netscape 4, reload the page*/
function resize(){
    var info = browserInfo();
    if( info == "WNS4" || info == "LNS4" ){
        location.reload();
    }
}

function checkWindowsUserName(str){
    if(str==""){
        return false;
    }
    
    if( str.charAt(0) == "-" ){
         return false;
     }

    var validstr ="abcdefghijklmnopqrstuvwxyz0123456789~`!@#$%^&()_-\"\'.{} ";
    var i,j;
    for(i=0; i<str.length; i++) {
        for(j=0; j<validstr.length; j++) {
            if( str.charAt(i).toLowerCase()==validstr.charAt(j) ){
                break;
            }
        }
        if(j >= validstr.length){
            return false;
        }
    }
    return true;
}

function checkLength(str, maxlen) {
    str = str.replace(/[^\x00-\x7f]/g, "  ");
    return (str.length <= maxlen);
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

/*
    this file should be embeded in general.js
    using by nshtml taglib to disable the radio and submit.
*/

function submitDisable(thisPoint)
{
    if(!thisPoint.html_taglib_submit_name){
        return true;
    }else if(thisPoint.html_taglib_submit_name.length){
        for(var i=0;i<thisPoint.html_taglib_submit_name.length;i++){
            var obj=eval('thisPoint.'+thisPoint.html_taglib_submit_name[i].value);
            if(obj.length) {
                for(var j=0;j<obj.length;j++){
                    if(!obj[j].disabled) {
                        return true;
                    }
                }
            }else if(!obj.disabled){
                return true;
            }
        }
        return false;
    }else if(eval('thisPoint.'+thisPoint.html_taglib_submit_name.value
            +'.disabled')==false){
        return true;
    }else{
        return false;
    }
}

function radioClickDisable(formName,thisPoint){
    obj=eval('document.'+formName+'.'+thisPoint.name);

    if(thisPoint.disabled){

        if(obj.length==undefined){
            obj.checked=obj.checked_status;
        }else{
            for(var i=0;i<obj.length;i++){
                if(thisPoint.checked_status!=undefined){
                    obj[i].checked=obj[i].checked_status;
                }
            }
        }

        if(browserInfo()=='LNS4') {
            return false;
        } else {
            return true;
        }
    }
}

function radioRecordStatus(formName,thisPoint){
    obj=eval('document.'+formName+'.'+thisPoint.name);

    if(obj.length==undefined){
        obj.checked_status=obj.checked;
    }else{
        for(var i=0;i<obj.length;i++){
            obj[i].checked_status=obj[i].checked;
        }
    }
}

// authenticated name check for LDAP
function checkRenName(name){
    if ( name == ""){
         return false;
     }
     
     if( name.charAt(0) == '-' 
        || (name.charAt(0) >= 'A' && name.charAt(0) <= 'Z')){
         return false;
     }
     
     var invalid = /[^A-Za-z0-9-_]/g;
     var ifFind = name.search(invalid);
     return (ifFind == -1); 
}
// base DN name check for LDAP
function checkDistinguishedName(name){
    if ( name == ""){
        return false;
    }
    var invalid = /[^A-Za-z0-9\,\=\-\_ ]/g;
    var ifFind = name.search(invalid);
    if (ifFind != -1){
        return false; 
    }
     
    var tmpArray = name.split(',');
    for (var i=0; i< tmpArray.length; i++){
        if( tmpArray[i].charAt(0) == "=" 
            || tmpArray[i].charAt(0) == "-"
            || tmpArray[i].charAt(0) == " "
            || tmpArray[i].charAt(0) == "_"
            || tmpArray[i].charAt(0) == ","
            || (tmpArray[i].charAt(0) >= "0" && tmpArray[i].charAt(0) <= "9")
            || tmpArray[i] == ""){
             return false;
        }
    }
    return true;
}

// server name check for LDAP
function checkLDAPServer(name){
     if ( name == ""){
         return false;
     }
     
     var tmpArray = name.split(' ');
     for (var i=0; i< tmpArray.length; i++){
        if( tmpArray[i].charAt(0) == "." 
            || tmpArray[i].charAt(0) == "-"
            || tmpArray[i].charAt(0) == ":"){
             return false;
        }
     }
     var invalid = /[^A-Za-z0-9\.\-\: ]/g;
     var ifFind = name.search(invalid);
     return (ifFind == -1); 
     
}

//add by key for nas 13095
function checkPortNum(name){
    var tmpArray = name.split(' ');
    for (var i=0; i< tmpArray.length; i++){
       if (tmpArray[i].match(/:(.*)/)){
            var port = RegExp.$1;
            if ((port == "") ||(port.match(/[^\d]/))) {
                return false;
            }
        }
    }   
    return true;

}


function checkNetBIOSName(str){
    if (str == ""){
        return false;
    }
    if (str.length>15){
        return false;
    }
    if (str.charAt(0) == "-"){
        return false;
    }
    var avail=/[^A-Za-z0-9\-]/g;
    ifFind = str.search(avail);
    return (ifFind==-1);
}


// check network or IP address for Native.
function checkNativeNetwork(str){
        if(str==""){
            return false;
        }
        var ipModel=/^(([\d]{1,3})\.){0,3}([\d]{1,3}){0,1}$/;
        var IPArray=str.match(ipModel);
        if (IPArray==null){
            return false;
        }
        IPArray = str.split('.');
        for (var i=0;i<=IPArray.length;i++){
            if (IPArray[i]>255) {
            return false;
            }
        }
        if (str.charAt(str.length - 1) != "."
            && IPArray.length <= 3 ){
            return false;
        }
        return true;
    }

function checkNISServer(textObject){ 
     var name =trim(textObject.value);
     if ( name == ""){
          return false;
     }
     name = name.replace(/(\s+)/g," ");
     var tmpArray = name.split(" ");

     if (tmpArray.length>3){
         return false;
     }
     var invalid = /[^A-Za-z0-9\.\- ]/g;
     var ifFind = name.search(invalid);
     if(ifFind != -1){
         return false;     
     }

     textObject.value = "";
     for (var i=0; i< tmpArray.length; i++){
         if( tmpArray[i].charAt(0) == "."
             || tmpArray[i].charAt(0) == "-"
             || tmpArray[i].length >255){
             textObject.value = name;
             return false;
         }
          for(var j=0;j<tmpArray.length;j++){
             if ((i!=j) && (tmpArray[i] == tmpArray[j])){
                 tmpArray[i] = "";
                 break;
             }
         }

       textObject.value =trim(textObject.value+" "+tmpArray[i]);
     }
     return true;
     
}

function checkKDCServer(textObject){ 
    var name =trim(textObject.value);
    if ( name == ""){
        return true;
    }
    name = name.replace(/(\s+)/g," ");
    var tmpArray = name.split(" ");
    if (tmpArray.length>3){
        textObject.focus();
        return false;
    }
    
    textObject.value = "";
    for (var i=0; i< tmpArray.length; i++){
        if (!checkFQDN(tmpArray[i])){
            textObject.focus();
            textObject.value = name;
            return false;
        }
        for(var j=0;j<tmpArray.length;j++){
            if ((i!=j) && (tmpArray[i] == tmpArray[j])){
                tmpArray[i] = "";
                break;
            }
        }
        textObject.value =trim(textObject.value+" "+tmpArray[i]);
    }
    return true;
}

function toUpper(object){
    object.value= object.value.toUpperCase();
}

function strToHex(str){
    var hexString = "";
    for (var i=0;i<str.length; i++){
        var charValue = str.charCodeAt(i);
        var intValue = parseInt(charValue);
        intValue = intValue.toString(16);
        hexString += "0x" + intValue;
    }
    return hexString;
}

function checkLdapFilter(filter){
    if(filter == ""){
        return true;
    }
    if(filter.length > 1023){
        return false;
    }
    var invalidCharector=/[^0-9a-zA-Z\(\) \&\|\!\~\=\<\>\*\:\-;]|^[^\(]|[^\)]$/g;
    return (filter.search(invalidCharector)==-1);
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

//base DN name check for LDAP 
//add by liq 2005/11/3 [nsgui-necas-sv4:10631]
function checkBaseDNName(basednname){
    if ( basednname == ""){
        return false;
    }
    var invalid = /[^A-Za-z0-9\,\=\-\_\s\+\.\#\<\>\;\\\"]/;
    var ifFind = basednname.search(invalid);
    if (ifFind != -1){
        return false; 
    }
     
    var tmpArray = basednname.split(',');
    for (var i=0; i< tmpArray.length; i++){
        var tmp = tmpArray[i].charAt(0);
        if (tmp==""){
            return false;
        }
        var invalidhead = /[^A-Za-z]/;
        var ifvalidhead = tmp.search(invalidhead);
        if (ifvalidhead!=-1){
            return false;
        }
        
    }
    return true;
}

function lockMenu(){
	top.TITLE.menuLock = 1;
	if(!top.CONTROLL.document
        ||!top.CONTROLL.document.forms[0]){
        return;
    }
	top.TITLE.exportGroup = top.CONTROLL.document.forms[0].exportGroup.disabled;
	top.CONTROLL.document.forms[0].exportGroup.disabled = true;
	if(top.CONTROLL.document.forms[0].changeNode){
		top.TITLE.changeNode = top.CONTROLL.document.forms[0].changeNode.disabled;
		top.CONTROLL.document.forms[0].changeNode.disabled = true;
	}
}

function unLockMenu(){
	top.TITLE.menuLock = 0;
	if(!top.CONTROLL.document
        ||!top.CONTROLL.document.forms[0]){
        return;
    }
	top.CONTROLL.document.forms[0].exportGroup.disabled = top.TITLE.exportGroup;
	if(top.CONTROLL.document.forms[0].changeNode){
		top.CONTROLL.document.forms[0].changeNode.disabled = top.TITLE.changeNode;
	}
}

function isMenuLocked(){
	return top.TITLE.menuLock;
}

/*
    end
*/
