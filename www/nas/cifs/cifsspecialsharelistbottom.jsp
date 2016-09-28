<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsspecialsharelistbottom.jsp,v 1.1 2007/03/23 08:01:09 chenbc Exp $" -->

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
    if(window.parent.topframe.document && window.parent.topframe.document.shareListForm && window.parent.topframe.document.shareListForm.shareName){
	    popUpWinName = window.open("/nsadmin/common/commonblank.html","shareDetail",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=700,height=600");
        window.parent.topframe.dispatchShareInfo();
        window.parent.topframe.document.shareListForm.action = "setSpecialShare.do?operation=displayDetail";
        window.parent.topframe.document.shareListForm.target = "shareDetail";
        window.parent.topframe.document.shareListForm.submit();
        popUpWinName.focus();
        return true;
    }else{
        return false;
    }
}
function onModifyShare(){
    if(window.parent.topframe.document && window.parent.topframe.document.shareListForm) {
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
            window.parent.topframe.document.shareListForm.action = "loadSetSpecialShare.do?shareAction=modify";
            window.parent.topframe.document.shareListForm.target = window.parent.name;
            window.parent.topframe.document.shareListForm.submit();
            disableButtons();
            return true;
        }
    }
    return false;
}

function onDeleteShare(){
    if(window.parent.topframe.document && window.parent.topframe.document.shareListForm && window.parent.topframe.document.shareListForm.shareName){
        if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.delete" bundle="common"/>"
            )){
            window.parent.topframe.dispatchShareInfo();
            disableButtons();
            window.parent.topframe.document.shareListForm.action = "specialShareList.do?operation=deleteShare";
            window.parent.topframe.document.shareListForm.target = window.parent.topframe.name;
            window.parent.topframe.document.shareListForm.submit();
            return true;
        }
    }
    return false;
}

function disableButtons(){
    if(document.shareListBottomForm){
        if(document.shareListBottomForm.button_shareDetail){
            document.shareListBottomForm.button_shareDetail.disabled=1;
        }
        if(document.shareListBottomForm.button_modifyShare){
            document.shareListBottomForm.button_modifyShare.disabled=1;
        }
        if(document.shareListBottomForm.button_deleteShare){
            document.shareListBottomForm.button_deleteShare.disabled=1;
        }
    }
}

function enableButtons(){
    if(document.shareListBottomForm){
        if(document.shareListBottomForm.button_shareDetail){
            document.shareListBottomForm.button_shareDetail.disabled=0;
        }
        if(document.shareListBottomForm.button_modifyShare){
            document.shareListBottomForm.button_modifyShare.disabled=0;
        }
        if(document.shareListBottomForm.button_deleteShare){
            document.shareListBottomForm.button_deleteShare.disabled=0;
        }
    }
}

function changeButtonStatus(){
    if(window.parent.topframe.document && window.parent.topframe.document.shareListForm && window.parent.topframe.document.shareListForm.shareName){
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
    <logic:equal name="<%=NSActionConst.SESSION_USERINFO %>"
	    value="<%=NSActionConst.NSUSER_NSADMIN %>" scope="session">
      <input type="button" name="button_modifyShare" onclick="onModifyShare()"
          value="<bean:message key="common.button.modify2" bundle="common"/>" />
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="button" name="button_deleteShare" onclick="onDeleteShare()"
          value="<bean:message key="common.button.delete" bundle="common"/>" />
    </logic:equal>
</nobr>
</form>
</body>
</html>