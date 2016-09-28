<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: configurationmenutop.jsp,v 1.2301 2005/09/21 04:49:10 wangli Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.framework.*" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script>
function onRefresh()
{
        parent.mainframe.location="<%=response.encodeURL("confdiskarrayrefresh.jsp")%>"
}
</script>
<body> 
<form>
  <h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
     <input type="button"  name="refresh" value="<nsgui:message key="common/button/reload"/>" onClick="onRefresh()">
     <h2 class="title"><nsgui:message key="fcsan_componentconf/confmenu/h2_csm"/></h2>
</form>
</body>
</html>
