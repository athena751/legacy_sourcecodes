<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldmenumiddle.jsp,v 1.4 2005/09/21 04:49:10 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>
<jsp:useBean id="diskarrayshow" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayFreshBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskarrayshow; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<script src="../../../menu/nas/common/general.js"></script>
<%@ include file="../common/displaycharstylejs.jsp" %>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language=javascript>
    function choose(radio) {
        if(radio.checked) {
            if("<%=diskarrayshow.getHasSameName()%>"=="true"){
                return;
            }
            var message=radio.value.split(' ')
            if(message.length==4) {
                document.forms[0].diskarrayid.value=message[0];
                document.forms[0].diskarrayname.value=message[1];
                document.forms[0].arraytype.value=message[2];
                document.forms[0].observation.value=message[3];
            } else {
                document.forms[0].diskarrayid.value="";
                document.forms[0].diskarrayname.value="";
                document.forms[0].arraytype.value="";
                document.forms[0].observation.value="";
            }
            
            /*if diskarray is used by NAS, ldpurpose is disabled,
            else if it is used by iSCSI, the button is enabled.
            the exact usage are not sure, so this button is disabled now.
            */    
            if (parent.frames[2].document.forms[0] 
                    && parent.frames[2].document.forms[0].ldbindunbind) {
                if (document.forms[0].observation.value=="<%=FCSANConstants.FCSAN_STATE_NO_MONITORING%>") {
                    parent.frames[2].document.forms[0].ldbindunbind.disabled=true;
                } else {
                    var intType = parseInt(document.forms[0].arraytype.value,16);
                    //if (intType < 0x50 || intType > 0x6f) {
                    //  parent.frames[2].document.forms[0].ldbindunbind.disabled=true;
                    //} else {
                        parent.frames[2].document.forms[0].ldbindunbind.disabled=false;
                    //}
                }
            }
        }
    }
    
    function loadFrame() {    
        parent.topframe.location="<%=response.encodeURL("ldmenutop.jsp")%>" ;
        parent.bottomframe.location="<%= response.encodeURL("ldmenubottom.jsp")%>";
        
    }
</script>
</head>

<body onload="loadFrame()" onResize="resize()"> 
<form>
<%if(diskarrayshow.getResult()!=0){%>
    <%if(diskarrayshow.setSpecialErrMsg()) {%>
        <h2 class="title"><%=diskarrayshow.getErrMsg()%></h2>       
    <%} else {%>
        <h1 class="Error"><nsgui:message key="fcsan_common/specialmessage/msg_getnodisk"/></h1>
        <h2 class="Error"><%=diskarrayshow.getErrMsg()%></h2>
    <%}%>
<%}else{
    List diskarray=diskarrayshow.getDiskArrayInfo();
    if (diskarray == null || diskarray.size()==0){
    %>
    <nsgui:message key="fcsan_componentconf/confmenu/msg_nodisk"/>
    <%}else{
%>

    <input type="hidden" name="diskarrayid" value="<%=((DiskArrayInfo)diskarray.get(0)).getID()%>">
    <input type="hidden" name="diskarrayname" value="<%=((DiskArrayInfo)diskarray.get(0)).getName() %>">
    <input type="hidden" name="arraytype" value="<%=((DiskArrayInfo)diskarray.get(0)).getType().toLowerCase() %>">
    <input type="hidden" name="observation" value="<%=((DiskArrayInfo)diskarray.get(0)).getObservation()%>">
    <%if(diskarrayshow.getHasSameName()){%>
       <input type="hidden" name="hassamename" value="true"> 
    <%}%>

<table border="1" >
<tr>
    <th>&nbsp;</th>
    <th><nsgui:message key="fcsan_componentconf/table/th_id"/></th>
    <th><nsgui:message key="fcsan_componentconf/table/th_dan"/></th>
    <th><nsgui:message key="fcsan_componentconf/table/th_state"/></th>
    <th><nsgui:message key="fcsan_componentconf/table/th_obs"/></th>
    <th><nsgui:message key="fcsan_componentconf/table/th_wwnn"/></th>
</tr>
    
<%
    for(int i=0; i<diskarray.size();i++)
    {        
%>
    <tr  align="center">
        <td><input type="radio" name="radio" value="<%=((DiskArrayInfo)diskarray.get(i)).getID()%> <%=((DiskArrayInfo)diskarray.get(i)).getName()%> <%=((DiskArrayInfo)diskarray.get(i)).getType().toLowerCase()%> <%=((DiskArrayInfo)diskarray.get(i)).getObservation()%>" <%if(i==0) out.print("checked");%> onclick="choose(this)"></td>
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
}
%>
</form>
</body>
</html>
