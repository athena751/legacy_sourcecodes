<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ranksparemiddleright.jsp,v 1.2304 2005/09/29 08:14:38 liyb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="PDAndRankListBean" class="com.nec.sydney.beans.fcsan.componentconf.PDAndRankListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=PDAndRankListBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<%PDAndRankListBean.setRankVec();%>
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
function loadBottomframe()
{
    parent.bottomframe.location="<%=response.encodeURL("ranksparebottom.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&pdgroupnumber=<%=pdgroupnumber%>&monitoringstate=<%=monitoringstate%>";
}
</script>
</head>
<body onLoad="loadBottomframe()">
<%
if((PDAndRankListBean.setRankPDVec())==1)
{
%>
    <%if(PDAndRankListBean.setSpecialErrMsg()) {%>
        <h2 class="title"><%=PDAndRankListBean.getErrMsg()%></h2>       
    <%}else{%>
        <h1 class="Error"><nsgui:message key="fcsan_componentconf/ranksparetop/h2_errmsghead"/></h1>
        <h2 class="Error"><%=PDAndRankListBean.getErrMsg()%></h2>
    <%}%>
<%
} else {
    Vector rankStringVec=PDAndRankListBean.getRankStringVec();
    Vector rankStringTipVec=PDAndRankListBean.getRankStringTipVec();
    Vector rankPDStringVec=PDAndRankListBean.getRankPDStringVec();
    int size=rankStringVec.size();
    
%>
<form name="formofmiddleright" method="post">
<%
    String sizeVec[] = new String[1];
    sizeVec[0] = Integer.toString(size);
%>
<h3 class="title"><%=NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/ranksparemiddleright/h3_ranklist",sizeVec)%></h3>
<%
if(size!=0) {
%>
<table>
<tr>

<td>
<table cellspacing="0" cellpadding="0">
<%
for (int i=0;i<size;i++) {
%>
<tr><td><table border=0 cellspacing="3"><tr><td title="<%=((String)(rankStringTipVec.get(i)))%>"><%=((String)(rankStringVec.get(i)))%></td></tr></table></td><td>:</td></tr>

<%
}
%>
</table>
</td>

<td>
<table cellspacing="0" >
<%
String rankPDString;
String rankPDStringOne;
int rankPDSize;
for (int i=0;i<size;i++) {
%>
<tr>
<%
    rankPDString=(String)rankPDStringVec.get(i);
    StringTokenizer st=new StringTokenizer(rankPDString.trim(),":");
    rankPDSize=st.countTokens();
    for(int j=0;j<rankPDSize;j++)
    {
        rankPDStringOne=st.nextToken();
%>
<td><table border="1" cellspacing="0"><tr><td><%=rankPDStringOne%></td></tr></table></td>
<%
    }
%>
</tr>


<%
}
%>
</table>
</td>

</tr>
</table>
<%
}
%>
<input type="hidden" name="rankunbind" value="<%=PDAndRankListBean.getRankunbind()%>" >
<input type="hidden" name="rankexpand2" value="<%=PDAndRankListBean.getRankexpand2()%>" >
<input type="hidden" name="rebuildingtimechange" value="<%=PDAndRankListBean.getRebuildingtimechange()%>" >
<input type="hidden" name="poolnamechange" value="<%=PDAndRankListBean.getPoolnamechange()%>" >
</form>
<%
}
%>

</body>
</html>
