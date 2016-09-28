<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemerror.jsp,v 1.3 2007/05/09 08:05:31 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<body onload="displayAlert();" onUnload="closeDetailErrorWin();">

<h1 class="title"><bean:message key="h1.filesystem"/></h1>

<br><br>
<displayerror:error h1_key="h1.filesystem"/>
<br>
<form>

</form>
</body>
</html:html>