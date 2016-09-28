<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: snapScheduleForward.jsp,v 1.2300 2003/11/24 00:55:15 nsadmin Exp $" -->

<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.snapshot.SnapScheduleBean
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.snapshot.*
                    ,com.nec.sydney.atom.admin.base.*" %>
<jsp:useBean id="bean" class="com.nec.sydney.beans.snapshot.SnapScheduleBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = bean; %>
<% _abstractJSPBean.setRequest(request); %>
<% _abstractJSPBean.setResponse(response); %>
<% _abstractJSPBean.setServlet(this); %>
<% _abstractJSPBean.process();%>