<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: sparebindshow.jsp,v 1.2302 2005/12/16 06:45:01 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,java.lang.*,java.util.*,com.nec.sydney.framework.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="getpdnubmerBean" class="com.nec.sydney.beans.fcsan.componentconf.SpareBindShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = getpdnubmerBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%String diskarrayname = request.getParameter("diskarrayname");
  String pdgroupnumber = request.getParameter("pdgroupnumber");
  String commandid = request.getParameter("commandid");
  Vector pdnumbers = getpdnubmerBean.getPdnumbers();
  String winname = "";
%>
<html>
<head>
<%if(commandid.equals("bind")){%>
<title><nsgui:message key="fcsan_componentconf/sparebind/title_sb"/></title>
<%winname = "sparebindwin";%>
<%}else{%>
<title><nsgui:message key="fcsan_componentconf/sparebind/title_sub"/></title>
<%winname = "spareunbindwin";%>
<%}%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<script language="JavaScript">
var win
function onOk()
{
        if(document.forms[0].ok.disabled==true)
            return false;
    if("<%=commandid%>"=="bind")
        var msg = "<nsgui:message key="fcsan_componentconf/sparebind/msg_bindconfirm"/>"
    else
        var msg = "<nsgui:message key="fcsan_componentconf/sparebind/msg_unbindconfirm"/>"
    if(confirm(msg + "\n\n"+"<nsgui:message key="fcsan_componentconf/table/th_dan"/>"+" : <%=diskarrayname%>\n"+
               "<nsgui:message key="fcsan_componentconf/table/td_tpd"/>"+" : "
               +document.forms[0].pdnumber.options[document.forms[0].pdnumber.selectedIndex].value)){    
        document.forms[0].ok.disabled=true;
        document.forms[0].cancel.disabled=true;    

            win=window.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?commandid=<%=commandid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&pdnumber="+document.forms[0].pdnumber.options[document.forms[0].pdnumber.selectedIndex].value+"&target_jsp="+document.forms[0].target_jsp.value,"<%=winname%>","toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=200")
                    win.focus();
        }
}
</script>
</head>

<body onload="document.forms[0].ok.focus()">
<form method="post">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<%if(commandid.equals("bind")){%>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/sparebind/h2_optionb"/></h2>
<%}else{%>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/sparebind/h2_optionu"/></h2>
<%}%>
  <table border="0">
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_dan"/></th>
      <td>:</td>
      <td><%=diskarrayname%></td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/td_tpd"/></th>
      <td>:</td>
      <td> 
        <select name="pdnumber">
        <%for(int i=0;i<pdnumbers.size();i++){%>
          <option value="<%=(String)pdnumbers.get(i)%>"><%=(String)pdnumbers.get(i)%></option>
        <%}%>
        </select>
      </td>
    </tr>
  </table> 
  <br>
  <center> 
    <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onClick="onOk()">
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="if(!this.disabled) window.close()">
      <input type="hidden" name="target_jsp" value="../componentconf/sparebind.jsp">
  </center>
</form>
</body>
</html>
