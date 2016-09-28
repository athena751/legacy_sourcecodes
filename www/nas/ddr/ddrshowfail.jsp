<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrshowfail.jsp,v 1.4 2008/05/14 09:58:53 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<html>
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="ddrcreatecommon.jsp"%>
<%@ include file="ddrcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function init(){
    loadBottom();
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_ALWAYS%>" scope="request">
    setHelpAnchor('disk_backup_5');
</logic:equal>
<logic:equal name="<%=DdrActionConst.REQUEST_D2D_USAGE%>" value="<%=DdrActionConst.USAGE_GENERATION%>" scope="request">
    setHelpAnchor('disk_backup_6');
</logic:equal>
}
function loadBottom(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '/nsadmin/common/commonblank.html' + '"',1);
  	}
}
</script>
</head>
<body onload="init();"onUnload="unLockMenu();closeDetailErrorWin();">
<html:button property="reloadBtn" onclick="reloadPage();">
   <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<displayerror:error h1_key="ddr.h1"/>
</body>
</html>