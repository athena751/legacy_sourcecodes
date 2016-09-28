<!--
        Copyright (c)2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: poolnodiskarray.jsp,v 1.5 2008/04/19 12:24:32 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<bean:parameter id="from" name="from" value="volumeCreate"/>
<%String title = "title.h1"; //from volume
  if (from.equals("replication")) {
  	title = "replication.h1";
  } else if (from.startsWith("ddr")) {
  	title = "ddr.h1";
  }
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<body>
    <h1 class="title"><bean:message key="<%=title%>"/></h1>
    <bean:message key="pool.info.nodiskarray"/>
</body>
</html:html>