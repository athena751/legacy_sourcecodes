<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsdctop.jsp,v 1.2 2006/05/12 09:38:22 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
    
    function onRefresh(){
       if(isSubmitted()){
           return false;
       }
       setSubmitted();
       parent.location="/nsadmin/cifs/cifsDCFrame.do";
    }
</script>
</head>
<body onload="displayAlert();setHelpAnchor('network_cifs_15');"
	onUnload="closeDetailErrorWin();">
<form method="post" target="_parent"><html:button property="refreshBtn"
	onclick="onRefresh();">
	<bean:message key="common.button.reload" bundle="common" />
</html:button><br><br>
<displayerror:error h1_key="cifs.h3.dcAccessStatus" />
<logic:notEmpty name="<%=CifsActionConst.REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD%>" scope="request">
    <bean:define id="errorMsg" name="<%=CifsActionConst.REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD%>" scope="request" type="java.lang.String" />
    <bean:message key="<%=errorMsg%>" />
</logic:notEmpty>
<logic:empty name="<%=CifsActionConst.REQUEST_CIFS_GET_DCCONNECTIONSTATUS_FAILD%>" scope="request">
    <logic:empty
	name="dcAccessStatus" scope="request">
	<bean:message key="cifs.dc.connectionStatusCannotGet" />
</logic:empty> <logic:notEmpty name="dcAccessStatus" scope="request">
<table style="background-image: url('blank.gif');background-color: White;">
	<tr><td align="right"><bean:write name="<%=CifsActionConst.REQUEST_CIFS_SYSDATE%>" scope="request" />&nbsp;
	<bean:message key="cifs.dc.now" /></td></tr>
	<tr><td>
	<table border="1">
		<tr>
			<th><bean:message key="cifs.dc.priority" /></th>
			<th><bean:message key="cifs.dc.domainController" /></th>
			<th><bean:message key="cifs.dc.accessStat" /></th>
			<th><bean:message key="cifs.dc.accessInfo" /></th>
		</tr>

		<logic:iterate id="dcAccess" name="dcAccessStatus" indexId="i">
			<tr>
				<td nowrap align="center"><bean:write name="dcAccess"
					property="priority" /></td>
				<td nowrap align="left"><bean:define id="domainController"
					name="dcAccess" property="domainController" type="java.lang.String" />
				<%=NSActionUtil.sanitize(domainController)%></td>
				<td nowrap align="left"><logic:equal name="dcAccess"
					property="accessStat" value="o">
					<bean:message key="cifs.dc.connectionstatus.connected" />
				</logic:equal><logic:equal name="dcAccess" property="accessStat"
					value="x">
					<bean:message key="cifs.dc.connectionstatus.error" />
				</logic:equal> <logic:notEqual name="dcAccess" property="accessStat"
					value="o">
					<logic:notEqual name="dcAccess" property="accessStat" value="x">
						<bean:message key="cifs.dc.connectionstatus.unused" />
					</logic:notEqual>
				</logic:notEqual></td>
				<td nowrap align="left"><logic:notEmpty name="dcAccess"
					property="accessInfo">
					<bean:define id="accessInfo" name="dcAccess" property="accessInfo"
						type="java.lang.String" />
					<%=NSActionUtil.sanitize(accessInfo)%>
				</logic:notEmpty> <logic:empty name="dcAccess" property="accessInfo">
					&nbsp;
				</logic:empty></td>
			</tr>
		</logic:iterate>
	</table>
	</td></tr>
</table>
    </logic:notEmpty>
</logic:empty>
</form>
</body>
