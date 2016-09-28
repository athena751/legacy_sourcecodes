<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraypdlistmiddle.jsp,v 1.2306 2005/12/26 11:33:45 wangli Exp $" -->

<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.fcsan.common.*,java.lang.*,java.util.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ taglib uri="taglib-sort" prefix="sortTag" %>
<jsp:useBean id="pdlist" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayPDListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = pdlist; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%@ include file="../common/displaycharstylejs.jsp" %>
<script src="../../../menu/nas/common/general.js"></script>

<script language=javascript>
function choose(radio)
{
        if(radio.checked)
        {
                var message=radio.value.split(' ')
                document.forms[0].diskid.value=message[0];
                document.forms[0].pdid.value=message[1];        
        }
}

function init()
{
    parent.bottomframe.location="<%=response.encodeURL("diskarraypdlistbottom.jsp")%>?diskarrayid=<%=request.getParameter("id")%>&diskname=<%=request.getParameter("diskname")%>";
    
}
</script>
</head>
	
<body onload="init()" onResize="resize()">
<form>
<%
if(!(pdlist.getSuccess()))
{
    if(pdlist.setSpecialErrMsg()) {%>
<h2 class="title"><%=pdlist.getErrMsg()%></h2> 
    <%} else {%>
<h1 class="Error"><nsgui:message key="fcsan_componentdisp/pd/msg_getnophysical"/></h1>
<h2 class="Error"><%=pdlist.getErrMsg()%></h2>
<%  }    
} else {
    List pdinfo=pdlist.getPDInfo();
    String state;
    if (pdinfo==null||pdinfo.size()==0){%>
       <nsgui:message key="fcsan_componentdisp/pd/none"/>
        <input type="hidden" name="diskid" value="<%=request.getParameter("id")%>">
    <%} else{
%>

<%// added by hujun for sorting State on Sep. 27
    Hashtable stateHash = new Hashtable();
    for (int i=0; i<pdinfo.size(); i++) {
            DiskArrayPDInfo info = (DiskArrayPDInfo)pdinfo.get(i);
            String cmdState = info.getState();
            stateHash.put(info, cmdState);
            info.setState(NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+cmdState));
    }
%>


<table border="1">
<%
    for (int i=0; i<pdinfo.size(); i++) {
        if (i%FCSANConstants.LINE10_PER_PAGE == 0) {
	        if(i==0) {
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
                names.add("state String");
                names.add("capacity Double");
                names.add("poolName String");
                names.add("pdDivision String");
                names.add("type String");
                names.add("progression String");
                
                String default_sort = "pdNo";
                String reverse = "ascend";
                String sortTarget = request.getRequestURI();
%>
<tr>
<th>&nbsp;</th>
<sortTag:sort list="<%=pdinfo%>" name="<%=names%>" value="<%=values%>" keyword="<%=default_sort%>" reverse="<%=reverse%>" sortTarget="<%=sortTarget%>" />
</tr>
<%// added by hujun for sorting State on Sep.27
    for (int j=0; j<pdinfo.size(); j++) {
            DiskArrayPDInfo info = (DiskArrayPDInfo) pdinfo.get(j);
            info.setState((String) stateHash.get(info));
    }
%>
<input type="hidden" name="diskid" value="<%=request.getParameter("id")%>">
<input type="hidden" name="pdid" value="<%=((DiskArrayPDInfo)pdinfo.get(0)).getPdNo()%>">
<%          } else {
%>
<tr>
<th>&nbsp;</th>
<th><nsgui:message key="fcsan_componentdisp/table/table_physicaldisknumber"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_capacity"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_poolname_no"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_division"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_type"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_rate"/></th>
</tr>
<%      
            }
        }
        state=((DiskArrayPDInfo)pdinfo.get(i)).getState();//caoyh 4.15
%>
    <tr  align="center">
    <td><input type="radio" name="radio" value="<%=request.getParameter("id")%> <%=((DiskArrayPDInfo)pdinfo.get(i)).getPdNo()%>" <%if(i==0) out.print("checked");%> onclick="choose(this)"></td>
    <td align="left"><%=((DiskArrayPDInfo)pdinfo.get(i)).getPdNo()%></td>
    <td align="left"><script language="javascript">display("<%=state%>","<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+state)%>")</script></td>
    <td align="right"><%
        String size=Double.toString((Double.parseDouble(((DiskArrayPDInfo)pdinfo.get(i)).getCapacity())/1024/1024/1024)-0.05);
        size=Double.valueOf(size).doubleValue()<=0.1?"0.1":size;
        out.print(pdlist.GetDouble(size,1));
    %></td>
    <%
        String poolNo = ((DiskArrayPDInfo)pdinfo.get(i)).getPoolNo();
        String poolName = ((DiskArrayPDInfo)pdinfo.get(i)).getPoolName();
        String poolText = poolNo.equals("--") ? "--" : poolName + "(" + poolNo + ")";
    %>
    <td align="left"><%=poolText%></td>
    <td align="left"><%=((DiskArrayPDInfo)pdinfo.get(i)).getPdDivision()%></td>
    <td align="left"><%=((DiskArrayPDInfo)pdinfo.get(i)).getType()%></td>
    <td align="right"><%=((DiskArrayPDInfo)pdinfo.get(i)).getProgression()%></td>
    </tr>
<%
    }
%>
</table>
</form>
<%}%>
<%}%>

</body>
</html>