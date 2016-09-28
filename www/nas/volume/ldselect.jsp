<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ldselect.jsp,v 1.2 2007/05/09 05:09:59 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="title.ld.h2"/></title>
</head> 
<Frameset rows="*,60">
    <frame name="topframe" src="/nsadmin/volume/ldSelect.do" scrolling="auto"/>
    <frame name="bottomframe" src="/nsadmin/common/commonblank.html" scrolling="no"/>
</frameset>
</html:html>