<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraywatchmiddle.jsp,v 1.2305 2005/09/21 04:56:42 wangli Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>

<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<html>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*" %>
<jsp:useBean id="diskarrayshow" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayFreshBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskarrayshow; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<script src="../../../menu/nas/common/general.js"></script>
<%@ include file="../common/displaycharstylejs.jsp" %>

<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<!--title><nsgui:message key="fcsan_statemon/common/page_title"/></title-->
<script language="javascript">
    function choose(radio)
    {
        if(radio.checked)
        {
            if("<%=diskarrayshow.getHasSameName()%>"=="true"){
                return;
            }
            var message=radio.value.split(' ');
    
            if(message.length==2) {
                document.forms[0].diskid.value = message[0];
                document.forms[0].observation.value = message[1];
            } else {
                document.forms[0].diskid.value ="";   
                document.forms[0].observation.value = "";
            }
        
            if (parent.frames[2].document.forms[0]) {
                if(message.length==2)
                {
                    parent.frames[2].document.forms[0].diskid.value = document.forms[0].diskid.value;
    
                    if (message[1].toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_RUNNING%>")
                    {
                        parent.frames[2].document.forms[0].start.disabled=true;
                        parent.frames[2].document.forms[0].stop.disabled=false;
                        parent.frames[2].document.forms[0].interrupt.disabled=true;
                    }else if (message[1].toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_STOP%>")
                    {
                        parent.frames[2].document.forms[0].start.disabled=false;
                        parent.frames[2].document.forms[0].stop.disabled=true;
                        parent.frames[2].document.forms[0].interrupt.disabled=true;
                    }else if (message[1].toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_STOP_F%>")
                    {
                        parent.frames[2].document.forms[0].start.disabled=false;
                        parent.frames[2].document.forms[0].stop.disabled=true;
                        parent.frames[2].document.forms[0].interrupt.disabled=true;
                    }else if (message[1].toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_STOP_M%>")
                    {
                        parent.frames[2].document.forms[0].start.disabled=false;
                        parent.frames[2].document.forms[0].stop.disabled=true;
                        parent.frames[2].document.forms[0].interrupt.disabled=true;
                    }else if (message[1].toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_INIT%>")
                    {
                        parent.frames[2].document.forms[0].start.disabled=true;
                        parent.frames[2].document.forms[0].stop.disabled=true;
                        parent.frames[2].document.forms[0].interrupt.disabled=false;
                    }else if (message[1].toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_WAIT%>")
                    {
                        parent.frames[2].document.forms[0].start.disabled=true;
                        parent.frames[2].document.forms[0].stop.disabled=true;
                        parent.frames[2].document.forms[0].interrupt.disabled=false;
                    }
                    else{
                        parent.frames[2].document.forms[0].start.disabled=true;
                        parent.frames[2].document.forms[0].stop.disabled=true;
                        parent.frames[2].document.forms[0].interrupt.disabled=true;
                    }
                }
                else
                {   
                    parent.frames[2].document.forms[0].start.disabled=true;
                    parent.frames[2].document.forms[0].stop.disabled=true;
                    parent.frames[2].document.forms[0].interrupt.disabled=true;
                }
            }
        }    
     }
     function enablebutton()
     {
         parent.topframe.location="<%=response.encodeURL("diskarraywatchtop.jsp")%>";
     }
</script>
</head>
<body onload="enablebutton()" onResize="resize()"> 

<form method="post">
<%if(diskarrayshow.getResult()!=0){
    if(diskarrayshow.setSpecialErrMsg()) {
%>
       	<h2 class="title"><%=diskarrayshow.getErrMsg()%></h2> 
    <%
    } else { 
    %>
<h1 class="Error"><nsgui:message key="fcsan_common/specialmessage/msg_getnodisk"/></h1>
<h2 class="Error"><%=diskarrayshow.getErrMsg()%></h2>

<%  
    }
} else {
    List diskarray=diskarrayshow.getDiskArrayInfo();
    if (diskarray==null||diskarray.size()==0)
    {
        out.println(NSMessageDriver.getInstance().getMessage(session,"fcsan_statemon/diskarraywatchmiddle/msg_noAry"));
    }else{
%>
<input type="hidden" name="success">
<input type="hidden" name="diskid" value="<%=((DiskArrayInfo)diskarray.get(0)).getID()%>" >
<input type="hidden" name="observation" value="<%=((DiskArrayInfo)diskarray.get(0)).getObservation()%>" >
<%if(diskarrayshow.getHasSameName()){%>
        <input type="hidden" name="hassamename" value="true">
<%}%>

<table border="1">
  <tr>
    <th>&nbsp;</th>
    <th ><nsgui:message key="fcsan_statemon/table/table_id"/></th>
    <th><nsgui:message key="fcsan_statemon/table/table_ary_name"/></th>
    <th><nsgui:message key="fcsan_statemon/table/table_state"/></th>
    <th><nsgui:message key="fcsan_statemon/table/table_observation"/></th>
    <th><nsgui:message key="fcsan_statemon/table/table_wwnn"/></th>
  </tr>
<%
    for(int i=0;i<diskarray.size();i++)
    {
%>
    <tr align="center">
        <td><input type="radio" name="radio" <%if(i==0) out.print("checked");%> value="<%=((DiskArrayInfo)diskarray.get(i)).getID()%> <%=((DiskArrayInfo)diskarray.get(i)).getObservation()%>" onclick="choose(this)"></td>
        <td><%=((DiskArrayInfo)diskarray.get(i)).getID()%></td>
        <td><%=((DiskArrayInfo)diskarray.get(i)).getName() %></td>
        <%  String state=((DiskArrayInfo)diskarray.get(i)).getState();
            String observation=((DiskArrayInfo)diskarray.get(i)).getObservation(); %>
        <td>
            <% if (observation.equals(FCSANConstants.FCSAN_STATE_NO_MONITORING)) { %>
                <%= state %>
            <% } else { %>
                <script>display("<%=state%>","<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+state)%>")</script>
            <% } %>
        </td>
        <td><%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+observation)%></td>
        <td><%=((DiskArrayInfo)diskarray.get(i)).getWWNN()%></td>
    </tr>
<%
    }
%>
</table>
    <%
    }
}//else
    %>
    
</form>  
</body>
</html>
