<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: nasheadportinfoframe.jsp,v 1.4 2007/05/09 05:17:44 yangxj Exp $Exp" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.nashead.NasheadActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<bean:define id="isCluster" value="<%=(NSActionUtil.isCluster(request))? "true":"false"%>"/>
<bean:define id="nodeNo" value='<%=request.getParameter("nodeNo")%>'/>
</head>

<body>
<form method="POST">
	
	<%-- single node --%>
	<logic:notEqual name="isCluster" value="true">
		<h2 class="title"><bean:message key="gateway.title.h2.portConnectInfo" bundle="nasheadResource/volume"/></h2>
	</logic:notEqual>
	
	<%-- cluster --%>
	<logic:equal name="isCluster" value="true">
		<logic:equal name="nodeNo" value="0">
			<h2 class="title"><bean:message key="gateway.title.h2.portConnectInfo.node0" bundle="nasheadResource/volume"/></h2>
		</logic:equal>
		<logic:equal name="nodeNo" value="1">
			<h2 class="title"><bean:message key="gateway.title.h2.portConnectInfo.node1" bundle="nasheadResource/volume"/></h2>
		</logic:equal>	
	</logic:equal>

	<!-- exitCode=1 -->
	<logic:notEqual name="exitCode" value="0">
		<bean:message key="gateway.error.getPortInfo" bundle="nasheadResource/volume"/>
	</logic:notEqual>
	
	<!-- exitCode=0 -->
	<logic:equal name="exitCode" value="0">
		<!-- no port information -->
		<logic:empty name="portNoSet">
			<bean:message key="gateway.error.noPort.exist" bundle="nasheadResource/volume"/>
		</logic:empty>
		
		<logic:notEmpty name="portNoSet">
		    <!-- no lun information -->
			<logic:empty name="tableVector">
				<bean:message key="gateway.error.noLun.exist" bundle="nasheadResource/volume"/>
			</logic:empty>  
			
			<logic:notEmpty name="tableVector">
				<table border=1>
					<tr>
						<logic:iterate id="portNo" name="portNoSet">
							<th colspan="3">
								<bean:message key="gateway.info.th.port" bundle="nasheadResource/volume"/>
								<bean:write name="portNo"/>
							</th>
						</logic:iterate>
					</tr>
					<tr>
						<logic:iterate id="portNo" name="portNoSet">
							<th><bean:message key="gateway.info.th.storage" bundle="nasheadResource/volume"/></th>
							<th><bean:message key="gateway.info.th.lun" bundle="nasheadResource/volume"/></th>
							<th><bean:message key="gateway.info.th.state" bundle="nasheadResource/volume"/></th>
						</logic:iterate>
					</tr>
				
					<logic:iterate id="rowVector" name="tableVector">
						<tr>
						<logic:iterate id="lunInfo" name="rowVector">
							<nested:root name="lunInfo">
								<td nowrap><nested:write filter="false" property="storage"/></td>
								<td nowrap><nested:write filter="false" property="LUN"/></td>
								<td nowrap>
									<nested:equal property="state" value="<%=NasheadActionConst.CONSTANT_PORT_STATE_NML%>">
										<bean:message key="gateway.info.state.normal" bundle="nasheadResource/volume"/>
									</nested:equal>
									<nested:equal property="state" value="<%=NasheadActionConst.CONSTANT_PORT_STATE_FLT%>">
										<bean:message key="gateway.info.state.fault" bundle="nasheadResource/volume"/>
									</nested:equal>
									<nested:equal property="state" value="<%=NasheadActionConst.CONSTANT_PORT_STATE_OFFLINE%>">
										<bean:message key="gateway.info.state.offline" bundle="nasheadResource/volume"/>
									</nested:equal>
									<nested:equal property="state" value="<%=NasheadActionConst.CONSTANT_NULL_VALUE%>">
										<nested:write filter="false" property="state"/>
									</nested:equal>
								</td>
							</nested:root>
						</logic:iterate> <!-- rowVector iterate -->
 						</tr>
 					</logic:iterate> <!-- tableVector iterate -->
				</table>		
			</logic:notEmpty> <!-- tableVector not empty -->
		</logic:notEmpty> <!-- portNoSet not empty -->
		
   </logic:equal> <!--exitCode equal 0 -->
	
</form>
</body>
</html:html>