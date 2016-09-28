<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswserverlist.jsp,v 1.2 2005/10/19 10:25:12 zhangj Exp $" -->

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
        <logic:equal name="tableLength" value="0">
            document.forms[0].selectAllBtn.disabled=true;
            document.forms[0].selectAllUnsettingBtn.disabled=true;
            document.forms[0].clearAllBtn.disabled=true;
            listLength=0;
            if(parent.nswsamplingbottom&&parent.nswsamplingbottom.bottomLoadFlag&&parent.nswsamplingbottom.bottomLoadFlag==1){
                parent.nswsamplingbottom.document.forms[0].samplingStartBtn.disabled=true;
                parent.nswsamplingbottom.document.forms[0].samplingStopBtn.disabled=true;
            }
        </logic:equal>
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
<body onload="setLoadFlag();displayAlert();setHelpAnchor('performance_virtual_nfs_sampling_2_1');">
    <displayerror:error h1_key="statis.nsw_sampling.h1"/>
    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshBtn()"/>
    <h3 class='title'><bean:message key="NSW_NFS_Server"/></h3>
    <html:form action="nswsampling.do" target="_parent">
	    <input type="button" name="selectAllBtn" value="<bean:message key='statis.nsw_sampling.button.selectall'/>" onclick="OnSelectAllBtn(document.forms[0].idList);">
	    &nbsp;
	    <input type="button" name="selectAllUnsettingBtn" value="<bean:message key='statis.nsw_sampling.button.select_inactive'/>" onclick="OnSelectAllUnsettingBtn(document.forms[0].idList);">
	    &nbsp;
	    <input type="button" name="clearAllBtn" value="<bean:message key='statis.nsw_sampling.button.clearall'/>" onclick="OnClearAllBtn(document.forms[0].idList);">
    <br>
    <logic:equal name="tableLength" value="0">
        <br>
        <bean:message key="statis.nsw_sampling.no.resource.server"/>
    </logic:equal>
    <br>
    <logic:notEqual name="tableLength" value="0">
        <bean:define id="tableList" name="tableList"/>
        <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
	        id="list1"
	        table="border=1"
	        sortonload="id:ascend">
	        <nssorttab:column name="checkbox"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            sortable="no">
	        </nssorttab:column>
	        <nssorttab:column name="id"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            sortable="yes">
	                <bean:message key="statis.nswsampling.sever.th"/>
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
    </logic:notEqual>
    </html:form>
</body>
</html>
