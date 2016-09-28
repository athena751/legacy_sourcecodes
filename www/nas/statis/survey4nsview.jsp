<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: survey4nsview.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

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
    function refreshGraph(){
      if(isSubmitted()){
          return false;
       }
       window.location="<html:rewrite page='/survey4nsview.do?operation=init'/>"; 
    setSubmitted();
    }
    </script>
</head>
<body onload="setHelpAnchor('performance_sampling_2_1');">
    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
    <br><br>
    <bean:define id="tableList" name="itemList"/>
    <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
        id="list1"
        table="border=1"
        sortonload="collectionItem:ascend">
        <nssorttab:column name="collectionItem"
            th="STHeaderRender"
            td="STDataRender"
            sortable="yes">
                <bean:message key="statis.sampling.href_item"/>
        </nssorttab:column>
        <nssorttab:column name="status"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderSurvey"
            comparator="BooleanComparator"
            sortable="yes">
                <bean:message key="statis.sampling.href_status"/>
        </nssorttab:column>
        <nssorttab:column name="dataFileSize"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderSurvey"
            comparator="com.nec.nsgui.action.statis.LineNumComparator"
            sortable="yes">
                <bean:message key="statis.sampling.href_size"/>
        </nssorttab:column>
        <nssorttab:column name="stockPeriod"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderSurvey"
            comparator="NumberStringComparator"
            sortable="yes">
                <bean:message key="statis.sampling.href_period"/>
        </nssorttab:column>
        <nssorttab:column name="interval"
            th="STHeaderRender"
            td="com.nec.nsgui.action.statis.STDataRenderSurvey"
            comparator="NumberStringComparator"
            sortable="yes">
                <bean:message key="statis.sampling.href_interval"/>
        </nssorttab:column>
    </nssorttab:table>
</body>
</html>