<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldlisttop4nsview.jsp,v 1.2 2005/10/24 07:00:45 liuyq Exp" -->
<%@ page contentType="text/html;charset=EUC-JP" buffer="32kb"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.nashead.*
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*
                 ,java.util.*
                 ,java.lang.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="bean" class="com.nec.sydney.beans.nashead.NasHeadListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="javaScript">
function setOperation(form, op){
    form.operation.value = op;
}

function selectStorage(obj){
    var tmpInfo = new Array();
    tmpInfo = obj.value.split(",");
    document.storageInfo.wwnn.value=tmpInfo[0];
    document.storageInfo.storageName.value=tmpInfo[1];
    document.storageInfo.model.value=tmpInfo[2];
}

function setNeedScan(){
    document.storageInfo.needScan.value="yes";
}

function getLunList(){
    if(!isSubmitted()){
        return false;
    }
    if(document.storageInfo.wwnn.value == ""){
        return false;
    }
    
    document.storageInfo.target="bottomframe";
    document.storageInfo.action="ldlistmid4nsview.jsp";
    setOperation(document.storageInfo,'getLunList');
    document.storageInfo.submit();
    return true;
}

function reloadPage(){
    if( !isSubmitted() ){
        return false;
    }
    setSubmitted();
    parent.location="ldlist4nsview.jsp";         
}    
</script>
<jsp:include page="../../common/wait.jsp" />
</head>

<body onload="displayAlert();getLunList();">
<h1 class="title"><nsgui:message key="nas_nashead/common/h1_storage"/></h1>
<form name="storageInfo" method="post" action="../../../menu/common/forward.jsp">
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
<h2 class="title"><nsgui:message key="nas_nashead/common/h2_storage"/></h2>
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="operation" value="">
<input type="hidden" name="beanClass" value="<%=bean.getClass().getName()%>">

<input type="hidden" name="wwnn" value="<%=bean.getCheckedWwnn()%>">
<input type="hidden" name="storageName" value="">
<input type="hidden" name="model" value="<%=bean.getCheckedModel()%>">
<input type="hidden" name="needScan" value="no">

<%
if (!bean.getGetddmapSuccess()){%>
    <br><nsgui:message key="nas_nashead/storage/getddmapfaild"/>
<%}else{%>
    <%Vector StorageList = bean.getStorageList();
    int storageNum = StorageList.size();
    if (0 == storageNum){%>
        <br><nsgui:message key="nas_nashead/storage/nostorage"/>
    <%}else{
        StorageInfo storage= new StorageInfo();
        Boolean isNasHead = (Boolean) session.getAttribute(NSConstant.SESSION_ISNASHEAD);%>
        <table border="1">
        <tr>
            <th>&nbsp;</th>
            <th><nsgui:message key="nas_nashead/storage/storagename"/></th>
            <th><nsgui:message key="nas_nashead/storage/wwnn"/></th>
            <%if (isNasHead.booleanValue()){%>
            	<th><nsgui:message key="nas_nashead/storage/model"/></th>
            <%}%>
        </tr>
        <%for (int j=0;j<storageNum;j++){
        storage = (StorageInfo)StorageList.get(j);
        String storagename=storage.getStorageName();
        if(storagename.equals("")){
            storagename=storage.getWwnn();
        }
        String checked = "";
        if(storage.getWwnn().equals(bean.getCheckedWwnn())){
            checked = "checked";
        }
        %>
        <tr>
            <td align="center"><input type="radio" name="storageRadio" <%=checked%> id="storageID<%=j%>" value="<%=storage.getWwnn()%>,<%=storagename%>,<%=storage.getModel()%>" onClick="selectStorage(this);"></td>
            <td align="center"><label for="storageID<%=j%>"><%=storagename%></label></td>
            <td align="center"><label for="storageID<%=j%>"><%=storage.getWwnn()%></label></td>
            <%if (isNasHead.booleanValue()){%>
            	<td align="center"><%=storage.getModel()%></td>
            <%}%>
        </tr>
        <%}%>
        </table>
        <br>
        <input type="button" name="lunList" value="<nsgui:message key="nas_nashead/common/getluninfo_button"/>" onclick="setNeedScan();getLunList()"> &nbsp;&nbsp;&nbsp;
    <%}
}
%>
</form>
</body>
</html>
