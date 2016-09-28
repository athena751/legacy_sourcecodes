<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: forward.jsp,v 1.2302 2006/02/20 00:35:05 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.beans.snapshot.MountPointBean
                            ,com.nec.sydney.beans.base.AbstractJSPBean
                            ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
                            
<jsp:useBean id="mpForward" class="com.nec.sydney.beans.snapshot.MountPointBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = mpForward; %>
<%@include file="../../../menu/common/includeheader.jsp" %> 
<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script src="../common/general.js"></script>
<jsp:include page="../../common/wait.jsp" />
</head>
</html>
