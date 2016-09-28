<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraydetailinfotop.jsp,v 1.2304 2005/12/21 01:21:00 wangli Exp $" -->


<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.fcsan.common.*,java.util.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="diskArrayDetailInfoBean" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayDetailInfoBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskArrayDetailInfoBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@ include file="../common/displaycharstylejs.jsp" %>

<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">


<body>
<%
if(!(diskArrayDetailInfoBean.getSuccess()))
{
    int errorCode=diskArrayDetailInfoBean.getErrorCode();
    if(diskArrayDetailInfoBean.setSpecialErrMsg()) {
%>
        <h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
       	<h2 class="popup"><%=diskArrayDetailInfoBean.getErrMsg()%></h2> 
 <%}else {%>
<h1 class="popupError"><nsgui:message key="fcsan_componentdisp/diskarray_detail/msg_getnodisk_detail"/></h1>
<h2 class="popupError"><%=diskArrayDetailInfoBean.getErrMsg()%></h2>
<%}
}else{
    String keyState=diskArrayDetailInfoBean.getDiskArrayInfo().getState();
    String valueState=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+keyState);
    String monitoringState=diskArrayDetailInfoBean.getDiskArrayInfo().getObservation();
    boolean isNo_monitoring=monitoringState.equals(NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+FCSANConstants.FCSAN_STATE_NO_MONITORING));
%>
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_common/label/h2_aname"/>&nbsp;:&nbsp;<%=diskArrayDetailInfoBean.getDiskArrayInfo().getName()%></h2>
<hr>

<table>
<tr align="left">
<th><nsgui:message key="fcsan_common/label/monitoring"/></th>
<td>:</td>
<td><%=monitoringState%></td>
</tr>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
<td>:</td>
<td>
<%
    if(isNo_monitoring) {
%>
    <%=keyState%>
<%} else {%>
    <script>
        display("<%=keyState%>","<%=valueState%>");
    </script>
<%}%>
</td>
</tr>
</table>

<br>
<%
    if(!isNo_monitoring) {
%>
<h3 class="popup"><nsgui:message key="fcsan_componentdisp/diskarray_detail/h3_component"/></h3>

<table border=1 cols=3 >
<tr>
<th><nsgui:message key="fcsan_componentdisp/table/table_type"/>
</th>
<th><nsgui:message key="fcsan_componentdisp/table/table_state"/>
</th>
<th><nsgui:message key="fcsan_componentdisp/table/table_count"/>
</th>
</tr>
<%
Vector compStates=diskArrayDetailInfoBean.getDiskArrayInfo().getComponentStates();
Vector entryCounts=diskArrayDetailInfoBean.getDiskArrayInfo().getEntryCounts();
Vector compTypes=diskArrayDetailInfoBean.getDiskArrayInfo().getComponentTypes();
int typeCounts=compTypes.size();
for(int i=0;i<typeCounts;i++)
{
    String keyCompState=(String)compStates.get(i);
    String valueCompState;
    valueCompState=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+keyCompState);
%>
<tr align="center">
<td><%=(String)compTypes.get(i)%></td>
<td>
<script>
display("<%=keyCompState%>","<%=valueCompState%>");
</script>
</td>
<td><%=entryCounts.get(i)%></td>
</tr>
<%
}
%>
</table>
<br>
<%}%>
<hr>
<table>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_snumber"/></th>
<td>:</td>
<td><%=diskArrayDetailInfoBean.getDiskArrayInfo().getSerialNo()%></td>
</tr>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_total"/></th>
<td>:</td>
<td><%=diskArrayDetailInfoBean.getDiskArrayInfo().getCapacity()%></td>
</tr>
<%
String pathState1 = diskArrayDetailInfoBean.getDiskArrayInfo().getPathState1();
String pathState2 = diskArrayDetailInfoBean.getDiskArrayInfo().getPathState2();
%>
<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_path1"/></th>
<td>:</td>
<td><%=diskArrayDetailInfoBean.getDiskArrayInfo().getControlPass1()%>
<%if (pathState1.equals("NG")){%>
(<font color="red"><nsgui:message key="fcsan_componentdisp/diskarray_detail/pathappendix"/></font>)
<%}%>
</td>
</tr>

<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_path2"/></th>
<td>:</td>
<td><%=diskArrayDetailInfoBean.getDiskArrayInfo().getControlPass2()%>
<%if (pathState2.equals("NG")){%>
(<font color="red"><nsgui:message key="fcsan_componentdisp/diskarray_detail/pathappendix"/></font>)
 <%}%>
</td>
</tr>

<tr align="left">
<th><nsgui:message key="fcsan_componentdisp/table/table_wwnn"/></th>
<td>:</td>
<td><%=diskArrayDetailInfoBean.getDiskArrayInfo().getWWNN()%></td>
</tr>
</table>

<hr>
<%
}//end of success process
%>

</body>
</html>
