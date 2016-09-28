<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfsdetail.jsp,v 1.14 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head> 
<Frameset rows="*,60" border="1">
    <frame name="nfsDetailTop" src="../../nfs/nfsDetailTop.do?operation=display" border="0">
    <frame name="nfsDetailBottom" scrolling="no" src="../../nfs/nfsDetailBottom.do" class="TabBottomFrame">
</Frameset>
</html:html>