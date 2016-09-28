<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: dirgracetimeaction.jsp,v 1.2301 2006/02/20 00:35:05 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*"%>

<jsp:useBean id="setTimeBean" class="com.nec.sydney.beans.quota.GraceTimeLimitSetBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = setTimeBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
