<!--
        Copyright (c) 2003-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ftpset.jsp,v 1.2309 2008/12/23 05:19:29 gaozf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*" %>  
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="nshtml-taglib" prefix="nshtml" %>

<jsp:useBean id="bean" class="com.nec.sydney.beans.ftp.FTPSetBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<TITLE><nsgui:message key="nas_ftp/common/h1"/></TITLE>
<script LANGUAGE="JavaScript">
var popupWind=null;
var ftpstatusform;
var ftpinfoform;

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

function resize(){
    var info = browserInfo();
    if( info == "WNS4" || info == "LNS4" ){
        location.reload();
    }
}

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

//    obj=eval('document.'+formName+'.'+thisPoint.name);
     obj=eval(ftpinfoform.name+'.'+thisPoint.name);
   

    if(thisPoint.disabled){
        //alert("liqing");
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
//                alert("xh");

         ftpinfoform.anonaccessmode[0].checked_status=ftpinfoform.anonaccessmode[0].checked;
         ftpinfoform.anonaccessmode[1].checked_status=ftpinfoform.anonaccessmode[1].checked;
         ftpinfoform.anonaccessmode[2].checked_status=ftpinfoform.anonaccessmode[2].checked;
         ftpinfoform.anonclientmode[0].checked_status=ftpinfoform.anonclientmode[0].checked;
         ftpinfoform.anonclientmode[1].checked_status=ftpinfoform.anonclientmode[1].checked;

}

function gRTrim(name){ 
    var whitespace = new String(" \t\n\r");
    var s = new String(name);
    var i = s.length - 1;       
    while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
         i--;
    s = s.substring(0, i+1);
    return s;
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



function newWindow(){
    if(popupWind==null || popupWind.closed){
        popupWind=window.open("ftpauthdb.jsp","ftp_auth_sub","toolbar=no,menubar=no,scrollbars=yes,width=700,height=600,resizable=yes");
	//popupWind.pwd2=document.forms[0].entry;
    }else{
	popupWind.focus();
    }
} 
function setOperation(form, op){
    form.operation.value = op;
}
function goBack()
{
    window.location="<%=response.encodeURL("ftpinfo.jsp")%>";
}
//1
function checkuseftp(){
    if(document.ftpstatusform.useftp.checked){
        showIt("ftpset");
        hideIt("ftpsetbutton");
    }else{
	    hideIt("ftpset");
	    showIt("ftpsetbutton");
    }
}

//2use834556
function firstload(){
    ftpstatusform=document.ftpstatusform;
    getlayerform();
  //  showport();  comment(nas 13408) [nsgui-necas-sv4 1299]
    showpassiveport();
    showhomedir();
    showanon();
}

//3comment(nas 13408) [nsgui-necas-sv4 1299]
//function showport(){
//    if(ftpinfoform.port[0].checked){
//        ftpinfoform.portnumber.disabled=1;
//    }
//    if(ftpinfoform.port[1].checked){
//       ftpinfoform.portnumber.disabled=0;
//    }
//}

//add as[nas-dev-necas:10343] 
function showpassiveport(){
    if(ftpinfoform.passiveport[0].checked){
        ftpinfoform.passiveportstartnumber.disabled=1;
        ftpinfoform.passiveportendnumber.disabled=1;
    }
    if(ftpinfoform.passiveport[1].checked){
       ftpinfoform.passiveportstartnumber.disabled=0;
       ftpinfoform.passiveportendnumber.disabled=0;
    }
}
//4 showusermapping()has delete (nas 12618) [nsgui-necas-sv4 548] FTP  (9/17)

//5
function showhomedir(){
    if(ftpinfoform.homedirectory[0].checked){
        ftpinfoform.getfsdir.disabled=1;
        ftpinfoform.fsdir.disabled=1;
        ftpinfoform.userinputarea.disabled=1;
    }
    if(ftpinfoform.homedirectory[1].checked){
        ftpinfoform.getfsdir.disabled=0;
        ftpinfoform.fsdir.disabled=0;
        ftpinfoform.userinputarea.disabled=0;
    }
    
}

//6
function showanon(){
	if(ftpinfoform.anonuse.checked){
		ftpinfoform.anondir.disabled=0;
		ftpinfoform.getanondir.disabled=0;
		ftpinfoform.anonmaxconnect.disabled=0;
		ftpinfoform.anonaccessmode[0].disabled=0;
		ftpinfoform.anonaccessmode[1].disabled=0;
		ftpinfoform.anonaccessmode[2].disabled=0;
		ftpinfoform.anonclientmode[0].disabled=0;
		ftpinfoform.anonclientmode[1].disabled=0;
		ftpinfoform.anonclientlist.disabled=0;
		ftpinfoform.anonusername.disabled=0;
		ftpinfoform.anongroupname.disabled=0;
	}else{
		ftpinfoform.anondir.disabled=1;
		ftpinfoform.getanondir.disabled=1;
		ftpinfoform.anonmaxconnect.disabled=1;
		ftpinfoform.anonaccessmode[0].disabled=1;
		ftpinfoform.anonaccessmode[1].disabled=1;
		ftpinfoform.anonaccessmode[2].disabled=1;
		ftpinfoform.anonclientmode[0].disabled=1;
		ftpinfoform.anonclientmode[1].disabled=1;
		ftpinfoform.anonclientlist.disabled=1;
		ftpinfoform.anonusername.disabled=1;
		ftpinfoform.anongroupname.disabled=1;
	}

} 

//7
function checkNetWork(str){
    if(str==""){
        return false;
    }
    var networkModel=/^(([\d]{1,3})\.){1,3}$/;
    var NetWorkArray=str.match(networkModel);
    if (NetWorkArray==null){
    	return false;
    }
    for (var i=1;i<NetWorkArray.length;i++){
    	if (NetWorkArray[i]>255) {
    	    return false;
        }
        if (NetWorkArray[i].length!=1 && NetWorkArray[i].indexOf(0) == 0){
            return false;
        }
    }
    if(NetWorkArray[1]>224){
        return false;
    }
    return true;
}

//8
function getlayerform(){
    if(document.getElementById) {
    //Type 1: IE5,6; NN6;
        ftpinfoform= document.getElementsByName("ftpinfoform")[0];
       // alert("nn6"+ftpinfoform.name);
    }
    if (document.layers) {
    //Type 2: NN4
        ftpinfoform= document.layers["ftpset"].document.ftpinfoform;
       // alert("nn4");
    }
}

//9
function checkset(){
    setOperation(ftpinfoform,'set');
    if(document.ftpstatusform.useftp.checked){
        ftpinfoform.useftp.value=true;
    }else{
        ftpinfoform.useftp.value=false;
    }
    
    //comment (nas 13408) [nsgui-necas-sv4 1299]
   // if(ftpinfoform.port[1].checked){//1
   //     ftpinfoform.portnumber.value = gRTrim(ftpinfoform.portnumber.value);
   //     if(!checkport(ftpinfoform.portnumber.value)){
   //         alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
   //                +"<nsgui:message key="nas_ftp/alert/invalidPortNum"/>");
   //     ftpinfoform.portnumber.focus();
   //     return false;
   //     }
   // }
    
    
    
    if(ftpinfoform.passiveport[1].checked){//add as[nas-dev-necas:10343] 
        ftpinfoform.passiveportstartnumber.value = gRTrim(ftpinfoform.passiveportstartnumber.value);
        ftpinfoform.passiveportendnumber.value = gRTrim(ftpinfoform.passiveportendnumber.value);
        if(!checkpassiveport(ftpinfoform.passiveportstartnumber.value,ftpinfoform.passiveportendnumber.value)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +"<nsgui:message key="nas_ftp/alert/invalidPassiveport"/>");
        ftpinfoform.passiveportstartnumber.focus();
        return false;
        }
    }
       
    ftpinfoform.basemaxconnect.value = gRTrim(ftpinfoform.basemaxconnect.value);
    if(!checkmaxconnect(ftpinfoform.basemaxconnect.value)){//2
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
              +"<nsgui:message key="nas_ftp/alert/invalidMaxConnect"/>");
        ftpinfoform.basemaxconnect.focus();
        return false;
    }
    ftpinfoform.baseclientlist.value = gRTrim(ftpinfoform.baseclientlist.value);
    if(!checkclientlist(ftpinfoform.baseclientlist.value)){//3
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
              +"<nsgui:message key="nas_ftp/alert/invalidClient"/>");
        ftpinfoform.baseclientlist.focus();              
        return false;
    }
    if(isEmpty(ftpinfoform.dbtype.value)){//4
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
              +"<nsgui:message key="nas_ftp/alert/noAuthDB"/>");
        return false;
    }
  //  ftpinfoform.userlist.value = gRTrim(ftpinfoform.userlist.value);
    if(!checkuserlist(ftpinfoform.userlist.value)){//5
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
              +"<nsgui:message key="nas_ftp/alert/invalidUserList"/>");
        ftpinfoform.userlist.focus();
        return false;
    }
    
    //ftpinfoform.anonuser.value = gRTrim(ftpinfoform.anonuser.value);
    if(!checkanonuser(ftpinfoform.anonuser.value)){//6
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
            +"<nsgui:message key="nas_ftp/alert/invalidUserName"/>");
        ftpinfoform.anonuser.focus();
        return false;
    }

    if(ftpinfoform.homedirectory[1].checked){
        if(isEmpty(ftpinfoform.fsdir.value)){//7-1
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                  +"<nsgui:message key="nas_ftp/alert/noHomeDir"/>");
            return false;
        }
     //   ftpinfoform.userinputarea.value = gRTrim(ftpinfoform.userinputarea.value);
        if(!checkuserinputarea(ftpinfoform.userinputarea.value)){//7-2
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                  +"<nsgui:message key="nas_ftp/alert/invalidUserInputArea"/>");
            ftpinfoform.userinputarea.focus();
            return false;
        }
        var fs=ftpinfoform.fsdir.value;
        if (!ftpinfoform.userinputarea.value==""){
            fs=fs+"/"+ftpinfoform.userinputarea.value;
        }
        if(!checkhomedirlength(fs)){//7-3
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                  +"<nsgui:message key="nas_ftp/alert/tooLongHomeDir"/>");
            return false;
        }
    }
    if(ftpinfoform.anonuse.checked){
        if(isEmpty(ftpinfoform.anondir.value)){//8
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                  +"<nsgui:message key="nas_ftp/alert/noAnonDir"/>");
            ftpinfoform.anondir.focus();
            return false;
        }
        ftpinfoform.anonmaxconnect.value = gRTrim(ftpinfoform.anonmaxconnect.value);
        if(!checkmaxconnect(ftpinfoform.anonmaxconnect.value)){//9
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                +"<nsgui:message key="nas_ftp/alert/invalidMaxConnect"/>");
            ftpinfoform.anonmaxconnect.focus();
            return false;
        }
        ftpinfoform.anonclientlist.value = gRTrim(ftpinfoform.anonclientlist.value);
        if(!checkclientlist(ftpinfoform.anonclientlist.value)){//10
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                +"<nsgui:message key="nas_ftp/alert/invalidClient"/>");
            ftpinfoform.anonclientlist.focus();
            return false;
        }
        
        if(!checkanonuser(ftpinfoform.anonusername.value) || ftpinfoform.anonusername.value=="anonymous"){//11
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                +"<nsgui:message key="nas_ftp/alert/noInvalidUserName"/>");
            ftpinfoform.anonusername.focus();
            return false;
        }
        
        if(!checkanonuser(ftpinfoform.anongroupname.value)){//12
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                +"<nsgui:message key="nas_ftp/alert/noInvalidGroupName"/>");
            ftpinfoform.anongroupname.focus();
            return false;
        }
    }
    if(isSubmitted()&&
        confirm(
//gaozf 20081205 start      
              <%if(bean.isFriendUseFTPServices()){%>
                  "<nsgui:message key="nas_ftp/alert/friendPort_set"/>" + "\r\n" 
              <%}else{%> 
                  "<nsgui:message key="common/confirm"/>"+ "\r\n"
              <%}%>   
//end
                 + "<nsgui:message key="common/confirm/act"/>"
                 + "<nsgui:message key="nas_ftp/common/button_set"/>" + "\r\n")){
        ftpinfoform.submit();
        setSubmitted();
        return true;
    }
    return false;
    
}

//10
function checkport(str){
    if(str==""){//alert("empty");
        return false;
    }
    var invalidnumModel=/[^0-9]/g;
    var portN=str.match(invalidnumModel);
    if (portN!=null){
        return false;
    }
    if(str.indexOf(0)==0){// alert("with 0 as head");
        return false;
    }
    if(str>65535){
        return false;
    }
    return true;
}

//11
function checkmaxconnect(str){
    if(str==""){
        return true;
    }
    var invalidmaxcModel=/[^0-9]/g;
    var maxcN=str.match(invalidmaxcModel);
    if (maxcN!=null){
        return false;
    }
    if((str.indexOf(0)==0)&&(str.length>1)){
        return false;
    }
    if(str>65535){
        return false;
    }
    return true;
}

//12useCheckIP()
function checkclientlist(str){
    if(str==""){
        return true;
    }
    if(str.length>4096){
        return false;
    }
    var clientlist= str.split(",");
    if(clientlist.length>256){
        return false;
    }
    for(var i=0;i<clientlist.length;i++)
    {
        if(!checkNetWork(clientlist[i])){
            if(!checkIP(clientlist[i])){
                return false;
            }
        }
    }
    return true;
}

//13/17/check29
function isEmpty(str){
    if(str==null||str=="<nsgui:message key="nas_ftp/common/select"/>"||str==""){
        return true;
    }
    return false;
}

//14 use15
function checkuserlist(str){
    if(str==""){
        return true;
    }
    if(str.length>4096){
        return false;
    }
    var userlist=str.split(",");
    for(var i=0;i<userlist.length;i++){
        if(!checkanonuser(userlist[i])){
            return false;
        }
    }
    return true;
}

//15
//change by liqing 20031018 (nas 13305) [nsgui-necas-sv4 1204] 
function checkanonuser(str){
    if(str==""){
        return false;
    }
    if(str.length>32){
        return false;
    }
    var num = /[ 0-9\-]/;
    var ifFind = str.search(num);
    if (ifFind == 0){
        return false;
    }
    var invaliduser = /[^ a-zA-Z0-9_-]/g;
    var anonuser=str.match(invaliduser);
    if (anonuser!=null){
        return false;
    }
    return true;
}

//16use20
function checkuserinputarea(str){
    if(str==""){
        return true;
    }
    var validuserinput=/^(%u|%h).*/;
    var userinput=str.match(validuserinput);
    if (userinput==null){
    	return false;
     }else{
        if(str.length>2){
        	var tempstr=str.substr(2);
        	
        	return checkdirsuffixName(tempstr);
        	
        }else {
            return true;
        }
    }
}

//18
function checkhomedirlength(str){
    if(str.length>256){
        return false;
    }
    return true;
}

//19
function ftpreset(){
    //comment (nas 13408) [nsgui-necas-sv4 1299]
    <%if(bean.getPortNumber().equals("21")){%>
      //  ftpinfoform.port[0].checked=1;
      //  ftpinfoform.port[1].checked=0;
        
    <%}else{%>
      //  ftpinfoform.port[0].checked=0;            
      //  ftpinfoform.port[1].checked=1;

    <%}%>

  //  showport();
  //end (nas 13408) [nsgui-necas-sv4 1299]
  
   //liq add 2003/9.4
    <%if(bean.getPassivePortStartNumber().equals("36864")&& bean.getPassivePortEndNumber().equals("40960")){%>
        ftpinfoform.passiveport[0].checked=1;
        ftpinfoform.passiveport[1].checked=0;
        
    <%}else{%>
        ftpinfoform.passiveport[0].checked=0;            
        ftpinfoform.passiveport[1].checked=1;

    <%}%>
    showpassiveport();
    //end liq
    <%if(bean.getAuthUserMappingMode().equals("Normal")){%>
        ftpinfoform.usermapping[0].checked=1;
        ftpinfoform.usermapping[1].checked=0;
    <%}else{%>
        ftpinfoform.usermapping[0].checked=0;
        ftpinfoform.usermapping[1].checked=1;
    <%}%>
   
    <%if(bean.getHomeDirMode().equals("AuthDB")){%>
        ftpinfoform.homedirectory[0].checked=1;
        ftpinfoform.homedirectory[1].checked=0;        
    <%}else{%>
        ftpinfoform.homedirectory[0].checked=0;    
        ftpinfoform.homedirectory[1].checked=1;
    <%}%>
    showhomedir();
    
    <%if(bean.isUseAnonFTP()){%>
        ftpinfoform.anonuse.checked=1;
         
    <%}else{%>
        ftpinfoform.anonuse.checked=0;
                        
        
    <%}%>
        <%if(bean.getAnonAccessMode().equals("ReadWrite")){%>
            ftpinfoform.anonaccessmode[0].checked = 1;
            ftpinfoform.anonaccessmode[1].checked = 0;
            ftpinfoform.anonaccessmode[2].checked = 0;                        
         <%}else if(bean.getAnonAccessMode().equals("DownloadOnly")){%>
            ftpinfoform.anonaccessmode[0].checked = 0;
            ftpinfoform.anonaccessmode[1].checked = 1;
            ftpinfoform.anonaccessmode[2].checked = 0;
         <%}else if(bean.getAnonAccessMode().equals("UploadOnly")){%>
            ftpinfoform.anonaccessmode[0].checked = 0;
            ftpinfoform.anonaccessmode[1].checked = 0;
            ftpinfoform.anonaccessmode[2].checked = 1;
         <%}else{%>         
            ftpinfoform.anonaccessmode[0].checked = 1;
            ftpinfoform.anonaccessmode[1].checked = 0;
            ftpinfoform.anonaccessmode[2].checked = 0;                        
        
         <%}%>
         <%if(bean.getAnonClientMode().equals("Allow")){%>
            ftpinfoform.anonclientmode[0].checked = 1;
            ftpinfoform.anonclientmode[1].checked = 0;
         
         <%}else if(bean.getAnonClientMode().equals("Deny")){%>
            ftpinfoform.anonclientmode[0].checked = 0;
            ftpinfoform.anonclientmode[1].checked = 1;
         <%}else{%>
            ftpinfoform.anonclientmode[0].checked = 1;
            ftpinfoform.anonclientmode[1].checked = 0;
      
         <%}%>
         
    radioRecordStatus("fault","fault");
    showanon();

}

//20check userinputarea without %u %h
function checkdirsuffixName(str){
    var invalid = /^[~\.\-]|[^ 0-9a-zA-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
    var flag=str.search(invalid);
    if(flag==-1){
        return true;
    }else{
        return false;
    }  
}

//add as[nas-dev-necas:10343] 
function checkpassiveport(startport,endport){
    if(startport==""||endport==""){//alert("empty");
        return false;
    }
    var invalidnumModel=/[^0-9]/g;
    var portNstart=startport.match(invalidnumModel);
    var portNend=endport.match(invalidnumModel);
    if (portNstart!=null||portNend!=null){
        return false;
    }
    if(startport.indexOf(0)==0||endport.indexOf(0)==0){// alert("with 0 as head");
        return false;
    }
    if((startport < 1024)||(endport>65534)||(parseInt(startport)>parseInt(endport))){
        return false;
    }
    return true;
}

function ftpnotuse(){
    setOperation(ftpstatusform,'set');
    if(isSubmitted()&&
        confirm("<nsgui:message key="common/confirm"/>"+ "\r\n"
                 + "<nsgui:message key="common/confirm/act"/>"
                 + "<nsgui:message key="nas_ftp/common/button_set"/>" + "\r\n")){
        ftpstatusform.submit();
        setSubmitted();
        return true;
    }
    return false;
}

var popWinHomeDir,popWinAnonyDir;
function getHomeDir(){
    if(popWinHomeDir==null || popWinHomeDir.closed) {
        popWinHomeDir = window.open("<%=response.encodeURL("../http/httpnavigator.jsp?act=nfs&frompage=ftp")%>","ftpgethomedir",
                "toolbar=no,menubar=no,scrollbar=no,width=500,height=500,resizable=yes");
                popWinHomeDir.path = ftpinfoform.fsdir;
    } else {
        popWinHomeDir.focus();
    }

}

function getAnonDir(){
    if(popWinAnonyDir==null || popWinAnonyDir.closed) {
        popWinAnonyDir = window.open("<%=response.encodeURL("../http/httpnavigator.jsp?act=nfs&frompage=ftp")%>","ftpgetanondir",
                "toolbar=no,menubar=no,scrollbar=no,width=500,height=500,resizable=yes");
                popWinAnonyDir.path = ftpinfoform.anondir;
    } else {
        popWinAnonyDir.focus();
    }

}

function enableUseftp(){
    ftpstatusform.useftp.disabled=0;
}

</script>
<jsp:include page="../../common/wait.jsp" />

</HEAD>

<BODY onResize="resize()" onload="firstload();checkuseftp();displayAlert();enableUseftp();">
<h1 class="title"><nsgui:message key="nas_ftp/common/h1"/></h1>
<h2 class="title"><nsgui:message key="nas_ftp/general_settings/h2_ftp_settings"/></h2>

<%String back=NSMessageDriver.getInstance().getMessage(session, "common/button/back");%> 
<nshtml:form name="ftpstatusform" method="post" action="../../../menu/common/forward.jsp">
<nshtml:button name="back" value="<%=back%>" onclick="goBack();"/><p>
<input type="hidden" name="operation">
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="beanClass" value="<%=bean.getClass().getName()%>">
<%boolean isUseFTP=bean.isUseFTPService();%>
<nshtml:checkbox name="useftp" value="useftp" others="id=\"useftp1\"" checked="<%=isUseFTP%>" disabled="true" onclick="checkuseftp()"/>
<label for="useftp1"><nsgui:message key="nas_ftp/general_settings/use_ftp"/></label>
<br>
</nshtml:form>

<div id="ftpset" style="VISIBILITY: hidden;  POSITION: absolute; left: 15px">
<nshtml:form name="ftpinfoform" method="post" action="../../../menu/common/forward.jsp">
<input type="hidden" name="useftp">
<input type="hidden" name="operation">
<input type="hidden" name="beanClass" value="<%=bean.getClass().getName()%>">
<input type="hidden" name="db" value="">
<input type="hidden" name="ludbname" value="">
<input type="hidden" name="nisnetwork" value="">
<input type="hidden" name="nisdomain" value="">
<input type="hidden" name="nisserver" value="">
<input type="hidden" name="pdcdomain" value="">
<input type="hidden" name="pdcname" value="">
<input type="hidden" name="bdcname" value="">
<input type="hidden" name="ldapserver" value="">
<input type="hidden" name="ldapbasedn" value="">
<input type="hidden" name="ldapmethod" value="">
<input type="hidden" name="ldapbindname" value="">
<input type="hidden" name="_ldapbindpasswd" value="">
<input type="hidden" name="ldapusetls" value="">
<input type="hidden" name="ldapUserFilter" value="">
<input type="hidden" name="ldapGroupFilter" value="">
<input type="hidden" name="utoa" value="">
<input type="hidden" name="ldapcertfile" value="">
<input type="hidden" name="ldapcertdir" value="">
<input type="hidden" name="ldapuserinput" value="">
<input type="hidden" name="port" value="default"><!-- add (nas 13408) [nsgui-necas-sv4 1299]-->
<input type="hidden" name="uselan" value="false">
<h3 class="title"><nsgui:message key="nas_ftp/ftp_info/basic_h3"/></h3>
<table border=1>
    <tr>
        <%boolean isPassiveDefault=true;
          String portStart="";
          String portEnd="";
        if(!bean.getPassivePortStartNumber().equals("36864")||!bean.getPassivePortEndNumber().equals("40960")){
            if(!bean.getPassivePortStartNumber().equals("")&&!bean.getPassivePortEndNumber().equals("")){
                isPassiveDefault=false;
                portStart=bean.getPassivePortStartNumber();
                portEnd=bean.getPassivePortEndNumber();
            }
        }%>
        <th nowrap align="left"><nsgui:message key="nas_ftp/general_settings/passiveport"/></th>
        <td><nshtml:radio name="passiveport" value="default" others="id=\"pp1\"" checked="<%=isPassiveDefault%>" onclick="showpassiveport()"/>
	        <label for="pp1"><nsgui:message key="nas_ftp/general_settings/default_passiveport"/></label>&nbsp;
	        <nshtml:radio name="passiveport" value="change" others="id=\"pp2\"" checked="<%=!isPassiveDefault%>" onclick="showpassiveport()"/>
	        <label for="pp2" ><nsgui:message key="nas_ftp/general_settings/change_passiveport"/></label>&nbsp;
    	    <nshtml:text name="passiveportstartnumber" size="5" maxlength="5" value="<%=portStart%>"/>
    	    <nsgui:message key="nas_ftp/general_settings/connect_signal"/>
    	    <nshtml:text name="passiveportendnumber" size="5" maxlength="5" value="<%=portEnd%>"/>
    	</td>    
    </tr>
    <tr>
        <%String basMaxConnections=bean.getBasMaxConnections();%>
	<th nowrap align="left"><nsgui:message key="nas_ftp/general_settings/maxclients"/></th>
	<td><nshtml:text name="basemaxconnect" maxlength="5" value="<%=basMaxConnections%>"/>
	        <nsgui:message key="nas_ftp/general_settings/nolimit"/></td>
    </tr>
    <tr>
        
	<th nowrap align="left"><nsgui:message key="nas_ftp/general_settings/write_protect"/></th>
	<td><nshtml:radio name="baseaccessmode" value="ReadWrite" others="id=\"bam1\"" 
	        checked='<%=!bean.getBasAccessMode().equals("ReadOnly")%>'/>
	        <label for="bam1"><nsgui:message key="nas_ftp/general_settings/read_write"/></label>&nbsp;
	    <nshtml:radio name="baseaccessmode" value="ReadOnly" others="id=\"bam2\""
	        checked='<%=bean.getBasAccessMode().equals("ReadOnly")%>'/>
	        <label for="bam2"><nsgui:message key="nas_ftp/general_settings/read_only"/></label>
	</td>
    </tr>
    <tr>
       
	<th nowrap align="left"><nsgui:message key="nas_ftp/general_settings/allow_deny_client"/></th>
        <td><nshtml:radio name="baseclientmode" value="Allow" others="id=\"bcm1\"" 
                checked='<%=!bean.getBasClientMode().equals("Deny")%>'/><label for="bcm1">
                <nsgui:message key="nas_ftp/general_settings/allow_user"/></label>
            <nshtml:radio name="baseclientmode" value="Deny" others="id=\"bcm2\""
                checked='<%=bean.getBasClientMode().equals("Deny")%>'/><label for="bcm2">
                <nsgui:message key="nas_ftp/general_settings/deny_user"/></label>
        </td>
    </tr>
    <tr>
        <%String basClientList=bean.getBasClientList();%>
        <th nowrap align="left"><nsgui:message key="nas_ftp/general_settings/client_list"/></th>
        <td><nshtml:text name="baseclientlist" size="50" maxlength="4096" value="<%=basClientList%>"/></td>
    </tr>
<!--shench 2008.12.3 start -->
    <tr>
        <th nowrap align="left"><nsgui:message key="nas_ftp/general_settings/user_identd"/></th>
        <td><nshtml:radio name="baseidentdmode" value="on" others="id=\"bdm1\"" 
                checked='<%=bean.getBasIdentdMode().equals("on")%>'/><label for="bdm1">
                <nsgui:message key="nas_ftp/general_settings/identd_use"/></label>
            <nshtml:radio name="baseidentdmode" value="off" others="id=\"bdm2\""
                checked='<%=!bean.getBasIdentdMode().equals("on")%>'/><label for="bdm2">
                <nsgui:message key="nas_ftp/general_settings/identd_not_use"/></label>
        </td>
    </tr>
<!--end shench -->
</table>


<h3 class="title"><nsgui:message key="nas_ftp/ftp_info/auth_h3"/></h3>
<table border="1">
    <tr>
        <%String authDBType=bean.getAuthDBType();
        if(authDBType.equals("nis")){
            authDBType="NIS";
        }else if(authDBType.equals("pwd")){
            authDBType="PWD";
        }else if(authDBType.equals("dmc")){
            authDBType="PDC";
        }else if(authDBType.equals("ldu")){
            authDBType="LDAP";
        }
        String changedb=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/button_change");%>
        <th nowrap align="left"><nsgui:message key="nas_ftp/auth_settings/auth_db"/></th>
        <td><nshtml:text name="dbtype" readonly="true" value="<%=authDBType%>"/>&nbsp;&nbsp;
            <nshtml:button name="changedb" value="<%=changedb%>" onclick="newWindow()"/>
        </td>
    </tr>
    <tr>
        <th nowrap align="left"><nsgui:message key="nas_ftp/auth_settings/allow_deny_user"/></th>
        <td>
           
      	    <nshtml:radio name="authaccesstype" value="allow" others="id=\"um1\"" 
      	        checked='<%=!bean.getAuthAccessType().equals("deny")%>'/><label for="um1">
      	        <nsgui:message key="nas_ftp/auth_settings/allow_user"/></label>
      	   <nshtml:radio name="authaccesstype" value="deny" others="id=\"um2\""
      	        checked='<%=bean.getAuthAccessType().equals("deny")%>'/><label for="um2">
      	        <nsgui:message key="nas_ftp/auth_settings/deny_user"/></label>
        </td>
    </tr>
    <tr>
        <%String authUserList=bean.getAuthUserList();%>
        <th nowrap align="left"><nsgui:message key="nas_ftp/auth_settings/user_list"/></th>
        <td><nshtml:text name="userlist" size="50" maxlength="4096" value="<%=authUserList%>"/></td>
    </tr>
    <tr>
        <% String authAnonUserName=bean.getAuthAnonUserName();
        boolean isNormal=true;
        boolean isAnonymous=false;
        if(bean.getAuthUserMappingMode().equals("Anonymous")){
            isNormal=false;
            isAnonymous=true; 
        }%>
        
        <th nowrap valign="top" align="left"><nsgui:message key="nas_ftp/auth_settings/user_mapping_mode"/></th>
        <td><nshtml:radio name="usermapping" value="Normal" others="id=\"ump2\""
      	        checked='<%=isNormal%>' /><label for="ump2">
      	            <nsgui:message key="nas_ftp/auth_settings/user_mapping_available"/></label>
      	    <nshtml:radio name="usermapping" value="Anonymous" others="id=\"ump3\""
      	        checked='<%=isAnonymous%>' /><label for="ump3">
      	            <nsgui:message key="nas_ftp/auth_settings/user_mapping_anonymous"/></label><br>
      	    <nsgui:message key="nas_ftp/auth_settings/anonymous_user"/>
      	        <nshtml:text name="anonuser" size="32" maxlength="32" value="<%=authAnonUserName%>"/>
        </td>
    </tr>
    <tr>
        <th nowrap valign="top" align="left"><nsgui:message key="nas_ftp/auth_settings/home_dir"/></th>
        <td>
      	    <table>
      	        <tr>
      	        <td>    
   		    <nshtml:radio name="homedirectory" value="AuthDB" others="id=\"hd1\"" 
   		        checked='<%=!bean.getHomeDirMode().equals("FSSpecify")%>' onclick="showhomedir()"/><label for="hd1">
   		        <nsgui:message key="nas_ftp/auth_settings/use_auth_db"/></label><br>
      		    <nshtml:radio name="homedirectory" value="FSSpecify" others="id=\"hd2\""
      		        checked='<%=bean.getHomeDirMode().equals("FSSpecify")%>' onclick="showhomedir()"/><label for="hd2">
      		        <nsgui:message key="nas_ftp/auth_settings/use_fs_specify"/></label>
      		    </td>
	      	</tr>
	      	<tr>
	      	    <%String getfsdir=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/button_browse");
	      	    String homeDirPrefix=bean.getHomeDirPrefix();
	      	    if (homeDirPrefix.equals("")){
	      	        homeDirPrefix=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/select");
	      	    }
	      	    String homeDirSuffix=bean.getHomeDirSuffix();
	      	    %>
      		    <td><nshtml:button name="getfsdir" value="<%=getfsdir%>" onclick="getHomeDir()"/>
      			<nshtml:text readonly="true"  name="fsdir" size="40" value="<%=homeDirPrefix%>"/>/
                        <nshtml:text name="userinputarea" size="20" value="<%=homeDirSuffix%>"/>
                    </td>
      		</tr>
   	    </table>
      </td>
    </tr>
</table>


<h3 class="title"><nsgui:message key="nas_ftp/ftp_info/anon_h3"/></h3> 		
<table border="1">
    <tr>
        
    
        <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/use_anonymous_ftp"/></th>
        <td><nshtml:checkbox name="anonuse" value="anonuse" others="id=\"au1\""
                checked="<%=bean.isUseAnonFTP()%>" onclick="showanon()"/>
      		<label for="au1"><nsgui:message key="nas_ftp/anonymous_settings/use"/></label></td>
    </tr>
    <tr>
        <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/directory"/></th>
        <td>
            <%String anonFTPDir=bean.getAnonFTPDir();
            if (anonFTPDir.equals("")){
                anonFTPDir=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/select");
            }
            String getanondir=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/button_browse");
            %>
      	    <nshtml:text readonly="true" name="anondir" size="50" value="<%=anonFTPDir%>"/> 
       	    <nshtml:button name="getanondir" value="<%=getanondir%>" onclick="getAnonDir()"/>
        </td>
    </tr>
    <tr>
        <%String anonmaxconnect=bean.getAnonMaxConnections();%>
        <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/max_connections"/></th>
        <td><nshtml:text name="anonmaxconnect" maxlength="5" value="<%=anonmaxconnect%>"/>&nbsp;&nbsp;<nsgui:message key="nas_ftp/general_settings/nolimit"/></td>
    </tr>
    <tr>
        <%boolean isRW=true;
        boolean isDO=false;
        boolean isUO=false;
        if(bean.getAnonAccessMode().equals("DownloadOnly")){
            isRW=false;
            isDO=true;
            
        }
        if(bean.getAnonAccessMode().equals("UploadOnly")){
            isRW=false;
            isUO=true;
        } 
        %>
        <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/write_protect"/></th>
        <td><nshtml:radio name="anonaccessmode" value="ReadWrite" others="id=\"am1\"" 
                checked='<%=isRW%>'/><label for="am1">
                <nsgui:message key="nas_ftp/anonymous_settings/read_write"/></label>
            <nshtml:radio name="anonaccessmode" value="DownloadOnly" others="id=\"am2\""
                checked='<%=isDO%>'/><label for="am2">
                <nsgui:message key="nas_ftp/anonymous_settings/download_only"/></label>
            <nshtml:radio name="anonaccessmode" value="UploadOnly" others="id=\"am3\""
                checked='<%=isUO%>'/><label for="am3">
                <nsgui:message key="nas_ftp/anonymous_settings/upload_only"/></label>
        </td>
    </tr>
    <tr>
        
        <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/allow_deny_client"/></th>
        <td><nshtml:radio name="anonclientmode" value="Allow" others="id=\"acm1\"" 
                checked='<%=!bean.getAnonClientMode().equals("Deny")%>'/><label for="acm1">
                <nsgui:message key="nas_ftp/anonymous_settings/allow_user"/></label>
	    <nshtml:radio name="anonclientmode" value="Deny" others="id=\"acm2\""
	        checked='<%=bean.getAnonClientMode().equals("Deny")%>'/><label for="acm2">
	        <nsgui:message key="nas_ftp/anonymous_settings/deny_user"/></label>
	</td>
    </tr>
    <tr>
        <%String anonclientlist=bean.getAnonClientList();%>
      <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/client_list"/></th>
      <td><nshtml:text name="anonclientlist" size="50" maxlength="4096" value="<%=anonclientlist%>"/></td>
    </tr>
    <tr>
        <%String anonusername=bean.getAnonUserName();%>
      <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/user_name"/></th>
      <td><nshtml:text name="anonusername" size="32" maxlength="32" value="<%=anonusername%>"/></td>
    </tr>
    <tr>
        <%String anongroupname=bean.getAnonGroupName();%>
      <th nowrap align="left"><nsgui:message key="nas_ftp/anonymous_settings/group_name"/></th>
      <td><nshtml:text name="anongroupname" size="32" maxlength="32" value="<%=anongroupname%>"/></td>
    </tr>
</table>

<br>
<%String setbutton=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/button_set");%>
<nshtml:button name="set" value="<%=setbutton%>" onclick="checkset()"/>

<input type="reset" name="resetftp" value="<nsgui:message key="common/button/reset"/>" onclick="ftpreset()"/>
</nshtml:form>
</div>

<div id="ftpsetbutton" style="VISIBILITY: show;  POSITION: absolute; left: 15px">
<%String setbutton=NSMessageDriver.getInstance().getMessage(session, "nas_ftp/common/button_set");%>
<nshtml:form name="ftpsetform" method="post" action="../../../menu/common/forward.jsp">
    <nshtml:button name="set" value="<%=setbutton%>" onclick="ftpnotuse()"/>
</nshtml:form>
</div>

</BODY>
</HTML>
