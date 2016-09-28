<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snapshottop.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="taglib-nstab"   prefix="nstab"%>
<%@ taglib uri="struts-bean"    prefix="bean" %>
<%@ taglib uri="struts-logic"   prefix="logic"%>

<html>
<head>
	<%@include file="../../common/head.jsp" %>
	<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
	<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
</head>

<body>
<div class="h1">
    <h1 class="title">
        <bean:message key='<%=request.getParameter("watchItemDesc")%>' />
    </h1>
</div>

<bean:parameter id="defaultGraphType" name="defaultGraphType" />
<bean:define id="displayonload" value="0" type="java.lang.String"/>
<logic:equal name="defaultGraphType" value="Bar1">
   <bean:define id="displayonload" value="0" type="java.lang.String"/>
</logic:equal>
<logic:equal name="defaultGraphType" value="Bar2">
   <bean:define id="displayonload" value="1" type="java.lang.String"/>
</logic:equal>
<logic:equal name="defaultGraphType" value="Pie">
   <bean:define id="displayonload" value="2" type="java.lang.String"/>
</logic:equal>

<nstab:nstab displayonload="<%=displayonload%>">
    <nstab:subtab url="snapshot.do?operation=displayList&graphType=Bar1&sortKey=mountPoint&orderFlag=true&sortKey=mountPoint&orderFlag=true">
        <bean:message key="statis.snapshot.graphtype.bar1"/>
    </nstab:subtab>
    <nstab:subtab url="snapshot.do?operation=displayList&graphType=Bar2&sortKey=mountPoint&orderFlag=true&sortKey=mountPoint&orderFlag=true">
        <bean:message key="statis.snapshot.graphtype.bar2"/>
    </nstab:subtab>
    <nstab:subtab url="snapshot.do?operation=displayList&graphType=Pie&sortKey=mountPoint&orderFlag=true&sortKey=mountPoint&orderFlag=true">
        <bean:message key="statis.snapshot.graphtype.pie"/>
    </nstab:subtab>
</nstab:nstab>

</body>
</html>