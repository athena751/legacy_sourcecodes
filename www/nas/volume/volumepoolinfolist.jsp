<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumepoolinfolist.jsp,v 1.3 2007/07/13 08:15:19 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%
    String topFrameHeight = "240";
    if (NSActionUtil.isProcyon(request)) {
        topFrameHeight = "310";
    }
%>
<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
</head>
<frameset rows="<%=topFrameHeight%>,*,60">
<html:frame frameName="volumeBatchListTop" href="volumepoolinfolist.do?operation=topDisplay"></html:frame>
<html:frame frameName="volumeBatchListMid" href="/nsadmin/nas/volume/commonblank.html"></html:frame>
<html:frame frameName="volumeBatchListBottom" scrolling="no" href="volumepoolinfolist.do?operation=bottomDisplay"></html:frame>
</frameset>
</html:html>