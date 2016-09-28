<!--
        Copyright (c) 2004-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: volumemodifyshow.jsp,v 1.14 2009/01/13 11:30:03 xingyh Exp $" --> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page buffer="32kb" %> 
<html:html lang="true">
<head> 
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">
function backToList(){
    if (!isSubmitted()){
        window.location = "/nsadmin/volume/volumeList.do";
        setSubmitted();
        lockMenu();
    }
}

function onModify(){
    if (isSubmitted()){
       return false;
    }

    // check snapshot  limits
    var usedSnapshotArea = '<bean:write name="usedSnapshotArea" scope="request"/>';
    var slect_snapshot = document.forms[0].elements["volumeInfo.snapshot"];
    if (slect_snapshot.disabled == false) {
        var limitSnapshotArea = slect_snapshot.value;
        if (parseInt(limitSnapshotArea) < parseInt(usedSnapshotArea)) {
            alert('<bean:message key="msg.alert.invalid_snapshotArea" arg0="\'+usedSnapshotArea+\'" />');
            return false;           
        }
    }

    var confirmMessage = "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.modify" bundle="common"/>" + "\r\n";
    
    var oldWpPeriod = document.forms[0].elements["volumeInfo.wpPeriod"].value;
    var active = (oldWpPeriod != "--") && (oldWpPeriod != "-1") && (oldWpPeriod != "0");
    var checkbox_wpperiod = document.forms[0].elements["useWpProtected"];
    var wpProtectedValueForPl;
    if(checkbox_wpperiod.disabled){
        wpProtectedValueForPl = "--";
    }else if(checkbox_wpperiod.checked && !active){
		//uncheck ---> check
		//set the Write-Protected
		//check the period
		if(checkWpPeriod(document.forms[0].elements["wpPeriod_text"])){
		    //the period is valid
		    wpProtectedValueForPl = document.forms[0].elements["wpPeriod_text"].value;
		    confirmMessage = '<bean:message key="info.confirm.set.writeprotected"/>';
		}else{
		    alert('<bean:message key="info.alert.invalid.wp.days"/>');
		    document.forms[0].elements["wpPeriod_text"].focus();
		    return false;
		}
	}else if(!checkbox_wpperiod.checked && active){
	    wpProtectedValueForPl = "-1";
	}else{
		wpProtectedValueForPl = "--";
	}

    if (!confirm(confirmMessage)){
        return false;
    }
    setSubmitted();
    document.forms[0].elements["volumeInfo.wpPeriod"].value = wpProtectedValueForPl;
    document.forms[0].action="/nsadmin/volume/volumeModify.do";
    lockMenu();
    return true;
}

function checkStatus(){
    var old_repli = document.forms[0].elements["oldRepli"];
    var repli_type = document.forms[0].elements["repli_type"];
    var radio_ro = document.getElementById("radio_ro");
    var radio_rw = document.getElementById("radio_rw");
    var checkbox_repli = document.forms[0].elements["volumeInfo.replication"];
    var checkbox_norecovery = document.forms[0].elements["volumeInfo.norecovery"];
    var slect_snapshot = document.forms[0].elements["volumeInfo.snapshot"];

    var fsType   = document.forms[0].elements["volumeInfo.fsType"].value;
    var capacity = document.forms[0].elements["volumeInfo.capacity"].value;
    var checkbox_useGfs = document.forms[0].elements["volumeInfo.useGfs"];
    var old_useGfs = document.forms[0].elements["oldUseGfs"];
    
    <logic:equal name="isNashead" value="true" scope="request">
        <logic:equal name="hasGfsLicense" value="true" scope="request">    
		    if (fsType == "sxfsfw") {
		        checkbox_useGfs.disabled = true;  // sxfsfw: GFS is disabled
		    } else {
			    if (checkbox_repli && checkbox_repli.checked) {
			        checkbox_useGfs.disabled = true;
			    } else {
			        checkbox_useGfs.disabled = false; 
			    }
	            if (checkbox_useGfs && checkbox_useGfs.checked) {
	                checkbox_repli.disabled = true;    
	            } else {
	                checkbox_repli.disabled = false;
	            }             
            }
		</logic:equal>    
    </logic:equal>
    
    if( old_repli && (old_repli.value == "true") && repli_type && (repli_type.value != "")){
        radio_ro.disabled = true; 
        radio_rw.disabled = true;
        checkbox_repli.disabled = true;
    }
    
    if( old_repli && (old_repli.value == "false")){
        checkbox_repli.disabled = true;
    }
    
    if (radio_ro && radio_ro.checked ){
        slect_snapshot.disabled = true;
    }else if (radio_rw && radio_rw.checked ){
        slect_snapshot.disabled = false;
    }
    
    if(radio_ro && radio_ro.checked && checkbox_repli && !checkbox_repli.checked){
        checkbox_norecovery.disabled = false;
    }else{
        checkbox_norecovery.checked = false;
        checkbox_norecovery.disabled = true;
    }
    
    /**enable about dmapi**/
    var canSetDmapi = document.forms[0].elements["canSetDmapi"];
    var hidden_dmapi = document.forms[0].elements["volumeInfo.dmapi"];
/*  var checkbox_dmapi = document.forms[0].elements["volumeInfo.dmapi"];
    var dmapi_snapshot = false ; /**snapshot not disabled the first time**/
/*    if(canSetDmapi && checkbox_dmapi && slect_snapshot){
	    if(canSetDmapi.value == "yes"){
	        checkbox_dmapi.disabled = false;
	    }else{
	        checkbox_dmapi.checked = false;
	        checkbox_dmapi.disabled = true;
	    }
	    if(checkbox_dmapi.disabled || !checkbox_dmapi.checked){
	        dmapi_snapshot = false;
	    }else{
	        dmapi_snapshot = true;
	    }
    }
*/  
    if(hidden_dmapi.value == "false"){
        dmapi_snapshot = false;
    }else{
        dmapi_snapshot = true;
    }  
    
    if(radio_ro.checked || dmapi_snapshot){
        slect_snapshot.disabled = true;
    }else{
        slect_snapshot.disabled = false;
    }
    if (parseFloat(capacity) > <%=VolumeActionConst.VOLUME_SIZE_20TB%>){
        slect_snapshot.disabled = true;
    }
    
    ////modify check status for write-protected
    var wpLicense = '<bean:write name="<%=VolumeActionConst.SESSION_WP_LICENSE%>" scope="session"/>';
    var oldWpPeriod = document.forms[0].elements["volumeInfo.wpPeriod"].value;
    var active = (oldWpPeriod != "--") && (oldWpPeriod != "-1") && (oldWpPeriod != "0");
    
    if(wpLicense == "false" ||
       checkbox_repli.checked ||
       fsType == "sxfsfw"||
       radio_ro.checked){
        document.forms[0].elements["useWpProtected"].checked = active;
        document.forms[0].elements["useWpProtected"].disabled = true;
    }else{
        document.forms[0].elements["useWpProtected"].disabled = false;
    }
    if(document.forms[0].elements["useWpProtected"].disabled ||
       !document.forms[0].elements["useWpProtected"].checked ||
       active){
        document.forms[0].elements["wpPeriod_text"].disabled = true;
    }else{
        document.forms[0].elements["wpPeriod_text"].disabled = false;
    }   
       
}

function init(){
    var oldWpPeriod = document.forms[0].elements["volumeInfo.wpPeriod"].value;
    if((oldWpPeriod != "--") && (oldWpPeriod != "-1") && (oldWpPeriod != "0")){
        document.forms[0].elements["wpPeriod_text"].value = oldWpPeriod;
        document.forms[0].elements["useWpProtected"].checked=true;
    }else{
        document.forms[0].elements["wpPeriod_text"].value = "1825";
        document.forms[0].elements["useWpProtected"].checked=false;
    }
}

</script>
</head>
<body onLoad="init();checkStatus();displayAlert();" onUnload="unLockMenu();closeDetailErrorWin();">
<h1 class="title"><bean:message key="title.h1"/></h1>
<html:button property="backBtn" onclick="backToList();">
   <bean:message key="common.button.back" bundle="common"/>
</html:button><br>
<h2 class="title"><bean:message key="title.modify.h2"/></h2>
<html:form action="volumeModify.do" onsubmit="return onModify();">
<displayerror:error h1_key="title.h1"/>
    <html:hidden property="canSetDmapi"/>
	<nested:nest property="volumeInfo">
	    <nested:hidden property="volumeName"/>
	    <nested:hidden property="capacity"/>
	    <nested:hidden property="fsType"/>
	    <nested:hidden property="wpPeriod"/>
	    
	    <input type="hidden" name="oldAccess" value='<nested:write property="accessMode"/>'>
	    <input type="hidden" name="oldRepli" value='<nested:write property="replication"/>'>
	    <input type="hidden" name="repli_type" value='<nested:write property="replicType"/>'>
	    <input type="hidden" name="oldUseGfs"  value='<nested:write property="useGfs"/>'>
	 <table border="1" nowrap class="Vertical">
      <tr>
        <th align=left><bean:message key="info.volumeName"/></th>
        <td align=left>
        	<nested:define id="volumeName4Show" property="volumeName"/>
        	<%=volumeName4Show.toString().replaceFirst("NV_LVM_" , "")%>
        </td>
      </tr>
            
      <tr>
        <th align=left><bean:message key="info.mountpoint"/></th>
        <td align=left> 
            <html:hidden property="volumeInfo.mountPoint" write="true"/>
        </td>
      </tr>
      
      <tr>
        <th><bean:message key="info.access"/></th>
        <td>
            <nested:radio property="accessMode" value="rw" styleId="radio_rw" onclick="checkStatus();"/>
            <label for="radio_rw"><bean:message key="info.access.rw"/></label>            
            <nested:radio property="accessMode" value="ro" styleId="radio_ro" onclick="checkStatus();"/>
            <label for="radio_ro"><bean:message key="info.access.ro"/></label>
        </td>
      </tr> 
      <%
         String isNashead = (String)(request.getAttribute("isNashead"));
         String rowSpan = "4";
         if((isNashead != null) && (isNashead.equals("true"))){
            String hasGfs = (String)(request.getAttribute("hasGfsLicense"));
            if((hasGfs != null) && (hasGfs.equals("true"))){
                rowSpan = "5";
            }
         }
      %>
      <tr>
        <th valign="top" rowspan="<%=rowSpan%>"><bean:message key="info.option"/></th>
        <td><nested:checkbox property="quota" styleId="quota"/>
            <label for="quota"><bean:message key="info.quota"/></label></td>
      </tr>
      <tr>
        <td><nested:checkbox property="noatime" styleId="noatime"/>
            <label for="noatime"><bean:message key="info.noatime"/></td>
      </tr>
      <nested:hidden property="dmapi"/>
<!--  <tr>
        <td><nested:checkbox property="dmapi" styleId="dmapi" onclick="checkStatus();"/>
            <label for="dmapi"><bean:message key="info.dmapi"/></td>
      </tr>
-->      
      <tr>
      	<td><nested:checkbox property="replication" styleId="replication" onclick="checkStatus()"/>
        <label for="replication"><bean:message key="info.replication"/></td>
      </tr>
      <tr>
      	<td><nested:checkbox property="norecovery" styleId="norecovery"/>
        <label for="norecovery"><bean:message key="info.norecovery"/></td>
      </tr>
      <logic:equal name="isNashead" value="true" scope="request">
      <logic:equal name="hasGfsLicense" value="true" scope="request">
	      <tr>
	        <td><nested:checkbox property="useGfs" styleId="useGfs" value="true" onclick="checkStatus();"/>
	        <label for="useGfs"><bean:message key="info.modify.useGfs"/></td>
	      </tr>
      </logic:equal>
      </logic:equal>
      <tr> 
        <th><bean:message key="info.snapshotArea"/></th>
        <td >
          <nested:define id="snapshot" type="java.lang.String" property="snapshot"/>
          <nested:select property="snapshot">
            <option value="100" <%=snapshot.equals("100")?"selected":""%>>100%
                                (<bean:message key="info.nolimit"/>)</option>
            <option value="90" <%=snapshot.equals("90")?"selected":""%>>90%</option>
            <option value="80" <%=snapshot.equals("80")?"selected":""%>>80%</option>
            <option value="70" <%=snapshot.equals("70")?"selected":""%>>70%</option>
            <option value="60" <%=snapshot.equals("60")?"selected":""%>>60%</option>
            <option value="50" <%=snapshot.equals("50")?"selected":""%>>50%</option>
            <option value="40" <%=snapshot.equals("40")?"selected":""%>>40%</option>
            <option value="30" <%=snapshot.equals("30")?"selected":""%>>30%</option>
            <option value="20" <%=snapshot.equals("20")?"selected":""%>>20%</option>
            <option value="10" <%=snapshot.equals("10")?"selected":""%>>10%</option>
          </nested:select>
        </td>
      </tr>
      <tr> 
        <th><bean:message key="info.writeprotected"/></th>
        <td >
          <input type="checkbox" name="useWpProtected" value="on" id="useWpProtected" onclick="checkStatus();">
          <label for="useWpProtected"><bean:message key="info.writeprotected.set"/></label>
          &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="wpPeriod_text" value="" size="5" maxlength="5" style="text-align:right" ><bean:message key="info.writeprotected.set.days"/>
        </td>
      </tr>
    </table>
    </nested:nest>
    <br>
    <html:submit property="submitBtn"><bean:message key="common.button.submit" bundle="common"/></html:submit>
  </html:form>
</body>
</html:html>