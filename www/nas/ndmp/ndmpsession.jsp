<!--
        Copyright (c) 2006-2007 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: ndmpsession.jsp,v 1.3 2007/05/09 05:52:10 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<head>
<%@include file="../../common/head.jsp"%>
</head>
<html:html lang="true">
<Frameset rows="*,60" border="1">
    <frame name="ndmpSessionTop" src="ndmpSessionAction.do?operation=getSessionInfo" border="0">
    <frame name="ndmpSessionBottom" scrolling="no" src="ndmpSessionBottom.do" class="TabBottomFrame">
</Frameset>
</html:html>