<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: rankunbindhasvolumeorpaircreating.jsp,v 1.2 2008/12/02 03:39:08 chenb Exp $" -->

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
function onCancel() {
    if(window.opener&&!window.opener.closed){
        window.opener.document.forms[0].ok.disabled=false;
        window.opener.document.forms[0].cancel.disabled=false;
    }
    window.close();
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

function defaultFocus()
{
    document.forms[0].cancel.focus();
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
	String ldnodetail=request.getParameter("ldnodetail");
	String isMultiMachine = request.getParameter("isMultiMachine");
	String hasVolCreatingOnPool = request.getParameter("hasVolCreatingOnPool");
	String hasPairCreatingOnPool = request.getParameter("hasPairCreatingOnPool");
%>
	<form name="pairConfirmForm" method="post" action="<%=response.encodeURL("../common/fcsanwait.jsp")%>">
<%	
    String rankNumber[] = new String[1];
    rankNumber[0] = rankno;	
%>
<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/rankunbindconfirmnold/confirmmsg",rankNumber)%>
<br><br>
  <% if(hasVolCreatingOnPool.equals("true")) {%>
  	<nsgui:message key="fcsan_componentconf/rankunbindalerthavevolumecreating/alertmsg"/>
  <%}else {%>
    <nsgui:message key="fcsan_componentconf/rankunbindalerthavepaircreating/alertmsg"/>
  <%}%>
  <br><br>
  <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg1"/>
  <li>
  	<% if(hasVolCreatingOnPool.equals("true")) {%>  
      <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg3_1a"/>
    <%}else {%>
      <nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/confirmmsg3_1b"/>
    <%}%>
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

  <% if(ldnodetail.equals("")){%>
  	<input type="hidden" name="target_jsp" value="../componentconf/rankunbindnoldresult.jsp">
  <% }else{ %>
  	<input type="hidden" name="ldnodetail" value="<%=ldnodetail%>">
  	<input type="hidden" name="target_jsp" value="../componentconf/rankunbindhaveldresult.jsp">
  <% } %>
  <input type="hidden" name="isMultiMachine" value="<%=isMultiMachine%>">
  <input type="hidden" name="isForce" value="false">
  
<br>
  <center>
    <input type="button" name="forceDel" value="<nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/bnt_del_force" />" onclick="onForceDel()">
    <input type="button" name="cancel" value="<nsgui:message key="fcsan_componentconf/rankunbindconfirmhaveld/bnt_cancel" />"   onClick="onCancel()">  
  </center>
  </form>
</body>

</html>