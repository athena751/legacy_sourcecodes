<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsDirAccessListTop4nsview.jsp,v 1.2 2005/09/08 00:35:21 key Exp $" -->


<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage,
                java.util.ArrayList,
                com.nec.nsgui.action.cifs.CifsActionConst,
                com.nec.nsgui.taglib.nssorttab.ListSTModel" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">

function init(){
    displayAlert();
    setHelpAnchor('network_cifs_10');
  
}



function onReload(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="dirAccessControl4nsview.do?operation=displayList";
}
function onClose(){
    window.close();
}

</script>
</head>
<body onload="init();" onUnload="setHelpAnchor('network_cifs_1');">

<displayerror:error h1_key="cifs.common.h1"/>

<html:form action="dirAccessControl4nsview.do" >
<html:hidden property="operationType"/>
<h1 class="popup"><bean:message key="cifs.common.h1"/></h1>
<logic:equal name="shareExsit" value="yes" scope="request">
<html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
 </html:button>
</logic:equal>
<h3 class="popup"><bean:message key="cifs.dirAccess_list.settingTitle_4nsview"/></h3>
<logic:notEqual name="shareExsit" value="yes" scope="request">
	<table><tr><td style='width:100%;'> <bean:message key="cifs.common.shareNotExist"/></td></tr></table>
</logic:notEqual>
<logic:equal name="shareExsit" value="yes" scope="request">
<bean:define id="shareName" name="shareNameForDisplay" type="java.lang.String"/>
<bean:define id="sharedDirectory" name="<%=CifsActionConst.SESSION_SHARED_DIRECTORY%>" type="java.lang.String"/>
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="cifs.shareOption.th_sharename"/></th>
    <td><%=NSActionUtil.sanitize(shareName)%></td>
  </tr>
  <tr>
    <th><bean:message key="cifs.th.directory"/></th>
    <td><%=NSActionUtil.sanitize(sharedDirectory)%></td>
  </tr>
</table>

<p class="domain"><bean:message key="cifs.dirAccess_list.listTitle"/></p>

<logic:notEmpty name="dirAccessInfoList" scope="request">
    <bean:define id="dirAccessInfoList" name="dirAccessInfoList" type="java.util.ArrayList"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)dirAccessInfoList)%>" id="cifs_shareList"
            table="border=\"1\"" sortonload="directory_td">
        
        <nssorttab:column name="directory_td" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.dirAccess.th_directory"/>
        </nssorttab:column>
        <nssorttab:column name="allowHost" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.shareOption.th_hostsallow"/>
        </nssorttab:column>
        <nssorttab:column name="denyHost" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.shareOption.th_hostsdeny"/>
        </nssorttab:column>
    </nssorttab:table>
    <input type="hidden" name="directory" value="" >
    <input type="hidden" name="allowHost" value="" >
    <input type="hidden" name="denyHost" value="" >
</logic:notEmpty>

<logic:empty name="dirAccessInfoList" scope="request">
    <bean:message key="cifs.message.noDirAccessControlList"/>
</logic:empty>

</logic:equal>

</html:form>
</body>
</html>