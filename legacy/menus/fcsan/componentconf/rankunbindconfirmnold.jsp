<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankunbindconfirmnold.jsp,v 1.2303 2005/08/29 08:17:50 huj Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>
<jsp:include page="../../common/wait.jsp" />
<%
String rankno=request.getParameter("rankno");
String pdgroupnumber=request.getParameter("pdgroupnumber");
String diskarrayname=request.getParameter("diskarrayname");
String diskarrayid=request.getParameter("diskarrayid");
String arraytype=request.getParameter("arraytype");
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<title>
<nsgui:message key="fcsan_common/title/title_confirm"/>
</title>
<script language="javaScript">
function onOk()
{
    if(isSubmitted())
    {
        setSubmitted();
        //window.location="<%=response.encodeURL("rankunbindnoldresult.jsp")%>?pdgroupnumber=<%=pdgroupnumber%>&diskarrayname=<%=diskarrayname%>&rankno=<%=rankno%>";
        //modify by maojb on may21 for waiting message
        window.location="<%=response.encodeURL("../common/fcsanwait.jsp")%>?diskarrayid=<%=diskarrayid%>&arraytype=<%=arraytype%>&pdgroupnumber=<%=pdgroupnumber%>&diskarrayname=<%=diskarrayname%>&rankno=<%=rankno%>&target_jsp="+"../componentconf/rankunbindnoldresult.jsp";
    }
    else
    {
        return ;
    }
    
}

function onCancel()
{
    if(window.opener&&!window.opener.closed){
        window.opener.document.forms[0].ok.disabled=false;
        window.opener.document.forms[0].cancel.disabled=false;
    }
    window.close();
}

function defaultFocus()
{
    document.forms[0].cancel.focus();
}
</script>
</head>
<body onLoad="defaultFocus()">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbind/h2_rankunbind"/></h2>
<form method="post">
<%
    String rankNumber[] = new String[1];
    rankNumber[0] = rankno;
%>
<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/rankunbindconfirmnold/confirmmsg",rankNumber)%>

<br>
<br>
<center>
<input type="button" name="ok" value="<nsgui:message key="fcsan_common/button/button_ok" />" onClick="onOk()" >
<input type="button" name="cancel" value="<nsgui:message key="fcsan_common/button/button_cancel" />"   onClick="onCancel()">

</center>
</form>

</body>
</html>
