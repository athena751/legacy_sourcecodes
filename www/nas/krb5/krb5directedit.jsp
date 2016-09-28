<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: krb5directedit.jsp,v 1.2 2007/05/09 08:24:21 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
</head> 
<Frameset rows="*,60" border="1">
    <frame name="topFrame" src="krb5FileTop.do?operation=readKrb5File" border="0">
    <frame name="bottomFrame" scrolling="no" src="/nsadmin/common/commonblank.html" class="TabBottomFrame">
</Frameset>
</html:html>