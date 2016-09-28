<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: rdr_dr4nsview.jsp,v 1.2 2007/05/09 08:23:24 liy Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.rdr_dr.Rdr_drActionConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript">
function onReload() {
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    
    window.location="<html:rewrite page='/changeMode.do?operation=display'/>";
    return true;    
}
</script>
</head>

<body>
    <h1 class="title"><bean:message key="rdr_dr.title.h1.rdr_dr"/></h1>
    <form method="POST">
        <html:button property="reloadBtn" onclick="return onReload();">
            <bean:message key="common.button.reload" bundle="common"/>
        </html:button>
        <br><br>
        
        <!-- mode info table -->
        <h2 class="title"><bean:message key="rdr_dr.title.h2.batteryMode"/></h2>
        <table border=1>
            <tr>
                <th><bean:message key="rdr_dr.info.th.currentMode"/></th>
                <td nowrap>
                    <logic:equal name="currentMode" value="on">
                        <bean:message key="rdr_dr.currentMode.on"/>
                    </logic:equal>
                    <logic:equal name="currentMode" value="off">
                        <bean:message key="rdr_dr.currentMode.off"/>
                    </logic:equal>
                </td>
            </tr>
        </table>
    </form>
</body>
</html:html>