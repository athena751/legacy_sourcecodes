<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: quotaset.jsp,v 1.2302 2005/09/01 08:21:18 zhangj Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<% boolean isNsview = NSActionUtil.isNsview(request); %>

<html>
<head>
</head> 

<%if(isNsview){%>
    <frameset rows="*,55%" >
        <frame name="topframe" src="quotasettop.jsp?action=start">
        <frame name="bottomframe" src="/nsadmin/common/commonblank.html">
<%}else{%>
    <frameset rows="*,60%" >
        <frame name="topframe" src="quotasettop.jsp?action=start">
        <frame name="bottomframe" src="quotasetbottom.jsp">
<%}%>

</frameset><noframes></noframes>
</html>