<!--
        Copyright (c) 2008 NEC Corporation
        NEC SOURCE CODE PROPRIETARY
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrschedulemodify.jsp,v 1.2 2008/04/30 10:22:25 pizb Exp $" -->
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
<script language="Javascript">

//load the bottom page when this page has been loaded
function loadBtnFrame(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrModifyScheduleBtn.do"/>' + '"',1);
  	}
}

function onModifySchedule(){
	if(isSubmitted()) {
    	return false;
    }
	var scheduleForm = document.forms[0];
	if(checkSchedule(scheduleForm)){
	 	var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
        "<bean:message key="common.confirm.action" bundle="common"/>"+ 
        "<bean:message key="common.button.modify" bundle="common"/>"; 
    	if(confirm(msg)){
    		setSubmitted();
    		lockMenu();
			scheduleForm.action = "ddrSchedule.do?operation=modify";
			scheduleForm.submit();
		}
	}
}
</script>
</head>

<body onload="initSchedule(document.forms[0]);loadBtnFrame();setHelpAnchor('disk_backup_4');" onUnload="unLockMenu();unloadBtnFrame();">
<html:form action="/ddrSchedule.do?operation=modify" method="post">
<input type="button" name="back" value="<bean:message key="common.button.back" bundle="common"/>" onclick="loadDdrPairList();"/>
<h3 class="title"><bean:message key="ddr.h3.modify"/>
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
<nested:nest property="ddrPairInfo">
<nested:hidden property="mvName"/>
<nested:hidden property="rvName"/>
<nested:hidden property="schedule"/>
</nested:nest>
</html:form>
</body>
</html>