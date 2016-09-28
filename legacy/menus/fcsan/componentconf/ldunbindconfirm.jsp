<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldunbindconfirm.jsp,v 1.2302 2004/08/14 09:51:50 huj Exp $" -->

<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="com.nec.sydney.framework.*" %>
<jsp:include page="../../common/wait.jsp" />
<head>
<title>
<nsgui:message key="fcsan_common/title/title_confirm"/>
</title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script>
    function onOk() {
        if(isSubmitted()) {
            setSubmitted();
            if(window.opener&&!window.opener.closed) {
                window.opener.document.forms[0].ok.disabled=true;
                window.opener.document.forms[0].cancel.disabled=true
            }
            document.forms[0].submit();
        }  
    }
    
    function onCancel() {
    	if(window.opener&&!window.opener.closed){
            window.opener.document.forms[0].ok.disabled = false;
            window.opener.document.forms[0].cancel.disabled = false;
	   }
	   window.close();
    }
</script>
</head>

<body>
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/logicdiskunbind/ldunbind_title"/></h2>
<form action="<%=response.encodeURL("../common/fcsanwait.jsp")%>"  method="post">
<nsgui:message key="fcsan_componentconf/logicdiskunbind/confirm_title" /><br><br>
<%
    String diskarrayname =request.getParameter("diskarrayname");
    String LDNo=request.getParameter("LDNo");
%>
<input type="hidden" name="diskarrayname" value="<%=diskarrayname%>">
<input type="hidden" name="LDNo" value="<%=LDNo%>">
<input type="hidden" name="target_jsp" value="../componentconf/bindunbindresult.jsp">
<input type="hidden" name="operation" value="unbind">
<input type="hidden" name="diskarrayid" value="<%=request.getParameter("diskarrayid")%>">
<input type="hidden" name="arraytype" value="<%=request.getParameter("arraytype")%>">
<input type="hidden" name="pdnum" value="<%=request.getParameter("pdnum")%>">

<table>
<tr>
    <th><nsgui:message key="fcsan_componentconf/logicdiskunbind/confirm_ldnumber" /></th>
    <td>:</td>
    <td><%=LDNo%></td>
</tr>
</table>
<br>
<nsgui:message key="fcsan_componentconf/logicdiskunbind/confirm_info" /><br>
<br>
<center>
<input type="submit"  name="ok" value="<nsgui:message key="fcsan_common/button/button_ok" />" onClick="onOk()">
<input type="button" name="cancel" value="<nsgui:message key="fcsan_common/button/button_cancel" />" onclick="onCancel()">
</center>
</form>
</body>
</html>
