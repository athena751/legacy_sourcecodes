<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: exportrootnfs.jsp,v 1.2303 2004/09/01 07:34:29 xiaocx Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.base.*
                    ,com.nec.sydney.framework.*
                    ,com.nec.nsgui.taglib.nssorttab.*
                    ,java.util.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>

<!-- some other taglib should be specified here -->
<jsp:useBean id="bean" class="com.nec.sydney.beans.exportroot.EGNFSListBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<title><nsgui:message key="nas_exportroot/nfs/h2_exports"/></title>

<%@include file="../../../menu/common/meta.jsp" %>

<script language="JavaScript">
</script>

</head>


<body onload="displayAlert();">
<h1 class="popup"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<h2 class="popup"><nsgui:message key="nas_exportroot/nfs/h2_exports"/>[<%=bean.getMountPoint()%>]</h2>

<form name="ExportsList" method="post" >

<%
    List entryList=bean.getExportList();
    if(entryList==null || entryList.size()==0){
%>
        <br><nsgui:message key="nas_exportroot/exportroot/p_noexports"/>
        <br>
<%
    }else{ 
%>
  <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)entryList)%>" 
                      id="list1"
                      table="border=1" 
                      sortonload="directory:ascend" >
                      
            <nssorttab:column name="directory" 
                              th="STHeaderRender" 
                              td="com.nec.sydney.beans.exportroot.NfsDirTDataRender"
                              sortable="no">
               <nsgui:message key="nas_exportroot/nfs/directory"/>
            </nssorttab:column>
            
            <nssorttab:column name="clientoption" 
                              th="com.nec.sydney.beans.exportroot.NfsClientTHeaderRender" 
                              td="com.nec.sydney.beans.exportroot.NfsClientTDataRender"
                              sortable="no">
                              <nsgui:message key="nas_exportroot/nfs/client"/>,<nsgui:message key="nas_exportroot/nfs/option"/>
            </nssorttab:column>
        </nssorttab:table>
<%}%>
<br>
<hr>
<br>
<center>
    <input type="button" value="<nsgui:message key="common/button/close"/>" onclick="window.close();">
</center>
</form>
</body>
</html>