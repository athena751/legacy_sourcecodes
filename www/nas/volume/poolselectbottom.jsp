<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: poolselectbottom.jsp,v 1.3 2007/05/09 05:12:59 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var loaded = 0;
function init() {
    loaded = 1;
    if(parent.middleframe 
       && parent.middleframe.loaded == 1) {

    <logic:empty name="poolList" scope="request">
        parent.bottomframe.document.forms[0].selectBtn.disabled = true;
    </logic:empty> 

    <logic:notEmpty name="poolList" scope="request">
        parent.middleframe.changeButtonStatus();    
    </logic:notEmpty>       
    }
}
</script>
</head>
<body onload="init();">
<form>
    
    <html:button property="selectBtn" onclick="return parent.middleframe.onSelectPool();" disabled="true">
        <bean:message key="common.button.select" bundle="common"/>
    </html:button>
    <html:button property="closeBtn" onclick="parent.close();">
        <bean:message key="common.button.close" bundle="common"/>
    </html:button>
</form>
</body>
</html:html>