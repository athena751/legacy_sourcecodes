<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ranksparemiddleleft.jsp,v 1.2307 2007/11/14 11:57:56 liq Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
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
int firstDENo = Integer.parseInt(pdgroupnumber,16);
firstDENo = firstDENo*2;
int size=PDStringVec.size();
int loop=size/15; // 15 PDs per line
int position;
%>

<td>
<table cellspacing="0" border=0>
<%
HashMap lineHavePD = new HashMap();
boolean showthisline;
String tmp="";
Hashtable drawThisDe = new Hashtable();
for (int i=0;i<loop;i++)
{
    showthisline = false;
    String hexTHendNo = (Integer.toHexString(firstDENo)+Integer.toHexString(i)).substring(1);
    int pdlinebegin = Integer.parseInt(hexTHendNo,16)*15;
    for (int j=0;j<15;j++){
        tmp = (String)PDStringVec.get(pdlinebegin+j);
        if (!tmp.equals("##")){
            showthisline = true;
            lineHavePD.put(Integer.toHexString(i),Integer.toHexString(i));
            break;
        }
    }
    if (showthisline){
%>
<tr><td>
        <table border=0 cellspacing="2.5">
            <tr><td><%=(Integer.toHexString(firstDENo)+Integer.toHexString(i))%></td></tr>
        </table>
    </td>
</tr>
<%
drawThisDe.put(""+i,"true");
}
}
%>
</table>
</td>

<td>
<table cellspacing="0" border="1" >
<%
String displayValue;
for(int i=0;i<loop;i++)
{
if(drawThisDe.get(""+i)!=null){ 
%>

<tr>
<%
    for(int j=0;j<15;j++)
    {
        position=i*15+j;
        displayValue=(String)(PDStringVec.get(position));
        if(displayValue.equals("##"))
        {
            if (lineHavePD.get(Integer.toHexString(i))!=null){
                displayValue="&nbsp;&nbsp";
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td title="<%=(String)(PDStringTipVec.get(position))%>"><%=displayValue%></td></tr></table></td>
<%
            }
        }
        else
        {
            String bgcolor = (String)(PDColorVec.get(position));
            if (bgcolor.equals("#00FF00")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td title="<%=(String)(PDStringTipVec.get(position))%>" bgcolor=<%=bgcolor%> ><b><%=displayValue%></b></td></tr></table></td>
<%
            } else if(bgcolor.equals("#FFFF33")) {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td title="<%=(String)(PDStringTipVec.get(position))%>" bgcolor=<%=bgcolor%> ><i><%=displayValue%></i></td></tr></table></td>           
<%          } else {
%>
        <td><table border=0 cellspacing="0" cellpadding="2.5"><tr><td title="<%=(String)(PDStringTipVec.get(position))%>" bgcolor=<%=bgcolor%> ><%=displayValue%></td></tr></table></td>                   
<%          }
        }
    }
%>
</tr>
<%
}
}
%>
</table>

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
