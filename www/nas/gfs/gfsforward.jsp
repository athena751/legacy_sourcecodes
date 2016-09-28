<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: gfsforward.jsp,v 1.2 2005/11/11 06:08:03 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.model.biz.license.LicenseInfo" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
</head>

<%
    LicenseInfo license=LicenseInfo.getInstance();
    int nodeNo = NSActionUtil.getCurrentNodeNo(request);
    if ((license.checkAvailable(nodeNo,"gfs"))!=0){
%>
	<Frameset rows="83,*">
	    <frame name="topframe"    scrolling="no"   frameborder="0" src="gfsTop.do" noresize>
	    <frame name="bottomframe" scrolling="auto" frameborder="0" src="/nsadmin/common/commonblank.html">
	</Frameset>
<%}else{%>
    <jsp:forward page='../../framework/noLicense.do'>
        <jsp:param name="licenseKey" value="gfs"/>
    </jsp:forward>
<%}%>

</html>