<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankbindresult.jsp,v 1.2302 2004/10/26 09:45:47 liuyq Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="RankBindBean" class="com.nec.sydney.beans.fcsan.componentconf.RankBindBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=RankBindBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<%
if(RankBindBean.getSuccess()){
    String diskarrayname = request.getParameter("diskarrayname");
    String pdgroupnumber = request.getParameter("pdgroupnumber");
    String diskarrayid = request.getParameter("diskarrayid");
    String arraytype = request.getParameter("arraytype");
%>
<title>
<nsgui:message key="fcsan_common/title/page_title_success"/>
</title>
<script language="javaScript">
    function onOk1() {
        if(window.opener&&!window.opener.closed) {
            if (window.opener.parent.opener.parent && window.opener.parent.opener.parent.topframe && window.opener.parent.opener.parent.topframe.document.forms[0].rankspare_check){
                window.opener.parent.opener.parent.location = "<%=response.encodeURL("rankspare.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&arraytype=<%=arraytype%>&reload=reload";
            }else if (window.opener.parent && window.opener.parent.opener 
                && window.opener.parent.opener.document.forms[0]
                && window.opener.parent.opener.document.forms[0].selfURL){
                    window.opener.parent.opener.location = window.opener.parent.opener.document.forms[0].selfURL.value;                
            }
            window.opener.parent.close();
        }
        window.close();
    }
</script>
</head>
<body>
<form method="post">
<h1 class="popup"><nsgui:message key="common/alert/done"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_common/specialmessage/msg_do_reload"/></h2>
<center>
<input type="button" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOk1()">
</center>
<%} else {%>
<title>
<nsgui:message key="fcsan_common/title/page_title_error"/>
</title>
<script language="javaScript">
    function onOk2() {
        window.close();
    }
    
    function changeOpenerButton() {
        if(window.opener&&!window.opener.closed&&window.opener.parent.frames[1]) {
            window.opener.parent.frames[1].document.forms[0].bind.disabled=false;
            window.opener.parent.frames[1].document.forms[0].cancel.disabled=false;
        }
    }
</script>
</head>
<body onload="changeOpenerButton()">
<form method="post">
    <%if(RankBindBean.getErrorCode() == FCSANConstants.iSMSM_EXIST) {%>
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><nsgui:message key="fcsan_componentconf/rankbindresult/msg_repeat_ranknum"/></h2>
    <%//added by hujing 2002/10/04 for fcsan-defect 190 %>    
    <%}else if (RankBindBean.setSpecialErrMsg()){%>   
        <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popup"><%=RankBindBean.getErrMsg()%></h2>
    <%}else{  //add end %>
        <h1 class="popupError"><nsgui:message key="common/alert/failed"/></h1>
        <h2 class="popupError"><%=RankBindBean.getErrMsg()%></h2>
    <%}%>
<center>
<input type="button" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOk2()">
</center>
<%}%>
</form>
</body>
</html>

