<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrdeletepairingforward.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page import="java.util.*,
        com.nec.sydney.atom.admin.base.*,
        com.nec.sydney.beans.base.*,
        com.nec.sydney.beans.ddr.*,
        com.nec.sydney.framework.*"%>
<jsp:useBean id="delBean" class="com.nec.sydney.beans.ddr.DdrDelPairingListBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = delBean; %>
<jsp:setProperty name="delBean" property="*"/>
<%@include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<script>
<%String act  = request.getParameter("operation");
  if(act.equals("deleteone")){%>
    parent.location = "ddrdeletepairinglist.jsp";
<%}else{%>
    if(parent.opener && parent.opener.multiaddexists){
        parent.opener.parent.location = "ddrpairinglist.jsp";
    }
    parent.close();
<%}%>
</script>
</head>
<body>
</body>
</html>
