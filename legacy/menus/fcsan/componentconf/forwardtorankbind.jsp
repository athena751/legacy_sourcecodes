<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: forwardtorankbind.jsp,v 1.1 2004/08/31 01:59:23 caoyh Exp $" -->

<!-- this file is used by volume -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.beans.base.*"%>
<jsp:useBean id="getPDAndRankBean" class="com.nec.sydney.beans.fcsan.componentconf.GetPDAndRankBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=getPDAndRankBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>
<jsp:forward page="rankbind.jsp?from=volume"/>
