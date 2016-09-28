<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldconstitutemiddle.jsp,v 1.2307 2005/12/25 11:16:07 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.atom.admin.*,java.util.*,com.nec.sydney.framework.*,com.nec.sydney.beans.base.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ taglib uri="taglib-sort" prefix="sortTag" %> 
<jsp:useBean id="refreshBean" class="com.nec.sydney.beans.fcsan.componentdisp.LdConstituteRefreshBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = refreshBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@ include file="../common/displaycharstylejs.jsp"%>
<script src="../../../menu/nas/common/general.js"></script>
<%
String diskarrayid  = request.getParameter("diskArrayID");
boolean isBeanSuccess = refreshBean.getSuccess();
String state = "";
String pdGroup = request.getParameter("PDGroup") ;
if(isBeanSuccess && (pdGroup==null))
	state = refreshBean.getDiskArrayMonState(diskarrayid);
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
function setLD(radio)
{
    var ldID;
    var ldName;
    var ldType;
    if (radio.checked)
    {
        var message=radio.value.split(' ');
        document.forms[0].ldID.value = message[0];
        document.forms[0].ldName.value = message[1];
        document.forms[0].ldType.value =message[2];
    }
}

function loadBottomPage()
{
    parent.bottomframe.location="<%=response.encodeURL("ldconstitutebottom.jsp")%>?diskArrayID=<%=diskarrayid%>&diskname=<%=request.getParameter("diskname")%>&monitorstate=<%=state%>";
}
</script>
</head>

<% if (pdGroup==null) { %>
<body onload="loadBottomPage()" onResize="resize()">
<% } else { %>
<body>
<% } %>

<%
if(!isBeanSuccess || state== null)
{
    if(refreshBean.setSpecialErrMsg()) {
        if (pdGroup!=null) { %>
            <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
            <h2 class="popup"><%=refreshBean.getErrMsg()%></h2>
<%      } else { %>
       	    <h2 class="title"><%=refreshBean.getErrMsg()%></h2>
<%      }        
    } else { 
        if (pdGroup!=null) { %>
            <h1 class="popupError"><nsgui:message key="fcsan_componentdisp/lddetail/p_lddetailtop"/></h1>
            <h2 class="popupError"><%=refreshBean.getErrMsg()%></h2>
<%      } else { %>        
            <h1 class="Error"><nsgui:message key="fcsan_componentdisp/lddetail/p_lddetailtop"/></h1>
            <h2 class="Error"><%=refreshBean.getErrMsg()%></h2>
<%      }
    }
}else{
    if (pdGroup!=null) { %>
        <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
        <h2 class="popup"><nsgui:message key="fcsan_componentdisp/pddetail/h3_detail"/></h2>
<%  } 
  
    List ldInfoVec = refreshBean.getLDInfoVec();
    int ldInfoCount=0;
    //--------add by caoyh 4.2
    if (ldInfoVec!=null)
        ldInfoCount = ldInfoVec.size();
    if (ldInfoVec==null||ldInfoCount==0)
    {
        out.println(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/ld/no_logical_disk"));
    }
    else
    {
    //--------
%>

<form  method="post">
<%// added by hujun for sorting State on Sep. 27
    Hashtable stateHash = new Hashtable();
    for (int i=0; i<ldInfoCount; i++) {
            DiskArrayLDInfo info = (DiskArrayLDInfo)ldInfoVec.get(i);
            String cmdState = info.getState();
            stateHash.put(info, cmdState);
            info.setState(NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+cmdState));
    }        

%>

<table border=1>
<%      DiskArrayLDInfo diskArrayLDInfo;
        String ldID;
        String ldName;
        String ldType;

        for (int i=0; i<ldInfoCount; i++)
        {
            if (i%FCSANConstants.LINE6_PER_PAGE == 0) {
%>
<tr>

<% if (pdGroup==null) { %>
<th>&nbsp;</th>
<% } %>

    <%if (i==0){
    Vector values = new Vector();
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_ldnum"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_state"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_raid"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_capacity"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_poolname_no"));
    values.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/table/table_rate"));
    // the names contain the name and it's modifier.and the modifier's first char is uppercase.
    Vector names = new Vector();
    names.add("ldNo String");
    names.add("state String");
    names.add("RAID Integer");
    names.add("capacity Double");
    names.add("poolName String");
    names.add("progression Double");
    String default_sort = "ldNo";
    String reverse = "ascend";
    String sortTarget = request.getRequestURI();
    %>
    <sortTag:sort list="<%=ldInfoVec%>" name="<%=names%>" value="<%=values%>" keyword="<%=default_sort%>" reverse="<%=reverse%>" sortTarget="<%=sortTarget%>" />
<input type="hidden" name="ldID" value="<%=((DiskArrayLDInfo)ldInfoVec.get(0)).getLdNo()%>">
<input type="hidden" name="ldName" value="<%=((DiskArrayLDInfo)ldInfoVec.get(0)).getName()%>">
<input type="hidden" name="ldType" value="<%=((DiskArrayLDInfo)ldInfoVec.get(0)).getType()%>">

<%// added by hujun for sorting State on Sep.27
    for (int j=0; j<ldInfoCount; j++) {
            DiskArrayLDInfo info = (DiskArrayLDInfo) ldInfoVec.get(j);
            info.setState((String) stateHash.get(info));
    }        

%>

        <%}else{%>

<th><nsgui:message key="fcsan_componentdisp/table/table_ldnum"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_raid"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_capacity"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_poolname_no"/></th>
<th><nsgui:message key="fcsan_componentdisp/table/table_rate"/></th>

</tr>
<%        }

    }
            diskArrayLDInfo = (DiskArrayLDInfo)ldInfoVec.get(i);
            ldID = diskArrayLDInfo.getLdNo();
            ldName = diskArrayLDInfo.getName();
            ldType = diskArrayLDInfo.getType();

            String keyState=diskArrayLDInfo.getState();
            String valueState=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+keyState);
%>

<tr align="center">

<% if (pdGroup==null) { %>
<td>
<input type="radio" name="radio" value="<%=ldID%> <%=ldName%> <%=ldType%>" onClick="setLD(this)" <% if(i==0) out.print("checked");%>>
</td>
<% } %>

<td align="right"><%=ldID%></td>
<td align="left">
<script>
var keyState="<%=keyState%>";
var valueState="<%=valueState%>";
display(keyState,valueState)
</script>
</td>
<td align="left" nowrap><%=diskArrayLDInfo.getRAID()%></td>
<td align="right"><%=diskArrayLDInfo.getCapacity()%></td>
<td align="left"><%=diskArrayLDInfo.getPoolName()+"("+diskArrayLDInfo.getPoolNo()+")"%></td>

<%
String progression = diskArrayLDInfo.getProgression();
if (!progression.startsWith("&nbsp;")){
    progression = progression + "%";
}
%>
<td align="right"><%=progression%></td>
</tr>
<%
}//---------------
%>
</table>
</form>
<%}
}//---------
%>
</body>
</html>