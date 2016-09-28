<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nativeaddforward.jsp,v 1.2300 2003/11/24 00:55:11 nsadmin Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"%>
<%@ page import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.beans.mapdnative.*" %>
<jsp:useBean id="addBean" class="com.nec.sydney.beans.mapdnative.NativeAddBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = addBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>