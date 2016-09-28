<!--    Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation. -->

<!-- "@(#) $Id: nfslognavigator.jsp,v 1.5 2007/05/09 06:08:46 caows Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="nfslog.h2.file.select"/></title>
<html:base/>
</head>
<frameset rows="80%,*">
<frame src="../../nfs/NfsLogNavigatorForwardList.do">
<frame src="../../nfs/NfsLogNavigatorForwardSubmit.do">
</frameset>
</html:html>