<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraywatchtop.jsp,v 1.2301 2005/09/21 04:56:42 wangli Exp $" -->

<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="diskarrayshow" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayFreshBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskarrayshow; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<head>
<!--title><nsgui:message key="fcsan_statemon/common/page_title"/></title-->
</head>
<script>
function initPage()
{
    <%
        //String alertMSG = _abstractJSPBean.getMsg ();
        if(alertMSG != null)
        {
            %>
            if(document.forms[0].alertFlag&&document.forms[0].alertFlag.value=="enable")
            {
                alert("<%=alertMSG%>");
                document.forms[0].alertFlag.value="disable";
                parent.location="<%=response.encodeRedirectURL("diskarraywatch.jsp")%>";
            }
            <%
        }
        %>
}
</script>
<body  onload="initPage();"> 
 <form method="post">
       <h1 class="title"><nsgui:message key="fcsan_statemon/common/h1"/></h1>
      <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>"  onclick='parent.middleframe.location="<%=response.encodeURL("diskarraywatchrefresh.jsp")%>"'>
       <h2 class="title"><nsgui:message key="fcsan_statemon/diskarraywatchtop/h2"/></h2>
      <input type="hidden" name="alertFlag" value="enable">
</form>
<script>
parent.bottomframe.location="<%=response.encodeRedirectURL("diskarraywatchbottom.jsp")%>"
</script>
</body>
</html>
