<!--
        Copyright (c) 2008 NEC Corporation
        NEC SOURCE CODE PROPRIETARY
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrscheduleadd.jsp,v 1.2 2008/04/30 10:09:32 pizb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<html>
<head>
<title></title>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<%@include file="../../common/head.jsp" %>
<%@include file="../ddr/ddrcommon.jsp" %>
<script language=javascript>
//load the bottom page when this page has been loaded
function loadBtnFrame(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrAddScheduleBtn.do"/>' + '"',1);
  	}
}

function backToAdd(){
	if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    lockMenu();
	window.location = "/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairCreateShow.do?operation=showGeneration";
}

function onAddSchedule(){
	if(isSubmitted()) {
        return false;
    }
	var scheduleForm = document.forms[0];
	if(checkSchedule(scheduleForm)){
    	setSubmitted();
		scheduleForm.action = "ddrConfirm.do?operation=confirm";
		scheduleForm.submit();
	}
}
</script>
</head>
<body onload="initSchedule(document.forms[0]);loadBtnFrame();" onUnload="unLockMenu();unloadBtnFrame();">
<html:form action="ddrConfirm.do?operation=confirm" method="post">
<h3 class="title"><bean:message key="ddr.h3.add"/>
</h3>
<table border=1 width="460px" class="Vertical" nowrap>
  <tr>
    <th><bean:message key="ddr.title.mv"/></th>
    <td><bean:write name="<%=DdrActionConst.REQUEST_DDR_MVNAME4SHOW%>"/></td>
  </tr>
  <tr>
    <th valign="top"><label><bean:message key="ddr.title.rv"/></label></th>
    <td><bean:write name="<%=DdrActionConst.REQUEST_DDR_RVNAME4SHOW%>" filter="false"/></td>
  </tr>
</table>
<br>
<%@include file="../ddr/ddrschedulecommon.jsp" %>
</html:form>
</body>
</html>