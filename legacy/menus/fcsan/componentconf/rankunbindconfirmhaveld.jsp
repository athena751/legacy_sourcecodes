<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankunbindconfirmhaveld.jsp,v 1.2306 2008/11/28 02:20:43 chenb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>


<jsp:include page="../../common/wait.jsp" />

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<title>
<nsgui:message key="fcsan_common/title/title_confirm"/>
</title>

<script language="javaScript">
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

function onForceDel()
{
    if(isSubmitted())
    {       
        var confirmAlertMsg = '<nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsgfinal" />';
    	if(!confirm(confirmAlertMsg))
    	{
    		return false;
    	}
    	setSubmitted();
    }
    else
    {
        return false;
    }
    document.forms[0].isForce.value = "true";
    document.forms[0].submit();
}

function onDel()
{
    if(isSubmitted())
    {
        setSubmitted();
    }
    else
    {
        return false;
    }
    document.forms[0].submit();
}
</script>
</head>
<body onLoad="defaultFocus()">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbind/h2_rankunbind"/></h2>


<%

    
    String rankno=request.getParameter("rankno");
    String pdgroupnumber=request.getParameter("pdgroupnumber");
    String diskarrayname=request.getParameter("diskarrayname");
    String diskarrayid=request.getParameter("diskarrayid");
    String arraytype = request.getParameter("arraytype");
    String ldnosummary=request.getParameter("ldnosummary");
    String ldnodetail=request.getParameter("ldnodetail");
    String size=request.getParameter("ldsize");
//modify by maojb and jinkc on 12.18 for LVM bind check
    String isMultiMachine = request.getParameter("isMultiMachine");
%>
    <form name="delForm" method="post" action="<%=response.encodeURL("../common/fcsanwait.jsp")%>">
<%
    String rankNumber[] = new String[2];
    rankNumber[0] = rankno;
    rankNumber[1] = size;
%>
<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/rankunbindconfirmhaveld/rankmsg",rankNumber)%>

<br>
    <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/ldnomsg"/>
    <%=ldnosummary%><br><br>
    <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg1"/>
    <li><nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg2"/>
    <li>
      <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg3_1"/>
      <span class="redmessage">
    	<nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg3_2"/>
      </span>
      )
    </li>
    <li><nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg4"/>
    <input type="hidden" name="rankno" value="<%=rankno%>">
    <input type="hidden" name="pdgroupnumber" value="<%=pdgroupnumber%>">
    <input type="hidden" name="diskarrayname" value="<%=diskarrayname%>">
    <input type="hidden" name="diskarrayid" value="<%=diskarrayid%>">
    <input type="hidden" name="arraytype" value="<%=arraytype%>">
    <input type="hidden" name="ldnodetail" value="<%=ldnodetail%>">
    <input type="hidden" name="target_jsp" value="../componentconf/rankunbindhaveldresult.jsp">
    <input type="hidden" name="isMultiMachine" value="<%=isMultiMachine%>">
    <input type="hidden" name="isForce" value="false">
    <!-- add by maojb on may21 for waiting message-->
<br>
<br>
    <center>
    <input type="button" name="del" value="<nsgui:message key="common/button/delete" />" onclick="onDel()">
    <input type="button" name="forceDel" value="<nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/bnt_del_force" />" onclick="onForceDel()">
    <input type="button" name="cancel" value="<nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/bnt_cancel" />"   onClick="onCancel()">
    </center>
    </form>

</body>
</html>
