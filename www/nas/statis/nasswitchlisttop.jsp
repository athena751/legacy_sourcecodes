<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchlisttop.jsp,v 1.2 2005/10/24 12:24:46 pangqr Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<bean:define id="graphType" name="graphType"/>
<script language="JavaScript">
    var subItem=new Array();
	function initialization(){
		window.parent.buttonframe.location="forwardToButton.do";	
	}
    function refreshGraph(){
      if(isSubmitted()){
          return false;
       }
       window.location="<html:rewrite page='/nasswitchList.do?operation=displayListTop'/>"; 
       setSubmitted();
    }
	function checkNum(){
		var num=0;
		if(document.forms[0].subItemCheckbox.length==null){
			if(document.forms[0].subItemCheckbox.checked){
			   num=1;
			}
		}else{
			for(var i=0;i<document.forms[0].subItemCheckbox.length;i++){
				if(document.forms[0].subItemCheckbox[i].checked==true){
					num+=1;
				}
			}
		}
		if(num>12){
			<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
 				alert("<bean:message key="statis.nasswitch.resource.virtualpath_greater" arg0="<%=StatisActionConst.SESSION_SELECTED_NUM%>"/>");
 			</logic:equal>
 			<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
 				alert("<bean:message key="statis.nasswitch.resource.server_greater" arg0="<%=StatisActionConst.SESSION_SELECTED_NUM%>"/>");
 			</logic:equal>			
			return false;
		}
		return true;
	}
	function alertInterval(){
		if(document.forms[0].subItemCheckbox.length==null){
			return true;
		}
		var interval=new Array();
		var currentInterval;
		var num=0;
		for(var i=0;i<document.forms[0].subItemCheckbox.length;i++){
			if(document.forms[0].subItemCheckbox[i].checked==true){
				interval[num++]=subItem[document.forms[0].subItemCheckbox[i].value];
				currentInterval=subItem[document.forms[0].subItemCheckbox[i].value];
				for(var j=0;j<num;j++){
					if(currentInterval!=interval[j]){
					<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
						alert("<bean:message key="statis.nasswitch.interval.virtualpath.error" />");
				     </logic:equal>
				     <logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
						alert("<bean:message key="statis.nasswitch.interval.server.error" />");
					</logic:equal>
		            	return false
				    }
				}
			}
		}
		return true;	   
	}
    
</script>
</head>
<body onload="initialization()">
<input type="button" value="<bean:message key='common.button.reload' bundle='common'/>" onclick="refreshGraph()"/>
<h3 class="title">
<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
<bean:message key="statis.nasswitchtab.virtualpath.h3"/>
</logic:equal>
<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
<bean:message key="statis.nasswitchtab.server.h3"/>
</logic:equal>
</h3>
<table style="background-image: url('blank.gif');background-color: White;" width="100%">
<tr><td align="right">
<table border="1">
<tr><th><bean:message key="statis.nasswitch.time"/></th>
<td>
<bean:write name="time"/>
</td>
</tr>
</table>
</td></tr></table>
<logic:notEmpty name="<%=StatisActionConst.SESSION_STATIS_NASSWITCH_TABLE_MODE%>">
<bean:define id="tableMode" name="<%=StatisActionConst.SESSION_STATIS_NASSWITCH_TABLE_MODE%>" scope="session"/>
<html:form action="nasswitchList.do" method="post">
<nssorttab:table tablemodel="<%=(SortTableModel)tableMode%>" id="list1" table="border=1" sortonload="subItem:ascend"> 
	<nssorttab:column name="subItemCheckbox" 
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch" 
		sortable="no">
	</nssorttab:column>		
	<nssorttab:column name="subItem"                
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"
		sortable="yes">
		<bean:message name="watchItemDesc"/>
	</nssorttab:column>
	<logic:equal name="isCluster" value="true">
	<nssorttab:column name="node"
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"  
		sortable="yes">
	<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
		<bean:message key="statis.nasswitch.th.title.group"/>
	</logic:equal>
	<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
		<bean:message key="statis.nasswitch.th.title.node"/>
	</logic:equal>	
	</nssorttab:column>
	</logic:equal>
	<nssorttab:column name="access_average"
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch" 
		comparator="com.nec.nsgui.action.statis.LineNumComparator"
		sortable="yes">
	</nssorttab:column>
	<nssorttab:column name="access_max"
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch" 
		sortable="yes">
	</nssorttab:column>
	<nssorttab:column name="response_average"  
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch"
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch" 
		comparator="com.nec.nsgui.action.statis.LineNumComparator"
		sortable="yes">
	</nssorttab:column>
	<nssorttab:column name="response_max"  
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch"
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"
		comparator="com.nec.nsgui.action.statis.LineNumComparator" 
		sortable="yes">
	</nssorttab:column>
	<nssorttab:column name="rover_average" 
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"
		comparator="com.nec.nsgui.action.statis.LineNumComparator"
		sortable="yes"> 
	</nssorttab:column>
	<nssorttab:column name="rover_max" 
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch" 
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"
		comparator="com.nec.nsgui.action.statis.LineNumComparator"
		sortable="yes"> 
	</nssorttab:column>
	<nssorttab:column name="stockPeriod"  
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch"                       
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"
		comparator="com.nec.nsgui.action.statis.LineNumComparator"
		sortable="yes">
		<bean:message key="statis.nasswitch.th.title.stockPeriod"/>
	</nssorttab:column>
	<nssorttab:column name="interval"  
		th="com.nec.nsgui.action.statis.STHeaderRender4NasSwitch"                       
		td="com.nec.nsgui.action.statis.STDataRender4NasSwitch"
		comparator="com.nec.nsgui.action.statis.LineNumComparator"
		sortable="yes">
		<bean:message key="statis.nasswitch.th.title.interval"/>
	</nssorttab:column>	
</nssorttab:table>
        <html:hidden property="downloadInfo.defaultPeriod" />
        <html:hidden property="downloadInfo.customStartTime" />
        <html:hidden property="downloadInfo.customEndTime" />
        <html:hidden property="downloadInfo.collectionItemId" />
        <input type="hidden" name="downloadWinKey" value="">
</html:form>
</logic:notEmpty>
<logic:empty name="<%=StatisActionConst.SESSION_STATIS_NASSWITCH_TABLE_MODE%>">
<br>
<table border ="0"><tr><td>
<bean:message key="statis.nasswitch.noresource"/>
</td></tr></table>
</logic:empty>
</body>
</html>




