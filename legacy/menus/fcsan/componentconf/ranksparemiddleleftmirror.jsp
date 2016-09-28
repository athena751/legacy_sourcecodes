<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ranksparemiddleleftmirror.jsp,v 1.2304 2005/08/29 08:17:50 huj Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP" buffer="32kb"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="PDAndRankListBean" class="com.nec.sydney.beans.fcsan.componentconf.PDAndRankListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=PDAndRankListBean;%>
<%
String errorMsg = request.getParameter("errorMsg");
//String errorMsg = new String (errorMsgPre.getBytes(),"EUC-JP");
String specialOrNot = request.getParameter("specialOrNot");
if (errorMsg == null) {
%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<%PDAndRankListBean.setPDVec();%>
<%
}
%>
<%
String diskarrayid=request.getParameter("diskarrayid");
String diskarrayname=request.getParameter("diskarrayname");
String arraytype=request.getParameter("arraytype");
String monitoringstate=request.getParameter("monitoringstate");
String pdgroupnumber=request.getParameter("pdgroupnumber");
String diskmodel=(String)session.getAttribute(FCSANConstants.SESSION_DISK_MODEL);

%>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
function loadMiddlerightframe()
{
    parent.middlerightframe.location="<%=response.encodeURL("ranksparemiddleright.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&pdgroupnumber=<%=pdgroupnumber%>&monitoringstate=<%=monitoringstate%>";
}
</script>
</head>
<%
if (errorMsg != null) {
    errorMsg = new String(errorMsg.getBytes(),"EUC-JP");
%>
<body>
<%
    if (specialOrNot.equals("yes")) {
%>
<h2 class="title"><%=errorMsg%></h2>  
<%
    } else  if (specialOrNot.equals("no1")) {
%>
<h1 class="Error"><nsgui:message key="fcsan_componentconf/ranksparetop/h2_errmsghead"/></h1>
<h2 class="Error"><%=errorMsg%></h2> 
<%
    } else {
%>
<h1 class="Error"><nsgui:message key="fcsan_componentconf/ranksparetop/h2_refresherrmsghead"/></h1>
<h2 class="Error"><%=errorMsg%></h2> 
<%
    }
%>
</body>
<%
} else {
%>
<body onLoad="loadMiddlerightframe()">
<form name="formofmiddleleft" method="post">
<%
    String pdn[] = new String[1];
    pdn[0] = PDAndRankListBean.getPdgroupnumber();
%>
<h3 class="title"><%=NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/ranksparemiddleleft/h3_pdlist",pdn)%></h3>

<table>
  <tr>
    <td> 
      (<nsgui:message key="fcsan_componentconf/common/legend" />&nbsp;&nbsp;
    </td>
    <td> 
      <table border="1" cellspacing="0" cellpadding="0">
        <tr><td bgcolor="#00FF00" width=20>&nbsp;</td></tr></table>
    </td>
    <td>:</td>
    <td><b><nsgui:message key="fcsan_componentconf/table/th_rank"/></b></td>
    <td> 
      <table border="1" cellspacing="0" cellpadding="0">
        <tr><td bgcolor="#FFFFFF" width=20>&nbsp;</td></tr></table></td>
    <td>:</td>
    <td><nsgui:message key="fcsan_componentconf/ranksparemiddleleft/unused"/></td>
    <td> 
      <table border="1" cellspacing="0" cellpadding="0">
        <tr><td bgcolor="#FFFF33" width=20>&nbsp;</td></tr></table></td>
    <td>:</td>
    <td><i><nsgui:message key="fcsan_componentconf/ranksparemiddleleft/spare"/></i>)</td>
</tr></table>

<table cellspacing="0" cellpadding="0">
<tr>

<%
Vector PDStringVec=PDAndRankListBean.getPDStringVec();
Vector PDStringTipVec=PDAndRankListBean.getPDStringTipVec();
Vector PDColorVec=PDAndRankListBean.getPDColorVec();
int size=PDStringVec.size();

int leftend = 0;
int rightend = 0;
String pdno;
int pdintValue;
int firstFCNo = 0;
String displayValue;

for (int i=0;i<size;i++){
    pdno = (String)PDStringVec.get(i);
    if (pdno!=null&&!pdno.equals("##")){
        pdintValue = Integer.parseInt(pdno,16);
        if (pdintValue<0x80){
            leftend = Integer.parseInt(pdno.substring(0,1));
        } else {
            break;
        }
    } else{
        continue;
    }
}
rightend = (size-120)/15-1;
firstFCNo = Integer.parseInt(pdgroupnumber)*2;
%>
<td valign="top">
<table>
<tr>
<td>
<nsgui:message key="fcsan_componentconf/ranksparemiddleleft/fc_loop0"/>
</td>
</tr>
</table>
<%
for (int i=0;i<=leftend;i++){
    String DENo = Integer.toHexString(firstFCNo)+Integer.toHexString(i);
%>
<table cellspacing="0" cellpadding="0">

<tr>
<td rowspan="2"><%=DENo%></td>
<td>
<table border="1" cellspacing="0"><tr>
<%
  for (int j=i*15;j<i*15+8;j++){
  displayValue=(String)(PDStringVec.get(j));
        if(displayValue.equals("##"))
        {
            displayValue="&nbsp;&nbsp;&nbsp;";
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>"><%=displayValue%></td></tr></table></td>
<%
        }
        else
        {
            String bgcolor = (String)(PDColorVec.get(j));
            if (bgcolor.equals("#00FF00")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><b><%=displayValue%></b></td></tr></table></td>
<%
            } else if(bgcolor.equals("#FFFF33")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><i><%=displayValue%></i></td></tr></table></td>           
<%          } else {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><%=displayValue%></td></tr></table></td>                   
<%          }
        }
  }
%>
</tr></table>
</td>
</tr>
<tr>
<td>
<table border="1" cellspacing="0"><tr>
<%
  for (int j=i*15+8;j<i*15+15;j++){
  displayValue=(String)(PDStringVec.get(j));
        if(displayValue.equals("##"))
        {
            displayValue="&nbsp;&nbsp;&nbsp;";
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>"><%=displayValue%></td></tr></table></td>
<%
        }
        else
        {
            String bgcolor = (String)(PDColorVec.get(j));
            if (bgcolor.equals("#00FF00")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><b><%=displayValue%></b></td></tr></table></td>
<%
            } else if(bgcolor.equals("#FFFF33")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><i><%=displayValue%></i></td></tr></table></td>           
<%          } else {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><%=displayValue%></td></tr></table></td>                   
<%          }
        }
  }
%>
</tr></table>
</td>
</tr>
</table>
<%}%>
</td>
<td>&nbsp;&nbsp;</td>
<td valign="top">
<table>
<tr>
<td>
<nsgui:message key="fcsan_componentconf/ranksparemiddleleft/fc_loop1"/>
</td>
</tr>
</table>
<%
for (int i=0; i<=rightend; i++){
    String DENo = Integer.toHexString(firstFCNo+1)+Integer.toHexString(i);
%>
<table cellspacing="0" cellpadding="0">
<tr>
<td rowspan="2"><%=DENo%></td>
<td>
<table cellspacing="0" border="1"><tr>
<%
  for (int j=i*15+120;j<i*15+128;j++){
  displayValue=(String)(PDStringVec.get(j));
        if(displayValue.equals("##"))
        {
            displayValue="&nbsp;&nbsp;&nbsp;";
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>"><%=displayValue%></td></tr></table></td>
<%
        }
        else
        {
            String bgcolor = (String)(PDColorVec.get(j));
            if (bgcolor.equals("#00FF00")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><b><%=displayValue%></b></td></tr></table></td>
<%
            } else if(bgcolor.equals("#FFFF33")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><i><%=displayValue%></i></td></tr></table></td>           
<%          } else {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><%=displayValue%></td></tr></table></td>                   
<%          }
        }
  }
%>
</tr></table>
</td>
</tr>
<tr>
<td>
<table cellspacing="0" border="1"><tr>
<%
  for (int j=i*15+128;j<i*15+135;j++){
  displayValue=(String)(PDStringVec.get(j));
        if(displayValue.equals("##"))
        {
            displayValue="&nbsp;&nbsp;&nbsp;";
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>"><%=displayValue%></td></tr></table></td>
<%
        }
        else
        {
            String bgcolor = (String)(PDColorVec.get(j));
            if (bgcolor.equals("#00FF00")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><b><%=displayValue%></b></td></tr></table></td>
<%
            } else if(bgcolor.equals("#FFFF33")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><i><%=displayValue%></i></td></tr></table></td>           
<%          } else {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td width="17" title="<%=(String)(PDStringTipVec.get(j))%>" bgcolor=<%=bgcolor%> ><%=displayValue%></td></tr></table></td>                   
<%          }
        }
  }
%>
</tr></table>
</td>
</tr>
</table>
<%}%>
</td>
</tr>
</table>

<input type="hidden" name="rankbind" value="<%=PDAndRankListBean.getRankbind()%>" >
<input type="hidden" name="rankexpand1" value="<%=PDAndRankListBean.getRankexpand1()%>" >
<input type="hidden" name="sparebind" value="<%=PDAndRankListBean.getSparebind()%>" >
<input type="hidden" name="spareunbind" value="<%=PDAndRankListBean.getSpareunbind()%>">
</form>

</body>
<%
}
%>
</html>
