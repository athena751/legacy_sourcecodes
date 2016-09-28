<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: enclosuremiddle.jsp,v 1.2302 2005/12/21 01:23:40 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.framework.*,com.nec.sydney.atom.admin.base.*,java.util.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="listBean" class="com.nec.sydney.beans.fcsan.componentdisp.EnclosureListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = listBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<HTML>
<HEAD>
<!--TITLE><nsgui:message key="fcsan_ctrlandencl/common/page_title"/></TITLE-->
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
</HEAD>

<body>
<%if(listBean.getResult()!=0){
    int errorCode=listBean.getErrorCode();
        if(listBean.setSpecialErrMsg()) {%>
        <h2 class="title"><%=listBean.getErrMsg()%></h2>       
     <%} else {     %>
<h1 class="Error"><nsgui:message key="fcsan_componentdisp/enclosure/msg_failed"/></h1>
<h2 class="Error"><%=listBean.getErrMsg()%></h2>
        <%}  
    }else{
        Vector enclosures = listBean.getEnclosures();%>
<table border="1" >
  <tr> 
    <th> 
      <nsgui:message key="fcsan_componentdisp/table/table_type"/>
    </th>
    <th> 
      <nsgui:message key="fcsan_componentdisp/table/table_abbrname"/>
    </th>
    <th > 
      <nsgui:message key="fcsan_componentdisp/table/table_number"/>
    </th>
    <th> 
      <nsgui:message key="fcsan_componentdisp/table/table_state"/>
    </th>
  </tr>
<%for(int i=0;i<enclosures.size();i++){
  DiskArrayDeInfo deinfo = (DiskArrayDeInfo)enclosures.get(i);%>
  <tr align="center"> 
    <td  align="left"><%=deinfo.getType()%></td>
    <td  align="left"><%=deinfo.getCtlName()%></td>
    <td  align="right"><%=deinfo.getCtlNo()%></td>
    <td  align="left"><%String state = deinfo.getState();
                      if(!state.equals(FCSANConstants.FCSAN_STATE_REDAY)){%>
                      <font color=RED>
                      <%}else{%>
                      <font color=GREEN>
                     <%}%> <%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+state)%></font>
    </td>
  </tr>
<%}%>
</table>
<%}%>
</body>
</html>
