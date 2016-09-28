<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpinfo.jsp,v 1.2301 2004/08/31 12:00:14 huj Exp" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="java.util.*,
                 com.nec.sydney.beans.base.*,
                 com.nec.sydney.framework.*,
                 com.nec.sydney.beans.http.*,
                 com.nec.sydney.atom.admin.base.*,
                 com.nec.sydney.atom.admin.http.* " %>
<%@ page import="com.nec.nsgui.model.biz.license.LicenseInfo"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="HTTPInfo" class="com.nec.sydney.beans.http.HTTPInfoBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = HTTPInfo; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<html>
<%LicenseInfo license=LicenseInfo.getInstance();
  int nodeNo = NSActionUtil.getCurrentNodeNo(request);
  if ((license.checkAvailable(nodeNo,"http"))==0){ //no license
%>
    <jsp:forward page='../../../framework/noLicense.do'>
        <jsp:param name="licenseKey" value="http"/>
    </jsp:forward>
<%}else{ //has license %>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<jsp:include page="../../../menu/common/wait.jsp"/>
<title>HTTP Information</title>
<script language="JavaScript" src="../common/general.js">
</script>
<script language="JavaScript">
    

    function onReloadInfo(){
        if(isSubmitted()){
            
            window.location="<%=response.encodeURL("httpinfo_nsview.jsp")%>";
            setSubmitted();
        }
    }
</script>
</head>

<body onload="displayAlert();">
<h1><nsgui:message key="nas_http/common/h1"/></h1>
<%
    HTTPBasicInfo theBasicInfo = HTTPInfo.getBasicInfo();
    HTTPServerInfo theServerInfo = HTTPInfo.getMainServerInfo();
    List theHostInfo = HTTPInfo.getVirtualHostInfo();
%>
<form name="formHTTPInfo" method="post" onSubmit="return false;">

<input type="button" name="reloadBtn" value="<nsgui:message key="nas_ftp/ftp_info/reload"/>" onclick="onReloadInfo()" >


<h2><nsgui:message key="nas_http/basic/h2"/></h2>

<table border="1">
<tr>
    <th align="left"><nsgui:message key="nas_http/basic/th_service"/></th>
    <td><% if (theBasicInfo.getServiceStatus()) { %>
            <nsgui:message key="nas_http/basic/th_use"/>

        <%      if (theBasicInfo.getHttpdStatus()){ %>
                    <nsgui:message key="nas_http/basic/th_start"/>
        <%      }else{%>
                    <nsgui:message key="nas_http/basic/th_stop"/>
        <%
                }
            } else {
        %>
            <nsgui:message key="nas_http/basic/th_unuse"/>
         <%      if (theBasicInfo.getHttpdStatus()){ %>
                    <nsgui:message key="nas_http/basic/th_start"/>
        <%      }else{%>
                    <nsgui:message key="nas_http/basic/th_stop"/>
        <%
                }
         } %>
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/basic/th_port"/></th>
    <td><%= theBasicInfo.getPorts() %></td>
</tr>
</table>
<br>

<h2><nsgui:message key="nas_http/server/h2_main"/></h2>

<table border="1">
<tr>
    <th align="left"><nsgui:message key="nas_http/server/th_document_root"/></th>
    <td><%= theServerInfo.getDocumentRoot().equals("")?"&nbsp;":NSUtil.space2nbsp(theServerInfo.getDocumentRoot())%></td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/server/th_server_admin"/></th>
    <td><%= theServerInfo.getServerAdmin().equals("")?"&nbsp;":theServerInfo.getServerAdmin() %></td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/server/th_user_group"/></th>
    <td><nsgui:message key="nas_http/server/th_unix_user"/>
                <%= NSUtil.space2nbsp(theServerInfo.getUnixUserName()) %>/<%= theServerInfo.getUnixUserID() %><br>
        <nsgui:message key="nas_http/server/th_unix_group"/>
                <%= NSUtil.space2nbsp(theServerInfo.getUnixGroupName()) %>/<%= theServerInfo.getUnixGroupID() %><br>
        <nsgui:message key="nas_http/server/th_windows_user_name"/>
                <%= NSUtil.space2nbsp(theServerInfo.getWindowsUserName()) %><br>
        <nsgui:message key="nas_http/server/th_windows_group_name"/>
                <%= NSUtil.space2nbsp(theServerInfo.getWindowsGroupName()) %>
    </td>
</tr>

<tr>
    <th align="left"><nsgui:message key="nas_http/server/th_errorlog"/></th>
    <td><nsgui:message key="nas_http/server/th_location"/><%= theServerInfo.getErrorLogLocation() %><br>
        <nsgui:message key="nas_http/server/th_level"/><%= theServerInfo.getErrorLogLevel() %>
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/server/th_user_directory_settings"/></th>
    <td><% boolean userDirAllowed = theServerInfo.getUserDirAllowed();
        if (userDirAllowed) {
            String userDirMode = theServerInfo.getUserDirMode() ; %>
            <nsgui:message key="nas_http/server/th_translate"/><br>
            <nsgui:message key="nas_http/server/th_pattern"/><%= NSUtil.space2nbsp(theServerInfo.getUserDirPattern()) %> <br>
            <nsgui:message key="nas_http/server/th_custom"/>
         <% if (userDirMode.equals(HTTPConstants.DIR_ENABLE)) { %>
            <nsgui:message key="nas_http/server/th_enable_all"/>
         <% } else {
                if (userDirMode.equals(HTTPConstants.DIR_ENABLE_ONLY)) { %>
                    <nsgui:message key="nas_http/server/th_enable_only"/>
             <% } else if (userDirMode.equals(HTTPConstants.DIR_DISABLE_ONLY)) { %>
                    <nsgui:message key="nas_http/server/th_disable_only"/>
             <% }
                out.print(NSUtil.space2nbsp(theServerInfo.getUserDirUserList())) ;
            }
        } else { %>
            <nsgui:message key="nas_http/server/th_not_translate"/>
     <% } %>
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/server/th_directrory_setting"/></th>
    <td>
    <%  Map theDirectoryMap = theServerInfo.getDirectoryMap() ;
        Iterator theDirectoryItr = theDirectoryMap.keySet().iterator();
        HTTPDirectoryInfo theDirectory ;
        String theDirAccessMode ;
        String theDirOptions ;
        String theDirHtaccess ;
        while (theDirectoryItr.hasNext()) {
            theDirectory = (HTTPDirectoryInfo)theDirectoryMap.get((String)theDirectoryItr.next()) ;%>
            <%=NSUtil.space2nbsp(theDirectory.getDirectory())%>
            <br>
            &nbsp;&nbsp;<nsgui:message key="nas_http/directory/th_main_access"/>
         <% theDirAccessMode = theDirectory.getDirectoryAccessMode() ;
            if (theDirAccessMode.equals(HTTPConstants.ALL_ALLOW)) { %>
                        <nsgui:message key="nas_http/directory/th_allow_from_all"/><br>
         <% } else {
                if (theDirAccessMode.equals(HTTPConstants.ORDER_ALLOW_DENY)) { %>
                    <nsgui:message key="nas_http/directory/th_order_allow_deny"/><br>
             <% } else if (theDirAccessMode.equals(HTTPConstants.ORDER_DENY_ALLOW)) { %>
                    <nsgui:message key="nas_http/directory/th_order_deny_allow"/><br>
             <% } %>
                &nbsp;&nbsp;&nbsp;&nbsp;<nsgui:message key="nas_http/directory/th_allow_list"/>
                                        <%=theDirectory.getDirectoryAccessAllowList()%><br>
                &nbsp;&nbsp;&nbsp;&nbsp;<nsgui:message key="nas_http/directory/th_deny_list"/>
                                        <%=theDirectory.getDirectoryAccessDenyList()%><br>
         <% }
        }
        if (theDirectoryMap.isEmpty())
            out.print("&nbsp;");
        %>
    </td>
</tr>
</table>
<br>

<h2><nsgui:message key="nas_http/server/h2_virtual"/></h2>
<% if (theHostInfo.size()==0) { %>
    <nsgui:message key="nas_http/alert/no_virtual_host"/><br><br>
<% } %>

<% if (theHostInfo.size()!=0) { %>

<table border="1">
<tr>
    <th><nsgui:message key="nas_http/server/th_virtual_host_name"/></th>
    <th><nsgui:message key="nas_http/server/th_ip_address"/></th>
    <th><nsgui:message key="nas_http/server/th_document_root"/></th>
    <th><nsgui:message key="nas_http/server/th_errorlog_location_level"/></th>
</tr>
    <% for (int i=0; i<theHostInfo.size(); i++) { %>
    <tr>
        <td><%  String virtualHostName = ((HTTPServerInfo)theHostInfo.get(i)).getServerName() ;
            if (virtualHostName.equals("")) {
                out.print("&nbsp;") ;
            } else {
                out.print(virtualHostName) ;
            } %>
        </td>
        <td><%  String usedIPAddrs = ((HTTPServerInfo)theHostInfo.get(i)).getUsedIPAddrs() ;
            if (usedIPAddrs.equals("")) {
                out.print("&nbsp;") ;
            } else {
                out.print(usedIPAddrs) ;
            } %>
        </td>
        <td><%  String documentRoot = ((HTTPServerInfo)theHostInfo.get(i)).getDocumentRoot() ;
            if (documentRoot.equals("")) {
                out.print("&nbsp;") ;
            } else {
                out.print(NSUtil.space2nbsp(documentRoot));
            } %>
        </td>
        <td><%= ((HTTPServerInfo)theHostInfo.get(i)).getErrorLogLocation() %>/
            <%= ((HTTPServerInfo)theHostInfo.get(i)).getErrorLogLevel() %>
        </td>
    </tr>
    <% } %>
</table>

<% } %>

</form>
</body>
<%} //end for has license%>
</html>