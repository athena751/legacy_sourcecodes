<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicationcommon.jsp,v 1.2 2005/10/12 00:44:33 jiangfx Exp $" -->

<script language="JavaScript">
// display replica list
function loadReplicaList() {
    if (isSubmitted()) {
        return false;
    }
    
    setSubmitted();
    window.location="<html:rewrite page='/replicaList.do?operation=display'/>";
    return true;
}

// display SSL info
function loadSsl(){
    if (isSubmitted()){
        return false;
     }
     setSubmitted();
     window.location="/nsadmin/replication/ssl.do?operation=display";
     return true;
}

// set btnframe with blank page when bottomframe unloading
function unloadBtnFrame() {
    if (parent.btnframe){
        parent.btnframe.location="/nsadmin/common/commonblank.html";
    }    
}

//==============open botton frame and change botton's disable attribute which is in btnframe====================================================
function loadSubmitPage(isDisableBtn){
  if(parent.btnframe)    {
       setTimeout('parent.btnframe.location="/nsadmin/replication/forwardSubmit.do?disableFlag='+isDisableBtn+'"',1);
    }    
}

// load page include [execute] button
function loadExecutePage(){
    if (parent.btnframe) {
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/forwardExecute.do"/>' + '"', 1);
    }   
}

// check the fileset name's validation and length
function checkFilesetName(filesetPreffix, filesetSuffix){

    if(filesetPreffix==""){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="original.err.input.filesetnamenull"/>");
        return false;
    }
    
    var invalidCharSet  = /[^A-Za-z0-9.#_-]/g;
    if(filesetPreffix.search(invalidCharSet)!=-1){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.fileset.invalid"/>");
        return false;
    }

    if(filesetPreffix.charAt(0)=="-"||filesetPreffix.charAt(0)==".") {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.fileset.invalid"/>");
        return false;
    }
    
    var fset = new String(filesetPreffix + "#" + filesetSuffix);
    if(fset.length>255){
       alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.fileset.toolang"/>");
       return false;
    }

    return true;
}

function checkServerName(hostName){
    
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
</script>