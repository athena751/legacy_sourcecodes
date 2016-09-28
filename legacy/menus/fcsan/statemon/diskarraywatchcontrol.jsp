<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraywatchcontrol.jsp,v 1.2300 2003/11/24 00:55:06 nsadmin Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>

<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>

<jsp:useBean id="diskarrayMonitor" class="com.nec.sydney.beans.fcsan.statemon.DiskArrayMonitorBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskarrayMonitor; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<script language="javascript">

<%if (diskarrayMonitor.isSuccess()){%>
parent.topframe.location="<%=response.encodeRedirectURL("diskarraywatchtop.jsp")%>";
//parent.bottomframe.location="<%=response.encodeRedirectURL("diskarraywatchbottom.jsp")%>";
<%}else{%>
//parent.bottomframe.location="<%=response.encodeRedirectURL("diskarraywatchbottom.jsp")%>?showerror=yes";
<%}%>
</script>

