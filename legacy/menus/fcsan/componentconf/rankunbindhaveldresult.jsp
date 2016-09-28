<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankunbindhaveldresult.jsp,v 1.2301 2008/11/26 09:25:26 chenb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="RankAndLDReleaseBean" class="com.nec.sydney.beans.fcsan.componentconf.RankAndLDReleaseBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=RankAndLDReleaseBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>


<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%
int result1=RankAndLDReleaseBean.releaseLD();
if(result1==0)
{
    int result2=RankAndLDReleaseBean.releaseRank();
    if(result2==0)
    {
        String pdgroupnumber=request.getParameter("pdgroupnumber");
        String diskarrayname=request.getParameter("diskarrayname");
        String diskarrayid=request.getParameter("diskarrayid");
        String arraytype=request.getParameter("arraytype");
%>
    <title>
    <nsgui:message key="fcsan_common/title/page_title_success"/>
    </title>
<script language="javaScript">
    function onOk1() {
        var win=window.opener;
        if(window.opener && !window.opener.closed) {
            if (window.opener.opener.parent && window.opener.opener.parent.topframe && window.opener.opener.parent.topframe.document.forms[0].rankspare_check)
                window.opener.opener.parent.location = "<%=response.encodeURL("rankspare.jsp")%>?pdgroupnumber=<%=pdgroupnumber%>&diskarrayname=<%=diskarrayname%>&diskarrayid=<%=diskarrayid%>&arraytype=<%=arraytype%>&reload=reload";               
            win.close();
        }
        window.close();
    }
</script>
</head>
    <body>
    <form method="post">
<h1 class="popup"><nsgui:message key="common/alert/done"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_common/specialmessage/msg_do_reload"/></h2>
<br>
    
    <center>    
    <input type="button" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOk1()">
    </center>
    
<%}else{%>
    <title>
    <nsgui:message key="fcsan_common/title/page_title_error"/>
    </title>
<script language="javaScript">
function onOk2()
{
    window.close();
}
function changeOpenerButton()
{

    var win=window.opener;
    if(window.opener&&!window.opener.closed){
        win.document.forms[0].ok.disabled=false;
        win.document.forms[0].cancel.disabled=false;
    }
}
</script>
    </head>
    <body onload="changeOpenerButton()">
    <form method="post">
    <%if(RankAndLDReleaseBean.setSpecialErrMsg()) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><%=RankAndLDReleaseBean.getErrMsg()%></h2>       
    <%}else{%>
        <h1 class="popupError"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popupError"><%=RankAndLDReleaseBean.getErrMsg()%></h2>
    <%}%>
<br>
<br>
    <center>
    <input type="button" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOk2()">
    </center>
<%}%>
<%}else{%>
<title>
<nsgui:message key="fcsan_common/title/page_title_error"/>
</title>

<script language="javaScript">
function onOk2()
{
    window.close();
}

function changeOpenerButton()
{

    var win=window.opener;
    if(window.opener&&!window.opener.closed){
        win.document.forms[0].ok.disabled=false;
        win.document.forms[0].cancel.disabled=false;
    }
}
</script>
</head>
<body onload="changeOpenerButton()">
<form method="post">
    <%if(result1 == 2){%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbindhaveldresult/inldsetmsg"/></h2>
    <%}else if(result1 == 3) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbindhaveldresult/hasportmsg"/></h2>
<!--modify by maojb and jinkc for LVM bind check-->
    <%}else if(result1 == 4) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><%=RankAndLDReleaseBean.getErrMsg()%></h2>
    <%}else if(result1 == 5) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/haspairedlds"/></h2>
    <%}else if(RankAndLDReleaseBean.setSpecialErrMsg()) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><%=RankAndLDReleaseBean.getErrMsg()%></h2>       
    <%}else{%>
        <h1 class="popupError"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popupError"><%=RankAndLDReleaseBean.getErrMsg()%></h2>
    <%}%>
<center>
<input type="button" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOk2()">
</center>
<%}%>

</form>
</body>
</html>