<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: commonexecute.jsp,v 1.2 2007/05/09 04:54:04 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp" %>
</head>
<body onload="parent.bottomframe.displayAlert();">
<form>
    <html:button property="executeBtn" onclick="return parent.bottomframe.onSet();">
        <bean:message key="replicaton.button.execute"/>
    </html:button>
</form>
</body>
</html:html>