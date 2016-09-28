<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchlistbottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function forwardToGraph (){
	if(isSubmitted()){
		return false;
	}
    if(!check()){
		return false;
    }
	var forwardForm=parent.contentframe.document.forms[0];
	forwardForm.target="_parent";
	forwardForm.action="nasSwitchGraph.do?operation=init";
	forwardForm.submit();
	setSubmitted();
}
function check(){
	var selectedForm=parent.contentframe.document.forms[0];
	var count=0;
	if(selectedForm.subItemCheckbox.length==null){
		if(selectedForm.subItemCheckbox.checked){
			 count=1;
		 }
	}else{
		for(i=0;i<selectedForm.subItemCheckbox.length;i++){
			if(selectedForm.subItemCheckbox[i].checked){
				count=1;
				break;
			}
		}
	}
	if(count<=0){
		<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
 			alert("<bean:message key="statis.nasswitch.resource.virtualpath_noselected"/>");
 		</logic:equal>
 		<logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
 			alert("<bean:message key="statis.nasswitch.resource.server_noselected"/>");
 		</logic:equal>
		return false;
	}
	return true;
}
function delList(){

	if(isSubmitted()){
		return false;
	}
    if(!check()){
		return false;
    }
    <logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Virtual_Export%>">
    	if(!confirm("<bean:message key='statis.nasswitch.resource.virtualpath_delete'/>")){
      		return false;
       	} 
    </logic:equal> 
    <logic:equal name="<%=StatisActionConst.SESSION_COLLECTION_ID%>" value="<%=StatisActionConst.NSW_NFS_Server%>">
    	if(!confirm("<bean:message key='statis.nasswitch.resource.server_delete'/>")){
      		return false;
       	}     
     </logic:equal>	
	var deleteForm=parent.contentframe.document.forms[0];
	deleteForm.action="nasswitchList.do?operation=deleteList";
	deleteForm.submit();
	setSubmitted();
}    
var windowName;
function createWin(){
    if(!check()){
		return false;
    }
	var count=0;
	var downloadform=parent.contentframe.document.forms[0]; 
	
	if(!parent.contentframe.alertInterval()){
	     return false;
	}
    var winName = "Statis_window_list_<bean:write name="<%=StatisActionConst.SESSION_COLLECTION_ID%>"/>";
    if(windowName && !windowName.closed){ 
		windowName.focus();
		return;
	}
	downloadform.elements['downloadWinKey'].value = winName;
	windowName = open("/nsadmin/common/commonblank.html",winName,"resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=580,height=650");
	downloadform.action= "<html:rewrite page='/download4NSW.do?operation=display'/>";
	downloadform.target=winName;
	downloadform.submit();
	windowName.focus();
}
function changeButtonStatus(){     
     <logic:empty name="<%=StatisActionConst.SESSION_STATIS_NASSWITCH_TABLE_MODE%>">
		document.forms[0].displayGraph.disabled = true;
		document.forms[0].download.disabled = true;
		document.forms[0].del.disabled = true;
	 </logic:empty>			
}
</script>
</HEAD>

<BODY onload="changeButtonStatus();">
<form>
<input type="button" name="displayGraph" 
         value="<bean:message key='statis.nasswitch.button.graphList'/>"
         onclick="return forwardToGraph()" />&nbsp;&nbsp;
<input type="button" name="download" 
         value="<bean:message key='csvdownload.Download2'/>"
         onclick="return createWin()" />&nbsp;&nbsp;&nbsp;&nbsp;
<logic:notEqual name="userinfo" value="nsview">
<input type="button" name="del" 
         value="<bean:message key='RRDGraph.button_delete'/>"
         onclick="return delList()" />
</logic:notEqual>
</form>
</BODY>
</HTML>
