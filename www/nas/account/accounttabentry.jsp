<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttabentry.jsp,v 1.1 2005/07/27 01:02:55 wangli Exp $" -->
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<Frameset rows="83,*" border="0">
    <frame name="topframe" scrolling="no" src="accountTabTop.do">
    <frame name="bottomframe" scrolling="auto" src="../common/commonblank.html">
</Frameset>
</html>
