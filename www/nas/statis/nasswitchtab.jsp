<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchtab.jsp,v 1.2 2005/10/24 12:28:16 pangqr Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="../common/tab.js"></script>
</head>
<body>
<div class="h1">
<h1 id="title">
  <bean:message name="watchItemDesc"/>
</h1>
</div>

    <bean:define id="displayonload" value="0" type="java.lang.String"/>
    <logic:equal name="graphType" value="Daily">
       <bean:define id="displayonload" value="0" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="graphType" value="Weekly">
       <bean:define id="displayonload" value="1" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="graphType" value="Monthly">
       <bean:define id="displayonload" value="2" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="graphType" value="Yearly">
       <bean:define id="displayonload" value="3" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="graphType" value="User Specification">
       <bean:define id="displayonload" value="4" type="java.lang.String"/>
    </logic:equal>
  
  <nstab:nstab displayonload="<%=displayonload%>">
    <nstab:subtab url="forwardToList.do?graphType=Daily"><bean:message key="RRDGraph.button_daily"/></nstab:subtab>
	<nstab:subtab url="forwardToList.do?graphType=Weekly"><bean:message key="RRDGraph.button_weekly"/></nstab:subtab>
	<nstab:subtab url="forwardToList.do?graphType=Monthly"><bean:message key="RRDGraph.button_monthly"/></nstab:subtab>   
	<nstab:subtab url="forwardToList.do?graphType=Yearly"><bean:message key="RRDGraph.button_yearly"/></nstab:subtab>
	<nstab:subtab url="forwardToList.do?graphType=User Specification"><bean:message key="RRDGraph.button_custom"/></nstab:subtab>
	<nstab:subtab url="rrdpropertyFrame.do"><bean:message key="RRDGraph.submit_options"/></nstab:subtab>
  </nstab:nstab>
</body>
</HTML>
