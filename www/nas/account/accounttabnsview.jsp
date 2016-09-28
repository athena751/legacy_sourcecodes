<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttabnsview.jsp,v 1.1 2005/07/27 01:02:55 wangli Exp $" -->
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<frameset rows="*,60" border="1">
    <frame src="accountTabnsviewTop.do?operation=display" name="accountTabnsviewTop" border="0">
    <frame src="../common/commonblank.html" name="accountTabnsviewBottom" class="TabBottomFrame">
</frameset>
</html>
