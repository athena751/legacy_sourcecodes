<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
        modified:xh2005
-->


<!-- "@(#) $Id: diskarraywatchrefresh.jsp,v 1.2302 2005/12/16 05:23:00 xingh Exp $" -->
<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.beans.fcsan.common.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="refresh" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayFreshBean" scope="page"/>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>
<% AbstractJSPBean _abstractJSPBean = refresh; %>
<% _abstractJSPBean.setRequest(request); %>

<%if(refresh.refreshDiskArray(session)!=0){
    int errorCode=refresh.getErrorCode();
    if(refresh.setSpecialErrMsg()) {%>

        <h2 class="title"><%=refresh.getErrMsg()%></h2>

    <%}  else {   %>

    <h1 class="Error"><nsgui:message key="fcsan_common/specialmessage/msg_refreshdiskarray"/></h1>
    <h2 class="Error"><%=refresh.getErrMsg()%></h2>

    <%}%>
    <script language=javascript>
    parent.bottomframe.location="<%=response.encodeURL("diskarraywatchbottom.jsp")%>";
    </script> 
    <%}else{%>
<script language=javascript>
parent.location="<%=response.encodeURL("diskarraywatch.jsp")%>"
</script> 
<%}%> 
    </body>
</html>
