<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: includeheader.jsp,v 1.2300 2003/11/24 00:54:59 nsadmin Exp $" -->

<%@ page import="com.nec.sydney.atom.admin.base.*" %>

<%-- Set implicit Servlet objects --%>
<% _abstractJSPBean.setRequest(request); %>
<% _abstractJSPBean.setResponse(response); %>
<% _abstractJSPBean.setServlet(this); %>

<script language="javaScript">

function displayAlert()
 {
     <%
    String alertMSG = _abstractJSPBean.getMsg ();
    if(alertMSG != null)
    {
        %>
        if(document.forms[0].alertFlag&&document.forms[0].alertFlag.value=="enable")
        {
            alert("<%=alertMSG%>");
            document.forms[0].alertFlag.value="disable"
        }
        <%
    }
    %>
 }

</script>

<%-- Perform the processing associated with the JSP --%>
<% _abstractJSPBean.process(); %>