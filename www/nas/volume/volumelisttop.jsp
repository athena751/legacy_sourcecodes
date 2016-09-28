<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumelisttop.jsp,v 1.5 2007/05/09 05:21:29 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<body onload="displayAlert();" onUnload="closeDetailErrorWin();">
<h1 class="title"><bean:message key="title.h1"/></h1>
<h2 class="title"><bean:message key="title.list.h2"/></h2>
<table>
    <tr>
	<td>
	<logic:notEmpty name="<%=VolumeActionConst.SESSION_VOLUME_TABLE_MODE%>" scope="session">
		<bean:message key="msg.list.selectVolume"/><br>
	</logic:notEmpty>
	<bean:message key="msg.list.createVolume"/>
	</td>
	</tr>
</table>
<displayerror:error h1_key="title.h1"/>
<br>
<form>
<html:button property="addBtn" onclick="parent.location='/nsadmin/volume/volumeAddShow.do';">
   <bean:message key="common.button.create" bundle="common"/><bean:message key="button.dot"/>
</html:button>
<html:button property="batchAddBtn" onclick="parent.location='/nsadmin/volume/volumeBatchDispatch.do?operation=display';">
   <bean:message key="button.batchCreate"/><bean:message key="button.dot"/>
</html:button>
</form>
</body>
</html:html>