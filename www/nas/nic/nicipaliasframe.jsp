<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicipaliasframe.jsp,v 1.1 2007/08/23 07:46:45 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<frameset rows="*,60" border="1">
    <frame src="nicIPAliasTop.do?operation=display" name="nicIPAliasTop" border="0">
    <frame src="../common/commonblank.html" name="nicIPAliasBottom" class="TabBottomFrame">
</frameset>
</html>
