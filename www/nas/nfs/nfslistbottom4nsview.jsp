<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfslistbottom4nsview.jsp,v 1.2 2007/05/09 06:08:46 caows Exp $" -->

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
    }   
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
        win.close();
    }
}
</script>
</head> 
<body onload="init()" onUnload="closePopupWin(detailWin);">
<form method="post">
<html:button property="detail" disabled="true" onclick="return onDetail();"><bean:message key="common.button.detail2" bundle="common"/></html:button>
</form>
</body>
</html:html>