<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: fcsanwaitwithheartbeat.jsp,v 1.1 2005/09/28 01:01:11 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="java.util.*,com.nec.sydney.framework.*" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script>
var heartBeatWin;
function submitForm()
{
    //document.forms[0].action=document.forms[0].target_jsp.value;
    heartbeatWin = openHeartBeatWin();
    document.forms[0].submit();
}
</script>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<title><nsgui:message key="fcsan_common/title/wait"/></title>
<body onload="submitForm()" onUnload="closePopupWin(heartbeatWin);">
<h1 class="popup"><nsgui:message key="fcsan_common/specialmessage/wait"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_common/specialmessage/msg_wait"/></h2>
<form method="post" action="<%=request.getParameter("target_jsp")%>">
<%
Enumeration e=request.getParameterNames();
while (e!=null&&e.hasMoreElements()) 
{
    String name=(String)e.nextElement();
    String [] params;
    params = request.getParameterValues(name);
    for (int i = 0; i<params.length; i++) {
        out.println("<input type=\"hidden\" name=\""+name+"\" value=\""+params[i]+"\">");
    }
}
%>

</form>
</body>
</html>
