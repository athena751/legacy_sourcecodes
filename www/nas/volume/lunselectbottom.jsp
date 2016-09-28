<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: lunselectbottom.jsp,v 1.2 2007/05/09 05:10:54 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript">
var loaded = 0;
function init() {
    loaded = 1;
    <logic:empty name="lunInfoTable" scope="session">
        document.forms[0].selectBtn.disabled = true;
    </logic:empty>
    <logic:notEmpty name="lunInfoTable" scope="session">
        parent.topframe.changeButtonStatus();    
    </logic:notEmpty>
}
</script>
</head>
<body onload="init();">
<form>
    <html:button property="selectBtn" onclick="return parent.topframe.onSelect();">
        <bean:message key="common.button.select" bundle="common"/>
    </html:button>
    <html:button property="closeBtn" onclick="parent.close();">
        <bean:message key="common.button.close" bundle="common"/>
    </html:button>
</form>
</body>
</html:html>