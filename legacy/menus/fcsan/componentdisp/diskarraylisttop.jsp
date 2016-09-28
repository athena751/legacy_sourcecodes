<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: diskarraylisttop.jsp,v 1.2301 2005/09/21 04:53:50 wangli Exp $" -->
  
<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body> 
<h1 class="title"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<form>
     <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>"  onclick='if(!this.disabled) parent.mainframe.location="<%=response.encodeURL("diskarraylistrefresh.jsp")%>"'>
     <input type="hidden" name="diskarraylist_check" value="">
</form>
<h2 class="title"><nsgui:message key="fcsan_componentdisp/diskarray/h2"/></h2>
</body>
</html>
