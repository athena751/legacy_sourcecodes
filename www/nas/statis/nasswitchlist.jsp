<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchlist.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<bean:parameter id="graphType" name="graphType"/>
</head>
<frameset rows="*,60">
	<frame name="contentframe" scrolling="auto" frameborder="0" noresize src="nasswitchList.do?operation=displayListTop&graphType=<%=graphType%>">
	<frame name="buttonframe" scrolling="auto" frameborder="0" src="/nsadmin/common/commonblank.html"  class="TabBottomFrame">
</frameset>

</html>
