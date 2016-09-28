<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: lvmclustercreate.jsp,v 1.2300 2003/11/24 00:55:10 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,java.lang.*" %>

<jsp:useBean id="createBean" class="com.nec.sydney.beans.lvm.LVMCreateBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = createBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %> 