<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifslistbottom.jsp,v 1.10 2005/12/14 06:50:04 fengmh Exp $" -->


<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage,
                com.nec.sydney.framework.NSConstant,
                com.nec.sydney.framework.HTMLUtil" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var popUpWinName;

function onDetail(){
		if(window.parent.topframe.document.shareListForm.shareName){
		 popUpWinName = window.open("/nsadmin/common/commonblank.html","shareDetail",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=700,height=600");
          window.parent.topframe.dispatchShareInfo();
          window.parent.topframe.document.shareListForm.action = "setShare.do?operation=displayDetail";
          window.parent.topframe.document.shareListForm.target = "shareDetail";
          window.parent.topframe.document.shareListForm.submit();
          popUpWinName.focus();
          return true;
        }
        else{
         return false;
        }
}
function onModifyShare(){
    if(window.parent.topframe.document.shareListForm.interfaceWanted){
        if(window.parent.topframe.document.shareListForm.interfaceWanted.value=="true"){
            alert('<bean:message key="cifs.alert.interfaceIsWanted"/>');
            return false;
        }
    }
    if(window.parent.topframe.document.shareListForm.hasAvailableNicForCIFS){
        if(window.parent.topframe.document.shareListForm.hasAvailableNicForCIFS.value=="false"){
            alert('<bean:message key="cifs.alert.availableServiceNIC_null"/>');
            return false;
        }
    }
    if(window.parent.topframe.document.shareListForm.shareName){
        window.parent.topframe.dispatchShareInfo();
        window.parent.topframe.document.shareListForm.action = "loadSetShare.do?shareAction=modify";
        window.parent.topframe.document.shareListForm.target = window.parent.name;
        window.parent.topframe.document.shareListForm.submit();
        disableButtons();
        return true;
    }
    return false;
}

function onSetAccessLog(){
    
    <logic:equal name="hasSetAccessLog" value="true">
        if(window.parent.topframe.document.shareListForm.shareName){
            window.parent.topframe.dispatchShareInfo();
            window.parent.topframe.document.shareListForm.action = "loadAccessLog.do";
            window.parent.topframe.document.shareListForm.target = window.parent.name;
            window.parent.topframe.document.shareListForm.submit();
            disableButtons();
            return true;
        }
    </logic:equal>
    <logic:notEqual name="hasSetAccessLog" value="true">
        alert('<bean:message key="cifs.alert.noSetAccessLog"/>');
        return false;
    </logic:notEqual>
    
    return false;
}

function onSetDirAccess(){
    
    if(window.parent.topframe.document.shareListForm.shareName){
        window.parent.topframe.dispatchShareInfo();
        if(window.parent.topframe.document.shareListForm.fsType.value!="sxfs"){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
               + "<bean:message key="cifs.alert.setDirAccessFor_sxfsfw"/>");
            return false;
        }else{
            disableButtons();
            window.parent.topframe.document.shareListForm.action = "dirAccessControl.do?operation=displayList";
            window.parent.topframe.document.shareListForm.target = window.parent.name;
            window.parent.topframe.document.shareListForm.submit();
            return true;
        }
    }
    return false;
}

function onDeleteShare(){
    if(window.parent.topframe.document.shareListForm.shareName){
        if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.delete" bundle="common"/>"
            )){
            window.parent.topframe.dispatchShareInfo();
            disableButtons();
            window.parent.topframe.document.shareListForm.action = "shareList.do?operation=deleteShare";
            window.parent.topframe.document.shareListForm.target = window.parent.topframe.name;
            window.parent.topframe.document.shareListForm.submit();
            return true;
        }
    }
    return false;
}

function disableButtons(){
    document.shareListBottomForm.button_shareDetail.disabled=1;
    document.shareListBottomForm.button_modifyShare.disabled=1;
    document.shareListBottomForm.button_setAccessLog_share.disabled=1;
    document.shareListBottomForm.button_setDirAccess.disabled=1;
    document.shareListBottomForm.button_deleteShare.disabled=1;
}

function enableButtons(){
    document.shareListBottomForm.button_shareDetail.disabled=0;
    document.shareListBottomForm.button_modifyShare.disabled=0;
    document.shareListBottomForm.button_setAccessLog_share.disabled=0;
    document.shareListBottomForm.button_setDirAccess.disabled=0;
    document.shareListBottomForm.button_deleteShare.disabled=0;
}

function changeButtonStatus(){
    if(window.parent.topframe.document.shareListForm && window.parent.topframe.document.shareListForm.shareName){
        enableButtons();
    }else{
        disableButtons();
    }
}
</script>
</head>
<body onload="changeButtonStatus()" onUnload="closePopupWin(popUpWinName);" style="margin: 10px;">
<form method="POST"  name="shareListBottomForm">
<nobr>

    <input type="button" name="button_shareDetail" onclick="onDetail()"
        value="<bean:message key="cifs.button.shareDetail"/>" />
    	&nbsp;
    <input type="button" name="button_modifyShare" onclick="onModifyShare()"
        value="<bean:message key="common.button.modify2" bundle="common"/>" />
    
    &nbsp;
    <input type="button" name="button_setAccessLog_share" onclick="onSetAccessLog()"
        value="<bean:message key="cifs.button.setAccessLog_share"/>" />
    
    &nbsp;
    <input type="button" name="button_setDirAccess" onclick="onSetDirAccess()"
        value="<bean:message key="cifs.button.setDirAccessControl"/>" />
    
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="button" name="button_deleteShare" onclick="onDeleteShare()"
        value="<bean:message key="common.button.delete" bundle="common"/>" />
</nobr>
</form>
</body>
</html>