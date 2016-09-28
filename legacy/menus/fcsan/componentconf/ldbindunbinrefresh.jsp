<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldbindunbinrefresh.jsp,v 1.2302 2005/09/21 04:49:10 wangli Exp $" -->

<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>
<jsp:useBean id="pdInfoBean" class="com.nec.sydney.beans.fcsan.componentconf.LDBindUnbindBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = pdInfoBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body>
<%
if(pdInfoBean.getErrMsg()==null)
{%>
<script>
parent.location="<%=response.encodeURL("ldbindunbind.jsp")%>?diskarrayid=<%=request.getParameter("diskarrayid")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>&arraytype=<%=request.getParameter("arraytype")%>&monitoringstate=<%=request.getParameter("monitoringstate")%>&PDGroups=<%=request.getParameter("PDGroups")%>"

</script>
<%}else{%>
        <%String errMsgForMiddle = pdInfoBean.getErrMsg(); %>
         <h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
         <input type="button" name="back" value="<nsgui:message key="common/button/back" />" onclick="parent.location='<%=response.encodeURL("ldmenu.jsp")%>'" >                             
         <input type="button" value="<nsgui:message key="common/button/reload" />" onclick="window.location='<%=response.encodeURL("ldbindunbinrefresh.jsp")%>?action=refresh&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>&PDGroups=<%=request.getParameter("PDGroups")%>'" >         
         <h2 class="title"><nsgui:message key="fcsan_componentconf/ldbindunbind/ldbindunbind_title" /></h2>
         <h3 class="title"><nsgui:message key="fcsan_componentconf/table/th_dan" />&nbsp;:&nbsp;<%=request.getParameter("diskarrayname")%></h3>
         <form action="<%=response.encodeURL("ldbindunbindmiddle.jsp")%>" target="mainframe">
         <input type="hidden" name="ErrMsgForMiddle" value="<%=errMsgForMiddle%>">
         <input type="hidden" name="diskarrayid" value="<%=request.getParameter("diskarrayid")%>">
         <input type="hidden" name="action" value="RankInfo">
         </form>
    <script>
    document.forms[0].submit();
    parent.bottomframe.location="<%=response.encodeURL("ldbindunbindbottom.jsp")%>";
    </script>   
<%}%>
</body>
</html>
