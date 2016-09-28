<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsDirAccessListTop.jsp,v 1.5 2008/06/04 01:28:11 chenbc Exp $" -->


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
<script language="JavaScript" src="../nas/cifs/cifscommon.js"></script>
<script language="JavaScript">
function onAddDirAccessControl(){
    if (isSubmitted()){
        return false;
    }
    document.forms[0].operationType.value="add";
    setSubmitted();
    document.forms[0].action = "loadSetAccess.do";
    document.forms[0].target = window.parent.name;
    document.forms[0].submit();
}

function init(){
    displayAlert();
    setHelpAnchor('network_cifs_10');
    <logic:notEmpty name="dirAccessInfoList" scope="request">
        disableBottomButton(false);
    </logic:notEmpty>
    <logic:empty name="dirAccessInfoList" scope="request">
        disableBottomButton(true);
    </logic:empty>
}


function disableBottomButton(statusValue){
    if(window.parent.dirAccess_bottomframe.document.forms[0] && window.parent.dirAccess_bottomframe.document.forms[0].button_modify){
        window.parent.dirAccess_bottomframe.document.forms[0].button_modify.disabled=statusValue;
    }
    if(window.parent.dirAccess_bottomframe.document.forms[0] && window.parent.dirAccess_bottomframe.document.forms[0].button_delete){
        window.parent.dirAccess_bottomframe.document.forms[0].button_delete.disabled=statusValue;
    }
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="enterCifs.do";
}

function dispatchDirAccessControlInfo(){
    <logic:notEmpty name="dirAccessInfoList" scope="request">
        var checkedInfo = getCheckedRadioValue(document.forms[0].dirAccessInfo);
        var firstSeparatorIndex = checkedInfo.indexOf(",");
        var secondSeparatorIndex = checkedInfo.indexOf(",", firstSeparatorIndex+1);
        document.forms[0].allowHost.value=checkedInfo.substring(0, firstSeparatorIndex);
        document.forms[0].denyHost.value=checkedInfo.substring(firstSeparatorIndex+1, secondSeparatorIndex);
        document.forms[0].directory.value=checkedInfo.substring(secondSeparatorIndex+1);
    </logic:notEmpty>
}

function onModifyDirAccessControl(){
    if (isSubmitted()){
        return false;
    }
    dispatchDirAccessControlInfo();
    var str = document.forms[0].directory.value;
    if(!checkPath4Win(str) || !checkNFDLength(str, 200)){
        alert('<bean:message key="cifs.alert.cannotModifyDirAccessControl"/>');
        return false;
    }
    document.forms[0].operationType.value="modify";
    setSubmitted();
    disableBottomButton(true);
    document.forms[0].action = "loadSetAccess.do";
    document.forms[0].target = window.parent.name;
    document.forms[0].submit();
    return true;
}

function onDeleteDirAccessControl(){
    if (isSubmitted()){
        return false;
    }
    if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
        + "<bean:message key="common.confirm.action" bundle="common" />" 
        + "<bean:message key="common.button.delete" bundle="common"/>"
        )){
        dispatchDirAccessControlInfo();
        setSubmitted();
        disableBottomButton(true);
        document.forms[0].action = "dirAccessControl.do?operation=deleteDirAccessControl";
        document.forms[0].submit();
        return true;
    }
    return false;
}
function onReload(){
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    document.forms[0].target=window.parent.name;
    document.forms[0].action="dirAccessControl.do?operation=displayList";
    document.forms[0].submit();
}

</script>
</head>
<body onload="init();" onUnload="closeDetailErrorWin();">

<displayerror:error h1_key="cifs.common.h1"/>

<html:form action="dirAccessControl.do" >
<html:hidden property="operationType"/>
<html:button property="goBack" onclick="return onBack()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
		&nbsp;
<html:button property="reload" onclick="onReload()">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<h3 class="title"><bean:message key="cifs.dirAccess_list.settingTitle"/></h3>
<table>
<tr>
<td style='width:100%;'><bean:message key="cifs.dirAccessControl.dirAccessControlAvailable"/></td>
</tr>
</table>
<br>
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
</table><br>

<p class="domain"><bean:message key="cifs.dirAccess_list.listTitle"/></p>

<html:button property="addDirAccessControl" onclick="onAddDirAccessControl()">
    <bean:message key="common.button.add2" bundle="common"/>
</html:button>
    <br><br>
<logic:notEmpty name="dirAccessInfoList" scope="request">
    <bean:define id="dirAccessInfoList" name="dirAccessInfoList" type="java.util.ArrayList"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)dirAccessInfoList)%>" id="cifs_shareList"
            table="border=\"1\"" sortonload="directory_td">
        <nssorttab:column name="dirAccessInfo" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCommonRadioRender"
                                            sortable="no">
        </nssorttab:column>
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
</html:form>
</body>
</html>