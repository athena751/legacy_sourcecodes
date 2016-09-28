<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingsettingframe.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
</head>
<Frameset rows="*,150,60" border="0">
    <frame name="nswsamplingsettingtop" src="nswsampling.do?operation=initSettingList">
    <frame name="nswsamplingsettingmid" src="nswsampling.do?operation=initSettingMid" class="TabBottomFrame">
    <frame name="nswsamplingsettingbot" src="nswsamplingsettingbottom.do" class="TabBottomFrame">
</Frameset>
</html>
