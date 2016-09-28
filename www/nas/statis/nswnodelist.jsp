<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswnodelist.jsp,v 1.2 2005/10/19 10:25:12 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.statis.CollectionConst3" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
    <script language="javascript" src="../nas/statis/nswselectbutton.js"></script>
    <script language="javascript">
    var listLoadFlag=0;
    var listLength=1;
    function setLoadFlag(){
        listLoadFlag=1;
    }
    function refreshBtn(){
        if(!parent.nswsamplingbottom||!parent.nswsamplingbottom.bottomLoadFlag||parent.nswsamplingbottom.bottomLoadFlag!=1||parent.nswsamplingbottom.isSubmitted()){
            return false;
        }
        parent.location="<html:rewrite page='/nswsamplingframe.do'/>"; 
        parent.nswsamplingbottom.setSubmitted();
    }
    </script>
</head>
<body onload="setLoadFlag();displayAlert();setHelpAnchor('performance_virtual_nfs_sampling_3_1');">
    <displayerror:error h1_key="statis.nsw_sampling.h1"/>
    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshBtn()"/>
    <h3 class='title'><bean:message key="NSW_NFS_Node"/></h3>
    <html:form action="nswsampling.do" target="_parent">
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
    </html:form>
</body>
</html>
