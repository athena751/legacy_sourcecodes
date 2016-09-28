<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cgnavigatorlist.jsp,v 1.6 2007/05/09 07:36:44 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<%
String contextPath = request.getContextPath();
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript">
function chooseParentDir(str , rootStr) {
    if (parent.frames[1].document.forms[0]) {
	var tmpArray = new Array();
	var reg = /\//g;
	
	str = str.substring(1);
	
	tmpArray = str.split(reg);
	
	var parentDir = "/";
	for (var index=0 ; index<tmpArray.length - 1 ; index++) {
		parentDir = parentDir + tmpArray[index] + "/";
	}
	
	if (parentDir != "/") {
            parentDir = parentDir.substring(0 , parentDir.length - 1);
        }
	
	var displaySelectedDir = parentDir;
	
	document.forms[0].nowDirectory.value = parentDir;
	
	parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedDir;
    }
	
}

function intoParentDir(str , rootStr) {
    if (parent.frames[1].document.forms[0]) {
	chooseParentDir(str ,rootStr);
	
	document.forms[0].submit();
    }
}

function chooseSubDir(displaySelectedPath , wholePath) {
    if (parent.frames[1].document.forms[0]) {
	document.forms[0].nowDirectory.value = wholePath;
	parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedPath;
    }
	
}

function intoSubDir(displaySelectedPath , wholePath) {
    if (parent.frames[1].document.forms[0]) {
	chooseSubDir(displaySelectedPath , wholePath);
	
	document.forms[0].submit();
    }
}

function initDisplayedDir(){
    if(parent.frames[1] && (parent.frames[1].document.forms[0]) && (parent.frames[1].document.forms[0].displayedDirectory)){
        parent.frames[1].document.forms[0].displayedDirectory.value = document.forms[0].nowDirectory.value;
    }
}
</script>
</head>

<body onload="initDisplayedDir();">
<h1 class="popup"><bean:message key="cifs.common.h1"/></h1>
<h2 class="popup"><bean:message key="cg.title.navigator.h2"/></h2>

<html:form action="CGNavigatorList.do?operation=listGlobal">

<bean:size id="dirSize" name="CIFSGlobalAllDirectoryInfo"/>

<bean:define id="nowDirTrue" name="CIFSNavigatorListForm" property="nowDirectory"/>
<bean:define id="rootDir" name="CIFSNavigatorListForm" property="rootDirectory"/>

<logic:equal name="dirSize" value="0">
	<logic:equal name="CIFSNavigatorListForm" property="rootDirectory"  value="<%=(String)nowDirTrue%>">
		<bean:message key="cg.msg.navigator.none"/>
	</logic:equal>
	
	<logic:notEqual name="CIFSNavigatorListForm" property="rootDirectory"  value="<%=(String)nowDirTrue%>">
		<table>
		<tr>
		<th><bean:message key="info.navigator.th_status"/></th>
		<th><bean:message key="info.navigator.th_name"/></th>
		<th><bean:message key="info.navigator.th_date"/></th>
		<th><bean:message key="info.navigator.th_time"/></th>
		</tr>		
	
		<tr>
		<td><a href="#" onclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
			<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
		<td nowrap><a href="#" onclick='chooseParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'
		                    ondblclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
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
		
		<logic:notEqual  name="CIFSNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
			<tr>
			<td><a href="#" onclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
				<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
			<td nowrap><a href="#" onclick='chooseParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'
			                ondblclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
				<bean:message key="info.navigator.parent_dir"/></a></td>
			<td></td>
			<td></td>
			</tr>
		</logic:notEqual>
		
		<logic:iterate id="oneDir" name="CIFSGlobalAllDirectoryInfo">
		
			<bean:define id="displaySelectedPath" name="oneDir" property="displaySelectedPath"/>
			<bean:define id="wholePath" name="oneDir" property="wholePath"/>
		
			<tr>
			<logic:equal name="oneDir" property="dirType" value="directory">		
			<td><a href="#"
				onclick='intoSubDir("<%=displaySelectedPath%>" , "<%=wholePath%>"); return false;'>
				<logic:equal name="oneDir" property="mountStatus" value="mount">	
					<img border="0" src="<%=contextPath%>/images/folder.open.gif">
				</logic:equal>	
				<logic:notEqual name="oneDir" property="mountStatus" value="mount">
				        <img border="0" src="<%=contextPath%>/images/folder.gif">
				</logic:notEqual>	
				</a></td>	
			<td nowrap><a href="#"
				onclick='chooseSubDir("<%=displaySelectedPath%>", "<%=wholePath%>"); return false'
				ondblclick='intoSubDir("<%=displaySelectedPath%>" , "<%=wholePath%>"); return false;'>
				<bean:define id="displayedPath" name="oneDir" property="displayedPath"/>
				<%=(String)displayedPath%>
				</a></td>
			</logic:equal>
		
			<logic:equal name="oneDir" property="dirType" value="file">
			<td><a href="#"
				onclick='chooseSubDir("<%=displaySelectedPath%>", "<%=wholePath%>"); return false'>	
					<img border="0" src="<%=contextPath%>/images/text.gif">	
				</a></td>	
			<td nowrap><a href="#"
				onclick='chooseSubDir("<%=displaySelectedPath%>", "<%=wholePath%>"); return false'>
				<bean:define id="displayedPath" name="oneDir" property="displayedPath"/>
				<%=(String)displayedPath%>
				</a></td>
			</logic:equal>
		
			<td nowrap><bean:write name="oneDir" property="dateString"/></td>
			<td nowrap><bean:write name="oneDir" property="timeString"/></td>		
			</tr>
		</logic:iterate>
	</table>
</logic:notEqual>

<html:hidden property="rootDirectory"/>
<html:hidden property="nowDirectory"/>

</html:form>
</body>
</html:html>