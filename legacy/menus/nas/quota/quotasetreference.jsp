<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: quotasetreference.jsp,v 1.2 2006/01/03 02:32:10 cuihw Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*"%>

<jsp:useBean id="GetReport4SetBean" class="com.nec.sydney.beans.quota.GetReport4SetBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = GetReport4SetBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>