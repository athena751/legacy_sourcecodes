<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicationerror.jsp,v 1.1 2008/05/28 02:09:30 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<form>
<body onload="displayAlert();" onUnload="closeDetailErrorWin();">
<html:button property="reloadBtn" onclick="window.location='/nsadmin/replication/originalAction.do?operation=list';">
	<bean:message key="common.button.reload" bundle="common" />
</html:button>
<displayerror:error h1_key="replicate.h1"/>
<br>
</form>
</body>
</html:html>