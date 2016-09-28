<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplinglist.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

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
    <script language="javascript">
    var listLoadFlag=0;
    var listLength=1;
    function setLoadFlag(){
        listLoadFlag=1;
        <logic:equal name="tableListLength" value="0">
            document.forms[0].selectAllBtn.disabled=true;
            document.forms[0].selectAllUnsettingBtn.disabled=true;
            document.forms[0].clearAllBtn.disabled=true;
            listLength=0;
            if(parent.nswsamplingbottom.bottomLoadFlag==1){
                parent.nswsamplingbottom.document.forms[0].samplingStartBtn.disabled=true;
                parent.nswsamplingbottom.document.forms[0].samplingStopBtn.disabled=true;
            }
        </logic:equal>
    }
    <logic:notEqual name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
    function OnSelectAllBtn(){
        var checkboxList = document.forms[0].idList;
        if(checkboxList.length==null){
            checkboxList.checked=true;
        }else{
            for(var i=0;i<checkboxList.length;i++){
                checkboxList[i].checked=true;
            }
        }
    }
    function OnSelectAllUnsettingBtn(){
        var checkboxList=document.forms[0].idList;
        if(checkboxList.length==null){
            var temp=checkboxList.value.split("#");
            if(temp[1]=="off"){
                checkboxList.checked=true;
            }else{
                checkboxList.checked=false;
            }
        }else{
	        for(var i=0;i<checkboxList.length;i++){
	            var temp=checkboxList[i].value.split("#");
	            if(temp[1]=="off"){
	                checkboxList[i].checked=true;
	            }else{
	                checkboxList[i].checked=false;
	            }
	        }
	    }
    }
    function OnClearAllBtn(){
        var checkboxList = document.forms[0].idList;
        if(checkboxList.length==null){
            checkboxList.checked=false;
        }else{
	        for(var i=0;i<checkboxList.length;i++){
	            checkboxList[i].checked=false;
	        }
	    }
    }
    </logic:notEqual>
    function refreshBtn(){
      if(parent.nswsamplingbottom.isSubmitted()){
          return false;
       }
       parent.location="<html:rewrite page='/nswsamplingframe.do'/>"; 
    setSubmitted();
    }
    </script>
</head>
<body onload="setLoadFlag();displayAlert();">
    <displayerror:error h1_key="statis.nsw_sampling.h1"/>
    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshBtn()"/>
    <bean:define id="colItemID" name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" type="java.lang.String"/>
    <h3 class='title'><bean:message name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session"/></h3>
    <html:form action="nswsampling.do" target="_parent">
    <logic:notEqual name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
	    <input type="button" name="selectAllBtn" value="<bean:message key='statis.nsw_sampling.button.selectall'/>" onclick="OnSelectAllBtn();">
	    &nbsp;
	    <input type="button" name="selectAllUnsettingBtn" value="<bean:message key='statis.nsw_sampling.button.select_inactive'/>" onclick="OnSelectAllUnsettingBtn();">
	    &nbsp;
	    <input type="button" name="clearAllBtn" value="<bean:message key='statis.nsw_sampling.button.clearall'/>" onclick="OnClearAllBtn();">
    </logic:notEqual>
    <br>
    <logic:equal name="tableListLength" value="0">
        <bean:define id="resourceName" name="resourceName" type="java.lang.String"></bean:define>
        <br>
        <bean:message key="statis.nsw_sampling.no.resource" arg0="<%=resourceName%>"/>
    </logic:equal>
    <br>
    <logic:notEqual name="tableListLength" value="0">
        <bean:define id="tableList" name="tableList"/>
        <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
	        id="list1"
	        table="border=1 class='Vertical'"
	        sortonload="id:ascend">
                <logic:notEqual name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
	        <nssorttab:column name="checkbox"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            sortable="no">
	        </nssorttab:column>
	        <nssorttab:column name="id"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            sortable="yes">
	                <bean:message name="idName"/>
	        </nssorttab:column>
                </logic:notEqual>
                <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
                <nssorttab:column name="id"
                    th="STHeaderRender"
                    td="STDataRender"
                    sortable="yes">
                        <bean:message name="idName"/>
                </nssorttab:column>
                </logic:equal>
	        <nssorttab:column name="samplingStatus"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            comparator="BooleanComparator"
	            sortable="yes">
	                <bean:message key="statis.nsw_sampling.href_sampling"/>
	        </nssorttab:column>
	        <nssorttab:column name="interval"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            comparator="com.nec.nsgui.action.statis.LineNumComparator"
	            sortable="yes">
	                <bean:message key="statis.nsw_sampling.href_interval"/>
	        </nssorttab:column>
	        <nssorttab:column name="period"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
	            comparator="com.nec.nsgui.action.statis.LineNumComparator"
	            sortable="yes">
	                <bean:message key="statis.nsw_sampling.href_period"/>
	        </nssorttab:column>
	        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_VIRTUAL_PATH%>" scope="session">
		        <nssorttab:column name="severName"
		            th="STHeaderRender"
		            td="STDataRender"
		            sortable="yes">
		                <bean:message key="statis.nsw_sampling.href_server"/>
		        </nssorttab:column>
		        <nssorttab:column name="exportPath"
		            th="STHeaderRender"
		            td="com.nec.nsgui.action.statis.STDataRenderNswSampling"
		            sortable="yes">
		                <bean:message key="statis.nsw_sampling.href_exportpath"/>
		        </nssorttab:column>
	        </logic:equal>
	    </nssorttab:table>
    </logic:notEqual>
    </html:form>
</body>
</html>
