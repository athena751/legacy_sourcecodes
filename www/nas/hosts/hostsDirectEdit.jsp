<!-- 
    Copyright (c) 2006-2007 NEC Corporation
		
    NEC SOURCE CODE PROPRIETARY
		
    Use, duplication and disclosure subject to a source code 
    license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: hostsDirectEdit.jsp,v 1.2 2007/05/09 05:28:30 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
</head>
<Frameset rows="*,60" border="1">
    <frame name="hostsFileTop" src="hostsFileTop.do?operation=getFileContent" border="0">
    <frame name="hostsFileBottom" scrolling="no" src="hostsFileBottom.do" class="TabBottomFrame">
</Frameset>
</html:html>