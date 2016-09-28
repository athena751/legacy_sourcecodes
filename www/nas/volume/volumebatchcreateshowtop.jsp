<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreateshowtop.jsp,v 1.10 2008/02/29 12:54:59 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<bean:define id="lunsNumber" name="volume_volumeNumber" scope="session"/>
<%
    String lvNumber = (String)session.getAttribute("volume_availLvNumber");
    if(lvNumber == null){
        lvNumber = "0";
    }
%> 

<script language="JavaScript">
function checkboxBlur(obj){
    if(obj.checked){
        obj.checked = false;
    }
}

function onChkAllLun(flag) {
    if (parent.frames[1].document.forms[0]) {
        if (<%=(String)lunsNumber%> == 1) {
            parent.frames[1].document.forms[0].selectOrNot.checked = flag;
        } else {
            for (var i=0 ; i<<%=(String)lunsNumber%> ; i++) {
                parent.frames[1].document.forms[0].selectOrNot[i].checked = flag;
            }
        }
    }
}

function onUseSameFstype() {
    if (parent.frames[1].document.forms[0]) {
        for (var i=0 ; i<256 ; i++) {
            if (parent.frames[1].document.forms[0].elements["volumes["+i+"].fsType"]) {
                parent.frames[1].document.forms[0].elements["volumes["+i+"].fsType"][0].checked = document.forms[0].samefstype[0].checked ;
                parent.frames[1].document.forms[0].elements["volumes["+i+"].fsType"][1].checked = document.forms[0].samefstype[1].checked ;
            }
        } 
    }
}

function onUseSameOptions() {
    if (parent.frames[1].document.forms[0]) {
        for (var i=0 ; i<256 ; i++) {
            var replication = "replication" + i;
            var quota = "quota" + i;
            var noatime = "noatime" + i;
			var dmapi = "dmapi" + i;
            if (eval("parent.frames[1].document.forms[0]."+replication)) {
                if (eval("parent.frames[1].document.forms[0]."+replication+".disabled == false")) {
                    eval("parent.frames[1].document.forms[0]."+replication+".checked = document.forms[0].chkallrepli.checked") ;
                }
                eval("parent.frames[1].document.forms[0]."+quota+".checked = document.forms[0].chkallquota.checked") ;
                eval("parent.frames[1].document.forms[0]."+noatime+".checked = document.forms[0].chkalltime.checked") ;
                //eval("parent.frames[1].document.forms[0]."+dmapi+".checked = document.forms[0].chkalldmapi.checked") ;
                
            }
        } 
    }
}
</script>
</head>

<body onUnload="unLockMenu();">
<h1><bean:message key="title.h1"/></h1>
<form>
<logic:equal name="volume_machineType" value="nashead" scope="session">
<input type=button 
       name="back" 
       value="<bean:message key="common.button.back" bundle="common"/>"
       onclick="lockMenu();parent.location='volumeList.do'"/>
</logic:equal>
<logic:notEqual name="volume_machineType" value="nashead" scope="session">
<input type=button 
       name="back" 
       value="<bean:message key="common.button.back" bundle="common"/>"
       onclick="lockMenu();parent.location='volumeBatchDispatch.do?operation=display'"/>
</logic:notEqual>
<h2><bean:message key="title.batchcreateshow.h2"/></h2>

<logic:equal name="volume_machineType" value="nashead" scope="session">
	<jsp:include page="volumelicensecommon.jsp" flush="true"/>
</logic:equal>

<h3><bean:message key="title.batchcreateshow.h3"/></h3>

<logic:equal name="volume_machineType" value="nashead" scope="session">
<table><tr>
<td><bean:message key="msg.batchcreateshow.createVolumeNumberNashead"/>
</td>
<td><%=(String)lvNumber%></td>
</tr></table>
</logic:equal>

<bean:define id="hasReplicLicense" name="volume_hasReplicLicense" scope="session"/>
<table border="1" width="100%">
<tr>
    <th><input type="button" value='<bean:message key="button.batchcreateshow.usesamefstype"/>' onclick="onUseSameFstype();"></th>
    <th><input type="button" value='<bean:message key="button.batchcreateshow.usesameoptions"/>' onclick="onUseSameOptions();"></th>
</tr>

<tr>
    <td align="center" nowrap>
        <input type="radio" name="samefstype" id="samefstype1" checked >
        <label for="samefstype1"><bean:message key="info.fsType.sxfs"/></label>
        <input type="radio" name="samefstype" id="samefstype2" >
        <label for="samefstype2"><bean:message key="info.fsType.sxfsfw"/></label>
    </td>
    <td align="center" nowrap>
      <input type="checkbox" name="chkallquota"  checked id="chkallquota">
      <label for="chkallquota"><bean:message key="info.quota"/></label>
      &nbsp;&nbsp;<input type="checkbox" name="chkalltime" checked id="chkalltime">
      <label for="chkalltime"><bean:message key="info.noatime"/></label>
<!--      &nbsp;&nbsp;<input type="checkbox" name="chkalldmapi" id="chkalldmapi">
      <label for="chkalldmapi"><bean:message key="info.dmapi"/></label>
-->      &nbsp;&nbsp;<input type="checkbox" name="chkallrepli" id="chkallrepli" <%=((String)hasReplicLicense).equals("true")?"":"disabled"%> onclick="if (this.disabled) checkboxBlur(this)">
      <label for="chkallrepli"><bean:message key="info.batchcreateshow.replication"/></label>
    </td>
</tr>
</table>

<logic:equal name="volume_machineType" value="nashead" scope="session">
    <input type="button" name="chkalllun" value='<bean:message key="button.batchcreateshow.checkalllun"/>' onclick="onChkAllLun(true);">
    <input type="button" name="unchkalllun" value='<bean:message key="button.batchcreateshow.uncheckalllun"/>' onclick="onChkAllLun(false);">
</logic:equal>
</form>
</body>
</html:html>

