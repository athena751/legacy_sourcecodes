<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumedetail.jsp,v 1.2 2007/05/09 05:19:08 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<bean:parameter id="from" name="from" value="volume"/>
<% String title = from.equals("volume")? "title.h1" : "h1.filesystem"; %>
<html:html lang="true">
<head>
<title><bean:message key="<%=title%>"/></title>
<%@include file="/common/head.jsp" %>
</head> 
<Frameset rows="*,60">
    <frame name="topframe" src="/nsadmin/volume/volumeDetailTop.do?from=<bean:write name="from"/>" scrolling="auto">
    <frame name="bottomframe" src="/nsadmin/volume/volumeClosePage.do" scrolling="no">
</frameset>
</html:html>