<!--
        Copyright (c) 2005-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicamodifyshow.jsp,v 1.6 2009/02/13 03:24:44 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<%@include file="replicationcommon.jsp" %>
<%@include file="replicacommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function onSet(){
    if (isSubmitted()){
        return false;
    }

    var snapMsg = "";

	<logic:notEqual name="replicaInfoForm" property="replicaInfo.replicationData" value="curdata">
		var useSnapKeepChkbox = document.forms[0].elements["replicaInfo.useSnapKeep"];
		if ((!useSnapKeepChkbox.disabled) && (useSnapKeepChkbox.checked)) {
			if (!checkSnapKeepLimit()) {
				return false;
			}
		}

		var oldUseSnapKeep = document.forms[0].elements["oldUseSnapKeep"].value;
		if ((oldUseSnapKeep == "on") && (!useSnapKeepChkbox.checked) ) {
			snapMsg = "<bean:message key="replication.snapKeepLimit.changeToNotUseSnapkeepMode"/>" + "\r\n\r\n";
		}
	</logic:notEqual>

    document.forms[0].action="/nsadmin/replication/replicaModify.do?operation=modify";
    if (!confirm(snapMsg 
            + "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.modify" bundle="common"/>")){
        return false;
    }
    setSubmitted();
    document.forms[0].submit();
    return true;
}
function init(){
	// initialize the status of the snap-keep mode
	disableSnapKeepOption(false);

	<logic:equal name="replicaInfoForm" property="replicaInfo.replicationData" value="curdata">
		disableSnapKeepOption(true);
	</logic:equal>
}
</script>
</head>
<body onLoad="init();loadSubmitPage(false);setHelpAnchor('replication_7');" onUnload="closeDetailErrorWin();unloadBtnFrame();">
<html:button property="goBack" onclick="return loadReplicaList();">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<br><br>
<displayerror:error h1_key="replicate.h1"/>
<h3 class="title"><bean:message key="replica.modify.h3"/></h3>
<html:form action="replicaModify.do" onsubmit="onSet();return false">
<nested:nest property="replicaInfo">
	<input type="hidden" name="oldUseSnapKeep" value='<nested:write property="useSnapKeep"/>'>
    <nested:hidden property="replicationData"/>
    <nested:hidden property="repliMethod"/>
</nested:nest>
<table border="1" nowrap class="Vertical">
    <tr>
        <th><bean:message key="replication.info.oriservername"/></th>
        <td><html:hidden property="replicaInfo.originalServer" write="true"/></td>
    </tr>
    <tr>
        <th><bean:message key="replication.info.filesetname"/></th>
        <td><html:hidden property="replicaInfo.filesetName" write="true"/></td>
    </tr>
    <tr>
        <th><bean:message key="replication.info.interface"/></th>
        <td><html:select property="replicaInfo.transInterface">
                <html:option value=""><bean:message key="replication.info.interface.nospecified"/></html:option>
                <html:optionsCollection name="interfaceVec" />
            </html:select>
        </td>
    </tr>
    <tr>
        <th><bean:message key="replication.info.mountpoint"/></th>
        <td><html:hidden property="replicaInfo.mountPoint" write="true"/></td>
    </tr>
    <tr>
        <th valign="top"><bean:message key="replication.info.snapKeepMode"/></th>
        <td>
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
