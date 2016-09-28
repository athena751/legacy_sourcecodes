<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicalistbottom.jsp,v 1.7 2008/05/28 05:07:25 liy Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function init(){
	<logic:equal name="asyncVol" value="true" scope="session">
	    disableAllBtn();
	</logic:equal> 
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        disableAllBtn();
    </logic:equal>  
    var replicaRadio;
    if ((parent.bottomframe.document.forms[0])
         && (parent.bottomframe.document.forms[0].elements["replicaRadio"] != null)) {
    
        replicaRadio = parent.bottomframe.document.forms[0].elements["replicaRadio"];
        if (!(replicaRadio.length)) {
            replicaRadio.click();
        } else {
            var hasChecked = false;
            for (var i = 0; i <replicaRadio.length; i++) {
                if (replicaRadio[i].checked) {
                    replicaRadio[i].click();
                    hasChecked = true;
                }
            }
            
            if (!hasChecked) {
                replicaRadio[0].click();
            }
        }
    } else {
        // if no replica, disable all button and checkbox
        disableAllBtn();
    }
}

function disableAllBtn() {
    document.forms[0].modifyBtn.disabled       = true;
    document.forms[0].promoteBtn.disabled      = true;
    document.forms[0].ctrlInNodeBtn.disabled   = true;
    document.forms[0].volSyncBtn.disabled      = true;
    document.forms[0].delBtn.disabled          = true;
    document.forms[0].delVolumeChkbox.disabled = true;
}

</script>
</head>
<body onload="init();parent.bottomframe.displayAlert();">

<form>
    <html:button property="modifyBtn" onclick="return parent.bottomframe.onModify();">
        <bean:message key="common.button.modify2" bundle="common"/>
    </html:button>&nbsp;
    <html:button property="promoteBtn" onclick="return parent.bottomframe.onPromote();">
        <bean:message key="replica.button.promote2"/>
    </html:button>&nbsp;
    <html:button property="ctrlInNodeBtn" onclick="return parent.bottomframe.onCtrlInNode();">
        <bean:message key="replica.button.ctrlInNode2"/>
    </html:button>&nbsp;
    <html:button property="volSyncBtn" onclick="return parent.bottomframe.onVolSync();">
        <bean:message key="replica.button.volSync2"/>
    </html:button>&nbsp;&nbsp;&nbsp;&nbsp;
    <html:button property="delBtn" onclick="return parent.bottomframe.onDelete();">
        <bean:message key="common.button.delete" bundle="common"/>
    </html:button>&nbsp;
    <input type="checkbox" id="delVolume" name="delVolumeChkbox" value="off"/>&nbsp;
    <label for="delVolume"><bean:message key="replica.info.delVolume"/></lable>
</form>
</body>
</html:html>