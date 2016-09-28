<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rdr_drerrorpage.jsp,v 1.2 2007/05/09 08:23:24 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
<head>
	<%@include file="../../common/head.jsp" %>
</head>
<body onLoad="displayAlert();" onUnload="closeDetailErrorWin();">
	<form>
		<h1 class="title"><bean:message key="rdr_dr.title.h1.rdr_dr"/></h1>
		<displayerror:error h1_key="rdr_dr.title.h1.rdr_dr"/> 
    </form>
</body>
</html:html>