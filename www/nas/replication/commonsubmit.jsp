<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: commonsubmit.jsp,v 1.2 2007/05/09 04:54:44 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<script language="JavaScript">
function init() {
    <bean:parameter id="isDisabled" name="disableFlag" value="false"/>
    document.forms[0].submitBtn.disabled = <bean:write name="isDisabled"/>;
}
</script>
</head>
<body onload="init();parent.bottomframe.displayAlert();">
<form>
    <html:button property="submitBtn" onclick="return parent.bottomframe.onSet();">
        <bean:message key="common.button.submit" bundle="common"/>
    </html:button>
</form>
</body>
</html:html>