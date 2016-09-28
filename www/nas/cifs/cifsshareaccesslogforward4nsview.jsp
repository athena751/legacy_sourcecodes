<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsshareaccesslogforward4nsview.jsp,v 1.1 2005/08/29 18:35:44 key Exp $" -->
<%@include file="../../common/head.jsp" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>
<% String name = (String)request.getParameter("shareName");
	session.setAttribute("shareName",name);
%>
<script language="JavaScript"> 
    window.location = "/nsadmin/cifs/setAccessLog4nsview.do?operation=display";
</script>