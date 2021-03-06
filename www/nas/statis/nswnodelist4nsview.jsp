<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswnodelist4nsview.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
    <script language="javascript">
    function refreshBtn(){
        if(isSubmitted()){
            return false;
        }
        window.location="<html:rewrite page='/nswsamplingframe4nsview.do?operation=initList'/>"; 
        setSubmitted();
    }
    </script>
</head>
<body onload="setHelpAnchor('performance_virtual_nfs_sampling_3_1');">
    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshBtn()"/>
    <h3 class='title'><bean:message key="NSW_NFS_Node"/></h3>
        <bean:define id="tableList" name="tableList"/>
        <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
	        id="list1"
	        table="border=1"
	        sortonload="id:ascend">
	        <nssorttab:column name="id"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            sortable="yes">
	                <bean:message key="statis.nswsampling.node.th"/>
	        </nssorttab:column>
	        <nssorttab:column name="samplingStatus"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            comparator="BooleanComparator"
	            sortable="yes">
	                <bean:message key="statis.nsw_sampling.href_sampling"/>
	        </nssorttab:column>
	        <nssorttab:column name="size"
                th="STHeaderRender"
                td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
                comparator="com.nec.nsgui.action.statis.LineNumComparator"
                sortable="yes">
                    <bean:message key="statis.nsw_sampling.href_size"/>
            </nssorttab:column>
	        <nssorttab:column name="period"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            comparator="com.nec.nsgui.action.statis.LineNumComparator"
	            sortable="yes">
	                <bean:message key="statis.nsw_sampling.href_period"/>
	        </nssorttab:column>
	        <nssorttab:column name="interval"
                th="STHeaderRender"
                td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
                comparator="com.nec.nsgui.action.statis.LineNumComparator"
                sortable="yes">
                    <bean:message key="statis.nsw_sampling.href_interval"/>
            </nssorttab:column>
	    </nssorttab:table>
</body>
</html>
