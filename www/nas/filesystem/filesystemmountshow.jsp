<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemmountshow.jsp,v 1.8 2008/04/19 13:46:06 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.filesystem.FilesystemConst"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<%
  int rowNum = 4;
  if (((String)request.getAttribute("isNashead")).equals("true") 
      && ((String)request.getAttribute("hasGfsLicense")).equals("true")) {
    rowNum = 5;
  }
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
function init(){
    // add for RV pair
    <logic:equal name="<%=FilesystemConst.SESSION_IS_PAIRED%>" value="true" scope="session">
    	disableAllElements();
    	return;
    </logic:equal>
    
	if (!document.forms[0].elements["fsInfo.replication"].checked){
		document.forms[0].elements["fsInfo.replication"].disabled = true;
	}else{
	    if (document.forms[0].elements["fsInfo.replicType"].value=="replic"
	        || document.forms[0].elements["fsInfo.replicType"].value=="original"){
	        document.forms[0].elements["fsInfo.replication"].disabled = true;
	    }else{
			document.forms[0].elements["fsInfo.replication"].disabled = false;
		}		
	}
    checkUseGfs();
    checkAccessMode();
	changeRecoveryStatus();
}
function disableAllElements() {
    // disable access mode
    document.forms[0].elements["fsInfo.accessMode"][0].disabled = true;
    document.forms[0].elements["fsInfo.accessMode"][1].disabled = true;   
    
    // disable quota,noatime,replication,norecovery option
    document.forms[0].elements["fsInfo.quota"].disabled = true;
    document.forms[0].elements["fsInfo.noatime"].disabled = true;
    document.forms[0].elements["fsInfo.replication"].disabled = true;
    document.forms[0].elements["fsInfo.norecovery"].disabled = true;

	// disable GFS element
    <logic:equal name="isNashead" value="true" scope="request">
        <logic:equal name="hasGfsLicense" value="true" scope="request">
        	document.forms[0].elements["fsInfo.useGfs"].disabled = true;
        </logic:equal>
    </logic:equal>     
}

function checkUseGfs() {
    <logic:equal name="isNashead" value="true" scope="request">
        <logic:equal name="hasGfsLicense" value="true" scope="request">
            var old_repli = document.forms[0].elements["oldRepli"];
            var checkbox_repli = document.forms[0].elements["fsInfo.replication"]; 
		    var fsType   = document.forms[0].elements["fsInfo.fsType"].value;
		    var capacity = document.forms[0].elements["fsInfo.capacity"].value;
		    var checkbox_useGfs = document.forms[0].elements["fsInfo.useGfs"];
		    var old_useGfs = document.forms[0].elements["oldUseGfs"];
  
            if (fsType == "sxfsfw") {
                checkbox_useGfs.disabled = true;  // sxfsfw: GFS is disabled
            } else {
                if (checkbox_repli && checkbox_repli.checked) {
                    checkbox_useGfs.disabled = true;
                } else {
                    checkbox_useGfs.disabled = false; 
                }

                if( old_repli && (old_repli.value == "true") 
                    && (document.forms[0].elements["fsInfo.replicType"].value == "")){ 
	                if (checkbox_useGfs && checkbox_useGfs.checked) {
	                    checkbox_repli.disabled = true;    
	                } else {
	                    checkbox_repli.disabled = false;
	                }
                }
            }
        </logic:equal>
    </logic:equal>         
}

function checkAccessMode(){
    if (!document.forms[0].elements["fsInfo.replication"].checked){
        return;
    }
    if (document.forms[0].elements["fsInfo.replicType"].value == "replic"){
        document.forms[0].elements["fsInfo.accessMode"][1].checked = true;
	    document.forms[0].elements["fsInfo.accessMode"][0].disabled = true;
	    document.forms[0].elements["fsInfo.accessMode"][1].disabled = true;	       
    }else if(document.forms[0].elements["fsInfo.replicType"].value == "original"){
        document.forms[0].elements["fsInfo.accessMode"][0].checked = true;
	    document.forms[0].elements["fsInfo.accessMode"][0].disabled = true;
	    document.forms[0].elements["fsInfo.accessMode"][1].disabled = true;	       
    }else{
	    document.forms[0].elements["fsInfo.accessMode"][0].disabled = false;
	    document.forms[0].elements["fsInfo.accessMode"][1].disabled = false;
    }
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    lockMenu();
    setSubmitted();
    window.location.href="<html:rewrite page='/filesystemListAndDel.do?operation=display'/>";
}

function clickMVD(){
    checkUseGfs();
    checkAccessMode();
    changeRecoveryStatus();
}

function onSet(){
	if (isSubmitted()){
       return false;
    }
    if (!confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="msg.action.mount"/>" + "\r\n")){
        return false;
    }
    setSubmitted();
    lockMenu();
    document.forms[0].submit();
    return true;
    
}

function changeRecoveryStatus(){
	if (document.forms[0].elements["fsInfo.accessMode"][1].checked
	    && !document.forms[0].elements["fsInfo.replication"].checked){
		document.forms[0].elements["fsInfo.norecovery"].disabled = false;
	}else{
	    document.forms[0].elements["fsInfo.norecovery"].checked = false;
		document.forms[0].elements["fsInfo.norecovery"].disabled = true;
	}
}

</script>
</head>
<body onload="init()" onUnload="unLockMenu();">
<html:form action="mountFS.do?operation=mount">
<h1 class="title"><bean:message key="h1.filesystem"/></h1>
<html:button property="back" onclick="onBack()">
	<bean:message key="common.button.back" bundle="common"/>
</html:button>
<h2 class="title"><bean:message key="h2.filesystem.mount.set"/></h2>
<displayerror:error h1_key="h1.filesystem"/><br>
<nested:nest property="fsInfo">
<nested:hidden property="capacity"/>
<nested:hidden property="fsType"/>
<input type="hidden" name="oldRepli" value='<nested:write property="replication"/>'>
<input type="hidden" name="oldUseGfs"  value='<nested:write property="useGfs"/>'>

<logic:equal name="<%=FilesystemConst.SESSION_IS_PAIRED%>" value="true" scope="session">
	<input type="hidden" name="oldAccessMode"  value='<nested:write property="accessMode"/>'>
	<input type="hidden" name="oldQuota"  value='<nested:write property="quota"/>'>
	<input type="hidden" name="oldNoatime"  value='<nested:write property="noatime"/>'>
	<input type="hidden" name="oldNorecovery"  value='<nested:write property="norecovery"/>'>
</logic:equal>


<nested:define id="volumeName4Show" property="volumeName"/>
<table border="1">
    <tr>
      <th align="left" nowrap><bean:message key="info.mountpoint" bundle="volume/filesystem"/></th>    
      <td>
    	<nested:write property="mountPoint"/>
    	<nested:hidden property="mountPoint"/>
      </td>
    </tr>
    
    <tr>
      <th align="left" nowrap><bean:message key="info.access" bundle="volume/filesystem"/></th>
       <td nowrap>
              <nested:radio property="accessMode" styleId="modeID1" value="rw" onclick="changeRecoveryStatus()"/>
      		  <label for="modeID1">
      		  <bean:message key="info.access.rw" bundle="volume/filesystem"/>&nbsp;&nbsp;</label>
              <nested:radio property="accessMode" styleId="modeID2" value="ro" onclick="changeRecoveryStatus()"/>
      		  <label for="modeID2">
      		  <bean:message key="info.access.ro" bundle="volume/filesystem"/></label>
       </td>
    </tr>
	<tr>
     <th align="left" valign="top" nowrap rowspan="<%=rowNum%>"><bean:message key="info.option" bundle="volume/filesystem"/></th>
     <td>
        <nested:checkbox property="quota" styleId="quotaID"/>
	    <label for="quotaID">
	    <bean:message key="info.quota" bundle="volume/filesystem"/></label>
	 </td>
    </tr>
    <tr>
     <td>
     	<nested:checkbox property="noatime" styleId="timeID"/>
	    <label for="timeID">
	    <bean:message key="info.noatime" bundle="volume/filesystem"/></label>
	 </td>
    </tr>
    <tr>
     <td>
        <nested:checkbox property="replication" styleId="repliID" onclick="clickMVD()"/>
	    <label for="repliID">
	    <bean:message key="info.replication" bundle="volume/filesystem"/></label>
	    <nested:hidden property="replicType"/>
     </td>
  	</tr>
    <tr>
     <td>
     	<nested:checkbox property="norecovery" styleId="recoveryID"/>
	    <label for="recoveryID">
	    <bean:message key="info.norecovery" bundle="volume/filesystem"/></label>
     </td>
    </tr>
    <logic:equal name="isNashead" value="true" scope="request">
        <logic:equal name="hasGfsLicense" value="true" scope="request">
		    <tr>
		     <td>
		        <nested:checkbox property="useGfs" styleId="useGfsID" value="true"  onclick="checkUseGfs();"/>
		        <label for="useGfsID">
		        <bean:message key="info.modify.useGfs" bundle="volume/filesystem"/></label>
		     </td>
		    </tr>
        </logic:equal>
    </logic:equal>  
    <nested:hidden property="dmapi"/>
</table>
</nested:nest>
<br>
<html:button property="set" onclick="onSet()">
	<bean:message key="common.button.submit" bundle="common"/>
</html:button>
</html:form>
</body>
</html:html>
