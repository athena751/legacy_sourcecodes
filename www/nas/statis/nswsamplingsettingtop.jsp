<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingsettingtop.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.statis.CollectionConst3" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
    <script language="javascript">
    function onBack(){
	    parent.location="nswsamplingframe.do";
    }
    function initHelpAnchorKey(){
        <bean:define id="helpAnchorKey" value="performance_virtual_nfs_sampling_1_2" type="java.lang.String"/>
        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_VIRTUAL_PATH%>">
            <bean:define id="helpAnchorKey" value="performance_virtual_nfs_sampling_1_2" type="java.lang.String"/>
        </logic:equal>
        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_SEVER%>">
            <bean:define id="helpAnchorKey" value="performance_virtual_nfs_sampling_2_2" type="java.lang.String"/>
        </logic:equal>
        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
            <bean:define id="helpAnchorKey" value="performance_virtual_nfs_sampling_3_2" type="java.lang.String"/>
        </logic:equal>
    }
    </script>
</head>
<body onload="initHelpAnchorKey();displayAlert();setHelpAnchor('<%=helpAnchorKey%>');">
    <displayerror:error h1_key="statis.nsw_sampling.h1"/>
    <input type="button" name="goBack" value="<bean:message key="common.button.back" bundle="common"/>" onclick="return onBack()">
    <h3 class='title'><bean:message key="statis.nsw_sampling.settingtop_h3"/></h3>
    <bean:define id="tableList" name="tableList"/>
    <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
        id="list1"
        table="border=1"
        >
        <nssorttab:column name="id"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
            sortable="no">
                <bean:message name="idName"/>
        </nssorttab:column>
        <nssorttab:column name="samplingStatus"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
            sortable="no">
                <bean:message key="statis.nsw_sampling.href_sampling"/>
        </nssorttab:column>
        <nssorttab:column name="period"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
            sortable="no">
                <bean:message key="statis.nsw_sampling.href_period"/>
        </nssorttab:column>
        <nssorttab:column name="interval"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
            sortable="no">
                <bean:message key="statis.nsw_sampling.href_interval"/>
        </nssorttab:column>
    </nssorttab:table>
</body>
</html>
