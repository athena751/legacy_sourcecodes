<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: bindunbindresult.jsp,v 1.2301 2008/07/21 05:50:19 pizb Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<jsp:useBean id="settingBean" class="com.nec.sydney.beans.fcsan.componentconf.BindUnbindConfBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = settingBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<% String operation=request.getParameter("operation");
    String diskarrayname = request.getParameter("diskarrayname") ;
    String diskarrayid = request.getParameter("diskarrayid") ;
    String arraytype = request.getParameter("arraytype") ; 
    String pdnum = request.getParameter("pdnum") ;
    if (pdnum != null && (pdnum.trim().endsWith("h") || pdnum.trim().endsWith("H"))) {
        pdnum = pdnum.trim().substring(0,pdnum.length()-1) ;
    }
    
if (operation.equals("unbind"))
{
    settingBean.LDUnbind();
}
if (operation.equals("bind"))
{
    settingBean.LDBind();
}
if (operation.equals("timeset"))
{
    settingBean.LDTimeset();
}
%>
<%if(settingBean.isSuccess()){%>
<title><nsgui:message key="fcsan_common/title/page_title_success" /></title>

<%}else{%>
<title><nsgui:message key="fcsan_common/title/page_title_error" /></title>
<script>

if(window.opener&&!window.opener.closed){
    <%
        if (operation.equals("bind")){
        %>
    if (window.opener.parent.frames[2]){
        window.opener.document.forms[0].ok.disabled=false;
        window.opener.document.forms[0].cancel.disabled=false;
    }
     <%}else{%>
        window.opener.document.forms[0].ok.disabled=false;
        window.opener.document.forms[0].cancel.disabled=false;
         <%}%>
}
</script>
<%}%>

<head>
    <link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
    <script>
    function onOk() {
        <% if(settingBean.isSuccess()){ %>
            if (window.opener&&!window.opener.closed) {
                if (window.opener.parent.opener.parent && window.opener.parent.opener.parent.topframe && window.opener.parent.opener.parent.topframe.document.forms[0].ldbindunbind_check)
                    if ("<%=operation%>"=="timeset") {
                        window.opener.parent.opener.parent.location = window.opener.parent.opener.parent.location;
                    } else {
                        window.opener.parent.opener.parent.location = "<%=response.encodeURL("ldbindunbind.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&PDGroups=<%=pdnum%>&reload=reload" ;
                    }
                window.opener.parent.close();
            }
        <%}%>
        window.close();
    }
</script>
</head>

<body>
<form method="post">

<%=settingBean.getErrMsg()%>
<br>
<center>
<input type="button" name="ok" value="<nsgui:message key="fcsan_common/button/button_ok" />" onclick="onOk()">
</center>
</form>
</body>
</html>