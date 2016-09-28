<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraypddetailtop.jsp,v 1.2307 2005/12/21 01:22:35 wangli Exp $" -->

<html>

<%@ taglib uri="taglib-sort" prefix="sortTag" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="pddetail " class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayPDDetailBean" scope="page"/>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.framework.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*"%>
<% AbstractJSPBean _abstractJSPBean = pddetail; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%@ include file="../common/displaycharstylejs.jsp" %>

<body>
<form>
<%
if(!(pddetail.getSuccess()))
{
    int errorCode=pddetail.getErrorCode();
    if(pddetail.setSpecialErrMsg()) {%>
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><%=pddetail.getErrMsg()%></h2>       
    <%} else {%>
<h1 class="popupError"><nsgui:message key="fcsan_componentdisp/pd/msg_getnophysical"/></h1>
<h2 class="popupError"><%=pddetail.getErrMsg()%></h2>
    <%}
} else if (((DiskArrayPDInfo)pddetail.getPDInfo()).getPdNo().equals("")){%>
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentdisp/pd/msg_getnophysical"/></h2>
<%}else{
    List LDList=pddetail.getLDList();
    DiskArrayPDInfo pdinfo=(DiskArrayPDInfo)pddetail.getPDInfo();
%> 
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentdisp/pddetail/page_title"/></h2>
<hr>
<table border="0">
  <tr align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_physicaldisknumber"/></th>
    <td>:</td>
    <td><%=pdinfo.getPdNo()%></td>
  </tr>
  <tr align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
    <td>:</td>
    <td><script language=javascript>
    display("<%=pdinfo.getState()%>","<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+pdinfo.getState())%>")
    </script></td>
  </tr>
  <tr align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_capa"/></th>
    <td>:</td>
    <td>
    <%
    out.print(pddetail.GetDouble(pdinfo.getCapacity(),0));
    %>&nbsp;<nsgui:message key="fcsan_common/label/unit_bytes"/></td>
  </tr>
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_rpm"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getSpinNumber()%>rpm</td>
  </tr>
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_type"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getType()%></td>
  </tr> 
</table>
<hr>
<table border="0" >
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_pid"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getProductID()%></td>
  </tr>
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_rev_pd"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getProductRevision()%></td>
  </tr>
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_snumber"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getSerialNo()%></td>
  </tr>
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_poolname_no"/></th>
    <td>:</td>
    <% String poolName = ((DiskArrayPDInfo)pdinfo).getPoolName();
       String poolNo   = ((DiskArrayPDInfo)pdinfo).getPoolNo(); 
       String poolText = poolNo.equals("--") ? "--" : poolName + "(" + poolNo + ")";
    %>
    <td><%=poolText%></td>
  </tr>
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_division"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getPdDivision()%></td>
  </tr>  
  <tr  align="left">
    <th><nsgui:message key="fcsan_componentdisp/table/table_rate"/></th>
    <td>:</td>
    <td><%=((DiskArrayPDInfo)pdinfo).getProgression()%></td>
  </tr>  
</table>

<h3 class="popup"><nsgui:message key="fcsan_componentdisp/pddetail/h3_detail"/>:</h3>
<%
    if (LDList==null||LDList.size()==0)
    {
        out.println(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/ld/no_logical_disk"));
    }else{
%>
<%// added by hujun for sorting State on Sep. 27
    Hashtable stateHash = new Hashtable();
    for (int i=0; i<LDList.size(); i++) {
            DiskArrayLDInfo info = (DiskArrayLDInfo)LDList.get(i);
            String cmdState = info.getState();
            stateHash.put(info, cmdState);
            info.setState(NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+cmdState));
    }
%>
<table border="1">
  <tr align="center"> 
<%      Vector values = new Vector();
        values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_ldnum"));
        values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_state"));
        values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_raid"));
        values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_capacity"));
        values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_rate"));

        Vector names = new Vector();
        names.add("ldNo String");
        names.add("state String");
        names.add("RAID Integer");
        names.add("capacity Double");
        names.add("progression Double");
                
        String default_sort = "ldNo";
        String reverse = "ascend";
        String sortTarget = request.getRequestURI();
%>
    <sortTag:sort list="<%=LDList%>" name="<%=names%>" value="<%=values%>" keyword="<%=default_sort%>" reverse="<%=reverse%>" sortTarget="<%=sortTarget%>" />

<%// added by hujun for sorting State on Sep.27
    for (int i=0; i<LDList.size(); i++) {
            DiskArrayLDInfo info = (DiskArrayLDInfo) LDList.get(i);
            info.setState((String) stateHash.get(info));
    }
%>
  </tr>
  <%
    String state;
    for(int i=0;i<LDList.size();i++)
    {
        state=((DiskArrayLDInfo)LDList.get(i)).getState();
  %>
  <tr align="center">
    <td align="right"><%=((DiskArrayLDInfo)LDList.get(i)).getLdNo()%></td>
    <td align="left">
      <script language=javascript>
      display("<%=state%>","<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+state)%>")
      </script>
   </td>
    <td align="left"><%=((DiskArrayLDInfo)LDList.get(i)).getRAID()%></td>
    <td align="right"><%=((DiskArrayLDInfo)LDList.get(i)).getCapacity()%></td>

<%
String progression = ((DiskArrayLDInfo)LDList.get(i)).getProgression();
if (!progression.startsWith("&nbsp;")){
    progression = progression + "%";
}
%>
    <td align="right"><%=progression%></td>
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
