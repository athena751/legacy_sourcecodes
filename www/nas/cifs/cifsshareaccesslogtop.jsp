<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsshareaccesslogtop.jsp,v 1.4 2005/09/08 00:36:38 key Exp $" -->

<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
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
var elements;
function enableBottomButton(){
	if(window.parent.frames[1] && window.parent.frames[1].document.forms[0]&& window.parent.frames[1].document.forms[0].button_submit){
	  window.parent.frames[1].document.forms[0].button_submit.disabled=0;
	}
}
function init(){
    elements = document.forms[0].elements;
    changeAlogEnable();
    
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="enterCifs.do";
}

function changeAlogEnable(){
    if (elements["info.alogEnable"].checked){
        elements["logType"][0].disabled = false;
        elements["logType"][1].disabled = false;
        changeLogType();
    }else{
        disableAll();
    }
}

function changeLogType(){
    var disableAllItem    = !elements["logType"][0].checked;
    var disableCustomItem = !elements["logType"][1].checked;
    changeStatus(disableAllItem, disableCustomItem);
}

function disableAll(){
    elements["logType"][0].disabled = true;
    elements["logType"][1].disabled = true;
    changeStatus(true, true);
}

function changeStatus(disableAllItem,disableCustomItem){
    var successItems         = elements["info.successLoggingItems"];
    var errorItems           = elements["info.errorLoggingItems"]; 
    successItems[0].disabled = disableAllItem;
    errorItems[0].disabled   = disableAllItem;
    for(var i = 1; i < successItems.length; i++){
        successItems[i].disabled = disableCustomItem;
        errorItems[i].disabled   = disableCustomItem;
    }
}

function onSet(){
    if(isSubmitted()){
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
	document.forms[0].target=window.parent.name;
	setSubmitted();
	document.forms[0].submit();

}

function onReload(){
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    document.forms[0].target=window.parent.name;
    document.forms[0].action="loadAccessLog.do";
    document.forms[0].submit();
}

</script>
</head>
<body onload="init();displayAlert();enableBottomButton();setHelpAnchor('network_cifs_5');" onUnload="closeDetailErrorWin();">
<html:form action="setAccessLog.do?operation=set">
<nested:define id="shareName" property="shareName" type="java.lang.String"/>
<nested:nest property="info">
<html:button property="goBack" onclick="return onBack()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
	&nbsp;
<html:button property="reload" onclick="onReload()">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<h3 class="title"><bean:message key="cifs.shareAccessLog.h2"/></h3>

<displayerror:error h1_key="cifs.common.h1"/>
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="cifs.shareOption.th_sharename"/></th>
    <td>
        <%=NSActionUtil.sanitize(shareName)%>
        <html:hidden property="shareName"/>
    </td>
  </tr>
  <tr>
    <th><bean:message key="cifs.shareAccessLog.th_logging"/></th>
    <td><nested:checkbox property="alogEnable" value="yes" styleId="alogEnable_chbox" onclick="changeAlogEnable()"/>
        <label for="alogEnable_chbox">
            <bean:message key="cifs.shareAccessLog.td_samplinglog"/>
        </label>
    </td>
  </tr>
  <tr>
    <th><bean:message key="cifs.shareAccessLog.th_loggingitems"/></th>
    <td>
        <html:radio property="logType" value="all" styleId="log_all" onclick="changeLogType()"/>
        <label for="log_all">
            <bean:message key="cifs.shareAccessLog.specifyall"/>
        </label>
        <br>
        <table border="0">
            <tr>
                <td align="center"><bean:message key="cifs.common.success"/></td>
                <td align="center"><bean:message key="cifs.common.error"/></td>
                <td></td>
            </tr>
            <tr>
                <td align="center">
                <nested:multibox property="successLoggingItems">
                    COLLECTALL
                </nested:multibox>
                </td>
                <td align="center">
                <nested:multibox property="errorLoggingItems">
                    COLLECTALL
                </nested:multibox>
                </td>
                <td><bean:message key="cifs.shareAccessLog.allsmbcmd"/></td>
            </tr>
        </table>
        <p></p>

        <html:radio property="logType" value="custom" styleId="log_custom" onclick="changeLogType()"/>
        <label for="log_custom">
            <bean:message key="cifs.shareAccessLog.specifycustom"/>
        </label>
        <br>
        <table border="0">
            <tr>
                <td align="center"><bean:message key="cifs.common.success"/></td>
                <td align="center"><bean:message key="cifs.common.error"/></td>
                <td></td>
            </tr>
                <logic:iterate name="shareLoggingItems" id="item">
                    <tr>
                    <td align="center">
                    <nested:multibox property="successLoggingItems">
                        <bean:write name="item" property="key"/>
                    </nested:multibox>
                    </td>
                    <td align="center">
                    <nested:multibox property="errorLoggingItems">
                        <bean:write name="item" property="key"/>
                    </nested:multibox>
                    </td>
                    <td><bean:message name="item" property="value"/></td>
                    </tr>
                </logic:iterate>
        </table>
    </td>
  </tr>
</table>
</nested:nest>
</html:form>
</body>
</html>