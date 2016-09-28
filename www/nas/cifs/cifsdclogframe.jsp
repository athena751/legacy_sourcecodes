<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsdclogframe.jsp,v 1.2 2006/05/12 09:37:20 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="cifs.dclog.h2"/></title>
<Frameset rows="100%,0" border="0" framespacing="0">
    <frame name="logviewframe" src="cifsDCLog.do?operation=displayDCLog">
    <frame name="autoconnectframe" src="cifsDCLogAutoConnect.do" frameborder="0" scrolling="no" noresize nofocus>
</Frameset>


</html>