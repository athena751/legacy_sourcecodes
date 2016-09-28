<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsglobaloptiontop.jsp,v 1.14 2008/12/18 08:15:11 chenbc Exp $" -->

<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript" src="../nas/cifs/cifscommon.js"></script>
<script language="JavaScript">
var elements;

function onReload(){
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    window.parent.location="loadGlobalFrame.do";
    return true; 
}
function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="shareList.do?operation=enterCIFS";
}

function initAntiVirusForGlobal() {
    <logic:equal name="globalForm" property="info.antiVirusForGlobal" value="yes">
      elements.antiVirus.checked = 1;
    </logic:equal>
    <logic:notEqual name="globalForm" property="info.antiVirusForGlobal" value="yes">
      elements.antiVirus.checked = 0;
    </logic:notEqual>
    <logic:notEqual name="<%=CifsActionConst.SESSION_SECURITY_MODE%>" value="<%=CifsActionConst.SECURITYMODE_ADS%>" scope="session">
        elements.antiVirus.disabled = 1;
    </logic:notEqual>
    <logic:notEqual name="<%=CifsActionConst.SESSION_HASANTIVIRUSSCAN_LICENSE%>" value="yes" scope="session">
        elements.antiVirus.disabled = 1;
    </logic:notEqual>
}

function init(){
    elements = document.forms[0].elements;
    initEncryptPasswd();
    initUseLogBox();
    initAntiVirusForGlobal();
    displayAlert();
    enableBottomButton();
    setHelpAnchor('network_cifs_2');
    <logic:empty name="cifs_nicList">
        <logic:equal name="globalForm" property="info.reasonForNoInterface" value="<%=CifsActionConst.CONST_NO_SERVICE_NETWORK%>">
              alert("<bean:message key="cifs.alert.availableServiceNIC_null"/>");
              return false;
        </logic:equal>
        <logic:equal name="globalForm" property="info.reasonForNoInterface" value="<%=CifsActionConst.CONST_NO_REMAINING_INTERFACE%>">
              alert("<bean:message key="cifs.alert.remainingServiceNIC_null"/>");
              return false;
        </logic:equal>
    </logic:empty>
    adviceWhenLogFileInWrongArea();
}

function enableBottomButton(){
	if(window.parent.frames[1] &&window.parent.frames[1].document.globalBottomForm && window.parent.frames[1].document.forms[0].button_submit){
        <logic:empty name="cifs_nicList">
            window.parent.frames[1].document.forms[0].button_submit.disabled=1;
        </logic:empty>
        <logic:notEmpty name="cifs_nicList">
            window.parent.frames[1].document.forms[0].button_submit.disabled=0;
        </logic:notEmpty>
	}
}


function adviceWhenLogFileInWrongArea(){
    <logic:equal name="globalForm" property="info.logFileInRightArea"  value="no">
        alert("<bean:message key="cifs.alert.logFileInWrongArea"/>");
        elements["info.alogFile"].focus();
    </logic:equal>
}

function initEncryptPasswd(){
    if (elements["info.encryptPasswords"].value == "yes"){
        elements["encpasswd"].checked = true;
    }else{
        elements["encpasswd"].checked = false;
    }
    <logic:equal name="cifs_securityMode" value="LDAP">
        elements["encpasswd"].disabled = false;
    </logic:equal>
}

function initUseLogBox(){
    if (elements["info.alogFile"].value != ""){
        elements["useLogBox"].checked = true;
    }else{
        elements["useLogBox"].checked = false;
    }
    if(elements["useAccessLog"].value == "yes"){
        elements["useLogBox"].disabled = true;
    }else{
        elements["useLogBox"].disabled = false;    
    }    
    changeUseLogStatus();
}

function changeUseLogStatus(){
    if (elements["useLogBox"].checked){
        disableLogForm(false);
    }else{
        disableLogForm(true);    
    }
}

function disableLogForm(status){
    elements["info.alogFile"].disabled = status;
    elements["info.canReadLog"].disabled = status;
    elements["info.successLoggingItems"][0].disabled = status;
    elements["info.successLoggingItems"][1].disabled = status;
    elements["info.errorLoggingItems"][0].disabled = status;
    elements["info.errorLoggingItems"][1].disabled = status;
    elements["button_browse"].disabled = status;
}

function changeEncryptPasswd(){
    if (elements["info.ldapAnonymous"].value == "yes"){
       elements["encpasswd"].checked = false;
       alert("<bean:message key="cifs.alert.cannot_encpasswd"/>");
       return false;
    }
    var chkboxStatus = elements["encpasswd"].checked;
    elements["info.encryptPasswords"].value = (chkboxStatus ? "yes" : "no");
}

function onSet(){
    if(isSubmitted()){
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
    document.forms[0].submit();
}

function checkAll(){
    if (elements["info.interfaces"]){
        if(elements["info.interfaces"].selectedIndex
           && elements["info.interfaces"].selectedIndex == -1){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                   + "<bean:message key="cifs.alert.null_interface"/>");
            elements["info.interfaces"].focus();
            return false;
        }
    }else{
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                + "<bean:message key="cifs.alert.up_nic_first"/>");
        return false;        
    }
    
    if (!checkComment(elements["info.serverString"].value)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.comment_invalidChar"/>");
        elements["info.serverString"].focus();
        return false;
    }
// modified for 0805 cifs limit
    if (!checkNFDLength(elements["info.serverString"].value, 48)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
            + "<bean:message key="cifs.alert.comment_invalidLen"/>" + "\r\n"
            + "<bean:message key="cifs.alert.invalidLength.utf8nfd" arg0='48'/>");
        elements["info.serverString"].focus();
        return false;
    }
//
    elements["info.deadtime"].value = trim(elements["info.deadtime"].value);
    if (elements["info.deadtime"].value == ""){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.deadtime_null"/>");
        elements["info.deadtime"].focus();
        return false;        
    }
    if (!checkDeadtime(elements["info.deadtime"].value)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.invalid_deadtime"/>");
        elements["info.deadtime"].focus();
        return false;
    }
    if (elements["info.deadtime"].value.length > 1){
        elements["info.deadtime"].value = elements["info.deadtime"].value.replace(/^0/,"");
    }
    
    <logic:notEqual name="cifs_securityMode" value="Share">
         elements["info.validUsers"].value = trim(elements["info.validUsers"].value);
         if (!checkUsers(elements["info.validUsers"].value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                                + "<bean:message key="cifs.alert.validUser_Group_invalid"/>");
            elements["info.validUsers"].focus();
            return false;
        }
    
        elements["info.invalidUsers"].value = trim(elements["info.invalidUsers"].value);
        if (!checkUsers(elements["info.invalidUsers"].value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                                + "<bean:message key="cifs.alert.invalidUser_Group_invalid"/>");
            elements["info.invalidUsers"].focus();
            return false;
        }
    </logic:notEqual>
    
    elements["info.hostsAllow"].value = trim(elements["info.hostsAllow"].value);
    if (!checkHosts(elements["info.hostsAllow"].value)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.hostsAllow_invalid"/>");
        elements["info.hostsAllow"].focus();
        return false;
    }

    elements["info.hostsDeny"].value = trim(elements["info.hostsDeny"].value);
    if (!checkHosts(elements["info.hostsDeny"].value)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.hostsDeny_invalid"/>");
        elements["info.hostsDeny"].focus();
        return false;
    }
    if (elements["useLogBox"].checked){
	    var logFile = trim(elements["info.alogFile"].value);
	    logFile = getRealPath(logFile);
	    logFile = logFile.replace(/([\/]+)/g,"/");
	    logFile = logFile.replace(/([\/])$/g,"");
	    //add by key to process the relative path "/../","/./"
	    elements["info.alogFile"].value = logFile;
	    var ret = checkLogFile(elements["info.alogFile"].value);
	    if (ret != 0){
		    if (ret == 1){
	            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                + "<bean:message key="cifs.alert.logfile_null"/>");	    
		    }else if (ret == 2){
	            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                + "<bean:message key="cifs.alert.logfile_invalid"/>");	    
		    }else if (ret == 3){
	            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                + "<bean:message key="cifs.alert.logfile_relativepath"/>");	    
		    }else if (ret == 4){
	        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
	                + "<bean:message key="cifs.alert.logfile"/>" + "\r\n"
	                + "<bean:message key="cifs.alert.invalidLogFileNameLength" arg0='240'/>");    
		    }
		    elements["info.alogFile"].focus();
		    return false;
	    }
    }    
    if(elements.antiVirus.disabled) {
       elements["info.antiVirusForGlobal"].value = ""; 
    } else {
        if(elements.antiVirus.checked) {
            elements["info.antiVirusForGlobal"].value = "yes";
        } else {
            elements["info.antiVirusForGlobal"].value = "no";
        }
    }
    return true;
}

function checkDeadtime(str){
    var invalid = /[^0-9]/g;
    if(str.search(invalid) != -1){
        return false;
    }
    var time = parseInt(str,10);
    if (time > 60){
        return false;
    }
    return true;
}

function checkLogFile(str){
    if(str == ""){
        return 1;
    }
    if(!checkPath4Win(str)){
        return 2;
    }
    if(str.charAt(0) != '/'){
        return 3;
    }    
    if(!checkLength(str, 240)){
        return 4;
    }
    if((str.search(/[^\x00-\x7f]/) != -1)){
        return 2;
    }
    return 0;
}

var pupUpWinName;
function onNavigator(){
    if (pupUpWinName == null || pupUpWinName.closed){
    	
    	var tmpLog = elements["info.alogFile"].value;
        tmpLog = getRealPath(tmpLog);
        elements["info.alogFile"].value = tmpLog;
  	
        window.mpPath = elements["info.alogFile"];
        var nowDir = compactPath(elements["info.alogFile"].value);
        nowDir = trim(nowDir);
        if (nowDir == "" || nowDir.charAt(0) != '/'){
            nowDir = "/";
        }
        document.logPathForm.nowDirectory.value = nowDir;
        pupUpWinName = window.open("/nsadmin/common/commonblank.html","selectLogPath_navigator",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
        document.logPathForm.submit();
    }else{
        pupUpWinName.focus();
    }
}
</script>
</head>
<body onload="init();" onUnload="closeDetailErrorWin();closePopupWin(pupUpWinName);">
<html:form action="setGlobal.do?operation=set" >
<nested:nest property="info">
	<html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    <br /><br />
    <displayerror:error h1_key="cifs.common.h1"/>
    <br />
<h3 class="title"><bean:message key="cifs.globalOption.h3_basic"/></h3>
    <table border="1" class="Vertical">
      <tr>
        <th><bean:message key="cifs.globalOption.th_encoding"/></th>
        <td><%String encodingKey = "cifs.encoding.";
              String encode = NSActionUtil.getExportGroupEncoding(request);
              if(encode.equals(NSActionConst.ENCODING_UTF_8)){
                  encodingKey += encode + "." + NSActionUtil.getSessionAttribute(request, "machineSeries");
              }else{
                  encodingKey += encode;
              }%>
            <bean:message key="<%=encodingKey%>"/>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_security"/></th>
        <td>
            <bean:define id="secMode" name="cifs_securityMode"/>
            <%String secModeKey = "cifs.security." + secMode;%>
            <bean:message key="<%=secModeKey%>"/>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_encryptpasswd"/></th>
        <td>
            <input type="checkbox" name="encpasswd" value="yes" id="encpasswdbox" onclick="changeEncryptPasswd()" disabled>
             <label for="encpasswdbox">
                <bean:message key="cifs.globalOption.use"/>
             </label>
            <nested:hidden property="encryptPasswords"/>
            <nested:hidden property="ldapAnonymous"/>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_interfaces"/></th>
        <td>
            <logic:notEmpty name="cifs_nicList">
              <table border="0">
                <tr>
                  <td>
                    <nested:select property="interfaces" multiple="true" size="4">
                        <nested:options name="cifs_nicList" labelName="cifs_nicLabelList"/>
                    </nested:select>
                    </td>
                    <td valign="top"><bean:message key="cifs.globalOption.currentsetting"/></td>
                    <td valign="top">
                    <nested:empty property="interfaces">
                        <bean:message key="cifs.globalOption.nic_not_specified"/>
                    </nested:empty>
                    <nested:notEmpty property="interfaces">
                        <nested:iterate id="nic" property="interfaces">
                            <bean:write name="nic"/><br>
                        </nested:iterate>
                    </nested:notEmpty>                  
                  </td>
                </tr>
              </table>
              [<font class="advice"><bean:message key="cifs.globalOption.nic_note"/></font>]
            </logic:notEmpty>
            <logic:empty name="cifs_nicList">
                <table border="0">
                <tr>
                    <td valign="top"><bean:message key="cifs.globalOption.currentsetting"/></td>
                    <td valign="top">
                    <nested:empty property="interfaces">
                        <bean:message key="cifs.globalOption.nic_not_specified"/>
                    </nested:empty>
                    <nested:notEmpty property="interfaces">
                        <nested:iterate id="nic" property="interfaces">
                            <bean:write name="nic"/><br>
                        </nested:iterate>
                    </nested:notEmpty>                  
                  </td>
                </tr>
              </table>
                
            </logic:empty>
         </td>
      <tr>
        <th><bean:message key="cifs.globalOption.th_comment"/></th>
        <td><nested:text property="serverString" size="64" maxlength="48"/></td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_deadtime"/></th>
        <td>
            <nested:text property="deadtime" size="3" maxlength="2"/>
            <bean:message key="cifs.globalOption.minutes"/>
        </td>
      </tr>
      <logic:notEqual name="cifs_securityMode" value="Share">
	      <tr>
	        <th><bean:message key="cifs.globalOption.th_validusers"/></th>
	        <td><nested:text property="validUsers" size="64" maxlength="200"/>
	        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]</td>
	      </tr>
	      <tr>
	        <th><bean:message key="cifs.globalOption.th_invalidusers"/></th>
	        <td><nested:text property="invalidUsers" size="64" maxlength="200"/>
	         <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
	        </td>
	      </tr>
      </logic:notEqual>      
      <tr>
        <th><bean:message key="cifs.globalOption.th_hostsallow"/></th>
        <td><nested:text property="hostsAllow" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_hostsdeny"/></th>
        <td><nested:text property="hostsDeny" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
        </td>
      </tr>
      <tr>
      	<th><bean:message key="cifs.antiVirus"/></th>
      	<td>
      	  <nested:hidden property="antiVirusForGlobal"/>
      	  <input type="checkbox" name="antiVirus" id="id_antiVirus" value="yes"/>
      	  <label for="id_antiVirus">
      	    <bean:message key="cifs.global.antiVirus"/>
      	  </label>
      	  <br>[<font class="advice"><bean:message key="cifs.global.setRealtime_scan"/></font>]
      	</td>
      </tr>
      <tr>
      <th><bean:message key="cifs.common.th_otherOption"/></th>
      <td>
        <nested:checkbox property="dirAccessControlAvailable" styleId="dirAccessControlAvailable"
          value="yes" />
        <label for="dirAccessControlAvailable">
            <bean:message key="cifs.globalOption.checkbox_dirAccessControlAvailable"/>
        </label>
      </td>
    </tr>
    </table>
<h3 class="title"><bean:message key="cifs.globalOption.h3_accesslog"/></h3>
    <input type="checkbox" name="useLogBox" value="on" id="logbox" onclick="changeUseLogStatus()">
    <html:hidden property="useAccessLog"/>
    <label for="logbox"><bean:message key="cifs.globalOption.useaccesslog"/></label>
    <table border="1" class="Vertical">
      <tr>
        <th><bean:message key="cifs.globalOption.th_logfile"/></th>
        <td><nested:text property="alogFile" size="64" maxlength="240"/>
            <html:button property="button_browse" onclick="onNavigator();">
                <bean:message key="common.button.browse2" bundle="common"/>
            </html:button><br>
            <nested:checkbox property="canReadLog" value="yes" styleId="canReadBox"/>
            <label for="canReadBox">
            <bean:message key="cifs.globalOption.canread"/><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[<font class="advice" ><bean:message key="cifs.globalOption.canread2"/></font>]
            </label>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_logitem"/></th>
        <td><table border="0">
            <tr>
              <td align="center"><bean:message key="cifs.common.success"/></td>
              <td align="center"><bean:message key="cifs.common.error"/></td>
              <td></td>
            </tr>
                <logic:iterate name="cifs_globalLogItemMap" id="item">
                    <tr>
                    <td align="center">
                    <nested:multibox property="successLoggingItems">
                        <bean:write name="item" property="key"/>
                    </nested:multibox>
                    </td>
                    <td align="center">
                    <nested:multibox property="errorLoggingItems">
                        <bean:write name="item" property="key"/>
                    </nested:multibox>
                    </td>
                    <td><bean:message name="item" property="value"/></td>
                    </tr>
                </logic:iterate>
            </table></td>
      </tr>
    </table>

</nested:nest>
</html:form>
<form name="logPathForm" action="CGNavigatorList.do" target="selectLogPath_navigator" method="post">
<input type="hidden" name="operation" value="callGlobal">
<input type="hidden" name="rootDirectory" value="/">
<input type="hidden" name="nowDirectory" value="">
</form>
</body>
</html> 