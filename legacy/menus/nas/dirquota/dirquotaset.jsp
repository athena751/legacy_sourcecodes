<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: dirquotaset.jsp,v 1.2304 2006/05/16 03:09:41 zhangjun Exp $" -->
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.beans.quota.*,com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="quotaBean" scope="page" class="com.nec.sydney.beans.quota.GetQuotaStatusBean"/>
<%AbstractJSPBean _abstractJSPBean = quotaBean; %>

<%
    String dataset = request.getParameter("dataset");
    String target = (String)session.getAttribute(NasConstants.TARGET);
    String export = (String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT);
    String codepage = APISOAPClient.getCodepage(target, export);
    session.setAttribute(NasSession.SESSION_DIRQUOTA_DATASET,dataset);
    //String dataset_hexValue = NSUtil.str2hStr(dataset,"EUC_JP");
    //String dataset_hexValue = NSUtil.page2Perl(dataset,codepage,NasConstants.CODEPAGE_UTF8);
    String dataset_hexValue = NSActionUtil.page2Perl(dataset,codepage,NasConstants.CODEPAGE_UTF8);
    session.setAttribute(NasSession.SESSION_HEX_DIRQUOTA_DATASET, dataset_hexValue);
    boolean isNsview = NSActionUtil.isNsview(request);
%>

<html> 
<head>
</head> 

<%if(isNsview){%>
<frameset rows="*,50%" >
    <frame name="topframe" src="dirquotasettop.jsp?action=start">
    <frame name="bottomframe" src="dirquotareport.jsp?type=none&keyword=id&reverse=true&commandid=dir&displayControl=all&unit=--&DirQuota=yes">
<%}else{%>
<frameset rows="*,54%" >
    <frame name="topframe" src="dirquotasettop.jsp?action=start">
    <frame name="bottomframe" src="dirquotasetbottom.jsp">
<%}%>
</frameset><noframes></noframes>
</html>