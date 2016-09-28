<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communitylistframe.jsp,v 1.2 2007/09/12 11:33:37 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head> 
  <Frameset rows="*,60px" border="1">
	<frame name="communityListTop" src="community.do?operation=displayList" border="0">
	<frame name="communityListBottom" src="communityListBottom.do" class="TabBottomFrame">
</Frameset>
</html>