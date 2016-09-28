<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMManageShow.jsp,v 1.2309 2007/08/23 06:54:23 xingyh Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.beans.base.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="manage" class="com.nec.sydney.beans.lvm.LVMManageShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = manage; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@ include file="../../../menu/common/fornashead.jsp" %>
<%@ page import="com.nec.sydney.framework.*,java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
boolean isCluster = manage.getIsCluster();
String lvname = manage.getLvname();
String disks = manage.getDisks();
String size= manage.getSize();
String storage= manage.getLunStorage();
%>

<html>
<head>
<title>Manage Logical Volume</title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="Javascript">
function confirmManage(form) {
    var conmsg= "<nsgui:message key="common/confirm"/>"
	         + "\r\n"
    		 + "<nsgui:message key="common/confirm/act"/>"
    		 + "<nsgui:message key="nas_lvm/lvmlist/btn_manage"/>"
    		 + "\r\n"
    		 + "<nsgui:message key="nas_lvm/lvmlist/td_Name"/>"
    		 + " : " + "<%=lvname%>"
    		 + "\r\n";
    if (isSubmitted()&& confirm(conmsg)){
     	setSubmitted();
     	lockMenu();
     	form.submit();
        disableButtonAll();        
        return false;
    }
    return false;

}

function cancel(){
    if("<%=isCluster%>"=="true"){
        window.location="<%=response.encodeURL("LVMList.jsp")%>?cluster=true";
    }else{
        window.location="<%=response.encodeURL("LVMList.jsp")%>?cluster=false";
    }
    lockMenu();
    disableButtonAll();  
}

</script>
<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" />
</head>
<body onUnload="unLockMenu()">
<h1 class="title"><nsgui:message key="nas_lvm/common/h1_lvm"/></h1>
<form name="lvmform" method="post" action="<%=response.encodeURL("LVMManage.jsp")%>" onsubmit="return false;">
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="cancel()">
<h2 class="title"><nsgui:message key="nas_lvm/lvmManageShow/h2"/></h2>

<% if (isCluster && !manage.is1Node()) { %>
<table border="1">
   <tr>
      <th align="left" valign="top" rowspan="2"><nsgui:message key="nas_lvm/LVMCreateShow/th_node"/></th>
      <td nowrap><input type="radio" name="activeNode" id="activeNodeID1" value="0" checked ><label for="activeNodeID1"><nsgui:message key="nas_lvm/common/node0"/></label></td>
   </tr>
   <tr>
      <td nowrap><input type="radio" name="activeNode" id="activeNodeID2" value="1" ><label for="activeNodeID2"><nsgui:message key="nas_lvm/common/node1"/></label></td>
   </tr>
</table>
<br>
<% } %>
  <table border="1">
    <tr>
      <th align="left"><nsgui:message key="nas_lvm/lvmlist/td_Name"/></th>
      <td colspan=2 ><%=lvname%></td>
    </tr> 
    <% if(isNasHead.booleanValue()){%>
    <tr>
      <th valign="top" nowrap><nsgui:message key="nas_lvm/lvmlist/td_lun_storage"/></th>
      <td align="left"><%=storage%></td>
    </tr>
    <%}else{%>
    <tr>
      <th valign="top" align="left"><nsgui:message key="nas_lvm/lvmlist/th_Disk"/></th>
      <td><%=disks%></td>
    </tr>  
    <%}%>
    <tr>
      <th align="left"><nsgui:message key="nas_lvm/lvmlist/td_Size"/></th>
      <td colspan=2 ><%=(new DecimalFormat("#,##0.0")).format(new Double(size))%></td>
    </tr>
  </table>
  <br>
<hr>
  <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>"  onclick="confirmManage(lvmform)">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="hidden" name="iscluster" value="<%=isCluster%>">
  <input type="hidden" name="lvname" value="<%=lvname%>">
  <input type="hidden" name="disks" value="<%=disks%>">
  <input type="hidden" name="alertFlag" value="enable">
</form>
</body>
</html>
