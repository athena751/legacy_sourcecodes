<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: datasetbottom.jsp,v 1.2305 2006/02/20 00:35:05 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%boolean isNsview = NSActionUtil.isNsview(request);%>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<jsp:include page="../../common/wait.jsp" />
<script src="../common/general.js">
</script>

<script>
function checkButton(){
    document.forms[0].dirquota.disabled = true;
    if (parent.frames[1].document.forms[0]
        && parent.frames[1].document.forms[0].radiobutton){
        document.forms[0].dirquota.disabled = false;
        parent.frames[0].document.forms[0].datasetlist.disabled = false;
        <%if(!isNsview){%>
            parent.frames[0].document.forms[0].datasetadd.disabled = false;
            parent.frames[0].document.forms[0].datasetdel.disabled = false;
        <%}%>
        if (parent.frames[1].document.forms[0].radiobutton.length){
            document.forms[0].dataset.value = parent.frames[1].document.forms[0].radiobutton[0].value;
        } else{
            document.forms[0].dataset.value = parent.frames[1].document.forms[0].radiobutton.value;
        }
    } else if (parent.frames[1].document.forms[0]){
    <%if(!isNsview){%>
        parent.frames[0].document.forms[0].datasetadd.disabled = false;
    <%}%>
    }
    
}

function onDirQuota(){
    if (document.forms[0].dirquota.disabled==true){
        return false;
    }
    if (isSubmitted()){
        document.forms[0].action = "dirquotaset.jsp";
        document.forms[0].target = "_parent";
        setSubmitted();
        document.forms[0].submit();
        return true;
    }
    return false;   
}
</script>
</head>

<body onload="checkButton()">
<form method="post">
    <input type="button" name="dirquota" onClick="onDirQuota()" 
    <%if(isNsview){%>
        value="<nsgui:message key="nas_dataset/datasetbottom/dirquota4Nsview"/>">
    <%}else{%>
        value="<nsgui:message key="nas_dataset/datasetbottom/dirquota"/>">
    <%}%>
    <input type="hidden" name="dataset" value="">
</form>
</body>
</html>
