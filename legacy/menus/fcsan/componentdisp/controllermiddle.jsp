<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: controllermiddle.jsp,v 1.2303 2005/12/21 01:12:48 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.framework.*,java.util.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="listBean" class="com.nec.sydney.beans.fcsan.componentdisp.ControllerListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = listBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@ include file="../common/displaycharstylejs.jsp"%>
<HTML>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<body>
<%if(listBean.getResult()!=0){
        int errorCode=listBean.getErrorCode();
    if(listBean.setSpecialErrMsg()) {%>
        <h2 class="title"><%=listBean.getErrMsg()%></h2>       
     <%}else {%>
<h1 class="Error"><nsgui:message key="fcsan_componentdisp/controller/get_ctrl_info_failed"/></h1>
<h2 class="Error"><%=listBean.getErrMsg()%></h2>
    <%}%>
<%}else{
    Vector controllers = listBean.getControllers();%>
<table border="1">
  <tr> 
    <th> 
       <nsgui:message key="fcsan_componentdisp/table/table_type"/>
    </th>
    <th> 
    <nsgui:message key="fcsan_componentdisp/table/table_abbrname"/>       
    </th>
    <th> 
       <nsgui:message key="fcsan_componentdisp/table/table_number"/>
    </th>
    <th> 
       <nsgui:message key="fcsan_componentdisp/table/table_state"/>
    </th>
    <th> 
       <nsgui:message key="fcsan_componentdisp/table/table_others"/>
    </th>
  </tr>
<%for(int i=0;i<controllers.size();i++){
  DiskArrayDacInfo dacinfo = (DiskArrayDacInfo)controllers.get(i);%>
  <tr align="center"> 
    <td align="left"><%=dacinfo.getType()%></td>
    <td align="left"><%=dacinfo.getCtlName()%></td>
    <td align="right"><%=dacinfo.getCtlNo()%></td>
    <td align="left"><%String state = dacinfo.getState();
          String valueState = NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+state);%>
     <script language="javaScript">
              display("<%=state%>","<%=valueState%>")
     </script>
    </td>
    <td align="left"><%=dacinfo.getComplement()%></td>
  </tr>
<%}%>
</table>
<%}%>
</body>
</html>
