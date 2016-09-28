<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrpairextendbottom.jsp,v 1.1 2008/05/04 05:37:50 yangxj Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<script language="javaScript">
function init(){
	parent.bottomframe.displayAlert();
}
</script>
</head>
<body onLoad="init();">
	<form>
		<html:button property="submitBtn" onclick="return parent.bottomframe.onExtendPair();">
        	<bean:message key="common.button.submit" bundle="common"/>
        </html:button>
	</form>
</body>
</html:html>