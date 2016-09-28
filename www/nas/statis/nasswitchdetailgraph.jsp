<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchdetailgraph.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<bean:define id="nName" name="nickName" type="java.lang.String"/>
<bean:define id="tagNo" name="nasSwitchGraphForm" property="targetNo" type="java.lang.String"/>
<bean:define id="subItem"  name="subItem" type="java.lang.String"/>
<bean:define id="watchItem"  name="nasSwitchGraphForm" property="watchItem"/>
<logic:equal name="autoReloadFlag" scope="request" value="enable">
    <logic:greaterThan name="autoReloadInterval" scope="request" value="0">
        <meta http-equiv='REFRESH' content='<bean:write name="autoReloadInterval" scope="request"/>'>      
    </logic:greaterThan>    
</logic:equal>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
	function backToGraph (){
		if(isSubmitted()){
			return false;
		}
		window.location="nasSwitchGraph.do?operation=displayGraph";
		parent.hideframe.location.reload();
		setSubmitted();
	}
    var windowName;
    function createWin(){
        var winName = "Statis_window_detailgraph_<%=StatisActionConst.SESSION_COLLECTION_ID%>_node<%=tagNo%>_<%=watchItem%>";
        if(windowName && !windowName.closed){ 
            windowName.focus();
            return;
        }
        document.forms[0].elements['downloadWinKey'].value = winName;
        windowName = open("/nsadmin/common/commonblank.html",winName,"resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=580,height=650");
        document.forms[0].action= "<html:rewrite page='/download4NSW.do?operation=display'/>";
        document.forms[0].target=winName;
        document.forms[0].submit();
        windowName.focus();
    }
    function createMaxWin(){
         var detailMaxWinName="Statis_nasswitch_window_setY_detail";
         if(parent.hideframe.detailMaxWin && !parent.hideframe.detailMaxWin.closed){
         	parent.hideframe.detailMaxWin.focus();
            return;
       	 }
       	 document.forms[3].elements['isDetail'].value ="1";
         document.forms[3].elements['collectionItem'].value = "<bean:write name='<%=StatisActionConst.SESSION_COLLECTION_ID%>'/>";
         parent.hideframe.detailMaxWin=open("/nsadmin/common/commonblank.html",detailMaxWinName,"resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=480,height=300");
         document.forms[3].action = "changeNasSwitchMax.do?operation=displayMax";
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
   function deleteGraph(){
      if(isSubmitted()){
           return false;
       }
      if(!confirm("<bean:message key='RRDGraph.delete.alert' arg0='<%=subItem%>'/>")){
      	return false;
       }
      document.forms[2].submit();
      parent.hideframe.location.reload();
      setSubmitted();
   } 
	function refreshGraph(){
		if(isSubmitted()){
			return false;
		}
		window.location="<html:rewrite page='/nasSwitchGraph.do?operation=displayDetailGraph'/>"; 
		setSubmitted();
	}   
</script>
</head>
<body>
<input type="button" name="back" value="<bean:message bundle="common" key="common.button.back"/>" onclick="backToGraph()"/>
<input type="button" value="<bean:message key='common.button.reload' bundle='common'/>" onclick="refreshGraph();"/> 
</br>
<h3 class="title">
<bean:message key="h2.graphdetail"/>      
<logic:equal name="isCluster" value="true">
<bean:message key="RRDGraph.node.with.brace" arg0='<%=tagNo%>' arg1='<%=nName%>'/>    
</logic:equal>
<logic:equal name="isCluster" value="false">
 <bean:message key="RRDGraph.brace.without.node" arg0='<%=nName%>'/>
 </logic:equal>  
</h3>
<html:form action="nasSwitchGraph.do" method="POST"> 
    <html:hidden property="downloadInfo.defaultPeriod" />
    <html:hidden property="downloadInfo.customStartTime" />
    <html:hidden property="downloadInfo.customEndTime" />
    <html:hidden property="downloadInfo.defaultResource" />
    <html:hidden property="downloadInfo.collectionItemId" />
    <input type="hidden" name="downloadWinKey" value="">
    <input type="button" name="download" 
         value="<bean:message key="csvdownload.Download2"/>"
         onclick="return createWin()" />&nbsp;&nbsp;  
<input type="button" value="<bean:message key='RRDGraph.button_setY'/>" onclick="createMaxWin()"/>&nbsp;&nbsp;   
<logic:notEqual name="userinfo" value="nsview">
    &nbsp;&nbsp;<input type="button" value="<bean:message key='RRDGraph.button_delete'/>" onclick="deleteGraph()"/>
</logic:notEqual>  
</br>
<logic:notEqual name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Node%>">
</br>
 <table border="0"><tr><th align="left"><bean:message name="watchItemDesc"/><bean:message key="statis.nasswitch.subItem" arg0="<%=subItem%>"/></th></tr></table> 
 </logic:notEqual>	
	<bean:write name="detailGraph" filter="false"/>
</html:form>
<html:form action="changeNasSwitchMax.do?operation=changeMax" method="POST">
<html:hidden property="yInfoBean.max"/>
<html:hidden property="yInfoBean.maxunit"/>
<html:hidden property="yInfoBean.min"/>
<html:hidden property="yInfoBean.minunit"/>
<html:hidden property="yInfoBean.maxradio"/>
<html:hidden property="yInfoBean.minradio"/>
<html:hidden property="yInfoBean.displaymax"/>
<html:hidden property="yInfoBean.displaymin"/>
<html:hidden property="selectedItem"/>
<html:hidden property="collectionItem"/>
<html:hidden property="isDetail"/>
</html:form>
<html:form action="nasSwitchGraph.do?operation=deleteGraph" method="POST">
<html:hidden property="index"/>
</html:form>
<html:form action="changeNasSwitchMax.do?operation=displayMax">
<html:hidden property="isDetail"/>
<html:hidden property="collectionItem"/>
<html:hidden property="selectedItem"/>
</html:form>

</BODY>
</HTML>
