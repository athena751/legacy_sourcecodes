<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportrootcreateresult.jsp,v 1.8 2005/12/15 01:21:54 xingh Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.framework.*"%>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="exportRootBean" class="com.nec.sydney.beans.exportroot.ExportRootBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = exportRootBean; %>
<% _abstractJSPBean.setRequest(request); %>

<%
String exportGroupName = request.getParameter("exportGroupName");
String codePage = request.getParameter("codePage");
%>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script src="../../common/common.js"></script>

<script language="JavaScript">
    function onAddDomain(){
        window.location = "<%=response.encodeURL("../nas/mapd/userdbdomainconf.jsp?exportGroup=/export/"
                                   + exportGroupName +"&fromWhere=export&dispMode=")%>";
        return false;
    }
    
    function onBack(){
        window.location = "<%=response.encodeURL("../nas/exportroot/exportRoot.jsp")%>";
        return false;
    }
</script>
</HEAD>
<BODY onload="refreshControllerFrame('<%=exportGroupName%>')">
<h1 class="title"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<form  method="post" name="createForm" action="">
    <input type="button" name="btnBack" value="<nsgui:message key="common/button/back"/>" onclick="return onBack();">
<h2 class="title"><nsgui:message key="nas_exportroot/exportroot/h2_create_result"/></h2> 
    
    <table border="1">
        <tr align="center">
            <th align="left"><nsgui:message key="nas_exportroot/exportroot/th_path"/></th>
            <td align="left"><%=exportGroupName%></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_exportroot/exportroot/th_codepage"/></th>
            <td align="left">
            <%=exportRootBean.codepageToDisplay(codePage)%>
            </td>
        </tr>
    </table>
    <br>
    <table border="0">
        <tr>
        <td><nsgui:message key="nas_exportroot/exportroot/domain_notes"/></td>
        </tr>
    </table>
    <br>
    <input type="button" name="btnAddDomain" value="<nsgui:message key="nas_mapd/button/add_dom"/>" onclick="return onAddDomain();">

</form>

</BODY>
</HTML>

