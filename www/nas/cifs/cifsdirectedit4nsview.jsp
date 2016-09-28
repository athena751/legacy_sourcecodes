<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsdirectedit4nsview.jsp,v 1.2 2005/08/29 20:00:34 key Exp $" -->


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
            setHelpAnchor('network_cifs_8');
        </logic:equal>

        <logic:equal name="targetFileType" value="dirAccessConf">
            setHelpAnchor('network_cifs_9');
        </logic:equal>
    }   
function onReload(){
	if (isSubmitted()){
	  	return false;
	}
	 setSubmitted();
	<logic:equal name="targetFileType" value="smbConf">
	   window.location="directEdit4nsview.do?operation=displayForSmbConf";
	</logic:equal>

    <logic:equal name="targetFileType" value="dirAccessConf">
      window.location="directEdit4nsview.do?operation=displayForDirAccessConf";
    </logic:equal>
}

</script>
</head>
<body onload="init();" onUnload="closeDetailErrorWin();">
<html:form action="directEdit4nsview.do" method="POST" >
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
    <textarea name="fileContent" wrap="off" rows="21" style='width:100%;'readonly>
<nested:write property="fileContent"/></textarea>

</html:form>
</body>
</html>
