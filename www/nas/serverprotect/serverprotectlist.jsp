<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectlist.jsp,v 1.5 2007/06/13 00:39:16 wanghb Exp $" -->

<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.ListSTModel"%>
<%@ page import="java.util.Arrays"%>
<%@ page
	import="com.nec.nsgui.model.entity.serverprotect.ServerProtectGlobalOptionBean"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onReload(){
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    window.location="serverProtectList.do";
}
</script>
</head>
<body onload="setHelpAnchor('nvavs_realtimescan_1');">

<html:button property="reload" onclick="onReload()">
	<bean:message key="common.button.reload" bundle="common" />
</html:button>

<form action="serverProtectList.do" method="post"><logic:equal
	name="haveConfigFile" value="yes" scope="request">

	<logic:equal name="cifs_global" value="no" scope="request">
		<bean:message key="serverprotect.list.notsetcifsglobal" />
	</logic:equal>

	<h3><bean:message key="serverprotect.h3.scanserver" /></h3>
	<bean:define id="scanServer" name="scanServer"
		type="java.util.ArrayList" />
	<nssorttab:table
		tablemodel="<%=new ListSTModel((ArrayList)scanServer)%>"
		id="serverprotect_scanserver" table="border=\" 1\"" sortonload="host">
		<nssorttab:column name="host"
			th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
			td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
			<bean:message key="serverprotect.scanserver.host.th" />
		</nssorttab:column>
		<nssorttab:column name="interfaces"
			th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
			td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
			<bean:message key="serverprotect.scanserver.interface.th" />
		</nssorttab:column>
		<nssorttab:column name="connectStatus"
			th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
			td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
			sortable="yes">
			<bean:message key="serverprotect.scanserver.connectstatus.th" />
		</nssorttab:column>
	</nssorttab:table>

	<h3><bean:message key="serverprotect.h3.scanuser" /></h3>
	<logic:empty name="globalOption" property="ludbUser" scope="request">
		<bean:message key="serverprotect.scanuser.noludbuser" />
	</logic:empty>
	<logic:notEmpty name="globalOption" property="ludbUser" scope="request">
		<table border="1" class="Vertical" nowrap>
			<tr>
				<th valign="top"><bean:message key="serverprotect.scanuser.th" /></th>
				<td>
				<table frame="void" rules="all" border="1">
					<%ServerProtectGlobalOptionBean globalInfo = (ServerProtectGlobalOptionBean) request
							.getAttribute("globalOption");
					String[] ludbuserArray = globalInfo.getLudbUser().trim()
							.split(":");
					for (int i = 0; i < ludbuserArray.length; i++) {

						%>
					<tr>
						<td><%=NSActionUtil.htmlSanitize(ludbuserArray[i])%></td>
					</tr>
					<%}%>
				</table>
				</td>
			</tr>
		</table>
	</logic:notEmpty>

	<h3><bean:message key="serverprotect.h3.extension" /></h3>
	<table border="1" class="Vertical" nowrap>
		<th valign="top"><bean:message
			key="serverprotect.realtimescan.targetfile.th" /></th>
		<td><logic:empty name="globalOption" property="extension">
			<bean:message key="serverprotect.realtimescan.targetfile.td.all" />
		</logic:empty> <logic:notEmpty name="globalOption"
			property="extension">
			<%ServerProtectGlobalOptionBean globalInfo = (ServerProtectGlobalOptionBean) request
							.getAttribute("globalOption");
					String[] extensionArray = globalInfo.getExtension().trim()
							.split(",");
					Arrays.sort(extensionArray);
					int length = extensionArray.length;
					String divHeight = (length > 42) ? "178px" : "auto";
					String overFlow = (length > 42) ? "auto" : "visible";

					%>
			<table>
				<tr>
					<td><bean:message
						key="serverprotect.realtimescan.targetfile.td.extension" /></td>
				</tr>
				<tr>
					<td>
					<DIV
						style="overflow: <%=overFlow %>; width: auto; height: <%=divHeight%>; ">
					<table border="1">

						<%int row = 6;
					int extensionNumber = extensionArray.length;
					for (int i = 0; i < extensionNumber; i++) {
						if (i % row == 0) {%>
						<tr>
							<%}%>
							<td width="60"><%if (extensionArray[i].equals(".")) {%> <bean:message
								key="serverprotect.realtimescan.targetfile.td.null" /> <%} else {%>
							<%=NSActionUtil
											.htmlSanitize(extensionArray[i]
													.replaceAll("\\.", ""))%><%}%></td>
							<%if (i % row == row - 1) {%>
						</tr>
						<%}%>
						<%}%>
						<%if (extensionNumber % row != 0) {%>
						<%for (int j = 0; j < row - extensionNumber % row; j++) {%>
						<td width="60">&nbsp;</td>
						<%}%>
						</tr>
						<%}%>
					</table>
					</DIV>
					</td>
				</tr>
			</table>
		</logic:notEmpty></td>
	</table>

	<h3><bean:message key="serverprotect.h3.scantarget" /></h3>
	<logic:empty name="scanTarget">
		<bean:message key="serverprotect.scanuser.notsetshare" />
	</logic:empty>
	<logic:notEmpty name="scanTarget">
		<bean:define id="scanTarget" name="scanTarget"
			type="java.util.ArrayList" />
		<nssorttab:table
			tablemodel="<%=new ListSTModel((ArrayList)scanTarget)%>"
			id="serverprotect_scanTarget" table="border=\" 1\"" titleTrNum="2"
			sortonload="shareName">
			<nssorttab:column name="shareName"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
				<bean:message key="serverprotect.scantarget.sharename.th" />
			</nssorttab:column>
			<nssorttab:column name="readCheck"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
				sortable="no">
				<bean:message key="serverprotect.scantarget.readcheck.th" />
			</nssorttab:column>
			<nssorttab:column name="writeCheck"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
				sortable="no">
				<bean:message key="serverprotect.scantarget.writecheck.th" />
			</nssorttab:column>
			<nssorttab:column name="sharePath"
				th="com.nec.nsgui.action.serverprotect.ServerProtectTHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
				<bean:message key="serverprotect.scantarget.sharedirectory.th" />
			</nssorttab:column>
		</nssorttab:table>
	</logic:notEmpty>
</logic:equal> <logic:equal name="haveConfigFile" value="no"
	scope="request">
	<bean:message key="serverprotect.message.noconfigfile" />
</logic:equal></form>
</body>
</html>
