<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraylistmiddle.jsp,v 1.2306 2005/09/27 00:31:32 wangli Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
 
<html>
<%@ page language="java"  import="java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.nsgui.action.base.NSActionUtil" %>
<jsp:useBean id="diskarrayshow" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayFreshBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskarrayshow; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<head>
<script src="../../../menu/nas/common/general.js"></script>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%@ include file="../common/displaycharstylejs.jsp" %>
 <script language=javascript>

 <%boolean isNotNsview = !(NSActionUtil.isNsview(request));%>

 function choose(radio)
 {
    if(radio.checked)
    {
        var message=radio.value.split(' ')
        if(message.length==4)
        {
            document.forms[0].diskid.value=message[0];
            document.forms[0].diskname.value=message[1];
            document.forms[0].observation.value=message[2];
            document.forms[0].arraytype.value=message[3];
            if (parent.frames[2].document.forms[0]) {
                if(document.forms[0].observation.value=="<%=FCSANConstants.FCSAN_STATE_RUNNING%>"){                          
                    parent.frames[2].document.forms[0].constitution.disabled=false;
                    <%if (isNotNsview){%>
                    parent.frames[2].document.forms[0].modifyName.disabled=false;
					<%}%>
                    var intType = parseInt(document.forms[0].arraytype.value,16);
                    //if (intType < 0x50 || intType > 0x6f) {
                    //    parent.frames[2].document.forms[0].modifyPort.disabled=false;
                    //} else {
                        parent.frames[2].document.forms[0].modifyPort.disabled=true;
                    //}                
                }else{
                    <%if (isNotNsview){%>
                    parent.frames[2].document.forms[0].modifyName.disabled=true;
					<%}%>
                    parent.frames[2].document.forms[0].modifyPort.disabled=true;    
                    if (document.forms[0].observation.value=="<%=FCSANConstants.FCSAN_STATE_NO_MONITORING%>") {
                        parent.frames[2].document.forms[0].constitution.disabled=true;
                    } else {
                        parent.frames[2].document.forms[0].constitution.disabled=false;
                    }
                }
            } 
        }
        else
        {
            document.forms[0].diskid.value="";
            document.forms[0].diskname.value="";
        }
    }    
 }
 /*delete on 7/29
 function enablebutton()
 {
     parent.bottomframe.location="<%= response.encodeURL("diskarraylistbottom.jsp")%>";
     parent.topframe.location="<%=response.encodeURL("diskarraylisttop.jsp")%>" ;
 }*/
  </script>


</head>
<body onload="parent.bottomframe.location='<%=response.encodeURL("diskarraylistbottom.jsp")%>';" onResize="resize()"> 
<form>
<%  if(diskarrayshow.getResult()!=0){
      if(diskarrayshow.setSpecialErrMsg()) {
%>
       	<h2 class="title"><%=diskarrayshow.getErrMsg()%></h2> 
<%    }else {
%>
	<h1 class="Error"><nsgui:message key="fcsan_common/specialmessage/msg_getnodisk"/></h1>
	<h2 class="Error"><%=diskarrayshow.getErrMsg()%></h2>
<%
      }
    }else{
    	List diskarray=diskarrayshow.getDiskArrayInfo();
    	//String state;//caoyh 4.15
    	if (diskarray==null||diskarray.size()==0){
    	    out.println(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/diskarray/msg_nodisk"));
    	}else{
%>
        <input type="hidden" name="arraytype" value="<%=((DiskArrayInfo)diskarray.get(0)).getType()%>">
        <input type="hidden" name="diskid" value="<%=((DiskArrayInfo)diskarray.get(0)).getID()%>">
		<input type="hidden" name="diskname" value="<%=((DiskArrayInfo)diskarray.get(0)).getName() %>">
		<input type="hidden" name="observation" value="<%=((DiskArrayInfo)diskarray.get(0)).getObservation()%>">
		<%if(diskarrayshow.getHasSameName()){%>	
		<input type="hidden" name="hassamename" value="true">	
        <%}%>
    		<table border="1" >
		<tr height=20 align="center">
    		<th>&nbsp;</th>
    		<th><nsgui:message key="fcsan_componentdisp/table/table_id"/></th>
    		<th><nsgui:message key="fcsan_componentdisp/table/table_diskarrayname"/></th>
    		<th><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
    		<th><nsgui:message key="fcsan_componentdisp/table/table_observ"/></th>
    		<th><nsgui:message key="fcsan_componentdisp/table/table_wwnn"/></th>
    		</tr>
    
<%

    for(int i=0;i<diskarray.size();i++)
    {
%>
    <tr  align="center">
        <td><input type="radio" name="radio" value="<%=((DiskArrayInfo)diskarray.get(i)).getID()%> <%=((DiskArrayInfo)diskarray.get(i)).getName()%> <%=((DiskArrayInfo)diskarray.get(i)).getObservation()%> <%=((DiskArrayInfo)diskarray.get(i)).getType()%>" <%if(i==0) out.print("checked") ;%> onclick="choose(this)"></td>
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
<%}
}%>
</form>
    
  
</body>
</html>
