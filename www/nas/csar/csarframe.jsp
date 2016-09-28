<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: csarframe.jsp,v 1.1 2008/02/15 06:10:16 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%@include file="../../common/head.jsp" %>
<Frameset rows="*,60,0" border="1">
    <frame name="topframe" src="csarTop.do">
    <frame name="bottomframe" src="csarBottom.do" scrolling="no" class="TabBottomFrame">
    <frame name="downloadframe" src="/nsadmin/common/commonblank.html" frameborder="0" scrolling="no" noresize nofocus>
</Frameset>
</html>