<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicdetail.jsp,v 1.2 2005/10/24 04:40:02 dengyp Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="nic.h2.nicDetail"/></title>
</head>
<frameset rows="*,60">
    <frame src="nicDetailTop.do" name="nicDetailTop" >
    <frame src="nicDetailBottom.do" name="nicDetailBottom"  >
</frameset>
</html>
