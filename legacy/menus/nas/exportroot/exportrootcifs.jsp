<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: exportrootcifs.jsp,v 1.2305 2005/12/14 06:37:05 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.base.*
                    ,com.nec.sydney.framework.*
                    ,com.nec.nsgui.taglib.nssorttab.*
                    ,java.util.*
                    ,java.text.*"%>


<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>

<!-- some other taglib should be specified here -->
<jsp:useBean id="bean" class="com.nec.sydney.beans.exportroot.EGCIFSShareListBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<title><nsgui:message key="nas_cifs/common/h1_cifs"/> <nsgui:message key="nas_cifs/shareslist/h2_sharelist"/></title>

<%@include file="../../../common/head.jsp" %>
<!-- Meta which doesn't included in meta.jsp should be specified here -->

<script language="JavaScript">
</script>

</head>


<body>
<h1 class="popup"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<h2 class="popup"><nsgui:message key="nas_cifs/common/h1_cifs"/>&nbsp;<nsgui:message key="nas_cifs/shareslist/h2_sharelist"/>[<%=bean.getMountPoint()%>]</h2>

<form name="CIFSShareList" method="post" >

        <TABLE border="1">
            <TR>
            <TH><nsgui:message key="nas_cifs/cifsglobalindirect/td_se"/></TH>
            <TD>
            <%String security=bean.getSecurityMode();
              if( security.equals("Domain")){%>
                    <nsgui:message key="nas_exportroot/cifs/option_domain"/>
              <%}else if(security.equals("Share")){%>
                    <nsgui:message key="nas_exportroot/cifs/option_share"/>
              <%}else if(security.equals("ADS")){%>
                    <nsgui:message key="nas_exportroot/cifs/option_ads"/>
              <%}else if(security.equals("NIS")){%>
                    <nsgui:message key="nas_exportroot/cifs/option_nis"/>
              <%}else if(security.equals("Passwd")){%>
                    <nsgui:message key="nas_exportroot/cifs/option_pwd"/>
              <%}else if(security.equals("LDAP")){%>
                    <nsgui:message key="nas_exportroot/cifs/option_ldap"/>
              <%}else{%>
                    <%=security%>
              <%}%>
            </TD>
            </TR>
        </TABLE>
        <br>
<%
    List shareList=bean.getShareList();

    if (shareList == null || shareList.isEmpty()){
%>
        <br><nsgui:message key="nas_cifs/shareslist/info_noshare"/>
        <br>
<%
    } else {
%>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)shareList)%>" id="cifs_shareList"
            table="border=\"1\"" sortonload="shareName">
        <nssorttab:column name="shareName" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="no">
                <nsgui:message key="nas_exportroot/cifs/sharename"/>
        </nssorttab:column>
        <nssorttab:column name="directory" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="no">
                <nsgui:message key="nas_exportroot/cifs/directory"/>
        </nssorttab:column>
        <nssorttab:column name="comment" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="no">
                <nsgui:message key="nas_exportroot/cifs/comment"/>
        </nssorttab:column>
        <nssorttab:column name="logging" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
                                                sortable="no">
                <nsgui:message key="nas_exportroot/cifs/logging"/>
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