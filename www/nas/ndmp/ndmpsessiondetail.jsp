<!--
        Copyright (c) 2006-2007 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ndmpsessiondetail.jsp,v 1.3 2007/05/09 06:43:41 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="ndmp.session.title.sessionDetail"/></title>
</head> 
<Frameset rows="*,60">
    <frame name="ndmpsessiondetailtop" src="ndmpDetailTop.do">
    <frame name="ndmpsessiondetailbottom" scrolling="no" src="ndmpDetailBottom.do">
</Frameset>
</html:html>