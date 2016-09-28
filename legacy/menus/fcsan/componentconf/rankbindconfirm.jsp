<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: rankbindconfirm.jsp,v 1.2303 2005/12/16 06:45:01 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="java.util.*,com.nec.sydney.framework.*,com.nec.sydney.beans.fcsan.common.*" %>
<jsp:include page="../../common/wait.jsp" />
<head>
<title>
<nsgui:message key="fcsan_common/title/title_confirm"/>
</title>
</head>
<script>
function onOk()
{
    if(isSubmitted())
    {
        setSubmitted();
        document.forms[0].submit();
    }
}
function onCancel()
{
    if(window.opener&&!window.opener.closed&&window.opener.parent.frames[1]){
        window.opener.parent.frames[1].document.forms[0].bind.disabled=false;
        window.opener.parent.frames[1].document.forms[0].cancel.disabled=false;
    }
    window.close();
    return;
}

</script>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body>
<% if (((String)session.getAttribute(FCSANConstants.SESSION_RANK_BIND_FROM)).equals("fcsan")){%>
    <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<%}else{%>
    <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_volume"/></h1>
<%}%>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rankbindtop/h2_rankbind"/></h2>
<form name="rbConfirmForm" target="rankbindWin" action="../common/fcsanwait.jsp" method="post">
<% // modified by huj Aug,6%>

<input type="hidden" name="diskarrayname" value="<%=(String)request.getParameter("diskarrayname")%>">
<input type="hidden" name="pdgroupnumber" value="<%=(String)request.getParameter("pdgroupnumber")%>">
<input type="hidden" name="diskarrayid" value="<%=(String)request.getParameter("diskarrayid")%>">
<input type="hidden" name="arraytype" value="<%=(String)request.getParameter("arraytype")%>">
<input type="hidden" name="pdno" value="<%=(String)request.getParameter("pdno")%>">
<input type="hidden" name="rankno" value="<%=(String)request.getParameter("rankno")%>">
<input type="hidden" name="raidtype" value="<%=(String)request.getParameter("raidtype")%>">
<input type="hidden" name="rebuildingtime" value="<%=(String)request.getParameter("rebuildingtime")%>">
<input type="hidden" name="target_jsp" value="<%=(String)request.getParameter("target_jsp")%>">
<nsgui:message key="fcsan_componentconf/rankbindbottom/confirmmsghead"/>
<table>
<br>
<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/table/th_dan"/>
</th>
<td>:
</td>
<td>
<%=request.getParameter("diskarrayname")%>
</td>
</tr>

<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/table/th_rn"/>
</th>
<td>:
</td>
<td>
<%=request.getParameter("rankno")%>h
</td>
</tr>

<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/table/th_pdn"/>
</th>
<td>:
</td>
<td>
<%=request.getParameter("pdno")%>
</td>
</tr>

<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/rankbindbottom/raidtype"/>
</th>
<td>:
</td>
<td>
<%=request.getParameter("raidtype")%>
</td>
</tr>

<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/common/h3_rt"/>
</th>
<td>:
</td>
<td>
<%=request.getParameter("rebuildingtime")%>
</td>
</tr>

</table>
<br>
<center>
<input type="button" name="ok" value="<nsgui:message key="fcsan_common/button/button_ok" />" onClick="onOk()">
<input type="button" name="cancel" value="<nsgui:message key="fcsan_common/button/button_cancel" />" onClick="onCancel()">
</center>
</form>
</body>
</html>
