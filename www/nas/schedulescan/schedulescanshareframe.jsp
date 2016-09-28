<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: schedulescanshareframe.jsp,v 1.1 2008/05/08 08:54:48 chenbc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%@include file="../../common/head.jsp" %>
<Frameset rows="*,60" border="1">
    <frame name="topframe" src="scheduleScanShare.do?operation=getShareInfo" border="0">
    <frame name="bottomframe" src="scheduleScanShareBottom.do" scrolling="no" class="TabBottomFrame">    
</Frameset>
</html>