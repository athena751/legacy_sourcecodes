<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrscheduleforward.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page import="java.util.*,
        com.nec.sydney.atom.admin.base.*,
        com.nec.sydney.beans.base.*,
        com.nec.sydney.beans.ddr.*,
        com.nec.sydney.framework.*"%>
<jsp:useBean id="ddrSchAdd" class="com.nec.sydney.beans.ddr.DdrScheduleAddBean" scope="page"/>

<%AbstractJSPBean _abstractJSPBean = ddrSchAdd; %>
<jsp:setProperty name="ddrSchAdd" property="*"/>
<%@include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<%String act = ddrSchAdd.getOperation();%>
<%if(ddrSchAdd.isSuccess()){%>
    <script language="JavaScript">
    if(parent.opener){
        if(parent.opener.singleaddexists){
            //single schedule add
            parent.opener.location
                ="ddrschedulelist.jsp?mvName=<%=request.getParameter("mvName")%>&rvName=<%=request.getParameter("rvName")%>";
        }else if(parent.opener.multiaddexists){
            //multi schedule add
            parent.opener.parent.location="ddrpairinglist.jsp";
        }
    }
    parent.close();
    </script>
<%}else{//add error
    if(act.equals("singleAdd")){%>
	<jsp:forward page="ddrsinglescheduleadd.jsp" />
    <%}else{%>
	<jsp:forward page="ddrmultischeduleaddbottom.jsp" />	
    <%}
}%>
</head>
<body>
</body>
</html>


