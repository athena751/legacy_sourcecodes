<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: surveytop.jsp,v 1.2 2007/04/03 02:24:22 yangxj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.statis.CollectionConst" %>
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
    var frameloadflag=0;
    function setframeloadflag(){
        frameloadflag=1;
        document.forms[0].surveyRadio[0].click();
    }
    function OnRadioBtnFun(dataFileSize){
        if((parent.surveymodify)&&(parent.surveymodify.modBtmLoadFlag)&&(parent.surveymodify.modBtmLoadFlag==1)){
            if(dataFileSize=="<%=CollectionConst.DLINE%>"){
                parent.surveymodify.document.forms[0].deleteDataBtn.disabled=true;
            }else{
                parent.surveymodify.document.forms[0].deleteDataBtn.disabled=false;
            }
        }
    }
    function creatAlertMsg(itemMsg){
        <bean:define id="alertList" name="alertList"/>
        <logic:iterate id="element" name="alertList">
            if("<bean:write name="element" property="collectionItem"/>"==itemMsg){
                <bean:define id="collectionItem" name="element" property="collectionItem" type="java.lang.String"/>
                return "<bean:message key="statis.sampling.delete_alert" arg0='<%=collectionItem%>'/>";
            }
        </logic:iterate>
    }
    function refreshGraph(){
      if(isSubmitted()){
          return false;
       }
       parent.location="<html:rewrite page='/surveyframe.do'/>"; 
    setSubmitted();
    }
    </script>
</head>
<body onload="setframeloadflag();displayAlert();setHelpAnchor('performance_sampling_2_1');" onUnload="closeDetailErrorWin();">

    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
    <br><br>
    <displayerror:error h1_key="statis.sampling.h1"/>
    <html:form action="survey.do" target="_parent">
    	<html:hidden property="id"/>
	    <html:hidden property="itemKey"/>
	    <html:hidden property="status"/>
	    <html:hidden property="interval"/>
	    <html:hidden property="stockPeriod"/>
	    <bean:define id="tableList" name="itemList"/>
	    <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
	        id="list1"
	        table="border=1"
	        sortonload="collectionItem:ascend">
	        <nssorttab:column name="radio"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderSurvey"
	            sortable="no">
	        </nssorttab:column>
	        <nssorttab:column name="collectionItem"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderSurvey"
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
    </html:form>    
</body>
</html>