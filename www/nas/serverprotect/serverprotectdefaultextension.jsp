<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectdefaultextension.jsp,v 1.1 2007/03/23 09:43:18 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="serverprotect.title.defaultlist"/></title>
</head>

<Frameset rows="*,60" border="1" >
    <frame name="topframe" src="serverProtectExtensionListTop.do" border="0">
    <frame name="bottomframe" scrolling="no" src="serverProtectExtensionListBottom.do" class="TabBottomFrame">
</Frameset>

</html>