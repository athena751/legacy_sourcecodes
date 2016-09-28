<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ddrpairlist4nsviewbtn.jsp,v 1.1 2008/04/19 10:11:18 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<script language="JavaScript">
function init(){
    var pairRadio;
    if ((parent.bottomframe.document.forms[0])
         && (parent.bottomframe.document.forms[0].elements["pairRadio"] != null)) {
    
        pairRadio = parent.bottomframe.document.forms[0].elements["pairRadio"];
        if (!(pairRadio.length)) {
            pairRadio.click();
        } else {
            var hasChecked = false;
            for (var i = 0; i <pairRadio.length; i++) {
                if (pairRadio[i].checked) {
                    pairRadio[i].click();
                    hasChecked = true;
                }
            }
            
            if (!hasChecked) {
                pairRadio[0].click();
            }
        }
    } else {
        // if no ddr pair, disable all button.
        parent.bottomframe.disableInputElement(document,"button");
    }
}
</script>
</head>
<body onload="init();">

<form>
	<html:button property="moreInfoBtn"
		onclick="return parent.bottomframe.displayDetail();">
		<bean:message key="common.button.detail2" bundle="common" />
	</html:button>&nbsp; 
</form>
</body>
</html:html>