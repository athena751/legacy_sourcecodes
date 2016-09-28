<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: sprrdgraphtop.jsp,v 1.1 2007/03/07 05:18:16 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-nstab" prefix="nstab" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="../common/tab.js"></script>
<bean:parameter id="watchItemDesc" name="watchItemDesc"/>
</head>
<body>
<div class="h1">
<h1 class="title">
    <bean:message name="watchItemDesc"/>
</h1>
    <p class="domain">
        <bean:message key="statis.common.p_domain_com"/>
        [<bean:write name="SESSION_STATIS_DOMAIN_NAME" />/<bean:write name="SESSION_STATIS_COMPUTER_NAME" />]
    </p>
</div>
    <bean:define id="displayonload" value="0" type="java.lang.String"/>
    <logic:equal name="SESSION_STATIS_GRAPH_TYPE" value="Daily">
       <bean:define id="displayonload" value="0" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="SESSION_STATIS_GRAPH_TYPE" value="Weekly">
       <bean:define id="displayonload" value="1" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="SESSION_STATIS_GRAPH_TYPE" value="Monthly">
       <bean:define id="displayonload" value="2" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="SESSION_STATIS_GRAPH_TYPE" value="Yearly">
       <bean:define id="displayonload" value="3" type="java.lang.String"/>
    </logic:equal>
    <logic:equal name="SESSIONs_STATIS_GRAPH_TYPE" value="User Specification">
       <bean:define id="displayonload" value="4" type="java.lang.String"/>
    </logic:equal>

    <nstab:nstab divoptions="style=\"top:78px;\""  displayonload="<%=displayonload%>">
        <nstab:subtab url="rrdgraph.do?operation=forwardToHideFrame&defaultGraphType=Daily&isInvestGraph=0"><bean:message key="RRDGraph.button_daily"/></nstab:subtab>       
        <nstab:subtab url="rrdgraph.do?operation=forwardToHideFrame&defaultGraphType=Weekly&isInvestGraph=0"><bean:message key="RRDGraph.button_weekly"/></nstab:subtab>      
        <nstab:subtab url="rrdgraph.do?operation=forwardToHideFrame&defaultGraphType=Monthly&isInvestGraph=0"><bean:message key="RRDGraph.button_monthly"/></nstab:subtab>        
        <nstab:subtab url="rrdgraph.do?operation=forwardToHideFrame&defaultGraphType=Yearly&isInvestGraph=0"><bean:message key="RRDGraph.button_yearly"/></nstab:subtab>         
        <nstab:subtab url="rrdgraph.do?operation=forwardToHideFrame&defaultGraphType=User Specification&isInvestGraph=0"><bean:message key="RRDGraph.button_custom"/></nstab:subtab>
        <nstab:subtab url="rrdpropertyFrame.do"><bean:message key="RRDGraph.submit_options"/></nstab:subtab>
    </nstab:nstab>
   </body>
</HTML>
