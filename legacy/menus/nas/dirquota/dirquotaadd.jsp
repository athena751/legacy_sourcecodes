<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: dirquotaadd.jsp,v 1.2307 2007/09/12 11:31:28 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.*,
                 com.nec.sydney.framework.*,
                 com.nec.sydney.beans.dirquota.*,
                 com.nec.nsgui.model.biz.base.*,
                 com.nec.sydney.atom.admin.base.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="addBean" class="com.nec.sydney.beans.dirquota.DirquotaAddBean" scope="page"/>

<%AbstractJSPBean _abstractJSPBean = addBean; %>
<%@include file="../../common/includeheader.jsp" %>

<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link rel="stylesheet" href="<%=NSConstant.DefaultCSS %>" type="text/css">

<jsp:include page="../../../menu/common/wait.jsp"/>
<script language="JavaScript">
var chooser;
function onNavigator(){
    if(chooser==null || chooser.closed){
            chooser=window.open("<%=response.encodeURL("dirnavigator.jsp")%>?"
                +"frameNo=0&act=dirquotalist",
                //"ok","");
                "ok","toolbar=no,menubar=no,width=407,height=400");            
        }else{
            chooser.focus();
        }
}

function doAdd (){
    if(!isSubmitted()){
        return false;
    }

    if(document.addForm.dirText.value==""
        || document.addForm.dirText.value=="<nsgui:message key="nas_common/common/msg_select"/>"){
        alert ("<nsgui:message key="nas_dataset/alert/add_dir"/>");
        return false;
    }

    var confirmMsg;
    confirmMsg = "<nsgui:message key="common/confirm"/>"+"\r\n"
                + "<nsgui:message key="common/confirm/act"/>"
                + "<nsgui:message key="nas_dataset/datasettop/datasetadd"/>" ;

    if(!confirm(confirmMsg)){
        return false;
    }
    document.addForm.operation.value="add";
    document.addForm.action = "<%= response.encodeURL("../../../menu/common/forward.jsp") %>";
    setSubmitted();
    document.addForm.submit();    
}
function onBack(){
    if (isSubmitted()){
        window.location="<%= response.encodeURL("dirquotadatasetmain.jsp?nextAction=dirquota&action=selected")%>";
    }
}

function closeNavigator(){
    if(chooser&&!chooser.closed){
        chooser.close();
    }
}

</script>
</head>

<body onload="displayAlert();" onUnload="closeNavigator()">
<form name="addForm" method="post">

<h1 class="title"><nsgui:message key="nas_dataset/datasettop/dirquota"/></h1>
<h2 class="title"><nsgui:message key="nas_dataset/datasettop/datasetadd"/></h2>

<input type="button" name="back" onclick="onBack()" value="<nsgui:message key="common/button/back"/>" />
<br><br>

<%if(!addBean.getAllowAdd()){%>
    <nsgui:message key="nas_dataset/alert/dataset_full"/>
<%}else{%>
<table border="1">
    <tr align="left">
        <th><nsgui:message key="nas_common/mountpoint/th_export"/></th>
        <td><%=session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT)%></td>
    </tr>
    <tr align="left">
        <th><nsgui:message key="nas_common/mountpoint/th_mp"/></th>
        <td><%=session.getAttribute(NasConstants.MP_SESSION_MOUNTPOINT)%></td>
    </tr>
    <tr align="left">
        <th><nsgui:message key="nas_dataset/datasettop/dirquota"/></th>
        <td>
            <input type="text" name="dirText" value="<nsgui:message key="nas_common/common/msg_select"/>"
                onFocus="this.blur();" size="50" readonly />
            <input type="button" name="dirButton" value=" ... "  onClick= "onNavigator()"/>
        </td>
    </tr>
</table>    
<br>
<input type="button" name="add" onclick="doAdd()" value="<nsgui:message key="common/button/submit"/>" />
<% } %>

<input type="hidden" name="dirHex" value=""/>
<input type="hidden" name="operation" value="">
<input type="hidden" name="beanClass" value="<%=addBean.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">
</form>
</body>
</html>