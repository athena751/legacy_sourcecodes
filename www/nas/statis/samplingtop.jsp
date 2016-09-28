<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: samplingtop.jsp,v 1.2 2007/04/03 02:24:22 yangxj Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.action.statis.CollectionConst" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
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
    var status;
    function setframeloadflag(){
        frameloadflag=1;
        <bean:define id="active" name="active"/>
        if("<%=active%>"=="true"){
            document.forms[0].start.disabled=true;
        }else{
            document.forms[0].stop.disabled=true;
        }
        
        document.forms[0].itemRadio[0].click();
    }
    function OnRadioBtnFun(dataFileSize){
        if((parent.sampmodify)&&(parent.sampmodify.bottomLoadFlag)&&(parent.sampmodify.bottomLoadFlag==1)){
            if(dataFileSize=="<%=CollectionConst.DLINE%>"){
                parent.sampmodify.document.forms[0].deleteDataBtn.disabled=true;
            }else{
                parent.sampmodify.document.forms[0].deleteDataBtn.disabled=false;
            }
        }
    }
    function onStatus(){   
        if(isSubmitted()){
            return false;
        }
        var action;
        if(document.forms[0].start.disabled){
            action="<bean:message key="statis.sampling.button.stop"/>";
            document.forms[0].status.value="false";
        }else{
            action="<bean:message key="statis.sampling.button.start"/>";
            document.forms[0].status.value="true";
        }
        if(confirm("<bean:message key="common.confirm" bundle="common"/>"+"\r\n"
                    +"<bean:message key="common.confirm.action" bundle="common"/>"
                    +action)){
            document.forms[0].action="sampling.do?operation=changeStatus";
            document.forms[0].submit();
            setSubmitted();
        }else{
            return false;
        }
    }
    function creatAlertMsg(itemKey){
    <bean:define id="alertList" name="alertList"/>
    <logic:iterate id="element" name="alertList">
        if("<bean:write name="element" property="collectionItem"/>"==itemKey){
            <bean:define id="collectionItem" name="element" property="collectionItem" type="java.lang.String"/>
            return "<bean:message key="statis.sampling.delete_alert" arg0="<%=collectionItem%>"/>";
        }
    </logic:iterate>
    }
    function refreshGraph(){
      if(isSubmitted()){
          return false;
       }
       parent.location="<html:rewrite page='/samplingframe.do'/>"; 
    setSubmitted();
    }
    </script>
</head>
<body onload="setframeloadflag();displayAlert();setHelpAnchor('performance_sampling_1_1');" onUnload="closeDetailErrorWin();">
    <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
    <displayerror:error h1_key="statis.sampling.h1"/>
    <h3 class='title'><bean:message key="statis.sampling.h3_sampling"/> </h3>
    <html:form action="sampling.do" target="_parent">
	    <table><tr><td>
	        <logic:equal name="active" value="true">
	           <bean:message key="statis.sampling.status_active"/>
	        </logic:equal>
	        <logic:equal name="active" value="false">
	           <bean:message key="statis.sampling.status_inactive"/>
	        </logic:equal>
	        </td></tr>
	    </table>
        <br>
        <html:hidden property="id"/>
        <html:hidden property="status"/>
        <html:submit property="start" onclick="return onStatus()">
            <bean:message key="statis.sampling.button.start"/>
        </html:submit>
        <html:submit property="stop" onclick="return onStatus()">
            <bean:message key="statis.sampling.button.stop"/>
        </html:submit>
	    <h3 class='title'><bean:message key="statis.sampling.h3_collection"/> </h3>
	    <html:hidden property="itemKey"/>
	    <html:hidden property="stockPeriod"/>
	    <bean:define id="tableList" name="itemList"/>
	    <nssorttab:table tablemodel="<%=(SortTableModel)tableList%>"
	        id="list1"
	        table="border=1"
	        sortonload="collectionItem:ascend">
	        <nssorttab:column name="radio"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderSampling"
	            sortable="no">
	        </nssorttab:column>
	        <nssorttab:column name="collectionItem"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderSampling"
	            sortable="yes">
	                <bean:message key="statis.sampling.href_item"/>
	        </nssorttab:column>
	        <nssorttab:column name="dataFileSize"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderSampling"
	            comparator="com.nec.nsgui.action.statis.LineNumComparator"
	            sortable="yes">
	                <bean:message key="statis.sampling.href_size"/>
	        </nssorttab:column>
	        <nssorttab:column name="stockPeriod"
	            th="STHeaderRender"
	            td="com.nec.nsgui.action.statis.STDataRenderSampling"
	            comparator="NumberStringComparator"
	            sortable="yes">
	                <bean:message key="statis.sampling.href_period"/>
	        </nssorttab:column>
	    </nssorttab:table>
    </html:form>    
</body>
</html>