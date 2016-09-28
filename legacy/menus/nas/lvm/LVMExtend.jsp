<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMExtend.jsp,v 1.2300 2003/11/24 00:55:10 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.beans.lvm.*" %>
<%@ page import="com.nec.sydney.beans.base.*" %>

<jsp:useBean id="extendlv" class="com.nec.sydney.beans.lvm.LVMExtendBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = extendlv; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
