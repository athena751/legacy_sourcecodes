<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: mapdnavigatorlist.jsp,v 1.3 2007/05/09 06:45:16 wanghb Exp $" -->

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
	for (var index=0 ; index<tmpArray.length - 2 ; index++) {
		parentDir = parentDir + tmpArray[index] + "/";
	}
	parentDir = parentDir + tmpArray[tmpArray.length-2];
	
	var displaySelectedDir = parentDir.substring(rootStr.length + 1);
	
	document.forms[0].nowDirectory.value = parentDir;
	
	document.forms[0].selectType.value = "directory";
	
	parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedDir;
    }
}

function intoParentDir(str , rootStr) {
    if (parent.frames[1].document.forms[0]) {
	chooseParentDir(str ,rootStr);
	
	document.forms[0].submit();
    }
}

function chooseSubDir(displaySelectedPath , wholePath , theType) {
    if (parent.frames[1].document.forms[0]) {
	document.forms[0].nowDirectory.value = wholePath;
	document.forms[0].selectType.value = theType;
	parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedPath;
    }
	
}

function intoSubDir(displaySelectedPath , wholePath) {
    if (parent.frames[1].document.forms[0]) {
	chooseSubDir(displaySelectedPath , wholePath , "directory");
	
	document.forms[0].submit();
    }
}
</script>
</head>

<body>
<h1><bean:message key="title.h1"/></h1>
<h2><bean:message key="title.navigator.h2"/></h2>

<html:form action="MapdNavigatorList.do?operation=list">

<bean:size id="dirSize" name="MapdAllDirectoryInfo"/>
<bean:define id="nowDirTrue" name="MapdNavigatorListForm" property="nowDirectory"/>
<bean:define id="rootDir" name="MapdNavigatorListForm" property="rootDirectory"/>

<logic:equal name="dirSize" value="0">
    <logic:equal name="MapdNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
        <bean:message key="msg.navigator.none"/>
    </logic:equal>
	
    <logic:notEqual name="MapdNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
        <table>
	<tr>
	<th><bean:message key="info.navigator.th_status"/></th>
	<th><bean:message key="info.navigator.th_name"/></th>
	<th><bean:message key="info.navigator.th_date"/></th>
	<th><bean:message key="info.navigator.th_time"/></th>
	</tr>		
		
	<tr>
	<td><a href="#" onclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>'); return false;">
	    <img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
	<td nowrap><a href="#" onclick="chooseParentDir('<%=nowDirTrue%>' , '<%=rootDir%>'); return false;"
	                ondblclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>'); return false;">
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
		
	<logic:notEqual name="MapdNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
	<tr>
	<td><a href="#" onclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>'); return false;">
	        <img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
	<td nowrap><a href="#" onclick="chooseParentDir('<%=nowDirTrue%>' , '<%=rootDir%>'); return false;"
	                ondblclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>'); return false;">
		<bean:message key="info.navigator.parent_dir"/></a></td>
	<td></td>
	<td></td>
	</tr>
	</logic:notEqual>
		
	<logic:iterate id="oneDir" name="MapdAllDirectoryInfo">
	    <bean:define id="displaySelectedPath" name="oneDir" property="displaySelectedPath"/>
	    <bean:define id="wholePath" name="oneDir" property="wholePath"/>
	    
	    <tr>		
	    <logic:equal name="oneDir" property="dirType" value="directory">		
	        <td><a href="#" onclick="intoSubDir('<%=displaySelectedPath%>' , '<%=wholePath%>'); return false;">
		        <img border="0" src="<%=contextPath%>/images/folder.gif"></a></td>	
		<td nowrap><a href="#" 
		                onclick="chooseSubDir('<%=displaySelectedPath%>', '<%=wholePath%>' , 'directory'); return false"
		                ondblclick="intoSubDir('<%=displaySelectedPath%>' , '<%=wholePath%>'); return false;">
				<bean:write name="oneDir" property="displayedPath"/></a></td>
	    </logic:equal>
		
	    <logic:equal name="oneDir" property="dirType" value="file">
		<td><a href="#" onclick="chooseSubDir('<%=displaySelectedPath%>', '<%=wholePath%>' , 'file'); return false">	
				<img border="0" src="<%=contextPath%>/images/text.gif"></a></td>	
		<td nowrap><a href="#"
				onclick="chooseSubDir('<%=displaySelectedPath%>', '<%=wholePath%>' , 'file'); return false">
				<bean:write name="oneDir" property="displayedPath"/></a></td>
	    </logic:equal>
	    
	    <td nowrap><bean:write name="oneDir" property="dateString"/></td>
	    <td nowrap><bean:write name="oneDir" property="timeString"/></td>		
	    </tr>
	</logic:iterate>
	
	</table>
</logic:notEqual>

<html:hidden property="rootDirectory"/>
<html:hidden property="nowDirectory"/>

<!-- 
the default value is file .
Only when nowDirectory is "/etc/openldap" , the original value should be directory.
But when it occurs , it is a error because of the null text .
So the default value has no questions.
-->
<input type="hidden" name="selectType" value='<%=request.getParameter("selectType") == null?"file":request.getParameter("selectType")%>' >
</html:form>
</body>
</html:html>