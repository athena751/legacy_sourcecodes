<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfslognavigatorlist.jsp,v 1.4 2007/05/09 06:08:46 caows Exp $" -->

<%@ page import="com.nec.nsgui.model.entity.nfs.NFSConstant"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page buffer="32kb" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
function chooseParentDir(str , rootStr, type) {
    var tmpArray = new Array();
    var reg = /\//g;
    
    str = str.substring(1);
    
    tmpArray = str.split(reg);
    
    var parentDir = "/";
    for (var index=0 ; index<tmpArray.length - 2 ; index++) {
    	parentDir = parentDir + tmpArray[index] + "/";
    }
    parentDir = parentDir + tmpArray[tmpArray.length-2];
    
    document.forms[0].nowDirectory.value = parentDir;
	
    if(parent.frames[1].loaded){	
	parent.frames[1].document.forms[0].displayedDirectory.value = parentDir;
	parent.frames[1].document.forms[0].pagetype.value = type;
    }
}

function intoParentDir(str , rootStr, type) {
	chooseParentDir(str ,rootStr, type);
	
	document.forms[0].submit();
}

function chooseSubDir(wholePath, type) {
    document.forms[0].nowDirectory.value = wholePath;
    document.forms[0].type.value = type;
    if(parent.frames[1].loaded){	
        parent.frames[1].document.forms[0].displayedDirectory.value = wholePath;
	parent.frames[1].document.forms[0].pagetype.value = type;
    }	
}

function intoSubDir(wholePath, type) {
    if (parent.frames[1].loaded) {
	chooseSubDir(wholePath, type);
	
	document.forms[0].submit();
    }
}
</script>
</head>
<%
String contextPath = request.getContextPath();
%>
<body onload="setHelpAnchor('network_nfs_7');" onUnload="setHelpAnchor('network_nfs_6');">
<h1><bean:message key="title.nfs"/></h1>
<h2><bean:message key="nfslog.h2.file.select"/></h2>
<html:form action="NfsLogNavigatorList.do?operation=listLog">

<bean:size id="dirSize" name="allDirectoryInfo"/>


<bean:define id="nowDirTrue" name="NfsLogNavigatorListForm" property="nowDirectory"/>
<bean:define id="rootDir" name="NfsLogNavigatorListForm" property="rootDirectory"/>
<bean:define id="type" name="NfsLogNavigatorListForm" property="type"/>

<logic:equal name="dirSize" value="0">
	<logic:equal name="NfsLogNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
		<bean:message key="msg.navigator.none"/>
	</logic:equal>
	
	<logic:notEqual name="NfsLogNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
		<table>
		<tr>
		<th><bean:message key="info.navigator.th_status"/></th>
		<th><bean:message key="info.navigator.th_name"/></th>
		<th><bean:message key="info.navigator.th_date"/></th>
		<th><bean:message key="info.navigator.th_time"/></th>
		</tr>		
		
		

		<tr>
		<td><a href="#" onclick='intoParentDir("<%=NSActionUtil.sanitize((String)nowDirTrue , false)%>" , "<%=rootDir%>", "<%=type%>") ; return false;' >
			<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
		<td><a href="#" onclick='chooseParentDir("<%=NSActionUtil.sanitize((String)nowDirTrue , false)%>" , "<%=rootDir%>", "<%=type%>"); return false;' 
			ondblclick='intoParentDir("<%=NSActionUtil.sanitize((String)nowDirTrue , false)%>" , "<%=rootDir%>", "<%=type%>")'>
			<bean:message key="info.navigator.parent_dir"/></a></td>	
		<td></td>
		<td></td>
		</tr>	
		</table>
	</logic:notEqual>
</logic:equal>


<logic:notEqual name="dirSize" value="0">	
	<table>
		<tr>
		<th><bean:message key="info.navigator.th_status"/></th>
		<th><bean:message key="info.navigator.th_name"/></th>
		<th><bean:message key="info.navigator.th_date"/></th>
		<th><bean:message key="info.navigator.th_time"/></th>
		</tr>		
		
		<logic:notEqual name="NfsLogNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
			<tr>
			<td><a href="#" onclick='intoParentDir("<%=NSActionUtil.sanitize((String)nowDirTrue , false)%>" , "<%=rootDir%>", "<%=type%>") ; return false;' >
				<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
			<td><a href="#" onclick='chooseParentDir("<%=NSActionUtil.sanitize((String)nowDirTrue , false)%>" , "<%=rootDir%>", "<%=type%>"); return false;' 
				ondblclick='intoParentDir("<%=NSActionUtil.sanitize((String)nowDirTrue , false)%>" , "<%=rootDir%>", "<%=type%>")'>
				<bean:message key="info.navigator.parent_dir"/></a></td>
			
			<td></td>
			<td></td>
			</tr>
		</logic:notEqual>
		
		<logic:iterate id="oneDir" name="allDirectoryInfo">
		
			<bean:define id="wholePath" name="oneDir" property="wholePath"/>
		
			<tr>
			<logic:equal name="oneDir" property="dirType" value="directory">		
			<td><a href="#"
				onclick='intoSubDir("<%=NSActionUtil.sanitize((String)wholePath , false)%>","<%=type%>"); return false;'>
				<logic:equal name="oneDir" property="mountStatus" value="mount">	
					<img border="0" src="<%=contextPath%>/images/folder.open.gif">
				</logic:equal>	
				<logic:notEqual name="oneDir" property="mountStatus" value="mount">
				        <img border="0" src="<%=contextPath%>/images/folder.gif">
				</logic:notEqual>	
				</a></td>	
			<td nowrap><a href="#"
				onclick='chooseSubDir("<%=NSActionUtil.sanitize((String)wholePath , false)%>","<%=type%>"); return false;'
				ondblclick='intoSubDir("<%=NSActionUtil.sanitize((String)wholePath , false)%>","<%=type%>"); return false;'>
				<bean:define id="displayedPath" name="oneDir" property="displayedPath"/>
				<%=(String)displayedPath%>
				</a></td>
			</logic:equal>
		
			<logic:equal name="oneDir" property="dirType" value="file">
			<td><a href="#"
				onclick='chooseSubDir("<%=NSActionUtil.sanitize((String)wholePath , false)%>","<%=type%>"); return false'>	
					<img border="0" src="<%=contextPath%>/images/text.gif">	
				</a></td>	
			<td nowrap><a href="#"
				onclick='chooseSubDir("<%=NSActionUtil.sanitize((String)wholePath , false)%>","<%=type%>"); return false'>
				<bean:define id="displayedPath" name="oneDir" property="displayedPath"/>
				<%=(String)displayedPath%>
				</a></td>
			</logic:equal>
		
			<td><bean:write name="oneDir" property="dateString"/></td>
			<td><bean:write name="oneDir" property="timeString"/></td>		
			</tr>
		</logic:iterate>
	</table>
</logic:notEqual>

<html:hidden property="rootDirectory"/>
<html:hidden property="nowDirectory"/>
<html:hidden property="type"/>

<logic:present name="allDirectoryInfo" scope="session">
<%
session.removeAttribute("allDirectoryInfo");
%>
</logic:present>

</html:form>
</body>
</html:html>

