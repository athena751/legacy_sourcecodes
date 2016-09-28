<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchcreateshownolun.jsp,v 1.3 2007/05/09 05:16:16 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>


<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>

<body>
<h1><bean:message key="title.h1"/></h1>
<input type=button 
       name="back" 
       value="<bean:message key="common.button.back" bundle="common"/>"
       onclick="window.location='volumeList.do'"/>
<h2><bean:message key="title.batchcreateshow.h2"/></h2>
<h3><bean:message key="title.batchcreateshow.h3"/></h3>
<bean:message key="msg.batchcreateshow.nolun"/>
</body>
</html:html>

