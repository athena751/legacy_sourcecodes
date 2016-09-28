<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrddetailgraph.jsp,v 1.5 2007/04/03 03:08:50 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst" %>



<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
    <bean:define id="watchItem" name="rrdGraphForm" property="watchItem"/>
    <bean:define id="subWatchItem" name="rrdGraphForm" property="subWatchItem"  type="java.lang.String"/>
    <bean:define id="targetID" name="rrdGraphForm" property="targetID"/>
    <bean:define id="tagNo" name="rrdGraphForm" property="targetNo" type="java.lang.String"/>
    <bean:define id="subItemNo" name="rrdGraphForm" property="subItemNo"/>
<script language="JavaScript">
<logic:equal name="autoReloadFlag" scope="request" value="enable">
    <logic:greaterThan name="autoReloadInterval" scope="request" value="0">
        setTimeout("window.location=\"<html:rewrite page='/rrdgraph.do?operation=displayDetail'/>\";",<bean:write
 name="autoReloadInterval" scope="request"/>*1000);
    </logic:greaterThan>
</logic:equal>
    function backToGraph(){
       if(isSubmitted()){
            return false;
        }
       window.location="<html:rewrite page='/rrdgraph.do?operation=displayList'/>";
       parent.hideframe.location.reload();
       setSubmitted();
    }
    var windowName;

    function createWin(){
        <logic:equal name="isDisplayNodeNo" value="false">
            <bean:define id="expgrp" name="SESSION_STATIS_EXPORT_GROUP" type="java.lang.String"/>
            var winName = "Statis_window_node<%=tagNo%>_<%=watchItem%>_<%=expgrp%>_subItem<%=subItemNo%>";
        </logic:equal>
        <logic:equal name="isDisplayNodeNo" value="true">
            var winName = "Statis_window_node<%=tagNo%>_<%=watchItem%>_subItem<%=subItemNo%>";
        </logic:equal>
        if(windowName && !windowName.closed){ 
            windowName.focus();
            return;
        }
        <logic:equal name="SESSION_STATIS_IS_INVESTGRAPH" value="1">
       		document.forms[0].elements['downloadInfo.isSurvey'].value = "true";
       	</logic:equal>
        <logic:equal name="SESSION_STATIS_IS_INVESTGRAPH" value="0">
       		document.forms[0].elements['downloadInfo.isSurvey'].value = "false";
       	</logic:equal>
        document.forms[0].elements['downloadWinKey'].value = winName;
        windowName = open("/nsadmin/common/commonblank.html",winName,"resizable=yes,toolbar=no,menubar=no,scrollbars=yes,width=580,height=680");
        document.forms[0].action= "<html:rewrite page='/download.do?operation=display'/>";
        document.forms[0].target=winName;
        document.forms[0].submit();
        windowName.focus();
    }
   function deleteGraph(){
      if(isSubmitted()){
           return false;
       }
       <bean:define id="subWatchItemName" name="subWatchItemName" type="java.lang.String"/>
       if(!confirm("<bean:message key='RRDGraph.delete.alert' arg0='<%=subWatchItemName%>'/>")){
       		return false;
       }
      document.forms[2].elements["subWatchItem"].value="<bean:write name='subWatchItem'/>";
      document.forms[2].elements["watchItem"].value="<bean:write name='watchItem'/>";
      document.forms[2].elements["targetId"].value="<bean:write name='targetID'/>";
      document.forms[2].submit();
      parent.hideframe.location.reload();
      setSubmitted();
   }
   
    function createMaxWin(){
         var detailMaxWinName="Statis_window_setY_detail";
         if(parent.hideframe.detailMaxWin && !parent.hideframe.detailMaxWin.closed){
         	parent.hideframe.detailMaxWin.focus();
            return;
       	 }
       	 document.forms[3].elements['isDetail'].value ="1";
         document.forms[3].elements['watchItem'].value = "<bean:write name='rrdGraphForm' property='watchItem'/>";
         document.forms[3].elements['targetId'].value = "<bean:write name='rrdGraphForm' property='targetID'/>";
         parent.hideframe.detailMaxWin=open("/nsadmin/common/commonblank.html",detailMaxWinName,"resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=480,height=250");
         document.forms[3].action = "changeMax.do?operation=displayMax";
         document.forms[3].target = detailMaxWinName;
         var old = new Date();
         while(true){
            var now = new Date();
            if(parseInt(now.getTime() - old.getTime()) / 1000-1>=0){
               break;
            }
         }
         document.forms[3].submit();   
    }
  
   function createInvestWin(){
     var detailInvestWinName="Statis_window_invest_detail";
     if(parent.hideframe.detailInvestWin && !parent.hideframe.detailInvestWin.closed){
         parent.hideframe.detailInvestWin.focus();
         return;
      }
     parent.hideframe.detailInvestWin=window.open('rrdproperty.do?operation=displayForSurvey',detailInvestWinName,'resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=480,height=285');
    }
    function refreshGraph(){
      if(isSubmitted()){
          return false;
       }
       window.location="<html:rewrite page='/rrdgraph.do?operation=displayDetail'/>"; 
    	setSubmitted();
    }

</script>
</head>
<body onload="displayAlert();" onUnload="closeDetailErrorWin();">
<input type="button" name="back" value="<bean:message bundle="common" key="common.button.back"/>" onclick="return backToGraph()" />
     <input type="button" name="refresh" 
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
         <displayerror:error h1_key="<%=(String)request.getSession().getAttribute("watchItemDesc") %>" />
<h3 class="title"><bean:message key="h2.graphdetail"/>
    <bean:define id="nName" name="nickName" type="java.lang.String"/>
    <logic:equal name="isDisplayNodeNo" value="true">
        <logic:equal name="isCluster" value="true">
            <bean:define id="tagNo" name="rrdGraphForm" property="targetNo" type="java.lang.String"/>
            <bean:message key="RRDGraph.node.with.brace" arg0='<%=tagNo%>' arg1='<%=nName%>'/>    
        </logic:equal>
        <logic:equal name="isCluster" value="false">
            <bean:message key="RRDGraph.brace.without.node" arg0='<%=nName%>'/>
        </logic:equal>       
    </logic:equal>
</h3>
<html:form action="rrdgraph.do" method="POST"> 
    <html:hidden property="downloadInfo.originalWatchItemID" />
    <html:hidden property="downloadInfo.periodType" />
    <html:hidden property="downloadInfo.defaultPeriod" />
    <html:hidden property="downloadInfo.customStartTime" />
    <html:hidden property="downloadInfo.customEndTime" />
    <html:hidden property="downloadInfo.host" />
    <html:hidden property="downloadInfo.defaultResource" />
    <html:hidden property="downloadInfo.isSurvey" />
    <input type="hidden" name="downloadWinKey" value="">
    <input type="button" name="download" 
         value="<bean:message key="csvdownload.Download2"/>"
         onclick="return createWin()" />&nbsp;&nbsp;
    <input type="button" value="<bean:message key='RRDGraph.button_setY'/>" onclick="createMaxWin()"/>&nbsp;&nbsp;  
     <logic:equal name="SESSION_STATIS_IS_INVESTGRAPH" value="1">
     <input type="button" name="invest" 
         value="<bean:message key='RRDGraph.button_stock_period'/>" onclick="return createInvestWin()"/>&nbsp;&nbsp;
     </logic:equal>
     <logic:notEqual name="userinfo" value="nsview">
      &nbsp;&nbsp;<input type="button" value="<bean:message key='RRDGraph.button_delete'/>" onclick="deleteGraph()"/>
     </logic:notEqual>   
        <br> 
    <logic:notEqual name="mountpoint" value="">
        <p><bean:message key="RRDGraphBean.mounted_on"/><bean:write name="mountpoint"/></p>
    </logic:notEqual>
    <bean:write name="detailGraph" filter="false"/>
</html:form>
<html:form action="changeMax.do?operation=changeMax" method="POST">
<html:hidden property="yInfoBean.max"/>
<html:hidden property="yInfoBean.maxunit"/>
<html:hidden property="yInfoBean.displaymax"/>
<html:hidden property="yInfoBean.min"/>
<html:hidden property="yInfoBean.minunit"/>
<html:hidden property="yInfoBean.displaymin"/>
<html:hidden property="yInfoBean.maxradio"/>
<html:hidden property="yInfoBean.minradio"/>
<html:hidden property="watchItem"/>
<html:hidden property="targetId"/>
<html:hidden property="isDetail"/>
</html:form>
<html:form action="deleteGraph.do?operation=deleteGraph" method="POST">
<html:hidden property="subWatchItem"/>
<html:hidden property="watchItem"/>
<html:hidden property="targetId"/>
</html:form>
<html:form action="changeMax.do?operation=displayMax">
<html:hidden property="isDetail"/>
<html:hidden property="watchItem"/>
<html:hidden property="targetId"/>
</html:form>
</BODY>
</HTML>
