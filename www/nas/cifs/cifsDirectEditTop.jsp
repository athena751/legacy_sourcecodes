<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsDirectEditTop.jsp,v 1.2 2005/09/08 00:39:10 key Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
    function init(){
        <logic:equal name="targetFileType" value="smbConf">
            <logic:notEqual name="notNeedWarning" value="true">
                alert('<bean:message key="cifs.alert.direct_edit.warning"/>');
            </logic:notEqual>
            <logic:equal name="notNeedWarning" value="true">
                 <%session.setAttribute("notNeedWarning",null );%>
            </logic:equal>
            setHelpAnchor('network_cifs_8');
        </logic:equal>

        <logic:equal name="targetFileType" value="dirAccessConf">
            <logic:notEqual name="notNeedWarning" value="true">
                alert('<bean:message key="cifs.alert.directEditForDirAccessConf.warning"/>');
            </logic:notEqual>
            <logic:equal name="notNeedWarning" value="true">
                 <%session.setAttribute("notNeedWarning",null );%>
            </logic:equal>
            setHelpAnchor('network_cifs_9');
        </logic:equal>
        enableBottomButton();

    }
    
	function enableBottomButton(){
		if(window.parent.frames[1] && window.parent.frames[1].document.directEditBottomForm){
		  window.parent.frames[1].document.directEditBottomForm.button_submit.disabled=0;
		  window.parent.frames[1].document.directEditBottomForm.button_reset.disabled=0;
		}
	}
    function onBack(){
        if (isSubmitted()){
            return false;
        }
       setSubmitted();
        window.location="shareList.do?operation=enterCIFS";
    }
    function onSave(){
        if (isSubmitted()){
            return false;
        }
        if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.submit" bundle="common"/>')){
            return false;
        }
        document.forms[0].target = window.parent.name;
        setSubmitted();
        document.forms[0].submit();
        return true;
    }
    function onReload(){
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    <logic:equal name="targetFileType" value="smbConf">
    	window.parent.location="directEdit.do?operation=displayForSmbConf";
     </logic:equal>
    <logic:equal name="targetFileType" value="dirAccessConf">
    	window.parent.location="directEdit.do?operation=displayForDirAccessConf";
     </logic:equal>
    
    return true; 
}

</script>
</head>
<body onload="displayAlert();init();" onUnload="closeDetailErrorWin();">
<html:form action="directEdit.do" method="POST" onsubmit="return onSave()">
<html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<br>
<br>
<logic:equal name="targetFileType" value="smbConf">
    <input type="hidden" name="operation" value="saveForSmbConf">
</logic:equal>

<logic:equal name="targetFileType" value="dirAccessConf">
    <input type="hidden" name="operation" value="saveForDirAccessConf">
</logic:equal>
<displayerror:error h1_key="cifs.common.h1"/>
<logic:equal name="targetFileType" value="dirAccessConf">
    <table><tr><td style='width:100%;'><bean:message key="cifs.direct_edit_dir_access.adviceMSG"/></td></tr></table><br><br>
</logic:equal>
    <textarea name="fileContent" wrap="off" rows="21" style='width:100%;'>
<nested:write property="fileContent"/></textarea>

</html:form>
</body>
</html>
