<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingnstab.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="taglib-nstab"   prefix="nstab"%>
<%@ page import="com.nec.nsgui.action.statis.CollectionConst3" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
    <SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
</head>
<%  String vp=CollectionConst3.STATIS_NFS_VIRTUAL_PATH;
    String server=CollectionConst3.STATIS_NFS_SEVER;
    String node=CollectionConst3.STATIS_NFS_NODE;
    String virtualpathStr="nswsampling.do?operation=tabSwitch&colItemID="+vp;
    String serverStr="nswsampling.do?operation=tabSwitch&colItemID="+server;
    String nodeStr="nswsampling.do?operation=tabSwitch&colItemID="+node;  %>
<body>
    <div class="h1">
        <h1 class="title"><bean:message key="statis.nsw_sampling.h1"/></h1>
    </div>
    <nstab:nstab displayonload="0">
        <nstab:subtab url="<%=virtualpathStr%>">
            <bean:message key="statis.nsw_sampling.nstab.virtualpath"/>
        </nstab:subtab>
        <nstab:subtab url="<%=serverStr%>">
            <bean:message key="statis.nsw_sampling.nstab.severhost"/>
        </nstab:subtab>
        <nstab:subtab url="<%=nodeStr%>">
            <bean:message key="statis.nsw_sampling.nstab.node"/>
        </nstab:subtab>
    </nstab:nstab>
</body>
</html>
