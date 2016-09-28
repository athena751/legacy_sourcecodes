<!--
        Copyright (c) 2008 NEC Corporation
        NEC SOURCE CODE PROPRIETARY
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ddrconfirm.jsp,v 1.4 2008/04/30 10:13:02 pizb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ page import="java.util.ArrayList"%>
<html>
<head>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<%@include file="../../common/head.jsp" %>
<%@include file="../ddr/ddrcommon.jsp" %>
<script language=javascript>
var  heartBeatWin;

//load the bottom page when this page has been loaded
function loadBtnFrame(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrCreateConfirmBtn.do"/>' + '"',1);
  	}
}
function backToSchedule(){
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
	window.location = "ddrConfirm.do?operation=addSchedule";
}
function backToAdd(){
	if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    lockMenu();
    window.location = "/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairCreateShow.do?operation=showGeneration";
}
function onAdd(){
	if (isSubmitted()) {
        return false;
    }
   
    var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
        "<bean:message key="common.confirm.action" bundle="common"/>"+ 
        "<bean:message key="common.button.create" bundle="common"/>"; 
   	if(!confirm(msg)){
    	return false;
    }
    setSubmitted();
    heartBeatWin = openHeartBeatWin();
    lockMenu();
    window.location = "ddrPairCreate.do?operation=generationRepl";
    return true;
}
</script>
<title></title>
</head>
<body onload="loadBtnFrame();" onUnload="unLockMenu();closePopupWin(heartBeatWin);unloadBtnFrame();">
<form name=schedule action="ddrPairCreate.do?operation=generationRepl" method="post">
<input type="button" name="backBtn" value="<bean:message key="common.button.back" bundle="common"/>" onclick="backToAdd();"/>
<h3 class="title"><bean:message key="ddr.h3.confirm"/>
</h3>
<table border="1" width="650px" nowrap>
<tbody>
	<tr>
		<th><bean:message key="ddr.title.mv"/></th>
		<th><bean:message key="ddr.title.rv"/></th>
		<th><bean:message key="info.pool"/></th>
		<th><bean:message key="info.pool.raidType"/></th>
		<th><bean:message key="pair.info.schedule"/></th>
	</tr>
	<%ArrayList rvInfoList = (ArrayList)request.getAttribute(DdrActionConst.REQUEST_DDR_RVINFOLIST);
	%>
	<logic:iterate id="rv" collection="<%=rvInfoList%>" type="com.nec.nsgui.model.entity.ddr.DdrVolInfoBean" offset="0" length="1">
		<tr>
			<td valign="top" rowspan="<%=rvInfoList.size()%>"><bean:write name="<%=DdrActionConst.REQUEST_DDR_MVNAME4SHOW%>"/></td>
			<td valign="top"><bean:write name="rv" property="name"/></td>
			<td valign="top"><%=rv.getPoolName().replaceAll(",","<br>")%></td>
			<td valign="top"><bean:write name="rv" property="raidType"/></td>
			<td valign="top" nowrap rowspan="<%=rvInfoList.size()%>">&nbsp;<bean:write name="<%=DdrActionConst.REQUEST_DDR_SCHEDULE4SHOW%>" filter="false"/>&nbsp;</td>
		</tr>
    </logic:iterate>
	<logic:iterate id="rv" collection="<%=rvInfoList%>" type="com.nec.nsgui.model.entity.ddr.DdrVolInfoBean" offset="1" indexId="indexId">
		<tr>
			<td><bean:write name="rv" property="name"/></td>
			<td><%=rv.getPoolName().replaceAll(",","<br>")%></td>
			<td><bean:write name="rv" property="raidType"/></td>
		</tr>
    </logic:iterate>
</tbody>
</table>
<br>
</form>
</body>
</html>