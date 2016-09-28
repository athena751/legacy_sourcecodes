<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: setgracetime.jsp,v 1.2300 2003/11/24 00:55:13 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*"%>

<jsp:useBean id="setTimeBean" class="com.nec.sydney.beans.quota.GraceTimeLimitSetBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = setTimeBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
