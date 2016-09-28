<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ddrpairlistbtn.jsp,v 1.3 2008/04/30 10:18:38 pizb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<script language="JavaScript">
function init(){
	// judge whether there is any pair.
    if ((parent.bottomframe.document.forms[0])
         && (parent.bottomframe.document.forms[0].elements["pairRadio"] != null)) {
    
        var pairRadio = parent.bottomframe.document.forms[0].elements["pairRadio"];
        // if there is only one mv.
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
<body onload="init();parent.bottomframe.displayAlert();">

<form>
<html:button property="moreInfoBtn"
	onclick="return parent.bottomframe.displayDetail();">
	<bean:message key="common.button.detail2" bundle="common" />
</html:button>&nbsp;
<html:button property="extendPairBtn"
	onclick="parent.bottomframe.onExtendDdrPair();">
	<bean:message key="pair.button.extendPair2" />
</html:button>&nbsp;
<html:button property="modifyPairBtn"
	onclick="return parent.bottomframe.onModifyDdrPair();">
	<bean:message key="pair.button.modifyPair2" />
</html:button>&nbsp;&nbsp;&nbsp;&nbsp;
<html:button property="unpairBtn"
	onclick="return parent.bottomframe.onDelete();">
	<bean:message key="common.button.delete" bundle="common" />
</html:button>
</form>
</body>
</html:html>
