<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: mountpointForward.jsp,v 1.2300 2003/11/24 00:55:08 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.beans.snapshot.MountPointBean
                            ,com.nec.sydney.beans.base.AbstractJSPBean
                            ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
                            
<jsp:useBean id="mpForward" class="com.nec.sydney.beans.snapshot.MountPointBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = mpForward; %>
<%@include file="../../../menu/common/includeheader.jsp" %> 