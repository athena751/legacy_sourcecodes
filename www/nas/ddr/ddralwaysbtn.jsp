<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) ddrpairinglistbottom.jsp,v 1.1 2004/02/19 09:49:51 xingyh Exp" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<script language="javaScript">
</script>
</head>
<body>
	<form>
		<html:button property="setBtn" onclick="return parent.bottomframe.onAdd();">
        	<bean:message key="common.button.submit" bundle="common"/>
        </html:button>
	</form>
</body>
</html:html>