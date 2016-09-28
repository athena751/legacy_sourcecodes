<!--
        Copyright (c) 2004-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: rdr_drchangemode.jsp,v 1.4 2007/05/09 08:23:24 liy Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.rdr_dr.Rdr_drActionConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld"  prefix="displayerror"%>

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

function onChangeMode() {
    if (isSubmitted()) {
        return false;
    }
    
    if (confirm("<bean:message key="rdr_dr.changeMode.confirm"/>" + "\r\n\r\n"
                + "<bean:message key="common.confirm" bundle="common" />")){
        setSubmitted();
        <logic:equal name="currentMode" value="on">
            window.location="<html:rewrite page='/changeMode.do?operation=changeMode&nextMode=off'/>";
        </logic:equal>
        <logic:equal name="currentMode" value="off">
            window.location="<html:rewrite page='/changeMode.do?operation=changeMode&nextMode=on'/>";
        </logic:equal>
        return true;
    }
    return false;  
}
</script>
</head>
<body onLoad="displayAlert();" onUnload="closeDetailErrorWin();">
    <h1 class="title"><bean:message key="rdr_dr.title.h1.rdr_dr"/></h1>
    <form method="POST">
        <html:button property="reloadBtn" onclick="return onReload();">
            <bean:message key="rdr_dr.button.reload"/>
        </html:button>
        <br><br>
        <!-- mode change info table -->
        <h2 class="title"><bean:message key="rdr_dr.title.h2.changeMode"/></h2>
        <displayerror:error h1_key="rdr_dr.title.h1.rdr_dr"/> 
        <table border=1>
            <tr>
                <th><bean:message key="rdr_dr.info.th.currentMode"/></th>
                <th><bean:message key="rdr_dr.info.th.action"/></th>
            </tr>
            <tr>
                <logic:equal name="currentMode" value="on">
                    <td nowrap><bean:message key="rdr_dr.currentMode.on"/></td>
                    <td nowrap>
                        <html:button property="changeModeBtn" onclick="return onChangeMode();">
                            <bean:message key="rdr_dr.button.changeToRdr_dr"/>
                        </html:button>
                    </td>
                </logic:equal>
                <logic:equal name="currentMode" value="off">
                    <td nowrap><bean:message key="rdr_dr.currentMode.off"/></td>
                    <td nowrap>
                        <html:button property="changeModeBtn" onclick="return onChangeMode();">
                            <bean:message key="rdr_dr.button.changeToNormal"/>
                        </html:button>
                    </td>
                </logic:equal>
            </tr>
        </table>
    </form>
</body>
</html:html>