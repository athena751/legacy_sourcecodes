<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchgraphcontent.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<logic:equal name="autoReloadFlag" scope="request" value="enable">
    <logic:greaterThan name="autoReloadInterval" scope="request" value="0">
        <meta http-equiv='REFRESH' content='<bean:write name="autoReloadInterval" scope="request"/>'>      
    </logic:greaterThan>    
</logic:equal>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
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
    var windowName;
    function createWin(){
        var winName = "Statis_window_graph_<bean:write name="<%=StatisActionConst.SESSION_COLLECTION_ID%>"/>";
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
	function refreshGraph(){
		if(isSubmitted()){
			return false;
		}
		window.location="<html:rewrite page='/nasSwitchGraph.do?operation=displayGraph'/>"; 
		setSubmitted();
	}
	function backToList(){
		if(isSubmitted()){
			return false;
		}
		parent.location="forwardToList.do?graphType=<bean:write name="graphType"/>";
		setSubmitted();
		return true;
	}
    function createMaxWin(){
		var MaxWinName='Statis_nasswitch_window_setY_list'
         if(parent.hideframe.listMaxWin[MaxWinName] && !parent.hideframe.listMaxWin[MaxWinName].closed){
         	parent.hideframe.listMaxWin[MaxWinName].focus();
            return;
       	 }
       	 parent.hideframe.listMaxWinName.unshift(MaxWinName);
       	 document.forms[2].elements['isDetail'].value = "0";
         document.forms[2].elements['collectionItem'].value = "<bean:write name='<%=StatisActionConst.SESSION_COLLECTION_ID%>'/>";
         parent.hideframe.listMaxWin[MaxWinName]=open("/nsadmin/common/commonblank.html",MaxWinName,"resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=480,height=300");
         document.forms[2].action = "changeNasSwitchMax.do?operation=displayMax";
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
</script>
</head>
<body>
<logic:notEqual name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Node%>">
<input type="button" name="back" value="<bean:message bundle="common" key="common.button.back"/>" onclick="backToList();"/>
</logic:notEqual>
<input type="button" value="<bean:message key='common.button.reload' bundle='common'/>" onclick="refreshGraph();"/> 
</br>
<h3 class="title">
<bean:message key="h2.graphlist"/>
</h3>
<logic:equal name="isHasButton" value="yes">
<html:form action="nasSwitchGraph.do" method="POST"> 
	<html:hidden property="downloadInfo.defaultPeriod" />
	<html:hidden property="downloadInfo.customStartTime" />
	<html:hidden property="downloadInfo.customEndTime" />
    <html:hidden property="downloadInfo.collectionItemId" />	
 	<input type="hidden" name="downloadWinKey" value="">
    <input type="button" name="download" 
         value="<bean:message key='csvdownload.Download2'/>"
         onclick="return createWin()" /> 
   <logic:present name="msg_big_interval"> 
        <input type="button" value="<bean:message key='RRDGraph.button_setY'/>" disabled onclick="return createMaxWin()"/><br> 
   </logic:present>
   <logic:notPresent name="msg_big_interval">  
       <input type="button" value="<bean:message key='RRDGraph.button_setY'/>" onclick="return createMaxWin()"/><br> 
   </logic:notPresent>
</br>
<bean:write name="graphInfoList" filter="false"/>          
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
<html:hidden property="collectionItem"/>
<html:hidden property="selectedItem"/>
<html:hidden property="isDetail"/>
</html:form>
<html:form action="changeNasSwitchMax.do?operation=displayMax">
<html:hidden property="isDetail"/>
<html:hidden property="collectionItem"/>
<html:hidden property="selectedItem"/>
</html:form>
</logic:equal>
<logic:equal name="isHasButton" value="no">
<br>
<table border ="0"><tr><td>
<bean:message key="statis.nasswitch.noresource"/>
</td></tr></table>
</logic:equal>
</body>
</html>




