<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originalcommon.jsp,v 1.7 2008/05/28 05:07:25 liy Exp $" -->
<script src="/nsadmin/common/common.js"></script>
<script language="JavaScript">

var isDisableBtn=false;
//======event for body onLoad  for page of precreate , transfer and modify=================================
//type=create , transfer or modify
function init(type){
   if(type=="modify"){ 
       loadOringinalInfo();

   }
   else  if(type=="transfer"){      
       setTagStatus();
   }
   else{                          //if(type=="create")
      //if this is the first time to enter this page
     if(document.forms[0].filesetNamePrefix.value==""){  
         setVolumeFstype(document.forms[0].elements["originalInfo.mountPoint"].selectedIndex);
         if( document.forms[0].elements["originalInfo.mountPoint"].value=="<bean:message key="replication.info.novolume"/>"){
           isDisableBtn=true;
         }            
     }
     else{
        document.getElementById("innerFilesetSuffix").innerHTML=document.forms[0].elements["filesetNameSuffix"].value;
     }
     setTagStatus();
   }
  loadSubmitPage(isDisableBtn);
}

//======set Tag's Status, chechked and disabled,  just acorrding default status or previous  status==========
function setTagStatus(){
  document.forms[0].txtBandWidth.disabled=!document.forms[0].chkBandLimit.checked;
  document.forms[0].slctBandWidthUnit.disabled=document.forms[0].txtBandWidth.disabled;
  
  document.getElementById("rdoPermitall").disabled=!document.forms[0].chkPermitExternalHost.checked;
  document.getElementById("rdoSpecifyHost").disabled=!document.forms[0].chkPermitExternalHost.checked;
  
   if( document.forms[0].chkPermitExternalHost.checked 
     && document.getElementById("rdoSpecifyHost").checked){      // disabled==false
    document.forms[0].txtReplicaHost.disabled=false; 
    
  }
  else{
    document.forms[0].txtReplicaHost.disabled=true; 
   
  }
  
}


//======show info about replicaHost & bandWidth of  the original to be modify  from list page==============================================
function loadOringinalInfo(){
//////////////////////////////////////////
/// set bandWidth info
//////////////////////////////////////////
    var strBandWidthWithUnit=document.forms[0].elements["originalInfo.bandWidth"].value;

    
    
    //"0" means no limit
    if( strBandWidthWithUnit=="0"){
      document.forms[0].chkBandLimit.checked=false;
      document.forms[0].txtBandWidth.disabled=true;
      document.forms[0].slctBandWidthUnit.disabled=true; 
    }
    else{
      document.forms[0].chkBandLimit.click();
      
      var len= strBandWidthWithUnit.length;
      var strUnit=strBandWidthWithUnit.substring(len-1,len);
      
      var strValue=strBandWidthWithUnit.substring(0,len-1);      
           
      document.forms[0].slctBandWidthUnit.value=strUnit;
      document.forms[0].txtBandWidth.value=strValue;
         
    }

//////////////////////////////////////////
/// set replicahost info
//////////////////////////////////////////

    var strHost=document.forms[0].elements["originalInfo.replicaHost"].value;
    
    //not permit Externl host

      document.forms[0].chkPermitExternalHost.checked=false;
      
    // nothing means not to permit external hosts
    if( strHost=="localhost"){       
      document.getElementById("rdoPermitall").checked=true;
      document.getElementById("rdoPermitall").disabled=true;
      document.getElementById("rdoSpecifyHost").disabled=true;
      document.forms[0].txtReplicaHost.disabled=true;
      
    }
    else{
      document.forms[0].chkPermitExternalHost.click();
      
      if(strHost=="all"){
        document.getElementById("rdoPermitall").checked=true;
      }
      else{
      
         var hosts = strHost.split(",");
         strHost = "";
		 var len = hosts.length;
     	 for (var i = 0; i < len; i++) {
			if (hosts[i] !="localhost") {
				strHost += " " + hosts[i];
			} 
		 }
		strHost = trim(strHost);
		document.getElementById("rdoSpecifyHost").checked=true;
        document.forms[0].txtReplicaHost.disabled=false;
        document.forms[0].txtReplicaHost.value=strHost;
	   }		    
    }
}




//===========back to original list page====================================================
 function back2List(){
     if (isSubmitted()){
            return false;
        }
        setSubmitted();
    window.location="/nsadmin/replication/originalAction.do?operation=list";

 }




//========event for Select:MountPoint ====================================================
//to set volume name and fstype
function setVolumeFstype(index){ 
   if(document.forms[0].elements["originalInfo.mountPoint"].value!="<bean:message key="replication.info.novolume"/>"){
    
   document.forms[0].elements["filesetNamePrefix"].value =volumeName[index];
   document.forms[0].elements["filesetNameSuffix"].value =fsType[index];
  
   document.getElementById("innerFilesetSuffix").innerHTML=fsType[index];
   }
   
}
//=======event for Checkbox--chkBandLimit===============================================
function setBandwidthLimit(obj) {
   var chkFlag=obj.checked;
   
   document.forms[0].txtBandWidth.disabled=!chkFlag;
   document.forms[0].slctBandWidthUnit.disabled=!chkFlag;
  
} 
  
//=======event for Checkbox--chkPermitExternalHost===============================================
function setPermitExternalHost(obj) {
    var chkFlag=obj.checked;
    
    document.getElementById("rdoPermitall").disabled=!chkFlag;
    document.getElementById("rdoSpecifyHost").disabled=!chkFlag;
    
    document.forms[0].txtReplicaHost.disabled=!(chkFlag && document.getElementById("rdoSpecifyHost").checked); 
   
 }

 
//============submit  form for the page of create or transfer==  ==invoked by btnframe===========================================================
function onSetAdd(){
    
   if (isSubmitted()) {     
        return false;
   }
   
   if(setOriginalInfo("add")){    
        if (confirm("<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
                   + "<bean:message key="common.confirm.action" bundle="common"/>" 
                   + "<bean:message key="common.button.create" bundle="common"/>")) {
            setSubmitted();
            
            document.forms[0].operation.value="create";
            document.forms[0].submit();
            
            return true;
        }
   }

    return false;
  
}
//============submit  form for the page of modify==  ==invoked by btnframe==========
function onSetModify(){

    
   if (isSubmitted()) {     
        return false;
   }
   
   if(setOriginalInfo("modify")){
   		var msg = "<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
                   + "<bean:message key="common.confirm.action" bundle="common"/>" 
                   + "<bean:message key="common.button.modify" bundle="common"/>";
   		if(document.forms[0].convert && document.forms[0].convert.checked){
   			msg = "<bean:message key="original.confirm.switch"/>" + "\r\n" + msg;
   		} 
        if (confirm(msg)) {
            setSubmitted();
            document.forms[0].operation.value="modify";
            document.forms[0].submit();        
            return true;
        }
   }
    return false;  
}
//============submit  form for the page of demote==  ==invoked by btnframe==========
function onSetDemote(){    

    if (isSubmitted()) {
        return false;
    }
    
    if (confirm("<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
               + "<bean:message key="common.confirm.action" bundle="common"/>" 
               + "<bean:message key="original.info.h3.demote" />"))  {
        setSubmitted();        
        document.forms[0].operation.value="demote";
        document.forms[0].submit();
        return true;
    }
    return false;  
 }

//============set input to originalInfo===================
//pageType=add or modify
function setOriginalInfo(pageType){
  if(pageType=="modify"){
    return (setBandWidth()&& setReplicaHost());
  }
  else{
    return (setFilesetName()&&setBandWidth()&& setReplicaHost());
  }
}
 
 
 

///===================set  Fileset Name  to originalInfo==================================
function setFilesetName(){  
  var strPrefix=document.forms[0].elements["filesetNamePrefix"].value;
  var strSuffix=document.forms[0].elements["filesetNameSuffix"].value;  
  
  if(!checkFilesetName(strPrefix, strSuffix)){
       document.forms[0].elements["filesetNamePrefix"].focus();
       return false;
    }
    else{
       document.forms[0].elements["originalInfo.filesetName"].value = strPrefix+"#"+strSuffix;
       return true;
    }
    
}
//=====================set  BandWidth to originalInfo==================================
function setBandWidth(){ 
  var value=document.forms[0].txtBandWidth.value;
  var unit=document.forms[0].elements["slctBandWidthUnit"].value ;
  
  if(document.forms[0].chkBandLimit.checked==true){
      if(!checkBandWidth(value, unit)){
        document.forms[0].elements["txtBandWidth"].focus();
        return false;  
      }
      else{
         document.forms[0].elements["originalInfo.bandWidth"].value = getBandWidthValue(value, unit);
      }
  }
  else{
    document.forms[0].elements["originalInfo.bandWidth"].value ="0";
  }
  
 return true;
}
//======set  replica host to oringialInfo================================================== 
function setReplicaHost(){  
  var chkPermitExternalHost=document.forms[0].chkPermitExternalHost;
  var elementHost=document.forms[0].elements["originalInfo.replicaHost"];
  var rdoPermitall=document.getElementById("rdoPermitall");
  var rdoSpecifyHost=document.getElementById("rdoSpecifyHost");
  var strHosts=trim(document.forms[0].txtReplicaHost.value);
  document.forms[0].txtReplicaHost.value = strHosts;

 if(!checkReplicaHost(chkPermitExternalHost,elementHost,rdoPermitall,rdoSpecifyHost,strHosts)){
    document.forms[0].elements["txtReplicaHost"].focus();
    return false;  
 }
 
  return true;
}


//======validate bandwidth==================================================   
    function checkBandWidth(value, unit){
        var iRtnBand=0;        
 
        var invalidCharSet  = /[^0-9]/g;

        if(value==""){
             alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                   +"<bean:message key="original.err.input.bandwidthnull"/>");
             return false;
        }
        
        if(value.search(invalidCharSet)!=-1){
             alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                   +"<bean:message key="original.err.input.bandwidth"/>");
             return false;
        }
  
        iRtnBand=getBandWidthValue(value, unit) ; 
  
        if (iRtnBand<1024||iRtnBand>1073741824){ 
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  +"<bean:message key="original.err.input.bandwidth"/>");           
            return false;
        }
                         
        return true;
    }
    
 //conversion  BandWidth  
 function getBandWidthValue(value, unit)  {  
    var iBandWidth = parseInt(value,10); 
    unit=unit.toUpperCase();
    if (unit=="K"){
        iBandWidth = iBandWidth*1024;
    }else if (unit=="M"){
        iBandWidth = iBandWidth*1024*1024;;
    }else if (unit=="G"){
        iBandWidth = iBandWidth*1024*1024*1024;
    }
    
    return iBandWidth;
 } 
 
 //======validate replica host================================================== 
function checkReplicaHost(chkPermitExternalHost,elementHost,rdoPermitall,rdoSpecifyHost,strHosts){
 
  if(chkPermitExternalHost.checked == 0){
    elementHost.value = "#";
    return true;
  }
               
  if( rdoPermitall.checked == 1){
    elementHost.value = "-a";
    return true;
  }
         
      
  // if there are specified hosts     
  if(rdoSpecifyHost.checked == 1){
    var invalidCharSet  = /[^A-Za-z0-9.\s-]/g;
    
    if(strHosts==""){
         alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
         +"<bean:message key="original.err.input.hostnull"/>"); 
         return false;
    }
    if(strHosts.search(invalidCharSet)!=-1){
         alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
         +"<bean:message key="original.err.input.host"/>"); 
         return false;
    }
   
    var aryHosts=new Array();
    var reg=/\s+/g;
    var charSetNoDigital = /[^0-9]/g;
    aryHosts=strHosts.split(reg);
    
    var countHost=aryHosts.length;
    var countHostNotDuplicate=countHost;
    
    strHosts="";
    
    for(var index=0;index<countHost;index++){            
     
         var tmp=new String(aryHosts[index]);
         if(tmp != "" && tmp.search(charSetNoDigital)==-1){
             alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                  +"<bean:message key="original.err.input.host"/>"); 
             return false;
         }
         
         if(tmp==""){        
          countHostNotDuplicate--;
          continue;              
         }
         else{
            strHosts+=tmp+" ";
         }
         
         if(tmp.length>255){
             alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
             +"<bean:message key="original.err.input.hostlength"/>"); 
             return false;
         }
    
        if(tmp.charAt(0)=="-"||tmp.charAt(0)==".") {
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                +"<bean:message key="original.err.input.host"/>");
                return false;
        }
        
        if(isNotHostnameStr(tmp)){
            if(!is_ipaddr(tmp)){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                +"<bean:message key="original.err.input.host"/>");
                return false;
            }
        }
         for(var i=index+1;i<countHost;i++){
             if(aryHosts[i]==tmp){
                aryHosts[i]="";                  // remove reduplicate host             
             }
         }
   }
  if(countHostNotDuplicate > 254){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
        +"<bean:message key="original.err.input.hostcount"/>"); 
        return false;    
  }
  strHosts=trim(strHosts);
  elementHost.value = strHosts;
  
  return true;
 }
}

//==================================is a valid ip string===================================================
function is_ipaddr(ipAddr){

    var parts = ipAddr.split(".");
    var countParts = parts.length;    

//wrong ipAddr such as  1.2.3  ,but 1.2.3.4.5  or 1.2.3.4.. is ok
    if(countParts < 4){
        return false;
    }

//validate very part of IP
    var IP0 = parseInt(parts[0],10);
    var IP1 = parseInt(parts[1],10);
    var IP2 = parseInt(parts[2],10);
    var IP3 = parseInt(parts[3],10);
    
    if( 0 < IP0 && IP0 < 256  &&  0 <= IP1 && IP1 < 256 &&
        0 <= IP2 && IP2 < 256 &&  0 < IP3 && IP3 < 255     ){
        return true;
    }else{
        return false;
    }

}

//=============is a possible ip string================================================
//=========if hostStr only  has "." or digitals, we think  that hostStr is  a ip string possibly. 
function isNotHostnameStr(hostStr){
 
    var invalidCharSet= /[^.0-9]/g;
 
 //if only . and digitals ===>true
    if(hostStr.search(invalidCharSet) == -1){
        return true;
    }
    
    return false;
}



</script>
