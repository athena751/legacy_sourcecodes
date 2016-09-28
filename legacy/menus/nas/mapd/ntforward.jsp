
<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ntforward.jsp,v 1.2300 2003/11/24 00:55:11 nsadmin Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.beans.mapd.*,java.lang.*" %>
<jsp:useBean id="bean" class="com.nec.sydney.beans.mapd.AuthInfoBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = bean; %>
<% _abstractJSPBean.setRequest(request); %>
<% _abstractJSPBean.setResponse(response); %>
<% _abstractJSPBean.setServlet(this); %>
<% _abstractJSPBean.process();%>