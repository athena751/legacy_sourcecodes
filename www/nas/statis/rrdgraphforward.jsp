<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdgraphforward.jsp,v 1.2 2005/10/21 06:55:19 liuhy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<html>
<head>
</head>
<frameset rows="83,*">
    <frame name="topframe" src="rrdgraphtop.do?watchItemDesc=<bean:write name="watchItemDesc"/>" scrolling="auto" frameborder="0" noresize>
    <frame name="bottomframe" scrolling="auto" frameborder="0" src="/nsadmin/common/commonblank.html">
</frameset>
</html>
