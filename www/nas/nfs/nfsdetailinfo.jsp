<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfsdetailinfo.jsp,v 1.3 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<html:html lang="true">
<head>
<title><bean:message key="h2.export.detail"/></title>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head> 
<Frameset rows="146,*, 60">
    <frame name="nfsDetailInfoTop" scrolling="no" src="../../nfs/nfsDetailInfoTop.do">
    <frame name="nfsDetailInfoMid" src="../../nfs/nfsDetailInfoMid.do">
    <frame name="nfsDetailInfoBottom" scrolling="no" src="../../nfs/nfsDetailInfoBottom.do">
</Frameset>
</html:html>