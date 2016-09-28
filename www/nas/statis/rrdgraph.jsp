<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdgraph.jsp,v 1.7 2007/03/07 05:18:07 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.model.entity.statis.GraphInfoBean" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst" %>
<%@ page import="java.util.Map" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<bean:size id="tarNumber" name="graphInfoList"/>
<bean:define id="watchItem" name="rrdGraphForm" property="watchItem"/>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
<logic:equal name="autoReloadFlag" scope="request" value="enable">
    <logic:greaterThan name="autoReloadInterval" scope="request" value="0">
        setTimeout("window.location=\"<html:rewrite page='/rrdgraph.do?operation=displayList'/>\";",<bean:write
 name="autoReloadInterval" scope="request"/>*1000);
    </logic:greaterThan>
</logic:equal>
function disableErrGraphAnchor(imgObj){
        if(isSubmitted()){
            return false;
        }
        if(imgObj.width == 96 &&
          imgObj.height == 64){
            return false;
        }
        parent.hideframe.location.reload();
        setSubmitted();
        return true;
    }
    
    var downloadwin = new Array();
    
    function createWin(winName,target,periodType){
        if(downloadwin[winName] != null && !downloadwin[winName].closed){
           downloadwin[winName].focus();
            return;
        }else{
        	<logic:equal name="SESSION_STATIS_IS_INVESTGRAPH" value="1">
       			document.forms[0].elements['downloadInfo.isSurvey'].value = "true";
       		</logic:equal>
        	<logic:equal name="SESSION_STATIS_IS_INVESTGRAPH" value="0">
       			document.forms[0].elements['downloadInfo.isSurvey'].value = "false";
       		</logic:equal>
            document.forms[0].elements['downloadInfo.host'].value = target;
            document.forms[0].elements['downloadInfo.periodType'].value = periodType;
            document.forms[0].elements['downloadWinKey'].value = winName;
            //need to modify
            downloadwin[winName] = 
                open("/nsadmin/common/commonblank.html",winName,"resizable=yes,toolbar=no,menubar=no,scrollbars=yes,width=580,height=680");
            document.forms[0].action = "<html:rewrite page='/download.do?operation=display'/>";
            document.forms[0].target = winName;
            document.forms[0].submit();
        }
    }
    function refreshGraph(){
      if(isSubmitted()){
          return false;
       }
       window.location="<html:rewrite page='/rrdgraph.do?operation=displayList'/>"; 
    setSubmitted();
    }
    function filter(){
      if(isSubmitted()){
          return false;
       }
      if(document.forms[0].os.checked==true){
         window.location="<html:rewrite page='/rrdgraph.do?operation=filterGraph&flag=0'/>";
      }
      else{
      	 window.location="<html:rewrite page='/rrdgraph.do?operation=filterGraph&flag=1'/>";
      } 
        setSubmitted();
    }
   
    function createMaxWin(MaxWinName,targetID){
         if(parent.hideframe.listMaxWin[MaxWinName] && !parent.hideframe.listMaxWin[MaxWinName].closed){
         	parent.hideframe.listMaxWin[MaxWinName].focus();
            return;
       	 }
       	 parent.hideframe.listMaxWinName.unshift(MaxWinName);
       	 document.forms[2].elements['isDetail'].value = "0";
         document.forms[2].elements['watchItem'].value = "<bean:write name='watchItem'/>";
         document.forms[2].elements['targetId'].value = targetID;
         parent.hideframe.listMaxWin[MaxWinName]=open("/nsadmin/common/commonblank.html",MaxWinName,"resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=480,height=250");
         document.forms[2].action = "changeMax.do?operation=displayMax";
         document.forms[2].target = MaxWinName;
         var old = new Date();
         while(true){
            var now = new Date();
            if(parseInt(now.getTime() - old.getTime()) / 1000-1>=0){
               break;
            }
         }
         document.forms[2].submit();   
    }
  
   function createInvestWin(){
     var listInvestWinName="Statis_window_invest_list";
     if(parent.hideframe.listInvestWin && !parent.hideframe.listInvestWin.closed){
         parent.hideframe.listInvestWin.focus();
         return;
      }
     parent.hideframe.listInvestWin=window.open('rrdproperty.do?operation=displayForSurvey',listInvestWinName,'resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=480,height=285');
    }

</script>
</HEAD>

<BODY>

<html:form action="rrdgraph.do?operation=displayDetail" method="POST"> 
    <html:hidden property="downloadInfo.originalWatchItemID" />
    <html:hidden property="downloadInfo.periodType" />
    <html:hidden property="downloadInfo.defaultPeriod" />
    <html:hidden property="downloadInfo.customStartTime" />
    <html:hidden property="downloadInfo.customEndTime" />
    <html:hidden property="downloadInfo.host" />
    <html:hidden property="downloadInfo.isSurvey" />
    <input type="hidden" name="downloadWinKey" value="">
    
    <input type="button" name="refresh" value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
    
    <logic:equal name="SESSION_STATIS_IS_INVESTGRAPH" value="1">
        <input type="button" name="invest" value="<bean:message key='RRDGraph.button_stock_period'/>" onclick="return createInvestWin()"/>
    </logic:equal>
         
    <logic:equal name="collectionItem" value="Filesystem">
        <logic:equal name="SESSION_STATIS_FILTER_FLAG" value="0">
            <input type="checkbox" name="os" checked id="os" onclick="return filter()"><label for="os"><bean:message key="RRDGraph.os"/></label> 
        </logic:equal>
        <logic:notEqual name="SESSION_STATIS_FILTER_FLAG" value="0">
            <input type="checkbox" name="os" onclick="return filter()" id="os"><label for="os"><bean:message key="RRDGraph.os"/></label> 
        </logic:notEqual>
    </logic:equal>
    
    <logic:equal name="collectionItem" value="Filesystem_Quantity">
        <logic:equal name="SESSION_STATIS_FILTER_FLAG" value="0">
            <input type="checkbox" name="os" checked id="os" onclick="return filter()"><label for="os"><bean:message key="RRDGraph.os"/></label> 
        </logic:equal>
        <logic:notEqual name="SESSION_STATIS_FILTER_FLAG" value="0">
            <input type="checkbox" name="os" onclick="return filter()" id="os"><label for="os"><bean:message key="RRDGraph.os"/></label> 
        </logic:notEqual>
    </logic:equal>
    
    <br><br>
    
    <bean:write name="illustration" filter="false"/>
    
    <logic:present name="statis_cluster_status_abnormal" scope="request">
        <logic:equal name="statis_cluster_status_abnormal" value="true">
            <br>
            <table border="0"><tr><td><bean:message key='RRDGraph.cluster.status.abnormal'/></td></tr></table>
        </logic:equal>
    </logic:present>
    
    <bean:define id="map" name="only_osfs_exist" type="java.util.Map"/>
    
    <logic:iterate id="tarInfo" name="graphInfoList" indexId="tarInx">
    
        <logic:equal name="isDisplayH3" value="true">
            <h3 class="title">
                <logic:equal name="isCluster" value="true">
                    <bean:message key='RRDGraph.node' arg0='<%=tarInx.toString()%>'/>    
                </logic:equal>
                <bean:write name="tarInfo" property="nickName"/> 
            </h3>
        </logic:equal>
        <logic:equal name="isDisplayH3" value="false">
            <br>
        </logic:equal>
        
        <logic:equal name="tarInfo" property="hasDownloadButton" value="true">
            <logic:equal name="isDisplayH3" value="false">
                <bean:define id="expgrp" name="SESSION_STATIS_EXPORT_GROUP" type="java.lang.String"/>
                <input type="button" name="download" value="<bean:message key="csvdownload.Download2"/>"
                    onclick="return createWin('Statis_window_node<%=tarInx.toString()%>_<%=watchItem%>_<%=expgrp%>','<bean:write name="tarInfo" property="targetId"/>','<bean:write name="tarInfo" property="periodNeedShow"/>')" />
            </logic:equal>
            <logic:equal name="isDisplayH3" value="true">
                <input type="button" name="download" value="<bean:message key="csvdownload.Download2"/>"
                    onclick="return createWin('Statis_window_node<%=tarInx.toString()%>_<%=watchItem%>','<bean:write name="tarInfo" property="targetId"/>','<bean:write name="tarInfo" property="periodNeedShow"/>')" />
            </logic:equal>
            <bean:define id="disabled" value="" type="java.lang.String"/> 
            
            <logic:equal name="collectionItem" value="Filesystem">
                <logic:notEqual name="SESSION_STATIS_FILTER_FLAG" value="0">
                    <bean:define id="targetId" name="tarInfo" property="targetId" type="java.lang.String"/> 
                    <%String exist=(String)map.get(targetId);request.setAttribute("exist",exist);%>
              		<logic:equal name="exist" value="true">
               			<bean:define id="disabled" value="disabled" type="java.lang.String"/>
               		</logic:equal>
                </logic:notEqual>
            </logic:equal>
            
            <logic:equal name="collectionItem" value="Filesystem_Quantity">
                <logic:notEqual name="SESSION_STATIS_FILTER_FLAG" value="0">
                    <bean:define id="targetId" name="tarInfo" property="targetId" type="java.lang.String"/> 
                    <%String exist=(String)map.get(targetId);request.setAttribute("exist",exist);%>
              		<logic:equal name="exist" value="true">
               			<bean:define id="disabled" value="disabled" type="java.lang.String"/>
               		</logic:equal>
                </logic:notEqual>
            </logic:equal>
            
            <logic:present name="msg_big_interval"> 
                <bean:define id="disabled" value="disabled" type="java.lang.String"/> 
            </logic:present>
            
            <input type="button" value="<bean:message key='RRDGraph.button_setY'/>" <%=disabled%> onclick="return createMaxWin('Statis_window_setY_list_<%=tarInx.toString()%>','<bean:write name="tarInfo" property="targetId"/>')"/><br>       
        </logic:equal>
        <bean:write name="tarInfo" property="graphTableHtml" filter="false"/> 
    </logic:iterate>
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

<html:form action="changeMax.do?operation=displayMax">
    <html:hidden property="isDetail"/>
    <html:hidden property="watchItem"/>
    <html:hidden property="targetId"/>
</html:form>

</BODY>
</HTML>
