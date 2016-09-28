<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankexpandingshow.jsp,v 1.2303 2005/08/29 08:17:50 huj Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,java.lang.*,java.util.*,com.nec.sydney.framework.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="showexpandBean" class="com.nec.sydney.beans.fcsan.componentconf.RankExpandingShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = showexpandBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<title><nsgui:message key="fcsan_componentconf/rankexpandingshow/title_expend"/></title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<% String diskarrayname = request.getParameter("diskarrayname");
    String pdgroupnumber = request.getParameter("pdgroupnumber");
    Vector ranknumbers = showexpandBean.getRanknumbers();
    Vector pdnumbers = showexpandBean.getPdnumbers();
%>
<script language="JavaScript">
    function onOK() {
        if(document.forms[0].ok.disabled==true)
            return false;
        if(confirm("<nsgui:message key="fcsan_componentconf/rankexpandingshow/msg_confirm"/>"+"\n\n"+
                "<nsgui:message key="fcsan_componentconf/table/th_dan"/>"+" : <%=diskarrayname%>\n"+
                "<nsgui:message key="fcsan_componentconf/table/th_pdg"/>"+" : <%=pdgroupnumber%>h\n"+
                "<nsgui:message key="fcsan_componentconf/table/th_rn"/>"+" : "+document.forms[0].exprank.options[document.forms[0].exprank.selectedIndex].value+"\n"+
                "<nsgui:message key="fcsan_componentconf/table/th_pdn"/>"+" : "+document.forms[0].pdnumber.options[document.forms[0].pdnumber.selectedIndex].value+"\n"+
                "<nsgui:message key="fcsan_componentconf/rankexpandingshow/msg_exptime"/>"+" : "+document.forms[0].exptime.options[document.forms[0].exptime.selectedIndex].value)){
            document.forms[0].ok.disabled=true;    
            document.forms[0].cancel.disabled=true;        
            win = window.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&ranknumber="+document.forms[0].exprank.options[document.forms[0].exprank.selectedIndex].value+"&pdnumber="+document.forms[0].pdnumber.options[document.forms[0].pdnumber.selectedIndex].value+"&exptime="+document.forms[0].exptime.options[document.forms[0].exptime.selectedIndex].value+"&target_jsp="+document.forms[0].target_jsp.value,"rankexpanding","toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=200")
            win.focus();
        }
    }
    
    function onCancel() {
        if(document.forms[0].cancel.disabled==true)
            return false;
        window.close()
    }
</script>
</head>
<body onload="document.forms[0].ok.focus()">
<form method="post">
  <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
  <h2 class="popup"><nsgui:message key="fcsan_componentconf/rankexpandingshow/msg_option"/></h2>
  <nsgui:message key="fcsan_componentconf/rankexpandingshow/msg_note"/><br><br>
  <table border="0">
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_dan"/></th>
      <td>:</td>
      <td><%=diskarrayname%></td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_pdg"/></th>
      <td>:</td>
      <td><%=pdgroupnumber%>h</td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_rn"/></th>
      <td>:</td>
      <td> 
        <select name="exprank" size="1">
         <%
          for(int i=0;i<ranknumbers.size();i++){%>
          <option value=<%=(String)ranknumbers.get(i)%>><%=(String)ranknumbers.get(i)%></option>
        <%}%>
        </select>
      </td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_pdn"/></th>
      <td>:</td>
      <td>
        <select name="pdnumber"  size="1">
        <%
          for(int i=0;i<pdnumbers.size();i++){%>
          <option value="<%=(String)pdnumbers.get(i)%>"><%=(String)pdnumbers.get(i)%></option>
        <%}%>
        </select>
      </td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/rankexpandingshow/msg_time"/></th>
      <td>:</td>
      <td>    <select name="exptime" size="1">
      <%for(int i=0;i<=24;i++){%>
      <option value="<%=i%>"><%=i%><%=(i==0)?"("+NSMessageDriver.getInstance() .getMessage(session,"fcsan_componentconf/rankexpandingshow/recommend")+")":""%></option>
      <%}%>
    </select>
  <nsgui:message key="fcsan_componentconf/common/hour"/> 
    </td>
    </tr>
  </table>
  <br>
  <center> 
    <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onClick="onOK()">
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="onCancel()">
    <input type="hidden" name="target_jsp" value="../componentconf/expandrank.jsp">
  </center>
</form>
</body>
</html>



