<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicacreatenotfromreplication.jsp,v 1.6 2008/10/09 09:52:08 chenb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page buffer="64kb" %> 
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<%@include file="replicationcommon.jsp" %>
<%@include file="replicacommon.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript">

function onSet(){
    if (isSubmitted()){
        return false;
    }
    
    var hostName = document.forms[0].elements["replicaInfo.originalServer"].value;
    if ( hostName == "" ){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.oriservername.no"/>");
        document.forms[0].elements["replicaInfo.originalServer"].focus();
        return false;
    }
    if(!checkServerName(hostName)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="replica.create.oriservername.invalid"/>");
        document.forms[0].elements["replicaInfo.originalServer"].focus();
        return false;
    }
    
    var filesetPreffix = document.forms[0].elements["filesetNamePrefix"].value;
    var filesetSuffix = document.forms[0].elements["filesetNameSuffix"].value;
    if(!checkFilesetName(filesetPreffix, filesetSuffix)){
       document.forms[0].elements["filesetNamePrefix"].focus();
       return false;
    }

    var fset = new String(filesetPreffix + "#" + filesetSuffix);    
    document.forms[0].elements["replicaInfo.filesetName"].value = fset;

    // check snap-keep limit
    var useSnapKeepChkbox = document.forms[0].elements["replicaInfo.useSnapKeep"];
    if ((!useSnapKeepChkbox.disabled) && (useSnapKeepChkbox.checked)) {
		if (!checkSnapKeepLimit()) {
			return false;
		}
    }

    var cfmMsg = "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.create" bundle="common"/>";
 
    if (!confirm(cfmMsg)){
        return false;
    }
    setSubmitted();

    document.forms[0].action="/nsadmin/replication/replicaCreate.do?errorFromFlag=forFSorVol";
    document.forms[0].submit();
    return true;
}

function checkStatus(){
    document.forms[0].elements["goBack"].disabled=true;
    document.forms[0].elements["replicaInfo.originalServer"].focus();
	
    onChangeRepliTiming();
}

</script>
</head>

<body onLoad="checkStatus();loadSubmitPage(false);setHelpAnchor('replication_6');"
    onUnload="closeDetailErrorWin();unloadBtnFrame();">
 
<html:form action="replicaCreate.do">
<html:button property="goBack" onclick="return loadReplicaList()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<br><br>
<displayerror:error h1_key="replicate.h1"/>
<h3 class="title"><bean:message key="replica.add.h3"/></h3>
<h4><bean:message key="replica.add.h4.fileset"/></h4>
<%String colspan = "2"; %>
<input type="hidden" name="lastMp" value="<bean:write name="replicaCreateForm" property="replicaInfo.mountPoint"/>">
<table border="1" nowrap class="Vertical">
    <tr>
        <th><bean:message key="replication.info.oriservername"/></th>
        <td colspan="<%=colspan%>"><html:text property="replicaInfo.originalServer" maxlength="255" size="60"/></td>
    </tr>
    <tr>
        <th><bean:message key="replication.info.filesetname"/></th>
        <td colspan="<%=colspan%>"><html:hidden property="replicaInfo.filesetName"/>
            <html:text property="filesetNamePrefix" maxlength="255" size="20"/>
            <bean:message key="replication.info.filesetseparator"/><html:hidden property="filesetNameSuffix" write="true"/>
        </td>
    </tr>
    <tr>
        <th><bean:message key="replication.info.mountpoint"/></th>
        <td colspan="<%=colspan%>">
            <html:hidden property="replicaInfo.mountPoint" write="true"/>
            <html:hidden property="newVolume" value="useExist"/>
            <html:hidden property="format" value="false"/>
        </td>
    </tr>    
   
    <tr>
        <th><bean:message key="replication.info.interface"/></th>
        <td colspan="<%=colspan%>">
            <html:select property="replicaInfo.transInterface">
                <html:option value=""><bean:message key="replication.info.interface.nospecified"/></html:option>
                <html:optionsCollection name="interfaceVec" />
            </html:select>
        </td>
    </tr>
    <tr>
        <th valign="top"><bean:message key="replication.info.replidata"/></th>
        <td colspan="<%=colspan%>">
            <html:radio property="replicaInfo.replicationData" value="all" styleId="all" onclick="onChangeRepliTiming()"/>
            <label for="all"><bean:message key="replication.info.replidata.all"/></label><br>
            <html:radio property="replicaInfo.replicationData" value="onlysnap" styleId="onlysnap" onclick="onChangeRepliTiming()"/>
            <label for="onlysnap"><bean:message key="replication.info.replidata.onlysnap"/></label><br>
            <html:radio property="replicaInfo.replicationData" value="curdata" styleId="curdata" onclick="onChangeRepliTiming()"/>
            <label for="curdata"><bean:message key="replication.info.replidata.curdata"/></label><br>
        </td>
    </tr>
    <tr>
        <th valign="top"><bean:message key="replication.info.snapKeepMode"/></th>
        <td colspan="<%=colspan%>">
        	<html:checkbox property="replicaInfo.useSnapKeep" styleId="chkboxUseSnap" onclick="onUseSnapKeep(this)"/>
			<label for="chkboxUseSnap"><bean:message key="replication.info.usable"/></label>
			<br>&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message key="replication.info.snapKeepLimit"/>
			<html:text property="replicaInfo.snapKeepLimit" maxlength="3" size="3" style="text-align:right"/>
        </td>
    </tr>    
</table> 

</html:form>   
</body>
</html:html>
