<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMRemove.jsp,v 1.2300 2003/11/24 00:55:10 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.beans.base.*" %>

<jsp:useBean    id="removeBean" class="com.nec.sydney.beans.lvm.LVMRemoveBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean =removeBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
