<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportRootForward.jsp,v 1.2302 2004/08/24 09:57:33 xiaocx Exp $" -->

<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.exportroot.ExportRootBean
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.base.*" %>
<jsp:useBean id="exportRootBean" class="com.nec.sydney.beans.exportroot.ExportRootBean" scope="page"/>

<%AbstractJSPBean _abstractJSPBean =exportRootBean; %>
<% _abstractJSPBean.setRequest(request); %>
<% _abstractJSPBean.setResponse(response); %>
<% _abstractJSPBean.setServlet(this); %>
<% _abstractJSPBean.process();%>

<html>
<head>
<script src="../../../common/common.js"></script>
<script>
    refreshControllerFrame('');
    window.location = "exportRoot.jsp";
</script>
</head>
<body>
</body>
</html>