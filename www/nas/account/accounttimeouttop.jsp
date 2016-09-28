<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: accounttimeouttop.jsp,v 1.2 2007/05/09 07:40:53 chenbc Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
	var buttonEnable = 0;
	function enableSet() {
			buttonEnable = 1;
			if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
				window.parent.frames[1].changeButtonStatus();
			}
	}
	
	function init() {
		var nsadminTimeout = '<bean:write name="accountTimeoutForm" property="nsadminTimeout" />';
		var nsviewTimeout = '<bean:write name="accountTimeoutForm" property="nsviewTimeout" />';
		if(nsadminTimeout != "10" && nsadminTimeout != "30" && nsadminTimeout != "60" && nsadminTimeout != "120") {
			document.forms[0].nsadminradio1.checked = "true";
		}
		if(nsviewTimeout != "10" && nsviewTimeout != "30" && nsviewTimeout != "60" && nsviewTimeout != "120" && nsviewTimeout != "-1") {
			document.forms[0].nsviewradio1.checked = "true";
		}
	}
	
	function onConfirm() {
		if (isSubmitted()){
			return false;
		}
		var msg = '<bean:message key="common.confirm" bundle="common"/>\r\n' + 
            	  '<bean:message key="common.confirm.action" bundle="common"/>' + " " +
            	  '<bean:message key="common.button.submit" bundle="common"/>';
        if(!document.forms[0].nsadminradio1.checked || !document.forms[0].nsviewradio1.checked) {
        	msg = '<bean:message key="account.timeout.alertmsg"/>\r\n' + 
        		  '<bean:message key="common.confirm" bundle="common"/>';
        }
		if(confirm(msg)) {
			setSubmitted();
    		document.forms[0].submit();
    		return true;
    	}
	}
			
	</script>
</head>
<body
	onload="enableSet();displayAlert();setHelpAnchor('system_account_4');init();">
<html:form action="accountTimeoutSet.do" method="post" target="_parent">
	<displayerror:error h1_key="account.common.h1" />

	<h3><bean:message key="account.list.nsadmin.h3" /></h3>
	<table>
		<tr>
			<th><bean:message key="account.old.timeout" /></th>
			<td><bean:write name="accountTimeoutForm" property="nsadminTimeout" />
			<bean:message key="account.list.mins" /></td>
		</tr>
		<tr>
			<th><bean:message key="account.new.timeout" /></th>
			<td align="left"><html:radio property="nsadminTimeout"
				styleId="nsadminradio1" value="10">
				<label for="nsadminradio1"><bean:message
					key="account.timeout.10minute" /></label>
			</html:radio> <html:radio property="nsadminTimeout"
				styleId="nsadminradio2" value="30">
				<label for="nsadminradio2"><bean:message
					key="account.timeout.30minute" /></label>
			</html:radio> <html:radio property="nsadminTimeout"
				styleId="nsadminradio3" value="60">
				<label for="nsadminradio3"><bean:message
					key="account.timeout.60minute" /></label>
			</html:radio> <html:radio property="nsadminTimeout"
				styleId="nsadminradio4" value="120">
				<label for="nsadminradio4"><bean:message
					key="account.timeout.120minute" /></label>
			</html:radio></td>
		</tr>
	</table>
	<h3><bean:message key="account.list.nsview.h3" /></h3>
	<table>
		<tr>
			<th><bean:message key="account.old.timeout" /></th>
			<td><logic:equal name="accountTimeoutForm" property="nsviewTimeout"
				value="-1">
				<bean:message key="account.list.nolimit" />
			</logic:equal> <logic:notEqual name="accountTimeoutForm"
				property="nsviewTimeout" value="-1">
				<bean:write name="accountTimeoutForm" property="nsviewTimeout" />
				<bean:message key="account.list.mins" />
			</logic:notEqual></td>
		</tr>
		<tr>
			<th><bean:message key="account.new.timeout" /></th>
			<td align="left"><html:radio property="nsviewTimeout"
				styleId="nsviewradio1" value="10">
				<label for="nsviewradio1"><bean:message
					key="account.timeout.10minute" /></label>
			</html:radio> <html:radio property="nsviewTimeout"
				styleId="nsviewradio2" value="30">
				<label for="nsviewradio2"><bean:message
					key="account.timeout.30minute" /></label>
			</html:radio> <html:radio property="nsviewTimeout"
				styleId="nsviewradio3" value="60">
				<label for="nsviewradio3"><bean:message
					key="account.timeout.60minute" /></label>
			</html:radio> <html:radio property="nsviewTimeout"
				styleId="nsviewradio4" value="120">
				<label for="nsviewradio4"><bean:message
					key="account.timeout.120minute" /></label>
			</html:radio> <html:radio property="nsviewTimeout"
				styleId="nsviewradio5" value="-1">
				<label for="nsviewradio5"><bean:message key="account.list.nolimit" /></label>
			</html:radio></td>
		</tr>
		<tr>
			<td colspan="2"><input type="checkbox" id="check_reflect"
				name="reflectNow" checked value="true" /><label for="check_reflect">
			<bean:message key="account.timeout.reflectNow" /></label></td>
		</tr>
	</table>
	<br>
</html:form>
</body>
</html:html>
