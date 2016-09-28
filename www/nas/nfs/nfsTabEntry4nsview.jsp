<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfsTabEntry4nsview.jsp,v 1.1 2005/07/26 11:11:23 wangzf Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" buffer="32kb"%>
<%@ page import="com.nec.nsgui.model.biz.license.LicenseInfo" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
</head>
<%
    LicenseInfo license=LicenseInfo.getInstance();
    int nodeNo = NSActionUtil.getCurrentNodeNo(request);
    if ((license.checkAvailable(nodeNo,"nfs"))!=0){
%>
<Frameset rows="83,*">
    <frame name="topframe" scrolling="no" src="tabTop4nsview.do" frameborder="0">
    <frame name="bottomframe" scrolling="auto" frameborder="0" src="/nsadmin/common/commonblank.html">
</Frameset>
<%
    }else{
%>
    <jsp:forward page='../../framework/noLicense.do'>
        <jsp:param name="licenseKey" value="nfs"/>
    </jsp:forward>
<%
    }
%>
</html>