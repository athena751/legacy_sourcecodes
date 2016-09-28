<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: niclinkstatustop.jsp,v 1.7 2007/05/09 06:46:23 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">

<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
		var buttonEnable = 0;
		
			function enableSet() {
				<logic:present name="linkStatusList">
					buttonEnable = 1;
					if(window.parent.frames[1].document&&window.parent.frames[1].document.forms[0]) {
						window.parent.frames[1].changeButtonStatus();
					}
				</logic:present>
			}
			
			function onBack() {
		       if(isSubmitted()){
                   return false;
                }
                setSubmitted();
                <logic:equal name="nic_from4change" value ="service">
					parent.location = "/nsadmin/nic/nicList.do";
				</logic:equal>
				<logic:notEqual name="nic_from4change" value ="service">
					parent.location = "/nsadmin/nic/adminList.do";
				</logic:notEqual>
				return true;
			}
			
			function onChangeAutoNego(autoNego,communicationStatus) {
				if(autoNego.value == "enable") {
					communicationStatus.disabled = true;
				}
				else if(autoNego.value == "disable") {
					communicationStatus.disabled = false;
				}
			}
			
			function onConfirm() {
			  if (isSubmitted()){
             return false;
        }
				<logic:iterate id="linkStatus" name="linkStatusList" indexId="i">
					if(document.forms[0].elements["linkStatusSet[<%=i%>].autoNego"].value != "enable" && document.forms[0].elements["linkStatusSet[<%=i%>].communicationStatus"].value == "unknown") {
						alert("<bean:message key ="nic.linkStatus.unknownMode" />");
						return false;
					}
				</logic:iterate>
				var confirmStr = '<bean:message key="common.confirm" bundle="common"/>\r\n'+
                         '<bean:message key="common.confirm.action" bundle="common"/>'+
                         '<bean:message key="common.button.submit" bundle="common"/>';
                <logic:notEqual name="nic_from4change" value ="service">
                         confirmStr = confirmStr +'\r\n\r\n'+
                         '<bean:message key="nic.admin.mediamode.confirm"/>';
                </logic:notEqual>
				if(confirm(confirmStr)) {
						setSubmitted();
            			document.forms[0].submit();
            			return true;
            		}
            	else
            		return false;
			}
			
	function onRefresh(){
	   if(isSubmitted()){
           return false;
       }
       setSubmitted();
	   parent.location="/nsadmin/nic/linkStatus.do";
	}
		</script>
</head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<body onload="displayAlert();enableSet();
                <logic:equal name="nic_from4change" value ="service">
                    setHelpAnchor('s_network_3');
                </logic:equal>
                <logic:notEqual name="nic_from4change" value ="service">
                    setHelpAnchor('m_network_2');
                </logic:notEqual>
" onUnload="closeDetailErrorWin();">
<html:form action="linkStatusSet.do" method="post" target="_parent">
	<html:button property="back" onclick="return onBack();">
		<bean:message key="common.button.back" bundle="common" />
	</html:button>
	<html:button property="refreshBtn" onclick="onRefresh();">
       <bean:message key="common.button.reload" bundle="common"/>
    </html:button> 
	<h3><bean:message key="nic.h3.linkStatus" /></h3>
    <logic:equal name="nic_from4change" value ="service">
        <displayerror:error h1_key="nic.h1.servicenetwork" /><br>
    </logic:equal>
    <logic:notEqual name="nic_from4change" value ="service">
        <displayerror:error h1_key="nic.h1.adminnetwork" /><br>
    </logic:notEqual>
	
	<logic:present name="linkStatusList" scope="request">
		<table border="1">
			<tr>
				<th><bean:message key="nic.linkStatus.nicName" /></th>
				<th><bean:message key="nic.linkStatus.nicLinkStatus" /></th>
				<th><bean:message key="nic.linkStatus.autoNego" /></th>
				<th><bean:message key="nic.linkStatus.communicationMode" /></th>
			</tr>
			<logic:iterate id="linkStatus" name="linkStatusList" indexId="i">
				<tr>
					<td nowrap><input type="hidden"
						name="linkStatusSet[<%=i%>].nicName"
						value='<bean:write name="linkStatus" property="nicName"/>'> <bean:write
						name="linkStatus" property="nicName" /></td>
					<td nowrap align="center"><logic:equal name="linkStatus"
						property="linkStatus" value="UP">
						<img border="0" src="/nsadmin/images/nation/correct.gif" />
					</logic:equal><logic:notEqual name="linkStatus"
						property="linkStatus" value="UP">
						<img border="0" src="/nsadmin/images/nation/incorrect.gif" />
					</logic:notEqual></td>
					<td nowrap><select id="autoNego<%=i%>"
						name="linkStatusSet[<%=i%>].autoNego"
						onchange="onChangeAutoNego(autoNego<%=i%>,communicationStatus<%=i%>)">
						<option value="enable"
							<logic:equal name="linkStatus" property="autoNego" value="enable">selected</logic:equal>><bean:message
							key="nic.linkStatus.enable" /></option>
						<option value="disable"
							<logic:equal name="linkStatus" property="autoNego" value="disable">selected</logic:equal>><bean:message
							key="nic.linkStatus.disable" /></option>
					</select></td>
					<td nowrap><select id="communicationStatus<%=i%>"
						name="linkStatusSet[<%=i%>].communicationStatus"
						<logic:equal name="linkStatus" property="autoNego" value="enable">disabled</logic:equal>>
						<option value="1000full"
							<logic:equal name="linkStatus" property="communicationStatus" value="1Gbps Full-Duplex">selected</logic:equal>><bean:message
							key="nic.linkStatus.1GFull" /></option>
						<option value="1000half"
							<logic:equal name="linkStatus" property="communicationStatus" value="1Gbps Half-Duplex">selected</logic:equal>><bean:message
							key="nic.linkStatus.1GHalf" /></option>
						<option value="100full"
							<logic:equal name="linkStatus" property="communicationStatus" value="100Mbps Full-Duplex">selected</logic:equal>><bean:message
							key="nic.linkStatus.100MFull" /></option>
						<option value="100half"
							<logic:equal name="linkStatus" property="communicationStatus" value="100Mbps Half-Duplex">selected</logic:equal>><bean:message
							key="nic.linkStatus.100MHalf" /></option>
						<option value="10full"
							<logic:equal name="linkStatus" property="communicationStatus" value="10Mbps Full-Duplex">selected</logic:equal>><bean:message
							key="nic.linkStatus.10MFull" /></option>
						<option value="10half"
							<logic:equal name="linkStatus" property="communicationStatus" value="10Mbps Half-Duplex">selected</logic:equal>><bean:message
							key="nic.linkStatus.10MHalf" /></option>
						<logic:equal name="linkStatus" property="communicationStatus" value="Unknown">
							<option value="unknown" selected><bean:message key="nic.linkStatus.unknown" /></option>
						</logic:equal>
					</select></td>
				</tr>
			</logic:iterate>
		</table>
	</logic:present>
</html:form>
</body>
</html:html>
