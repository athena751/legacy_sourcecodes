<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: forward.jsp,v 1.2300 2003/11/24 00:54:59 nsadmin Exp $" -->
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>

<%  String beanClass = request.getParameter("beanClass");
    AbstractJSPBean _abstractJSPBean = (AbstractJSPBean)(Class.forName(beanClass).newInstance());
    pageContext.setAttribute("_abstractJSPBean", _abstractJSPBean, PageContext.PAGE_SCOPE);
%>
<jsp:setProperty name="_abstractJSPBean" property="*"/>
<%@ include file="../../menu/common/includeheader.jsp" %>