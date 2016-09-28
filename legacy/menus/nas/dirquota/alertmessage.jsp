<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: alertmessage.jsp,v 1.2303 2006/02/20 00:35:05 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="com.nec.sydney.beans.base.*,java.util.*,com.nec.sydney.atom.admin.quota.*,com.nec.sydney.atom.admin.base.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%
  String alertType = request.getParameter("alertType");
  if(alertType == null) alertType = "";
  boolean isNsview = NSActionUtil.isNsview(request);
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<script language=JavaScript>
var loaded = 0;
     function doDisable(){
         loaded = 1;
       <%if(!alertType.equals("dirquota_noexp")){%>
         if(parent.frames[0].document.forms[0]){
            if (parent.frames[0].document.forms[0].datasetlist){
                parent.frames[0].document.forms[0].datasetlist.disabled=true;
            }
            <%if(!isNsview){%>
            if (parent.frames[0].document.forms[0].datasetadd){
                parent.frames[0].document.forms[0].datasetadd.disabled=true;
            }
            if (parent.frames[0].document.forms[0].datasetdel){
                parent.frames[0].document.forms[0].datasetdel.disabled=true;
            }
            <%}%>
         }
         parent.frames[2].location = "datasetbottom.jsp";
       <%}%>
     }
</script>

</head>
<body onLoad="doDisable();">
<%if(alertType != null && alertType.equals("dirquota_noexp"))
{%>
    <h1 class="title"><nsgui:message key="nas_dataset/datasettop/dirquota"/></h1>
<%}else{%>
    <h2 class="title"><nsgui:message key="nas_dataset/datasetmiddle/h2_datasetlist"/></h2>
<%}%>

<%if(alertType != null){
%>
    <% if (alertType.equals("dirquota_nomp")){
    %>
        <nsgui:message key="nas_dataset/alert/msg_nomp"/>
    <%
    }else if(alertType.equals("dirquota_noauth")){
    %>
        <nsgui:message key="nas_dataset/alert/dirquota_nopdc"/>
    <%
    }else if(alertType.equals("dirquota_noexp")){
    %>
        <nsgui:message key="nas_common/mountpoint/msg_no_export_mp"/>
    <%}%>
<%}%>
</body>
</html>

