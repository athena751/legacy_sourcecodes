<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsnavigatorlist.jsp,v 1.4 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>

<%
String contextPath = request.getContextPath();
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
function chooseParentDir(str , rootStr, fsType, isSubMount, hasDomain) {
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
	document.forms[0].fsType.value = fsType;
	document.forms[0].isSubMount.value = isSubMount;
	document.forms[0].hasDomain.value = hasDomain;

        if(parent.frames[1].loaded){	
            parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedDir;
            parent.frames[1].document.forms[0].fsType.value = fsType;
            parent.frames[1].document.forms[0].isSubMount.value = isSubMount;
            parent.frames[1].document.forms[0].hasDomain.value = hasDomain;
	}
}

function intoParentDir(str , rootStr, fsType, isSubMount, hasDomain) {
	chooseParentDir(str ,rootStr, fsType, isSubMount, hasDomain);
	
	document.forms[0].submit();
}

function chooseSubDir(displaySelectedPath , wholePath, fsType, isSubMount, hasDomain) {
	document.forms[0].nowDirectory.value = wholePath;
	document.forms[0].fsType.value = fsType;
	document.forms[0].isSubMount.value = isSubMount;
	document.forms[0].hasDomain.value = hasDomain;
        if(parent.frames[1].loaded){	
            parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedPath;
            parent.frames[1].document.forms[0].fsType.value = fsType;
            parent.frames[1].document.forms[0].isSubMount.value = isSubMount;
            parent.frames[1].document.forms[0].hasDomain.value = hasDomain;
	}
}

function intoSubDir(displaySelectedPath , wholePath, fsType, isSubMount, hasDomain) {
	chooseSubDir(displaySelectedPath , wholePath, fsType, isSubMount, hasDomain);
	
	document.forms[0].submit();
}
</script>
</head>

<body onload="setHelpAnchor('network_nfs_4');" onUnload="top.opener.setHelp();">
<h1><bean:message key="title.nfs"/></h1>
<h2><bean:message key="title.navigator.h2"/></h2>

<html:form action="NfsNavigatorList.do?operation=list">

<bean:size id="dirSize" name="allDirectoryInfo"/>

<bean:define id="nowDirTrue" name="NfsNavigatorListForm" property="nowDirectory"/>
<bean:define id="rootDir" name="NfsNavigatorListForm" property="rootDirectory"/>
<bean:define id="fsType" name="NfsNavigatorListForm" property="fsType"/>
<bean:define id="isSubMount" name="NfsNavigatorListForm" property="isSubMount"/>
<bean:define id="hasDomain" name="NfsNavigatorListForm" property="hasDomain"/>
			
<logic:equal name="dirSize" value="0">
	<logic:equal name="NfsNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
		<bean:message key="msg.navigator.none"/>
	</logic:equal>
	
	<logic:notEqual name="NfsNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
		<table>
		<tr>
		<th><bean:message key="info.navigator.th_status"/></th>
		<th><bean:message key="info.navigator.th_name"/></th>
		<th><bean:message key="info.navigator.th_date"/></th>
		<th><bean:message key="info.navigator.th_time"/></th>
		</tr>		
		
		

		<tr>
		<td><a href="#" onclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false;" >
			<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
		<td nowrap><a href="#" onclick="chooseParentDir('<%=nowDirTrue%>' , '<%=rootDir%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false;"
		                ondblclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false;" >
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
		
		<logic:notEqual name="NfsNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
			<tr>
			<td><a href="#" onclick="intoParentDir('<%=nowDirTrue%>', '<%=rootDir%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false;" >
				<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
			<td nowrap><a href="#" onclick="chooseParentDir('<%=nowDirTrue%>' , '<%=rootDir%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false;" 
			                ondblclick="intoParentDir('<%=nowDirTrue%>' , '<%=rootDir%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false;" >
				<bean:message key="info.navigator.parent_dir"/></a></td>
			
			<td></td>
			<td></td>
			</tr>
		</logic:notEqual>
		
		<logic:iterate id="oneDir" name="allDirectoryInfo">
		
			<bean:define id="displaySelectedPath" name="oneDir" property="displaySelectedPath"/>
			<bean:define id="wholePath" name="oneDir" property="wholePath"/>
			<bean:define id="fsType" name="oneDir" property="fsType"/>
			<bean:define id="isSubMount" name="oneDir" property="isSubMount"/>
			<bean:define id="hasDomain" name="oneDir" property="hasDomain"/>
			<tr>
                        <%
                           String imageUrl = contextPath + "/images/folder.gif";                           
                           if(((String)wholePath).split("/").length ==4 || Integer.parseInt((String)isSubMount) == 1) {
                               imageUrl = contextPath + "/images/folder.open.gif";
                           }
                        %>		
			
			<td><a href="#"
				onclick="intoSubDir('<%=displaySelectedPath%>', '<%=wholePath%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false" >	
					<img border="0" src="<%=imageUrl%>">	
				</a></td>	
			<td nowrap><a href="#"
				onclick="chooseSubDir('<%=displaySelectedPath%>', '<%=wholePath%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false"
				ondblclick="intoSubDir('<%=displaySelectedPath%>' , '<%=wholePath%>', '<%=fsType%>', '<%=isSubMount%>', '<%=hasDomain%>'); return false" >
				<bean:write name="oneDir" property="displayedPath"/>
				</a></td>
		
			<td nowrap><bean:write name="oneDir" property="dateString"/></td>
			<td nowrap><bean:write name="oneDir" property="timeString"/></td>		
			</tr>
		</logic:iterate>
	</table>
</logic:notEqual>

<html:hidden property="rootDirectory"/>
<html:hidden property="nowDirectory"/>
<html:hidden property="fsType"/>
<html:hidden property="isSubMount"/>
<html:hidden property="hasDomain"/>

</html:form>
</body>
</html:html>

