<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: directedit.jsp,v 1.18 2007/05/09 06:08:17 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head> 
<Frameset rows="*,60" border="1">
    <frame name="directEditTop" src="../../nfs/directEditTop.do?operation=display" border="0">
    <frame name="directEditBottom" scrolling="no" src="../../nfs/directEditBottom.do" class="TabBottomFrame">
</Frameset>
</html:html>