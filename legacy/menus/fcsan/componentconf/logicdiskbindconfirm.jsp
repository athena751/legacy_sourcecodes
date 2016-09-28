<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logicdiskbindconfirm.jsp,v 1.2307 2007/05/09 07:11:24 liuyq Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>

<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>
<jsp:useBean id="bind" class="com.nec.sydney.beans.fcsan.componentconf.BindUnbindConfBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = bind; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<jsp:include page="../../common/wait.jsp" />
<%String capacity=bind.getTrimCapacity();%>
<%if (!bind.isSuccess()){%>
<title><nsgui:message key="fcsan_common/title/page_title_error"/></title>
<%}else{%>
<title><nsgui:message key="fcsan_common/title/title_confirm" /></title>
<%}%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
    <%    if (!bind.isSuccess()){%>
    <script>
        if(window.opener&&!window.opener.closed){
            window.opener.document.forms[0].ok.disabled=false;
            window.opener.document.forms[0].cancel.disabled=false;
        }
    </script>
<body>
<form>
<%=bind.getErrMsg()%>
<center>
<input type="button" name="cancel" value="<nsgui:message key="common/button/close" />" onclick="parent.close();">
</center>
</form>
</body>
<%}else{%>
<script>
function submitForm()
{
    /*if(window.opener&&!window.opener.closed&&window.opener.parent.frames[2]){
    window.opener.document.forms[0].ok.disabled=true;
    window.opener.document.forms[0].cancel.disabled=true;
    }*/
    if(isSubmitted())
    {
        setSubmitted();
        return true;
    }
    return false;
}
function onCancel(){
	if(window.opener&&!window.opener.closed&&window.opener.parent.frames[2]){
		window.opener.document.forms[0].ok.disabled = false;
		window.opener.document.forms[0].cancel.disabled = false;
	}
	window.close();
}
</script>
<body >
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/logicdiskbind/ldbind_title"/></h2>
<%
        String arraytype =  request.getParameter("arraytype") ;
        String raid=request.getParameter("raid");
        String ldnum=request.getParameter("ldnum");
        String ldtype=request.getParameter("ldtype");
        //String ldsize=request.getParameter("ldsize");
        String bltime=request.getParameter("bltime");
        String rankNo=request.getParameter("rankNo");
        String poolName=request.getParameter("poolName");
        String pdnum=request.getParameter("pdnum");
        String diskarrayid=request.getParameter("diskarrayid");
        String diskarrayname=request.getParameter("diskarrayname");
        String WWNN=bind.getWWNNByAid(diskarrayid);
        StringBuffer sb=new StringBuffer((new StringTokenizer(capacity,".")).nextToken());
        for(int j=sb.length()-3;j>0;j=j-3)
            sb.insert(j,",");
        String ldname = null;
        ldname = WWNN + ldnum;
%>
<form method="post" onsubmit="return submitForm()" action="<%=response.encodeURL("../common/fcsanwait.jsp")%>">
<nsgui:message key="fcsan_componentconf/logicdiskbind/confirm_info" />
<br>
<br>
<table border="0">
<tbody align="left">
<tr>
    <th><nsgui:message key="fcsan_componentconf/table/th_dan" /></th>
      <td>:</td>
    <td><%=diskarrayname%></td>
</tr>
</tbody>
</table>
<br>
<table>
<tbody align="left">
<tr>
    <th><nsgui:message key="fcsan_componentconf/table/th_rn" /></th>
      <td>:</td>
    <td><%=poolName+"("+rankNo+")"%></td>
</tr>
<tr>
    <th><nsgui:message key="fcsan_componentconf/table/th_ld_no" /></th>
      <td>:</td>
    <td><%=ldnum%>h</td>
</tr>
<tr>
    <th><nsgui:message key="fcsan_componentconf/table/th_ld_capacity" /></th>
      <td>:</td>
    <td><%=request.getParameter("ldsize")%><nsgui:message key="fcsan_common/label/unit_GB" />&nbsp;(<%=sb.toString()%><nsgui:message key="fcsan_common/label/unit_bytes" />)</td>
</tr>
<%if (bltime != null){%>
<tr>
    <th><nsgui:message key="fcsan_componentconf/table/th_formatting_time" /></th>
      <td>:</td>
    <td><%=bltime%></td>
</tr>
<%} %>
</tbody>
</table>
<br>
<center>
<input type="submit" name="ok" value="<nsgui:message key="fcsan_common/button/button_ok" />" >
<input type="button" name="cancel" value="<nsgui:message key="fcsan_common/button/button_cancel" />" onclick="onCancel()">
</center>
<input type="hidden" name="ldnum" value="<%=ldnum%>">
<input type="hidden" name="ldtype" value="<%=ldtype%>">
<input type="hidden" name="ldsize" value="<%=request.getParameter("ldsize")%>">
<%if (bltime != null){%>
<input type="hidden" name="bltime" value="<%=bltime%>">
<%} %>
<input type="hidden" name="diskarrayid" value="<%=diskarrayid%>">
<input type="hidden" name="rankNo" value="<%=rankNo%>">
<input type="hidden" name="poolName" value="<%=poolName%>">
<input type="hidden" name="pdnum" value="<%=pdnum%>">
<input type="hidden" name="diskarrayname" value="<%=diskarrayname%>">
<input type="hidden" name="arraytype" value="<%=arraytype%>">
<input type="hidden" name="operation" value="bind">
<input type="hidden" name="target_jsp" value="../componentconf/bindunbindresult.jsp">
<input type="hidden" name="ldname" value="<%=ldname%>">
<input type="hidden" name="raid" value="<%=raid%>">

</form>
</body>
<%}%>
</html>
