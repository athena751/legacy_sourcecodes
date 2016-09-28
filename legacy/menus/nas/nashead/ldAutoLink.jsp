<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldAutoLink.jsp,v 1.2 2004/08/14 11:03:37 changhs Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP" %>
<%@ page language="java"  import="com.nec.sydney.beans.base.AbstractJSPBean,com.nec.sydney.atom.admin.base.*" %>

<jsp:useBean id="bean" class="com.nec.sydney.beans.nashead.NasHeadAutoLinkBean" scope="application"/>
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@ include file="../../common/includeheader.jsp" %>
<%
bean.execAutoLink();

String nextURL = "ldlist.jsp";
if (request.getParameter("nextURL") != null){    
    nextURL = request.getParameter("nextURL");
}else{
	String target = request.getParameter("target");
	if((target != null) && !target.equals("")){
	    nextURL = nextURL + "?target=" + target;
	}
}
response.sendRedirect(response.encodeRedirectURL(nextURL));

%>