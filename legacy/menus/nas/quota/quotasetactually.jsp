<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: quotasetactually.jsp,v 1.2300 2003/11/24 00:55:13 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*"%>

<jsp:useBean id="QuotaSetBean" class="com.nec.sydney.beans.quota.QuotaSetBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = QuotaSetBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%    
    QuotaSetBean.setQuota();
%>