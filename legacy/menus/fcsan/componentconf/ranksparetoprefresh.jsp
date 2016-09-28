<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ranksparetoprefresh.jsp,v 1.2300 2003/11/24 00:55:04 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.sydney.beans.fcsan.common.*"%>

<jsp:useBean id="refreshBean" class="com.nec.sydney.beans.fcsan.componentdisp.FCSANRefreshBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=refreshBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
</head>
<body>
<%
String diskarrayid=request.getParameter("diskarrayid");
String diskarrayname=request.getParameter("diskarrayname");
String arraytype=request.getParameter("arraytype");
String pdgroupnumber=request.getParameter("pdgroupnumber");

if (refreshBean.refresh(diskarrayid)==0 ) {    
%>
<script language="javaScript">
parent.location="<%=response.encodeURL("rankspare.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&pdgroupnumber=<%=pdgroupnumber%>"
</script>
<%
} else {
    String errorMsg ; 
    String specialOrNot ;
    
    if (refreshBean.setSpecialErrMsg()) {
        errorMsg = refreshBean.getErrMsg();
        specialOrNot = "yes";
    } else {
        errorMsg = refreshBean.getErrMsg();
        specialOrNot = "no2";             
    }
%>
    
<form action="<%=response.encodeURL("ranksparetop.jsp")%>" target="topframe">
<input type="hidden" name="diskarrayname" value="<%=diskarrayname%>" >
<input type="hidden" name="errorMsg" value="<%=errorMsg%>">
<input type="hidden" name="specialOrNot" value="<%=specialOrNot%>">
<input type="hidden" name="diskarrayid" value="<%=diskarrayid%>" >
<input type="hidden" name="arraytype" value="<%=arraytype%>" >
<input type="hidden" name="pdgroupnumber" value="<%=pdgroupnumber%>">
</form>
<script language="javaScript">
document.forms[0].submit();
</script>
<%}%>
</body>
</html>