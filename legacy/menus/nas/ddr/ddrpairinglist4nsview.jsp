<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrpairinglist4nsview.jsp,v 1.1 2005/08/29 04:44:57 wangzf Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" 
    import="com.nec.sydney.beans.license.*,
            com.nec.sydney.atom.admin.license.*,
            com.nec.sydney.framework.*,
            com.nec.nsgui.model.biz.license.LicenseInfo,
            com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
</head>
<%  LicenseInfo license=LicenseInfo.getInstance();
    int nodeNo = NSActionUtil.getCurrentNodeNo(request);
    if ((license.checkAvailable(nodeNo,"repctrl"))==0){%>
        <jsp:forward page='../../../framework/noLicense.do'>
            <jsp:param name="licenseKey" value="repctrl"/>
        </jsp:forward>
<%  }else{
    String target = request.getParameter("target");
    target = (target==null)? "" : "?target="+target;%>
        <Frameset rows="90%,*">
            <frame name="topframe" src="ddrpairinglisttop4nsview.jsp<%=target%>">
            <frame name="bottomframe" src="ddrpairinglistbottom4nsview.jsp">
        </Frameset>
<%  }%>
</html>
