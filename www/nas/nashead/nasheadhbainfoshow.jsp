<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#):$Id: nasheadhbainfoshow.jsp,v 1.4 2007/05/09 05:17:44 yangxj Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.lang.*,com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>

<html:html lang="true">

<% 	
	Vector exitCodeVector = (Vector)request.getAttribute("exitCodeVector");
    Vector hbaInfoVector  = (Vector)request.getAttribute("hbaInfoVector"); 
%>

<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function init() {

	document.forms[0].portConnectInfoBtn.disabled = true;
	
	
	<logic:iterate id="exitCode" indexId="nodeNo" name="exitCodeVector"> 
	 	<logic:equal name="exitCode" value="0">
			<logic:equal name="nodeNo" value="0">
				<bean:define id="portInfoVectorSize" 			
							 value="<%=Integer.toString(((Vector)(hbaInfoVector.get(0))).size())%>"/>
			</logic:equal>
	
			<logic:equal name="nodeNo" value="1">
				<bean:define id="portInfoVectorSize" 
							 value="<%=Integer.toString(((Vector)(hbaInfoVector.get(1))).size())%>"/>
			</logic:equal> 
		 
		    <logic:notEqual name="portInfoVectorSize" value="0">
				document.forms[0].portConnectInfoBtn.disabled = false;
			</logic:notEqual>
		</logic:equal>
	</logic:iterate> 
	

}

function openPortConnectInfo() {
	if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location = "<html:rewrite page='/nasheadPortInfoFramesetShow.do'/>"; 
}
</script>
</head>

<body onload="init()">
<bean:define id="isNashead" value="<%=(NSActionUtil.isNashead(request))? "true":"false"%>"/>
<logic:equal name="isNashead" value="true">
	<h1 class="title"><bean:message key="gateway.title.h1.gateway" bundle="nasheadResource/volume"/></h1>
</logic:equal>
<logic:notEqual name="isNashead" value="true" >
	<h1 class="title"><bean:message key="gateway.title.h1.hba" bundle="nasheadResource/volume"/></h1>
</logic:notEqual>

<h2 class="title"><bean:message key="gateway.title.h2.hbaInfo" bundle="nasheadResource/volume"/></h2>

<form method="POST">
<html:button property="portConnectInfoBtn" onclick="return openPortConnectInfo();">
	<bean:message key="gateway.button.portConnectInfo" bundle="nasheadResource/volume"/> 
</html:button>

<br><br>
<logic:iterate id="portInfoVector" indexId="nodeNo" name="hbaInfoVector">
		
	<%-- display Node0 or Node1--%>
	<logic:equal name="isCluster" value="true">
		<h3 class="title"><bean:message key="gateway.title.h3.node" bundle="nasheadResource/volume"/><%=nodeNo%></h3>
	</logic:equal>
    
	<logic:equal name="nodeNo" value="0">
		<bean:define id="exitCode" value="<%=(String)exitCodeVector.get(0)%>"/>
	</logic:equal>
	
	<logic:equal name="nodeNo" value="1">
		<bean:define id="exitCode" value="<%=(String)exitCodeVector.get(1)%>"/>
	</logic:equal>
			 
	<logic:notEqual name="exitCode" value="0">
		
		<bean:message key="gateway.error.getHbaInfo" bundle="nasheadResource/volume"/>
	</logic:notEqual>
	
	<logic:equal name="exitCode" value="0">
		<logic:empty name="portInfoVector">
			<bean:message key="gateway.error.noHbaCard" bundle="nasheadResource/volume"/>
		</logic:empty>
	
		<logic:notEmpty name="portInfoVector">
			<table border=1>
				<tr>
					<th>&nbsp;</th>
					<th align="center"><bean:message key="gateway.info.th.wwnn" bundle="nasheadResource/volume"/></th>
					<th align="center"><bean:message key="gateway.info.th.wwpn" bundle="nasheadResource/volume"/></th>
				</tr>
			
				<logic:iterate id="portInfo" name="portInfoVector">
					<tr>
				    	<nested:root name="portInfo">
							<th>
								<bean:message key="gateway.info.th.port" bundle="nasheadResource/volume"/>
								<nested:write property="portNo"/>
							</th>
							<td nowrap><nested:write property="nodeName"/></td>
							<td nowrap><nested:write property="portName"/></td>
						</nested:root>
					</tr>
				</logic:iterate>  <!-- portInfoVector iterate -->
			
			</table>
			<br>
		</logic:notEmpty> <!-- portInfoVector notEmpty -->
	</logic:equal> <!-- exitCode equal "0" -->
</logic:iterate>  <!-- hbaInfoVector iterate -->
</form>

</body>

</html:html>
