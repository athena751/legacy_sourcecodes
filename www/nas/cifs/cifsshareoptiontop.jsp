<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsshareoptiontop.jsp,v 1.18 2008/12/18 08:15:11 chenbc Exp $" -->

<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<% String exportGroup = NSActionUtil.getExportGroupPath(request);%>
<html>
<head>

<%@include file="../../common/head.jsp" %>

<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript" src="../nas/cifs/cifscommon.js"></script>
<script language="JavaScript">

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="enterCifs.do";
}

function createOrSave(){
    if(isSubmitted() ){
        return false;
    }
    if(!checkAll()) {
        return false;
    }
    
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
  	setSubmitted();
    document.shareOptionForm.submit();
    
}    

function upCaseShareName(){
    document.shareOptionForm.elements["shareOption.shareName"].value=document.shareOptionForm.elements["shareOption.shareName"].value.toUpperCase();
}

function checkAll(){
    <logic:equal name="cifs_shareOptionAction" value="add">
        document.shareOptionForm.elements["shareOption.shareName"].value = trim(document.shareOptionForm.elements["shareOption.shareName"].value);
        if (!checkShareName(document.shareOptionForm.elements["shareOption.shareName"].value)){
            document.shareOptionForm.elements["shareOption.shareName"].focus();
            return false;
        }
    </logic:equal>

    document.shareOptionForm.temppath.value=getCorrectPath(document.shareOptionForm.temppath.value);
    if(!checkTempPath(document.shareOptionForm.temppath.value)){
        document.shareOptionForm.temppath.focus();
        return false;
    }else{
        document.shareOptionForm.elements["shareOption.directory"].value=getFullDirectory(document.shareOptionForm.temppath.value);
    }

    if (!checkComment(document.shareOptionForm.elements["shareOption.comment"].value)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.comment_invalidChar"/>");
        document.shareOptionForm.elements["shareOption.comment"].focus();
        return false;
    }
    
// modified for 0805 cifs limit
    if (!checkNFDLength(document.shareOptionForm.elements["shareOption.comment"].value, 48)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.comment_invalidLen"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.invalidLength.utf8nfd" arg0='48'/>");
        document.shareOptionForm.elements["shareOption.comment"].focus();
        return false;
    }
//

    if ((document.shareOptionForm.elements["shareOption.readOnly"][1].checked)&&(!document.shareOptionForm.sharesnap.checked)){
        document.shareOptionForm.elements["shareOption.writeList"].value=trim(document.shareOptionForm.elements["shareOption.writeList"].value);
        if (!checkUsers(document.shareOptionForm.elements["shareOption.writeList"].value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.writeList_invalid"/>");
            document.shareOptionForm.elements["shareOption.writeList"].focus();
            return false;
        }
    }

    <logic:equal name="cifs_securityMode" value="Share">
        if(document.shareOptionForm.elements["shareOption.settingPassword"].checked){
            if(document.shareOptionForm.elements["shareOption.password_"].value==document.shareOptionForm.defaultValueForPass.value){
                document.shareOptionForm.elements["shareOption.passwordChanged"].value="false";
            }else{
                if (!checkPassword()){
                    return false;
                }
                document.shareOptionForm.elements["shareOption.passwordChanged"].value="true";
            }
            
        }
    </logic:equal>
    
    <logic:notEqual name="cifs_securityMode" value="Share">
        document.shareOptionForm.elements["shareOption.validUser_Group"].value=trim(document.shareOptionForm.elements["shareOption.validUser_Group"].value);
        if (!checkUsers(document.shareOptionForm.elements["shareOption.validUser_Group"].value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                                + "<bean:message key="cifs.alert.validUser_Group_invalid"/>");
            document.shareOptionForm.elements["shareOption.validUser_Group"].focus();
            return false;
        }
    
        document.shareOptionForm.elements["shareOption.invalidUser_Group"].value=trim(document.shareOptionForm.elements["shareOption.invalidUser_Group"].value);
        if (!checkUsers(document.shareOptionForm.elements["shareOption.invalidUser_Group"].value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                                + "<bean:message key="cifs.alert.invalidUser_Group_invalid"/>");
            document.shareOptionForm.elements["shareOption.invalidUser_Group"].focus();
            return false;
        }
    </logic:notEqual>

    document.shareOptionForm.elements["shareOption.hostsAllow"].value=trim(document.shareOptionForm.elements["shareOption.hostsAllow"].value);
    if (!checkHosts(document.shareOptionForm.elements["shareOption.hostsAllow"].value)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.hostsAllow_invalid"/>");
        document.shareOptionForm.elements["shareOption.hostsAllow"].focus();
        return false;
    }

    document.shareOptionForm.elements["shareOption.hostsDeny"].value=trim(document.shareOptionForm.elements["shareOption.hostsDeny"].value);
    if (!checkHosts(document.shareOptionForm.elements["shareOption.hostsDeny"].value)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.hostsDeny_invalid"/>");
        document.shareOptionForm.elements["shareOption.hostsDeny"].focus();
        return false;
    }

    document.shareOptionForm.elements["shareOption.antiVirusForShare"].value = "yes";
    if(!document.shareOptionForm.elements.antiVirus[1].disabled && document.shareOptionForm.elements.antiVirus[1].checked) {
        document.shareOptionForm.elements["shareOption.antiVirusForShare"].value = "no";
    }
    return true;
}

function getCorrectPath(rawPath){
	var tmp = deleteMutipleSlash(rawPath);
    tmp = tmp.replace(/(^[\/\s]*)/g,"");      //delete the first "/" or space
    tmp = tmp.replace(/([\/])$/g,"");         //delete the last "/"
    tmp = tmp.replace(/^[\.]([\.])?$/g,"");   //delete the ".." or "."
    //tmp = tmp.replace(/(\/\.Snap)+$/g,"/.Snap"); //only keep one last "/.Snap"
    return tmp;
}

function checkPassword(){
    if(document.shareOptionForm.elements["shareOption.password_"].value==""){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.password_null"/>");
        return false;
    }
    var invalidChar = /[^\x00-\x7f]/g;
    if(document.shareOptionForm.elements["shareOption.password_"].value.search(invalidChar)!=-1){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.password_invalidChar"/>");
        return false;
    }
    if(document.shareOptionForm.elements["shareOption.password_"].value!=document.shareOptionForm.repeatpassword_.value){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.password_not_same"/>");
        return false;
    }
    return true;
}

function checkShareName(str){
    if (str == "") {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareName_null"/>");
        return false;
    }

    var invalidChar = /[<>|:\;\"\]\[,\/\\\*\?%]/g;
    if ( str.search(invalidChar) != -1){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareName_invalidChar"/>");
        return false;
    }
// modified for 0805 cifs limit   
    if(!checkNFDLength(str, 80)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareName_invalidLen"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.invalidLength.utf8nfd" arg0='80'/>");
        return false;
    }
// 
    str = str.toLowerCase();
    if (str == "global" || str == "homes" || str == "printers"){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareName_useReservedName"/>");
        return false;
    }
    return true;
}

function checkTempPath(str){
    if ((str == "") || (str == ".Snap")){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.path_null"/>");
        return false;
    }

    if(!checkPath4Win(str)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.path_invalidChar"/>");
        return false;
    }

/** omitted for 0805 cifs limit

    if(!checkLength(getFullDirectory(str), 255)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareDir_toolong_wholeDir"/>");
        return false;
    }
    
    var a = new Array();
    a = str.split("/");
    for(var i=0; i< a.length; i++){
        if(a[i]){
            if(!checkLength(a[i], 64)){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.toolong_eachDir"/>");
                return false;
            }
        }
    }
*/ 

    return true;
}

function getFullDirectory(tempPath){
    return ("<%=exportGroup%>" + "/" + tempPath);
}

function enableBottomButton(){
	if(window.parent.frames[1] && window.parent.frames[1].document.forms[0] && window.parent.frames[1].document.forms[0].button_submit){
	  window.parent.frames[1].document.forms[0].button_submit.disabled=0;
	}
}

function initAntiVirusForShare() {
    <logic:equal name="shareOptionForm" property="shareOption.antiVirusForShare" value="yes">
      document.forms[0].elements.antiVirus[0].checked = 1;
      document.forms[0].elements.antiVirus[1].checked = 0;
    </logic:equal>
    <logic:notEqual name="shareOptionForm" property="shareOption.antiVirusForShare" value="yes">
      document.forms[0].elements.antiVirus[0].checked = 0;
      document.forms[0].elements.antiVirus[1].checked = 1;
    </logic:notEqual>

    <logic:notEqual name="<%=CifsActionConst.SESSION_SECURITY_MODE%>" value="<%=CifsActionConst.SECURITYMODE_ADS%>" scope="session">
        document.forms[0].elements.antiVirus[0].disabled = 1;
        document.forms[0].elements.antiVirus[1].disabled = 1;
    </logic:notEqual>
    
    <logic:notEqual name="<%=CifsActionConst.SESSION_HASANTIVIRUSSCAN_LICENSE%>" value="yes" scope="session">
        document.forms[0].elements.antiVirus[0].disabled = 1;
        document.forms[0].elements.antiVirus[1].disabled = 1;
    </logic:notEqual>
}

function init(){
    initTempPath();
    initShareSnap();
    initPassword();
    changetext();
    setHelpAnchor(document.shareOptionForm.helpLocation.value);
    initAntiVirusForShare();
    displayAlert();
    enableBottomButton();
    <logic:equal name="alertForDMAPI" value="true">
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
               + "<bean:message key="cifs.alert.alertForDMAPI"/>");
        <%session.setAttribute("alertForDMAPI", null);%>
        return false;
    </logic:equal>

    <logic:equal name="alert_setDirAccessFor_sxfsfw" value="true">
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
               + "<bean:message key="cifs.alert.setDirAccessFor_sxfsfw"/>");
		 <%session.setAttribute("alert_setDirAccessFor_sxfsfw", null);%>				               
        return false;
    </logic:equal>
    
    
     <logic:equal name="shadowCopy_alert" value="true">
    	<logic:equal name="setGlobal_alert" value="true">
	        alert('<bean:message key="cifs.alert.usedShadowCopy_andSetGlobalOption"/>');
    	</logic:equal>
    	<logic:notEqual name="setGlobal_alert" value="true">
	        alert('<bean:message key="cifs.alert.usedShadowCopy"/>');
    	</logic:notEqual>	
        	<%session.setAttribute("setGlobal_alert", null);%>	
	        <%session.setAttribute("shadowCopy_alert", null);%>	
     </logic:equal>
     //shadow copy value: "no" -> "yes",filetimes value: "no" -> "yes"

     <logic:equal name="shadowCopy_alert" value="false">	
	     <logic:equal name="setGlobal_alert" value="true">
		     alert('<bean:message key="cifs.alert.SetGlobalOption"/>');
	     </logic:equal>
	     <logic:notEqual name="setGlobal_alert" value="true">
		     alert('<bean:message key="common.alert.done"  bundle="common"/>');
	     </logic:notEqual>
	     <%session.setAttribute("setGlobal_alert", null);%>
	     <%session.setAttribute("shadowCopy_alert", null);%>
     </logic:equal> 
     //shadow copy value: "no" -> "yes",filetimes value: "yes" -> "yes"
  
	  <logic:equal name="setGlobal_alert" value="true">
		   alert('<bean:message key="cifs.alert.SetGlobalOption"/>');
		  <%session.setAttribute("setGlobal_alert", null);%>
	  </logic:equal>   
	  //shadow copy value: "yes" -> "yes"
	  //shadow copy value: "yes" -> "no","no" -> "no",was deal with in action.
    
    <logic:equal name="need_snapshot_confirm" value="true">
        if(confirm("<bean:message key="cifs.confirm.toSetSnapSchedule"/>")){
            //go to the [snapshot schedule] page
            setSubmitted();
            //window.location="setShare.do?operation=addSnapshotSchedule";
            var targetNode = top.CONTROLL.document.forms[0].elements["nodeInfo.target"].value;
            window.parent.parent.location="/nsadmin/menu/nas/snapshot/snapSchedule.jsp?fromWhere=cifs&target="+targetNode;
        }else{
            //go to the [share list] page
            setSubmitted();
            window.parent.location="shareList.do?operation=enterCIFS";
        }
       <%session.setAttribute("need_snapshot_confirm", null);%>	 
    </logic:equal>
    <logic:equal name="cifs_securityMode" value="Share">
        if(document.shareOptionForm.elements["shareOption.writeList"]){
            document.shareOptionForm.elements["shareOption.writeList"].value="";
        }
    </logic:equal>
    
  //added for 0805 cifs limit
    <logic:equal name="<%=CifsActionConst.SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING%>" value="yes">
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" 
              + "<bean:message key="cifs.alert.invalidLength.fullPath.over1000"/>" + "\r\n"
              + "<bean:message key="cifs.alert.invalidLength.exportEncoding"/>");
        document.shareOptionForm.temppath.focus();
        <%session.setAttribute(CifsActionConst.SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING, null);%>
    </logic:equal>
  //
}

function initTempPath(){
    var exportGroup = "<%=exportGroup%>"+"/";
    var fullPath = document.shareOptionForm.elements["shareOption.directory"].value;
    if(fullPath.indexOf(exportGroup)==0 && fullPath.length>exportGroup.length){
        document.shareOptionForm.temppath.value = fullPath.substring(exportGroup.length, fullPath.length);
    }
}

function initShareSnap(){
    
    var path=document.shareOptionForm.temppath.value;
    var hasSnap=path.lastIndexOf("/.Snap");
    if ((hasSnap != -1) && (hasSnap==path.length-6)){
        document.shareOptionForm.sharesnap.checked=true;
        blurReadWrite();
        disableShadowCopy();
    }else {
        document.shareOptionForm.sharesnap.checked=false;
        enableReadWrite();
        enableShadowCopy();
    }
}

function showShareSnap(){
    if (trim(document.shareOptionForm.temppath.value)=="") {
        document.shareOptionForm.sharesnap.checked=false;
        return false;
    }
    document.shareOptionForm.temppath.value=getCorrectPath(document.shareOptionForm.temppath.value);
    if (document.shareOptionForm.sharesnap.checked){
        document.shareOptionForm.temppath.value=document.shareOptionForm.temppath.value + "/.Snap";
        //document.shareOptionForm.temppath.value=document.shareOptionForm.temppath.value.replace(/(\/\.Snap)+$/g,"/.Snap");
        blurReadWrite();
        disableShadowCopy();
    }else {
        document.shareOptionForm.temppath.value=document.shareOptionForm.temppath.value.replace(/(\/\.Snap)$/g,"");
        enableReadWrite();
        enableShadowCopy();
    }
}

function blurReadWrite(){
    document.shareOptionForm.elements["shareOption.readOnly"][1].checked=true;
    document.shareOptionForm.elements["shareOption.readOnly"][0].checked=false;
    document.shareOptionForm.elements["shareOption.readOnly"][0].disabled=true;
    document.shareOptionForm.elements["shareOption.writeList"].disabled=true;
}

function enableReadWrite(){
    document.shareOptionForm.elements["shareOption.readOnly"][0].disabled=false;
    if (document.shareOptionForm.elements["shareOption.readOnly"][1].checked){
        document.shareOptionForm.elements["shareOption.writeList"].disabled=false;
    }
}


function changetext(){
    if (document.shareOptionForm.sharesnap.checked==true){
        document.shareOptionForm.elements["shareOption.readOnly"][1].checked=true;
        return;
    }
    if (document.shareOptionForm.elements["shareOption.readOnly"][1].checked){
        document.shareOptionForm.elements["shareOption.writeList"].disabled=false;
    }else{
        document.shareOptionForm.elements["shareOption.writeList"].disabled=true;
    }
}

function enableWriteList(flag) {
    if (document.shareOptionForm.sharesnap.checked==true){
        document.shareOptionForm.elements["shareOption.readOnly"][1].checked=true;
        return;
    }
    if(flag == "1") {
        document.shareOptionForm.elements["shareOption.writeList"].disabled=false;
    } else {
        document.shareOptionForm.elements["shareOption.writeList"].disabled=true;
    }
}

function changePasswdStatus(){
    <logic:equal name="cifs_securityMode" value="Share">
        if (document.shareOptionForm.elements["shareOption.settingPassword"].checked){
            document.shareOptionForm.elements["shareOption.password_"].disabled=false;
            document.shareOptionForm.repeatpassword_.disabled=false;
        }else{
            document.shareOptionForm.elements["shareOption.password_"].disabled=true;
            document.shareOptionForm.repeatpassword_.disabled=true;
        }
    </logic:equal>
    
   return false;
}

function initPassword(){
    <logic:equal name="cifs_securityMode" value="Share">
        if (document.shareOptionForm.elements["shareOption.settingPassword"].checked){
            <logic:equal name="cifs_shareOptionAction" value="modify">
            if((document.shareOptionForm.elements["shareOption.userName"].value != "")
                && (document.shareOptionForm.elements["shareOption.password_"].value == "")
              ){
                document.shareOptionForm.elements["shareOption.password_"].value=document.shareOptionForm.defaultValueForPass.value;
            }
            </logic:equal>
            document.shareOptionForm.repeatpassword_.value=document.shareOptionForm.elements["shareOption.password_"].value;
        }
        changePasswdStatus();
    </logic:equal>
    
   return false;
}

function modifyPassShow(){
    <logic:equal name="cifs_securityMode" value="Share">
        if((document.shareOptionForm.elements["shareOption.password_"].value==document.shareOptionForm.defaultValueForPass.value)
            ||(document.shareOptionForm.repeatpassword_.value==document.shareOptionForm.defaultValueForPass.value)){
            document.shareOptionForm.elements["shareOption.password_"].value="";
            document.shareOptionForm.repeatpassword_.value="";
        }
    </logic:equal>
}

function disableShadowCopy(){
    document.shareOptionForm.elements["shareOption.shadowCopy"].checked=false;
    document.shareOptionForm.elements["shareOption.shadowCopy"].disabled=true;
}

function enableShadowCopy(){
    document.shareOptionForm.elements["shareOption.shadowCopy"].disabled=false;
}

var pupUpWinName;
function onNavigator(){
    if (pupUpWinName == null || pupUpWinName.closed){
        window.mpPath = document.shareOptionForm.temppath;
        document.sharePathForm.nowDirectory.value=compactPath(getFullDirectory(getCorrectPath(document.shareOptionForm.temppath.value)));
        pupUpWinName = window.open("/nsadmin/common/commonblank.html","selectSharePath_navigator",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=500,height=500");
        document.sharePathForm.submit();
    }else{
        pupUpWinName.focus();
    }
}
function checkLength4Cifs(str, maxlen) {
    str = str.replace(/[^\x00-\x7f\uff61-\uff9f]/g, "  ");
    return (str.length <= maxlen);
}

</script>
</head>

<body onload="init();" onUnload="closeDetailErrorWin();closePopupWin(pupUpWinName);">
<html:form action="setShare.do" method="post" onsubmit="return createOrSave();">
<nested:nest property="shareOption">
<nested:hidden property="oldshadowCopy" />
<nested:hidden property="oldFileTimes" />
<html:button property="goBack" onclick="return onBack()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<br /><br />
<displayerror:error h1_key="cifs.common.h1"/>
<br />
<input type="hidden" name="operation" value="addOrmodify_Share">
<logic:equal name="cifs_shareOptionAction" value="add">
    <h3 class="title"><bean:message key="cifs.shareOption.h2_add"/></h3>
    <input type="hidden" name="shareOption.settingOperation" value="add">
    <input type="hidden" name="helpLocation" value="network_cifs_3">
</logic:equal>
<logic:equal name="cifs_shareOptionAction" value="modify">
    <h3 class="title"><bean:message key="cifs.shareOption.h2_modify"/></h3>
    <input type="hidden" name="shareOption.settingOperation" value="modify">
    <input type="hidden" name="helpLocation" value="network_cifs_4">
</logic:equal>
    <input type="hidden" name="helpLocation_navigator" value="network_cifs_7">

  <table border="1" class="Vertical">
  <tr><th><bean:message key="cifs.shareOption.th_sharename"/></th>
  <td>
    <logic:equal name="cifs_shareOptionAction" value="add">
        <nested:text property="shareName" size="24" maxlength="80" onblur="upCaseShareName();"/>
    </logic:equal>
    <logic:equal name="cifs_shareOptionAction" value="modify">
        <nested:define id="shareName_td" property="shareName" type="java.lang.String"/>
        <%=NSActionUtil.sanitize(shareName_td)%>
        <nested:hidden property="shareName"/>
    </logic:equal>
  </td>
  </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_connection"/></th>
      <td>
          <nested:checkbox property="connection" styleId="available" value="yes"/>
          <label for="available"><bean:message key="cifs.shareOption.checkbox_available"/></label>
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_directory"/></th>
      <td nowrap>
       <%=exportGroup%>/
       <input type="text" name="temppath" size="48" value="" onblur="initShareSnap();" maxlength="1000"/>
       <nested:hidden property="directory"/>
       <html:button property="button_browse" onclick="onNavigator();">
        <bean:message key="common.button.browse2" bundle="common"/>
       </html:button>
       <br>
        <input type="checkbox" name="sharesnap" id="sharesnapD1"
          onclick="return showShareSnap()">
          <label for="sharesnapD1">
              <bean:message key="cifs.shareOption.checkbox_sharesnap"/>
          </label>
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_comment"/></th>
      <td>
        <nested:text property="comment" size="64" maxlength="48"/>
      </td>
    </tr>

    <tr>
      <th><bean:message key="cifs.shareOption.th_accessMode"/></th>
      <td>
        <table border="0">
          <tr>
            <td>
              <nested:radio property="readOnly" styleId="label_rw" value="no" onclick="enableWriteList('0')"/>
              <label for="label_rw"><bean:message key="cifs.shareOption.radio_rw"/></label>
            </td>
          </tr>
          <tr>
            <td>
              <nested:radio property="readOnly" styleId="label_ro" value="yes" onclick="enableWriteList('1')"/>
              <label for="label_ro"><bean:message key="cifs.shareOption.radio_ro"/></label>
           <logic:notEqual name="cifs_securityMode" value="Share">
           <!-- when share domain, hide the following four tags -->
            </td>
          </tr>
          <tr>
            <td>
            <div id="div_writeList">
           </logic:notEqual>
           <logic:equal name="cifs_securityMode" value="Share">
             <div id="div_writeList" style="display:none;">
           </logic:equal>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <bean:message key="cifs.shareOption.td_wl"/>
              <nested:text property="writeList" maxlength="128" size="36"
                  onfocus="if (this.disabled) this.blur();"/>
            </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <logic:equal name="cifs_securityMode" value="Share">
    <tr>
      <th><bean:message key="cifs.shareOption.th_password"/></th>
      <td>
        <table border="0">
         <tr>
            <td nowrap colspan="2">
              <nested:checkbox property="settingPassword" styleId="usePasswdID1"  value="yes" onclick="changePasswdStatus()"/>
              <label for="usePasswdID1"><bean:message key="cifs.shareOption.checkbox_setPass"/></label>
              <input type="hidden" name="defaultValueForPass" value="&#127;&#127;&#127;&#127;&#127;&#127;">
              <nested:hidden property="userName"/>
              <nested:hidden property="passwordChanged"/>
            </td>
            <td></td>
         </tr>
         <tr>
            <td nowrap>
              &nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="cifs.shareOption.td_pass1"/>
            </td>
            <td><nested:password property="password_" maxlength="14" onfocus="modifyPassShow();if(this.disabled) this.blur();"/></td>
         </tr>
         <tr>
            <td nowrap>
              &nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="cifs.shareOption.td_pass2"/>
            </td>
            <td><input type="password" name="repeatpassword_" value="" maxlength="14"
                onfocus="modifyPassShow();if (this.disabled) this.blur();" >
            </td>
         </tr>
        </table>
      </td>
    </tr>

    </logic:equal>
    <logic:notEqual name="cifs_securityMode" value="Share">
    <tr>
      <th><bean:message key="cifs.shareOption.th_validusers"/></th>
      <td>
        <nested:text property="validUser_Group" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_invalidusers"/></th>
      <td>
        <nested:text property="invalidUser_Group" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </td>
    </tr>
    </logic:notEqual>

    <logic:equal name="cifs_securityMode" value="Share">
        <nested:hidden property="validUser_Group" />
        <nested:hidden property="invalidUser_Group" />
    </logic:equal>

    <tr>
      <th><bean:message key="cifs.shareOption.th_hostsallow"/></th>
      <td>
        <nested:text property="hostsAllow" size="64" maxlength="200"/>
       <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_hostsdeny"/></th>
      <td>
        <nested:text property="hostsDeny" size="64" maxlength="200"/>
       <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.antiVirus"/></th>
      <td>
        <nested:hidden property="antiVirusForShare"/>
        <input type="radio" name="antiVirus" id="id_antiVirus0" value="yes"/>
        <label for="id_antiVirus0">
          <bean:message key="cifs.shareOption.antiVirusForGlobal.follow_global"/>
        </label>
        <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <bean:message key="cifs.shareOption.antiVirusForGlobal.current_setting"/>
        <nested:equal property="antiVirusForGlobal" value="yes">
          <bean:message key="cifs.antiVirus.current.enabled"/>
        </nested:equal>
        <nested:notEqual property="antiVirusForGlobal" value="yes">
          <bean:message key="cifs.antiVirus.current.disabled"/>
        </nested:notEqual><br>
        <input type="radio" name="antiVirus" id="id_antiVirus1" value="no"/>
        <label for="id_antiVirus1">
          <bean:message key="cifs.share.antiVirus"/>
        <label>
        <nested:hidden property="antiVirusForGlobal"/>
      </td>
    </tr>

    <tr>
      <th><bean:message key="cifs.common.th_otherOption"/></th>
      <td>
        <!--<nested:checkbox property="serverProtect" styleId="serverProtect"  value="yes"/>
        <label for="serverProtect"><bean:message key="cifs.shareOption.checkbox_useServerProtect"/></label>
        <br>-->
        <nested:checkbox property="shadowCopy" styleId="shadowCopy"  value="yes"/>
        <label for="shadowCopy"><bean:message key="cifs.shareOption.checkbox_useShadowCopy"/></label>
        <br>
        <nested:checkbox property="dirAccessControlAvailable" styleId="dirAccessControlAvailable" value="yes"/>
        <label for="dirAccessControlAvailable">
            <bean:message key="cifs.shareOption.checkbox_dirAccessControlAvailable"/>
        </label>
        <logic:notEqual name="cifs_securityMode" value="Share">
            <br />
            <nested:checkbox property="pseudoABE" styleId="abeAvailable" value="yes" />
            <label for="abeAvailable">
                <bean:message key="cifs.shareOption.checkbox_ABE"/>
            </label>
        </logic:notEqual>
      </td>
    </tr>
  </table><br>

</nested:nest>
</html:form>
<form name="sharePathForm" action="CSNavigatorList.do" target="selectSharePath_navigator" method="post">
<input type="hidden" name="operation" value="callShare">
<input type="hidden" name="rootDirectory" value="<%=exportGroup%>">
<input type="hidden" name="nowDirectory" value="">
</form>
</body>
</html> 
 