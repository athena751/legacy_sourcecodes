<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: lddetailtop.jsp,v 1.2306 2005/12/21 01:26:32 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.framework.*,java.util.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ taglib uri="taglib-sort" prefix="sortTag" %> 

<jsp:useBean id="LDDetailBean" class="com.nec.sydney.beans.fcsan.componentdisp.LdDetailBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = LDDetailBean; %>
<%@ include file="../../common/includeheader.jsp" %>
<%@ include file="../common/displaycharstylejs.jsp"%>

<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<body>
<form>
<%
if(!(LDDetailBean.getSuccess()))
{
    if(LDDetailBean.setSpecialErrMsg()) {
%>
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>       
<h2 class="popup"><%=LDDetailBean.getErrMsg()%></h2> 
 <%} else { 
%>
<h1 class="popupError"><nsgui:message key="fcsan_componentdisp/lddetail/p_lddetailtop"/></h1>
<h2 class="popupError"><%=LDDetailBean.getErrMsg()%></h2>
<%    }
} else {
    String keyState=LDDetailBean.getDiskArrayLDInfo().getState();
    String valueState=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+keyState);
%>
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentdisp/lddetail/page_title"/></h2>

<hr>

<table>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_ldnum"/></th>
<td>:</td>
<td><%=LDDetailBean.getDiskArrayLDInfo().getLdNo()%></td>
</tr>
</table>

<hr>

<table>

<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
<td>:</td>
<td>
<script>
display("<%=keyState%>","<%=valueState%>")
</script>
</td>
</tr>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_raid"/></th>
<td>:</td>
<td><%=LDDetailBean.getDiskArrayLDInfo().getRAID()%></td>
</tr>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_capa"/></th>
<td>:</td>
<td><%=LDDetailBean.getDiskArrayLDInfo().getCapacity()%></td>
</tr>
<tr  align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_poolname_no"/></th>
<td>:</td>
<td><%=LDDetailBean.getDiskArrayLDInfo().getPoolName()+"("+LDDetailBean.getDiskArrayLDInfo().getPoolNo()+")"%></td>
</tr>
<tr  align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_rate"/></th>
<td>:</td>
<td><%=LDDetailBean.getDiskArrayLDInfo().getProgression()%></td>
</tr>

</table>

<hr>

<h3 class="popup"><nsgui:message key="fcsan_componentdisp/lddetail/th_physicaldisklist"/></h3>
<%
    int count=0;
    List PDVec = LDDetailBean.getPDVec();
    if (PDVec!=null)
        count=PDVec.size();
    if (PDVec==null||count==0)
    {
        out.println(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/lddetail/no_physical_disk")); 
    }else{
%>
<table border=1 >
<tr>
    <%
    Vector values = new Vector();
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_physicaldisknumber"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_state"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_capacity"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_poolname_no"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_division"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_type"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_rate"));
    Vector names = new Vector();
    names.add("pdNo String");
    names.add(null);
    names.add(null);
    names.add(null);
    names.add(null);
    names.add(null);
    names.add(null);
    String default_sort = "pdNo";
    String reverse = "ascend";
    String sortTarget = request.getRequestURI();
    %>
    <sortTag:sort list="<%=PDVec%>" name="<%=names%>" value="<%=values%>" sortTarget="<%=sortTarget%>" keyword="<%=default_sort%>" reverse="<%=reverse%>"/>

 <!--
<th><nsgui:message key="fcsan_componentdisp/table/table_physicaldisknumber"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_capacity"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_rank"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_division"/></th>
-->
</tr>
<%
    
    for (int i=0;i<count;i++)
    {
        DiskArrayPDInfo diskArrayPDInfo=(DiskArrayPDInfo)PDVec.get(i);
        String keyPDState=diskArrayPDInfo.getState();
        String valuePDState=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+keyPDState);
%>
<tr align="center">
<td align="left"><%=diskArrayPDInfo.getPdNo()%></td>
<td align="left">
<script>
display("<%=keyPDState%>","<%=valuePDState%>")
</script>
</td>
<td align="right"><%=diskArrayPDInfo.getCapacity()%></td>
<td align="left"><%=diskArrayPDInfo.getPoolName()+"("+diskArrayPDInfo.getPoolNo()+")"%></td>
<td align="left"><%=diskArrayPDInfo.getPdDivision()%></td>
<td align="left"><%=diskArrayPDInfo.getType()%></td>
<td align="right"><%=diskArrayPDInfo.getProgression()%></td>
</tr>
<%
    }
%>
</table>
<%
    }//end of else
}
%>

</form>


</body>
</html>