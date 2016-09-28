<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsSetDirAccessControlTop.jsp,v 1.9 2008/12/18 08:15:11 chenbc Exp $" -->

<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst,com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>

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
<bean:define id="sharedDirectory" name="<%=CifsActionConst.SESSION_SHARED_DIRECTORY%>" type="java.lang.String"/>
function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="dirAccessControl.do?operation=backToList";
}

function onSet(){
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
    document.forms[0].action ="dirAccessControl.do?operation=setDirAccessControl";
    setSubmitted();
    document.forms[0].submit();
    
}    

function checkAll(){
    <logic:equal name="dirAccessControlForm" property="operationType" value="add">
        document.forms[0].elements["dirAccessControlInfo.directory"].value=getCorrectPath(document.forms[0].elements["dirAccessControlInfo.directory"].value);
        if(!checkTempPath(document.forms[0].elements["dirAccessControlInfo.directory"].value)){
            document.forms[0].elements["dirAccessControlInfo.directory"].focus();
            return false;
        }
    </logic:equal>

    document.forms[0].elements["dirAccessControlInfo.allowHost"].value=trim(document.forms[0].elements["dirAccessControlInfo.allowHost"].value);
    if (!checkHosts(document.forms[0].elements["dirAccessControlInfo.allowHost"].value)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.hostsAllow_invalid"/>");
        document.forms[0].elements["dirAccessControlInfo.allowHost"].focus();
        return false;
    }

    document.forms[0].elements["dirAccessControlInfo.denyHost"].value=trim(document.forms[0].elements["dirAccessControlInfo.denyHost"].value);
    if (!checkHosts(document.forms[0].elements["dirAccessControlInfo.denyHost"].value)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.hostsDeny_invalid"/>");
        document.forms[0].elements["dirAccessControlInfo.denyHost"].focus();
        return false;
    }

    return true;
}

function getCorrectPath(rawPath){
	var tmp = deleteMutipleSlash(rawPath);
    tmp = tmp.replace(/(^[\/]*)/g,"");                      //delete the first "/"
    tmp = tmp.replace(/([\/])$/g,"");                       //delete the last "/"
    tmp = tmp.replace(/^[\.]([\.])?$/g,"");                 //delete the ".." or "."
    return tmp;
}

function checkTempPath(str){
    if (str == ""){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.path_null"/>");
        return false;
    }

    if(!checkPath4Win(str)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.dirAccess.alert.path_invalidChar"/>");
        return false;
    }
// modified for 0805 cifs limit
    if(!checkNFDLength(str, 200)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.directory.too_long"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.invalidLength.utf8nfd" arg0="200"/>");
        return false;
    }
//
    if((str.search(/[\/][\.][\/]/) != -1) || (str.search(/[\/][\.][\.][\/]/) != -1)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.dirAccess.alert.path_invalidChar"/>");
        return false;
    }
    return true;
}

function getFullDirectory(tempPath){
    return ("<%=sharedDirectory%>" + "/" + tempPath);
}

function enableBottomButton(){
	if(window.parent.frames[1] && window.parent.frames[1].document.forms[0]&& window.parent.frames[1].document.forms[0].button_submit){
	  window.parent.frames[1].document.forms[0].button_submit.disabled=0;
	}
}
function init(){
    setHelpAnchor(document.forms[0].helpLocation.value);
    displayAlert();
    enableBottomButton();
}

var pupUpWinName;
function onNavigator(){
    if (pupUpWinName == null || pupUpWinName.closed){
        window.mpPath = document.forms[0].elements["dirAccessControlInfo.directory"];
        document.sharePathForm.nowDirectory.value=compactPath(getFullDirectory(getCorrectPath(document.forms[0].elements["dirAccessControlInfo.directory"].value)));
        pupUpWinName = window.open("/nsadmin/common/commonblank.html","selectAccessDir_navigator",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=500,height=500");
        document.sharePathForm.submit();
    }else{
        pupUpWinName.focus();
    }
}

</script>
</head>

<body onload="init();" onUnload="closeDetailErrorWin();closePopupWin(pupUpWinName);">
<html:form action="dirAccessControl.do?operation=setDirAccessControl" method="post">

<html:hidden property="operationType"/>

<html:button property="goBack" onclick="return onBack()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button><br><br>
<displayerror:error h1_key="cifs.common.h1"/>
<br />
<logic:equal name="dirAccessControlForm" property="operationType" value="add">
    <h3 class="title"><bean:message key="cifs.dirAccessControl.h3_add"/></h3>
    <input type="hidden" name="helpLocation" value="network_cifs_11">
    <input type="hidden" name="helpLocation_navigator" value="network_cifs_13">
</logic:equal>
<logic:equal name="dirAccessControlForm" property="operationType" value="modify">
    <h3 class="title"><bean:message key="cifs.dirAccessControl.h3_modify"/></h3>
    <input type="hidden" name="helpLocation" value="network_cifs_12">
</logic:equal>

<nested:nest property="dirAccessControlInfo">

  <br>
  <table border="1" class="Vertical">
  <tr><th><bean:message key="cifs.shareOption.th_sharename"/></th>
  <td>
    <bean:define id="shareName" name="shareNameForDisplay" type="java.lang.String"/>
    <%=NSActionUtil.sanitize(shareName)%>
    <%session.setAttribute("shareNameForDisplay", null);%>
  </td>
  </tr>
    <tr>
      <th><bean:message key="cifs.dirAccess.th_directory"/></th>
      <td nowrap>
          <logic:equal name="dirAccessControlForm" property="operationType" value="add">
            <%=NSActionUtil.sanitize(sharedDirectory)%>/<nested:text property="directory" onblur=";"
                         size="48" maxlength="200" />
                <html:button property="button_browse" onclick="onNavigator();">
                    <bean:message key="common.button.browse2" bundle="common"/>
                </html:button>
         </logic:equal>
        <logic:equal name="dirAccessControlForm" property="operationType" value="modify">
            <nested:define id="targetDirectory" property="directory" type="java.lang.String"/>
            <%=NSActionUtil.sanitize(sharedDirectory)%>/<%=NSActionUtil.sanitize(targetDirectory)%>
            <nested:hidden property="directory"/>
        </logic:equal>
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_hostsallow"/></th>
      <td>
        <nested:text property="allowHost" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_hostsdeny"/></th>
      <td>
        <nested:text property="denyHost" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </td>
    </tr>

  </table><br>

</nested:nest>
</html:form>
<form name="sharePathForm" action="CSNavigatorList.do" target="selectAccessDir_navigator" method="post">
<input type="hidden" name="operation" value="callShare">
<input type="hidden" name="rootDirectory" value="<%=sharedDirectory%>">
<input type="hidden" name="nowDirectory" value="">
</form>
</body>
</html>