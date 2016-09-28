<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logicdiskbindtop.jsp,v 1.2302 2005/12/16 06:45:01 wangli Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="com.nec.sydney.framework.*" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body>
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/logicdiskbind/ldbind_title"/></h2>
<form>
<table>
<tr>
<th align="left"><nsgui:message key="fcsan_componentconf/table/th_dan" /></th>
<td>:</td>
<td align="left"><%=request.getParameter("diskarrayname")%></td>
</tr>
</table>
</form>
</body>
</html>
