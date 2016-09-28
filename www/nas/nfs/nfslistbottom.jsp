<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfslistbottom.jsp,v 1.11 2008/09/25 01:51:19 penghe Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html:html lang="true">
<head>
<title><bean:message key="title"/></title>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="javascript">
var loaded = 0;
var detailWin;
function init() {
    loaded = 1;
    if(parent.frames[0].loaded && parent.frames[0].document.forms[0].isNormal) {
        document.forms[0].detail.disabled=0;
        document.forms[0].modify.disabled=0;
        document.forms[0].deleteEntry.disabled=0;
    }   
}

function onModify() {
    if(!parent.frames[0].loaded){
        return false;
    }
    if(parent.frames[0].document.forms[0].isNormal.value == "false") {
        alert("<bean:message key='list.abnormal'/>");
        return false;
    }
    disableButtons();
    parent.frames[0].document.forms[0].action="../../nfs/nfsDetail.do?opType=modify";
    parent.frames[0].document.forms[0].target = "_parent";
    parent.frames[0].document.forms[0].submit();
    return true;
}

function disableButtons(){
    document.forms[0].detail.disabled=1;
    document.forms[0].modify.disabled=1;
    document.forms[0].deleteEntry.disabled=1;    
}

function onDelete() {
    if(!parent.frames[0].loaded){
        return false;
    }
    if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="common.button.delete" bundle="common"/>"  + "\r\n"
            + "<bean:message key="table.directory"/>:" 
            + parent.frames[0].document.forms[0].selectedDir.value)){    
        disableButtons();
        closePopupWin(detailWin);
        parent.frames[0].document.forms[0].target = "_self";
        parent.frames[0].document.forms[0].action="../../nfs/nfsListTop.do?operation=delete";  
        parent.frames[0].document.forms[0].submit();
        return true; 
    }
    return false;
}

function onDetail() {
    if(!parent.frames[0].loaded){
        return false;
    }

    if(detailWin == null || detailWin.closed){
        if(navigator.appName.indexOf("Microsoft") != -1){
            hori = top.document.body.clientWidth - 10;
            verti = top.document.body.clientHeight - 10;
        }else{
            hori = top.innerWidth - 10;
            verti = top.innerHeight -10;
        }
        detailWin = window.open("/nsadmin/common/commonblank.html","nfs_detail_navigator", 'width='+ hori + ',height='+ verti + ',left=1,top=1,fullscreen=0,scrollbars=1,resizable=1,status=1,menubar=0,toolbar=0,addressbar=0');
    }else{
        detailWin.focus();
    }
    parent.frames[0].document.forms[0].target="nfs_detail_navigator";
    parent.frames[0].document.forms[0].action="../../nfs/nfsDetailInfo.do";
    parent.frames[0].document.forms[0].submit();
    return true;
}

function closePopupWin(win){
    if (win != null && !win.closed){
        if(win.window.frames[0].document.body.onunload){
            win.window.frames[0].document.body.onunload="";
        }else{
            win.window.frames[0].onunload="";
        }
        win.close();
    }
}
</script>
</head> 
<body onload="init()" onUnload="closePopupWin(detailWin);">
<form method="post">
<html:button property="detail" disabled="true" onclick="return onDetail();"><bean:message key="common.button.detail2" bundle="common"/></html:button>
<html:button property="modify" disabled="true" onclick="return onModify();"><bean:message key="common.button.modify2" bundle="common"/></html:button>
&nbsp;&nbsp;&nbsp;&nbsp;<html:button property="deleteEntry" disabled="true" onclick="return onDelete();"><bean:message key="common.button.delete" bundle="common"/></html:button>
</form>
</body>
</html:html>