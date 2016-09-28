<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: sprrdgraphforward.jsp,v 1.1 2007/03/07 05:18:16 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
</head>
    <frameset rows="108,*">
        <frame name="topframe" src="sprrdgraphtop.do?watchItemDesc=<bean:write name="watchItemDesc"/>" scrolling="auto" frameborder="0" noresize>
        <frame name="bottomframe" scrolling="auto" frameborder="0" src="/nsadmin/common/commonblank.html">
    </frameset>
</html>
