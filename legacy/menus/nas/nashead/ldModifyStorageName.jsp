<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldModifyStorageName.jsp,v 1.2 2004/06/04 08:03:38 baiwq Exp" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean,
                 com.nec.sydney.framework.*,
                 com.nec.sydney.beans.nashead.NasHeadModifyStorageNameBean" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean    id="storageModifyBean" 
                class="com.nec.sydney.beans.nashead.NasHeadModifyStorageNameBean"
                scope="page"/>
<jsp:setProperty name="storageModifyBean" property="*" />
<% AbstractJSPBean _abstractJSPBean = storageModifyBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<jsp:include page="../../../menu/common/wait.jsp"/>
<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript">
function checkStorageName(str) {
    var invalidCharector=/[~&'";:!@#$%^*()=`,.<>?\/\s]/g;
    return (str.search(invalidCharector)==-1);
}

function onBack() {
    if (!isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="<%=response.encodeURL("ldlist.jsp")%>";
}

function submitProcess() {
    if (!isSubmitted()){
        return false;
    } 
    if(!checkStorageName(document.storageNameForm.storageName.value)){
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                + "<nsgui:message key="nas_nashead/alert/invalidStorageName"/>");
        document.storageNameForm.storageName.focus();
        return false;
    }
    if (checkLength(document.storageNameForm.storageName.value, 32) == false) {
        var len = "32";
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                + "<nsgui:message key="nas_nashead/alert/overflowStorageName"/>"+"\r\n"
                + <nsgui:message key="exception/common/overMaxLength" firstReplace="len" separate="true"/>);
        document.storageNameForm.storageName.focus();
        return false;
    }
    if(confirm("<nsgui:message key="common/confirm"/>"+ "\r\n"
        + "<nsgui:message key="common/confirm/act"/>"
        + "<nsgui:message key="common/button/submit"/>")){
        document.storageNameForm.operation.value = "set";
        setSubmitted();
        return true;
    }
    return false;
}
</script>

</head>
<body onload="displayAlert();">
<form name="storageNameForm" method="post"  action="../../../menu/common/forward.jsp"
      onsubmit="return submitProcess();">

<h1 class="title"><nsgui:message key="nas_nashead/common/h1_storage"/></h1>

<input type="button" name="back" 
        value="<nsgui:message key="common/button/back"/>" 
        onclick="return onBack();" />

<h2 class="title"><nsgui:message key="nas_nashead/changeStorageName/h2_changeStorage"/></h2>

<input type="hidden" name="operation" value=""/>
<input type="hidden" name="beanClass" value="<%=storageModifyBean.getClass().getName()%>" />
<input type="hidden" name="alertFlag" value="enable" />
<input type="hidden" name="wwnn" value="<%=storageModifyBean.getWwnn()%>" />
<input type="hidden" name="model" value="<%=storageModifyBean.getModel()%>" />

<table border="1">
<tr>
    <th><nsgui:message key="nas_nashead/changeStorageName/th_wwnn"/></th>
    <td>
        <%=storageModifyBean.getWwnn()%>
    </td>
</tr>
<%Boolean isNasHead = (Boolean) session.getAttribute(NSConstant.SESSION_ISNASHEAD);
  if (isNasHead.booleanValue()){%>
<tr>
    <th><nsgui:message key="nas_nashead/changeStorageName/th_model"/></th>
    <td>
        <%=storageModifyBean.getModel()%>
    </td>
</tr>
  <%}%>
<tr>
    <th><nsgui:message key="nas_nashead/changeStorageName/th_storage"/></th>
    <td>
        <input type="text" name="storageName" maxlength="32" size="32"
         value="<%=storageModifyBean.getStorageName()%>"/>
    </td>
</tr>
</table>
<br>

<input type="submit" name="modify" 
        value="<nsgui:message key="common/button/submit"/>" />

</form>
</body>
</html>