<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrerror.jsp,v 1.1 2008/04/19 10:11:18 liuyq Exp $" -->
<! DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function reloadEntry(){
	if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    window.location="<html:rewrite page='/ddrEntry.do'/>";
    return true;
}
</script>
</head>
<body onload="displayAlert();";onunload="closeDetailErrorWin();">
<h1 class="title"><bean:message key="ddr.h1"/></h1>
&nbsp;
<html:button property="reloadBtn" onclick="reloadEntry();">
	<bean:message key="common.button.reload" bundle="common" />
</html:button>
<br><br>
<displayerror:error h1_key="ddr.h1"/>
</body>
</html:html>
